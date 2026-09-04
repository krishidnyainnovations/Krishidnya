import 'package:dio/dio.dart';
import 'package:cropdoc/core/constants/app_constants.dart';
import 'package:cropdoc/core/storage/secure_storage_service.dart';

/// Attaches authorization token to outgoing requests.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required SecureStorageService storage})
      : _storage = storage;

  final SecureStorageService _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(AppConstants.accessTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
