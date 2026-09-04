import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:cropdoc/core/api/api_config.dart';
import 'package:cropdoc/core/constants/app_constants.dart';
import 'package:cropdoc/core/network/auth_interceptor.dart';
import 'package:cropdoc/core/network/logging_interceptor.dart';
import 'package:cropdoc/core/network/retry_interceptor.dart';
import 'package:cropdoc/core/services/app_logger.dart';
import 'package:cropdoc/core/storage/secure_storage_service.dart';

/// Centralized HTTP client with interceptors, retry, and auth support.
class ApiClient {
  ApiClient({
    required SecureStorageService storage,
    Dio? dio,
    AppLogger? logger,
  }) : _storage = storage,
       _logger = logger ?? AppLogger.instance,
       _dio = dio ?? Dio() {
    _configureDio();
  }

  final SecureStorageService _storage;
  final AppLogger _logger;
  final Dio _dio;
  CancelToken _cancelToken = CancelToken();

  Dio get dio => _dio;

  /// Cancel all pending requests (call when navigating away)
  void cancelRequests([String? reason]) {
    if (!_cancelToken.isCancelled) {
      _logger.info(
        'ApiClient',
        'Cancelling pending requests',
        details: reason ?? 'Navigation',
      );
      _cancelToken.cancel(reason ?? 'Request cancelled due to navigation');
      // Create new cancel token for future requests
      _cancelToken = CancelToken();
    }
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.addAll([
      AuthInterceptor(storage: _storage),
      RetryInterceptor(dio: _dio, logger: _logger),
      if (kDebugMode) LoggingInterceptor(logger: _logger),
    ]);

    _logger.info('ApiClient', 'Initialized → ${ApiConfig.baseUrl}');
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.get<T>(
    path,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken ?? _cancelToken,
  );

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.post<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken ?? _cancelToken,
  );

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.put<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken ?? _cancelToken,
  );

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.patch<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken ?? _cancelToken,
  );

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.delete<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken ?? _cancelToken,
  );

  Future<Response<T>> multipart<T>(
    String path, {
    required FormData formData,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.post<T>(
    path,
    data: formData,
    options: options ?? Options(contentType: 'multipart/form-data'),
    cancelToken: cancelToken ?? _cancelToken,
  );

  /// OAuth2 form login used by FastAPI `/token` endpoint.
  Future<Response<T>> postForm<T>(
    String path, {
    required Map<String, String> data,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.post<T>(
    path,
    data: data,
    options: options ?? Options(contentType: Headers.formUrlEncodedContentType),
    cancelToken: cancelToken ?? _cancelToken,
  );
}
