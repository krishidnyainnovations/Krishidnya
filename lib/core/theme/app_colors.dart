import 'package:flutter/material.dart';

/// Nature-inspired color palette for Krishidnya.
abstract final class AppColors {
  // Primary — Forest Green
  static const Color primary = Color(0xFF2D6A4F);
  static const Color primaryLight = Color(0xFF40916C);
  static const Color primaryDark = Color(0xFF1B4332);
  static const Color primaryContainer = Color(0xFFD8F3DC);

  // Secondary — Earth Brown
  static const Color secondary = Color(0xFF8B6914);
  static const Color secondaryLight = Color(0xFFD4A843);
  static const Color secondaryContainer = Color(0xFFFFF3CD);

  // Accent — Sky Blue
  static const Color accent = Color(0xFF0077B6);
  static const Color accentLight = Color(0xFF90E0EF);
  static const Color accentContainer = Color(0xFFCAF0F8);

  // Neutral
  static const Color background = Color(0xFFF8FAF5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5EE);
  static const Color outline = Color(0xFFD4E2D4);

  // Text
  static const Color textPrimary = Color(0xFF1A2E1A);
  static const Color textSecondary = Color(0xFF5C6B5C);
  static const Color textTertiary = Color(0xFF8A9A8A);

  // Semantic
  static const Color success = Color(0xFF2D6A4F);
  static const Color warning = Color(0xFFE9C46A);
  static const Color error = Color(0xFFE76F51);
  static const Color info = Color(0xFF0077B6);

  // Dark mode
  static const Color darkBackground = Color(0xFF0F1A0F);
  static const Color darkSurface = Color(0xFF1A2E1A);
  static const Color darkSurfaceVariant = Color(0xFF243524);
  static const Color darkTextPrimary = Color(0xFFF0F4F0);
  static const Color darkTextSecondary = Color(0xFFB0C4B0);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary, primaryDark],
  );

  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF90E0EF), Color(0xFFCAF0F8), background],
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE9C46A), Color(0xFFE76F51), primaryDark],
  );
}
