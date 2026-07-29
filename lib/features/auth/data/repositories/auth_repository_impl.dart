import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/services/app_logger.dart';
import 'package:krishidnya/core/utils/username_generator.dart';
import 'package:krishidnya/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:krishidnya/features/auth/domain/entities/auth_models.dart';
import 'package:krishidnya/features/auth/domain/entities/location_data.dart';
import 'package:krishidnya/features/auth/domain/entities/user.dart';

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
}

/// Implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    AppLogger? logger,
  })  : _remote = remoteDataSource,
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
          location?.displayLocation.isNotEmpty ?? false
              ? location!.displayLocation
              : 'India';

      _logger.info(
        'AuthRepo',
        'Register attempt',
        details: 'username=$username mobile=$mobile location=$locationString',
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
}
