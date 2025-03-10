// flutter pub run build_runner build

import 'package:json_annotation/json_annotation.dart';

part 'runner_model.g.dart';

enum VehicleType { bicycle, motorcycle, car }

enum CurrentStatus { offline, available, busy, onBreak }

@JsonSerializable()
class Runner {
  final String? name;
  final String? phone;
  final String? email;
  final String? password;
  final String? profileImageUrl;
  final VehicleType? vehicleType;
  final CurrentStatus? currentStatus;
  final String? shiftStartTime;
  final int? queuePosition;

  Runner({
    this.name,
    this.phone,
    this.email,
    this.password,
    this.profileImageUrl,
    this.vehicleType,
    this.currentStatus,
    this.shiftStartTime,
    this.queuePosition,
  });

  factory Runner.fromJson(Map<String, dynamic> json) => _$RunnerFromJson(json);
  Map<String, dynamic> toJson() => _$RunnerToJson(this);
}
