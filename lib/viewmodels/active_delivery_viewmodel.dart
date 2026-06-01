import 'package:flutter/foundation.dart';
import 'package:road_runner_app/core/di/service_locator.dart';
import 'package:road_runner_app/core/enums/order_status.dart';
import 'package:road_runner_app/data/models/courier_order.dart';
import 'package:road_runner_app/data/services/courier_order_service.dart';
import 'package:road_runner_app/viewmodels/base_viewmodel.dart';

/// Kabul edilmiş aktif siparişin teslimat akışını yöneten ViewModel.
/// Akış: ASSIGNED → (Teslim Al) → PICKED_UP → (Yola Çık) → IN_TRANSIT → (Teslim Et) → DELIVERED
class ActiveDeliveryViewModel extends BaseViewModel {
  final CourierOrderService _orderService;

  ActiveDeliveryViewModel({required CourierOrderService orderService})
      : _orderService = orderService;

  factory ActiveDeliveryViewModel.fromLocator() => ActiveDeliveryViewModel(
        orderService: locator<CourierOrderService>(),
      );

  CourierOrder? _order;
  CourierOrder? get order => _order;
  bool get hasActiveOrder =>
      _order != null &&
      _order!.status != OrderStatus.delivered &&
      _order!.status != OrderStatus.cancelled;

  bool _actionInProgress = false;
  bool get actionInProgress => _actionInProgress;

  void _setBusy(bool v) {
    _actionInProgress = v;
    notifyListeners();
  }

  /// Kabul edilen siparişi ID ile yükle ve aktif teslimat olarak ayarla
  Future<bool> loadOrder(int orderId) async {
    setLoading();
    try {
      _order = await _orderService.getOrder(orderId);
      setSuccess();
      return true;
    } catch (e) {
      setError(CourierOrderService.extractError(e));
      return false;
    }
  }

  /// Uygulama açılışında devam eden aktif siparişi tespit et.
  /// (ASSIGNED / PICKED_UP / IN_TRANSIT durumundaki ilk sipariş)
  Future<void> restoreActiveOrder() async {
    try {
      for (final status in [
        OrderStatus.inTransit,
        OrderStatus.pickedUp,
        OrderStatus.assigned,
      ]) {
        final orders = await _orderService.getMyOrders(status: status);
        if (orders.isNotEmpty) {
          _order = orders.first;
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      debugPrint('[ActiveDeliveryVM] restore error: $e');
    }
  }

  /// Adım 1: Teslim Al (ASSIGNED → PICKED_UP)
  Future<bool> pickup({String? notes}) => _runStep(() =>
      _orderService.pickup(_order!.id, notes: notes));

  /// Adım 2: Yola Çık (PICKED_UP → IN_TRANSIT)
  Future<bool> startDelivery() =>
      _runStep(() => _orderService.startDelivery(_order!.id));

  /// Adım 3: Teslim Et (IN_TRANSIT → DELIVERED)
  Future<bool> complete({String? notes, double? collectionAmount}) =>
      _runStep(() => _orderService.complete(
            _order!.id,
            notes: notes,
            collectionAmount: collectionAmount,
          ));

  Future<bool> _runStep(Future<CourierOrder> Function() action) async {
    if (_order == null) return false;
    _setBusy(true);
    try {
      _order = await action();
      return true;
    } catch (e) {
      setError(CourierOrderService.extractError(e));
      return false;
    } finally {
      _setBusy(false);
    }
  }

  /// Teslimat tamamlandıktan sonra temizle
  void clear() {
    _order = null;
    setIdle();
  }
}

