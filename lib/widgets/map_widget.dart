import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final LatLng initialPosition;
  final List<Marker> markers;

  const MapWidget({
    Key? key,
    required this.initialPosition,
    this.markers = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: initialPosition,
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png", // Koyu tema harita
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
