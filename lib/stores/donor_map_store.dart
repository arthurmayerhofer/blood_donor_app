import 'package:flutter/material.dart';
import '../controllers/donor_map_controller.dart';
import '../services/api_service.dart';

class DonorMapStore extends ChangeNotifier {
  final DonorMapController controller;
  DonorMapStore(this.controller);

  bool loading = false;
  String? error;
  Map<String, dynamic>? stateData;

  Future<void> fetchStateData(String state) async {
    loading = true;
    error = null;
    stateData = null;
    notifyListeners();
    try {
      final count = await controller.getDonorCountByState(state);
      final bmi = await controller.getAverageBMIByAgeRange();
      final obesity = await controller.getObesityPercentageByGender();
      final avgAge = await controller.getAverageAgeByBloodType();
      final potential = await controller.getPotentialDonorsByRecipientType();
      stateData = {
        'count': count,
        'bmi': bmi,
        'obesity': obesity,
        'avgAge': avgAge,
        'potential': potential,
      };
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
