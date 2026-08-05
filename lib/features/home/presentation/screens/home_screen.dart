import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/domain/entities/home_entities.dart';
import 'package:krishidnya/features/home/domain/quick_actions.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/features/home/presentation/widgets/home_widgets.dart';
import 'package:krishidnya/widgets/ads/home_ad_banner.dart';
import 'package:krishidnya/widgets/common/app_logo.dart';

/// Main home screen with banners and quick actions.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  String _firstName(String? name) {
    if (name == null || name.isEmpty) return 'Farmer';
    return name.split(' ').first;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final weatherAsync = ref.watch(homeWeatherProvider);

    return Scaffold(
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => _HomeBody(
            greeting: 'Good ${_greeting()}, Farmer',
            weatherAsync: weatherAsync,
          ),
          data: (user) => _HomeBody(
            greeting: 'Good ${_greeting()}, ${_firstName(user?.fullName)}',
            weatherAsync: weatherAsync,
            location: user?.location,
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.greeting,
    required this.weatherAsync,
    this.location,
  });

  final String greeting;
  final AsyncValue<WeatherSummary> weatherAsync;
  final String? location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StaggeredFadeIn(
                  index: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              location ?? 'Your trusted farming companion',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const KrishidnyaLogo(size: 44, animate: false),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                StaggeredFadeIn(
                  index: 1,
                  child: HomeBannerCarousel(
                    items: [
                      PromoBanner(
                        title: 'Government Schemes',
                        subtitle: 'Benefits designed for farmers like you',
                        icon: Icons.account_balance_rounded,
                        gradient: AppColors.primaryGradient,
                        onTap: () => context.push(AppRoutes.schemes),
                      ),
                      _WeatherBanner(
                        weatherAsync: weatherAsync,
                        onTap: () => context.push(AppRoutes.weatherForecast),
                      ),
                      StaggeredFadeIn(
                        index: 2,
                        child: HomeAdBanner(
                          onFallbackTap: () => context.push(AppRoutes.marketplace),
                        ),
                      ),
                    ],
                  ),
                ),
                StaggeredFadeIn(
                  index: 2,
                  child: Text(
                    'Quick Actions',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                StaggeredFadeIn(
                  index: 3,
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 0.85,
                    children: QuickActions.items.map((action) {
                      return QuickActionTile(
                        title: action.title,
                        subtitle: action.subtitle,
                        icon: action.icon,
                        color: action.color,
                        onTap: () => context.push(action.route),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WeatherBanner extends StatelessWidget {
  const _WeatherBanner({
    required this.weatherAsync,
    required this.onTap,
  });

  final AsyncValue<WeatherSummary> weatherAsync;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return weatherAsync.when(
      loading: () => PromoBanner(
        title: "Today's Weather",
        subtitle: "Looking at today's sky...",
        icon: Icons.wb_cloudy_outlined,
        gradient: AppColors.skyGradient,
        onTap: onTap,
      ),
      error: (_, __) => PromoBanner(
        title: "Today's Weather",
        subtitle: 'Tap to view forecast',
        icon: Icons.wb_sunny_rounded,
        gradient: AppColors.skyGradient,
        onTap: onTap,
      ),
      data: (weather) => PromoBanner(
        title: '${weather.temperature} · ${weather.condition}',
        subtitle: weather.location,
        icon: Icons.wb_sunny_rounded,
        gradient: AppColors.skyGradient,
        onTap: onTap,
      ),
    );
  }
}
