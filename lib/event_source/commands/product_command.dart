import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/event_source/events/product_event.dart';
import 'package:laundry/helpers/utils.dart';

class ProductCommand {
  final EventDao _eventDao;

  ProductCommand(EventDB _db) : _eventDao = EventDao(_db);

  Future<void> generateEvent<T>(
    String streamId, {
    required String streamTag,
    required Serializer<T> serializer,
    required T data,
    int? version,
  }) async {
    final event = ProjectionEvent<T>(
      streamType: PRODUCT_EVENT_TYPE,
      date: DateTime.now(),
      version: version ?? await _eventDao.lastVersion(streamId) + 1,
      streamId: streamId,
      streamTag: streamTag,
      serializer: serializer,
      data: data,
    );
    await persistEvent(_eventDao, event);
  }

  Future<String> create({
    required String category,
    required String title,
    required int price,
    required String unit,
  }) async {
    var streamId = makeStreamId(PRODUCT_EVENT_TYPE);
    await generateEvent(
      streamId,
      streamTag: ProductCreated.tag,
      serializer: ProductCreatedSerializer(),
      version: 1,
      data: ProductCreated(
        category: category,
        title: title,
        price: price,
        unit: unit,
      ),
    );
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
    await generateEvent(
      streamId,
      streamTag: ProductUpdated.tag,
      serializer: ProductUpdatedSerializer(),
      data: ProductUpdated(
        category: category,
        title: title,
        price: price,
        unit: unit,
      ),
    );
  }

  Future<void> delete({required String streamId}) async {
    await generateEvent(
      streamId,
      streamTag: ProductDeleted.tag,
      serializer: ProductDeletedSerializer(),
      data: ProductDeleted(),
    );
  }
}
