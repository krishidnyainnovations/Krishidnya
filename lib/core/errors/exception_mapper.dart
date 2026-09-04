import 'package:dio/dio.dart';
import 'package:cropdoc/core/errors/failures.dart';

/// Maps exceptions and Dio errors to domain [Failure] types.
abstract final class ExceptionMapper {
  static Failure map(Object error) {
    if (error is Failure) return error;

    if (error is DioException) {
      return _mapDioException(error);
    }

    return UnknownFailure(error.toString());
  }

  static Failure _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return NetworkFailure(
          'Cannot reach server at ${error.requestOptions.uri.host}. '
          'Check your internet connection.',
        );
      case DioExceptionType.badResponse:
        return _mapStatusCode(error);
      case DioExceptionType.cancel:
        return const UnknownFailure('Request was cancelled');
      default:
        return UnknownFailure(error.message ?? 'Network error');
    }
  }

  static Failure _mapStatusCode(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final message = _extractMessage(data) ?? 'Server error occurred';

    if (statusCode == 401 || statusCode == 403) {
      return AuthFailure(message, code: statusCode.toString());
    }

    if (statusCode == 422) {
      return ValidationFailure(message, field: _extractField(data));
    }

    if (statusCode == 409) {
      return ValidationFailure(message);
    }

    if (statusCode == 429) {
      return ServerFailure(
        'AI assistant is busy right now. Please try again in a moment.',
        statusCode: statusCode,
      );
    }

    return ServerFailure(message, statusCode: statusCode);
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map) {
      // FastAPI standard: {"detail": "..."}
      final detail = data['detail'];
      if (detail is String) return detail;

      // FastAPI validation: {"detail": [{loc, msg, type}, ...]}
      if (detail is List && detail.isNotEmpty) {
        final messages = detail
            .whereType<Map>()
            .map((e) {
              final loc = (e['loc'] as List?)?.whereType<String>().join('.');
              final msg = e['msg'] as String? ?? '';
              return loc != null ? '$loc: $msg' : msg;
            })
            .where((m) => m.isNotEmpty)
            .toList();
        if (messages.isNotEmpty) return messages.join('\n');
      }

      return data['message'] as String? ??
          data['error'] as String?;
    }
    if (data is String) return data;
    return null;
  }

  static String? _extractField(dynamic data) {
    if (data is Map && data['detail'] is List) {
      final detail = data['detail'] as List;
      if (detail.isNotEmpty && detail.first is Map) {
        final loc = (detail.first as Map)['loc'] as List?;
        if (loc != null && loc.length > 1) {
          return loc.last.toString();
        }
      }
    }
    return null;
  }
}

/// Result type for repository operations.
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class ErrorResult<T> extends Result<T> {
  const ErrorResult(this.failure);
  final Failure failure;
}
