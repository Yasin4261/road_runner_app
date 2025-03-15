import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:road_runner_app/services/api_service.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.1.106:3001'; // API URL
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _apiService = ApiService();

  Future<void> login(String email, String password) async {
    try {
      // Firebase Authentication ile giriş yap
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kullanıcı token'ını al
      String? token = await userCredential.user?.getIdToken();
      print(
          'Firebase Token: $token'); // Token'ı konsola yazdırarak kontrol edin

      // Web API'ye token ile giriş yap
      if (token != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/login'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          print('Login successful');
          await _apiService
              .setAuthToken(token); // Set the auth token in ApiService
        } else {
          print('Login failed: ${response.statusCode}');
          throw Exception('Login failed: ${response.statusCode}');
        }
      } else {
        print('Token alınamadı');
        throw Exception('Token alınamadı');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Authentication hatası: ${e.message}');
      throw e;
    } catch (e) {
      print('Bir hata oluştu: ${e.toString()}');
      throw e;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _apiService.clearAuthToken();
  }

  /*

  Future<void> startShift(String runnerId) async {
    String? token = await _auth.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('Token alınamadı');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/runners/$runnerId/start-shift'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> runner = json.decode(response.body);
      print('Kurye vardiyaya başladı: $runner');
    } else if (response.statusCode == 400) {
      Map<String, dynamic> error = json.decode(response.body);
      print('Vardiyaya başlama başarısız: ${error['message']}');
      throw Exception('Vardiyaya başlama başarısız: ${error['message']}');
    } else {
      print('Vardiyaya başlama başarısız: ${response.statusCode}');
      throw Exception('Vardiyaya başlama başarısız: ${response.statusCode}');
    }
  }

  Future<void> endShift(String runnerId) async {
    String? token = await _auth.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('Token alınamadı');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/runners/$runnerId/end-shift'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> runner = json.decode(response.body);
      print('Kurye vardiyayı sonlandırdı: $runner');
    } else if (response.statusCode == 400) {
      Map<String, dynamic> error = json.decode(response.body);
      print('Vardiyayı sonlandırma başarısız: ${error['message']}');
      throw Exception('Vardiyayı sonlandırma başarısız: ${error['message']}');
    } else {
      print('Vardiyayı sonlandırma başarısız: ${response.statusCode}');
      throw Exception(
          'Vardiyayı sonlandırma başarısız: ${response.statusCode}');
    }
  }
  */

  // Diğer istek fonksiyonları burada...
}
