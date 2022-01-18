import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/event_source/events/product_event.dart';
import 'package:laundry/helpers/utils.dart';

class ProductCommand {
  final EventDao _eventDao;

  ProductCommand(EventDB _db) : _eventDao = EventDao(_db);

  Future<String> create({
    required String category,
    required String title,
    required int price,
    required String unit,
  }) async {
    var streamId = makeStreamId(PRODUCT_EVENT_TYPE);

    final event = ProjectionEvent(
      streamId: streamId,
      streamTag: PRODUCT_EVENT_TYPE,
      streamType: ProductCreated.tag,
      date: DateTime.now(),
      version: 1,
      data: ProductCreated(
        category: category,
        title: title,
        price: price,
        unit: unit,
      ),
    );

    await persistEvent(_eventDao, event);
    return streamId;
  }
}
