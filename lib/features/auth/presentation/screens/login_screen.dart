import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cropdoc/core/routes/app_routes.dart';
import 'package:cropdoc/core/theme/app_spacing.dart';
import 'package:cropdoc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cropdoc/l10n/app_localizations.dart';
import 'package:cropdoc/widgets/buttons/primary_button.dart';
import 'package:cropdoc/widgets/common/app_logo.dart';
import 'package:cropdoc/widgets/inputs/app_text_field.dart';

/// Calm, minimal login screen with animated logo.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(loginControllerProvider.notifier)
      ..updateMobile(_mobileController.text)
      ..updatePassword(_passwordController.text);

    await ref.read(loginControllerProvider.notifier).login();

    if (!mounted) return;
    final state = ref.read(loginControllerProvider);
    if (state.isSuccess) {
      await refreshAuthSession(ref);
      if (!mounted) return;
      context.go(AppRoutes.dashboard);
    } else if (state.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error!.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final loginState = ref.watch(loginControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                const Center(child: KrishidnyaLogo(size: 72))
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      curve: Curves.easeOutBack,
                    ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.welcomeBack,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.loginSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: AppSpacing.xxl),
                AppTextField(
                  label: l10n.mobileNumber,
                  controller: _mobileController,
                  hint: l10n.mobileHintLogin,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  autofillHints: const [AutofillHints.telephoneNumber],
                  validator: (value) {
                    if (value == null || value.length < 10) {
                      return l10n.validMobileLogin;
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.05, end: 0),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: l10n.password,
                  controller: _passwordController,
                  hint: l10n.passwordHint,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed:
                        () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                  ),
                  autofillHints: const [AutofillHints.password],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.enterPassword;
                    }
                    return null;
                  },
                  onChanged: (_) {},
                ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.05, end: 0),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: l10n.login,
                  isLoading: loginState.isLoading,
                  onPressed: _handleLogin,
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.dontHaveAccount,
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.register),
                      child: Text(l10n.register),
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
