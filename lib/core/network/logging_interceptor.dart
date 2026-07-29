import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:krishidnya/core/services/app_logger.dart';

/// Logs all HTTP traffic to [AppLogger] for monitoring and debugging.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({AppLogger? logger})
      : _logger = logger ?? AppLogger.instance;

  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final body = _formatBody(options.data);
    final sanitizedHeaders = Map<String, dynamic>.from(options.headers)
      ..remove('Authorization');

    _logger.api(
      'HTTP',
      '→ ${options.method} ${options.uri}',
      details: 'Headers: $sanitizedHeaders\nBody: $body',
    );

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.api(
      'HTTP',
      '← ${response.statusCode} ${response.requestOptions.method} '
          '${response.requestOptions.uri}',
      details: 'Body: ${_formatBody(response.data)}',
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final responseBody = _formatBody(err.response?.data);

    _logger.error(
      'HTTP',
      '✕ ${err.requestOptions.method} ${err.requestOptions.uri} '
          '${status != null ? '($status)' : ''}',
      details: 'Type: ${err.type.name}\n'
          'Message: ${err.message}\n'
          'Response: $responseBody',
      error: err,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }

  String _formatBody(dynamic data) {
    if (data == null) return 'null';
    if (data is FormData) {
      return 'FormData(fields: ${data.fields}, files: ${data.files.length})';
    }
    try {
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      return data.toString();
    } catch (_) {
      return data.toString();
    }
  }
}
