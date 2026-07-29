import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/widgets/cards/farm_card.dart';
import 'package:krishidnya/widgets/cards/weather_card.dart';
import 'package:krishidnya/widgets/common/app_logo.dart';

/// Dashboard with progressive staggered content reveal.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _timeOfDayGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  String _firstName(String? fullName) {
    if (fullName == null || fullName.isEmpty) return 'Farmer';
    return fullName.split(' ').first;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => _DashboardContent(
            greeting: 'Good ${_timeOfDayGreeting()}, Farmer',
          ),
          data: (user) => _DashboardContent(
            greeting:
                'Good ${_timeOfDayGreeting()}, ${_firstName(user?.fullName)}',
            location: user?.city ?? user?.location,
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.greeting,
    this.location,
  });

  final String greeting;
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
                              "Here's what's happening on your farm today",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const KrishidnyaLogo(size: 44, animate: false),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                StaggeredFadeIn(
                  index: 1,
                  child: WeatherCard(
                    temperature: '32°C',
                    condition: 'Partly Cloudy',
                    location: location ?? 'Your Farm',
                    humidity: '65%',
                    windSpeed: '12 km/h',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                StaggeredFadeIn(
                  index: 2,
                  child: Text(
                    'Farm Status',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const StaggeredFadeIn(
                  index: 3,
                  child: FarmCard(
                    farmName: 'Main Field',
                    status: 'All crops healthy',
                    cropCount: 3,
                    healthScore: 92,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                StaggeredFadeIn(
                  index: 4,
                  child: Text(
                    'Crop Stage',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                StaggeredFadeIn(
                  index: 5,
                  child: AppCard(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.grass_rounded,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wheat — Flowering Stage',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: const LinearProgressIndicator(
                                  value: 0.65,
                                  backgroundColor: AppColors.outline,
                                  color: AppColors.primary,
                                  minHeight: 6,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                '65% to harvest',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                StaggeredFadeIn(
                  index: 6,
                  child: Text(
                    'Recommendations',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const StaggeredFadeIn(
                  index: 7,
                  child: RecommendationCard(
                    title: 'Irrigate tomorrow morning',
                    description:
                        'Soil moisture is dropping. Water before 9 AM for best absorption.',
                    icon: Icons.water_drop_outlined,
                    priority: RecommendationPriority.high,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const StaggeredFadeIn(
                  index: 8,
                  child: RecommendationCard(
                    title: 'Monitor for leaf rust',
                    description:
                        'Humid conditions favor rust development in flowering wheat.',
                    icon: Icons.biotech_outlined,
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
