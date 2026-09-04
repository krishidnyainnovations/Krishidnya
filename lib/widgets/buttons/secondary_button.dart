import 'package:flutter/material.dart';
import 'package:cropdoc/core/theme/app_colors.dart';
import 'package:cropdoc/core/theme/app_spacing.dart';

/// Secondary text-style button for less prominent actions.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonRadius,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(label),
        ],
      ),
    );
  }
}
