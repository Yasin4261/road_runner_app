import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:road_runner_app/models/runner_model.dart';
import 'package:road_runner_app/services/runner_service.dart';
import 'package:road_runner_app/services/auth_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final RunnerService _runnerService = RunnerService();
  final AuthService _authService = AuthService();
  Runner? _runner;
  bool _isLoading = false;

  Runner? get runner => _runner;
  bool get isLoading => _isLoading;

  Future<void> fetchRunnerProfile(String runnerId) async {
    _setLoading(true);
    try {
      _runner = await _runnerService.getRunnerProfile(runnerId);
    } catch (e) {
      print('Failed to fetch runner profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
