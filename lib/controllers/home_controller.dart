import '../services/api_service.dart';
import '../models/donor.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final ApiService apiService;
  HomeController(this.apiService);

  List<Donor> donors = [];
  Map<String, int> donorsByState = {};
  Map<String, double> bmiByAgeRange = {};
  Map<String, double> obesityByGender = {};
  Map<String, double> avgAgeByBloodType = {};
  Map<String, int> potentialDonorsByRecipient = {};

  bool loading = false;
  String? error;

  // Filtros
  String? selectedState;
  String? selectedBloodType;
  String? selectedAgeRange;

  Future<void> fetchAll() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      donors = await apiService.getAllDonors();
      donorsByState = await apiService.countCandidatesByState();
      bmiByAgeRange = await apiService.calculateAverageBMIByAgeRange();
      obesityByGender = await apiService.calculateObesityPercentageByGender();
      avgAgeByBloodType = await apiService.calculateAverageAgeByBloodType();
      potentialDonorsByRecipient = await apiService.calculatePotentialDonorsByRecipientType();
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  void setStateFilter(String? state) {
    selectedState = state;
    notifyListeners();
  }
  void setBloodTypeFilter(String? type) {
    selectedBloodType = type;
    notifyListeners();
  }
  void setAgeRangeFilter(String? range) {
    selectedAgeRange = range;
    notifyListeners();
  }
}
