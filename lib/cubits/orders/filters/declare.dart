import 'package:laundry/db/aggregates/order_details.dart';

abstract class Filter {
  const Filter(this.hasValue);

  bool valid(OrderDetail order);

  final bool hasValue;
}
