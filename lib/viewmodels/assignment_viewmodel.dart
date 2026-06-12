import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:road_runner_app/core/di/service_locator.dart';
import 'package:road_runner_app/data/models/assignment_notification.dart';
import 'package:road_runner_app/data/services/courier_order_service.dart';
import 'package:road_runner_app/data/services/websocket_service.dart';
import 'package:road_runner_app/viewmodels/base_viewmodel.dart';
/// Sipariş atamalarını yöneten ViewModel.
/// - WebSocket üzerinden gerçek zamanlı atamaları dinler
/// - REST API ile bekleyenleri yükler (WS kaçırılırsa fallback)
/// - Kabul/Reddet işlemlerini backend'e iletir
class AssignmentViewModel extends BaseViewModel {
  final WebSocketService _webSocketService;
  final CourierOrderService _orderService;
  StreamSubscription<AssignmentNotification>? _subscription;
  final List<AssignmentNotification> _pendingAssignments = [];
  List<AssignmentNotification> get pendingAssignments =>
      List.unmodifiable(_pendingAssignments);
  /// Son gelen atama (UI'da popup göstermek için)
  AssignmentNotification? _latestAssignment;
  AssignmentNotification? get latestAssignment => _latestAssignment;
  bool get hasAssignments => _pendingAssignments.isNotEmpty;
  bool get isConnected => _webSocketService.isConnected;
  bool _actionInProgress = false;
  bool get actionInProgress => _actionInProgress;
  AssignmentViewModel({
    required WebSocketService webSocketService,
    required CourierOrderService orderService,
  })  : _webSocketService = webSocketService,
        _orderService = orderService {
    _subscription = _webSocketService.assignmentStream.listen(
      _onNotificationReceived,
      onError: (error) => debugPrint('[AssignmentVM] WS error: $error'),
    );
  }
  factory AssignmentViewModel.fromLocator() {
    return AssignmentViewModel(
      webSocketService: locator<WebSocketService>(),
      orderService: locator<CourierOrderService>(),
    );
  }
  void _onNotificationReceived(AssignmentNotification notification) {
    if (notification.isNewAssignment) {
      final exists = _pendingAssignments
          .any((a) => a.assignmentId == notification.assignmentId);
      if (!exists) {
        _pendingAssignments.add(notification);
      }
      _latestAssignment = notification;
      notifyListeners();
    } else if (notification.isTimeout) {
      _pendingAssignments
          .removeWhere((a) => a.assignmentId == notification.assignmentId);
      if (_latestAssignment?.assignmentId == notification.assignmentId) {
        _latestAssignment = null;
      }
      notifyListeners();
    }
  }
  /// Bekleyen atamaları REST API'den yükle (WebSocket kaçırılmışsa)
  Future<void> loadPendingFromApi() async {
    try {
      final list = await _orderService.getPendingAssignments();
      for (final item in list) {
        final assignmentId = (item['assignmentId'] as num?)?.toInt();
        final orderId = (item['orderId'] as num?)?.toInt();
        if (assignmentId == null || orderId == null) continue;
        final exists =
            _pendingAssignments.any((a) => a.assignmentId == assignmentId);
        if (!exists) {
          _pendingAssignments.add(AssignmentNotification(
            type: 'NEW_ASSIGNMENT',
            assignmentId: assignmentId,
            orderId: orderId,
            assignedAt: item['assignedAt']?.toString(),
            timeoutAt: item['timeoutAt']?.toString(),
          ));
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('[AssignmentVM] loadPendingFromApi error: $e');
    }
  }
  /// Atamayı kabul et → backend'e bildir. Başarılıysa orderId döner.
  Future<int?> acceptAssignment(int assignmentId) async {
    _actionInProgress = true;
    notifyListeners();
    try {
      final assignment = _pendingAssignments
          .firstWhere((a) => a.assignmentId == assignmentId);
      await _orderService.acceptAssignment(assignmentId);
      _removeLocal(assignmentId);
      return assignment.orderId;
    } catch (e) {
      setError(CourierOrderService.extractError(e));
      return null;
    } finally {
      _actionInProgress = false;
      notifyListeners();
    }
  }
  /// Atamayı reddet → backend'e bildir
  Future<bool> rejectAssignment(int assignmentId, {String? reason}) async {
    _actionInProgress = true;
    notifyListeners();
    try {
      await _orderService.rejectAssignment(assignmentId, reason: reason);
      _removeLocal(assignmentId);
      return true;
    } catch (e) {
      setError(CourierOrderService.extractError(e));
      return false;
    } finally {
      _actionInProgress = false;
      notifyListeners();
    }
  }
  void _removeLocal(int assignmentId) {
    _pendingAssignments.removeWhere((a) => a.assignmentId == assignmentId);
    if (_latestAssignment?.assignmentId == assignmentId) {
      _latestAssignment = null;
    }
  }
  /// Son popup'ı temizle (kullanıcı kapatınca)
  void clearLatest() {
    _latestAssignment = null;
    notifyListeners();
  }
  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}
