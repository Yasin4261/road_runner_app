import 'package:flutter/material.dart';

/// Map position model
class MapPosition {
  final double latitude;
  final double longitude;
  final double zoom;

  const MapPosition({
    required this.latitude,
    required this.longitude,
    this.zoom = 15.0,
  });

  MapPosition copyWith({
    double? latitude,
    double? longitude,
    double? zoom,
  }) {
    return MapPosition(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      zoom: zoom ?? this.zoom,
    );
  }

  /// Default position (Istanbul)
  static const MapPosition defaultPosition = MapPosition(
    latitude: 41.0082,
    longitude: 28.9784,
    zoom: 15.0,
  );
}

/// Map provider type enum
enum MapProviderType {
  google,
  openStreetMap,
}

/// Extension for display names
extension MapProviderTypeExtension on MapProviderType {
  String get displayName {
    switch (this) {
      case MapProviderType.google:
        return 'Google Maps';
      case MapProviderType.openStreetMap:
        return 'OpenStreetMap';
    }
  }

  IconData get icon {
    switch (this) {
      case MapProviderType.google:
        return Icons.map;
      case MapProviderType.openStreetMap:
        return Icons.public;
    }
  }
}

