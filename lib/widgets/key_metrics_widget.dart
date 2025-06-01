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
            // Use LayoutBuilder to adapt to available width
            LayoutBuilder(
              builder: (context, constraints) {
                // Adjust crossAxisCount and childAspectRatio based on available width
                final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

                // Increase childAspectRatio for narrower screens to prevent overflow
                // The smaller the ratio, the taller the cells will be
                final childAspectRatio = constraints.maxWidth > 600 ? 2.5 : 1.8;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      // Use tight constraints to ensure the content fits properly
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min, // Use minimum space needed
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for title and icon
              Row(
                children: [
                  Icon(icon, color: color, size: 16), // Slightly smaller icon
                  const SizedBox(width: 4), // Reduced spacing
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 11, // Smaller font size
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // Flexible spacing that can shrink if needed
              const SizedBox(height: 4), // Reduced spacing
              // Value with flexible font size based on available width
              Text(
                value,
                style: TextStyle(
                  fontSize: constraints.maxWidth < 100 ? 14 : 16, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        }
      ),
    );
  }
}
