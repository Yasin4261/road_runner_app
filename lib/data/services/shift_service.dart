import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:road_runner_app/core/constants/api_constants.dart';
import 'package:road_runner_app/core/enums/shift_enums.dart';
import 'package:road_runner_app/core/events/auth_events.dart';
import 'package:road_runner_app/core/utils/date_formatter.dart';
import 'package:road_runner_app/data/models/shift.dart';
import 'package:road_runner_app/data/models/shift_template.dart';
import 'package:road_runner_app/data/services/auth_storage.dart';

/// Kurye vardiya işlemleri için API servisi.
/// Backend: /api/v1/courier/shifts/**
class ShiftService {
  final Dio _dio;

  ShiftService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': ApiConstants.contentType},
            )) {
    // Her istekte JWT token'ı otomatik ekle + ayrıntılı log
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await AuthStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers[ApiConstants.authorization] =
              '${ApiConstants.bearer} $token';
          debugPrint('[ShiftService] → ${options.method} ${options.uri} '
              '(token: ${token.substring(0, token.length < 20 ? token.length : 20)}...)');
        } else {
          debugPrint('[ShiftService] → ${options.method} ${options.uri} '
              '(⚠️ TOKEN YOK - kullanıcı login değil mi?)');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint(
            '[ShiftService] ← ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (err, handler) {
        debugPrint('[ShiftService] ✗ ${err.requestOptions.method} '
            '${err.requestOptions.uri} → ${err.response?.statusCode} '
            '${err.response?.data ?? err.message}');

        // 401 → token süresi dolmuş / geçersiz: oturumu temizle ve
        // uygulamayı login ekranına yönlendir.
        if (err.response?.statusCode == 401) {
          debugPrint('[ShiftService] 401 algılandı → oturum sonlandırılıyor');
          AuthStorage.clear();
          AuthEvents.instance.notifySessionExpired();
        }
        return handler.next(err);
      },
    ));
  }

  // ---------- Templates ----------

  Future<List<ShiftTemplate>> getTemplates() async {
    final res = await _dio.get(ApiConstants.shiftTemplates);
    final list = _extractList(res.data);
    return list
        .map((e) => ShiftTemplate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ---------- Reserve / Cancel ----------

  Future<Shift> reserveShift({
    required int templateId,
    required DateTime shiftDate,
    String? notes,
  }) async {
    final res = await _dio.post(
      ApiConstants.shiftReserve,
      data: {
        'templateId': templateId,
        'shiftDate': DateFormatter.iso(shiftDate),
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
    return Shift.fromJson(_extractObject(res.data));
  }

  Future<void> cancelShift(int shiftId) async {
    await _dio.delete(ApiConstants.shiftCancel(shiftId));
  }

  // ---------- Listeler ----------

  Future<List<Shift>> getUpcomingShifts() async {
    final res = await _dio.get(ApiConstants.shiftUpcoming);
    final list = _extractList(res.data);
    return list.map((e) => Shift.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Shift>> getMyShifts({ShiftStatus? status}) async {
    final res = await _dio.get(
      ApiConstants.shiftMine,
      queryParameters: status != null ? {'status': status.apiValue} : null,
    );
    final list = _extractList(res.data);
    return list.map((e) => Shift.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Shift?> getActiveShift() async {
    final res = await _dio.get(ApiConstants.shiftActive);
    final raw = res.data is Map ? res.data['data'] : null;
    if (raw == null) return null;
    return Shift.fromJson(raw as Map<String, dynamic>);
  }

  // ---------- Check-in / Check-out ----------

  Future<Shift> checkIn(
    int shiftId, {
    String? notes,
    double? latitude,
    double? longitude,
  }) async {
    final body = <String, dynamic>{};
    if (notes != null && notes.isNotEmpty) body['notes'] = notes;
    if (latitude != null) body['latitude'] = latitude;
    if (longitude != null) body['longitude'] = longitude;

    final res = await _dio.post(
      ApiConstants.shiftCheckIn(shiftId),
      data: body.isEmpty ? null : body,
    );
    return Shift.fromJson(_extractObject(res.data));
  }

  Future<Shift> checkOut(
    int shiftId, {
    String? notes,
    double? latitude,
    double? longitude,
  }) async {
    final body = <String, dynamic>{};
    if (notes != null && notes.isNotEmpty) body['notes'] = notes;
    if (latitude != null) body['latitude'] = latitude;
    if (longitude != null) body['longitude'] = longitude;

    final res = await _dio.post(
      ApiConstants.shiftCheckOut(shiftId),
      data: body.isEmpty ? null : body,
    );
    return Shift.fromJson(_extractObject(res.data));
  }

  // ---------- Helpers ----------

  /// Backend response yapısı: { code, data, message, respondedAt }
  List<dynamic> _extractList(dynamic raw) {
    if (raw is Map && raw['data'] is List) {
      return raw['data'] as List<dynamic>;
    }
    if (raw is List) return raw;
    return const [];
  }

  Map<String, dynamic> _extractObject(dynamic raw) {
    if (raw is Map && raw['data'] is Map) {
      return Map<String, dynamic>.from(raw['data'] as Map);
    }
    if (raw is Map) return Map<String, dynamic>.from(raw);
    throw const FormatException('Unexpected shift response format');
  }

  /// DioException → kullanıcı dostu mesaj
  static String extractError(Object error) {
    if (error is DioException) {
      final baseUrl = ApiConstants.baseUrl;

      // Bağlantı / timeout hataları
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Sunucu yanıt vermedi (timeout).\n'
              'API adresi: $baseUrl\n'
              '• Telefonunuz backend ile aynı ağda mı?\n'
              '• Android emülatörde iseniz IP "10.0.2.2:8081" olmalı.';
        case DioExceptionType.connectionError:
          return 'Sunucuya bağlanılamadı.\n'
              'API adresi: $baseUrl\n'
              '• Backend çalışıyor mu? (http://localhost:8081/actuator/health)\n'
              '• Telefon ile bilgisayar aynı WiFi\'da mı?\n'
              '• Android emülatörde iseniz IP "10.0.2.2:8081" olmalı.\n'
              '• Detay: ${error.message ?? ''}';
        case DioExceptionType.badCertificate:
          return 'SSL sertifika hatası: ${error.message ?? ''}';
        case DioExceptionType.cancel:
          return 'İstek iptal edildi';
        case DioExceptionType.badResponse:
        case DioExceptionType.unknown:
          break;
      }

      // HTTP error response
      final data = error.response?.data;
      final status = error.response?.statusCode;
      String backendMsg = '';
      if (data is Map && data['message'] is String) {
        backendMsg = data['message'] as String;
      }

      switch (status) {
        case 400:
          return 'Geçersiz istek${backendMsg.isNotEmpty ? ": $backendMsg" : ""}';
        case 401:
          return 'Oturum geçersiz veya süresi doldu.\n'
              'Lütfen çıkış yapıp tekrar giriş yapın.';
        case 403:
          return 'Bu işlem için yetkiniz yok'
              '${backendMsg.isNotEmpty ? ": $backendMsg" : ""}';
        case 404:
          return 'Kayıt bulunamadı${backendMsg.isNotEmpty ? ": $backendMsg" : ""}';
        case 409:
          return 'Çakışma: bu vardiya zaten alınmış olabilir'
              '${backendMsg.isNotEmpty ? "\n$backendMsg" : ""}';
        case 500:
          return 'Sunucu hatası (500)'
              '${backendMsg.isNotEmpty ? "\n$backendMsg" : ""}';
      }

      debugPrint('[ShiftService] Dio error fallthrough: ${error.message}');
      return backendMsg.isNotEmpty
          ? backendMsg
          : 'Bilinmeyen ağ hatası (${error.type}) - ${error.message ?? ""}';
    }
    return error.toString();
  }
}

