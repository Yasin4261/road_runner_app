import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final LatLng initialPosition;
  final List<Marker> markers;
  final MapController mapController;

  const MapWidget({
    Key? key,
    required this.initialPosition,
    required this.mapController,
    this.markers = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: initialPosition,
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          tileSize: 256,
          retinaMode: true,
        ),
        MarkerLayer(
          markers: markers,
        ),
      ],
    );
  }
}
