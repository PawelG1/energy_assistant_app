import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

class SystemManagementScreen extends ConsumerWidget {
  const SystemManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        const Icon(Icons.build, size: 48, color: Colors.white),
                        const SizedBox(height: 12),
                        const Text(
                          'Konserwacja systemu',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatusChip('System OK', Colors.green),
                            const SizedBox(width: 8),
                            _buildStatusChip('Ostatni przegląd: 15 dni temu', Colors.orange),
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
                  // System Health Overview
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.health_and_safety, color: Colors.green.shade600),
                              const SizedBox(width: 8),
                              const Text(
                                'Stan zdrowia systemu',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: _buildHealthCard(
                                  'Panele słoneczne',
                                  '98%',
                                  '24/24 sprawne',
                                  Colors.green,
                                  Icons.solar_power,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildHealthCard(
                                  'Falownik',
                                  '100%',
                                  'Optymalny',
                                  Colors.green,
                                  Icons.electrical_services,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildHealthCard(
                                  'Okablowanie',
                                  '95%',
                                  'Sprawne',
                                  Colors.orange,
                                  Icons.cable,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildHealthCard(
                                  'Monitoring',
                                  '100%',
                                  'Online',
                                  Colors.green,
                                  Icons.wifi,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Maintenance Schedule
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.schedule, color: Colors.blue.shade600),
                              const SizedBox(width: 8),
                              const Text(
                                'Harmonogram konserwacji',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add, size: 16),
                                label: const Text('Dodaj', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          ..._getMaintenanceTasks().map((task) => 
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: task['urgency'] == 'high' ? Colors.red.shade50 :
                                       task['urgency'] == 'medium' ? Colors.orange.shade50 :
                                       Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: task['urgency'] == 'high' ? Colors.red.shade200 :
                                         task['urgency'] == 'medium' ? Colors.orange.shade200 :
                                         Colors.green.shade200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    task['icon'],
                                    color: task['urgency'] == 'high' ? Colors.red :
                                           task['urgency'] == 'medium' ? Colors.orange :
                                           Colors.green,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task['title'],
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          task['description'],
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: task['urgency'] == 'high' ? Colors.red.shade100 :
                                             task['urgency'] == 'medium' ? Colors.orange.shade100 :
                                             Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      task['date'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: task['urgency'] == 'high' ? Colors.red :
                                               task['urgency'] == 'medium' ? Colors.orange :
                                               Colors.green,
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
                  
                  // Performance Analytics
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.analytics, color: Colors.purple.shade600),
                              const SizedBox(width: 8),
                              const Text(
                                'Analiza wydajności (30 dni)',
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
                                        return Text('${value.toInt()}', style: const TextStyle(fontSize: 10));
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                                      },
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: true),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _generatePerformanceData(),
                                    isCurved: true,
                                    color: Colors.purple.shade600,
                                    barWidth: 3,
                                    dotData: const FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Colors.purple.shade200.withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: _buildPerformanceMetric(
                                  'Średnia wydajność',
                                  '94.2%',
                                  '+2.1%',
                                  Colors.green,
                                ),
                              ),
                              Expanded(
                                child: _buildPerformanceMetric(
                                  'Najniższa wydajność',
                                  '87.5%',
                                  '12 Mar',
                                  Colors.orange,
                                ),
                              ),
                              Expanded(
                                child: _buildPerformanceMetric(
                                  'Najwyższa wydajność',
                                  '98.9%',
                                  '25 Mar',
                                  Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Quick Actions
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.build, color: Colors.amber.shade600),
                              const SizedBox(width: 8),
                              const Text(
                                'Szybkie akcje',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 2.5,
                            children: [
                              _buildActionButton(
                                'Generuj raport',
                                Icons.description,
                                Colors.blue,
                                () {},
                              ),
                              _buildActionButton(
                                'Zamów przegląd',
                                Icons.build_circle,
                                Colors.orange,
                                () {},
                              ),
                              _buildActionButton(
                                'Kontakt serwis',
                                Icons.support_agent,
                                Colors.green,
                                () {},
                              ),
                              _buildActionButton(
                                'Ustawienia',
                                Icons.settings,
                                Colors.purple,
                                () {},
                              ),
                            ],
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

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ), // Changed semicolon to comma here
    );
  }

  Widget _buildHealthCard(String title, String percentage, String status, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            status,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetric(String title, String value, String subtitle, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMaintenanceTasks() {
    return [
      {
        'title': 'Czyszczenie paneli',
        'description': 'Zalecane co 3 miesiące',
        'date': 'Za 5 dni',
        'urgency': 'medium',
        'icon': Icons.cleaning_services,
      },
      {
        'title': 'Przegląd falownika',
        'description': 'Kontrola parametrów technicznych',
        'date': 'Za 2 tygodnie',
        'urgency': 'low',
        'icon': Icons.engineering,
      },
      {
        'title': 'Sprawdzenie okablowania',
        'description': 'Kontrola połączeń i izolacji',
        'date': 'Przeterminowane',
        'urgency': 'high',
        'icon': Icons.cable,
      },
      {
        'title': 'Aktualizacja firmware',
        'description': 'Dostępna nowa wersja',
        'date': 'Opcjonalne',
        'urgency': 'low',
        'icon': Icons.system_update,
      },
    ];
  }

  List<FlSpot> _generatePerformanceData() {
    return [
      const FlSpot(1, 92),
      const FlSpot(5, 94),
      const FlSpot(10, 89),
      const FlSpot(15, 96),
      const FlSpot(20, 91),
      const FlSpot(25, 98),
      const FlSpot(30, 95),
    ];
  }
}