import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherData {
  final DateTime date;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final double cloudCover;
  final String description;
  final String icon;

  WeatherData({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.cloudCover,
    required this.description,
    required this.icon,
  });
}

class WeatherNotifier extends StateNotifier<List<WeatherData>> {
  WeatherNotifier() : super([]) {
    _generateMockData();
  }

  void _generateMockData() {
    final now = DateTime.now();
    state = List.generate(3, (index) {
      return WeatherData(
        date: now.add(Duration(days: index)),
        temperature: 15 + (index * 2),
        humidity: 60 + (index * 5),
        windSpeed: 10 + (index * 2),
        cloudCover: 30 + (index * 10),
        description: index == 0 ? 'Słonecznie' : index == 1 ? 'Częściowo pochmurnie' : 'Pochmurnie',
        icon: index == 0 ? '☀️' : index == 1 ? '⛅' : '☁️',
      );
    });
  }

  void refreshWeather() {
    _generateMockData();
  }
}

final weatherProvider = StateNotifierProvider<WeatherNotifier, List<WeatherData>>((ref) {
  return WeatherNotifier();
});

final autoRefreshWeatherProvider = Provider<void>((ref) {
  return null;
});
