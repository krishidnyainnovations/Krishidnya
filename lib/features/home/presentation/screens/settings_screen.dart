import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/l10n/locale_config.dart';
import 'package:krishidnya/core/config/providers.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/core/utils/account_dialogs.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/l10n/app_localizations.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';

/// App settings, legal pages, language, and account actions.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(appLocaleProvider);
    final currentLang = AppLanguages.find(locale.languageCode);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          _SectionHeader(title: l10n.language),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.appLanguage),
              subtitle: Text(currentLang?.name ?? locale.languageCode),
              trailing: DropdownButton<String>(
                value: locale.languageCode,
                items: AppLanguages.supported
                    .map(
                      (lang) => DropdownMenuItem(
                        value: lang.code,
                        child: Text(lang.name),
                      ),
                    )
                    .toList(),
                onChanged: (code) {
                  if (code != null) {
                    ref
                        .read(appLocaleProvider.notifier)
                        .setLocale(Locale(code));
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(title: l10n.account),
          _SettingsTile(
            icon: Icons.logout,
            title: l10n.logOut,
            onTap: () => _logout(context, ref, l10n),
          ),
          _SettingsTile(
            icon: Icons.delete_outline,
            title: l10n.deleteAccount,
            color: AppColors.error,
            onTap: () => confirmDeleteAccount(context, ref),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(title: l10n.legal),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: l10n.termsAndConditions,
            onTap: () =>
                showLegalSheet(context, l10n.termsAndConditions, kTermsText),
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: l10n.privacyPolicy,
            onTap: () =>
                showLegalSheet(context, l10n.privacyPolicy, kPrivacyText),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(title: l10n.about),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.appVersion),
              subtitle: Text(l10n.appTagline),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logOutConfirmTitle),
        content: Text(l10n.logOutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.logOut),
          ),
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
