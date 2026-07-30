import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/config/providers.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';

/// App settings, legal pages, and account actions.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          _SectionHeader(title: 'Account'),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Log Out',
            onTap: () => _logout(context, ref),
          ),
          _SettingsTile(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            color: AppColors.error,
            onTap: () => _showDeleteDialog(context),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(title: 'Legal'),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: () => _showLegalSheet(
              context,
              'Terms & Conditions',
              _termsText,
            ),
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _showLegalSheet(
              context,
              'Privacy Policy',
              _privacyText,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(title: 'About'),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Krishidnya v1.0.0'),
              subtitle: Text('Your trusted digital farming companion'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Log Out')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final result = await ref.read(authRepositoryProvider).logout();
    if (!context.mounted) return;

    switch (result) {
      case Success():
        ref.invalidate(authStatusProvider);
        ref.invalidate(currentUserProvider);
        context.go(AppRoutes.onboarding);
      case ErrorResult(:final failure):
        AppSnackBar.error(context, failure.message);
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'To delete your account, please contact our support team at '
          'support@krishidnya.com. We will process your request within 48 hours.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showLegalSheet(BuildContext context, String title, String body) {
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
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
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

const _termsText = '''
By using Krishidnya, you agree to use the app for lawful agricultural purposes. '
Government scheme applications submitted through the app are processed by our back-office team on your behalf.

We reserve the right to modify these terms. Continued use of the app constitutes acceptance of updated terms.
''';

const _privacyText = '''
Krishidnya collects your name, mobile number, location, and farm data to provide personalized recommendations.

Your data is stored securely and is not sold to third parties. Location data is used for weather and crop recommendations.

You may request account deletion by contacting support@krishidnya.com.
''';
