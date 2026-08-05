import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/config/providers.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/core/utils/account_dialogs.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';

/// App settings, legal pages, language, and account actions.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const _SectionHeader(title: 'Language'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('App Language'),
              subtitle: Text(locale.languageCode == 'hi' ? 'Hindi' : 'English'),
              trailing: DropdownButton<String>(
                value: locale.languageCode,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
                ],
                onChanged: (code) {
                  if (code != null) {
                    ref.read(appLocaleProvider.notifier).setLocale(Locale(code));
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionHeader(title: 'Account'),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Log Out',
            onTap: () => _logout(context, ref),
          ),
          _SettingsTile(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            color: AppColors.error,
            onTap: () => confirmDeleteAccount(context, ref),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionHeader(title: 'Legal'),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: () => showLegalSheet(context, 'Terms & Conditions', kTermsText),
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => showLegalSheet(context, 'Privacy Policy', kPrivacyText),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionHeader(title: 'About'),
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
