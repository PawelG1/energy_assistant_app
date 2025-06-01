import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount, {String symbol = 'PLN'}) {
    final formatter = NumberFormat.currency(
      locale: 'pl_PL',
      symbol: '$symbol ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
  
  static String formatPercentage(double value) {
    final formatter = NumberFormat.percentPattern('pl_PL');
    return formatter.format(value / 100);
  }
}
