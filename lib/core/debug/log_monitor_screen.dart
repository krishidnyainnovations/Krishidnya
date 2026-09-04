import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cropdoc/core/api/api_config.dart';
import 'package:cropdoc/core/config/providers.dart';
import 'package:cropdoc/core/services/app_logger.dart';
import 'package:cropdoc/core/theme/app_colors.dart';
import 'package:cropdoc/core/theme/app_spacing.dart';

/// In-app log monitor for debugging API and auth errors.
class LogMonitorScreen extends ConsumerWidget {
  const LogMonitorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(logEntriesProvider);
    final errors = logs
        .where((e) => e.level == LogLevel.error || e.level == LogLevel.warning)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Monitor'),
        actions: [
          if (errors > 0)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Center(
                child: Chip(
                  label: Text('$errors issues'),
                  backgroundColor: AppColors.error.withValues(alpha: 0.15),
                  labelStyle: const TextStyle(color: AppColors.error),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear logs',
            onPressed: () =>
                ref.read(logEntriesProvider.notifier).clear(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: AppSpacing.cardPadding,
            color: AppColors.primaryContainer.withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Backend: ${ApiConfig.baseUrl}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${logs.length} entries · Debug mode only',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: logs.isEmpty
                ? const Center(
                    child: Text('No logs yet. Try login or register.'),
                  )
                : ListView.builder(
                    reverse: true,
                    padding: AppSpacing.screenPadding,
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final entry = logs[logs.length - 1 - index];
                      return _LogEntryTile(entry: entry);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _LogEntryTile extends StatelessWidget {
  const _LogEntryTile({required this.entry});

  final LogEntry entry;

  @override
  Widget build(BuildContext context) {
    final color = switch (entry.level) {
      LogLevel.error => AppColors.error,
      LogLevel.warning => AppColors.warning,
      LogLevel.api => AppColors.accent,
      LogLevel.info => AppColors.primary,
      LogLevel.debug => AppColors.textTertiary,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  entry.formattedTime,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  entry.tag,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              entry.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            if (entry.details != null && entry.details!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                entry.details!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Floating debug button to open log monitor (debug builds only).
class DebugLogFab extends StatelessWidget {
  const DebugLogFab({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return FloatingActionButton.small(
      heroTag: 'debug_log_fab',
      onPressed: onTap,
      backgroundColor: AppColors.textPrimary,
      foregroundColor: Colors.white,
      tooltip: 'Log Monitor',
      child: const Icon(Icons.bug_report_outlined, size: 20),
    );
  }
}
