import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/l10n/locale_config.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/core/utils/account_dialogs.dart';
import 'package:krishidnya/features/auth/domain/entities/user.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/domain/entities/feature_models.dart';
import 'package:krishidnya/features/home/domain/entities/home_entities.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/features/home/presentation/screens/feature_screens.dart';
import 'package:krishidnya/widgets/buttons/primary_button.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';
import 'package:krishidnya/widgets/feedback/empty_state_widget.dart';
import 'package:krishidnya/widgets/inputs/app_text_field.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// AI farming assistant chat with voice input and history persistence.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <_ChatMessage>[];
  final _conversationHistory = <Map<String, String>>[];
  final _speech = stt.SpeechToText();
  final _tts = FlutterTts();
  var _loading = false;
  var _listening = false;
  var _speechReady = false;

  static const _suggestedPrompts = [
    'Best crop for loamy soil in Kharif?',
    'How to treat leaf curl in tomato?',
    'Government schemes for small farmers',
    'When to harvest onion crop?',
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadHistory();
  }

  Future<void> _initSpeech() async {
    _speechReady = await _speech.initialize();
    await _applyVoiceLocale(ref.read(appLocaleProvider));
  }

  Future<void> _applyVoiceLocale(Locale locale) async {
    final speechCode = AppLanguages.speechLocale(locale.languageCode);
    await _tts.setLanguage(speechCode);
  }

  Future<void> _loadHistory() async {
    final service = await ref.read(chatHistoryServiceProvider.future);
    final history = service.load();
    if (history.isNotEmpty) {
      final restored = <_ChatMessage>[];
      for (final entry in history) {
        final role = entry['role'];
        final content = entry['content'];
        if (role == null || content == null) continue;
        restored.add(_ChatMessage(
          text: content,
          isUser: role == 'user',
        ));
      }
      setState(() {
        _conversationHistory.addAll(history);
        _messages.addAll(restored);
      });
    }
  }

  Future<void> _saveHistory() async {
    final service = await ref.read(chatHistoryServiceProvider.future);
    await service.save(_conversationHistory);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _speech.stop();
    _tts.stop();
    super.dispose();
  }

  Future<void> _toggleVoice() async {
    if (!_speechReady) {
      AppSnackBar.error(context, 'Voice input not available on this device');
      return;
    }
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    setState(() => _listening = true);
    await _speech.listen(
      onResult: (result) {
        _controller.text = result.recognizedWords;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        if (result.finalResult) {
          setState(() => _listening = false);
        }
      },
    );
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> _send([String? overrideText]) async {
    final text = (overrideText ?? _controller.text).trim();
    if (text.isEmpty || _loading) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _loading = true;
    });
    _controller.clear();

    final result = await ref.read(homeRepositoryProvider).chat(
          text,
          history: _conversationHistory,
        );

    if (!mounted) return;
    setState(() {
      _loading = false;
      switch (result) {
        case Success(:final data):
          final reply = data['response'] as String? ??
              data['message'] as String? ??
              data.toString();
          _messages.add(_ChatMessage(text: reply, isUser: false));
          _conversationHistory.add({'role': 'user', 'content': text});
          _conversationHistory.add({'role': 'assistant', 'content': reply});
          _saveHistory();
        case ErrorResult(:final failure):
          _messages.add(
            _ChatMessage(text: failure.message, isUser: false, isError: true),
          );
      }
    });

    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appLocaleProvider, (_, next) => _applyVoiceLocale(next));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Krishidnya AI', style: Theme.of(context).textTheme.titleMedium),
            Text('Ask anything about farming',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear chat',
            onPressed: () async {
              setState(() {
                _messages.clear();
                _conversationHistory.clear();
              });
              final service = await ref.read(chatHistoryServiceProvider.future);
              await service.clear();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? ListView(
                    padding: AppSpacing.screenPadding,
                    children: [
                      const EmptyStateWidget(
                        title: 'How can I help your farm today?',
                        subtitle:
                            'Ask about crops, weather, diseases, or government schemes.',
                        icon: Icons.chat_bubble_outline_rounded,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: _suggestedPrompts.map((p) {
                          return ActionChip(
                            label: Text(p),
                            onPressed: () => _send(p),
                          );
                        }).toList(),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: AppSpacing.screenPadding,
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => _ChatBubble(
                      message: _messages[i],
                      onSpeak: _speak,
                    ),
                  ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: LinearProgressIndicator(color: AppColors.primary),
            ),
          Padding(
            padding: AppSpacing.screenPadding,
            child: Row(
              children: [
                IconButton(
                  onPressed: _toggleVoice,
                  icon: Icon(
                    _listening ? Icons.mic : Icons.mic_none,
                    color: _listening ? AppColors.error : AppColors.primary,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: _listening ? 'Listening...' : 'Type your question...',
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filled(
                  onPressed: _send,
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  _ChatMessage({required this.text, required this.isUser, this.isError = false});
  final String text;
  final bool isUser;
  final bool isError;
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, this.onSpeak});
  final _ChatMessage message;
  final Future<void> Function(String)? onSpeak;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.xxs),
            padding: AppSpacing.cardPadding,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            decoration: BoxDecoration(
              color: message.isError
                  ? AppColors.error.withValues(alpha: 0.12)
                  : message.isUser
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isError
                    ? AppColors.error
                    : message.isUser
                        ? Colors.white
                        : AppColors.textPrimary,
              ),
            ),
          ),
          if (!message.isUser && !message.isError && onSpeak != null)
            IconButton(
              icon: const Icon(Icons.volume_up_outlined, size: 18),
              onPressed: () => onSpeak!(message.text),
              tooltip: 'Listen',
            ),
        ],
      ),
    );
  }
}

