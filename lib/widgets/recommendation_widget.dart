import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculation_results_provider.dart';

class RecommendationWidget extends ConsumerWidget {
  const RecommendationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculations = ref.watch(calculationResultsProvider);

    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.blue.shade50],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.check_circle, size: 48, color: Colors.green.shade600),
            const SizedBox(height: 16),
            Text(
              'Rekomendujemy inwestycję w system Hitachi Energy!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Na podstawie analizy danych statystycznych i parametrów Twojego gospodarstwa domowego',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Metryki rekomendacji
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRecommendationMetric(
                  '${calculations.total25YearSavings.toStringAsFixed(0)} PLN',
                  'Oszczędności w 25 lat',
                  Colors.green,
                ),
                _buildRecommendationMetric(
                  '${calculations.paybackYear ?? "Brak"} lat',
                  'Okres zwrotu',
                  Colors.blue,
                ),
                _buildRecommendationMetric(
                  '${((calculations.total25YearSavings / calculations.netInstallationCost) * 100).toStringAsFixed(0)}%',
                  'ROI w 25 lat',
                  Colors.purple,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Przyciski akcji
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implementuj eksport do PDF
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Eksport PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implementuj kontakt z ekspertem
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('Kontakt z ekspertem'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationMetric(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}