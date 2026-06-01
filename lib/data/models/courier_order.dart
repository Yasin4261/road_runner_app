import 'package:road_runner_app/core/enums/order_status.dart';

/// Kurye sipariş modeli - Backend Order entity'sinin JSON karşılığı.
/// Hem aktif teslimat hem geçmiş için kullanılır.
class CourierOrder {
  final int id;
  final String orderNumber;
  final OrderStatus status;
  final String? priority;

  // İşletme (restoran)
  final String? businessName;
  final String? businessPhone;
  final String? pickupContactPerson;

  // Müşteri
  final String? endCustomerName;
  final String? endCustomerPhone;

  // Adresler
  final String pickupAddress;
  final String? pickupAddressDescription;
  final String deliveryAddress;
  final String? deliveryAddressDescription;

  // Koordinatlar
  final double? pickupLatitude;
  final double? pickupLongitude;
  final double? deliveryLatitude;
  final double? deliveryLongitude;

  // Paket
  final String? packageDescription;
  final num? packageWeight;
  final int? packageCount;

  // Ödeme
  final String? paymentType;
  final num? deliveryFee;
  final num? collectionAmount;

  final String? businessNotes;
  final String? courierNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CourierOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    this.priority,
    this.businessName,
    this.businessPhone,
    this.pickupContactPerson,
    this.endCustomerName,
    this.endCustomerPhone,
    required this.pickupAddress,
    this.pickupAddressDescription,
    required this.deliveryAddress,
    this.deliveryAddressDescription,
    this.pickupLatitude,
    this.pickupLongitude,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.packageDescription,
    this.packageWeight,
    this.packageCount,
    this.paymentType,
    this.deliveryFee,
    this.collectionAmount,
    this.businessNotes,
    this.courierNotes,
    this.createdAt,
    this.updatedAt,
  });

  factory CourierOrder.fromJson(Map<String, dynamic> json) {
    // business iç içe obje olarak da gelebilir (Order entity) veya düz alan (OrderResponse)
    final business = json['business'];
    String? bizName;
    if (business is Map) {
      bizName = business['name'] as String?;
    }
    bizName ??= json['businessName'] as String?;

    return CourierOrder(
      id: (json['id'] ?? json['orderId'] as num).toInt(),
      orderNumber: json['orderNumber'] as String? ?? '',
      status: OrderStatus.fromString(json['status'] as String?) ??
          OrderStatus.assigned,
      priority: json['priority'] as String?,
      businessName: bizName,
      businessPhone: json['businessPhone'] as String?,
      pickupContactPerson: json['pickupContactPerson'] as String?,
      endCustomerName: json['endCustomerName'] as String?,
      endCustomerPhone: json['endCustomerPhone'] as String?,
      pickupAddress: json['pickupAddress'] as String? ?? '',
      pickupAddressDescription: json['pickupAddressDescription'] as String?,
      deliveryAddress: json['deliveryAddress'] as String? ?? '',
      deliveryAddressDescription:
          json['deliveryAddressDescription'] as String?,
      pickupLatitude: (json['pickupLatitude'] as num?)?.toDouble(),
      pickupLongitude: (json['pickupLongitude'] as num?)?.toDouble(),
      deliveryLatitude: (json['deliveryLatitude'] as num?)?.toDouble(),
      deliveryLongitude: (json['deliveryLongitude'] as num?)?.toDouble(),
      packageDescription: json['packageDescription'] as String?,
      packageWeight: json['packageWeight'] as num?,
      packageCount: (json['packageCount'] as num?)?.toInt(),
      paymentType: json['paymentType'] as String?,
      deliveryFee: json['deliveryFee'] as num?,
      collectionAmount: json['collectionAmount'] as num?,
      businessNotes: json['businessNotes'] as String?,
      courierNotes: json['courierNotes'] as String?,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    try {
      return DateTime.parse(raw.toString());
    } catch (_) {
      return null;
    }
  }

  bool get hasPickupLocation =>
      pickupLatitude != null && pickupLongitude != null;
  bool get hasDeliveryLocation =>
      deliveryLatitude != null && deliveryLongitude != null;

  /// Ödeme tipinin Türkçe etiketi
  String get paymentLabel {
    switch (paymentType) {
      case 'CASH':
        return 'Nakit';
      case 'CREDIT_CARD':
        return 'Kredi Kartı';
      case 'BUSINESS_ACCOUNT':
        return 'İşletme Hesabı';
      case 'CASH_ON_DELIVERY':
        return 'Kapıda Nakit';
      case 'ONLINE':
        return 'Online';
      default:
        return paymentType ?? '-';
    }
  }
}

