import 'package:laundry/db/aggregates/plain_order_details.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/full_command.dart';
import 'package:laundry/event_source/events/order_event.dart';

class OrderCommand extends Command {
  OrderCommand(EventDB db) : super(db, orderEventType);

  Future<String?> create(
      String userId, String? customerId, List<OrderItem> items) async {
    assert(items.isNotEmpty);

    var streamId = generateId();
    await generateEvent(
      streamId: streamId,
      version: 1,
      data: OrderCreated(userId: userId, customerId: customerId, items: items),
    );
    return streamId;
  }

  Future<void> remove(String streamId, String userId) =>
      generateEvent(streamId: streamId, data: OrderRemoved(userId));

  Future<void> sent(String streamId, String userId) =>
      generateEvent(streamId: streamId, data: OrderSent(userId));

  Future<void> sentCancelled(String streamId, String userId) =>
      generateEvent(streamId: streamId, data: OrderSentCancelled(userId));

  Future<String?> mTempCreate(String userId, String? customerId,
      List<OrderItem> items, DateTime date) async {
    assert(items.isNotEmpty);

    var streamId = generateId();
    await generateEvent(
      streamId: streamId,
      version: 1,
      date: date,
      data: OrderCreated(userId: userId, customerId: customerId, items: items),
    );
    return streamId;
  }
}
