// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Runner _$RunnerFromJson(Map<String, dynamic> json) => Runner(
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      password: json['password'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      vehicleType: $enumDecode(_$VehicleTypeEnumMap, json['vehicleType']),
      currentStatus: $enumDecode(_$CurrentStatusEnumMap, json['currentStatus']),
      shiftStartTime: json['shiftStartTime'] as String,
      queuePosition: (json['queuePosition'] as num).toInt(),
    );

Map<String, dynamic> _$RunnerToJson(Runner instance) => <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'password': instance.password,
      'profileImageUrl': instance.profileImageUrl,
      'vehicleType': _$VehicleTypeEnumMap[instance.vehicleType]!,
      'currentStatus': _$CurrentStatusEnumMap[instance.currentStatus]!,
      'shiftStartTime': instance.shiftStartTime,
      'queuePosition': instance.queuePosition,
    };

const _$VehicleTypeEnumMap = {
  VehicleType.bicycle: 'bicycle',
  VehicleType.motorcycle: 'motorcycle',
  VehicleType.car: 'car',
};

const _$CurrentStatusEnumMap = {
  CurrentStatus.offline: 'offline',
  CurrentStatus.available: 'available',
  CurrentStatus.busy: 'busy',
  CurrentStatus.onBreak: 'onBreak',
};
