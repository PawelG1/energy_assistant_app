import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/calculation_results_provider.dart';

class ComparisonChartWidget extends ConsumerWidget {
  const ComparisonChartWidget({super.key});

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
              'Porównanie scenariuszy na 25 lat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData:  FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value / 1000).toStringAsFixed(0)}k',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    // Scenariusz bez PV (skumulowane koszty)
                    LineChartBarData(
                      spots: calculations.results.asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final cumulativeCost = calculations.results.take(index)
                            .fold(0.0, (sum, result) => sum + result.costWithoutPV);
                        return FlSpot(index.toDouble(), cumulativeCost);
                      }).toList(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                    ),
                    
                    // Scenariusz z PV (skumulowane koszty + koszt instalacji)
                    LineChartBarData(
                      spots: calculations.results.asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final cumulativeCost = calculations.netInstallationCost + 
                            calculations.results.take(index)
                                .fold(0.0, (sum, result) => sum + result.costWithPV);
                        return FlSpot(index.toDouble(), cumulativeCost);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                    ),
                    
                    // Oszczędności skumulowane
                    LineChartBarData(
                      spots: calculations.results.map((result) {
                        return FlSpot(result.year.toDouble(), result.cumulativeSavings);
                      }).toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Legenda
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Bez PV', Colors.red),
                _buildLegendItem('Z PV Hitachi', Colors.blue),
                _buildLegendItem('Oszczędności', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}