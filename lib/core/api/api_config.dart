/// API configuration — base URL and endpoint paths only.
abstract final class ApiConfig {
  /// Production backend entrypoint.
  /// Override via --dart-define=API_BASE_URL=...
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://coyness-hastily-enjoyably.ngrok-free.dev',
  );

  /// AdMob banner unit — use test ID in debug.
  static const String admobBannerUnitId = String.fromEnvironment(
    'ADMOB_BANNER_ID',
    defaultValue: 'ca-app-pub-3940256099942544/6300978111',
  );

  // Auth
  static const String register = '/register';
  static const String token = '/token';

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
  static String postLike(int id) => '/posts/$id/like';
  static String postComments(int id) => '/posts/$id/comments';

  // Marketplace
  static const String products = '/api/products';

  // Schemes
  static const String schemes = '/api/schemes/';
  static String schemeDetail(int id) => '/api/schemes/$id';
  static const String schemeInterests = '/api/scheme-interests/';

  // Farm sync
  static const String farmCrops = '/api/farm/crops';

  // Soil
  static const String soil = '/api/soil';

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
