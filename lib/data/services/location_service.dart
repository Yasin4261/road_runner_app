import 'package:geolocator/geolocator.dart';
import 'package:road_runner_app/core/enums/location_status.dart';
import 'package:road_runner_app/views/widgets/map/map_types.dart';

/// Location service for getting user's current location
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  /// Check current location status
  Future<LocationStatus> checkLocationStatus() async {
    // First check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationStatus.serviceDisabled;
    }

    // Then check permission status
    LocationPermission permission = await Geolocator.checkPermission();

    switch (permission) {
      case LocationPermission.denied:
        return LocationStatus.denied;
      case LocationPermission.deniedForever:
        return LocationStatus.deniedForever;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return LocationStatus.granted;
      case LocationPermission.unableToDetermine:
        return LocationStatus.denied;
    }
  }

  /// Request location permission
  Future<LocationStatus> requestPermission() async {
    // First check if service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationStatus.serviceDisabled;
    }

    LocationPermission permission = await Geolocator.requestPermission();

    switch (permission) {
      case LocationPermission.denied:
        return LocationStatus.denied;
      case LocationPermission.deniedForever:
        return LocationStatus.deniedForever;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return LocationStatus.granted;
      case LocationPermission.unableToDetermine:
        return LocationStatus.denied;
    }
  }

  /// Open app settings (for deniedForever case)
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Open location settings (for serviceDisabled case)
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Get current position (only if permission granted)
  Future<MapPosition?> getCurrentPosition() async {
    try {
      final status = await checkLocationStatus();
      if (status != LocationStatus.granted) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      ).timeout(
        const Duration(seconds: 6),
        onTimeout: () => throw Exception('Location timeout'),
      );

      return MapPosition(
        latitude: position.latitude,
        longitude: position.longitude,
        zoom: 16.0,
      );
    } catch (e) {
      // Try with lower accuracy as fallback
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 3),
          ),
        );
        return MapPosition(
          latitude: position.latitude,
          longitude: position.longitude,
          zoom: 16.0,
        );
      } catch (_) {
        return null;
      }
    }
  }

  /// Stream of position updates
  Stream<MapPosition> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).map((position) => MapPosition(
          latitude: position.latitude,
          longitude: position.longitude,
        ));
  }
}

