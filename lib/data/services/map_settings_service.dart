import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:road_runner_app/views/widgets/map/osm_tile_providers.dart';

/// Service for storing map settings
class MapSettingsService extends ChangeNotifier {
  static const String _tileProviderKey = 'map_tile_provider';

  MapSettingsService._();
  static final MapSettingsService instance = MapSettingsService._();

  SharedPreferences? _prefs;
  OsmTileProvider _currentProvider = OsmTileProvider.defaultProvider;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _currentProvider = _loadTileProvider();
  }

  OsmTileProvider _loadTileProvider() {
    final savedName = _prefs?.getString(_tileProviderKey);
    if (savedName == null) return OsmTileProvider.defaultProvider;

    return OsmTileProvider.all.firstWhere(
      (p) => p.name == savedName,
      orElse: () => OsmTileProvider.defaultProvider,
    );
  }

  /// Get saved tile provider
  OsmTileProvider getTileProvider() {
    return _currentProvider;
  }

  /// Save tile provider and notify listeners
  Future<void> setTileProvider(OsmTileProvider provider) async {
    if (_currentProvider.name == provider.name) return;

    _currentProvider = provider;
    await _prefs?.setString(_tileProviderKey, provider.name);
    notifyListeners(); // Notify HomeViewModel to refresh
  }

  /// Get tile provider name
  String get currentTileProviderName => _currentProvider.name;
}

