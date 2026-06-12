/// Sipariş durumu - Backend OrderStatus enum'una karşılık gelir
enum OrderStatus {
  pending,
  assigned,
  pickedUp,
  inTransit,
  delivered,
  cancelled,
  returned;

  String get apiValue {
    switch (this) {
      case OrderStatus.pending:
        return 'PENDING';
      case OrderStatus.assigned:
        return 'ASSIGNED';
      case OrderStatus.pickedUp:
        return 'PICKED_UP';
      case OrderStatus.inTransit:
        return 'IN_TRANSIT';
      case OrderStatus.delivered:
        return 'DELIVERED';
      case OrderStatus.cancelled:
        return 'CANCELLED';
      case OrderStatus.returned:
        return 'RETURNED';
    }
  }

  String get displayLabel {
    switch (this) {
      case OrderStatus.pending:
        return 'Bekliyor';
      case OrderStatus.assigned:
        return 'Atandı';
      case OrderStatus.pickedUp:
        return 'Teslim Alındı';
      case OrderStatus.inTransit:
        return 'Yolda';
      case OrderStatus.delivered:
        return 'Teslim Edildi';
      case OrderStatus.cancelled:
        return 'İptal';
      case OrderStatus.returned:
        return 'İade';
    }
  }

  static OrderStatus? fromString(String? value) {
    if (value == null) return null;
    switch (value.toUpperCase()) {
      case 'PENDING':
        return OrderStatus.pending;
      case 'ASSIGNED':
        return OrderStatus.assigned;
      case 'PICKED_UP':
        return OrderStatus.pickedUp;
      case 'IN_TRANSIT':
        return OrderStatus.inTransit;
      case 'DELIVERED':
        return OrderStatus.delivered;
      case 'CANCELLED':
        return OrderStatus.cancelled;
      case 'RETURNED':
        return OrderStatus.returned;
    }
    return null;
  }
}

