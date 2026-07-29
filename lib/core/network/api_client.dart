import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:krishidnya/core/api/api_config.dart';
import 'package:krishidnya/core/constants/app_constants.dart';
import 'package:krishidnya/core/network/auth_interceptor.dart';
import 'package:krishidnya/core/network/logging_interceptor.dart';
import 'package:krishidnya/core/network/retry_interceptor.dart';
import 'package:krishidnya/core/services/app_logger.dart';
import 'package:krishidnya/core/storage/secure_storage_service.dart';

/// Centralized HTTP client with interceptors, retry, and auth support.
class ApiClient {
  ApiClient({
    required SecureStorageService storage,
    Dio? dio,
    AppLogger? logger,
  })  : _storage = storage,
        _logger = logger ?? AppLogger.instance,
        _dio = dio ?? Dio() {
    _configureDio();
  }

  final SecureStorageService _storage;
  final AppLogger _logger;
  final Dio _dio;

  Dio get dio => _dio;

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

    _logger.info(
      'ApiClient',
      'Initialized → ${ApiConfig.baseUrl}',
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<T>> multipart<T>(
    String path, {
    required FormData formData,
    Options? options,
  }) =>
      _dio.post<T>(
        path,
        data: formData,
        options: options ??
            Options(
              contentType: 'multipart/form-data',
            ),
      );

  /// OAuth2 form login used by FastAPI `/token` endpoint.
  Future<Response<T>> postForm<T>(
    String path, {
    required Map<String, String> data,
    Options? options,
  }) =>
      _dio.post<T>(
        path,
        data: data,
        options: options ??
            Options(
              contentType: Headers.formUrlEncodedContentType,
            ),
      );
}
