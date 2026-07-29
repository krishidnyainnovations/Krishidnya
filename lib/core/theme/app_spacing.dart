import 'package:flutter/material.dart';

/// Consistent spacing scale for premium layouts.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: lg, vertical: md);

  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  static BorderRadius get cardRadius => BorderRadius.circular(20);
  static BorderRadius get buttonRadius => BorderRadius.circular(16);
  static BorderRadius get inputRadius => BorderRadius.circular(16);
}
