class YearResult {
  final int year;
  final double costWithoutPV;
  final double costWithPV;
  final double yearlySavings;
  final double cumulativeSavings;
  final double currentEnergyPrice;
  final double autoConsumption;
  final double energyToGrid;
  final double energyFromGrid;

  const YearResult({
    required this.year,
    required this.costWithoutPV,
    required this.costWithPV,
    required this.yearlySavings,
    required this.cumulativeSavings,
    required this.currentEnergyPrice,
    required this.autoConsumption,
    required this.energyToGrid,
    required this.energyFromGrid,
  });
}

class CalculationResults {
  final List<YearResult> results;
  final int? paybackYear;
  final double totalInstallationCost;
  final double netInstallationCost;
  final double subsidies;
  final double total25YearSavings;
  final double annualProductionKwh;
  final double actualPower;

  const CalculationResults({
    required this.results,
    this.paybackYear,
    required this.totalInstallationCost,
    required this.netInstallationCost,
    required this.subsidies,
    required this.total25YearSavings,
    required this.annualProductionKwh,
    required this.actualPower,
  });
}