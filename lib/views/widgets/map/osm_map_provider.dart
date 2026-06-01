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
    List<MapMarker> markers = const [],
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
        // Sipariş işaretçileri (pickup / delivery)
        if (markers.isNotEmpty)
          MarkerLayer(
            markers: markers
                .map((m) => Marker(
                      point: LatLng(m.latitude, m.longitude),
                      width: 44,
                      height: 54,
                      alignment: Alignment.topCenter,
                      child: _OrderMarker(type: m.type, label: m.label),
                    ))
                .toList(),
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

/// Sipariş işaretçisi (pickup=mavi mağaza, delivery=kırmızı konum)
class _OrderMarker extends StatelessWidget {
  final MapMarkerType type;
  final String? label;
  const _OrderMarker({required this.type, this.label});

  @override
  Widget build(BuildContext context) {
    final isPickup = type == MapMarkerType.pickup;
    final color = isPickup ? Colors.blue.shade700 : Colors.red.shade700;
    final icon = isPickup ? Icons.store : Icons.location_on;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        Container(
          width: 2,
          height: 8,
          color: color,
        ),
      ],
    );
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

