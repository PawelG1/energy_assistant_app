import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'solar_calculator_page.dart';
import 'dashboard_screen.dart';
import 'shadow_simulator_page.dart'; // Nowy import
import 'upgrade_installation_screen.dart';
import 'support_screen.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    
    // List of screens for the navigation - używamy nowej ShadowSimulatorPage
    final screens = [
      const DashboardScreen(),
      const SolarCalculatorPage(),
      const ShadowSimulatorPage(), // Nowa klasa
      const UpgradeInstallationScreen(),
      const SupportScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Colors.red.shade600,
        unselectedItemColor: Colors.grey,
        onTap: (index) => ref.read(navigationIndexProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.solar_power),
            label: 'Installation Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school), // Zmieniona ikona na edukacyjną
            label: 'PV Academy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upgrade),
            label: 'Upgrade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Support',
          ),
        ],
      ),
    );
  }
}