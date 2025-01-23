import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:road_runner_app/models/user_model.dart';
import 'package:road_runner_app/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> login(UserModel user, BuildContext context) async {
    _setLoading(true);

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      // Kullanıcı token'ını al
      String? token = await userCredential.user?.getIdToken();

      // Web API'ye token ile giriş yap
      if (token != null) {
        bool loginSuccess = await _authService.loginWithToken(token);
        if (loginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login failed: Invalid token'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchData(String endpoint) async {
    _setLoading(true);

    try {
      String? token = await _auth.currentUser?.getIdToken();
      if (token != null) {
        final response = await _authService.getRequest(endpoint, token);
        print('Data fetched: ${response.body}');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> postData(String endpoint, Map<String, dynamic> data) async {
    _setLoading(true);

    try {
      String? token = await _auth.currentUser?.getIdToken();
      if (token != null) {
        final response = await _authService.postRequest(endpoint, token, data);
        print('Data posted: ${response.body}');
      }
    } catch (e) {
      print('Failed to post data: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateData(String endpoint, Map<String, dynamic> data) async {
    _setLoading(true);

    try {
      String? token = await _auth.currentUser?.getIdToken();
      if (token != null) {
        final response = await _authService.putRequest(endpoint, token, data);
        print('Data updated: ${response.body}');
      }
    } catch (e) {
      print('Failed to update data: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteData(String endpoint) async {
    _setLoading(true);

    try {
      String? token = await _auth.currentUser?.getIdToken();
      if (token != null) {
        final response = await _authService.deleteRequest(endpoint, token);
        print('Data deleted: ${response.body}');
      }
    } catch (e) {
      print('Failed to delete data: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
