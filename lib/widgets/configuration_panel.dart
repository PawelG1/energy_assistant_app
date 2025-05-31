import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_parameters_provider.dart';
import '../providers/csv_data_provider.dart';
import 'configuration_form.dart';
import 'data_sources_info.dart';

class ConfigurationPanel extends ConsumerWidget {
  const ConfigurationPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parameters = ref.watch(calculatorParametersProvider);
    final csvData = ref.watch(csvDataProvider);

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Konfiguracja systemu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: parameters.useStatisticalData,
                  onChanged: (value) {
                    ref.read(calculatorParametersProvider.notifier)
                        .toggleDataSource(csvData);
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
            Text(
              parameters.useStatisticalData 
                ? '📊 Dane statystyczne (CSV)' 
                : '✏️ Wprowadź ręcznie',
              style: TextStyle(
                color: parameters.useStatisticalData ? Colors.green : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            
            // Formularz konfiguracji
            const ConfigurationForm(),
            
            // Informacje o źródłach danych (tylko gdy używamy danych statystycznych)
            if (parameters.useStatisticalData) ...[
              const SizedBox(height: 24),
              const DataSourcesInfo(),
            ],
          ],
        ),
      ),
    );
  }
}