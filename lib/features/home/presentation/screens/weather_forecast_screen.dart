import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/widgets/cards/weather_card.dart';

/// 15-day weather forecast screen.
class WeatherForecastScreen extends ConsumerWidget {
  const WeatherForecastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(homeWeatherProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Weather Forecast')),
      body: weatherAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: AppSpacing.md),
              Text("Looking at today's sky..."),
            ],
          ),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off_outlined, size: 48),
                const SizedBox(height: AppSpacing.md),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () => context.push(AppRoutes.profileEdit),
                  child: const Text('Update Location in Profile'),
                ),
              ],
            ),
          ),
        ),
        data: (weather) => ListView(
          padding: AppSpacing.screenPadding,
          children: [
            WeatherCard(
              temperature: weather.temperature,
              condition: weather.condition,
              location: weather.location,
              humidity: weather.humidity,
              windSpeed: weather.windSpeed,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '15-Day Extended Forecast',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            if (weather.forecast.isEmpty)
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Forecast data is loading from your location. '
                        'If this persists, ensure your profile has GPS coordinates set.',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton(
                        onPressed: () => ref.invalidate(homeWeatherProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...weather.forecast.map(
                (day) => Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: Text(day.date),
                    subtitle: Text(day.condition),
                    trailing: Text('${day.high} / ${day.low}'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
