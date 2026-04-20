import 'dart:async';
import 'package:road_runner_app/core/di/service_locator.dart';
import 'package:road_runner_app/data/models/assignment_notification.dart';
import 'package:road_runner_app/data/services/websocket_service.dart';
import 'package:road_runner_app/viewmodels/base_viewmodel.dart';
/// Sipariş atamalarını yöneten ViewModel.
/// WebSocket üzerinden gelen gerçek zamanlı atamaları dinler.
class AssignmentViewModel extends BaseViewModel {
  final WebSocketService _webSocketService;
  StreamSubscription<AssignmentNotification>? _subscription;
  /// Bekleyen atamalar listesi
  final List<AssignmentNotification> _pendingAssignments = [];
  List<AssignmentNotification> get pendingAssignments =>
      List.unmodifiable(_pendingAssignments);
  /// Son gelen atama (UI'da popup göstermek için)
  AssignmentNotification? _latestAssignment;
  AssignmentNotification? get latestAssignment => _latestAssignment;
  bool get hasAssignments => _pendingAssignments.isNotEmpty;
  bool get isConnected => _webSocketService.isConnected;
  AssignmentViewModel({required WebSocketService webSocketService})
      : _webSocketService = webSocketService;
  /// Service locator'dan oluştur
  factory AssignmentViewModel.fromLocator() {
    return AssignmentViewModel(webSocketService: locator<WebSocketService>());
  }
  /// WebSocket bağlantısını başlat ve atamaları dinle
  void startListening(String jwtToken) {
    _webSocketService.connect(jwtToken);
    _subscription = _webSocketService.assignmentStream.listen(
      _onNotificationReceived,
      onError: (error) {
        setError('WebSocket hatası: $error');
      },
    );
    setSuccess();
  }
  void _onNotificationReceived(AssignmentNotification notification) {
    if (notification.isNewAssignment) {
      _pendingAssignments.add(notification);
      _latestAssignment = notification;
      notifyListeners();
    } else if (notification.isTimeout) {
      // Timeout olan atamayı listeden kaldır
      _pendingAssignments.removeWhere(
        (a) => a.assignmentId == notification.assignmentId,
      );
      notifyListeners();
    }
  }
  /// Atamayı listeden kaldır (kabul veya red sonrası)
  void removeAssignment(int assignmentId) {
    _pendingAssignments.removeWhere((a) => a.assignmentId == assignmentId);
    if (_latestAssignment?.assignmentId == assignmentId) {
      _latestAssignment = null;
    }
    notifyListeners();
  }
  /// Son popup'ı temizle
  void clearLatest() {
    _latestAssignment = null;
    notifyListeners();
  }
  /// Bağlantıyı durdur
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _webSocketService.disconnect();
  }
  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
