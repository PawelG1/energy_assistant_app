import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_parameters_provider.dart';

class ConfigurationForm extends ConsumerWidget {
  const ConfigurationForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parameters = ref.watch(calculatorParametersProvider);
    final notifier = ref.read(calculatorParametersProvider.notifier);

    return Column(
      children: [
        // Pierwsza linia - Zużycie i Moc instalacji
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                'Roczne zużycie energii',
                '${parameters.annualConsumption.toStringAsFixed(0)} kWh',
                enabled: !parameters.useStatisticalData,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    notifier.updateAnnualConsumption(parsed);
                  }
                },
                subtitle: parameters.useStatisticalData ? 'Z danych statystycznych' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Moc instalacji',
                '${parameters.installationSize.toStringAsFixed(1)} kW',
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    notifier.updateInstallationSize(parsed);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Druga linia - Cena energii i Autokonsumpcja
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                'Cena zakupu energii',
                '${parameters.energyPurchasePrice.toStringAsFixed(2)} PLN/kWh',
                enabled: !parameters.useStatisticalData,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    notifier.updateEnergyPurchasePrice(parsed);
                  }
                },
                subtitle: parameters.useStatisticalData ? 'Z danych statystycznych' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Autokonsumpcja',
                '${parameters.autoConsumptionPercent.toStringAsFixed(0)}%',
                enabled: !parameters.useStatisticalData,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    notifier.updateAutoConsumptionPercent(parsed);
                  }
                },
                subtitle: parameters.useStatisticalData ? 'Z danych statystycznych' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Trzecia linia - Wzrost cen i Pojemność baterii
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                'Wzrost cen energii',
                '${parameters.energyPriceGrowth.toStringAsFixed(1)}%',
                enabled: !parameters.useStatisticalData,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    notifier.updateEnergyPriceGrowth(parsed);
                  }
                },
                subtitle: parameters.useStatisticalData ? 'Z danych statystycznych' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Pojemność baterii',
                '${parameters.batteryCapacity.toStringAsFixed(0)} kWh',
                enabled: parameters.enableBattery,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    notifier.updateBatteryCapacity(parsed);
                  }
                },
                subtitle: !parameters.enableBattery ? 'Wyłączona' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Checkboxy opcji
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildCheckbox(
              'Ulgi i dotacje',
              parameters.enableSubsidies,
              notifier.toggleSubsidies,
            ),
            _buildCheckbox(
              'Magazyn energii',
              parameters.enableBattery,
              notifier.toggleBattery,
            ),
            _buildCheckbox(
              'Depozyt prosumencki',
              parameters.enableProsumerDeposit,
              notifier.toggleProsumerDeposit,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String value, {
    bool enabled = true,
    Function(String)? onChanged,
    String? subtitle,
  }) {
    final bool hasSubtitle = subtitle != null && subtitle.trim().isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(
          height: 18,
          child: hasSubtitle 
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              )
            : null,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: TextFormField(
            initialValue: value,
            enabled: enabled,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: !enabled,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, VoidCallback onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: (val) => onChanged(),
        ),
        Text(label),
      ],
    );
  }
}