import 'dart:convert';

import 'package:flutter/foundation.dart';

/// JWT token yardımcıları - harici paket olmadan payload decode eder.
class JwtUtils {
  JwtUtils._();

  /// Token'ın payload kısmındaki claim'leri Map olarak döndürür.
  /// Geçersiz token'da null döner.
  static Map<String, dynamic>? decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // base64url → normalize (padding ekle)
      var payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      switch (payload.length % 4) {
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }

      final decoded = utf8.decode(base64.decode(payload));
      final map = jsonDecode(decoded);
      return map is Map<String, dynamic> ? map : null;
    } catch (e) {
      debugPrint('[JwtUtils] decode error: $e');
      return null;
    }
  }

  /// Token'ın son geçerlilik zamanı (exp claim). Yoksa null.
  static DateTime? expiry(String token) {
    final payload = decodePayload(token);
    final exp = payload?['exp'];
    if (exp is int) {
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    }
    if (exp is num) {
      return DateTime.fromMillisecondsSinceEpoch(
          (exp.toInt()) * 1000,
          isUtc: true);
    }
    return null;
  }

  /// Token süresi dolmuş mu? (60 sn güvenlik payı ile)
  /// exp claim yoksa "dolmamış" kabul edilir (false).
  static bool isExpired(String token) {
    final exp = expiry(token);
    if (exp == null) return false;
    final now = DateTime.now().toUtc().add(const Duration(seconds: 60));
    return now.isAfter(exp);
  }
}

