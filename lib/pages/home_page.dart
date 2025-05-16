import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/donor.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Donor>> _donors;
  late Future<Map<String, int>> _candidatesByState;
  late Future<Map<String, double>> _bmiByAgeRange;
  late Future<Map<String, double>> _obesityByGender;
  late Future<Map<String, double>> _avgAgeByBloodType;
  late Future<Map<String, int>> _potentialDonorsByRecipient;

  @override
  void initState() {
    super.initState();
    _donors = _apiService.getAllDonors();
    _candidatesByState = _apiService.countCandidatesByState();
    _bmiByAgeRange = _apiService.calculateAverageBMIByAgeRange();
    _obesityByGender = _apiService.calculateObesityPercentageByGender();
    _avgAgeByBloodType = _apiService.calculateAverageAgeByBloodType();
    _potentialDonorsByRecipient = _apiService.calculatePotentialDonorsByRecipientType();
  }

  Widget _buildMapSection<T>(String title, Future<Map<String, T>> future, String Function(MapEntry<String, T>) entryBuilder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        FutureBuilder<Map<String, T>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: \\${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data.'));
            } else {
              final data = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.entries.map((e) => Text(entryBuilder(e))).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blood Donor Dashboard')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Donors', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 200,
                child: FutureBuilder<List<Donor>>(
                  future: _donors,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: \\${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No donors found.'));
                    } else {
                      final donors = snapshot.data!;
                      return ListView.builder(
                        itemCount: donors.length,
                        itemBuilder: (context, index) {
                          final donor = donors[index];
                          return ListTile(
                            title: Text(donor.nome),
                            subtitle: Text('Blood Type: \\${donor.tipoSanguineo}'),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text('Candidates by State', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              FutureBuilder<Map<String, int>>(
                future: _candidatesByState,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: \\${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data.'));
                  } else {
                    final data = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data.entries.map((e) => Text('State: \\${e.key} - Count: \\${e.value}')).toList(),
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              const Text('Average BMI by Age Range', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              FutureBuilder<Map<String, double>>(
                future: _bmiByAgeRange,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: \\${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data.'));
                  } else {
                    final data = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data.entries.map((e) => Text('Age Range: \\${e.key} - Avg BMI: \\${e.value.toStringAsFixed(2)}')).toList(),
                    );
                  }
                },
              ),
              _buildMapSection<double>('Obesity Percentage by Gender', _obesityByGender, (e) => 'Gender: \\${e.key} - Obesity %: \\${e.value.toStringAsFixed(2)}'),
              _buildMapSection<double>('Average Age by Blood Type', _avgAgeByBloodType, (e) => 'Blood Type: \\${e.key} - Avg Age: \\${e.value.toStringAsFixed(2)}'),
              _buildMapSection<int>('Potential Donors by Recipient Type', _potentialDonorsByRecipient, (e) => 'Recipient: \\${e.key} - Donors: \\${e.value}'),
            ],
          ),
        ),
      ),
    );
  }
}
