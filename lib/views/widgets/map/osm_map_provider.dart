import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'map_provider.dart';
import 'map_types.dart';
import 'osm_tile_providers.dart';

/// OpenStreetMap implementation
class OsmMapProvider implements MapProvider {
  final MapController _controller = MapController();
  MapPosition _currentPosition;
  final OsmTileProvider _tileProvider;

  OsmMapProvider({
    MapPosition? initialPosition,
    OsmTileProvider? tileProvider,
  })  : _currentPosition = initialPosition ?? MapPosition.defaultPosition,
        _tileProvider = tileProvider ?? OsmTileProvider.defaultProvider;

  @override
  MapPosition get currentPosition => _currentPosition;

  @override
  Widget buildMap({
    required MapPosition position,
    required ValueChanged<MapPosition> onPositionChanged,
    MapPosition? userLocation,
  }) {
    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: LatLng(position.latitude, position.longitude),
        initialZoom: position.zoom,
        onPositionChanged: (pos, hasGesture) {
          _currentPosition = MapPosition(
            latitude: pos.center.latitude,
            longitude: pos.center.longitude,
            zoom: pos.zoom,
          );
          if (hasGesture) {
            onPositionChanged(_currentPosition);
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: _tileProvider.urlTemplate,
          subdomains: _tileProvider.subdomains,
          userAgentPackageName: 'com.roadrunner.app',
          retinaMode: true,
          maxZoom: _tileProvider.maxZoom.toDouble(),
          tileSize: 256,
        ),
        if (userLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(userLocation.latitude, userLocation.longitude),
                width: 40,
                height: 40,
                child: const _UserLocationMarker(),
              ),
            ],
          ),
      ],
    );
  }

  @override
  void moveToPosition(MapPosition position) {
    _controller.move(
      LatLng(position.latitude, position.longitude),
      position.zoom,
    );
    _currentPosition = position;
  }

  @override
  void dispose() {
    _controller.dispose();
  }
}

/// Custom user location marker widget
class _UserLocationMarker extends StatelessWidget {
  const _UserLocationMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

