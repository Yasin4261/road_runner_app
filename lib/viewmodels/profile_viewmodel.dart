import 'package:flutter/material.dart';
import 'package:road_runner_app/models/runner_model.dart';
import 'package:road_runner_app/services/runner_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final RunnerService _runnerService = RunnerService();
  Runner? _runner;
  bool _isLoading = false;

  Runner? get runner => _runner;
  bool get isLoading => _isLoading;

  Future<void> loadRunnerProfile(String runnerId) async {
    _setLoading(true);
    try {
      _runner = await _runnerService.getRunnerProfile(runnerId);
    } catch (e) {
      print('Kurye profili yüklenemedi: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    // Logout işlemi burada yapılabilir
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
