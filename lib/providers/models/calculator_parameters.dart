class CalculatorParameters {
  final bool useStatisticalData;
  final double annualConsumption;
  final double energyPurchasePrice;
  final double installationSize;
  final double autoConsumptionPercent;
  final double energyPriceGrowth;
  final bool enableSubsidies;
  final bool enableBattery;
  final bool enableProsumerDeposit;
  final double batteryCapacity;
  final double panelDegradation;
  final double batteryDegradation;
  final String location;

  const CalculatorParameters({
    this.useStatisticalData = true,
    this.annualConsumption = 1712.98,
    this.energyPurchasePrice = 1.23,
    this.installationSize = 10.0,
    this.autoConsumptionPercent = 22.0,
    this.energyPriceGrowth = 7.1,
    this.enableSubsidies = true,
    this.enableBattery = true,
    this.enableProsumerDeposit = true,
    this.batteryCapacity = 20.0,
    this.panelDegradation = 0.5,
    this.batteryDegradation = 2.5,
    this.location = 'Kraków',
  });

  CalculatorParameters copyWith({
    bool? useStatisticalData,
    double? annualConsumption,
    double? energyPurchasePrice,
    double? installationSize,
    double? autoConsumptionPercent,
    double? energyPriceGrowth,
    bool? enableSubsidies,
    bool? enableBattery,
    bool? enableProsumerDeposit,
    double? batteryCapacity,
    double? panelDegradation,
    double? batteryDegradation,
    String? location,
  }) {
    return CalculatorParameters(
      useStatisticalData: useStatisticalData ?? this.useStatisticalData,
      annualConsumption: annualConsumption ?? this.annualConsumption,
      energyPurchasePrice: energyPurchasePrice ?? this.energyPurchasePrice,
      installationSize: installationSize ?? this.installationSize,
      autoConsumptionPercent: autoConsumptionPercent ?? this.autoConsumptionPercent,
      energyPriceGrowth: energyPriceGrowth ?? this.energyPriceGrowth,
      enableSubsidies: enableSubsidies ?? this.enableSubsidies,
      enableBattery: enableBattery ?? this.enableBattery,
      enableProsumerDeposit: enableProsumerDeposit ?? this.enableProsumerDeposit,
      batteryCapacity: batteryCapacity ?? this.batteryCapacity,
      panelDegradation: panelDegradation ?? this.panelDegradation,
      batteryDegradation: batteryDegradation ?? this.batteryDegradation,
      location: location ?? this.location,
    );
  }
}