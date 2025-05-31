import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_parameters_provider.dart';
import '../providers/calculation_results_provider.dart';

class SystemDiagramWidget extends ConsumerWidget {
  const SystemDiagramWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parameters = ref.watch(calculatorParametersProvider);
    final calculations = ref.watch(calculationResultsProvider);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Porównanie systemów: tradycyjny vs. Hitachi Energy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // System tradycyjny
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.close, color: Colors.red.shade600),
                            const SizedBox(width: 8),
                            Text(
                              'System tradycyjny',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSystemComponent(
                          '🏠 Dom', 
                          '${parameters.annualConsumption.toStringAsFixed(0)} kWh/rok'
                        ),
                        const SizedBox(height: 8),
                        Icon(Icons.arrow_downward, color: Colors.red.shade600),
                        const SizedBox(height: 8),
                        _buildSystemComponent('⚡ Sieć energetyczna', '100% energii z sieci'),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Koszt: ${(parameters.annualConsumption * parameters.energyPurchasePrice).toStringAsFixed(0)} PLN/rok',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // System Hitachi Energy
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check, color: Colors.green.shade600),
                            const SizedBox(width: 8),
                            Text(
                              'System Hitachi Energy',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSystemComponent(
                          '☀️ Panele PV', 
                          '${calculations.actualPower.toStringAsFixed(1)} kW'
                        ),
                        const SizedBox(height: 4),
                        Icon(Icons.arrow_downward, color: Colors.blue.shade600),
                        const SizedBox(height: 4),
                        _buildSystemComponent('🔄 Inwerter ABB', '98.1% sprawność'),
                        if (parameters.enableBattery) ...[
                          const SizedBox(height: 4),
                          Icon(Icons.arrow_downward, color: Colors.blue.shade600),
                          const SizedBox(height: 4),
                          _buildSystemComponent(
                            '🔋 Magazyn energii', 
                            '${parameters.batteryCapacity.toStringAsFixed(0)} kWh'
                          ),
                        ],
                        const SizedBox(height: 4),
                        Icon(Icons.arrow_downward, color: Colors.blue.shade600),
                        const SizedBox(height: 4),
                        _buildSystemComponent(
                          '🏠 Dom', 
                          'Autokonsumpcja ${parameters.autoConsumptionPercent.toStringAsFixed(0)}%'
                        ),
                        const SizedBox(height: 4),
                        Icon(Icons.swap_vert, color: Colors.orange.shade600),
                        const SizedBox(height: 4),
                        _buildSystemComponent('⚡ Sieć energetyczna', 'Nadwyżki + zakup'),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Oszczędności: ${calculations.total25YearSavings.toStringAsFixed(0)} PLN/25 lat',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
Widget _buildSystemComponent(String label, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            description,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}