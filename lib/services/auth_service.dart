import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl =
      'https://your-api-url.com'; // API URL'nizi buraya yazın

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

  Future<bool> loginWithToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Başarılı giriş
        print('Login successful');
        return true;
      } else {
        // Hata durumu
        final data = jsonDecode(response.body);
        print('Login failed: ${data['message']}');
        return false;
      }
    } catch (e) {
      print('An error occurred: ${e.toString()}');
      return false;
    }
  }

  Future<http.Response> getRequest(String endpoint, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<http.Response> postRequest(
      String endpoint, String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to post data');
    }
  }

  Future<http.Response> putRequest(
      String endpoint, String token, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<http.Response> deleteRequest(String endpoint, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to delete data');
    }
  }
}
