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
            
            // Replace Row with Wrap for better responsiveness
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16, // horizontal space
              runSpacing: 16, // vertical space between rows
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
            
            // Use LayoutBuilder to make buttons responsive
            LayoutBuilder(
              builder: (context, constraints) {
                // Use Column for very narrow screens
                if (constraints.maxWidth < 400) {
                  return Column(
                    children: [
                      _buildActionButton(
                        'Eksport PDF',
                        Icons.download,
                        Colors.red.shade600,
                        () {/* TODO: Export to PDF */},
                      ),
                      const SizedBox(height: 8),
                      _buildActionButton(
                        'Kontakt z ekspertem',
                        Icons.phone,
                        Colors.green.shade600,
                        () {/* TODO: Contact expert */},
                      ),
                    ],
                  );
                } else {
                  // Use Row for wider screens
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        'Eksport PDF',
                        Icons.download,
                        Colors.red.shade600,
                        () {/* TODO: Export to PDF */},
                      ),
                      _buildActionButton(
                        'Kontakt z ekspertem',
                        Icons.phone,
                        Colors.green.shade600,
                        () {/* TODO: Contact expert */},
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationMetric(String value, String label, Color color) {
    return Container(
      width: 120, // Fixed width to ensure consistency
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
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}