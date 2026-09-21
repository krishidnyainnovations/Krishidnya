import 'package:cropdoc/core/api/api_config.dart';
import 'package:cropdoc/core/constants/app_constants.dart';
import 'package:cropdoc/core/network/api_client.dart';
import 'package:cropdoc/core/services/app_logger.dart';
import 'package:cropdoc/core/storage/secure_storage_service.dart';
import 'package:cropdoc/features/auth/domain/entities/auth_models.dart';
import 'package:cropdoc/features/auth/domain/entities/user.dart';

/// Remote data source for authentication API calls.
class AuthRemoteDataSource {
  AuthRemoteDataSource({
    required ApiClient apiClient,
    required SecureStorageService storage,
    AppLogger? logger,
  }) : _apiClient = apiClient,
       _storage = storage,
       _logger = logger ?? AppLogger.instance;

  final ApiClient _apiClient;
  final SecureStorageService _storage;
  final AppLogger _logger;

  /// Registers user, then logs in to obtain token.
  Future<AuthResponse> register(RegisterRequest request) async {
    _logger.info('Auth', 'Registering user: ${request.username}');

    final registerResponse = await _apiClient.post<Map<String, dynamic>>(
      ApiConfig.register,
      data: request.toJson(),
    );

    if (registerResponse.data == null) {
      throw Exception('Registration returned no data');
    }

    final user = User.fromJson(registerResponse.data!);
    _logger.info(
      'Auth',
      'Registration successful',
      details: 'User ID: ${user.id}',
    );

    return _loginAfterRegister(
      mobile: request.mobile,
      password: request.password,
      fallbackUser: user,
    );
  }

  /// OAuth2 login — mobile sent as `username` per FastAPI convention.
  Future<AuthResponse> login(LoginRequest request) async {
    _logger.info('Auth', 'Logging in mobile: ${request.mobile}');

    final token = await _fetchToken(request);
    final user =
        await _fetchCurrentUser() ??
        User(id: '', username: request.mobile, mobile: request.mobile);

    await _persistToken(token.accessToken, user.id);

    _logger.info('Auth', 'Login successful', details: 'User: ${user.username}');

    return AuthResponse(
      accessToken: token.accessToken,
      tokenType: token.tokenType,
      user: user,
    );
  }

  Future<void> logout() async {
    _logger.info('Auth', 'Logging out — clearing local session');
    await _storage.deleteAll();
  }

  Future<User?> getCurrentUser() async {
    final token = await _storage.read(AppConstants.accessTokenKey);
    if (token == null) return null;

    try {
      return await _fetchCurrentUser();
    } catch (e, st) {
      _logger.error(
        'Auth',
        'Failed to fetch current user',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await _storage.read(AppConstants.accessTokenKey);
      return token != null && token.isNotEmpty;
    } catch (e, st) {
      _logger.error(
        'Auth',
        'Failed to check authentication status',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  Future<AuthResponse> _loginAfterRegister({
    required String mobile,
    required String password,
    required User fallbackUser,
  }) async {
    try {
      return await login(LoginRequest(mobile: mobile, password: password));
    } catch (e, st) {
      _logger.warning(
        'Auth',
        'Auto-login after register failed — user must login manually',
        details: e.toString(),
      );
      _logger.error('Auth', 'Auto-login error', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<TokenResponse> _fetchToken(LoginRequest request) async {
    final response = await _apiClient.postForm<Map<String, dynamic>>(
      ApiConfig.token,
      data: request.toFormData(),
    );

    if (response.data == null) {
      throw Exception('Token response returned no data');
    }

    final token = TokenResponse.fromJson(response.data!);
    if (token.accessToken.isEmpty) {
      throw Exception('Empty access token received from server');
    }

    await _storage.write(AppConstants.accessTokenKey, token.accessToken);
    return token;
  }

  Future<User?> _fetchCurrentUser() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiConfig.currentUser,
    );

    if (response.data == null) {
      return null;
    }

    return User.fromJson(response.data!);
  }

  Future<User> updateUser({
    String? fullName,
    String? email,
    String? location,
    String? city,
    String? state,
  }) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      ApiConfig.updateUser,
      data: {
        if (fullName != null) 'full_name': fullName,
        if (email != null) 'email': email,
        if (location != null) 'location': location,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
      },
    );
    return User.fromJson(response.data!);
  }

  Future<User> updateLocation({
    required double latitude,
    required double longitude,
    String? location,
    String? city,
    String? state,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      ApiConfig.updateLocation,
      queryParameters: {'latitude': latitude, 'longitude': longitude},
      data: {
        if (location != null) 'location': location,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
      },
    );
    return User.fromJson(response.data!);
  }

  Future<void> deleteAccount() async {
    await _apiClient.delete<Map<String, dynamic>>(ApiConfig.currentUser);
    await _storage.deleteAll();
  }

  Future<void> _persistToken(String token, String userId) async {
    await _storage.write(AppConstants.accessTokenKey, token);
    if (userId.isNotEmpty) {
      await _storage.write(AppConstants.userIdKey, userId);
    }
  }
}
