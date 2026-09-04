import 'package:dio/dio.dart';
import 'package:cropdoc/core/constants/app_constants.dart';
import 'package:cropdoc/core/services/app_logger.dart';

/// Retries failed requests on transient network errors.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({required Dio dio, AppLogger? logger})
    : _dio = dio,
      _logger = logger ?? AppLogger.instance;

  final Dio _dio;
  final AppLogger _logger;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry = _shouldRetry(err);
    final attempt = err.requestOptions.extra['retry_attempt'] as int? ?? 0;

    if (shouldRetry && attempt < AppConstants.maxRetryAttempts) {
      err.requestOptions.extra['retry_attempt'] = attempt + 1;
      final delay = Duration(milliseconds: 500 * (attempt + 1));

      _logger.warning(
        'Retry',
        'Retrying ${err.requestOptions.method} ${err.requestOptions.uri} '
            '(attempt ${attempt + 1}/${AppConstants.maxRetryAttempts})',
        details: 'Waiting ${delay.inMilliseconds}ms',
      );

      await Future<void>.delayed(delay);

      try {
        final response = await _dio.fetch<dynamic>(err.requestOptions);
        handler.resolve(response);
        return;
      } on DioException catch (retryError) {
        handler.next(retryError);
        return;
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Don't retry chat requests that timeout (they take too long)
    final isChatRequest = err.requestOptions.path.contains('/chat');
    if (isChatRequest && err.type == DioExceptionType.receiveTimeout) {
      return false;
    }

    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
