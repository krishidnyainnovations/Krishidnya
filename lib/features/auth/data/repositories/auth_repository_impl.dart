import 'package:cropdoc/core/errors/exception_mapper.dart';
import 'package:cropdoc/core/services/app_logger.dart';
import 'package:cropdoc/core/utils/username_generator.dart';
import 'package:cropdoc/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cropdoc/features/auth/domain/entities/auth_models.dart';
import 'package:cropdoc/features/auth/domain/entities/location_data.dart';
import 'package:cropdoc/features/auth/domain/entities/user.dart';

/// Repository interface for authentication operations.
abstract interface class AuthRepository {
  Future<Result<AuthResponse>> register({
    required String email,
    required String password,
    required String mobile,
    required String fullName,
    LocationData? location,
  });

  Future<Result<AuthResponse>> login({
    required String mobile,
    required String password,
  });

  Future<Result<bool>> logout();

  Future<Result<User?>> getCurrentUser();

  Future<bool> isAuthenticated();

  Future<Result<User>> updateProfile({
    String? fullName,
    String? email,
    String? location,
    String? city,
    String? state,
  });

  Future<Result<User>> updateLocation({
    required double latitude,
    required double longitude,
    String? location,
    String? city,
    String? state,
  });

  Future<Result<bool>> deleteAccount();
}

/// Implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    AppLogger? logger,
  }) : _remote = remoteDataSource,
       _logger = logger ?? AppLogger.instance;

  final AuthRemoteDataSource _remote;
  final AppLogger _logger;

  @override
  Future<Result<AuthResponse>> register({
    required String email,
    required String password,
    required String mobile,
    required String fullName,
    LocationData? location,
  }) async {
    try {
      final username = UsernameGenerator.fromFullName(fullName);
      final locationString =
          (location != null && location.displayLocation.isNotEmpty)
              ? location.displayLocation
              : 'India';

      _logger.info(
        'AuthRepo',
        'Register attempt',
        details:
            'username=$username mobile=$mobile location=$locationString email=$email',
      );

      final request = RegisterRequest(
        username: username,
        password: password,
        mobile: mobile,
        fullName: fullName,
        location: locationString,
        latitude: location?.latitude,
        longitude: location?.longitude,
      );

      final response = await _remote.register(request);

      _logger.info('AuthRepo', 'Register + login complete');
      return Success(response);
    } catch (e, st) {
      final failure = ExceptionMapper.map(e);
      _logger.error(
        'AuthRepo',
        'Registration failed: ${failure.message}',
        error: e,
        stackTrace: st,
      );
      return ErrorResult(failure);
    }
  }

  @override
  Future<Result<AuthResponse>> login({
    required String mobile,
    required String password,
  }) async {
    try {
      _logger.info('AuthRepo', 'Login attempt', details: 'mobile=$mobile');

      final response = await _remote.login(
        LoginRequest(mobile: mobile, password: password),
      );

      _logger.info('AuthRepo', 'Login complete');
      return Success(response);
    } catch (e, st) {
      final failure = ExceptionMapper.map(e);
      _logger.error(
        'AuthRepo',
        'Login failed: ${failure.message}',
        error: e,
        stackTrace: st,
      );
      return ErrorResult(failure);
    }
  }

  @override
  Future<Result<bool>> logout() async {
    try {
      await _remote.logout();
      return const Success(true);
    } catch (e, st) {
      final failure = ExceptionMapper.map(e);
      _logger.error('AuthRepo', 'Logout failed', error: e, stackTrace: st);
      return ErrorResult(failure);
    }
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      final user = await _remote.getCurrentUser();
      return Success(user);
    } catch (e, st) {
      final failure = ExceptionMapper.map(e);
      _logger.error(
        'AuthRepo',
        'Get current user failed',
        error: e,
        stackTrace: st,
      );
      return ErrorResult(failure);
    }
  }

  @override
  Future<bool> isAuthenticated() => _remote.isAuthenticated();

  @override
  Future<Result<User>> updateProfile({
    String? fullName,
    String? email,
    String? location,
    String? city,
    String? state,
  }) async {
    try {
      final user = await _remote.updateUser(
        fullName: fullName,
        email: email,
        location: location,
        city: city,
        state: state,
      );
      return Success(user);
    } catch (e, st) {
      final failure = ExceptionMapper.map(e);
      _logger.error(
        'AuthRepo',
        'Update profile failed',
        error: e,
        stackTrace: st,
      );
      return ErrorResult(failure);
    }
  }

  @override
  Future<Result<User>> updateLocation({
    required double latitude,
    required double longitude,
    String? location,
    String? city,
    String? state,
  }) async {
    try {
      final user = await _remote.updateLocation(
        latitude: latitude,
        longitude: longitude,
        location: location,
        city: city,
        state: state,
      );
      return Success(user);
    } catch (e, st) {
      final failure = ExceptionMapper.map(e);
      _logger.error(
        'AuthRepo',
        'Update location failed',
        error: e,
        stackTrace: st,
      );
      return ErrorResult(failure);
    }
  }

  @override
  Future<Result<bool>> deleteAccount() async {
    try {
      await _remote.deleteAccount();
      return const Success(true);
    } catch (e, st) {
      final failure = ExceptionMapper.map(e);
      _logger.error(
        'AuthRepo',
        'Delete account failed',
        error: e,
        stackTrace: st,
      );
      return ErrorResult(failure);
    }
  }
}
