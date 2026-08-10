import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/l10n/app_localizations.dart';
import 'package:krishidnya/widgets/buttons/primary_button.dart';
import 'package:krishidnya/widgets/inputs/app_text_field.dart';

/// Registration step 1 — collect user details.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(registrationControllerProvider.notifier).updateForm(
          fullName: _fullNameController.text,
          email: _emailController.text,
          mobile: _mobileController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        );

    ref
        .read(registrationControllerProvider.notifier)
        .goToLocationPermission();

    context.push(AppRoutes.registerLocationPermission);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(AppRoutes.onboarding),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.createAccountTitle,
                  style: theme.textTheme.headlineMedium,
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.createAccountSubtitle,
                  style: theme.textTheme.bodyMedium,
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  label: l10n.fullName,
                  controller: _fullNameController,
                  hint: l10n.fullNameHint,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  autofillHints: const [AutofillHints.name],
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? l10n.nameRequired : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: l10n.email,
                  controller: _emailController,
                  hint: l10n.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined),
                  autofillHints: const [AutofillHints.email],
                  validator: (v) {
                    if (v == null || !v.contains('@')) {
                      return l10n.validEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: l10n.mobileNumber,
                  controller: _mobileController,
                  hint: l10n.mobileHint,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (v) =>
                      v == null || v.length < 10 ? l10n.validMobile : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: l10n.password,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) => v == null || v.length < 6
                      ? l10n.passwordMinLength
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: l10n.confirmPassword,
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) {
                    if (v != _passwordController.text) {
                      return l10n.passwordsNoMatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: l10n.continueLabel,
                  onPressed: _continue,
                  icon: Icons.arrow_forward_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
