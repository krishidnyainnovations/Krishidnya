import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishidnya/core/config/providers.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/network/api_client.dart';
import 'package:krishidnya/core/services/app_logger.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/data/home_repository.dart';
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

final schemesProvider = FutureProvider<List<Scheme>>((ref) async {
  final result = await ref.watch(homeRepositoryProvider).getSchemes();
  return switch (result) {
    Success(:final data) => data,
    ErrorResult(:final failure) => throw failure,
  };
});

final homeWeatherProvider = FutureProvider<WeatherSummary>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  final lat = user?.latitude ?? 18.5204;
  final lng = user?.longitude ?? 73.8567;
  final label = user?.location ?? user?.city ?? 'Your Farm';

  final result = await ref.watch(homeRepositoryProvider).getWeather(
        latitude: lat,
        longitude: lng,
        locationLabel: label,
      );

  return switch (result) {
    Success(:final data) => data,
    ErrorResult(:final failure) => throw failure,
  };
});

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final result = await ref.watch(homeRepositoryProvider).getProducts();
  return switch (result) {
    Success(:final data) => data,
    ErrorResult(:final failure) => throw failure,
  };
});

final communityPostsProvider = FutureProvider<List<CommunityPost>>((ref) async {
  final result = await ref.watch(homeRepositoryProvider).getPosts();
  return switch (result) {
    Success(:final data) => data,
    ErrorResult(:final failure) => throw failure,
  };
});
