import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/formatters.dart';
import 'investment_calculation_provider.dart';

class FormattedCalculationResults {
  final String savingsIn25Years;
  final String returnPeriod;
  final String roi;
  
  FormattedCalculationResults({
    required this.savingsIn25Years,
    required this.returnPeriod,
    required this.roi,
  });
}

final calculatorResultsFormatterProvider = Provider<FormattedCalculationResults>((ref) {
  final calculationResults = ref.watch(investmentCalculationProvider);
  
  return FormattedCalculationResults(
    savingsIn25Years: Formatters.formatCurrency(calculationResults.savingsIn25Years),
    returnPeriod: '${calculationResults.returnPeriod.toStringAsFixed(1)} lat',
    roi: '${calculationResults.roi.toStringAsFixed(0)}%',
  );
});
