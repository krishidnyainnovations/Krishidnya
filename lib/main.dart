import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cropdoc/core/api/api_config.dart';
import 'package:cropdoc/core/config/providers.dart';
import 'package:cropdoc/core/l10n/locale_config.dart';
import 'package:cropdoc/core/routes/app_router.dart';
import 'package:cropdoc/core/services/app_logger.dart';
import 'package:cropdoc/core/theme/app_theme.dart';
import 'package:cropdoc/features/home/presentation/controllers/home_providers.dart';
import 'package:cropdoc/l10n/app_localizations.dart';
import 'package:cropdoc/widgets/ads/home_ad_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = AppLogger.instance;
  logger.info('App', 'CropDoc starting');
  logger.info('App', 'Backend → ${ApiConfig.baseUrl}');

  // Defer AdMob initialization to avoid blocking startup
  // It will be initialized in background after app renders
  Future.microtask(() async {
    try {
      await initializeMobileAds();
    } catch (e, st) {
      logger.warning('App', 'AdMob init skipped', details: e.toString());
      logger.error('App', 'AdMob init error', error: e, stackTrace: st);
    }
  });

  // Wrap app in error boundary to catch initialization errors
  runApp(
    ProviderScope(
      observers: [_ProviderErrorLogger(logger)],
      child: const KrishidnyaApp(),
    ),
  );
}

/// Logs provider errors to prevent silent crashes
class _ProviderErrorLogger extends ProviderObserver {
  _ProviderErrorLogger(this.logger);

  final AppLogger logger;

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    logger.error(
      'Provider',
      'Provider failed: ${provider.name ?? provider.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Root application widget.
class KrishidnyaApp extends ConsumerStatefulWidget {
  const KrishidnyaApp({super.key});

  @override
  ConsumerState<KrishidnyaApp> createState() => _KrishidnyaAppState();
}

class _KrishidnyaAppState extends ConsumerState<KrishidnyaApp> {
  @override
  void initState() {
    super.initState();
    // Defer health check to avoid blocking app startup
    Future.microtask(_checkBackendHealth);
  }

  Future<void> _checkBackendHealth() async {
    final logger = ref.read(appLoggerProvider);
    try {
      final client = ref.read(apiClientProvider);
      final response = await client.get<Map<String, dynamic>>('/health');
      logger.info(
        'App',
        'Backend health check OK',
        details: response.data.toString(),
      );
    } catch (e, st) {
      logger.error(
        'App',
        'Backend health check failed',
        details: 'Could not reach ${ApiConfig.baseUrl}/health',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final router = ref.watch(routerProvider);
      final locale = ref.watch(appLocaleProvider);
      final isRtl = AppLanguages.isRtl(locale);

      return MaterialApp.router(
        title: 'Krishidnya',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          return Directionality(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: child ?? const SizedBox.shrink(),
          );
        },
        routerConfig: router,
      );
    } catch (e, st) {
      final logger = ref.read(appLoggerProvider);
      logger.error('App', 'Failed to build app', error: e, stackTrace: st);
      // Fallback to minimal error screen
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('App initialization failed'),
                const SizedBox(height: 8),
                Text(
                  'Error: ${e.toString()}',
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
