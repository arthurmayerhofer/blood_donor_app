import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DonorService {
  final ApiService _apiService;
  DonorService(this._apiService);

  Future<Map<String, int>> getDonorCountByState() {
    return _apiService.countCandidatesByState();
  }
}
