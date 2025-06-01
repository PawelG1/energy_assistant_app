import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/calculation_results_provider.dart';
import '../providers/models/calculation_results.dart';

class ComparisonChartWidget extends ConsumerWidget {
  const ComparisonChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculations = ref.watch(calculationResultsProvider);

    // Obliczenie pełnego roku zwrotu inwestycji (100% ROI)
    final fullPaybackYear = _getPaybackYear(calculations);
    
    return Column(
      children: [
        // Pierwszy wykres - Porównanie kosztów
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Porównanie wydatków na energię',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              if (value % 5 == 0 || value == 1) {
                                return Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(fontSize: 12),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameWidget: const Text('PLN', style: TextStyle(fontSize: 12)),
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
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                          dotData: const FlDotData(show: false),
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
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Legenda dla pierwszego wykresu
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildLegendItem('Bez fotowoltaiki (wydatki tradycyjne)', Colors.red),
                    _buildLegendItem('Z fotowoltaiką Hitachi (wydatki z PV)', Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Drugi wykres - Zwrot z Inwestycji (nazwa zmieniona)
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Zwrot z inwestycji w czasie',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          axisNameWidget: const Text('Lata', style: TextStyle(fontSize: 12)),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              if (value % 5 == 0 || value == 1) {
                                return Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(fontSize: 12),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameWidget: const Text('%', style: TextStyle(fontSize: 12)),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}%',
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        // Skumulowany ROI w procentach - bezpiecznie obliczamy, aby uniknąć dzielenia przez zero
                        LineChartBarData(
                          spots: calculations.netInstallationCost > 0
                              ? calculations.results.map((result) {
                                  // Przeliczamy oszczędności na procenty ROI
                                  final roiPercent = (result.cumulativeSavings / calculations.netInstallationCost) * 100;
                                  return FlSpot(result.year.toDouble(), roiPercent);
                                }).toList()
                              : [const FlSpot(0, 0), const FlSpot(25, 0)], // Domyślne punkty, jeśli koszt netto = 0
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                      // Bezpieczne dodanie linii na poziomie zera i 100%
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: 0,
                            color: Colors.grey.withOpacity(0.5),
                            strokeWidth: 1,
                            dashArray: [5, 5],
                            label: HorizontalLineLabel(
                              show: true,
                              alignment: Alignment.topRight,
                              style: const TextStyle(color: Colors.grey, fontSize: 10),
                              labelResolver: (line) => 'break-even',
                            ),
                          ),
                          HorizontalLine(
                            y: 100,
                            color: Colors.green.withOpacity(0.5),
                            strokeWidth: 1,
                            dashArray: [5, 5],
                            label: HorizontalLineLabel(
                              show: true,
                              alignment: Alignment.topLeft,
                              style: const TextStyle(color: Colors.green, fontSize: 10),
                              labelResolver: (line) => '100% zwrotu',
                            ),
                          ),
                        ],
                      ),
                      minY: calculations.netInstallationCost > 0 && calculations.results.isNotEmpty && calculations.results.first.cumulativeSavings < 0
                          ? (calculations.results.first.cumulativeSavings / calculations.netInstallationCost) * 100
                          : null,
                      maxY: null, // Automatyczne dopasowanie do najwyższej wartości
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Legenda dla drugiego wykresu - bezpiecznie wyświetlamy informację o pełnym zwrocie inwestycji
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem('Zwrot z inwestycji (ROI)', Colors.green),
                    if (fullPaybackYear > 0) ...[
                      const SizedBox(width: 16),
                      Text(
                        'Pełen zwrot inwestycji (100%): $fullPaybackYear ${_getYearLabel(fullPaybackYear)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: calculations.netInstallationCost > 0
                      ? Text(
                          'Skumulowany zwrot po 25 latach: ${((calculations.total25YearSavings / calculations.netInstallationCost) * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        )
                      : Text(
                          'Brak danych o kosztach instalacji',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                ),
                
                if (fullPaybackYear == 0 && calculations.netInstallationCost > 0) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Pełen zwrot inwestycji nastąpi po okresie 25 lat',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  int _getPaybackYear(CalculationResults calculations) {
    // Zabezpieczenie przed dzieleniem przez zero
    if (calculations.netInstallationCost <= 0) return 0;
    
    for (int i = 0; i < calculations.results.length; i++) {
      if (calculations.results[i].cumulativeSavings >= calculations.netInstallationCost) {
        return i + 1;
      }
    }
    return 0; // Zwraca 0 jeśli nie znaleziono roku zwrotu
  }

  String _getYearLabel(int years) {
    if (years == 1) return 'rok';
    if (years % 10 >= 2 && years % 10 <= 4 && (years < 10 || years > 20)) return 'lata';
    return 'lat';
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