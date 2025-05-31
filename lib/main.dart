import 'package:energy_strategist/screens/solar_calculator_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const SolarCalculatorApp());
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
        useMaterial3: true,
      ),
      home: const SolarCalculatorPage(),
    );
  }
}

