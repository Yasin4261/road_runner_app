import 'package:road_runner_app/core/enums/shift_enums.dart';

/// Vardiya şablonu - Backend ShiftTemplateDto karşılığı
class ShiftTemplate {
  final int templateId;
  final String name;
  final String? description;
  final String startTime; // "HH:mm" formatında (LocalTime serialize)
  final String endTime;
  final ShiftRole? defaultRole;
  final int? maxCouriers;
  final bool isActive;

  ShiftTemplate({
    required this.templateId,
    required this.name,
    this.description,
    required this.startTime,
    required this.endTime,
    this.defaultRole,
    this.maxCouriers,
    this.isActive = true,
  });

  factory ShiftTemplate.fromJson(Map<String, dynamic> json) {
    return ShiftTemplate(
      templateId: (json['templateId'] as num).toInt(),
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      startTime: _parseTime(json['startTime']),
      endTime: _parseTime(json['endTime']),
      defaultRole: ShiftRole.fromString(json['defaultRole'] as String?),
      maxCouriers: (json['maxCouriers'] as num?)?.toInt(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// LocalTime backend'den "HH:mm:ss" veya "HH:mm" olarak gelebilir
  static String _parseTime(dynamic raw) {
    if (raw == null) return '--:--';
    final s = raw.toString();
    // HH:mm:ss → HH:mm
    if (s.length >= 5) return s.substring(0, 5);
    return s;
  }

  String get timeRange => '$startTime - $endTime';
}

