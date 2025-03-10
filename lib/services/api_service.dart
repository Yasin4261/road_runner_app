import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  late Dio _dio;
  static const String _baseUrl =
      "http://192.168.1.106:3001/api"; // API Base URL

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );
  }

  /// **Auth Token Kaydet**
  Future<void> setAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
  }

  /// **Auth Token Al**
  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  /// **Auth Token Sil (Logout)**
  Future<void> clearAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }

  /// **GET Request**
  Future<Response> getRequest(String endpoint,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      String? token = await getAuthToken();
      Map<String, dynamic> defaultHeaders = {
        "Authorization": token != null ? "Bearer $token" : "",
        ...?headers,
      };

      print("GET Request: $endpoint");
      final response = await _dio.get(
        endpoint,
        queryParameters: params,
        options: Options(headers: defaultHeaders),
      );
      print("GET Response: ${response.statusCode} - ${response.data}");
      return response;
    } on DioException catch (e) {
      _handleError(e);
      throw Exception("GET isteği başarısız: ${e.message}");
    }
  }

  /// **POST Request**
  Future<Response> postRequest(String endpoint, dynamic data,
      {Map<String, dynamic>? headers}) async {
    try {
      String? token = await getAuthToken();
      Map<String, dynamic> defaultHeaders = {
        "Authorization": token != null ? "Bearer $token" : "",
        ...?headers,
      };

      print("POST Request: $endpoint");
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: defaultHeaders),
      );
      print("POST Response: ${response.statusCode} - ${response.data}");
      return response;
    } on DioException catch (e) {
      _handleError(e);
      throw Exception("POST isteği başarısız: ${e.message}");
    }
  }

  /// **PUT Request**
  Future<Response> putRequest(String endpoint, dynamic data,
      {Map<String, dynamic>? headers}) async {
    try {
      String? token = await getAuthToken();
      Map<String, dynamic> defaultHeaders = {
        "Authorization": token != null ? "Bearer $token" : "",
        ...?headers,
      };

      print("PUT Request: $endpoint");
      final response = await _dio.put(
        endpoint,
        data: data,
        options: Options(headers: defaultHeaders),
      );
      print("PUT Response: ${response.statusCode} - ${response.data}");
      return response;
    } on DioException catch (e) {
      _handleError(e);
      throw Exception("PUT isteği başarısız: ${e.message}");
    }
  }

  /// **DELETE Request**
  Future<Response> deleteRequest(String endpoint,
      {Map<String, dynamic>? headers}) async {
    try {
      String? token = await getAuthToken();
      Map<String, dynamic> defaultHeaders = {
        "Authorization": token != null ? "Bearer $token" : "",
        ...?headers,
      };

      print("DELETE Request: $endpoint");
      final response = await _dio.delete(
        endpoint,
        options: Options(headers: defaultHeaders),
      );
      print("DELETE Response: ${response.statusCode} - ${response.data}");
      return response;
    } on DioException catch (e) {
      _handleError(e);
      throw Exception("DELETE isteği başarısız: ${e.message}");
    }
  }

  /// **Hata Yönetimi**
  void _handleError(DioException e) {
    if (e.response != null) {
      print(
          "API Hata Kodu: ${e.response?.statusCode}, Mesaj: ${e.response?.data}");
    } else {
      print("Bağlantı hatası: ${e.message}");
    }
  }
}
