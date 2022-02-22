import 'package:laundry/db/aggregates/plain_order_details.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/order_event.dart';
import 'package:laundry/event_source/projectors/declare.dart';

class OrderDetailsProjector {
  static PlainOrderDetail? projectStatic(List<Event> events) {
    assertStreamId(events);
    events.sort((a, b) => a.version.compareTo(b.version));

    PlainOrderDetail? data;
    for (final event in events) {
      data = _projectEvent(event, data);
    }

    return data;
  }

  static PlainOrderDetail? _projectEvent(Event event, PlainOrderDetail? order) {
    switch (event.tag) {
      case OrderCreated.staticTag:
        return _onCreate(event);
      case OrderRemoved.staticTag:
        return _onRemoved(event, order!);
      case OrderRestored.staticTag:
        return _onRestored(event, order!);
      case OrderSent.staticTag:
        return _onSent(event, order!);
      case OrderSentCancelled.staticTag:
        return _onSentCancel(event, order!);
    }
  }

  static PlainOrderDetail _onCreate(Event event) {
    final data = OrderCreatedSerializer().fromJson(event.data);
    return PlainOrderDetail(
      streamId: event.streamId,
      orderId: data.orderId,
      createDate: event.date,
      lastEditorId: data.userId,
      userId: data.userId,
      customerId: data.customerId,
      items: data.items,
    );
  }

  static PlainOrderDetail _onRestored(Event event, PlainOrderDetail detail) {
    final data = OrderRestoredSerializer().fromJson(event.data);
    detail.removedDate = null;
    detail.lastEditorId = data.restoredBy;
    return detail;
  }

  static PlainOrderDetail _onRemoved(Event event, PlainOrderDetail detail) {
    final data = OrderRemovedSerializer().fromJson(event.data);
    detail.removedDate = event.date;
    detail.lastEditorId = data.removedBy;
    return detail;
  }

  static PlainOrderDetail _onSent(Event event, PlainOrderDetail detail) {
    final data = OrderSentSerializer().fromJson(event.data);
    detail.checkoutDate = event.date;
    detail.lastEditorId = data.sentBy;
    return detail;
  }

  static PlainOrderDetail _onSentCancel(Event event, PlainOrderDetail detail) {
    final data = OrderSentCancelledSerializer().fromJson(event.data);
    detail.checkoutDate = null;
    detail.lastEditorId = data.cancelledBy;
    return detail;
  }
}
