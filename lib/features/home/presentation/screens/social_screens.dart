import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/features/home/presentation/screens/feature_screens.dart';
import 'package:krishidnya/widgets/buttons/primary_button.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';
import 'package:krishidnya/widgets/feedback/empty_state_widget.dart';
import 'package:krishidnya/widgets/inputs/app_text_field.dart';

/// AI farming assistant chat.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <_ChatMessage>[];
  var _loading = false;
  final _conversationHistory = <Map<String, String>>[];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
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
        case ErrorResult(:final failure):
          _messages.add(
            _ChatMessage(
              text: failure.message,
              isUser: false,
              isError: true,
            ),
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
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Krishidnya AI',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Ask anything about farming',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const EmptyStateWidget(
                    title: 'How can I help your farm today?',
                    subtitle:
                        'Ask about crops, weather, diseases, or government schemes.',
                    icon: Icons.chat_bubble_outline_rounded,
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: AppSpacing.screenPadding,
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => _ChatBubble(message: _messages[i]),
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
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your question...',
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
  const _ChatBubble({required this.message});
  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
          border: message.isError
              ? Border.all(color: AppColors.error.withValues(alpha: 0.4))
              : null,
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
    );
  }
}

/// Farmer community — social feed.
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
                itemBuilder: (context, i) {
                  final post = posts[i];
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
                                    Text(
                                      post.authorName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Text(
                                      post.category,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          if (post.title != null)
                            Text(
                              post.title!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          Text(post.content),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Icon(Icons.favorite_border,
                                  size: 18, color: AppColors.textTertiary),
                              const SizedBox(width: 4),
                              Text('${post.likesCount}'),
                              const SizedBox(width: AppSpacing.md),
                              Icon(Icons.chat_bubble_outline,
                                  size: 18, color: AppColors.textTertiary),
                              const SizedBox(width: 4),
                              Text('${post.commentsCount}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showCreatePost(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: 'Crop Update');

    showModalBottomSheet<void>(
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
            Text('Share Update', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Title (optional)', controller: titleCtrl),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Category', controller: categoryCtrl),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'What\'s happening on your farm?', controller: contentCtrl),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Post',
              onPressed: () async {
                if (contentCtrl.text.trim().isEmpty) {
                  AppSnackBar.error(ctx, 'Write something to share');
                  return;
                }
                final result = await ref.read(homeRepositoryProvider).createPost(
                      content: contentCtrl.text.trim(),
                      title: titleCtrl.text.trim().isEmpty ? null : titleCtrl.text.trim(),
                      category: categoryCtrl.text.trim(),
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
    );
  }
}

/// Scan crop for disease detection — uses shared feature screen.
class ScanCropScreen extends StatelessWidget {
  const ScanCropScreen({super.key});

  @override
  Widget build(BuildContext context) => const ScanCropFeatureScreen();
}

/// User profile and settings.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: userAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (_, __) => const EmptyStateWidget(
          title: 'Profile',
          subtitle: 'Manage your account and farm details.',
          icon: Icons.person_outline_rounded,
        ),
        data: (user) => ListView(
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
              icon: Icons.settings_outlined,
              title: 'App Settings',
              onTap: () => context.push(AppRoutes.settings),
            ),
            _ProfileTile(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              onTap: () => context.push(AppRoutes.settings),
            ),
            _ProfileTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => context.push(AppRoutes.settings),
            ),
            _ProfileTile(
              icon: Icons.delete_outline,
              title: 'Delete Account',
              color: AppColors.error,
              onTap: () => context.push(AppRoutes.settings),
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
