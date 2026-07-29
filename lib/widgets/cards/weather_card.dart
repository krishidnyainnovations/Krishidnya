import 'package:flutter/material.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/widgets/common/app_logo.dart';

/// Weather summary card for dashboard.
class WeatherCard extends StatelessWidget {
  const WeatherCard({
    required this.temperature,
    required this.condition,
    required this.location,
    super.key,
    this.humidity,
    this.windSpeed,
  });

  final String temperature;
  final String condition;
  final String location;
  final String? humidity;
  final String? windSpeed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      gradient: AppColors.skyGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    condition,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.wb_sunny_rounded,
                size: 48,
                color: AppColors.secondary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            temperature,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          if (humidity != null || windSpeed != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                if (humidity != null) ...[
                  const Icon(Icons.water_drop_outlined,
                      size: 16, color: AppColors.accent),
                  const SizedBox(width: 4),
                  Text(humidity!, style: theme.textTheme.bodySmall),
                  const SizedBox(width: AppSpacing.md),
                ],
                if (windSpeed != null) ...[
                  const Icon(Icons.air_outlined,
                      size: 16, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(windSpeed!, style: theme.textTheme.bodySmall),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
