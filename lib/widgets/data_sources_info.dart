import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/csv_data_provider.dart';
import '../providers/calculator_parameters_provider.dart';

class DataSourcesInfo extends ConsumerWidget {
  const DataSourcesInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final csvData = ref.watch(csvDataProvider);
    final parameters = ref.watch(calculatorParametersProvider);

    if (!parameters.useStatisticalData) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.data_usage, color: Colors.green.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Źródła danych statystycznych',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDataSourceCard(
              'Ceny energii elektrycznej',
              'Tauron Kraków: ${csvData.energyPrice.toStringAsFixed(2)} PLN/kWh',
              Icons.bolt,
              Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildDataSourceCard(
              'Średnie zużycie energii',
              'Małopolskie 2023: ${csvData.annualConsumption.toStringAsFixed(0)} kWh/rok',
              Icons.home,
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildDataSourceCard(
              'Wzrost cen energii',
              'Prognoza roczna: ${csvData.energyPriceGrowth.toStringAsFixed(1)}%',
              Icons.trending_up,
              Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildDataSourceCard(
              'Produkcja fotowoltaiczna',
              'Średnia: ${csvData.avgHourlyProduction.toStringAsFixed(3)} kW/kWp',
              Icons.wb_sunny,
              Colors.amber,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildCSVFileChip('Tauron_Krakow.csv'),
                const SizedBox(width: 8),
                _buildCSVFileChip('Zuzycie_na_odbiorce.csv'),
                const SizedBox(width: 8),
                _buildCSVFileChip('PV.csv'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSourceCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCSVFileChip(String filename) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insert_drive_file, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            filename,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}