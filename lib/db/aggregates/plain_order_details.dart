import 'package:laundry/db/aggregates/product_order_details.dart';
import 'package:laundry/helpers/utils.dart';

class PlainOrderDetail {
  final String streamId;
  final String userId;
  final String? customerId;
  final List<OrderItem> items;
  DateTime? checkoutDate;
  DateTime? removedDate;
  String lastEditorId;
  DateTime createDate;

  PlainOrderDetail({
    required this.streamId,
    required this.userId,
    required this.lastEditorId,
    required this.createDate,
    this.customerId,
    this.checkoutDate,
    this.removedDate,
    List<OrderItem>? items,
  }) : items = items ?? [];
}

class OrderItem {
  OrderItem(this.amount, this.productId, this.addonIds);

  factory OrderItem.fromProductOrderDetail(ProductOrderDetail product) {
    return OrderItem(product.amount, product.product.id,
        product.addons.map((a) => a.id).toList());
  }

  Serializer<OrderItem> get serializer => OrderItemSerializer();

  final String productId;
  final List<String> addonIds;
  final double amount;

  @override
  String toString() =>
      '''productId: $productId, amount: $amount, addonIds: $addonIds''';
}

class OrderItemSerializer implements Serializer<OrderItem> {
  @override
  fromJson(data) => OrderItem(
        data["amount"] as double,
        data["productId"] as String,
        (data["addonIds"] as List).cast<String>(),
      );

  @override
  toJson(t) => <String, dynamic>{
        "amount": t.amount,
        "productId": t.productId,
        "addonIds": t.addonIds,
      };
}
