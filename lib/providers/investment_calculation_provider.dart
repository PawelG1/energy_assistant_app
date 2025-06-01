import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calculation_results_provider.dart';

class InvestmentCalculation {
  final double savingsIn25Years;
  final double returnPeriod;
  final double roi;

  const InvestmentCalculation({
    required this.savingsIn25Years,
    required this.returnPeriod,
    required this.roi,
  });
}

final investmentCalculationProvider = Provider<InvestmentCalculation>((ref) {
  final calculationResults = ref.watch(calculationResultsProvider);
  
  // Extract the investment-related metrics from calculation results
  final savings = calculationResults.total25YearSavings;
  final returnPeriod = calculationResults.paybackYear?.toDouble() ?? 0.0;
  
  // Calculate ROI (Return on Investment) as a percentage
  final roi = calculationResults.netInstallationCost > 0
    ? (calculationResults.total25YearSavings / calculationResults.netInstallationCost) * 100
    : 0.0;
  
  return InvestmentCalculation(
    savingsIn25Years: savings,
    returnPeriod: returnPeriod,
    roi: roi,
  );
});
