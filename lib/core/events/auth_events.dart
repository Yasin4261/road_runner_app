import 'dart:async';

/// Uygulama genelinde oturum olaylarını yayınlayan basit event bus.
///
/// API katmanı (ör. 401 Unauthorized) oturumun geçersiz olduğunu
/// `notifySessionExpired()` ile bildirir; `App` widget'ı bunu dinleyip
/// kullanıcıyı login ekranına yönlendirir.
class AuthEvents {
  AuthEvents._();
  static final AuthEvents instance = AuthEvents._();

  final _sessionExpiredController = StreamController<void>.broadcast();

  /// Oturum süresi dolduğunda / geçersizleştiğinde tetiklenen stream.
  Stream<void> get onSessionExpired => _sessionExpiredController.stream;

  /// Oturumun geçersiz olduğunu tüm dinleyicilere bildir.
  void notifySessionExpired() {
    if (!_sessionExpiredController.isClosed) {
      _sessionExpiredController.add(null);
    }
  }

  void dispose() {
    _sessionExpiredController.close();
  }
}

