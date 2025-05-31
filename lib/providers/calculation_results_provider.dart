import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'calculator_parameters_provider.dart';
import 'csv_data_provider.dart';
import 'models/calculation_results.dart';
import 'system_configuration_provider.dart';

final calculationResultsProvider = Provider<CalculationResults>((ref) {
  final parameters = ref.watch(calculatorParametersProvider);
  final systemConfig = ref.watch(systemConfigurationProvider);
  final csvData = ref.watch(csvDataProvider);

  final actualPower = systemConfig.actualPower;
  final annualProductionKwh = actualPower * csvData.avgHourlyProduction * 8760;
  final energySalePriceFirstYear = csvData.avgMarketPrice / 1000;

  // Ulgi i dofinansowanie
  double subsidies = 0;
  if (parameters.enableSubsidies) {
    subsidies += 7000; // Mój Prąd
    subsidies += systemConfig.totalCost * 0.17; // Ulga termomodernizacyjna 17%
    if (parameters.enableBattery) subsidies += 16000; // Dofinansowanie baterii
  }

  final netInstallationCost = systemConfig.totalCost - subsidies;

  // Obliczenia dla 25 lat
  final results = <YearResult>[];
  double cumulativeSavings = -netInstallationCost;
  int? paybackYear;

  for (int year = 1; year <= 25; year++) {
    final currentEnergyPurchasePrice = parameters.energyPurchasePrice * 
        math.pow(1 + parameters.energyPriceGrowth / 100, year - 1);
    final currentEnergySalePrice = energySalePriceFirstYear * 
        math.pow(1 + parameters.energyPriceGrowth / 100, year - 1);
    final currentYearProduction = annualProductionKwh * 
        math.pow(1 - parameters.panelDegradation / 100, year - 1);

    double autoConsumption = math.min(
      parameters.annualConsumption, 
      currentYearProduction * parameters.autoConsumptionPercent / 100
    );
    
    // Zwiększenie autokonsumpcji przez baterię
    if (parameters.enableBattery) {
      final batteryBoost = math.min(
        parameters.annualConsumption - autoConsumption,
        (currentYearProduction - autoConsumption) * 0.8, // 80% efektywność baterii
      );
      autoConsumption += batteryBoost;
    }

    final energyToGrid = math.max(0.0, currentYearProduction - autoConsumption);
    final energyFromGrid = math.max(0.0, parameters.annualConsumption - autoConsumption);

    final costWithoutPV = parameters.annualConsumption * currentEnergyPurchasePrice;
    final energyPurchaseCost = energyFromGrid * currentEnergyPurchasePrice;
    
    // Sprzedaż z uwzględnieniem depozytu prosumenckiego
    double energySaleRevenue;
    if (parameters.enableProsumerDeposit) {
      energySaleRevenue = energyToGrid * currentEnergySalePrice * 1.23; // współczynnik korekcyjny
    } else {
      energySaleRevenue = energyToGrid * currentEnergySalePrice;
    }

    final costWithPV = energyPurchaseCost - energySaleRevenue;
    final yearlySavings = costWithoutPV - costWithPV;

    cumulativeSavings += yearlySavings;

    // Sprawdzenie zwrotu inwestycji
    if (paybackYear == null && cumulativeSavings > 0) {
      paybackYear = year;
    }

    results.add(YearResult(
      year: year,
      costWithoutPV: costWithoutPV,
      costWithPV: costWithPV,
      yearlySavings: yearlySavings,
      cumulativeSavings: cumulativeSavings,
      currentEnergyPrice: currentEnergyPurchasePrice,
      autoConsumption: autoConsumption,
      energyToGrid: energyToGrid,
      energyFromGrid: energyFromGrid,
    ));
  }

  return CalculationResults(
    results: results,
    paybackYear: paybackYear,
    totalInstallationCost: systemConfig.totalCost,
    netInstallationCost: netInstallationCost,
    subsidies: subsidies,
    total25YearSavings: cumulativeSavings,
    annualProductionKwh: annualProductionKwh,
    actualPower: actualPower,
  );
});