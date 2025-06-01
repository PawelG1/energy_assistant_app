import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculation_results_provider.dart';
import '../providers/models/calculation_results.dart';
import '../providers/models/calculator_parameters.dart';
import '../providers/models/system_configuration.dart';
import '../providers/system_configuration_provider.dart';
import '../providers/calculator_parameters_provider.dart';
import '../utils/formatters.dart';
import '../services/pdf_report_service.dart';
import 'package:printing/printing.dart';

class RecommendationWidget extends ConsumerWidget {
  const RecommendationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculations = ref.watch(calculationResultsProvider);
    // Add these new providers
    final systemConfig = ref.watch(systemConfigurationProvider);
    final parameters = ref.watch(calculatorParametersProvider);

    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.blue.shade50],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.check_circle, size: 48, color: Colors.green.shade600),
            const SizedBox(height: 16),
            Text(
              'Rekomendujemy inwestycję w system Hitachi Energy!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Na podstawie analizy danych statystycznych i parametrów Twojego gospodarstwa domowego',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Replace Row with Wrap for better responsiveness
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16, // horizontal space
              runSpacing: 16, // vertical space between rows
              children: [
                _buildRecommendationMetric(
                  Formatters.formatCurrency(calculations.total25YearSavings), // Use formatter
                  'Oszczędności w 25 lat',
                  Colors.green,
                ),
                _buildRecommendationMetric(
                  '${calculations.paybackYear ?? "Brak"} lat',
                  'Okres zwrotu',
                  Colors.blue,
                ),
                _buildRecommendationMetric(
                  '${((calculations.total25YearSavings / calculations.netInstallationCost) * 100).toStringAsFixed(0)}%',
                  'ROI w 25 lat',
                  Colors.purple,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Use LayoutBuilder to make buttons responsive
            LayoutBuilder(
              builder: (context, constraints) {
                // Use Column for very narrow screens
                if (constraints.maxWidth < 400) {
                  return Column(
                    children: [
                      _buildActionButton(
                        'Eksport PDF',
                        Icons.download,
                        Colors.red.shade600,
                        () async {
                          _generateAndSharePdf(context, calculations, systemConfig, parameters);
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildActionButton(
                        'Kontakt z ekspertem',
                        Icons.phone,
                        Colors.green.shade600,
                        () {
                          _showContactDialog(context);
                        },
                      ),
                    ],
                  );
                } else {
                  // Use Row for wider screens
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        'Eksport PDF',
                        Icons.download,
                        Colors.red.shade600,
                        () async {
                          _generateAndSharePdf(context, calculations, systemConfig, parameters);
                        },
                      ),
                      _buildActionButton(
                        'Kontakt z ekspertem',
                        Icons.phone,
                        Colors.green.shade600,
                        () {
                          _showContactDialog(context);
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // New method to generate and share PDF
  Future<void> _generateAndSharePdf(
    BuildContext context, 
    CalculationResults calculations, 
    SystemConfiguration systemConfig,
    CalculatorParameters parameters
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    // Show loading indicator
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Generowanie raportu PDF...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      // Generate PDF
      final pdfBytes = await PdfReportService.generateReport(
        calculations: calculations,
        systemConfig: systemConfig,
        parameters: parameters,
      );
      
      // Show PDF preview
      await Printing.sharePdf(
        bytes: pdfBytes, 
        filename: 'hitachi_energy_raport.pdf'
      );
      
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Raport PDF został wygenerowany'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Błąd podczas generowania PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // New method to show contact dialog
  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.contact_phone, color: Colors.green.shade600),
              const SizedBox(width: 8),
              const Text('Kontakt z ekspertem'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Skontaktuj się z naszym zespołem ekspertów, którzy odpowiedzą na wszystkie pytania dotyczące instalacji fotowoltaicznej.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              _buildContactItem(Icons.phone, 'Telefon', '+48 123 456 789'),
              const SizedBox(height: 8),
              _buildContactItem(Icons.email, 'Email', 'contact@hitachienergy.com'),
              const SizedBox(height: 8),
              _buildContactItem(Icons.schedule, 'Godziny pracy', 'Pon-Pt: 8:00-16:00'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Zamknij'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                // Here you could add actual phone call functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Inicjowanie połączenia...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.phone),
              label: const Text('Zadzwoń teraz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendationMetric(String value, String label, Color color) {
    return Container(
      width: 150, // Increase width from 120 to 150 to accommodate longer text
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          FittedBox( // Wrap in FittedBox to ensure text fits
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}