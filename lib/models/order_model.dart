import 'package:json_annotation/json_annotation.dart';
import 'location_model.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  final Customer customer;
  final Pickup pickup;
  final Delivery delivery;
  final double price;

  OrderModel({
    required this.customer,
    required this.pickup,
    required this.delivery,
    required this.price,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

@JsonSerializable()
class Customer {
  final String name;
  final String phone;
  final String address;

  Customer({required this.name, required this.phone, required this.address});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class Pickup {
  final String address;
  final LocationModel location;

  Pickup({required this.address, required this.location});

  factory Pickup.fromJson(Map<String, dynamic> json) => _$PickupFromJson(json);

  Map<String, dynamic> toJson() => _$PickupToJson(this);
}

@JsonSerializable()
class Delivery {
  final String address;
  final LocationModel location;

  Delivery({required this.address, required this.location});

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryToJson(this);
}
