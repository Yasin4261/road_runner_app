import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_provider.dart';
import 'map_types.dart';

/// Google Maps implementation
class GoogleMapProvider implements MapProvider {
  GoogleMapController? _controller;
  MapPosition _currentPosition;

  GoogleMapProvider({MapPosition? initialPosition})
      : _currentPosition = initialPosition ?? MapPosition.defaultPosition;

  @override
  MapPosition get currentPosition => _currentPosition;

  @override
  Widget buildMap({
    required MapPosition position,
    required ValueChanged<MapPosition> onPositionChanged,
    MapPosition? userLocation,
    List<MapMarker> markers = const [],
  }) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: position.zoom,
      ),
      onMapCreated: (controller) {
        _controller = controller;
      },
      onCameraMove: (cameraPosition) {
        _currentPosition = MapPosition(
          latitude: cameraPosition.target.latitude,
          longitude: cameraPosition.target.longitude,
          zoom: cameraPosition.zoom,
        );
      },
      onCameraIdle: () {
        onPositionChanged(_currentPosition);
      },
      markers: markers.map((m) {
        final isPickup = m.type == MapMarkerType.pickup;
        return Marker(
          markerId: MarkerId('${m.type}_${m.latitude}_${m.longitude}'),
          position: LatLng(m.latitude, m.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isPickup
                ? BitmapDescriptor.hueAzure
                : BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(
            title: m.label ?? (isPickup ? 'Alış (Restoran)' : 'Teslimat'),
          ),
        );
      }).toSet(),
      myLocationEnabled: userLocation != null,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: true,
    );
  }

  @override
  void moveToPosition(MapPosition position) {
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: position.zoom,
        ),
      ),
    );
    _currentPosition = position;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
  }
}

