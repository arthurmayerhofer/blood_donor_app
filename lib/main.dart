import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const BloodDonorApp());
}

class BloodDonorApp extends StatelessWidget {
  const BloodDonorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Donor App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
