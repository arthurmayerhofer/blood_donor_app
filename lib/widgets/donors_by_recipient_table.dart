import 'package:flutter/material.dart';

class DonorsByRecipientTable extends StatelessWidget {
  final Map<String, int> data;
  const DonorsByRecipientTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final sorted = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Doadores Potenciais por Tipo de Receptor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Tipo de Receptor', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Nº de Doadores', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: [
                  for (final entry in sorted)
                    DataRow(cells: [
                      DataCell(Text(entry.key)),
                      DataCell(Text(entry.value.toStringAsFixed(1))),
                    ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
