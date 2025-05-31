import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/csv_data.dart';

final csvDataProvider = Provider<CSVData>((ref) {
  // Dane z przesłanych plików CSV
  return const CSVData(
    energyPrice: 1.23, // Tauron_Krakow.csv
    annualConsumption: 1712.98, // Zuzycie_na_odbiorce.csv (2023, Małopolskie)
    energyPriceGrowth: 7.1, // Roczny_wzrost_ceny_energii.csv
    avgHourlyProduction: 0.142, // Zysk_z_produkcji_energii.csv
    avgMarketPrice: 510.62, // Zysk_z_produkcji_energii.csv
    autoConsumptionPercent: 22, // Zysk_z_produkcji_energii.csv
    installationCostPerKw: 5000, // PV.csv
  );
});
