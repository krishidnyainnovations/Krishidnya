import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cropdoc/core/constants/app_constants.dart';
import 'package:cropdoc/core/routes/app_routes.dart';
import 'package:cropdoc/core/theme/app_colors.dart';
import 'package:cropdoc/core/theme/app_spacing.dart';
import 'package:cropdoc/l10n/app_localizations.dart';
import 'package:cropdoc/widgets/buttons/primary_button.dart';
import 'package:cropdoc/widgets/common/app_logo.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Emotional storytelling onboarding journey.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  List<_OnboardingPageData> _pages(AppLocalizations l10n) => [
        _OnboardingPageData(
          title: l10n.onboardingPage1Title,
          subtitle: l10n.onboardingPage1Subtitle,
          icon: Icons.cloud_off_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF6B705C), Color(0xFF354F52)],
          ),
        ),
        _OnboardingPageData(
          title: l10n.onboardingPage2Title,
          subtitle: l10n.onboardingPage2Subtitle,
          icon: Icons.insights_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF40916C), Color(0xFF2D6A4F)],
          ),
        ),
        _OnboardingPageData(
          title: l10n.onboardingPage3Title,
          subtitle: l10n.onboardingPage3Subtitle,
          icon: Icons.psychology_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF0077B6), Color(0xFF023E8A)],
          ),
        ),
        _OnboardingPageData(
          title: l10n.onboardingPage4Title,
          subtitle: l10n.onboardingPage4Subtitle,
          icon: Icons.eco_rounded,
          gradient: AppColors.primaryGradient,
        ),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(int pageCount) {
    if (_currentPage < pageCount - 1) {
      _pageController.nextPage(
        duration: AppConstants.animationNormal,
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.go(AppRoutes.register);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = _pages(l10n);
    final theme = Theme.of(context);
    final isLastPage = _currentPage == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go(AppRoutes.login),
                child: Text(
                  l10n.skip,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return _OnboardingPage(
                    data: page,
                    isActive: index == _currentPage,
                  );
                },
              ),
            ),
            Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: pages.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.outline,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: isLastPage ? l10n.getStarted : l10n.next,
                    onPressed: () => _nextPage(pages.length),
                    icon: isLastPage ? Icons.arrow_forward_rounded : null,
                  ),
                  if (!isLastPage) ...[
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: Text(l10n.alreadyHaveAccountLogin),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.data,
    required this.isActive,
  });

  final _OnboardingPageData data;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isActive)
            StoryIllustration(
              icon: data.icon,
              gradient: data.gradient,
              size: 220,
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(
                  begin: const Offset(0.85, 0.85),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                ),
          const SizedBox(height: AppSpacing.xxl),
          if (isActive)
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium,
            )
                .animate()
                .fadeIn(delay: 150.ms, duration: 400.ms)
                .slideY(begin: 0.2, end: 0),
          const SizedBox(height: AppSpacing.md),
          if (isActive)
            Text(
              data.subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 400.ms)
                .slideY(begin: 0.15, end: 0),
        ],
      ),
    );
  }
}
