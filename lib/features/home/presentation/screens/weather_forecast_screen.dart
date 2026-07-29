import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              Text('Looking at today\'s sky...'),
            ],
          ),
        ),
        error: (e, _) => Center(child: Text('Weather unavailable: $e')),
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
              'Extended Forecast',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            if (weather.forecast.isEmpty)
              const Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Text(
                    'Detailed 15-day forecast will appear here once '
                    'connected to your location data.',
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
