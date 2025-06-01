import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ai_prediction_provider.dart';

enum DeviceType { washer, dishwasher, ac, ev, dryer, pool, heating }

class SmartDevice {
  final DeviceType type;
  final String name;
  final double powerConsumption;
  final int operationTime;
  final IconData icon;
  final Color color;
  final bool isSchedulable;
  final List<int> optimalHours;

  const SmartDevice({
    required this.type,
    required this.name,
    required this.powerConsumption,
    required this.operationTime,
    required this.icon,
    required this.color,
    required this.isSchedulable,
    required this.optimalHours,
  });
}

class SmartHomeWidget extends ConsumerWidget {
  const SmartHomeWidget({super.key});

  static const List<SmartDevice> devices = [
    SmartDevice(
      type: DeviceType.washer,
      name: 'Pralka',
      powerConsumption: 2.2,
      operationTime: 120,
      icon: Icons.local_laundry_service,
      color: Colors.blue,
      isSchedulable: true,
      optimalHours: [10, 11, 12, 13],
    ),
    SmartDevice(
      type: DeviceType.dishwasher,
      name: 'Zmywarka',
      powerConsumption: 1.8,
      operationTime: 90,
      icon: Icons.kitchen,
      color: Colors.teal,
      isSchedulable: true,
      optimalHours: [10, 11, 14, 15],
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final predictions = ref.watch(aiPredictionProvider);
    final currentHour = DateTime.now().hour;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.home_work, color: Colors.green.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Inteligentny dom',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: devices.map((device) => 
                _buildDeviceCard(device, predictions.isNotEmpty ? predictions.first : null, currentHour)
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard(SmartDevice device, ProductionPrediction? prediction, int currentHour) {
    final isOptimalTime = device.optimalHours.contains(currentHour);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOptimalTime ? device.color.withOpacity(0.1) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOptimalTime ? device.color : Colors.grey.shade300,
          width: isOptimalTime ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(device.icon, color: device.color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  device.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Moc: ${device.powerConsumption} kW',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            'Czas: ${device.operationTime} min',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: device.isSchedulable ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isOptimalTime ? device.color : Colors.grey,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 32),
            ),
            child: Text(
              isOptimalTime ? 'Uruchom teraz' : 'Zaplanuj',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
