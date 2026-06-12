/// Sipariş atama modeli — backend'den gelen WebSocket notification verisini temsil eder.
class AssignmentNotification {
  final String type; // NEW_ASSIGNMENT, ASSIGNMENT_TIMEOUT
  final int assignmentId;
  final int orderId;
  final String? assignedAt;
  final String? timeoutAt;
  final OrderDetails? orderDetails;

  AssignmentNotification({
    required this.type,
    required this.assignmentId,
    required this.orderId,
    this.assignedAt,
    this.timeoutAt,
    this.orderDetails,
  });

  factory AssignmentNotification.fromJson(Map<String, dynamic> json) {
    return AssignmentNotification(
      type: json['type'] as String? ?? '',
      assignmentId: (json['assignmentId'] as num?)?.toInt() ?? 0,
      orderId: (json['orderId'] as num?)?.toInt() ?? 0,
      assignedAt: json['assignedAt'] as String?,
      timeoutAt: json['timeoutAt'] as String?,
      orderDetails: json['orderDetails'] != null
          ? OrderDetails.fromJson(json['orderDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isNewAssignment => type == 'NEW_ASSIGNMENT';
  bool get isTimeout => type == 'ASSIGNMENT_TIMEOUT';
}

class OrderDetails {
  final String? pickupAddress;
  final String? deliveryAddress;
  final String? packageDescription;
  final double? deliveryFee;
  final String? endCustomerName;

  OrderDetails({
    this.pickupAddress,
    this.deliveryAddress,
    this.packageDescription,
    this.deliveryFee,
    this.endCustomerName,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      pickupAddress: json['pickupAddress'] as String?,
      deliveryAddress: json['deliveryAddress'] as String?,
      packageDescription: json['packageDescription'] as String?,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
      endCustomerName: json['endCustomerName'] as String?,
    );
  }
}

