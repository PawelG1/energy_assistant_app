import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/configuration_panel.dart';
import '../widgets/hitachi_product_widget.dart';
import '../widgets/key_metrics_widget.dart';
import '../widgets/system_diagram_widget.dart';
import '../widgets/comparison_chart_widget.dart';
import '../widgets/recommendation_widget.dart';

class SolarCalculatorPage extends ConsumerWidget {
  const SolarCalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header z gradientem
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            title: const Text('HITACHI',  
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Helvetica', color: Colors.white),
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
                        const Icon(Icons.solar_power, size: 48, color: Colors.white),
                        const SizedBox(height: 12),
                        const Text(
                          'Kalkulator Kosztów Energii dla Każdego',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        const Text('Planowanie instalacji', 
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Panel konfiguracji
          const SliverToBoxAdapter(
            child: ConfigurationPanel(),
          ),

          // Kluczowe wskaźniki
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: KeyMetricsWidget(),
            ),
          ),

          // Schemat systemu
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SystemDiagramWidget(),
            ),
          ),

          // Produkty Hitachi Energy
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: HitachiProductsWidget(),
            ),
          ),

          // Wykres porównawczy
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ComparisonChartWidget(), // Ten widget teraz zawiera dwa wykresy
            ),
          ),

          // Rekomendacja
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: RecommendationWidget(),
            ),
          ),

          // Spacer na koniec
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}