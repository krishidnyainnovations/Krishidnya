/// API configuration — base URL and endpoint paths only.
abstract final class ApiConfig {
  /// Production backend entrypoint.
  /// Override via --dart-define=API_BASE_URL=...
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://13.200.235.31',
  );

  // Auth
  static const String register = '/register';
  static const String token = '/token';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';

  // User
  static const String currentUser = '/users/me';
  static const String updateUser = '/users/me';
  static const String updateLocation = '/users/me/location';
  static const String nearbyUsers = '/users/nearby';

  // Weather
  static const String weather = '/api/weather';
  static const String weatherBatch = '/api/weather/batch';

  // Posts & Social
  static const String posts = '/posts';

  // Marketplace
  static const String products = '/api/products';

  // Schemes
  static const String schemes = '/api/schemes/';
  static const String schemeInterests = '/api/scheme-interests/';

  // AI & External
  static const String scanCrop = '/scan-crop';
  static const String chat = '/api/chat';
  static const String cropPrices = '/api/crop-prices';

  // Notifications
  static const String notifications = '/notifications';

  // Health
  static const String health = '/health';
  static const String servicesHealth = '/api/services/health';
}
// C:\Users\Krishidnya\Projects\krishidnya\lib\core\api\api_config.dart