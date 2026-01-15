import 'package:flutter/material.dart';
import 'map_types.dart';

/// Abstract map provider interface - Dependency Inversion Principle
abstract class MapProvider {
  /// Build the map widget
  Widget buildMap({
    required MapPosition position,
    required ValueChanged<MapPosition> onPositionChanged,
    MapPosition? userLocation,
  });

  /// Move camera to position
  void moveToPosition(MapPosition position);

  /// Get current position
  MapPosition get currentPosition;

  /// Dispose resources
  void dispose();
}

