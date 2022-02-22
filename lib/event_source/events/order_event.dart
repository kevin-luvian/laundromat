import 'package:laundry/db/aggregates/plain_order_details.dart';
import 'package:laundry/helpers/utils.dart';

const orderEventType = "ORDER";

class OrderCreated implements EventData<OrderCreated> {
  final String orderId;
  final String userId;
  final String? customerId;
  final List<OrderItem> items;

  OrderCreated({
    required this.orderId,
    required this.userId,
    required this.customerId,
    required this.items,
  });

  @override
  get tag => staticTag;
  static const String staticTag = "OrderCreated";

  @override
  get serializer => OrderCreatedSerializer();

  @override
  String toString() {
    final itemsString = items.map((i) => "{ $i }").toList();
    return '''userId: $userId, customerId: $customerId, items: $itemsString''';
  }
}

class OrderSent implements EventData<OrderSent> {
  final String sentBy;

  OrderSent(this.sentBy);

  @override
  get serializer => OrderSentSerializer();

  @override
  get tag => staticTag;
  static const String staticTag = "OrderSent";
}

class OrderSentCancelled implements EventData<OrderSentCancelled> {
  final String cancelledBy;

  OrderSentCancelled(this.cancelledBy);

  @override
  get serializer => OrderSentCancelledSerializer();

  @override
  get tag => staticTag;
  static const String staticTag = "OrderSentCancelled";
}

class OrderRemoved implements EventData<OrderRemoved> {
  final String removedBy;

  OrderRemoved(this.removedBy);

  @override
  get serializer => OrderRemovedSerializer();

  @override
  get tag => staticTag;
  static const String staticTag = "OrderRemoved";
}

class OrderRestored implements EventData<OrderRestored> {
  final String restoredBy;

  OrderRestored(this.restoredBy);

  @override
  get serializer => OrderRestoredSerializer();

  @override
  get tag => staticTag;
  static const String staticTag = "OrderRestored";
}

/// SERIALIZERS ==============================================================

class OrderCreatedSerializer implements Serializer<OrderCreated> {
  OrderItemSerializer get orderItemSerializer => OrderItemSerializer();

  @override
  fromJson(data) {
    return OrderCreated(
      orderId: data["orderId"] as String,
      userId: data["userId"] as String,
      customerId: data["customerId"] as String?,
      items: (data["items"] as List)
          .cast<Map<String, dynamic>>()
          .map(orderItemSerializer.fromJson)
          .toList(),
    );
  }

  @override
  toJson(t) => <String, dynamic>{
        "orderId": t.orderId,
        "userId": t.userId,
        "customerId": t.customerId,
        "items":
            t.items.map(orderItemSerializer.toJson).toList(growable: false),
      };
}

class OrderSentSerializer implements Serializer<OrderSent> {
  @override
  fromJson(data) => OrderSent(data["sentBy"] as String);

  @override
  toJson(t) => <String, dynamic>{"sentBy": t.sentBy};
}

class OrderRemovedSerializer implements Serializer<OrderRemoved> {
  @override
  fromJson(data) => OrderRemoved(data["removedBy"] as String);

  @override
  toJson(t) => <String, dynamic>{"removedBy": t.removedBy};
}

class OrderRestoredSerializer implements Serializer<OrderRestored> {
  @override
  fromJson(data) => OrderRestored(data["restoredBy"] as String);

  @override
  toJson(t) => <String, dynamic>{"restoredBy": t.restoredBy};
}

class OrderSentCancelledSerializer implements Serializer<OrderSentCancelled> {
  @override
  fromJson(data) => OrderSentCancelled(data["cancelledBy"] as String);

  @override
  toJson(t) => <String, dynamic>{"cancelledBy": t.cancelledBy};
}
