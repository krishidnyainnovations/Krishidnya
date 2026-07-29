import 'package:equatable/equatable.dart';

/// Location data captured during registration.
class LocationData extends Equatable {
  const LocationData({
    required this.latitude,
    required this.longitude,
    this.city,
    this.state,
    this.country,
    this.formattedAddress,
  });

  final double latitude;
  final double longitude;
  final String? city;
  final String? state;
  final String? country;
  final String? formattedAddress;

  /// Human-readable location string for API.
  String get displayLocation =>
      formattedAddress ??
      [city, state, country].where((e) => e != null && e.isNotEmpty).join(', ');

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (country != null) 'country': country,
        if (formattedAddress != null) 'location': formattedAddress,
      };

  @override
  List<Object?> get props =>
      [latitude, longitude, city, state, country, formattedAddress];
}
