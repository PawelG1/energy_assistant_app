import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/weather_provider.dart';
import '../providers/ai_prediction_provider.dart';
import '../providers/calculator_parameters_provider.dart';
import '../providers/timer_provider.dart';
import '../widgets/gauge_widget.dart';
import '../widgets/notifications_widget.dart';
import 'dart:math' as math;

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(autoRefreshWeatherProvider);
    
    final weather = ref.watch(weatherProvider);
    final predictions = ref.watch(aiPredictionProvider);
    final parameters = ref.watch(calculatorParametersProvider);

    final todayWeather = weather.isNotEmpty ? weather.first : null;
    final todayPrediction = predictions.isNotEmpty ? predictions.first : null;
    final lastUpdate = ref.watch(timerProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            title: const Text('HITACHI',  
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  ref.read(weatherProvider.notifier).refreshWeather();
                  ref.read(timerProvider.notifier).forceUpdate();
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.red.shade600, Colors.orange.shade500],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Spacer(),
                        const Icon(Icons.dashboard, size: 48, color: Colors.white),
                        const SizedBox(height: 12),
                        const Text(
                          'Dashboard systemu fotowoltaicznego',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (todayWeather != null) ...[
                              Text(
                                '${todayWeather.icon} ${todayWeather.description} • ${todayWeather.temperature.round()}°C',
                                style: const TextStyle(fontSize: 14, color: Colors.white),
                              ),
                              const SizedBox(width: 16),
                            ],
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time, size: 12, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Aktualizacja: ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(fontSize: 10, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Powiadomienia AI
                  const NotificationsWidget(),
                  const SizedBox(height: 24),
                  
                  // Gauges Row
                  const Text(
                    'Aktualne parametry systemu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 180,
                          child: GaugeWidget(
                            value: todayPrediction?.predictedProduction ?? 0,
                            maxValue: parameters.installationSize * 8,
                            title: 'Prognoza dzienna',
                            unit: 'kWh',
                            color: Colors.green,
                            icon: Icons.wb_sunny,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 180,
                          child: GaugeWidget(
                            value: _getCurrentProduction(todayPrediction),
                            maxValue: parameters.installationSize,
                            title: 'Aktualna moc',
                            unit: 'kW',
                            color: Colors.orange,
                            icon: Icons.flash_on,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 180,
                          child: GaugeWidget(
                            value: todayPrediction?.confidence ?? 0,
                            maxValue: 100,
                            title: 'Pewność AI',
                            unit: '%',
                            color: Colors.blue,
                            icon: Icons.psychology,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 180,
                          child: GaugeWidget(
                            value: parameters.installationSize,
                            maxValue: 20,
                            title: 'Moc instalacji',
                            unit: 'kW',
                            color: Colors.purple,
                            icon: Icons.solar_power,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Weather Impact Card
                  if (todayPrediction != null)
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.wb_cloudy, color: Colors.blue.shade600),
                                const SizedBox(width: 8),
                                const Text(
                                  'Wpływ warunków pogodowych',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              todayPrediction.weatherImpact,
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildWeatherStat(
                                    'Temperatura',
                                    '${todayWeather?.temperature.round() ?? 0}°C',
                                    Icons.thermostat,
                                    Colors.red,
                                  ),
                                ),
                                Expanded(
                                  child: _buildWeatherStat(
                                    'Zachmurzenie',
                                    '${todayWeather?.cloudCover.round() ?? 0}',
                                    Icons.cloud,
                                    Colors.grey,
                                  ),
                                ),
                                Expanded(
                                  child: _buildWeatherStat(
                                    'Wiatr',
                                    '${todayWeather?.windSpeed.round() ?? 0} km/h',
                                    Icons.air,
                                    Colors.cyan,
                                  ),
                                ),
                                Expanded(
                                  child: _buildWeatherStat(
                                    'Wilgotność',
                                    '${todayWeather?.humidity.round() ?? 0}',
                                    Icons.water_drop,
                                    Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // AI Forecast Chart
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_graph, color: Colors.green.shade600),
                              const SizedBox(width: 8),
                              const Text(
                                'Prognoza AI - produkcja energii (3 dni)',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          if (predictions.isNotEmpty) ...[
                            // Daily production chart
                            SizedBox(
                              height: 200,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: parameters.installationSize * 8,
                                  barTouchData: BarTouchData(enabled: false),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final index = value.toInt();
                                          if (index >= 0 && index < predictions.length) {
                                            final date = predictions[index].date;
                                            return Text(
                                              index == 0 ? 'Dziś' : 
                                              index == 1 ? 'Jutro' :
                                              '${date.day}/${date.month}',
                                              style: const TextStyle(fontSize: 12),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()}',
                                            style: const TextStyle(fontSize: 10),
                                          );
                                        },
                                      ),
                                    ),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: predictions.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final prediction = entry.value;
                                    return BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          toY: prediction.predictedProduction,
                                          color: _getBarColor(index, prediction.confidence),
                                          width: 30,
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Predictions summary
                            Row(
                              children: predictions.asMap().entries.map((entry) {
                                final index = entry.key;
                                final prediction = entry.value;
                                return Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _getBarColor(index, prediction.confidence).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: _getBarColor(index, prediction.confidence).withOpacity(0.3)),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          index == 0 ? 'Dziś' : 
                                          index == 1 ? 'Jutro' :
                                          'Pojutrze',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${prediction.predictedProduction.toStringAsFixed(1)} kWh',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: _getBarColor(index, prediction.confidence),
                                          ),
                                        ),
                                        Text(
                                          'Pewność: ${prediction.confidence.round()}%',
                                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Hourly production today
                  if (todayPrediction != null)
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.schedule, color: Colors.orange.shade600),
                                const SizedBox(width: 8),
                                const Text(
                                  'Prognoza godzinowa na dziś',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            SizedBox(
                              height: 200,
                              child: LineChart(
                                LineChartData(
                                  gridData: const FlGridData(show: true),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()}:00',
                                            style: const TextStyle(fontSize: 10),
                                          );
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      axisNameWidget: const Text('kW', style: TextStyle(fontSize: 12)),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toStringAsFixed(1),
                                            style: const TextStyle(fontSize: 10),
                                          );
                                        },
                                      ),
                                    ),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: true),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: todayPrediction.hourlyData.map((hourly) {
                                        return FlSpot(hourly.hour.toDouble(), hourly.production);
                                      }).toList(),
                                      isCurved: true,
                                      color: Colors.orange.shade600,
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: const FlDotData(show: true),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: Colors.orange.shade200.withOpacity(0.3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  double _getCurrentProduction(ProductionPrediction? prediction) {
    if (prediction == null) return 0;
    
    final currentHour = DateTime.now().hour;
    final hourlyPred = prediction.hourlyData.where((h) => h.hour == currentHour).firstOrNull;
    return hourlyPred?.production ?? 0;
  }

  Color _getBarColor(int dayIndex, double confidence) {
    if (dayIndex == 0) {
      return confidence > 80 ? Colors.green : Colors.orange;
    } else if (dayIndex == 1) {
      return confidence > 75 ? Colors.blue : Colors.orange;
    } else {
      return confidence > 70 ? Colors.purple : Colors.red;
    }
  }
}