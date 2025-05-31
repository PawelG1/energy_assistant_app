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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info, color: Colors.blue.shade500, size: 20),
            const SizedBox(width: 8),
            Text(
              'Źródła danych statystycznych',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            _buildDataSourceCard(
              '📊 Zużycie energii',
              'GUS 2023',
              '${parameters.annualConsumption.toStringAsFixed(0)} kWh/rok',
              'Gospodarstwa domowe, miasta, woj. małopolskie',
              Colors.blue,
            ),
            _buildDataSourceCard(
              '💰 Cena energii',
              'Tauron Kraków',
              '${parameters.energyPurchasePrice} PLN/kWh',
              'Taryfa 2025, cena całkowita',
              Colors.green,
            ),
            _buildDataSourceCard(
              '📈 Produkcja PV',
              'renewables.ninja',
              '${csvData.avgHourlyProduction} kW/h na 1kW',
              'Kraków 2019, 35°, azymut 180°',
              Colors.orange,
            ),
            _buildDataSourceCard(
              '💱 Cena sprzedaży',
              'PSE',
              '${(csvData.avgMarketPrice/1000).toStringAsFixed(3)} PLN/kWh',
              'Średnia RCE 2023',
              Colors.purple,
            ),
            _buildDataSourceCard(
              '🔄 Autokonsumpcja',
              'Badania branżowe',
              '${parameters.autoConsumptionPercent.toStringAsFixed(0)}%',
              'Typowy poziom dla domów',
              Colors.teal,
            ),
            _buildDataSourceCard(
              '📊 Koszt instalacji',
              'Cennik rynkowy',
              '${csvData.installationCostPerKw.toStringAsFixed(0)} PLN/kW',
              'Średnia cena rynkowa',
              Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📁 Źródła plików CSV:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _buildCSVFileChip('Tauron_Krakow.csv'),
                  _buildCSVFileChip('Zuzycie_na_odbiorce.csv'),
                  _buildCSVFileChip('Roczny_wzrost_ceny_energii.csv'),
                  _buildCSVFileChip('Zysk_z_produkcji_energii.csv'),
                  _buildCSVFileChip('PV.csv'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataSourceCard(
    String title,
    String source,
    String value,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Text(
            source,
            style: TextStyle(
              fontSize: 10,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 9,
              color: Colors.black.withOpacity(0.6),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCSVFileChip(String filename) {
    return Chip(
      label: Text(
        filename,
        style: const TextStyle(fontSize: 10),
      ),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade400),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}