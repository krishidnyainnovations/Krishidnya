import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cropdoc/core/routes/app_routes.dart';
import 'package:cropdoc/core/theme/app_colors.dart';
import 'package:cropdoc/core/theme/app_spacing.dart';
import 'package:cropdoc/features/home/presentation/controllers/home_providers.dart';
import 'package:cropdoc/l10n/app_localizations.dart';
import 'package:cropdoc/widgets/cards/weather_card.dart';

/// 15-day weather forecast screen.
class WeatherForecastScreen extends ConsumerWidget {
  const WeatherForecastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final weatherAsync = ref.watch(homeWeatherProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.weatherForecast)),
      body: weatherAsync.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.checkingSky),
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
                  child: Text(l10n.updateLocationInProfile),
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
              l10n.extendedForecast,
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
                      Text(l10n.forecastLoadingHint),
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton(
                        onPressed: () => ref.invalidate(homeWeatherProvider),
                        child: Text(l10n.retry),
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
