import 'package:get_it/get_it.dart';
import 'package:road_runner_app/data/services/location_service.dart';
import 'package:road_runner_app/data/services/map_settings_service.dart';
import 'package:road_runner_app/data/services/websocket_service.dart';
import 'package:road_runner_app/viewmodels/assignment_viewmodel.dart';
import 'package:road_runner_app/viewmodels/home_viewmodel.dart';
import 'package:road_runner_app/viewmodels/profile_viewmodel.dart';
final GetIt locator = GetIt.instance;
Future<void> setupLocator() async {
  // Initialize services
  await MapSettingsService.instance.init();
  // Services
  locator.registerLazySingleton<LocationService>(() => LocationService.instance);
  locator.registerLazySingleton<MapSettingsService>(() => MapSettingsService.instance);
  locator.registerLazySingleton<WebSocketService>(() => WebSocketService());
  // ViewModels
  locator.registerFactory<HomeViewModel>(
    () => HomeViewModel(
      locationService: locator<LocationService>(),
      mapSettingsService: locator<MapSettingsService>(),
    ),
  );
  locator.registerFactory<ProfileViewModel>(
    () => ProfileViewModel(mapSettingsService: locator<MapSettingsService>()),
  );
  locator.registerFactory<AssignmentViewModel>(
    () => AssignmentViewModel(webSocketService: locator<WebSocketService>()),
  );
}
