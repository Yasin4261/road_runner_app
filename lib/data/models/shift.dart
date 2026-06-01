import 'package:road_runner_app/core/enums/shift_enums.dart';
import 'package:road_runner_app/core/utils/date_formatter.dart';

/// Vardiya - Backend ShiftDto karşılığı
class Shift {
  final int shiftId;
  final int? courierId;
  final String? courierName;
  final DateTime startTime;
  final DateTime endTime;
  final ShiftRole? shiftRole;
  final ShiftStatus status;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? notes;
  final DateTime? createdAt;

  Shift({
    required this.shiftId,
    this.courierId,
    this.courierName,
    required this.startTime,
    required this.endTime,
    this.shiftRole,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.notes,
    this.createdAt,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      shiftId: (json['shiftId'] as num).toInt(),
      courierId: (json['courierId'] as num?)?.toInt(),
      courierName: json['courierName'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      shiftRole: ShiftRole.fromString(json['shiftRole'] as String?),
      status:
          ShiftStatus.fromString(json['status'] as String?) ?? ShiftStatus.reserved,
      checkInTime: _parseDate(json['checkInTime']),
      checkOutTime: _parseDate(json['checkOutTime']),
      notes: json['notes'] as String?,
      createdAt: _parseDate(json['createdAt']),
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

  bool get canCheckIn => status == ShiftStatus.reserved;
  bool get canCheckOut => status == ShiftStatus.checkedIn;
  bool get canCancel => status == ShiftStatus.reserved;
  bool get isActive => status == ShiftStatus.checkedIn;

  String get dayLabel => DateFormatter.dayLabel(startTime.toLocal());

  String get timeRange {
    return '${DateFormatter.hm(startTime.toLocal())} - '
        '${DateFormatter.hm(endTime.toLocal())}';
  }

  Duration get duration => endTime.difference(startTime);
}



