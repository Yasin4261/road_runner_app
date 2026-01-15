/// OSM Tile providers with different styles and quality
class OsmTileProvider {
  final String name;
  final String urlTemplate;
  final List<String> subdomains;
  final int maxZoom;

  const OsmTileProvider({
    required this.name,
    required this.urlTemplate,
    this.subdomains = const ['a', 'b', 'c'],
    this.maxZoom = 19,
  });

  /// Carto Voyager - Clean, modern style (recommended)
  static const OsmTileProvider cartoVoyager = OsmTileProvider(
    name: 'Carto Voyager',
    urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
    subdomains: ['a', 'b', 'c', 'd'],
    maxZoom: 20,
  );

  /// Carto Light - Light, minimal style
  static const OsmTileProvider cartoLight = OsmTileProvider(
    name: 'Carto Light',
    urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
    subdomains: ['a', 'b', 'c', 'd'],
    maxZoom: 20,
  );

  /// Carto Dark - Dark mode style
  static const OsmTileProvider cartoDark = OsmTileProvider(
    name: 'Carto Dark',
    urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
    subdomains: ['a', 'b', 'c', 'd'],
    maxZoom: 20,
  );

  /// OpenStreetMap Standard
  static const OsmTileProvider osmStandard = OsmTileProvider(
    name: 'OpenStreetMap',
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    subdomains: [],
    maxZoom: 19,
  );

  /// Stamen Terrain - Terrain style with hill shading
  static const OsmTileProvider stamenTerrain = OsmTileProvider(
    name: 'Terrain',
    urlTemplate: 'https://stamen-tiles.a.ssl.fastly.net/terrain/{z}/{x}/{y}.png',
    subdomains: [],
    maxZoom: 18,
  );

  /// Default provider
  static const OsmTileProvider defaultProvider = cartoVoyager;

  /// All available providers
  static const List<OsmTileProvider> all = [
    cartoVoyager,
    cartoLight,
    cartoDark,
    osmStandard,
  ];
}

