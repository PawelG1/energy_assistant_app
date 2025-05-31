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
            flexibleSpace: FlexibleSpaceBar(
              title: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HITACHI', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Słoneczna Przyszłość', style: TextStyle(fontSize: 14)),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.red.shade600, Colors.orange.shade500],
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wb_sunny, size: 48, color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Kalkulator Kosztów Energii dla Każdego',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Porównanie scenariuszy: tradycyjny vs. Hitachi Energy',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
              child: ComparisonChartWidget(),
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