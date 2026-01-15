import 'package:road_runner_app/viewmodels/base_viewmodel.dart';
import 'package:road_runner_app/data/services/map_settings_service.dart';
import 'package:road_runner_app/views/widgets/map/osm_tile_providers.dart';

class ProfileViewModel extends BaseViewModel {
  final MapSettingsService _mapSettingsService;

  OsmTileProvider _selectedTileProvider = OsmTileProvider.defaultProvider;

  ProfileViewModel({MapSettingsService? mapSettingsService})
      : _mapSettingsService = mapSettingsService ?? MapSettingsService.instance;

  // Getters
  OsmTileProvider get selectedTileProvider => _selectedTileProvider;
  List<OsmTileProvider> get availableTileProviders => OsmTileProvider.all;

  /// Initialize - load saved settings
  Future<void> init() async {
    _selectedTileProvider = _mapSettingsService.getTileProvider();
    notifyListeners();
  }

  /// Change tile provider
  Future<void> setTileProvider(OsmTileProvider provider) async {
    if (_selectedTileProvider.name == provider.name) return;

    _selectedTileProvider = provider;
    await _mapSettingsService.setTileProvider(provider);
    notifyListeners();
  }
}

