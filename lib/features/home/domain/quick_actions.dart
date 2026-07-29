import 'package:flutter/material.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';

/// Quick action definition for home grid.
class QuickActionItem {
  const QuickActionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
}

/// All quick actions shown on the home screen (3×2 grid).
abstract final class QuickActions {
  static const items = [
    QuickActionItem(
      id: 'crop_recommendation',
      title: 'Crop Recommendation',
      subtitle: 'AI-powered crop picks',
      icon: Icons.eco_rounded,
      color: AppColors.primary,
      route: AppRoutes.cropRecommendation,
    ),
    QuickActionItem(
      id: 'scan_crop',
      title: 'Scan Crop',
      subtitle: 'Detect diseases early',
      icon: Icons.document_scanner_outlined,
      color: AppColors.error,
      route: AppRoutes.scanCrop,
    ),
    QuickActionItem(
      id: 'marketplace',
      title: 'Marketplace',
      subtitle: 'Buy, sell & rent',
      icon: Icons.storefront_outlined,
      color: AppColors.secondary,
      route: AppRoutes.marketplace,
    ),
    QuickActionItem(
      id: 'history',
      title: 'View History',
      subtitle: 'Crop & soil records',
      icon: Icons.history_rounded,
      color: AppColors.accent,
      route: AppRoutes.history,
    ),
    QuickActionItem(
      id: 'mandi_prices',
      title: 'Mandi Prices',
      subtitle: 'Daily market rates',
      icon: Icons.trending_up_rounded,
      color: Color(0xFFE9C46A),
      route: AppRoutes.mandiPrices,
    ),
    QuickActionItem(
      id: 'analytics',
      title: 'Analytics',
      subtitle: 'Farm expense tracker',
      icon: Icons.analytics_outlined,
      color: Color(0xFF6A4C93),
      route: AppRoutes.analytics,
    ),
  ];
}
