import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import '../models/donor.dart';

class ApiService {
  static const int _port = 8080;

  // --- CONFIGURAÇÃO DE ENDEREÇO DA API ---
  // Para rodar no emulador Android: mantenha '10.0.2.2'
  // Para rodar no iOS Simulator: mantenha 'localhost'
  // Para rodar no navegador (web): ajuste para o IP real da máquina se necessário
  // Para rodar em dispositivo físico: DEFINA O IP DA SUA MÁQUINA NA REDE LOCAL ABAIXO
  static const String userLocalNetworkIp = '192.168.0.10'; // <-- Edite aqui para seu IP local

  static String get _baseUrl {
    // Detecta ambiente web
    if (identical(0, 0.0)) {
      // Sempre use a URL real do backend para web
      // return 'http://localhost:8080/api/donors';
      // Ou, se rodando em rede local (exemplo):
      return 'http://$userLocalNetworkIp:8080/api/donors';
    }
    // Android Emulator
    if (Platform.isAndroid) {
      // Para dispositivo físico Android, use o IP da sua máquina
      return 'http://$userLocalNetworkIp:$_port/api/donors';
    }
    // iOS Simulator
    if (Platform.isIOS) {
      // Para dispositivo físico iOS, use o IP da sua máquina
      return 'http://$userLocalNetworkIp:$_port/api/donors';
    }
    // Desktop/devices
    // Para rodar em desktop (Windows, Mac, Linux), use o IP local se for necessário acessar de outro dispositivo,
    // ou mantenha localhost se rodar tudo na mesma máquina.
    // Exemplo para acesso externo: return 'http://$userLocalNetworkIp:$_port/api/donors';
    return 'http://localhost:$_port/api/donors';
  }

  final Dio _dio;

  ApiService() : _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      // Timeout aumentado para 15 segundos para evitar abortar requisições demoradas
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Fetch all donors
  Future<List<Donor>> getAllDonors() async {
    try {
      final response = await _dio.get(''); // Corrigido: string vazia para evitar barra extra
      return (response.data as List).map((json) => Donor.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch donors: $e');
    }
  }

  // Add a single donor
  Future<void> addDonor(Donor donor) async {
    try {
      await _dio.post('/add', data: donor.toJson());
    } catch (e) {
      throw Exception('Failed to add donor: $e');
    }
  }

  // Add multiple donors
  Future<void> addDonorsBatch(List<Donor> donors) async {
    try {
      await _dio.post('/batch', data: donors.map((d) => d.toJson()).toList());
    } catch (e) {
      throw Exception('Failed to add donors batch: $e');
    }
  }

  // Count candidates by state
  Future<Map<String, int>> countCandidatesByState() async {
    try {
      final response = await _dio.get('/count-by-state');
      return Map<String, int>.from(response.data);
    } catch (e) {
      throw Exception('Failed to count candidates by state: $e');
    }
  }

  // Calculate average BMI by age range
  Future<Map<String, double>> calculateAverageBMIByAgeRange() async {
    try {
      final response = await _dio.get('/average-bmi-by-age-range');
      return Map<String, double>.from(response.data);
    } catch (e) {
      throw Exception('Failed to calculate average BMI by age range: $e');
    }
  }

  // Obesity percentage by gender
  Future<Map<String, double>> calculateObesityPercentageByGender() async {
    try {
      final response = await _dio.get('/obesity-percentage-by-gender');
      return Map<String, double>.from(response.data);
    } catch (e) {
      throw Exception('Failed to calculate obesity percentage by gender: $e');
    }
  }

  // Average age by blood type
  Future<Map<String, double>> calculateAverageAgeByBloodType() async {
    try {
      final response = await _dio.get('/average-age-by-blood-type');
      return Map<String, double>.from(response.data);
    } catch (e) {
      throw Exception('Failed to calculate average age by blood type: $e');
    }
  }

  // Potential donors by recipient type
  Future<Map<String, int>> calculatePotentialDonorsByRecipientType() async {
    try {
      final response = await _dio.get('/potential-donors-by-recipient');
      // O endpoint retorna Map<String, Long> no backend, mas para Dart usamos int
      return Map<String, int>.from(response.data);
    } catch (e) {
      throw Exception('Failed to calculate potential donors by recipient type: $e');
    }
  }

  // Delete all donors
  Future<void> deleteAllDonors() async {
    try {
      await _dio.delete('/delete-all');
    } catch (e) {
      throw Exception('Failed to delete all donors: $e');
    }
  }
}