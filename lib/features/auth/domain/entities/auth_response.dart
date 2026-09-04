import 'package:equatable/equatable.dart';
import 'package:cropdoc/features/auth/domain/entities/user.dart';

/// Combined auth result after login or register+login.
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
