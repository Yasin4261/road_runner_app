import 'package:flutter/material.dart';
import 'package:road_runner_app/app.dart';
import 'package:road_runner_app/core/di/service_locator.dart';
import 'package:road_runner_app/core/utils/jwt_utils.dart';
import 'package:road_runner_app/data/services/auth_storage.dart';
import 'package:road_runner_app/data/services/websocket_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Setup dependency injection
  await setupLocator();
  // Kayıtlı token GEÇERLİ ise WebSocket bağlantısını otomatik başlat.
  // Süresi dolmuş token ile bağlanmaya çalışma; oturumu temizle.
  final token = await AuthStorage.getToken();
  if (token != null && token.isNotEmpty) {
    if (JwtUtils.isExpired(token)) {
      await AuthStorage.clear();
    } else {
      locator<WebSocketService>().connect(token);
    }
  }
  runApp(const App());
}
