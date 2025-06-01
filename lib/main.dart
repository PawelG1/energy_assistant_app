import 'package:energy_strategist/screens/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  // Initialize WebView platform
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const ProviderScope(
    child: SolarCalculatorApp()
  ));
}

class SolarCalculatorApp extends StatelessWidget {
  const SolarCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hitachi Energy - Słoneczna Przyszłość',
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.red.shade600,
          secondary: Colors.orange.shade500,
        ),
        fontFamily: 'Helvetica', // Używamy Helvetica zamiast NotoSans
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

