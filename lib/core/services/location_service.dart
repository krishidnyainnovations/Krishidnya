import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cropdoc/core/errors/exception_mapper.dart';
import 'package:cropdoc/core/errors/failures.dart';
import 'package:cropdoc/features/auth/domain/entities/location_data.dart';
import 'package:permission_handler/permission_handler.dart';

/// Handles GPS location fetching and reverse geocoding.
class LocationService {
  final Geocoding _geocoding = Geocoding();

  /// Checks if location services are enabled on device.
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  /// Requests location permission from the user.
  Future<bool> requestPermission() async {
    try {
      final status = await Permission.locationWhenInUse.request();
      return status.isGranted;
    } catch (e) {
      // If permission request fails, return false
      return false;
    }
  }

  /// Returns current permission status.
  Future<bool> hasPermission() async {
    try {
      final status = await Permission.locationWhenInUse.status;
      return status.isGranted;
    } catch (e) {
      // If permission check fails, return false
      return false;
    }
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
      final placemarks = await _geocoding.placemarkFromCoordinates(
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
      final formatted = [
        city,
        state,
        country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

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
