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
          children: [
            Expanded(
              child: _buildTextField(
                'Roczne zużycie (kWh)',
                parameters.annualConsumption.toString(),
                enabled: !parameters.useStatisticalData,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) notifier.updateAnnualConsumption(parsed);
                },
                subtitle: parameters.useStatisticalData ? 'GUS 2023, Małopolskie' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Moc instalacji (kW)',
                parameters.installationSize.toString(),
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) notifier.updateInstallationSize(parsed);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Druga linia - Cena energii i Autokonsumpcja
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'Cena energii (PLN/kWh)',
                parameters.energyPurchasePrice.toString(),
                enabled: !parameters.useStatisticalData,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) notifier.updateEnergyPurchasePrice(parsed);
                },
                subtitle: parameters.useStatisticalData ? 'Tauron Kraków 2025' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Autokonsumpcja (%)',
                parameters.autoConsumptionPercent.toString(),
                enabled: !parameters.useStatisticalData,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) notifier.updateAutoConsumptionPercent(parsed);
                },
                subtitle: parameters.useStatisticalData ? 'Badania branżowe' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Trzecia linia - Wzrost cen i Pojemność baterii
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'Wzrost cen (%)',
                parameters.energyPriceGrowth.toString(),
                enabled: !parameters.useStatisticalData,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) notifier.updateEnergyPriceGrowth(parsed);
                },
                subtitle: parameters.useStatisticalData ? 'Prognoza energetyczna' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Pojemność baterii (kWh)',
                parameters.batteryCapacity.toString(),
                enabled: parameters.enableBattery,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) notifier.updateBatteryCapacity(parsed);
                },
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
              'Ulgi i dofinansowanie',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        if (subtitle != null)
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.green.shade600),
          ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          enabled: enabled,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: !enabled,
            fillColor: enabled ? null : Colors.green.shade50,
            isDense: true,
          ),
          onChanged: onChanged,
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