/// Farmer community with likes, comments, and image posts.
class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(communityPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline),
            tooltip: 'Nearby farmers',
            onPressed: () => context.push(AppRoutes.nearbyFarmers),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showCreatePost(context, ref),
          ),
        ],
      ),
      body: postsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => const EmptyStateWidget(
          title: 'Farmer Community',
          subtitle: 'Share crop updates, tips, and connect with farmers nearby.',
          icon: Icons.people_outline_rounded,
        ),
        data: (posts) => posts.isEmpty
            ? const EmptyStateWidget(
                title: 'No posts yet',
                subtitle: 'Share your first farm update with the community.',
                icon: Icons.people_outline_rounded,
              )
            : ListView.separated(
                padding: AppSpacing.screenPadding,
                itemCount: posts.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, i) => _PostCard(post: posts[i]),
              ),
      ),
    );
  }

  void _showCreatePost(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: 'Crop Update');
    String? imagePath;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Share Update', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Title (optional)', controller: titleCtrl),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Category', controller: categoryCtrl),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: "What's happening on your farm?",
                controller: contentCtrl,
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) setState(() => imagePath = picked.path);
                },
                icon: const Icon(Icons.image_outlined),
                label: Text(imagePath == null ? 'Add Photo' : 'Photo selected'),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Post',
                onPressed: () async {
                  if (contentCtrl.text.trim().isEmpty) {
                    AppSnackBar.error(ctx, 'Write something to share');
                    return;
                  }
                  final result =
                      await ref.read(homeRepositoryProvider).createPost(
                            content: contentCtrl.text.trim(),
                            title: titleCtrl.text.trim().isEmpty
                                ? null
                                : titleCtrl.text.trim(),
                            category: categoryCtrl.text.trim(),
                            imagePath: imagePath,
                          );
                  if (!ctx.mounted) return;
                  switch (result) {
                    case Success():
                      Navigator.pop(ctx);
                      ref.invalidate(communityPostsProvider);
                      AppSnackBar.success(context, 'Post shared!');
                    case ErrorResult(:final failure):
                      AppSnackBar.error(context, failure.message);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostCard extends ConsumerWidget {
  const _PostCard({required this.post});
  final CommunityPost post;

  Future<void> _like(WidgetRef ref) async {
    final result = await ref.read(homeRepositoryProvider).likePost(post.id);
    if (result case Success()) {
      ref.invalidate(communityPostsProvider);
    }
  }

  Future<void> _showComments(BuildContext context, WidgetRef ref) async {
    final commentCtrl = TextEditingController();
    final commentsResult =
        await ref.read(homeRepositoryProvider).getComments(post.id);
    final comments = switch (commentsResult) {
      Success(:final data) => data,
      ErrorResult() => <PostComment>[],
    };

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Comments', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            if (comments.isEmpty)
              const Text('No comments yet. Be the first!')
            else
              ...comments.map(
                (c) => ListTile(
                  title: Text(c.authorName),
                  subtitle: Text(c.content),
                ),
              ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Add a comment', controller: commentCtrl),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: 'Post Comment',
              onPressed: () async {
                if (commentCtrl.text.trim().isEmpty) return;
                final result = await ref
                    .read(homeRepositoryProvider)
                    .addComment(post.id, commentCtrl.text.trim());
                if (!ctx.mounted) return;
                switch (result) {
                  case Success():
                    Navigator.pop(ctx);
                    ref.invalidate(communityPostsProvider);
                  case ErrorResult(:final failure):
                    AppSnackBar.error(context, failure.message);
                }
              },
            ),
          ],
        ),
      ),
    );
    commentCtrl.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(post.authorName[0].toUpperCase()),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName,
                          style: Theme.of(context).textTheme.titleSmall),
                      Text(post.category,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (post.title != null)
              Text(post.title!,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            Text(post.content),
            if (post.imageUrl != null) ...[
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(post.imageUrl!, height: 160, fit: BoxFit.cover),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                InkWell(
                  onTap: () => _like(ref),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_border, size: 18),
                      const SizedBox(width: 4),
                      Text('${post.likesCount}'),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                InkWell(
                  onTap: () => _showComments(context, ref),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 18),
                      const SizedBox(width: 4),
                      Text('${post.commentsCount}'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Scan crop wrapper for bottom nav.
class ScanCropScreen extends StatelessWidget {
  const ScanCropScreen({super.key});

  @override
  Widget build(BuildContext context) => const ScanCropFeatureScreen();
}

/// User profile and settings links.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (_, __) => const EmptyStateWidget(
          title: 'Profile',
          subtitle: 'Manage your account and farm details.',
          icon: Icons.person_outline_rounded,
        ),
        data: (User? user) => ListView(
          padding: AppSpacing.screenPadding,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryContainer,
              child: Text(
                (user?.fullName ?? 'F')[0].toUpperCase(),
                style: const TextStyle(fontSize: 32, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(user?.fullName ?? 'Farmer',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall),
            Text(user?.mobile ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            if (user?.location != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(user!.location!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: AppSpacing.xl),
            _ProfileTile(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: () => context.push(AppRoutes.profileEdit),
            ),
            _ProfileTile(
              icon: Icons.settings_outlined,
              title: 'App Settings',
              onTap: () => context.push(AppRoutes.settings),
            ),
            _ProfileTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () => context.push(AppRoutes.notifications),
            ),
            _ProfileTile(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              onTap: () => showLegalSheet(context, 'Terms & Conditions', kTermsText),
            ),
            _ProfileTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => showLegalSheet(context, 'Privacy Policy', kPrivacyText),
            ),
            _ProfileTile(
              icon: Icons.delete_outline,
              title: 'Delete Account',
              color: AppColors.error,
              onTap: () => confirmDeleteAccount(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.primary),
        title: Text(title, style: TextStyle(color: color)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
