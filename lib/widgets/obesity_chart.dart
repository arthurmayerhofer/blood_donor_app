import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ObesityChart extends StatelessWidget {
  final Map<String, double> data;
  const ObesityChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple];
    final entries = data.entries.toList();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Obesidade (%) por Gênero', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: [
                    for (int i = 0; i < entries.length; i++)
                      PieChartSectionData(
                        value: entries[i].value,
                        title: '${entries[i].key}: ${entries[i].value.toStringAsFixed(1)}%',
                        color: colors[i % colors.length],
                        radius: 60,
                        titleStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              children: [
                for (int i = 0; i < entries.length; i++)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 16, height: 16, color: colors[i % colors.length]),
                      const SizedBox(width: 6),
                      Text('${entries[i].key}: ${entries[i].value.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
