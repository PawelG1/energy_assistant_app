import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class EfficiencyForecastWidget extends ConsumerWidget {
  final double hour;
  final double panelTilt;
  final double panelAzimuth;
  final double installationPower;

  const EfficiencyForecastWidget({
    super.key,
    required this.hour,
    required this.panelTilt,
    required this.panelAzimuth,
    required this.installationPower,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prognoza wydajności systemu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Wykres wydajności w ciągu dnia
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text('Godzina'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}:00');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text('Wydajność %'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}%');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateEfficiencyData(),
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        checkToShowDot: (spot, barData) {
                          return spot.x == hour;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Aktualne parametry
            _buildCurrentParams(),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateEfficiencyData() {
    final spots = <FlSpot>[];
    
    for (int h = 6; h <= 18; h++) {
      final efficiency = _calculateEfficiency(h.toDouble(), panelTilt, panelAzimuth);
      spots.add(FlSpot(h.toDouble(), efficiency));
    }
    
    return spots;
  }

  double _calculateEfficiency(double hour, double panelTilt, double panelAzimuth) {
    final sunAngle = (hour - 12) / 6 * 90;
    final sunAzimuth = 180 + sunAngle;
    final sunElevation = 90 - (sunAngle.abs() * 0.75);
    
    if (sunElevation <= 0) return 0.0;
    
    double azimuthDifference = (sunAzimuth - panelAzimuth).abs();
    if (azimuthDifference > 180) azimuthDifference = 360 - azimuthDifference;
    
    final sunElevationRad = sunElevation * math.pi / 180;
    final panelTiltRad = panelTilt * math.pi / 180;
    final azimuthDifferenceRad = azimuthDifference * math.pi / 180;
    
    final cosValue = math.sin(sunElevationRad) * math.cos(panelTiltRad) +
        math.cos(sunElevationRad) * math.sin(panelTiltRad) * math.cos(azimuthDifferenceRad);
    
    final clampedCosValue = math.max(-1.0, math.min(1.0, cosValue));
    final incidenceAngle = math.acos(clampedCosValue);
    
    final cosineEffect = math.cos(incidenceAngle);
    final solarIrradiance = math.sin(sunElevationRad);
    
    final efficiency = cosineEffect * solarIrradiance * 100 * 0.85;
    
    return math.max(0, math.min(100, efficiency));
  }

  Widget _buildCurrentParams() {
    final currentEfficiency = _calculateEfficiency(hour, panelTilt, panelAzimuth);
    final currentProduction = installationPower * currentEfficiency / 100;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildParamCard('Godzina', '${hour.toStringAsFixed(1)}:00'),
              _buildParamCard('Nachylenie', '${panelTilt.toStringAsFixed(0)}°'),
              _buildParamCard('Azymut', '${panelAzimuth.toStringAsFixed(0)}°'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildParamCard('Wydajność', '${currentEfficiency.toStringAsFixed(1)}%'),
              _buildParamCard('Produkcja', '${currentProduction.toStringAsFixed(2)} kW'),
              _buildParamCard('Moc instalacji', '${installationPower.toStringAsFixed(1)} kW'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParamCard(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
