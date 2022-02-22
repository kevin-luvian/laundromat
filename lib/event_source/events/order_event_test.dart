import 'package:laundry/db/aggregates/plain_order_details.dart';
import 'package:laundry/event_source/events/order_event.dart';
import 'package:test/test.dart';

void main() {
  test('create event OrderCreated successfully', () async {
    final evt = OrderCreated(
      orderId: "Ord1",
      userId: "userId",
      customerId: "customerId",
      items: [
        OrderItem(10, "abc", ["123", "456"]),
        OrderItem(5, "abcdefg", ["123", "456"]),
      ],
    );

    expect(evt.items.length, 2);
    expect(evt.items[0].addonIds.length, 2);

    final serializer = OrderCreatedSerializer();
    final json = serializer.toJson(evt);

    final parsedEvt = serializer.fromJson(json);
    expect(parsedEvt.items.length, 2);
    expect(parsedEvt.items[0].addonIds.length, 2);
  });
}
