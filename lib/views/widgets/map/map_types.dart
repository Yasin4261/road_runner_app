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

  /// Kadıköy merkez - sipariş konumları için varsayılan
  static const MapPosition kadikoy = MapPosition(
    latitude: 40.9907,
    longitude: 29.0245,
    zoom: 14.0,
  );
}

/// Haritada gösterilecek işaretçi tipi
enum MapMarkerType { pickup, delivery, courier }

/// Harita işaretçisi modeli
class MapMarker {
  final double latitude;
  final double longitude;
  final MapMarkerType type;
  final String? label;

  const MapMarker({
    required this.latitude,
    required this.longitude,
    required this.type,
    this.label,
  });
}

/// Map provider type enum
enum MapProviderType {
  google,
  openStreetMap,
}/// Extension for display names
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

