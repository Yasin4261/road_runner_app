import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:road_runner_app/services/auth_service.dart';

class ShiftViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> startShift(String runnerId) async {
    _setLoading(true);

    try {
      String? token = await _auth.currentUser?.getIdToken();
      if (token != null) {
        await _authService.startShift(token, runnerId);
      }
    } catch (e) {
      print('Failed to start shift: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
