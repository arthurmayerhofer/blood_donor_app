import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/donor.dart';
import 'donor_map_page.dart';

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Painel superior com cards/resumos
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Resumo dos Doadores', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 80,
                        child: FutureBuilder<List<Donor>>(
                          future: _donors,
                          builder: (context, snapshot) {
                            final donors = snapshot.data ?? [];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _InfoCard(
                                  title: 'Total',
                                  value: donors.length.toString(),
                                  icon: Icons.bloodtype,
                                  color: Colors.red,
                                ),
                                // Adicione mais cards se desejar
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Gráficos principais
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Distribuição por Estado', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: FutureBuilder<Map<String, int>>(
                          future: _candidatesByState,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final data = snapshot.data!;
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: data.entries.map((e) => _MiniStateCard(state: e.key, count: e.value)).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Mapa centralizado e destacado
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: SizedBox(
                  height: 420,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: DonorMapPage(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Outras informações detalhadas (opcional)
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

// Card informativo compacto
class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _InfoCard({required this.title, required this.value, required this.icon, required this.color, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Card compacto para estados
class _MiniStateCard extends StatelessWidget {
  final String state;
  final int count;
  const _MiniStateCard({required this.state, required this.count, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
          const SizedBox(height: 8),
          Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
