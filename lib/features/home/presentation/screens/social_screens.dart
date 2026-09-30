import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cropdoc/core/errors/exception_mapper.dart';
import 'package:cropdoc/core/errors/failures.dart';
import 'package:cropdoc/core/l10n/locale_config.dart';
import 'package:cropdoc/core/routes/app_routes.dart';
import 'package:cropdoc/core/theme/app_colors.dart';
import 'package:cropdoc/core/theme/app_spacing.dart';
import 'package:cropdoc/core/utils/account_dialogs.dart';
import 'package:cropdoc/features/auth/domain/entities/user.dart';
import 'package:cropdoc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cropdoc/features/home/domain/entities/feature_models.dart';
import 'package:cropdoc/features/home/domain/entities/home_entities.dart';
import 'package:cropdoc/features/home/presentation/controllers/home_providers.dart';
import 'package:cropdoc/features/home/presentation/screens/feature_screens.dart';
import 'package:cropdoc/l10n/app_localizations.dart';
import 'package:cropdoc/widgets/buttons/primary_button.dart';
import 'package:cropdoc/widgets/feedback/app_snackbar.dart';
import 'package:cropdoc/widgets/feedback/empty_state_widget.dart';
import 'package:cropdoc/widgets/inputs/app_text_field.dart';
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
      // Load all history (stored locally, performance is acceptable)
      final restored = <_ChatMessage>[];
      final restoredHistory = <Map<String, String>>[];
      for (final entry in history) {
        final role = entry['role'];
        final content = entry['content'];
        if (role == null || content == null) continue;
        restored.add(_ChatMessage(text: content, isUser: role == 'user'));
        restoredHistory.add(entry);
      }
      setState(() {
        _conversationHistory.addAll(restoredHistory);
        _messages.addAll(restored);
      });
    }
  }

  Future<void> _saveHistory() async {
    final service = await ref.read(chatHistoryServiceProvider.future);
    await service.save(_conversationHistory);
  }

  String _getFriendlyErrorMessage(Failure failure) {
    // Provide user-friendly error messages for different failure types
    if (failure.message.contains('timeout') ||
        failure.message.contains('time')) {
      return 'I apologize, but the request took too long. Please try again.';
    } else if (failure.message.contains('network') ||
        failure.message.contains('connection')) {
      return 'Network connection issue. Please check your internet connection and try again.';
    } else if (failure.message.contains('server') ||
        failure.message.contains('500')) {
      return 'Server is temporarily unavailable. Please try again in a moment.';
    } else if (failure.message.contains('401') ||
        failure.message.contains('auth')) {
      return 'Authentication error. Please log in again.';
    } else {
      return 'Something went wrong. Please try again or contact support if the issue persists.';
    }
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

    try {
      final result = await ref
          .read(homeRepositoryProvider)
          .chat(text, history: _conversationHistory);

      if (!mounted) return;
      setState(() {
        _loading = false;
        switch (result) {
          case Success(:final data):
            final reply =
                data['response'] as String? ??
                data['message'] as String? ??
                data.toString();
            _messages.add(_ChatMessage(text: reply, isUser: false));
            _conversationHistory.add({'role': 'user', 'content': text});
            _conversationHistory.add({'role': 'assistant', 'content': reply});
            _saveHistory();
          case ErrorResult(:final failure):
            final errorMessage = _getFriendlyErrorMessage(failure);
            _messages.add(
              _ChatMessage(text: errorMessage, isUser: false, isError: true),
            );
            // Still add to conversation history to maintain consistency
            _conversationHistory.add({'role': 'user', 'content': text});
            _conversationHistory.add({
              'role': 'assistant',
              'content': errorMessage,
            });
            _saveHistory();
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        final errorMessage = _getFriendlyErrorMessage(ExceptionMapper.map(e));
        _messages.add(
          _ChatMessage(text: errorMessage, isUser: false, isError: true),
        );
        _conversationHistory.add({'role': 'user', 'content': text});
        _conversationHistory.add({
          'role': 'assistant',
          'content': errorMessage,
        });
        _saveHistory();
      });
    }

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
    final l10n = AppLocalizations.of(context);
    ref.listen(appLocaleProvider, (_, next) => _applyVoiceLocale(next));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.krishidnyaAI,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              l10n.askAnythingAboutFarming,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.clearChat,
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
            child:
                _messages.isEmpty
                    ? ListView(
                      padding: AppSpacing.screenPadding,
                      children: [
                        EmptyStateWidget(
                          title: l10n.howCanHelpFarmToday,
                          subtitle: l10n.askAboutCropsWeatherDiseases,
                          icon: Icons.chat_bubble_outline_rounded,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children:
                              _suggestedPrompts.map((p) {
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
                      itemBuilder:
                          (_, i) => _ChatBubble(
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
                      hintText:
                          _listening ? l10n.listening : l10n.typeYourQuestion,
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
  _ChatMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
  });
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
              color:
                  message.isError
                      ? AppColors.error.withValues(alpha: 0.12)
                      : message.isUser
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color:
                    message.isError
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
    final l10n = AppLocalizations.of(context);
    final postsAsync = ref.watch(communityPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.communityTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline),
            tooltip: l10n.nearbyFarmers,
            onPressed: () => context.push(AppRoutes.nearbyFarmers),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showCreatePost(context, ref),
          ),
        ],
      ),
      body: postsAsync.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        error:
            (e, _) => EmptyStateWidget(
              title: l10n.farmerCommunity,
              subtitle: l10n.farmerCommunitySubtitle,
              icon: Icons.people_outline_rounded,
            ),
        data:
            (posts) =>
                posts.isEmpty
                    ? EmptyStateWidget(
                      title: l10n.noPostsYet,
                      subtitle: l10n.noPostsYetSubtitle,
                      icon: Icons.people_outline_rounded,
                    )
                    : ListView.separated(
                      padding: AppSpacing.screenPadding,
                      itemCount: posts.length,
                      separatorBuilder:
                          (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) => _PostCard(post: posts[i]),
                    ),
      ),
    );
  }

  void _showCreatePost(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: 'Crop Update');
    String? imagePath;
    List<int>? imageBytes;
    String? imageName;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder:
          (ctx) => StatefulBuilder(
            builder:
                (ctx, setState) => Padding(
                  padding: EdgeInsets.only(
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    top: AppSpacing.lg,
                    bottom:
                        MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.shareUpdate,
                        style: Theme.of(ctx).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: l10n.titleOptional,
                        controller: titleCtrl,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        label: l10n.category,
                        controller: categoryCtrl,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        label: l10n.whatsHappeningOnFarm,
                        controller: contentCtrl,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (picked != null) {
                            if (kIsWeb) {
                              // On web, read bytes
                              final bytes = await picked.readAsBytes();
                              setState(() {
                                imagePath = picked.path;
                                imageBytes = bytes;
                                imageName = picked.name;
                              });
                            } else {
                              // On native platforms, use file path
                              setState(() => imagePath = picked.path);
                            }
                          }
                        },
                        icon: const Icon(Icons.image_outlined),
                        label: Text(
                          imagePath == null
                              ? l10n.addPhoto
                              : l10n.photoSelected,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      PrimaryButton(
                        label: l10n.post,
                        onPressed: () async {
                          if (contentCtrl.text.trim().isEmpty) {
                            AppSnackBar.error(ctx, l10n.writeSomethingToShare);
                            return;
                          }
                          // Use multipart for all posts (backend now expects form data)
                          await ref
                              .read(homeRepositoryProvider)
                              .createPost(
                                content: contentCtrl.text.trim(),
                                title:
                                    titleCtrl.text.trim().isEmpty
                                        ? null
                                        : titleCtrl.text.trim(),
                                category: categoryCtrl.text.trim(),
                                imagePath: imagePath,
                                imageBytes: imageBytes,
                                imageName: imageName,
                              );
                          if (!ctx.mounted) return;
                          Navigator.pop(ctx);
                          ref.invalidate(communityPostsProvider);
                          AppSnackBar.success(context, 'Post shared!');
                        },
                      ),
                    ],
                  ),
                ),
          ),
    );
  }
}

