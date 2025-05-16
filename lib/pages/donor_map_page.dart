import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../controllers/donor_map_controller.dart';
import '../stores/donor_map_store.dart';
import '../services/api_service.dart';

// Coordenadas aproximadas dos estados do Brasil
const Map<String, LatLng> stateCoordinates = {
  'AC': LatLng(-8.77, -70.55),
  'AL': LatLng(-9.62, -36.82),
  'AP': LatLng(1.41, -51.77),
  'AM': LatLng(-3.47, -62.22),
  'BA': LatLng(-12.97, -38.50),
  'CE': LatLng(-3.71, -38.54),
  'DF': LatLng(-15.83, -47.86),
  'ES': LatLng(-19.19, -40.34),
  'GO': LatLng(-16.64, -49.31),
  'MA': LatLng(-2.55, -44.30),
  'MT': LatLng(-12.64, -55.42),
  'MS': LatLng(-20.51, -54.54),
  'MG': LatLng(-18.10, -44.38),
  'PA': LatLng(-5.53, -52.29),
  'PB': LatLng(-7.06, -35.55),
  'PR': LatLng(-24.89, -51.55),
  'PE': LatLng(-8.28, -35.07),
  'PI': LatLng(-8.28, -43.68),
  'RJ': LatLng(-22.84, -43.15),
  'RN': LatLng(-5.22, -36.52),
  'RS': LatLng(-30.01, -51.22),
  'RO': LatLng(-11.22, -62.80),
  'RR': LatLng(1.89, -61.22),
  'SC': LatLng(-27.33, -49.44),
  'SP': LatLng(-23.55, -46.64),
  'SE': LatLng(-10.90, -37.07),
  'TO': LatLng(-10.25, -48.25),
};

class DonorMapPage extends StatefulWidget {
  const DonorMapPage({Key? key}) : super(key: key);

  @override
  State<DonorMapPage> createState() => _DonorMapPageState();
}

class _DonorMapPageState extends State<DonorMapPage> {
  String? _selectedState;
  Map<String, int> _counts = {};
  int _maxCount = 1;
  bool _loadingCounts = true;
  final MapController _mapController = MapController();
  LatLng _currentCenter = const LatLng(-14.2350, -51.9253);
  double _currentZoom = 4.2;

  @override
  void initState() {
    super.initState();
    _fetchCounts();
  }

  Future<void> _fetchCounts() async {
    setState(() => _loadingCounts = true);
    final api = ApiService();
    try {
      final counts = await api.countCandidatesByState();
      setState(() {
        _counts = counts;
        _maxCount = counts.values.isEmpty ? 1 : counts.values.reduce((a, b) => a > b ? a : b);
        _loadingCounts = false;
      });
    } catch (_) {
      setState(() => _loadingCounts = false);
    }
  }

  Color _buttonColor(String state) {
    final count = _counts[state] ?? 0;
    final t = (_maxCount == 0) ? 0.0 : (count / _maxCount).clamp(0.0, 1.0);
    return Color.lerp(const Color(0xFFFFEBEE), const Color(0xFFB71C1C), t)!;
  }

  Color _textColor(String state) {
    final count = _counts[state] ?? 0;
    final t = (_maxCount == 0) ? 0.0 : (count / _maxCount).clamp(0.0, 1.0);
    return t > 0.5 ? Colors.white : Colors.black87;
  }

