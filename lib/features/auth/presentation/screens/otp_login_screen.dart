import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/config/providers.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/widgets/buttons/primary_button.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';
import 'package:krishidnya/widgets/inputs/app_text_field.dart';

/// OTP-based login without password.
class OtpLoginScreen extends ConsumerStatefulWidget {
  const OtpLoginScreen({super.key});

  @override
  ConsumerState<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends ConsumerState<OtpLoginScreen> {
  final _mobileCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  var _otpSent = false;
  var _loading = false;

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_mobileCtrl.text.trim().length < 10) {
      AppSnackBar.error(context, 'Enter a valid mobile number');
      return;
    }
    setState(() => _loading = true);
    final result = await ref.read(authRepositoryProvider).sendOtp(
          _mobileCtrl.text.trim(),
        );
    if (!mounted) return;
    setState(() => _loading = false);
    switch (result) {
      case Success():
        setState(() => _otpSent = true);
        AppSnackBar.success(context, 'OTP sent to your mobile');
      case ErrorResult(:final failure):
        AppSnackBar.error(context, failure.message);
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpCtrl.text.trim().isEmpty) {
      AppSnackBar.error(context, 'Enter the OTP');
      return;
    }
    setState(() => _loading = true);
    final result = await ref.read(authRepositoryProvider).verifyOtp(
          mobile: _mobileCtrl.text.trim(),
          otp: _otpCtrl.text.trim(),
        );
    if (!mounted) return;
    setState(() => _loading = false);
    switch (result) {
      case Success():
        await refreshAuthSession(ref);
        if (mounted) context.go(AppRoutes.dashboard);
      case ErrorResult(:final failure):
        AppSnackBar.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login with OTP')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Text(
            'Enter your mobile number to receive a one-time password.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Mobile Number',
            controller: _mobileCtrl,
            keyboardType: TextInputType.phone,
            enabled: !_otpSent,
          ),
          if (_otpSent) ...[
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'OTP',
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: _otpSent ? 'Verify & Login' : 'Send OTP',
            isLoading: _loading,
            onPressed: _otpSent ? _verifyOtp : _sendOtp,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.push(AppRoutes.login),
            child: const Text('Login with password instead'),
          ),
        ],
      ),
    );
  }
}
