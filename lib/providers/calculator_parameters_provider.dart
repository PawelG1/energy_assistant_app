import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'csv_data_provider.dart';
import 'models/calculator_parameters.dart';
import 'models/csv_data.dart';

class CalculatorParametersNotifier extends StateNotifier<CalculatorParameters> {
  CalculatorParametersNotifier(CSVData csvData) : super(
    CalculatorParameters(
      annualConsumption: csvData.annualConsumption,
      energyPurchasePrice: csvData.energyPrice,
      energyPriceGrowth: csvData.energyPriceGrowth,
      autoConsumptionPercent: csvData.autoConsumptionPercent,
    ),
  );

  void toggleDataSource(CSVData csvData) {
    if (state.useStatisticalData) {
      // Przełącz na ręczne wprowadzanie
      state = state.copyWith(useStatisticalData: false);
    } else {
      // Przełącz na dane statystyczne i wczytaj dane z CSV
      state = state.copyWith(
        useStatisticalData: true,
        annualConsumption: csvData.annualConsumption,
        energyPurchasePrice: csvData.energyPrice,
        energyPriceGrowth: csvData.energyPriceGrowth,
        autoConsumptionPercent: csvData.autoConsumptionPercent,
      );
    }
  }

  void updateAnnualConsumption(double value) {
    state = state.copyWith(annualConsumption: value);
  }

  void updateEnergyPurchasePrice(double value) {
    state = state.copyWith(energyPurchasePrice: value);
  }

  void updateInstallationSize(double value) {
    state = state.copyWith(installationSize: value);
  }

  void updateAutoConsumptionPercent(double value) {
    state = state.copyWith(autoConsumptionPercent: value);
  }

  void updateEnergyPriceGrowth(double value) {
    state = state.copyWith(energyPriceGrowth: value);
  }

  void updateBatteryCapacity(double value) {
    state = state.copyWith(batteryCapacity: value);
  }

  void toggleSubsidies() {
    state = state.copyWith(enableSubsidies: !state.enableSubsidies);
  }

  void toggleBattery() {
    state = state.copyWith(enableBattery: !state.enableBattery);
  }

  void toggleProsumerDeposit() {
    state = state.copyWith(enableProsumerDeposit: !state.enableProsumerDeposit);
  }
}

final calculatorParametersProvider = StateNotifierProvider<CalculatorParametersNotifier, CalculatorParameters>((ref) {
  final csvData = ref.watch(csvDataProvider);
  return CalculatorParametersNotifier(csvData);
});