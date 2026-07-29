import 'package:equatable/equatable.dart';
import 'package:krishidnya/features/auth/domain/entities/user.dart';

/// Registration request payload aligned with backend `UserCreate` schema.
class RegisterRequest extends Equatable {
  const RegisterRequest({
    required this.username,
    required this.password,
    required this.mobile,
    required this.fullName,
    required this.location,
    this.latitude,
    this.longitude,
    this.farmType = 'Mixed Farming',
    this.appLanguage = 'en',
  });

  final String username;
  final String password;
  final String mobile;
  final String fullName;
  final String location;
  final double? latitude;
  final double? longitude;
  final String farmType;
  final String appLanguage;

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'mobile': mobile,
        'full_name': fullName,
        'location': location,
        'farm_type': farmType,
        'app_language': appLanguage,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

  @override
  List<Object?> get props => [
        username,
        password,
        mobile,
        fullName,
        location,
        latitude,
        longitude,
        farmType,
        appLanguage,
      ];
}

/// Login request — mobile is sent as OAuth2 `username` field.
class LoginRequest extends Equatable {
  const LoginRequest({
    required this.mobile,
    required this.password,
  });

  final String mobile;
  final String password;

  Map<String, String> toFormData() => {
        'username': mobile,
        'password': password,
      };

  @override
  List<Object?> get props => [mobile, password];
}

/// OAuth2 token response from `/token`.
class TokenResponse extends Equatable {
  const TokenResponse({
    required this.accessToken,
    this.tokenType = 'bearer',
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        accessToken: json['access_token'] as String? ?? '',
        tokenType: json['token_type'] as String? ?? 'bearer',
      );

  final String accessToken;
  final String tokenType;

  @override
  List<Object?> get props => [accessToken, tokenType];
}

/// Full auth session after login + profile fetch.
class AuthResponse extends Equatable {
  const AuthResponse({
    required this.accessToken,
    required this.user,
    this.tokenType = 'bearer',
  });

  final String accessToken;
  final String tokenType;
  final User user;

  @override
  List<Object?> get props => [accessToken, tokenType, user];
}
