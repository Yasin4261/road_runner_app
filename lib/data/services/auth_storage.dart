import 'package:shared_preferences/shared_preferences.dart';
import 'package:road_runner_app/core/utils/jwt_utils.dart';

/// Oturum bilgilerini SharedPreferences'ta yönetir.
class AuthStorage {
  static const _keyToken = 'jwt_token';
  static const _keyUserId = 'user_id';
  static const _keyEmail = 'user_email';
  static const _keyName = 'user_name';
  static const _keyUserType = 'user_type';

  /// Token kaydet
  static Future<void> saveSession({
    required String token,
    required int userId,
    required String email,
    required String name,
    required String userType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyUserType, userType);
  }

  /// Token oku
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// UserId oku
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  /// Kullanıcı adı oku
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  /// Oturum geçerli mi?
  /// Token yoksa VEYA süresi dolmuşsa false döner.
  /// Süresi dolmuş token bulunursa otomatik temizlenir.
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;

    if (JwtUtils.isExpired(token)) {
      // Süresi dolmuş oturumu temizle ki app login ekranına yönlensin
      await clear();
      return false;
    }
    return true;
  }

  /// Token süresi dolmuş mu? (oturum açıkken kontrol için)
  static Future<bool> isTokenExpired() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return true;
    return JwtUtils.isExpired(token);
  }

  /// Oturumu temizle
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyName);
    await prefs.remove(_keyUserType);
  }
}

