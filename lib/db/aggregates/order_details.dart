import 'package:laundry/db/aggregates/product_order_details.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/utils.dart';

class OrderDetail {
  OrderDetail({
    required this.streamId,
    required this.orderId,
    required this.user,
    required this.orders,
    required this.createDate,
    this.customer,
    this.checkoutDate,
    this.removedDate,
  });

  final String streamId;
  final String orderId;
  final User user;
  final Customer? customer;
  final List<ProductOrderDetail> orders;
  final DateTime createDate;
  final DateTime? checkoutDate;
  final DateTime? removedDate;

  int get totalPrice => orders.map((e) => e.totalPrice).reduce(sumInt);

  @override
  toString() {
    final ordersString = orders.map((o) => "{ $o }");
    return "user: $user\ncustomer: $customer\norders: $ordersString";
  }
}
