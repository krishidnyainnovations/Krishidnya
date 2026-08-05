import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/config/providers.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';

/// Shared terms & conditions text.
const kTermsText = '''
By using Krishidnya, you agree to use the app for lawful agricultural purposes.
Government scheme applications submitted through the app are processed by our back-office team on your behalf.

We reserve the right to modify these terms. Continued use of the app constitutes acceptance of updated terms.
''';

/// Shared privacy policy text.
const kPrivacyText = '''
Krishidnya collects your name, mobile number, location, and farm data to provide personalized recommendations.

Your data is stored securely and is not sold to third parties. Location data is used for weather and crop recommendations.

You may request account deletion from Settings or by contacting support@krishidnya.com.
''';

/// Shows a scrollable legal document bottom sheet.
void showLegalSheet(BuildContext context, String title, String body) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (_, controller) => Column(
        children: [
          Padding(
            padding: AppSpacing.screenPadding,
            child: Text(title, style: Theme.of(ctx).textTheme.titleLarge),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              padding: AppSpacing.screenPadding,
              child: Text(body, style: Theme.of(ctx).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Confirms and executes account deletion.
Future<void> confirmDeleteAccount(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete Account'),
      content: const Text(
        'This permanently deletes your account and all associated data. '
        'This action cannot be undone.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete', style: TextStyle(color: AppColors.error)),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  final result = await ref.read(authRepositoryProvider).deleteAccount();
  if (!context.mounted) return;

  switch (result) {
    case Success():
      ref.invalidate(authStatusProvider);
      ref.invalidate(currentUserProvider);
      AppSnackBar.success(context, 'Account deleted');
      context.go(AppRoutes.onboarding);
    case ErrorResult(:final failure):
      AppSnackBar.error(
        context,
        '${failure.message}. Contact support@krishidnya.com for help.',
      );
  }
}
