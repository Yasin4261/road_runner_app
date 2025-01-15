import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://your-api-url.com'; // API URL'nizi buraya yazın

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Token'ı kaydet
        final token = data['token'];
        // TODO: Token'ı güvenli bir şekilde saklayın
        return data;
      } else {
        throw Exception(data['message'] ?? 'Giriş başarısız');
      }
    } catch (e) {
      throw Exception('Bir hata oluştu: ${e.toString()}');
    }
  }
}