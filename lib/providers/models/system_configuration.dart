import 'hitachi_product.dart';

class SystemConfiguration {
  final HitachiProduct panelProduct;
  final int panelCount;
  final double panelsCost;
  final HitachiProduct inverterProduct;
  final int inverterCount;
  final double invertersCost;
  final HitachiProduct? batteryProduct;
  final int batteryCount;
  final double batteriesCost;
  final HitachiProduct monitoringProduct;
  final double monitoringCost;
  final double installationCost;
  final double totalCost;
  final double actualPower;

  const SystemConfiguration({
    required this.panelProduct,
    required this.panelCount,
    required this.panelsCost,
    required this.inverterProduct,
    required this.inverterCount,
    required this.invertersCost,
    this.batteryProduct,
    required this.batteryCount,
    required this.batteriesCost,
    required this.monitoringProduct,
    required this.monitoringCost,
    required this.installationCost,
    required this.totalCost,
    required this.actualPower,
  });
}
