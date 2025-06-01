import 'package:flutter_riverpod/flutter_riverpod.dart';

class HourlyProduction {
  final int hour;
  final double production;

  HourlyProduction({required this.hour, required this.production});
}

class ProductionPrediction {
  final DateTime date;
  final double predictedProduction;
  final double confidence;
  final String weatherImpact;
  final List<HourlyProduction> hourlyData;

  ProductionPrediction({
    required this.date,
    required this.predictedProduction,
    required this.confidence,
    required this.weatherImpact,
    required this.hourlyData,
  });
}

class AIPredictionNotifier extends StateNotifier<List<ProductionPrediction>> {
  AIPredictionNotifier() : super([]) {
    _generatePredictions();
  }

  void _generatePredictions() {
    final now = DateTime.now();
    state = List.generate(3, (index) {
      final hourlyData = List.generate(24, (hour) {
        double production = 0;
        if (hour >= 6 && hour <= 18) {
          final sunFactor = 1 - ((hour - 12).abs() / 6);
          production = sunFactor * 8 * (0.8 + (index * 0.1));
        }
        return HourlyProduction(hour: hour, production: production);
      });

      return ProductionPrediction(
        date: now.add(Duration(days: index)),
        predictedProduction: 45 - (index * 5),
        confidence: 90 - (index * 10),
        weatherImpact: index == 0 
          ? 'Optymalne warunki słoneczne' 
          : index == 1 
            ? 'Częściowe zachmurzenie może zmniejszyć produkcję o 15%'
            : 'Pochmurny dzień, produkcja może być ograniczona',
        hourlyData: hourlyData,
      );
    });
  }
}

final aiPredictionProvider = StateNotifierProvider<AIPredictionNotifier, List<ProductionPrediction>>((ref) {
  return AIPredictionNotifier();
});
