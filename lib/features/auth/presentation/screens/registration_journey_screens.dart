import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/l10n/app_localizations.dart';
import 'package:krishidnya/widgets/buttons/outlined_button.dart';
import 'package:krishidnya/widgets/buttons/primary_button.dart';
import 'package:krishidnya/widgets/common/app_logo.dart';

/// Explains why location permission is needed before requesting it.
class LocationPermissionScreen extends ConsumerWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(),
              const StoryIllustration(
                icon: Icons.location_on_rounded,
                gradient: AppColors.skyGradient,
                size: 180,
              ).animate().fadeIn().scale(
                    begin: const Offset(0.8, 0.8),
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l10n.locationPermissionTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.locationPermissionSubtitleExtended,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(delay: 350.ms),
              const Spacer(flex: 2),
              PrimaryButton(
                label: l10n.locationPermissionAllow,
                icon: Icons.my_location_rounded,
                onPressed: () {
                  ref
                      .read(registrationControllerProvider.notifier)
                      .requestLocation();
                  context.push(AppRoutes.registerLocationLoading);
                },
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: AppSpacing.sm),
              OutlinedAppButton(
                label: l10n.locationPermissionSkip,
                onPressed: () {
                  ref
                      .read(registrationControllerProvider.notifier)
                      .skipLocation();
                  context.push(AppRoutes.registerAlmostReady);
                },
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}

/// Loading animation while fetching GPS location.
class LocationLoadingScreen extends ConsumerWidget {
  const LocationLoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(registrationControllerProvider);

    ref.listen(registrationControllerProvider, (prev, next) {
      if (next.step == RegistrationStep.locationFound) {
        context.pushReplacement(AppRoutes.registerLocationFound);
      } else if (next.step == RegistrationStep.almostReady) {
        context.pushReplacement(AppRoutes.registerAlmostReady);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const StoryIllustration(
                  icon: Icons.explore_rounded,
                  gradient: AppColors.skyGradient,
                  size: 140,
                )
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(duration: 1500.ms)
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.05, 1.05),
                      duration: 1500.ms,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.05, 1.05),
                      end: const Offset(1, 1),
                      duration: 1500.ms,
                    ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  l10n.locationLoading,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ).animate().fadeIn(),
                const SizedBox(height: AppSpacing.md),
                const CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2.5,
                ),
                if (state.error != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    state.error!.message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows discovered location before proceeding.
class LocationFoundScreen extends ConsumerWidget {
  const LocationFoundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final location = ref.watch(registrationControllerProvider).location;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              )
                  .animate()
                  .fadeIn()
                  .scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l10n.locationFound,
                style: theme.textTheme.headlineMedium,
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: AppSpacing.md),
              Text(
                location?.displayLocation ?? l10n.locationDetected,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ).animate().fadeIn(delay: 450.ms),
              const Spacer(flex: 2),
              PrimaryButton(
                label: l10n.continueLabel,
                onPressed: () {
                  ref
                      .read(registrationControllerProvider.notifier)
                      .confirmLocation();
                  context.push(AppRoutes.registerAlmostReady);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Account setup loading with storytelling microcopy.
class AlmostReadyScreen extends ConsumerWidget {
  const AlmostReadyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(registrationControllerProvider);

    ref.listen(registrationControllerProvider, (prev, next) {
      if (next.step == RegistrationStep.success) {
        refreshAuthSession(ref).then((_) {
          if (context.mounted) context.go(AppRoutes.registerSuccess);
        });
      } else if (next.error != null &&
          prev?.step != RegistrationStep.createAccount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!.message)),
        );
        context.go(AppRoutes.register);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const KrishidnyaLogo(size: 100),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  l10n.almostReady,
                  style: theme.textTheme.headlineMedium,
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.almostReadySubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ).animate().fadeIn(delay: 550.ms),
                const SizedBox(height: AppSpacing.xl),
                if (state.isLoading)
                  const CircularProgressIndicator(color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Success celebration before entering dashboard.
class RegisterSuccessScreen extends ConsumerWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(),
              const StoryIllustration(
                icon: Icons.celebration_rounded,
                gradient: AppColors.primaryGradient,
                size: 180,
              )
                  .animate()
                  .fadeIn()
                  .scale(begin: const Offset(0.7, 0.7), curve: Curves.elasticOut),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l10n.accountCreated,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium,
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.accountCreatedSubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ).animate().fadeIn(delay: 550.ms),
              const Spacer(flex: 2),
              PrimaryButton(
                label: l10n.enterDashboard,
                icon: Icons.arrow_forward_rounded,
                onPressed: () async {
                  await refreshAuthSession(ref);
                  if (context.mounted) context.go(AppRoutes.dashboard);
                },
              ).animate().fadeIn(delay: 700.ms),
            ],
          ),
        ),
      ),
    );
  }
}
