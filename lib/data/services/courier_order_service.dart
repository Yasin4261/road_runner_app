import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:road_runner_app/core/constants/api_constants.dart';
import 'package:road_runner_app/core/enums/order_status.dart';
import 'package:road_runner_app/core/events/auth_events.dart';
import 'package:road_runner_app/data/models/courier_order.dart';
import 'package:road_runner_app/data/services/auth_storage.dart';

/// Kurye sipariş ve atama işlemleri için API servisi.
/// - Atama: pending / accept / reject
/// - Sipariş akışı: getOrder / pickup / start-delivery / complete
class CourierOrderService {
  final Dio _dio;

  CourierOrderService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': ApiConstants.contentType},
            )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await AuthStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers[ApiConstants.authorization] =
              '${ApiConstants.bearer} $token';
        }
        debugPrint('[CourierOrderService] → ${options.method} ${options.uri}');
        return handler.next(options);
      },
      onError: (err, handler) {
        debugPrint('[CourierOrderService] ✗ ${err.requestOptions.uri} → '
            '${err.response?.statusCode} ${err.response?.data ?? err.message}');
        if (err.response?.statusCode == 401) {
          AuthStorage.clear();
          AuthEvents.instance.notifySessionExpired();
        }
        return handler.next(err);
      },
    ));
  }

  // ---------- Atama ----------

  /// Bekleyen atamaları getir (kurye token ile)
  Future<List<Map<String, dynamic>>> getPendingAssignments() async {
    final res = await _dio.get(ApiConstants.pendingAssignments);
    final data = res.data is Map ? res.data['data'] : null;
    if (data is List) {
      return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return const [];
  }

  /// Atamayı kabul et → sipariş ASSIGNED olur
  Future<void> acceptAssignment(int assignmentId) async {
    await _dio.post('${ApiConstants.acceptAssignment}/$assignmentId/accept');
  }

  /// Atamayı reddet
  Future<void> rejectAssignment(int assignmentId, {String? reason}) async {
    await _dio.post(
      '${ApiConstants.rejectAssignment}/$assignmentId/reject',
      data: {'reason': reason ?? 'Belirtilmedi'},
    );
  }

  // ---------- Sipariş akışı ----------

  /// Kuryenin siparişlerini getir (status ile filtrelenebilir)
  Future<List<CourierOrder>> getMyOrders({OrderStatus? status}) async {
    final res = await _dio.get(
      ApiConstants.courierOrders,
      queryParameters: status != null ? {'status': status.apiValue} : null,
    );
    final data = res.data is Map ? res.data['data'] : null;
    if (data is List) {
      return data
          .map((e) => CourierOrder.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return const [];
  }

  /// Sipariş detayını getir
  Future<CourierOrder> getOrder(int orderId) async {
    final res = await _dio.get('${ApiConstants.courierOrders}/$orderId');
    return CourierOrder.fromJson(_extractObject(res.data));
  }

  /// Siparişi teslim al (ASSIGNED → PICKED_UP)
  Future<CourierOrder> pickup(int orderId, {String? notes}) async {
    final res = await _dio.post(
      '${ApiConstants.courierOrders}/$orderId/pickup',
      queryParameters: notes != null ? {'notes': notes} : null,
    );
    return CourierOrder.fromJson(_extractObject(res.data));
  }

  /// Teslimatı başlat (PICKED_UP → IN_TRANSIT)
  Future<CourierOrder> startDelivery(int orderId) async {
    final res =
        await _dio.post('${ApiConstants.courierOrders}/$orderId/start-delivery');
    return CourierOrder.fromJson(_extractObject(res.data));
  }

  /// Teslimatı tamamla (IN_TRANSIT → DELIVERED)
  Future<CourierOrder> complete(
    int orderId, {
    String? notes,
    double? collectionAmount,
  }) async {
    final params = <String, dynamic>{};
    if (notes != null) params['notes'] = notes;
    if (collectionAmount != null) params['collectionAmount'] = collectionAmount;

    final res = await _dio.post(
      '${ApiConstants.courierOrders}/$orderId/complete',
      queryParameters: params.isEmpty ? null : params,
    );
    return CourierOrder.fromJson(_extractObject(res.data));
  }

  // ---------- Helpers ----------

  Map<String, dynamic> _extractObject(dynamic raw) {
    if (raw is Map && raw['data'] is Map) {
      return Map<String, dynamic>.from(raw['data'] as Map);
    }
    if (raw is Map) return Map<String, dynamic>.from(raw);
    throw const FormatException('Beklenmeyen sipariş yanıtı');
  }

  static String extractError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] is String) {
        return data['message'] as String;
      }
      switch (error.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
          return 'Sunucuya bağlanılamadı';
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return 'Sunucu yanıt vermedi';
        default:
          break;
      }
      switch (error.response?.statusCode) {
        case 401:
          return 'Oturum geçersiz, tekrar giriş yapın';
        case 403:
          return 'Bu işlem için yetkiniz yok';
        case 404:
          return 'Sipariş bulunamadı';
        case 409:
          return 'Sipariş başka bir kuryeye atanmış olabilir';
      }
      return 'Bir hata oluştu';
    }
    return error.toString();
  }
}



