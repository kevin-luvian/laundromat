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

    final event = ProjectionEvent<ProductCreated>(
      streamId: streamId,
      streamTag: ProductCreated.tag,
      streamType: PRODUCT_EVENT_TYPE,
      date: DateTime.now(),
      version: 1,
      serializer: ProductCreatedSerializer(),
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

  Future<void> update({
    required String streamId,
    String? category,
    String? title,
    int? price,
    String? unit,
  }) async {
    if (category == null && title == null && price == null && unit == null) {
      return;
    }
    final event = ProjectionEvent<ProductUpdated>(
      streamId: streamId,
      streamTag: ProductUpdated.tag,
      streamType: PRODUCT_EVENT_TYPE,
      date: DateTime.now(),
      version: await _eventDao.lastVersion(streamId) + 1,
      serializer: ProductUpdatedSerializer(),
      data: ProductUpdated(
        category: category,
        title: title,
        price: price,
        unit: unit,
      ),
    );

    await persistEvent(_eventDao, event);
  }

  Future<void> delete({required String streamId}) async {
    final event = ProjectionEvent<ProductDeleted>(
      streamId: streamId,
      streamTag: ProductDeleted.tag,
      streamType: PRODUCT_EVENT_TYPE,
      date: DateTime.now(),
      version: await _eventDao.lastVersion(streamId) + 1,
      serializer: ProductDeletedSerializer(),
      data: ProductDeleted(),
    );

    await persistEvent(_eventDao, event);
  }
}
