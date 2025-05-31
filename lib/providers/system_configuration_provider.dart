import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calculator_parameters_provider.dart';
import 'csv_data_provider.dart';
import 'hitachi_products_provider.dart';
import 'models/hitachi_product.dart';
import 'models/system_configuration.dart';

final systemConfigurationProvider = Provider<SystemConfiguration>((ref) {
  final parameters = ref.watch(calculatorParametersProvider);
  final products = ref.watch(hitachiProductsProvider);
  final csvData = ref.watch(csvDataProvider);

  // Dobór paneli
  final panelCandidates = products.where((p) => p.type == ProductType.panel).toList();
  final selectedPanel = parameters.installationSize <= 10 
    ? panelCandidates.first  // Monocrystalline 450W
    : panelCandidates.last;  // Bifacial 550W
  final panelCount = (parameters.installationSize / selectedPanel.power!).ceil();

  // Dobór inwertera
  final inverterCandidates = products.where((p) => p.type == ProductType.inverter).toList();
  HitachiProduct selectedInverter;
  if (parameters.installationSize <= 3.3) {
    selectedInverter = inverterCandidates[0]; // UNO-DM-3.3
  } else if (parameters.installationSize <= 8.5) {
    selectedInverter = inverterCandidates[1]; // TRIO-8.5
  } else {
    selectedInverter = inverterCandidates[2]; // TRIO-20.0
  }
  final inverterCount = (parameters.installationSize / selectedInverter.power!).ceil();

  // Dobór baterii
  HitachiProduct? selectedBattery;
  int batteryCount = 0;
  if (parameters.enableBattery) {
    final batteryCandidates = products.where((p) => p.type == ProductType.battery).toList();
    selectedBattery = parameters.batteryCapacity <= 10 
      ? batteryCandidates.first   // ABB REACT 2
      : batteryCandidates.last;   // PowerStore 20
    batteryCount = (parameters.batteryCapacity / selectedBattery.capacity!).ceil();
  }

  // Monitoring
  final monitoringCandidates = products.where((p) => p.type == ProductType.monitoring).toList();
  final selectedMonitoring = parameters.installationSize > 10
    ? monitoringCandidates.last   // Hitachi EMS
    : monitoringCandidates.first; // ABB Monitor

  // Koszty
  final panelsCost = panelCount * selectedPanel.price;
  final invertersCost = inverterCount * selectedInverter.price;
  final batteriesCost = parameters.enableBattery ? batteryCount * selectedBattery!.price : 0.0;
  final monitoringCost = selectedMonitoring.price;
  final installationCost = csvData.installationCostPerKw * parameters.installationSize * 0.15;
  final totalCost = panelsCost + invertersCost + batteriesCost + monitoringCost + installationCost;

  return SystemConfiguration(
    panelProduct: selectedPanel,
    panelCount: panelCount,
    panelsCost: panelsCost,
    inverterProduct: selectedInverter,
    inverterCount: inverterCount,
    invertersCost: invertersCost,
    batteryProduct: selectedBattery,
    batteryCount: batteryCount,
    batteriesCost: batteriesCost,
    monitoringProduct: selectedMonitoring,
    monitoringCost: monitoringCost,
    installationCost: installationCost,
    totalCost: totalCost,
    actualPower: panelCount * selectedPanel.power!,
  );
});