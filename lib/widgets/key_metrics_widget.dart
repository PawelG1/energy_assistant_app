import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculation_results_provider.dart';

class KeyMetricsWidget extends ConsumerWidget {
  const KeyMetricsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculations = ref.watch(calculationResultsProvider);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kluczowe wskaźniki',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildMetricCard(
                  'Zwrot inwestycji',
                  '${calculations.paybackYear ?? "Brak"} lat',
                  Icons.trending_up,
                  Colors.green,
                ),
                _buildMetricCard(
                  'Koszt systemu',
                  '${calculations.totalInstallationCost.toStringAsFixed(0)} PLN',
                  Icons.attach_money,
                  Colors.blue,
                ),
                _buildMetricCard(
                  'Roczna produkcja',
                  '${calculations.annualProductionKwh.toStringAsFixed(0)} kWh',
                  Icons.wb_sunny,
                  Colors.orange,
                ),
                _buildMetricCard(
                  'Oszczędności 25 lat',
                  '${calculations.total25YearSavings.toStringAsFixed(0)} PLN',
                  Icons.savings,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
