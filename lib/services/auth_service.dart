import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static const String baseUrl =
      'http://192.168.1.106:3001'; // API URL'nizi buraya yazın
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> startShift(String token, String runnerId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/runners/$runnerId/start-shift'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> runner = json.decode(response.body);
      print('Kurye vardiyaya başladı: $runner');
    } else {
      print('Vardiyaya başlama başarısız: ${response.statusCode}');
    }
  }

  // Diğer istek fonksiyonları burada...
}
