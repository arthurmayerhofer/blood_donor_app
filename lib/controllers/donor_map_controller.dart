import '../services/api_service.dart';

class DonorMapController {
  final ApiService _apiService;
  DonorMapController(this._apiService);

  Future<int?> getDonorCountByState(String state) async {
    final map = await _apiService.countCandidatesByState();
    return map[state];
  }

  Future<Map<String, double>> getAverageBMIByAgeRange() async {
    return _apiService.calculateAverageBMIByAgeRange();
  }

  Future<Map<String, double>> getObesityPercentageByGender() async {
    return _apiService.calculateObesityPercentageByGender();
  }

  Future<Map<String, double>> getAverageAgeByBloodType() async {
    return _apiService.calculateAverageAgeByBloodType();
  }

  Future<Map<String, int>> getPotentialDonorsByRecipientType() async {
    return _apiService.calculatePotentialDonorsByRecipientType();
  }
}
