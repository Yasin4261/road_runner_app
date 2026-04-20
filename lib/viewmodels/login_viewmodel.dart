import 'package:flutter/foundation.dart';
import 'package:road_runner_app/core/di/service_locator.dart';
import 'package:road_runner_app/data/services/auth_service.dart';
import 'package:road_runner_app/data/services/auth_storage.dart';
import 'package:road_runner_app/data/services/websocket_service.dart';
import 'package:road_runner_app/viewmodels/base_viewmodel.dart';

class LoginViewModel extends BaseViewModel {
  final AuthService _authService;
  final WebSocketService _webSocketService;

  String? _token;
  String? _userName;
  String? get token => _token;
  String? get userName => _userName;
  bool get isAuthenticated => _token != null;

  LoginViewModel({
    required AuthService authService,
    required WebSocketService webSocketService,
  })  : _authService = authService,
        _webSocketService = webSocketService;

  factory LoginViewModel.fromLocator() {
    return LoginViewModel(
      authService: locator<AuthService>(),
      webSocketService: locator<WebSocketService>(),
    );
  }

  /// Login yap, token'ı kaydet ve WebSocket bağlantısını başlat
  Future<bool> login(String email, String password) async {
    setLoading();

    try {
      final response = await _authService.login(email, password);

      // Token'ı kaydet
      await AuthStorage.saveSession(
        token: response.token,
        userId: response.userId,
        email: response.email,
        name: response.name,
        userType: response.userType,
      );

      _token = response.token;
      _userName = response.name;

      // WebSocket bağlantısını başlat
      _webSocketService.connect(response.token);

      debugPrint('[Login] Success: ${response.name} (${response.userType})');
      setSuccess();
      return true;
    } catch (e) {
      setError(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  /// Kayıtlı oturumu kontrol et
  Future<bool> tryAutoLogin() async {
    final token = await AuthStorage.getToken();
    if (token != null && token.isNotEmpty) {
      _token = token;
      _userName = await AuthStorage.getName();

      // WebSocket bağlantısını başlat
      _webSocketService.connect(token);

      debugPrint('[Login] Auto-login: $_userName');
      setSuccess();
      return true;
    }
    return false;
  }

  /// Çıkış yap
  Future<void> logout() async {
    _webSocketService.disconnect();
    await AuthStorage.clear();
    _token = null;
    _userName = null;
    setIdle();
  }
}

