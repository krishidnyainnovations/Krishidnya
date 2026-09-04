/// Named route paths for GoRouter.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String registerLocationPermission =
      '/register/location-permission';
  static const String registerLocationLoading = '/register/location-loading';
  static const String registerLocationFound = '/register/location-found';
  static const String registerAlmostReady = '/register/almost-ready';
  static const String registerSuccess = '/register/success';
  static const String dashboard = '/dashboard';
  static const String logMonitor = '/debug/logs';

  // Home feature routes
  static const String schemes = '/schemes';
  static const String schemeDetail = '/schemes/:id';
  static const String weatherForecast = '/weather/forecast';
  static const String cropRecommendation = '/crop-recommendation';
  static const String scanCrop = '/scan-crop';
  static const String marketplace = '/marketplace';
  static const String history = '/history';
  static const String mandiPrices = '/mandi-prices';
  static const String analytics = '/analytics';
  static const String chat = '/chat';
  static const String community = '/community';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String profileEdit = '/profile/edit';
  static const String notifications = '/notifications';
  static const String nearbyFarmers = '/community/nearby';
  static const String productDetail = '/marketplace/:id';
}
