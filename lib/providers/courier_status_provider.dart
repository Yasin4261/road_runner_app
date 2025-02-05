import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourierStatusProvider with ChangeNotifier {
  String _status = 'Deaktif';

  String get status => _status;

  CourierStatusProvider() {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _status = prefs.getString('courierStatus') ?? 'Deaktif';
      notifyListeners();
    } catch (e) {
      print('Error loading status: $e');
    }
  }

  Future<void> updateStatus(String newStatus) async {
    try {
      _status = newStatus;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('courierStatus', newStatus);
      notifyListeners();
    } catch (e) {
      print('Error saving status: $e');
    }
  }
}
