import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/widgets/feedback/empty_state_widget.dart';

/// In-app notification center.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
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
        error: (_, __) => const EmptyStateWidget(
          title: 'No notifications',
          subtitle: 'Weather alerts, scheme updates, and community activity appear here.',
          icon: Icons.notifications_none,
        ),
        data: (items) => items.isEmpty
            ? const EmptyStateWidget(
                title: 'All caught up',
                subtitle: 'You have no new notifications.',
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
                      leading: Icon(
                        Icons.notifications_active_outlined,
                        color: n.isRead ? AppColors.textTertiary : AppColors.primary,
                      ),
                      title: Text(
                        n.title,
                        style: TextStyle(
                          fontWeight:
                              n.isRead ? FontWeight.normal : FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(n.body),
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
