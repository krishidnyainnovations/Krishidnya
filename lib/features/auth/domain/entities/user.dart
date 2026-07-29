import 'package:equatable/equatable.dart';

/// User entity representing authenticated farmer.
class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.mobile,
    this.email = '',
    this.fullName,
    this.location,
    this.latitude,
    this.longitude,
    this.city,
    this.state,
    this.country,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id']?.toString() ?? '',
        username: json['username'] as String? ?? '',
        mobile: json['mobile'] as String? ?? '',
        email: json['email'] as String? ?? '',
        fullName: json['full_name'] as String?,
        location: json['location'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        city: json['city'] as String?,
        state: json['state'] as String?,
        country: json['country'] as String?,
      );

  final String id;
  final String username;
  final String mobile;
  final String email;
  final String? fullName;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? state;
  final String? country;

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'mobile': mobile,
        if (email.isNotEmpty) 'email': email,
        if (fullName != null) 'full_name': fullName,
        if (location != null) 'location': location,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (country != null) 'country': country,
      };

  @override
  List<Object?> get props => [
        id,
        username,
        mobile,
        email,
        fullName,
        location,
        latitude,
        longitude,
        city,
        state,
        country,
      ];
}
