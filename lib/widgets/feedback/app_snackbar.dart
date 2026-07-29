import 'package:flutter/material.dart';
import 'package:krishidnya/core/theme/app_colors.dart';

/// Styled snackbar helpers with storytelling-friendly defaults.
abstract final class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarAction? action,
    Color? backgroundColor,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 12),
              ],
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: backgroundColor ?? AppColors.textPrimary,
          behavior: SnackBarBehavior.floating,
          action: action,
        ),
      );
  }

  static void success(BuildContext context, String message) => show(
        context,
        message: message,
        backgroundColor: AppColors.success,
        icon: Icons.check_circle_outline,
      );

  static void error(BuildContext context, String message) => show(
        context,
        message: message,
        backgroundColor: AppColors.error,
        icon: Icons.error_outline,
      );

  static void info(BuildContext context, String message) => show(
        context,
        message: message,
        backgroundColor: AppColors.accent,
        icon: Icons.info_outline,
      );
}
