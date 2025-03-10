// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      pickup: Pickup.fromJson(json['pickup'] as Map<String, dynamic>),
      delivery: Delivery.fromJson(json['delivery'] as Map<String, dynamic>),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'customer': instance.customer,
      'pickup': instance.pickup,
      'delivery': instance.delivery,
      'price': instance.price,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

Pickup _$PickupFromJson(Map<String, dynamic> json) => Pickup(
      address: json['address'] as String,
      location:
          LocationModel.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PickupToJson(Pickup instance) => <String, dynamic>{
      'address': instance.address,
      'location': instance.location,
    };

Delivery _$DeliveryFromJson(Map<String, dynamic> json) => Delivery(
      address: json['address'] as String,
      location:
          LocationModel.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeliveryToJson(Delivery instance) => <String, dynamic>{
      'address': instance.address,
      'location': instance.location,
    };
