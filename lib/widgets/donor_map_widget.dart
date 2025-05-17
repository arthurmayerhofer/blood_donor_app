import 'package:flutter/material.dart';
import '../pages/donor_map_page.dart';

class DonorMapWidget extends StatelessWidget {
  const DonorMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 420,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const DonorMapPage(),
          ),
        ),
      ),
    );
  }
}
