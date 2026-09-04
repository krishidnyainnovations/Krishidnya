import 'package:flutter/material.dart';
import 'package:cropdoc/core/theme/app_colors.dart';
import 'package:cropdoc/core/theme/app_spacing.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading placeholder for cards and lists.
class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({
    super.key,
    this.height = 120,
    this.width,
    this.borderRadius = 20,
  });

  final double height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant;
    final highlightColor = isDark ? AppColors.darkSurface : AppColors.surface;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Full-screen shimmer layout for dashboard loading.
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoader(height: 32, width: 200),
          SizedBox(height: AppSpacing.lg),
          ShimmerLoader(height: 160),
          SizedBox(height: AppSpacing.md),
          ShimmerLoader(),
          SizedBox(height: AppSpacing.md),
          ShimmerLoader(),
        ],
      ),
    );
  }
}
