import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishidnya/core/api/api_config.dart';
import 'package:krishidnya/core/config/providers.dart';
import 'package:krishidnya/core/routes/app_router.dart';
import 'package:krishidnya/core/services/app_logger.dart';
import 'package:krishidnya/core/theme/app_theme.dart';
import 'package:krishidnya/l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = AppLogger.instance;
  logger.info('App', 'Krishidnya starting');
  logger.info('App', 'Backend → ${ApiConfig.baseUrl}');

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

    return MaterialApp.router(
      title: 'Krishidnya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
