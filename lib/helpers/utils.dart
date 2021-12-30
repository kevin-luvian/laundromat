import 'package:intl/intl.dart';

formatPrice(double value) {
  return NumberFormat("#,###", "id").format(value);
}
