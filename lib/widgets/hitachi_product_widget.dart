import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/system_configuration_provider.dart';
import '../providers/calculation_results_provider.dart';

class HitachiProductsWidget extends ConsumerWidget {
  const HitachiProductsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemConfig = ref.watch(systemConfigurationProvider);
    final calculations = ref.watch(calculationResultsProvider);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rekomendowane produkty Hitachi Energy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Grid produktów
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildProductCard(
                  systemConfig.panelProduct,
                  systemConfig.panelCount,
                  systemConfig.panelsCost,
                ),
                _buildProductCard(
                  systemConfig.inverterProduct,
                  systemConfig.inverterCount,
                  systemConfig.invertersCost,
                ),
                if (systemConfig.batteryProduct != null)
                  _buildProductCard(
                    systemConfig.batteryProduct!,
                    systemConfig.batteryCount,
                    systemConfig.batteriesCost,
                  ),
                _buildProductCard(
                  systemConfig.monitoringProduct,
                  1,
                  systemConfig.monitoringCost,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Podsumowanie kosztów
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade600, Colors.orange.shade500],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Podsumowanie finansowe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCostSummary(
                        'Koszt brutto', 
                        '${systemConfig.totalCost.toStringAsFixed(0)} PLN'
                      ),
                      _buildCostSummary(
                        'Ulgi i dotacje', 
                        '-${calculations.subsidies.toStringAsFixed(0)} PLN'
                      ),
                      _buildCostSummary(
                        'Koszt netto', 
                        '${calculations.netInstallationCost.toStringAsFixed(0)} PLN'
                      ),
                      _buildCostSummary(
                        'Zwrot', 
                        '${calculations.paybackYear ?? "Brak"} lat'
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(dynamic product, int count, double cost) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header z obrazem i kategorią
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [product.color.withOpacity(0.8), product.color],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: Icon(Icons.image, size: 30, color: Colors.white54),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$count szt.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Szczegóły produktu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Specyfikacja techniczna
                  if (product.power != null)
                    Text('Moc: ${product.power}kW', 
                         style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  if (product.efficiency != null)
                    Text('Sprawność: ${product.efficiency}%', 
                         style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  if (product.capacity != null)
                    Text('Pojemność: ${product.capacity}kWh', 
                         style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  if (product.cycles != null)
                    Text('Cykle: ${product.cycles}', 
                         style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  
                  const Spacer(),
                  
                  // Cena
                  Text(
                    '${cost.toStringAsFixed(0)} PLN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: product.color,
                    ),
                  ),
                  
                  // Główne cechy
                  Text(
                    product.features.take(2).join(' • '),
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostSummary(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}