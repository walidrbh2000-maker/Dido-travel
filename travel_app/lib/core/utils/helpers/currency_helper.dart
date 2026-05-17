import 'package:intl/intl.dart';

class CurrencyHelper {
  const CurrencyHelper._();

  static String format(double amount, {String symbol = '€'}) {
    final formatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount, {String symbol = '€'}) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k$symbol';
    }
    return format(amount, symbol: symbol);
  }
}
