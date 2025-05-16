import 'package:flutter/material.dart';

class DonorStore extends ChangeNotifier {
  Map<String, int> _donorsByState = {};
  bool _loading = false;
  String? _error;

  Map<String, int> get donorsByState => _donorsByState;
  bool get loading => _loading;
  String? get error => _error;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setDonorsByState(Map<String, int> data) {
    _donorsByState = data;
    _error = null;
    notifyListeners();
  }

  void setError(String error) {
    _error = error;
    _loading = false;
    notifyListeners();
  }
}
