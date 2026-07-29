import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishidnya/core/network/api_client.dart';
import 'package:krishidnya/core/services/app_logger.dart';
import 'package:krishidnya/core/services/location_service.dart';
import 'package:krishidnya/core/storage/preferences_service.dart';
import 'package:krishidnya/core/storage/secure_storage_service.dart';
import 'package:krishidnya/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:krishidnya/features/auth/data/repositories/auth_repository_impl.dart';

/// Global app logger with in-memory monitoring buffer.
final appLoggerProvider = Provider<AppLogger>((ref) => AppLogger.instance);

/// Secure storage provider.
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Shared preferences provider.
final preferencesProvider = FutureProvider<PreferencesService>((ref) async {
  return PreferencesService.create();
});

/// API client provider.
final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final logger = ref.watch(appLoggerProvider);
  return ApiClient(storage: storage, logger: logger);
});

/// Location service provider.
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Auth remote data source provider.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    apiClient: ref.watch(apiClientProvider),
    storage: ref.watch(secureStorageProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

/// Auth repository provider.
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

/// Reactive log entries for the debug monitor UI.
final logEntriesProvider =
    StateNotifierProvider<LogMonitorController, List<LogEntry>>((ref) {
  final logger = ref.watch(appLoggerProvider);
  return LogMonitorController(logger);
});

/// Controls the in-app log monitor list.
class LogMonitorController extends StateNotifier<List<LogEntry>> {
  LogMonitorController(this._logger) : super(_logger.entries) {
    _logger.addListener(_sync);
  }

  final AppLogger _logger;

  void _sync() => state = _logger.entries;

  void clear() {
    _logger.clear();
    state = _logger.entries;
  }

  @override
  void dispose() {
    _logger.removeListener(_sync);
    super.dispose();
  }
}
