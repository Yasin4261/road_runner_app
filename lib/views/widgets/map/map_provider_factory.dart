import 'map_provider.dart';
import 'map_types.dart';
import 'google_map_provider.dart';
import 'osm_map_provider.dart';
import 'osm_tile_providers.dart';

/// Factory for creating map providers - Factory Pattern
class MapProviderFactory {
  MapProviderFactory._();

  static MapProvider create(
    MapProviderType type, {
    MapPosition? initialPosition,
    OsmTileProvider? tileProvider,
  }) {
    switch (type) {
      case MapProviderType.google:
        return GoogleMapProvider(initialPosition: initialPosition);
      case MapProviderType.openStreetMap:
        return OsmMapProvider(
          initialPosition: initialPosition,
          tileProvider: tileProvider,
        );
    }
  }
}

