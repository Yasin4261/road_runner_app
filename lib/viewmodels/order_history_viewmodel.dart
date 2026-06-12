import 'package:flutter/foundation.dart';
import 'package:road_runner_app/core/di/service_locator.dart';
import 'package:road_runner_app/core/enums/order_status.dart';
import 'package:road_runner_app/data/models/courier_order.dart';
import 'package:road_runner_app/data/services/courier_order_service.dart';
import 'package:road_runner_app/viewmodels/base_viewmodel.dart';

/// Kuryenin sipariş geçmişini yöneten ViewModel.
/// Tamamlanan (DELIVERED) ve diğer geçmiş siparişleri listeler.
class OrderHistoryViewModel extends BaseViewModel {
  final CourierOrderService _orderService;

  OrderHistoryViewModel({required CourierOrderService orderService})
      : _orderService = orderService;

  factory OrderHistoryViewModel.fromLocator() => OrderHistoryViewModel(
        orderService: locator<CourierOrderService>(),
      );

  List<CourierOrder> _orders = const [];
  List<CourierOrder> get orders => _orders;

  List<CourierOrder> get delivered =>
      _orders.where((o) => o.status == OrderStatus.delivered).toList();

  /// Tüm siparişleri yükle (en yeni önce - backend sıralıyor)
  Future<void> load() async {
    setLoading();
    try {
      _orders = await _orderService.getMyOrders();
      setSuccess();
    } catch (e) {
      setError(CourierOrderService.extractError(e));
    }
  }

  Future<void> refresh() async {
    try {
      _orders = await _orderService.getMyOrders();
      notifyListeners();
    } catch (e) {
      debugPrint('[OrderHistoryVM] refresh error: $e');
    }
  }
}

