/// Application-wide constants.
abstract final class AppConstants {
  static const String appName = 'Krishidnya';
  static const String appTagline = 'Your trusted farming companion';

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String themeModeKey = 'theme_mode';
  static const String localeKey = 'locale';

  // Network
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration chatTimeout = Duration(
    seconds: 60,
  ); // AI responses take longer
  static const Duration imageTimeout = Duration(
    seconds: 45,
  ); // Image processing takes longer
  static const int maxRetryAttempts = 2;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 600);
  static const Duration animationStagger = Duration(milliseconds: 80);

  // Layout
  static const double maxContentWidth = 480;
  static const double minTouchTarget = 48;
}
