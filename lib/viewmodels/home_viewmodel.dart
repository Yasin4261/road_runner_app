import 'package:road_runner_app/viewmodels/base_viewmodel.dart';
import 'package:road_runner_app/core/enums/location_status.dart';
import 'package:road_runner_app/views/widgets/map/map_types.dart';
import 'package:road_runner_app/views/widgets/map/map_provider.dart';
import 'package:road_runner_app/views/widgets/map/map_provider_factory.dart';
import 'package:road_runner_app/data/services/location_service.dart';
import 'package:road_runner_app/data/services/map_settings_service.dart';

class HomeViewModel extends BaseViewModel {
  final LocationService _locationService;
  final MapSettingsService _mapSettingsService;

  MapProviderType _mapProviderType = MapProviderType.openStreetMap;
  MapProvider? _mapProvider;
  MapPosition _currentPosition = MapPosition.defaultPosition;
  MapPosition? _userLocation;
  bool _isLoadingLocation = false;
  LocationStatus? _locationStatus;

  HomeViewModel({
    LocationService? locationService,
    MapSettingsService? mapSettingsService,
  })  : _locationService = locationService ?? LocationService.instance,
        _mapSettingsService = mapSettingsService ?? MapSettingsService.instance {
    // Listen for map settings changes
    _mapSettingsService.addListener(_onMapSettingsChanged);
  }

  void _onMapSettingsChanged() {
    // Refresh map when settings change (e.g., tile provider)
    _initMapProvider();
  }

  // Getters
  MapProviderType get mapProviderType => _mapProviderType;
  MapProvider? get mapProvider => _mapProvider;
  MapPosition get currentPosition => _currentPosition;
  MapPosition? get userLocation => _userLocation;
  bool get isLoadingLocation => _isLoadingLocation;
  LocationStatus? get locationStatus => _locationStatus;
  bool get hasLocationPermission => _locationStatus == LocationStatus.granted;

  void _initMapProvider() {
    _mapProvider?.dispose();

    final tileProvider = _mapSettingsService.getTileProvider();

    _mapProvider = MapProviderFactory.create(
      _mapProviderType,
      initialPosition: _currentPosition,
      tileProvider: tileProvider,
    );
    notifyListeners();
  }

  /// Refresh map with new settings (called when returning to home)
  void refreshMapProvider() {
    _initMapProvider();
  }

  /// Switch map provider (Google <-> OSM)
  void switchMapProvider(MapProviderType type) {
    if (_mapProviderType == type) return;

    _mapProviderType = type;
    _initMapProvider();
  }

  /// Toggle between map providers
  void toggleMapProvider() {
    final newType = _mapProviderType == MapProviderType.google
        ? MapProviderType.openStreetMap
        : MapProviderType.google;
    switchMapProvider(newType);
  }

  /// Update current position from map
  void onMapPositionChanged(MapPosition position) {
    _currentPosition = position;
    notifyListeners();
  }

  /// Check location status
  Future<LocationStatus> checkLocationStatus() async {
    _locationStatus = await _locationService.checkLocationStatus();
    notifyListeners();
    return _locationStatus!;
  }

  /// Request location permission
  Future<LocationStatus> requestLocationPermission() async {
    _locationStatus = await _locationService.requestPermission();
    notifyListeners();

    if (_locationStatus == LocationStatus.granted) {
      await _fetchAndSetLocation();
    }

    return _locationStatus!;
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    await _locationService.openAppSettings();
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await _locationService.openLocationSettings();
  }

  /// Handle permission action based on status
  Future<void> handleLocationPermissionAction() async {
    if (_locationStatus == null) return;

    if (_locationStatus!.canRequestPermission) {
      await requestLocationPermission();
    } else if (_locationStatus!.needsAppSettings) {
      await openAppSettings();
    } else if (_locationStatus!.needsLocationSettings) {
      await openLocationSettings();
    }
  }

  /// Clear location status (dismiss dialog)
  void clearLocationStatus() {
    _locationStatus = null;
    notifyListeners();
  }

  /// Get current user location and center map
  Future<void> goToMyLocation() async {
    // Prevent multiple calls
    if (_isLoadingLocation) return;

    // First check status
    final status = await checkLocationStatus();

    if (status != LocationStatus.granted) {
      // Status will trigger dialog in UI
      return;
    }

    _isLoadingLocation = true;
    notifyListeners();

    try {
      await _fetchAndSetLocation();
    } catch (e) {
      // Ignore errors
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  Future<void> _fetchAndSetLocation() async {
    final position = await _locationService.getCurrentPosition();

    if (position != null) {
      _userLocation = position;
      _currentPosition = position;
      _mapProvider?.moveToPosition(position);
      notifyListeners();
    }
  }

  /// Initialize and get user location on start
  Future<void> initializeLocation() async {
    setLoading();

    try {
      // Check permission status first (without triggering dialog)
      final status = await _locationService.checkLocationStatus();

      if (status == LocationStatus.granted) {
        // Try to get location with timeout
        final position = await _locationService.getCurrentPosition();

        if (position != null) {
          _userLocation = position;
          _currentPosition = position;
        }
      }
      // Don't set _locationStatus here to avoid dialog on startup
      // User can tap "My Location" button to trigger permission flow

    } catch (e) {
      // Ignore errors, just use default position
    }

    _initMapProvider();
    setSuccess();
  }

  /// Re-check permission after returning from settings
  Future<void> recheckPermissionAfterSettings() async {
    final status = await checkLocationStatus();

    if (status == LocationStatus.granted) {
      _locationStatus = null; // Clear to dismiss dialog
      await _fetchAndSetLocation();
    }
  }

  @override
  void dispose() {
    _mapSettingsService.removeListener(_onMapSettingsChanged);
    _mapProvider?.dispose();
    super.dispose();
  }
}

