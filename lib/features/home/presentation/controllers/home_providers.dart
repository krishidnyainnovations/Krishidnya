import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishidnya/core/config/providers.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/services/local_preferences_service.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/data/home_repository.dart';
import 'package:krishidnya/features/home/data/local_farm_storage.dart';
import 'package:krishidnya/features/home/domain/entities/feature_models.dart';
import 'package:krishidnya/features/home/domain/entities/home_entities.dart';

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSource(
    apiClient: ref.watch(apiClientProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(remote: ref.watch(homeRemoteDataSourceProvider));
});

final localFarmStorageProvider = FutureProvider<LocalFarmStorage>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return LocalFarmStorage(prefs);
});

final chatHistoryServiceProvider = FutureProvider<ChatHistoryService>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return ChatHistoryService(prefs);
});

final mandiPreferencesProvider = FutureProvider<MandiPreferences>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return MandiPreferences(prefs);
});

final notificationPreferencesProvider =
    FutureProvider<NotificationPreferences>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return NotificationPreferences(prefs);
});

final localePreferencesProvider = FutureProvider<LocalePreferences>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return LocalePreferences(prefs);
});

final appLocaleProvider = StateNotifierProvider<AppLocaleNotifier, Locale>((ref) {
  return AppLocaleNotifier(ref);
});

class AppLocaleNotifier extends StateNotifier<Locale> {
  AppLocaleNotifier(this._ref) : super(const Locale('en')) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    final prefs = await _ref.read(localePreferencesProvider.future);
    final code = prefs.getLocaleCode();
    if (code != null) state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await _ref.read(localePreferencesProvider.future);
    await prefs.setLocaleCode(locale.languageCode);
  }
}

final farmCropsProvider = FutureProvider<List<FarmCrop>>((ref) async {
  final storage = await ref.watch(localFarmStorageProvider.future);
  return storage.getCrops();
});

final farmHistoryProvider = FutureProvider<List<HistoryEntry>>((ref) async {
  final storage = await ref.watch(localFarmStorageProvider.future);
  return storage.getUnifiedHistory();
});

final monthlyIncomeProvider = FutureProvider<double>((ref) async {
  final storage = await ref.watch(localFarmStorageProvider.future);
  return storage.monthlyIncome(DateTime.now());
});

final schemesSearchProvider = StateProvider<String>((ref) => '');
final schemesTypeFilterProvider = StateProvider<String?>((ref) => null);

final schemesProvider = FutureProvider<List<Scheme>>((ref) async {
  final search = ref.watch(schemesSearchProvider);
  final type = ref.watch(schemesTypeFilterProvider);
  final result = await ref.watch(homeRepositoryProvider).getSchemes(
        search: search.isEmpty ? null : search,
        type: type,
      );
  return switch (result) {
    Success(:final data) => data,
    ErrorResult(:final failure) => throw failure,
  };
});

final schemeDetailProvider =
    FutureProvider.family<Scheme, int>((ref, id) async {
  final result = await ref.watch(homeRepositoryProvider).getScheme(id);
  return switch (result) {
    Success(:final data) => data,
    ErrorResult(:final failure) => throw failure,
  };
});

final homeWeatherProvider = FutureProvider<WeatherSummary>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user?.latitude == null || user?.longitude == null) {
    throw Exception(
      'Location not set. Update your profile location for weather data.',
    );
  }

  final result = await ref.watch(homeRepositoryProvider).getWeather(
        latitude: user!.latitude!,
        longitude: user.longitude!,
        locationLabel: user.location ?? user.city ?? 'Your Farm',
      );

  return switch (result) {
    Success(:final data) => data,
    ErrorResult(:final failure) => throw failure,
  };
});

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  final result = await ref.watch(homeRepositoryProvider).getProducts(
        state: user?.state,
      );
  return switch (result) {
    Success(:final data) => data,
    ErrorResult(:final failure) => throw failure,
  };
});

final productDetailProvider = FutureProvider.family<Product, int>((ref, id) async {
  final products = await ref.watch(productsProvider.future);
  return products.firstWhere(
    (p) => p.id == id,
    orElse: () => throw StateError('Product #$id not found'),
  );
});

final communityPostsProvider = FutureProvider<List<CommunityPost>>((ref) async {
  final result = await ref.watch(homeRepositoryProvider).getPosts();
  return switch (result) {
    Success(:final data) => data,
    ErrorResult(:final failure) => throw failure,
  };
});

final notificationsProvider =
    FutureProvider<List<AppNotification>>((ref) async {
  final result = await ref.watch(homeRepositoryProvider).getNotifications();
  final readPrefs = await ref.watch(notificationPreferencesProvider.future);
  final readIds = readPrefs.getReadIds();
  return switch (result) {
    Success(:final data) => data
        .map((n) => n.copyWith(isRead: n.isRead || readIds.contains(n.id)))
        .toList(),
    ErrorResult(:final failure) => throw failure,
  };
});

final nearbyFarmersProvider = FutureProvider<List<NearbyFarmer>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  final result = await ref.watch(homeRepositoryProvider).getNearbyUsers(
        latitude: user?.latitude,
        longitude: user?.longitude,
      );
  return switch (result) {
    Success(:final data) => data,
    ErrorResult(:final failure) => throw failure,
  };
});

/// Syncs local farm crops to backend when available.
Future<void> syncFarmData(WidgetRef ref) async {
  final storage = await ref.read(localFarmStorageProvider.future);
  final crops = storage.getCrops();
  final result = await ref.read(homeRepositoryProvider).syncFarmCrops(crops);
  if (result case Success()) {
    final remote = await ref.read(homeRepositoryProvider).fetchRemoteFarmCrops();
    if (remote case Success(:final data) when data.isNotEmpty) {
      await storage.saveCrops(data);
      ref.invalidate(farmCropsProvider);
    }
  }
}
