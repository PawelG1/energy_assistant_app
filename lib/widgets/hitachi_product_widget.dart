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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Uproszczona logika ładowania obrazu
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    // Usunięto problematyczne nagłówki cache-control
                    errorBuilder: (context, error, stackTrace) {
                      // Prostsza obsługa błędów
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [product.color.withOpacity(0.8), product.color],
                          ),
                        ),
                        child: const Icon(Icons.image_not_supported, size: 30, color: Colors.white54),
                      );
                    },
                  ),
                ),
                // Gradient overlay for text readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        product.color.withOpacity(0.3),
                        product.color.withOpacity(0.7),
                      ],
                    ),
                  ),
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
                          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                        ),
                      ),
                      Text(
                        '$count szt.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Szczegóły produktu
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                
                // Specyfikacja techniczna - kompaktowo
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (product.power != null)
                      _buildSpecChip('Moc: ${product.power}kW'),
                    if (product.efficiency != null)
                      _buildSpecChip('Sprawność: ${product.efficiency}%'),
                    if (product.capacity != null)
                      _buildSpecChip('Pojemność: ${product.capacity}kWh'),
                    if (product.cycles != null)
                      _buildSpecChip('Cykle: ${product.cycles}'),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Główne cechy
                Text(
                  product.features.take(2).join(' • '),
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                // Cena - zawsze na dole karty
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: product.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${cost.toStringAsFixed(0)} PLN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: product.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSpecChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 9, color: Colors.grey.shade800),
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