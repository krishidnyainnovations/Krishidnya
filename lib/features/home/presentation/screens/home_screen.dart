import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/data/local_farm_storage.dart';
import 'package:krishidnya/features/home/domain/entities/home_entities.dart';
import 'package:krishidnya/features/home/domain/quick_actions.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/features/home/presentation/widgets/home_widgets.dart';
import 'package:krishidnya/l10n/app_localizations.dart';
import 'package:krishidnya/widgets/ads/home_ad_banner.dart';
import 'package:krishidnya/widgets/common/app_logo.dart';

/// Progressive dashboard stages shown on each visit.
enum _DashboardStage {
  preparing,
  greeting,
  weather,
  farmStatus,
  cropStage,
  recommendations,
}

/// Main home screen with progressive insight loading.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  _DashboardStage _stage = _DashboardStage.preparing;
  Timer? _stageTimer;

  @override
  void initState() {
    super.initState();
    _startProgressiveLoad();
  }

  @override
  void dispose() {
    _stageTimer?.cancel();
    super.dispose();
  }

  void _startProgressiveLoad() {
    const step = Duration(milliseconds: 700);
    var index = 0;
    _stageTimer = Timer.periodic(step, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      index++;
      setState(() {
        _stage = _DashboardStage.values[index.clamp(
          0,
          _DashboardStage.values.length - 1,
        )];
      });
      if (index >= _DashboardStage.values.length - 1) {
        timer.cancel();
      }
    });
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

  bool _isVisible(_DashboardStage required) =>
      _stage.index >= required.index;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userAsync = ref.watch(currentUserProvider);
    final weatherAsync = ref.watch(homeWeatherProvider);
    final cropsAsync = ref.watch(farmCropsProvider);

    if (_stage == _DashboardStage.preparing) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const KrishidnyaLogo(size: 72, animate: true),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.preparingInsights,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                const CircularProgressIndicator(color: AppColors.primary),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => _HomeBody(
            l10n: l10n,
            greeting: l10n.dashboardGreeting(
              _timeOfDay(l10n),
              l10n.defaultFarmerName,
            ),
            weatherAsync: weatherAsync,
            cropsAsync: cropsAsync,
            stage: _stage,
            isVisible: _isVisible,
          ),
          data: (user) => _HomeBody(
            l10n: l10n,
            greeting: l10n.dashboardGreeting(
              _timeOfDay(l10n),
              _firstName(user?.fullName, l10n),
            ),
            weatherAsync: weatherAsync,
            cropsAsync: cropsAsync,
            location: user?.location,
            stage: _stage,
            isVisible: _isVisible,
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.l10n,
    required this.greeting,
    required this.weatherAsync,
    required this.cropsAsync,
    required this.stage,
    required this.isVisible,
    this.location,
  });

  final AppLocalizations l10n;
  final String greeting;
  final AsyncValue<WeatherSummary> weatherAsync;
  final AsyncValue<List<FarmCrop>> cropsAsync;
  final _DashboardStage stage;
  final bool Function(_DashboardStage) isVisible;
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
                _RevealSection(
                  visible: isVisible(_DashboardStage.greeting),
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
                              location ?? l10n.appTagline,
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
                _RevealSection(
                  visible: isVisible(_DashboardStage.weather),
                  child: HomeBannerCarousel(
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
                ),
                if (isVisible(_DashboardStage.farmStatus)) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _InsightCard(
                    title: l10n.farmStatus,
                    subtitle: crops.isEmpty
                        ? l10n.noCropsTracked
                        : l10n.cropsTracked(crops.length),
                    icon: Icons.agriculture_rounded,
                    loading: cropsAsync.isLoading &&
                        stage.index <= _DashboardStage.farmStatus.index,
                    loadingText: l10n.checkingCropHealth,
                  ),
                ],
                if (isVisible(_DashboardStage.cropStage)) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _InsightCard(
                    title: l10n.cropStage,
                    subtitle: primaryCrop != null
                        ? primaryCrop.name
                        : l10n.addCropsHint,
                    icon: Icons.eco_rounded,
                    loading: false,
                  ),
                ],
                if (isVisible(_DashboardStage.recommendations)) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.recommendations,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.quickActions,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 0.85,
                    children: QuickActions.items(l10n).map((action) {
                      return QuickActionTile(
                        title: action.title,
                        subtitle: action.subtitle,
                        icon: action.icon,
                        color: action.color,
                        onTap: () => context.push(action.route),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RevealSection extends StatelessWidget {
  const _RevealSection({required this.visible, required this.child});

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 0.04),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOut,
        child: visible ? child : const SizedBox.shrink(),
      ),
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
        leading: loading
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
      loading: () => PromoBanner(
        title: l10n.todaysWeather,
        subtitle: l10n.checkingSky,
        icon: Icons.wb_cloudy_outlined,
        gradient: AppColors.skyGradient,
        onTap: onTap,
      ),
      error: (_, __) => PromoBanner(
        title: l10n.todaysWeather,
        subtitle: l10n.tapToViewForecast,
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
