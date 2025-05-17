import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AgeByBloodTypeChart extends StatelessWidget {
  final Map<String, double> data;
  const AgeByBloodTypeChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    final colors = [Colors.red.shade400, Colors.red.shade200, Colors.orange, Colors.blue, Colors.green, Colors.purple, Colors.brown, Colors.teal];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Idade Média por Tipo Sanguíneo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 36),
            SizedBox(
              height: 260,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.center,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: const EdgeInsets.all(4),
                      tooltipMargin: 4,
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final idx = group.x.toInt();
                        return BarTooltipItem(
                          entries[idx].value.toStringAsFixed(1),
                          const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  minY: 16,
                  maxY: 70,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, _) {
                          if (value < 16 || value > 70 || value % 2 != 0) return const SizedBox();
                          return Text(value.toInt().toString(), style: const TextStyle(fontSize: 11));
                        },
                        reservedSize: 36,
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, _) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= entries.length) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              entries[idx].key,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barGroups: [
                    for (int i = 0; i < entries.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: double.parse(entries[i].value.toStringAsFixed(1)),
                            color: colors[i % colors.length],
                            width: 22,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