class _PostCard extends ConsumerStatefulWidget {
  const _PostCard({required this.post});
  final CommunityPost post;

  @override
  ConsumerState<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<_PostCard> {
  bool _isLiked = false;
  int _likesCount = 0;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _likesCount = widget.post.likesCount;
  }

  Future<void> _like() async {
    if (_isProcessing) return;

    // Store original state for rollback
    final originalIsLiked = _isLiked;
    final originalLikesCount = _likesCount;

    // Optimistic UI: update immediately
    setState(() {
      _isProcessing = true;
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });

    final result = await ref
        .read(homeRepositoryProvider)
        .likePost(widget.post.id);

    if (!mounted) return;

    setState(() => _isProcessing = false);

    if (result case Success()) {
      // Success - keep the optimistic state
      ref.invalidate(communityPostsProvider);
    } else {
      // Failure - revert to original state
      setState(() {
        _isLiked = originalIsLiked;
        _likesCount = originalLikesCount;
      });
      AppSnackBar.error(context, 'Failed to update like');
    }
  }

  Future<void> _showComments() async {
    final l10n = AppLocalizations.of(context);
    final commentCtrl = TextEditingController();
    final commentsResult = await ref
        .read(homeRepositoryProvider)
        .getComments(widget.post.id);
    final comments = switch (commentsResult) {
      Success(:final data) => data,
      ErrorResult() => <PostComment>[],
    };

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder:
          (ctx) => Padding(
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
                Text(
                  l10n.commentsTitle,
                  style: Theme.of(ctx).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                if (comments.isEmpty)
                  Text(l10n.noCommentsYet)
                else
                  ...comments.map(
                    (c) => ListTile(
                      title: Text(c.authorName),
                      subtitle: Text(c.content),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(label: l10n.addAComment, controller: commentCtrl),
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(
                  label: l10n.postComment,
                  onPressed: () async {
                    if (commentCtrl.text.trim().isEmpty) return;
                    final result = await ref
                        .read(homeRepositoryProvider)
                        .addComment(widget.post.id, commentCtrl.text.trim());
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
  Widget build(BuildContext context) {
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
                  child: Text(
                    widget.post.authorName.isNotEmpty
                        ? widget.post.authorName[0].toUpperCase()
                        : '?',
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.authorName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        widget.post.category,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (widget.post.title != null)
              Text(
                widget.post.title!,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            Text(widget.post.content),
            if (widget.post.imageUrl != null) ...[
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.post.imageUrl!,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                InkWell(
                  onTap: _isProcessing ? null : _like,
                  child: Row(
                    children: [
                      Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: _isLiked ? Colors.red : null,
                      ),
                      const SizedBox(width: 4),
                      Text('$_likesCount'),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                InkWell(
                  onTap: _showComments,
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 18),
                      const SizedBox(width: 4),
                      Text('${widget.post.commentsCount}'),
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
    final l10n = AppLocalizations.of(context);
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
      body: userAsync.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        error:
            (_, __) => const EmptyStateWidget(
              title: 'Profile',
              subtitle: 'Manage your account and farm details.',
              icon: Icons.person_outline_rounded,
            ),
        data:
            (User? user) => ListView(
              padding: AppSpacing.screenPadding,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    (user?.fullName?.isNotEmpty ?? false)
                        ? user!.fullName![0].toUpperCase()
                        : 'F',
                    style: const TextStyle(
                      fontSize: 32,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  user?.fullName ?? 'Farmer',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  user?.mobile ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (user?.location != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    user!.location!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
                  onTap:
                      () => showLegalSheet(
                        context,
                        'Terms & Conditions',
                        kTermsText,
                      ),
                ),
                _ProfileTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap:
                      () => showLegalSheet(
                        context,
                        'Privacy Policy',
                        kPrivacyText,
                      ),
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
