import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishidnya/core/api/api_config.dart';
import 'package:krishidnya/core/config/providers.dart';
import 'package:krishidnya/core/routes/app_router.dart';
import 'package:krishidnya/core/services/app_logger.dart';
import 'package:krishidnya/core/theme/app_theme.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/l10n/app_localizations.dart';
import 'package:krishidnya/widgets/ads/home_ad_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = AppLogger.instance;
  logger.info('App', 'Krishidnya starting');
  logger.info('App', 'Backend → ${ApiConfig.baseUrl}');

  try {
    await initializeMobileAds();
  } catch (e, st) {
    logger.warning('App', 'AdMob init skipped', details: e.toString());
    logger.error('App', 'AdMob init error', error: e, stackTrace: st);
  }

  runApp(const ProviderScope(child: KrishidnyaApp()));
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
    _checkBackendHealth();
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
    final router = ref.watch(routerProvider);
    final locale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: 'Krishidnya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
