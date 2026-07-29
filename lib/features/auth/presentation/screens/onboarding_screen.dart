import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/constants/app_constants.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/widgets/buttons/primary_button.dart';
import 'package:krishidnya/widgets/common/app_logo.dart';
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

  static const _pages = [
    _OnboardingPageData(
      title: 'Every season brings challenges',
      subtitle:
          'Unpredictable weather, crop diseases, and rising costs make farming harder every day.',
      icon: Icons.cloud_off_rounded,
      gradient: LinearGradient(
        colors: [Color(0xFF6B705C), Color(0xFF354F52)],
      ),
    ),
    _OnboardingPageData(
      title: 'Technology can help',
      subtitle:
          'Smart insights and real-time data can turn uncertainty into informed decisions.',
      icon: Icons.insights_rounded,
      gradient: LinearGradient(
        colors: [Color(0xFF40916C), Color(0xFF2D6A4F)],
      ),
    ),
    _OnboardingPageData(
      title: 'AI becomes your partner',
      subtitle:
          'Detect diseases early, track your crops, and get personalized recommendations.',
      icon: Icons.psychology_rounded,
      gradient: LinearGradient(
        colors: [Color(0xFF0077B6), Color(0xFF023E8A)],
      ),
    ),
    _OnboardingPageData(
      title: 'Welcome to Krishidnya',
      subtitle: "Your farm, understood. Let's grow together.",
      icon: Icons.eco_rounded,
      gradient: AppColors.primaryGradient,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
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
    final theme = Theme.of(context);
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go(AppRoutes.login),
                child: Text(
                  'Skip',
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
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
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
                    count: _pages.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.outline,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: isLastPage ? 'Get Started' : 'Next',
                    onPressed: _nextPage,
                    icon: isLastPage ? Icons.arrow_forward_rounded : null,
                  ),
                  if (!isLastPage) ...[
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: const Text('Already have an account? Login'),
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
