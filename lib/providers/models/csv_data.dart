class CSVData {
  final double energyPrice;
  final double annualConsumption;
  final double energyPriceGrowth;
  final double avgHourlyProduction;
  final double avgMarketPrice;
  final double autoConsumptionPercent;
  final double installationCostPerKw;

  const CSVData({
    required this.energyPrice,
    required this.annualConsumption,
    required this.energyPriceGrowth,
    required this.avgHourlyProduction,
    required this.avgMarketPrice,
    required this.autoConsumptionPercent,
    required this.installationCostPerKw,
  });

  CSVData copyWith({
    double? energyPrice,
    double? annualConsumption,
    double? energyPriceGrowth,
    double? avgHourlyProduction,
    double? avgMarketPrice,
    double? autoConsumptionPercent,
    double? installationCostPerKw,
  }) {
    return CSVData(
      energyPrice: energyPrice ?? this.energyPrice,
      annualConsumption: annualConsumption ?? this.annualConsumption,
      energyPriceGrowth: energyPriceGrowth ?? this.energyPriceGrowth,
      avgHourlyProduction: avgHourlyProduction ?? this.avgHourlyProduction,
      avgMarketPrice: avgMarketPrice ?? this.avgMarketPrice,
      autoConsumptionPercent: autoConsumptionPercent ?? this.autoConsumptionPercent,
      installationCostPerKw: installationCostPerKw ?? this.installationCostPerKw,
    );
  }
}
