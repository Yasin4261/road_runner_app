import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:road_runner_app/services/runner_service.dart';
import 'package:road_runner_app/services/api_service.dart';

class ShiftViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _apiService = ApiService();
  final RunnerService _runnerService = RunnerService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> startShift(String runnerId) async {
    _setLoading(true);

    try {
      String? token = await _auth.currentUser?.getIdToken();
      if (token != null) {
        await _apiService
            .setAuthToken(token); // Set the auth token in AuthService
        await _runnerService.startShift(runnerId);
      }
    } catch (e) {
      print('Failed to start shift: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> endShift(String runnerId) async {
    _setLoading(true);

    try {
      await _runnerService.endShift(runnerId);
      print('Shift ended');
    } catch (e) {
      print('Failed to end shift: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
