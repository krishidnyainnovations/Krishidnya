import 'package:flutter/material.dart';
import 'package:cropdoc/core/routes/app_routes.dart';
import 'package:cropdoc/core/theme/app_colors.dart';
import 'package:cropdoc/l10n/app_localizations.dart';

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
  static List<QuickActionItem> items(AppLocalizations l10n) => [
        QuickActionItem(
          id: 'crop_recommendation',
          title: l10n.cropRecommendation,
          subtitle: l10n.cropRecommendationSubtitle,
          icon: Icons.eco_rounded,
          color: AppColors.primary,
          route: AppRoutes.cropRecommendation,
        ),
        QuickActionItem(
          id: 'scan_crop',
          title: l10n.scanCrop,
          subtitle: l10n.scanCropSubtitle,
          icon: Icons.document_scanner_outlined,
          color: AppColors.error,
          route: AppRoutes.scanCrop,
        ),
        QuickActionItem(
          id: 'marketplace',
          title: l10n.marketplace,
          subtitle: l10n.marketplaceSubtitle,
          icon: Icons.storefront_outlined,
          color: AppColors.secondary,
          route: AppRoutes.marketplace,
        ),
        QuickActionItem(
          id: 'history',
          title: l10n.viewHistory,
          subtitle: l10n.viewHistorySubtitle,
          icon: Icons.history_rounded,
          color: AppColors.accent,
          route: AppRoutes.history,
        ),
        QuickActionItem(
          id: 'mandi_prices',
          title: l10n.mandiPrices,
          subtitle: l10n.mandiPricesSubtitle,
          icon: Icons.trending_up_rounded,
          color: const Color(0xFFE9C46A),
          route: AppRoutes.mandiPrices,
        ),
        QuickActionItem(
          id: 'analytics',
          title: l10n.analytics,
          subtitle: l10n.analyticsSubtitle,
          icon: Icons.analytics_outlined,
          color: const Color(0xFF6A4C93),
          route: AppRoutes.analytics,
        ),
      ];
}
