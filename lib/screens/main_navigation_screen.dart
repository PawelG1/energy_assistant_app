import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'solar_calculator_page.dart';
import 'dashboard_screen.dart';
import 'threejs_webview_page.dart'; // Changed import
import 'upgrade_installation_screen.dart';
import 'support_screen.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    
    // List of screens for the navigation
    final screens = [
      const DashboardScreen(),
      const SolarCalculatorPage(),
      const ThreeJSWebViewPage(), // Changed screen
      const UpgradeInstallationScreen(),
      const SupportScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Required for more than 3 items
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
            icon: Icon(Icons.wb_sunny), // Changed icon
            label: 'Shadow Simulator', // Changed label
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