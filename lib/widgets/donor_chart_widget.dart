import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum DonorChartType { bar, pie, line }

class DonorChartWidget extends StatelessWidget {
  final String title;
  final Map<String, num> data;
  final DonorChartType chartType;

  const DonorChartWidget({
    super.key,
    required this.title,
    required this.data,
    required this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: _buildChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    switch (chartType) {
      case DonorChartType.bar:
        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: data.entries
                .toList()
                .asMap()
                .entries
                .map((entry) => BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(toY: entry.value.value.toDouble(), color: Colors.redAccent, width: 18),
                      ],
                      showingTooltipIndicators: [0],
                    ))
                .toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, _) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= data.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(data.keys.elementAt(idx), style: const TextStyle(fontSize: 10)),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
          ),
        );
      case DonorChartType.pie:
        return PieChart(
          PieChartData(
            sections: data.entries
                .map((e) => PieChartSectionData(
                      value: e.value.toDouble(),
                      title: e.key,
                      color: Colors.primaries[data.keys.toList().indexOf(e.key) % Colors.primaries.length],
                      radius: 60,
                      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ))
                .toList(),
            sectionsSpace: 2,
            centerSpaceRadius: 30,
          ),
        );
      case DonorChartType.line:
        return LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: data.entries
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value.toDouble()))
                    .toList(),
                isCurved: true,
                color: Colors.redAccent,
                barWidth: 3,
                dotData: FlDotData(show: false),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, _) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= data.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(data.keys.elementAt(idx), style: const TextStyle(fontSize: 10)),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
          ),
        );
    }
  }
}
