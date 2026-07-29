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
import 'package:krishidnya/features/auth/presentation/screens/register_screen.dart';
import 'package:krishidnya/features/auth/presentation/screens/registration_journey_screens.dart';
import 'package:krishidnya/widgets/common/app_logo.dart';
import 'package:krishidnya/widgets/navigation/main_shell.dart';

/// GoRouter configuration with auth-aware redirects.
final routerProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authStatusProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
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

      if (isAuthenticated && isAuthRoute && location != AppRoutes.splash) {
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
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStatusProvider, (prev, next) {
      if (next.hasValue) {
        final router = ref.read(routerProvider);
        if (next.value ?? false) {
          router.go(AppRoutes.dashboard);
        } else {
          router.go(AppRoutes.onboarding);
        }
      }
    });

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
