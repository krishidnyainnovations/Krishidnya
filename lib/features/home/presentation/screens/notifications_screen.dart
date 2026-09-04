import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cropdoc/core/theme/app_colors.dart';
import 'package:cropdoc/core/theme/app_spacing.dart';
import 'package:cropdoc/features/home/domain/entities/feature_models.dart';
import 'package:cropdoc/features/home/presentation/controllers/home_providers.dart';
import 'package:cropdoc/l10n/app_localizations.dart';
import 'package:cropdoc/widgets/feedback/empty_state_widget.dart';

/// In-app notification center with read-state tracking.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _markAsRead(WidgetRef ref, AppNotification notification) async {
    final prefs = await ref.read(notificationPreferencesProvider.future);
    await prefs.markAsRead(notification.id);
    ref.invalidate(notificationsProvider);
  }

  Future<void> _markAllAsRead(
    WidgetRef ref,
    List<AppNotification> items,
  ) async {
    final prefs = await ref.read(notificationPreferencesProvider.future);
    await prefs.markAllAsRead(items.map((n) => n.id).toList());
    ref.invalidate(notificationsProvider);
  }

  void _showDetail(BuildContext context, WidgetRef ref, AppNotification n) {
    _markAsRead(ref, n);
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(n.title, style: Theme.of(ctx).textTheme.titleLarge),
            if (n.createdAt.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                n.createdAt.length > 10
                    ? n.createdAt.substring(0, 10)
                    : n.createdAt,
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Text(n.body),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          notificationsAsync.maybeWhen(
            data: (items) => items.any((n) => !n.isRead)
                ? TextButton(
                    onPressed: () => _markAllAsRead(ref, items),
                    child: Text(l10n.markAllRead),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(notificationsProvider),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (_, __) => EmptyStateWidget(
          title: l10n.noNotifications,
          subtitle: l10n.notificationsEmptySubtitle,
          icon: Icons.notifications_none,
        ),
        data: (items) => items.isEmpty
            ? EmptyStateWidget(
                title: l10n.allCaughtUp,
                subtitle: l10n.noNewNotifications,
                icon: Icons.notifications_none,
              )
            : ListView.separated(
                padding: AppSpacing.screenPadding,
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final n = items[i];
                  return Card(
                    color: n.isRead
                        ? null
                        : AppColors.primaryContainer.withValues(alpha: 0.2),
                    child: ListTile(
                      onTap: () => _showDetail(context, ref, n),
                      leading: Icon(
                        Icons.notifications_active_outlined,
                        color: n.isRead
                            ? AppColors.textTertiary
                            : AppColors.primary,
                      ),
                      title: Text(
                        n.title,
                        style: TextStyle(
                          fontWeight:
                              n.isRead ? FontWeight.normal : FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        n.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: n.createdAt.isNotEmpty
                          ? Text(
                              n.createdAt.length > 10
                                  ? n.createdAt.substring(0, 10)
                                  : n.createdAt,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          : null,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
