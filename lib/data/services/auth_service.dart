import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:road_runner_app/core/constants/api_constants.dart';

/// Login response modeli
class LoginResponse {
  final String token;
  final int userId;
  final String email;
  final String name;
  final String userType;
  final String status;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.email,
    required this.name,
    required this.userType,
    required this.status,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String? ?? '',
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      userType: json['userType'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}

/// Kurye authentication servisi
class AuthService {
  final Dio _dio;

  AuthService() : _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  /// Kurye login
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/login',
        data: jsonEncode({'email': email, 'password': password}),
      );

      final data = response.data;
      // API response: { code: 200, data: { token, userId, ... }, message: "..." }
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return LoginResponse.fromJson(data['data'] as Map<String, dynamic>);
      }

      throw Exception('Unexpected response format');
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] ?? 'Login failed')
          : 'Sunucuya bağlanılamadı';
      debugPrint('[Auth] Login error: $message');
      throw Exception(message);
    }
  }
}

