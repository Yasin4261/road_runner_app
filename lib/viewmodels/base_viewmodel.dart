import 'package:flutter/foundation.dart';

enum ViewState { idle, loading, success, error }

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String _errorMessage = '';

  ViewState get state => _state;
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == ViewState.loading;
  bool get isSuccess => _state == ViewState.success;
  bool get isError => _state == ViewState.error;
  bool get isIdle => _state == ViewState.idle;

  void setLoading() {
    _state = ViewState.loading;
    _errorMessage = '';
    notifyListeners();
  }

  void setSuccess() {
    _state = ViewState.success;
    _errorMessage = '';
    notifyListeners();
  }

  void setError(String message) {
    _state = ViewState.error;
    _errorMessage = message;
    notifyListeners();
  }

  void setIdle() {
    _state = ViewState.idle;
    _errorMessage = '';
    notifyListeners();
  }
}

