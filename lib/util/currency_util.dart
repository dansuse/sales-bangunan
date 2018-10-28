import 'package:intl/intl.dart';

class CurrencyUtil {
  static final idrFormatter = new NumberFormat("#,##0.00", "id_ID");

  static String parseDoubleToIDR(double value) {
    return "Rp.${idrFormatter.format(value)}";
  }
}
