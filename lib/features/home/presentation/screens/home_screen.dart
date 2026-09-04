import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cropdoc/core/routes/app_routes.dart';
import 'package:cropdoc/core/theme/app_colors.dart';
import 'package:cropdoc/core/theme/app_spacing.dart';
import 'package:cropdoc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cropdoc/features/home/data/local_farm_storage.dart';
import 'package:cropdoc/features/home/domain/entities/home_entities.dart';
import 'package:cropdoc/features/home/domain/quick_actions.dart';
import 'package:cropdoc/features/home/presentation/controllers/home_providers.dart';
import 'package:cropdoc/features/home/presentation/widgets/home_widgets.dart';
import 'package:cropdoc/l10n/app_localizations.dart';
import 'package:cropdoc/widgets/ads/home_ad_banner.dart';
import 'package:cropdoc/widgets/common/app_logo.dart';

/// Main home screen.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: ref
            .watch(currentUserProvider)
            .when(
              loading:
                  () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
              error:
                  (_, __) => _HomeBody(
                    l10n: l10n,
                    greeting: l10n.dashboardGreeting(
                      _timeOfDay(l10n),
                      l10n.defaultFarmerName,
                    ),
                    weatherAsync: ref.watch(homeWeatherProvider),
                    cropsAsync: ref.watch(farmCropsProvider),
                  ),
              data:
                  (user) => _HomeBody(
                    l10n: l10n,
                    greeting: l10n.dashboardGreeting(
                      _timeOfDay(l10n),
                      _firstName(user?.fullName, l10n),
                    ),
                    weatherAsync: ref.watch(homeWeatherProvider),
                    cropsAsync: ref.watch(farmCropsProvider),
                    location: user?.location,
                  ),
            ),
      ),
    );
  }

  String _timeOfDay(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.morning;
    if (hour < 17) return l10n.afternoon;
    return l10n.evening;
  }

  String _firstName(String? name, AppLocalizations l10n) {
    if (name == null || name.isEmpty) return l10n.defaultFarmerName;
    return name.split(' ').first;
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.l10n,
    required this.greeting,
    required this.weatherAsync,
    required this.cropsAsync,
    this.location,
  });

  final AppLocalizations l10n;
  final String greeting;
  final AsyncValue<WeatherSummary> weatherAsync;
  final AsyncValue<List<FarmCrop>> cropsAsync;
  final String? location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final crops = cropsAsync.valueOrNull ?? [];
    final primaryCrop = crops.isNotEmpty ? crops.first : null;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                            location ?? l10n.appTagline,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const KrishidnyaLogo(size: 44, animate: false),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                HomeBannerCarousel(
                  items: [
                    PromoBanner(
                      title: l10n.governmentSchemes,
                      subtitle: l10n.schemesSubtitle,
                      icon: Icons.account_balance_rounded,
                      gradient: AppColors.primaryGradient,
                      onTap: () => context.push(AppRoutes.schemes),
                    ),
                    _WeatherBanner(
                      l10n: l10n,
                      weatherAsync: weatherAsync,
                      onTap: () => context.push(AppRoutes.weatherForecast),
                    ),
                    HomeAdBanner(
                      onFallbackTap: () => context.push(AppRoutes.marketplace),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _InsightCard(
                  title: l10n.farmStatus,
                  subtitle:
                      crops.isEmpty
                          ? l10n.noCropsTracked
                          : l10n.cropsTracked(crops.length),
                  icon: Icons.agriculture_rounded,
                  loading: cropsAsync.isLoading,
                  loadingText: l10n.checkingCropHealth,
                ),
                const SizedBox(height: AppSpacing.sm),
                _InsightCard(
                  title: l10n.cropStage,
                  subtitle:
                      primaryCrop != null
                          ? primaryCrop.name
                          : l10n.addCropsHint,
                  icon: Icons.eco_rounded,
                  loading: false,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.recommendations, style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xxs),
                Text(l10n.quickActions, style: theme.textTheme.bodySmall),
                const SizedBox(height: AppSpacing.md),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 0.85,
                  children:
                      QuickActions.items(l10n).map((action) {
                        return QuickActionTile(
                          title: action.title,
                          subtitle: action.subtitle,
                          icon: action.icon,
                          color: action.color,
                          onTap: () => context.push(action.route),
                        );
                      }).toList(),
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

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.loading,
    this.loadingText,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool loading;
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading:
            loading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(loading ? (loadingText ?? subtitle) : subtitle),
      ),
    );
  }
}

class _WeatherBanner extends StatelessWidget {
  const _WeatherBanner({
    required this.l10n,
    required this.weatherAsync,
    required this.onTap,
  });

  final AppLocalizations l10n;
  final AsyncValue<WeatherSummary> weatherAsync;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return weatherAsync.when(
      loading:
          () => PromoBanner(
            title: l10n.todaysWeather,
            subtitle: l10n.checkingSky,
            icon: Icons.wb_cloudy_outlined,
            gradient: AppColors.skyGradient,
            onTap: onTap,
          ),
      error:
          (_, __) => PromoBanner(
            title: l10n.todaysWeather,
            subtitle: l10n.tapToViewForecast,
            icon: Icons.wb_sunny_rounded,
            gradient: AppColors.skyGradient,
            onTap: onTap,
          ),
      data:
          (weather) => PromoBanner(
            title: '${weather.temperature} · ${weather.condition}',
            subtitle: weather.location,
            icon: Icons.wb_sunny_rounded,
            gradient: AppColors.skyGradient,
            onTap: onTap,
          ),
    );
  }
}