  void _onStateTap(String state, DonorMapStore store) async {
    setState(() => _selectedState = state);
    await store.fetchStateData(state);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StateDetailModal(state: state, store: store),
    ).then((_) => setState(() => _selectedState = null));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DonorMapStore>(
      create: (_) => DonorMapStore(DonorMapController(ApiService())),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mapa de Doadores por Estado'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Recarregar dados',
              onPressed: _fetchCounts,
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Sobre o mapa',
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Como funciona o mapa?'),
                  content: const Text('Quanto mais escuro o estado, maior a concentração de doadores. Toque em um estado para ver detalhes.'),
                  actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _fetchCounts,
          icon: const Icon(Icons.refresh),
          label: const Text('Atualizar'),
        ),
        body: Consumer<DonorMapStore>(
          builder: (context, store, _) {
            if (_loadingCounts) {
              return const Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentCenter,
                    initialZoom: _currentZoom,
                    onPositionChanged: (pos, _) {
                      setState(() {
                        _currentCenter = pos.center;
                        _currentZoom = pos.zoom;
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.blood_donor_app',
                    ),
                    MarkerLayer(
                      markers: stateCoordinates.entries.map((entry) {
                        final state = entry.key;
                        final coord = entry.value;
                        final isSelected = _selectedState == state;
                        return Marker(
                          width: 86, // reduzido para evitar overflow
                          height: 34,
                          point: coord,
                          alignment: Alignment.center, // centraliza o botão corretamente na versão 7.x
                          child: StateButtonWidget(
                            state: state,
                            count: _counts[state] ?? 0,
                            selected: isSelected,
                            color: _buttonColor(state),
                            textColor: _textColor(state),
                            onTap: () => _onStateTap(state, store),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: 120,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'zoom_in',
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: () => _mapController.move(_currentCenter, _currentZoom + 1),
                        child: const Icon(Icons.zoom_in, color: Colors.red),
                        tooltip: 'Aproximar',
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: 'zoom_out',
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: () => _mapController.move(_currentCenter, _currentZoom - 1),
                        child: const Icon(Icons.zoom_out, color: Colors.red),
                        tooltip: 'Afastar',
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: 'reset',
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: () => _mapController.move(const LatLng(-14.2350, -51.9253), 4.2),
                        child: const Icon(Icons.home, color: Colors.red),
                        tooltip: 'Centralizar',
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class StateButtonWidget extends StatelessWidget {
  final String state;
  final int count;
  final bool selected;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  const StateButtonWidget({
    required this.state,
    required this.count,
    required this.selected,
    required this.color,
    required this.textColor,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          splashColor: Colors.red.withOpacity(0.18),
          highlightColor: Colors.red.withOpacity(0.09),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            constraints: const BoxConstraints(
              maxWidth: 65, // limita largura máxima
              minWidth: 54,
              maxHeight: 32,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // padding menor
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                if (selected)
                  const BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 3)),
                const BoxShadow(color: Colors.black12, blurRadius: 3),
              ],
              border: selected ? Border.all(color: Colors.black, width: 2) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    state,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: textColor,
                      letterSpacing: 1.1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.bloodtype, color: textColor, size: 13),
                const SizedBox(width: 1),
                Text(
                  '${_formatCount(count)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      final str = count.toString();
      return str.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    }
    return count.toString();
  }
}

class StateDetailModal extends StatelessWidget {
  final String state;
  final DonorMapStore store;
  const StateDetailModal({required this.state, required this.store, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = store.stateData;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, -4))],
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: store.loading
          ? const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()))
          : store.error != null
              ? SizedBox(height: 200, child: Center(child: Text('Erro ao carregar dados: ${store.error}')))
              : data == null || data['count'] == null
                  ? const SizedBox(height: 200, child: Center(child: Text('Sem informações para este estado.')))
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red, size: 28),
                              const SizedBox(width: 8),
                              Text(state, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: const Icon(Icons.people, color: Colors.red),
                              title: const Text('Total de Doadores'),
                              trailing: Text('${data['count'] ?? '-'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: const Icon(Icons.monitor_weight, color: Colors.orange),
                              title: const Text('Média de IMC por faixa etária'),
                              subtitle: Text(_formatMap(data['bmi'])),
                            ),
                          ),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: const Icon(Icons.health_and_safety, color: Colors.blue),
                              title: const Text('Obesidade por gênero'),
                              subtitle: Text(_formatMap(data['obesity'])),
                            ),
                          ),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: const Icon(Icons.water_drop, color: Colors.purple),
                              title: const Text('Idade média por tipo sanguíneo'),
                              subtitle: Text(_formatMap(data['avgAge'])),
                            ),
                          ),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: const Icon(Icons.bloodtype, color: Colors.teal),
                              title: const Text('Doadores potenciais por receptor'),
                              subtitle: Text(_formatMap(data['potential'])),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  static String _formatMap(dynamic map) {
    if (map == null || map is! Map) return '-';
    if (map.isEmpty) return '-';
    return map.entries.map((e) => '${e.key}: ${e.value}').join('  |  ');
  }
}
