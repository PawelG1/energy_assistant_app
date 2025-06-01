import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/models/system_configuration.dart';
import '../providers/models/calculation_results.dart';
import '../providers/models/calculator_parameters.dart';
import '../utils/formatters.dart';

class PdfReportService {
  static Future<Uint8List> generateReport({
    required SystemConfiguration systemConfig,
    required CalculationResults calculations,
    required CalculatorParameters parameters,
  }) async {
    final pdf = pw.Document();
    
    // Load custom fonts for branding
    final regularFont = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();
    
    // Header image
    final ByteData logoData = await rootBundle.load('assets/hitachi_logo.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);

    // Format date
    final now = DateTime.now();
    final dateFormatter = DateFormat('dd.MM.yyyy');
    final formattedDate = dateFormatter.format(now);

    // PDF Content
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (pw.Context context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(logoImage, width: 120),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Raport instalacji fotowoltaicznej', style: pw.TextStyle(font: boldFont, fontSize: 16)),
                  pw.Text('Data: $formattedDate', style: pw.TextStyle(font: regularFont, fontSize: 12)),
                  pw.Text('Nr raportu: HIE${now.millisecondsSinceEpoch.toString().substring(6)}', 
                    style: pw.TextStyle(font: regularFont, fontSize: 10)),
                ]
              ),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 20),
            child: pw.Text(
              'Strona ${context.pageNumber} z ${context.pagesCount}',
              style: pw.TextStyle(font: regularFont, fontSize: 9, color: PdfColors.grey700)
            ),
          );
        },
        build: (pw.Context context) => [
          // Title Section
          pw.Center(
            child: pw.Text(
              'Rekomendacja systemu fotowoltaicznego',
              style: pw.TextStyle(font: boldFont, fontSize: 20),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.SizedBox(height: 20),
          
          // System Configuration Summary
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8)
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Konfiguracja systemu', style: pw.TextStyle(font: boldFont, fontSize: 16)),
                pw.SizedBox(height: 10),
                _buildInfoRow('Moc instalacji:', '${calculations.actualPower.toStringAsFixed(2)} kW', regularFont),
                _buildInfoRow('Roczna produkcja:', '${calculations.annualProductionKwh.toStringAsFixed(0)} kWh', regularFont),
                _buildInfoRow('Roczne zużycie:', '${parameters.annualConsumption.toStringAsFixed(0)} kWh', regularFont),
                _buildInfoRow('Autokonsumpcja:', '${parameters.autoConsumptionPercent.toStringAsFixed(0)}%', regularFont),
              ]
            )
          ),
          pw.SizedBox(height: 20),
          
          // Financial Summary
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(8)
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Podsumowanie finansowe', style: pw.TextStyle(font: boldFont, fontSize: 16)),
                pw.SizedBox(height: 10),
                _buildInfoRow('Koszt całkowity:', Formatters.formatCurrency(systemConfig.totalCost), regularFont),
                _buildInfoRow('Ulgi i dotacje:', '- ${Formatters.formatCurrency(calculations.subsidies)}', regularFont),
                _buildInfoRow('Koszt netto:', Formatters.formatCurrency(calculations.netInstallationCost), regularFont),
                _buildInfoRow('Okres zwrotu:', '${calculations.paybackYear ?? "Brak"} lat', regularFont),
                _buildInfoRow('Oszczędności (25 lat):', Formatters.formatCurrency(calculations.total25YearSavings), regularFont),
                _buildInfoRow('ROI (25 lat):', '${((calculations.total25YearSavings / calculations.netInstallationCost) * 100).toStringAsFixed(0)}%', regularFont),
              ]
            )
          ),
          pw.SizedBox(height: 20),
          
          // System Components
          pw.Text('Komponenty systemu Hitachi Energy', style: pw.TextStyle(font: boldFont, fontSize: 16)),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              // Header row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableCell('Komponenty', isHeader: true, font: boldFont),
                  _buildTableCell('Model', isHeader: true, font: boldFont),
                  _buildTableCell('Ilość', isHeader: true, font: boldFont),
                  _buildTableCell('Wartość', isHeader: true, font: boldFont),
                ]
              ),
              // Data rows
              pw.TableRow(
                children: [
                  _buildTableCell('Panele fotowoltaiczne', font: regularFont),
                  _buildTableCell(systemConfig.panelProduct.name, font: regularFont),
                  _buildTableCell('${systemConfig.panelCount} szt', font: regularFont),
                  _buildTableCell('${systemConfig.panelsCost.toStringAsFixed(0)} PLN', font: regularFont),
                ]
              ),
              pw.TableRow(
                children: [
                  _buildTableCell('Inwerter', font: regularFont),
                  _buildTableCell(systemConfig.inverterProduct.name, font: regularFont),
                  _buildTableCell('${systemConfig.inverterCount} szt', font: regularFont),
                  _buildTableCell('${systemConfig.invertersCost.toStringAsFixed(0)} PLN', font: regularFont),
                ]
              ),
              if (parameters.enableBattery) pw.TableRow(
                children: [
                  _buildTableCell('Magazyn energii', font: regularFont),
                  _buildTableCell(systemConfig.batteryProduct?.name ?? '-', font: regularFont),
                  _buildTableCell('${systemConfig.batteryCount} szt', font: regularFont),
                  _buildTableCell('${systemConfig.batteriesCost.toStringAsFixed(0)} PLN', font: regularFont),
                ]
              ),
              pw.TableRow(
                children: [
                  _buildTableCell('Monitoring', font: regularFont),
                  _buildTableCell(systemConfig.monitoringProduct.name, font: regularFont),
                  _buildTableCell('1 szt', font: regularFont),
                  _buildTableCell('${systemConfig.monitoringCost.toStringAsFixed(0)} PLN', font: regularFont),
                ]
              ),
              pw.TableRow(
                children: [
                  _buildTableCell('Montaż', font: regularFont),
                  _buildTableCell('-', font: regularFont),
                  _buildTableCell('-', font: regularFont),
                  _buildTableCell('${systemConfig.installationCost.toStringAsFixed(0)} PLN', font: regularFont),
                ]
              ),
            ]
          ),
          pw.SizedBox(height: 30),
          
          // Year-by-year analysis - First 10 years
          pw.Text('Analiza roczna', style: pw.TextStyle(font: boldFont, fontSize: 16)),
          pw.SizedBox(height: 10),
          _buildYearlyAnalysis(calculations, regularFont, 0, 10),
          pw.SizedBox(height: 20),
          
          // Year-by-year analysis - Remaining years
          _buildYearlyAnalysis(calculations, regularFont, 10, 25),
          pw.SizedBox(height: 30),
          
          // Recommendation Section
          pw.Container(
            padding: const pw.EdgeInsets.all(15),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.green700, width: 1)
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Rekomendujemy inwestycję w system Hitachi Energy!',
                  style: pw.TextStyle(font: boldFont, fontSize: 16, color: PdfColors.green800),
                  textAlign: pw.TextAlign.center
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Na podstawie analizy danych statystycznych i parametrów Twojego gospodarstwa domowego rekomendujemy instalację systemu fotowoltaicznego Hitachi Energy o mocy ${calculations.actualPower.toStringAsFixed(1)} kW.',
                  style: pw.TextStyle(font: regularFont, fontSize: 12),
                  textAlign: pw.TextAlign.center,
                ),
              ]
            )
          ),
          pw.SizedBox(height: 30),
          
          // Contact Information
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.red50,
              borderRadius: pw.BorderRadius.circular(8)
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Kontakt:', style: pw.TextStyle(font: boldFont, fontSize: 14)),
                      pw.SizedBox(height: 5),
                      pw.Text('Hitachi Energy Polska Sp. z o.o.', style: pw.TextStyle(font: regularFont, fontSize: 11)),
                      pw.Text('Tel: +48 123 456 789', style: pw.TextStyle(font: regularFont, fontSize: 11)),
                      pw.Text('Email: contact@hitachienergy.com', style: pw.TextStyle(font: regularFont, fontSize: 11)),
                    ]
                  )
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Umów konsultację:', style: pw.TextStyle(font: boldFont, fontSize: 14)),
                      pw.SizedBox(height: 5),
                      pw.Text('Zeskanuj kod QR lub odwiedź:', style: pw.TextStyle(font: regularFont, fontSize: 11)),
                      pw.Text('www.hitachienergy.com/solar', style: pw.TextStyle(font: regularFont, fontSize: 11)),
                    ]
                  )
                )
              ]
            )
          )
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildInfoRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(font: font, fontSize: 12)),
          pw.Text(value, style: pw.TextStyle(font: font, fontSize: 12, fontWeight: pw.FontWeight.bold)),
        ]
      )
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false, required pw.Font font}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal
        )
      )
    );
  }

  static pw.Widget _buildYearlyAnalysis(CalculationResults calculations, pw.Font font, int startYear, int endYear) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Rok', isHeader: true, font: font),
            _buildTableCell('Cena energii', isHeader: true, font: font),
            _buildTableCell('Koszt bez PV', isHeader: true, font: font),
            _buildTableCell('Koszt z PV', isHeader: true, font: font),
            _buildTableCell('Oszczędności', isHeader: true, font: font),
            _buildTableCell('Suma oszczędności', isHeader: true, font: font),
          ]
        ),
        // Data rows - only show a subset based on start and end indices
        ...calculations.results
            .where((result) => result.year > startYear && result.year <= endYear)
            .map((result) => pw.TableRow(
                children: [
                  _buildTableCell('${result.year}', font: font),
                  _buildTableCell('${result.currentEnergyPrice.toStringAsFixed(2)} PLN', font: font),
                  _buildTableCell('${result.costWithoutPV.toStringAsFixed(0)} PLN', font: font),
                  _buildTableCell('${result.costWithPV.toStringAsFixed(0)} PLN', font: font),
                  _buildTableCell('${result.yearlySavings.toStringAsFixed(0)} PLN', font: font),
                  _buildTableCell('${result.cumulativeSavings.toStringAsFixed(0)} PLN', font: font),
                ]
              )
            ).toList(),
      ]
    );
  }

  static Future<void> sharePdf(Uint8List pdfBytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/hitachi_energy_raport.pdf');
    await file.writeAsBytes(pdfBytes);
    await Share.shareXFiles([XFile(file.path)], text: 'Raport instalacji fotowoltaicznej Hitachi Energy');
  }
}
