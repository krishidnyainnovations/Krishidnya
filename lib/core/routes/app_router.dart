import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/constants/app_constants.dart';
import 'package:krishidnya/core/debug/log_monitor_screen.dart';
import 'package:krishidnya/core/routes/app_routes.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/auth/presentation/screens/login_screen.dart';
import 'package:krishidnya/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:krishidnya/features/auth/presentation/screens/otp_login_screen.dart';
import 'package:krishidnya/features/auth/presentation/screens/profile_edit_screen.dart';
import 'package:krishidnya/features/auth/presentation/screens/register_screen.dart';
import 'package:krishidnya/features/auth/presentation/screens/registration_journey_screens.dart';
import 'package:krishidnya/features/home/presentation/screens/feature_screens.dart';
import 'package:krishidnya/features/home/presentation/screens/nearby_farmers_screen.dart';
import 'package:krishidnya/features/home/presentation/screens/notifications_screen.dart';
import 'package:krishidnya/features/home/presentation/screens/scheme_detail_screen.dart';
import 'package:krishidnya/features/home/presentation/screens/schemes_screen.dart';
import 'package:krishidnya/features/home/presentation/screens/settings_screen.dart';
import 'package:krishidnya/features/home/presentation/screens/social_screens.dart';
import 'package:krishidnya/features/home/presentation/screens/weather_forecast_screen.dart';
import 'package:krishidnya/widgets/common/app_logo.dart';
import 'package:krishidnya/widgets/navigation/main_shell.dart';

/// Keeps GoRouter alive while re-running redirects on auth changes.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authStatusProvider, (_, __) => notifyListeners());
  }
}

final _routerRefreshNotifierProvider = Provider<_RouterRefreshNotifier>((ref) {
  final notifier = _RouterRefreshNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});

/// GoRouter configuration with auth-aware redirects.
final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(_routerRefreshNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authStatus = ref.read(authStatusProvider);
      final isAuthenticated = authStatus.valueOrNull ?? false;
      final location = state.matchedLocation;

      final isAuthRoute = location == AppRoutes.login ||
          location == AppRoutes.register ||
          location.startsWith('/register') ||
          location == AppRoutes.onboarding ||
          location == AppRoutes.splash;

      final isDebugRoute = location == AppRoutes.logMonitor;

      if (location == AppRoutes.splash) {
        if (authStatus.isLoading) return null;
        return isAuthenticated ? AppRoutes.dashboard : AppRoutes.onboarding;
      }

      if (isDebugRoute) return null;

      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.onboarding;
      }

      if (isAuthenticated &&
          isAuthRoute &&
          location != AppRoutes.splash &&
          location != AppRoutes.registerSuccess) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.otpLogin,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const OtpLoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerLocationPermission,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const LocationPermissionScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerLocationLoading,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const LocationLoadingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerLocationFound,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const LocationFoundScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerAlmostReady,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const AlmostReadyScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerSuccess,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const RegisterSuccessScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainShell(child: SizedBox.shrink()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.logMonitor,
        builder: (context, state) => const LogMonitorScreen(),
      ),
      GoRoute(
        path: AppRoutes.schemes,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const SchemesScreen(),
        ),
      ),
      GoRoute(
        path: '/schemes/:id',
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          SchemeDetailScreen(
            schemeId: int.parse(state.pathParameters['id']!),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.chat,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const ChatScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.community,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const CommunityScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profileEdit,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const ProfileEditScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.nearbyFarmers,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const NearbyFarmersScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.weatherForecast,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const WeatherForecastScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.cropRecommendation,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const CropRecommendationScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.scanCrop,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const ScanCropFeatureScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.marketplace,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const MarketplaceScreen(),
        ),
      ),
      GoRoute(
        path: '/marketplace/:id',
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          ProductDetailScreen(
            productId: int.parse(state.pathParameters['id']!),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.history,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const HistoryScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.mandiPrices,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const MandiPricesScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.analytics,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const AnalyticsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) => _sharedAxisPage(
          state,
          const SettingsScreen(),
        ),
      ),
    ],
  );
});

CustomTransitionPage<void> _sharedAxisPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: AppConstants.animationNormal,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.05, 0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: Curves.easeOutCubic),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

/// Splash screen with animated logo while checking auth.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KrishidnyaLogo(size: 100),
              SizedBox(height: 24),
              Text(
                AppConstants.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                AppConstants.appTagline,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
