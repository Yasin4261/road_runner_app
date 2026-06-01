import 'package:get_it/get_it.dart';
import 'package:road_runner_app/data/services/auth_service.dart';
import 'package:road_runner_app/data/services/courier_order_service.dart';
import 'package:road_runner_app/data/services/location_service.dart';
import 'package:road_runner_app/data/services/map_settings_service.dart';
import 'package:road_runner_app/data/services/shift_service.dart';
import 'package:road_runner_app/data/services/websocket_service.dart';
import 'package:road_runner_app/viewmodels/active_delivery_viewmodel.dart';
import 'package:road_runner_app/viewmodels/assignment_viewmodel.dart';
import 'package:road_runner_app/viewmodels/home_viewmodel.dart';
import 'package:road_runner_app/viewmodels/login_viewmodel.dart';
import 'package:road_runner_app/viewmodels/profile_viewmodel.dart';
import 'package:road_runner_app/viewmodels/shifts_viewmodel.dart';
final GetIt locator = GetIt.instance;
Future<void> setupLocator() async {
  // Initialize services
  await MapSettingsService.instance.init();
  // Services
  locator.registerLazySingleton<LocationService>(() => LocationService.instance);
  locator.registerLazySingleton<MapSettingsService>(() => MapSettingsService.instance);
  locator.registerLazySingleton<WebSocketService>(() => WebSocketService());
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<ShiftService>(() => ShiftService());
  locator.registerLazySingleton<CourierOrderService>(() => CourierOrderService());
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
  // Global singletons - tüm uygulama boyunca tek instance (bildirim + aktif teslimat)
  locator.registerLazySingleton<AssignmentViewModel>(
    () => AssignmentViewModel(
      webSocketService: locator<WebSocketService>(),
      orderService: locator<CourierOrderService>(),
    ),
  );
  locator.registerLazySingleton<ActiveDeliveryViewModel>(
    () => ActiveDeliveryViewModel(
      orderService: locator<CourierOrderService>(),
    ),
  );
  locator.registerFactory<LoginViewModel>(
    () => LoginViewModel(
      authService: locator<AuthService>(),
      webSocketService: locator<WebSocketService>(),
    ),
  );
  locator.registerFactory<ShiftsViewModel>(
    () => ShiftsViewModel(
      shiftService: locator<ShiftService>(),
      locationService: locator<LocationService>(),
    ),
  );
}
