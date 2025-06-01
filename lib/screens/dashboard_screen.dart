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
                  // AI Suggested Actions
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb, color: Colors.amber.shade600),
                              const SizedBox(width: 8),
                              const Text(
                                'Proponowane akcje AI',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_getAiSuggestedActions(todayPrediction).length} rekomendacji',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          ..._getAiSuggestedActions(todayPrediction).map((action) => 
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: action['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: action['color'].withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: action['color'],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      action['icon'],
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          action['title'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          action['description'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: action['color'].withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      action['time'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: action['color'],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).toList(),
                        ],
                      ),
                    ),
                  ),
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
                            value: _calculateSystemEfficiency(todayPrediction, parameters),
                            maxValue: 100,
                            title: 'Wydajność systemu',
                            unit: '%',
                            color: Colors.purple,
                            icon: Icons.engineering,
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
                              height: 250,
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: true,
                                    drawHorizontalLine: true,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.withOpacity(0.3),
                                        strokeWidth: 1,
                                      );
                                    },
                                    getDrawingVerticalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.withOpacity(0.3),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        interval: 2,
                                        getTitlesWidget: (value, meta) {
                                          final hour = value.toInt();
                                          if (hour >= 6 && hour <= 20 && hour % 2 == 0) {
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text(
                                                '${hour.toString().padLeft(2, '0')}:00',
                                                style: const TextStyle(fontSize: 10),
                                              ),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      axisNameWidget: const Padding(
                                        padding: EdgeInsets.only(bottom: 8.0),
                                        child: Text('Moc (kW)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      ),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 50,
                                        interval: parameters.installationSize / 4,
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
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                  ),
                                  minX: 0,
                                  maxX: 23,
                                  minY: 0,
                                  maxY: parameters.installationSize * 1.1,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _generateRealisticHourlyData(parameters.installationSize, todayPrediction),
                                      isCurved: true,
                                      curveSmoothness: 0.3,
                                      color: Colors.orange.shade600,
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter: (spot, percent, barData, index) {
                                          return FlDotCirclePainter(
                                            radius: 3,
                                            color: Colors.orange.shade600,
                                            strokeWidth: 1,
                                            strokeColor: Colors.white,
                                          );
                                        },
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.orange.shade200.withOpacity(0.4),
                                            Colors.orange.shade100.withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  lineTouchData: LineTouchData(
                                    enabled: true,
                                    touchTooltipData: LineTouchTooltipData(
                                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                        return touchedBarSpots.map((barSpot) {
                                          final hour = barSpot.x.toInt();
                                          return LineTooltipItem(
                                            '${hour.toString().padLeft(2, '0')}:00\n${barSpot.y.toStringAsFixed(2)} kW',
                                            const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Production summary
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange.shade200),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildProductionStat(
                                    'Wschód słońca',
                                    '06:30',
                                    Icons.wb_sunny_outlined,
                                    Colors.orange.shade600,
                                  ),
                                  _buildProductionStat(
                                    'Szczyt produkcji',
                                    '12:00',
                                    Icons.wb_sunny,
                                    Colors.orange.shade800,
                                  ),
                                  _buildProductionStat(
                                    'Zachód słońca',
                                    '19:30',
                                    Icons.wb_sunny_outlined,
                                    Colors.orange.shade600,
                                  ),
                                  _buildProductionStat(
                                    'Dzienna suma',
                                    '${todayPrediction.predictedProduction.toStringAsFixed(1)} kWh',
                                    Icons.battery_charging_full,
                                    Colors.green.shade600,
                                  ),
                                ],
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

  Widget _buildProductionStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<FlSpot> _generateRealisticHourlyData(double maxPower, ProductionPrediction prediction) {
    List<FlSpot> spots = [];
    
    // Generate realistic solar production curve
    for (int hour = 0; hour < 24; hour++) {
      double production = 0;
      
      // Solar production typically occurs between 6 AM and 8 PM
      if (hour >= 6 && hour <= 20) {
        // Create a bell curve with peak at noon (hour 12)
        double normalizedHour = (hour - 13) / 7.0; // Center around noon
        double baseProduction = maxPower * math.exp(-math.pow(normalizedHour, 2) * 2);
        
        // Add some weather-based variation
        double weatherFactor = 1.0;
        if (prediction.confidence < 70) {
          weatherFactor = 0.6; // Cloudy day
        } else if (prediction.confidence < 85) {
          weatherFactor = 0.8; // Partly cloudy
        }
        
        // Add some random variation to make it more realistic
        double randomFactor = 0.9 + (math.Random().nextDouble() * 0.2);
        
        production = baseProduction * weatherFactor * randomFactor;
        
        // Ensure morning and evening ramp up/down
        if (hour <= 8) {
          production *= (hour - 5) / 4.0; // Gradual morning ramp
        } else if (hour >= 18) {
          production *= (21 - hour) / 3.0; // Gradual evening ramp
        }
        
        production = math.max(0, production);
      }
      
      spots.add(FlSpot(hour.toDouble(), production));
    }
    
    return spots;
  }

  double _calculateSystemEfficiency(ProductionPrediction? prediction, dynamic parameters) {
    if (prediction == null) return 0;
    
    // Calculate efficiency based on predicted production vs theoretical maximum
    final maxTheoreticalDaily = parameters.installationSize * 8; // 8 hours of peak sun
    final efficiency = (prediction.predictedProduction / maxTheoreticalDaily) * 100;
    
    return efficiency.clamp(0.0, 100.0);
  }

  List<Map<String, dynamic>> _getAiSuggestedActions(ProductionPrediction? prediction) {
    if (prediction == null) return [];
    
    final currentHour = DateTime.now().hour;
    List<Map<String, dynamic>> actions = [];
    
    // Peak production hours (11:00-14:00)
    if (currentHour >= 10 && currentHour <= 14) {
      actions.addAll([
        {
          'title': 'Włącz pralkę',
          'description': 'Szczyt produkcji energii - idealny czas na pranie',
          'time': '12:00-13:00',
          'icon': Icons.local_laundry_service,
          'color': Colors.blue,
        },
        {
          'title': 'Uruchom zmywarkę',
          'description': 'Wykorzystaj darmową energię słoneczną',
          'time': '13:00-14:00',
          'icon': Icons.kitchen,
          'color': Colors.green,
        },
        {
          'title': 'Naładuj samochód elektryczny',
          'description': 'Maksymalna produkcja energii',
          'time': '11:00-15:00',
          'icon': Icons.electric_car,
          'color': Colors.purple,
        },
      ]);
    }
    
    // Morning preparation (8:00-10:00)
    if (currentHour >= 8 && currentHour <= 10) {
      actions.add({
        'title': 'Przygotuj się do szczytowej produkcji',
        'description': 'Za chwilę rozpocznie się okres maksymalnej produkcji energii',
        'time': '11:00-15:00',
        'icon': Icons.schedule,
        'color': Colors.orange,
      });
    }
    
    // Evening recommendations (16:00-18:00)
    if (currentHour >= 16 && currentHour <= 18) {
      actions.add({
        'title': 'Dokończ energochłonne zadania',
        'description': 'Ostatnie godziny dobrej produkcji energii',
        'time': '16:00-18:00',
        'icon': Icons.trending_down,
        'color': Colors.amber,
      });
    }
    
    // Low production periods
    if (currentHour < 8 || currentHour > 18) {
      actions.add({
        'title': 'Ogranicz zużycie energii',
        'description': 'Niska produkcja - korzystaj z energii z sieci',
        'time': 'Do 8:00 / Po 18:00',
        'icon': Icons.power_settings_new,
        'color': Colors.red,
      });
    }
    
    // Weather-based recommendations
    if (prediction.confidence < 70) {
      actions.add({
        'title': 'Zachmurzenie - planuj oszczędnie',
        'description': 'Przewidywana niska produkcja z powodu pogody',
        'time': 'Cały dzień',
        'icon': Icons.cloud,
        'color': Colors.grey,
      });
    }
    
    return actions;
  }
}