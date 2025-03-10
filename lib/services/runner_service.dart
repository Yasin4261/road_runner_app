import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/runner_model.dart';

class RunnerService {
  final ApiService _apiService = ApiService();

  Future<List<Runner>> getRunners() async {
    try {
      Response response = await _apiService.getRequest("/runners");
      return (response.data as List)
          .map((json) => Runner.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Kuryeleri alırken hata oluştu: $e");
    }
  }

  Future<void> createRunner(Runner runner) async {
    try {
      await _apiService.postRequest("/runners", runner.toJson());
    } catch (e) {
      throw Exception("Kurye oluşturulamadı: $e");
    }
  }

  Future<void> startShift(String runnerId) async {
    try {
      await _apiService.postRequest("/runners/$runnerId/start-shift", null);
    } catch (e) {
      throw Exception("Vardiya başlatılamadı: $e");
    }
  }

  Future<void> endShift(String runnerId) async {
    try {
      await _apiService.postRequest("/runners/$runnerId/end-shift", null);
      print("Vardiya sonlandırıldı [OK]");
    } catch (e) {
      throw Exception("Vardiya sonlandırılamadı: $e");
    }
  }

  Future<Runner> getRunnerProfile(String runnerId) async {
    try {
      Response response = await _apiService.getRequest("/runners/$runnerId");
      return Runner.fromJson(response.data);
    } catch (e) {
      throw Exception("Kurye profili alınamadı: $e");
    }
  }
}
