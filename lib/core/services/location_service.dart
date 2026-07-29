import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/errors/failures.dart';
import 'package:krishidnya/features/auth/domain/entities/location_data.dart';
import 'package:permission_handler/permission_handler.dart';

/// Handles GPS location fetching and reverse geocoding.
class LocationService {
  /// Checks if location services are enabled on device.
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  /// Requests location permission from the user.
  Future<bool> requestPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  /// Returns current permission status.
  Future<bool> hasPermission() async {
    final status = await Permission.locationWhenInUse.status;
    return status.isGranted;
  }

  /// Fetches current GPS coordinates and reverse geocodes to city/state.
  Future<Result<LocationData>> getCurrentLocation() async {
    try {
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const ErrorResult(
          LocationFailure('Location services are disabled'),
        );
      }

      final permitted = await hasPermission();
      if (!permitted) {
        return const ErrorResult(
          LocationFailure('Location permission not granted'),
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      return await _reverseGeocode(position);
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<LocationData>> _reverseGeocode(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return Success(
          LocationData(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      }

      final place = placemarks.first;
      final city = place.locality ?? place.subAdministrativeArea;
      final state = place.administrativeArea;
      final country = place.country;
      final formatted = [city, state, country]
          .where((e) => e != null && e.isNotEmpty)
          .join(', ');

      return Success(
        LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          city: city,
          state: state,
          country: country,
          formattedAddress: formatted.isNotEmpty ? formatted : null,
        ),
      );
    } catch (e) {
      return Success(
        LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    }
  }
}
