import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/event_source/events/product_addon_event.dart';
import 'package:laundry/helpers/utils.dart';

class ProductAddonCommand {
  final EventDao _eventDao;

  ProductAddonCommand(EventDB _db) : _eventDao = EventDao(_db);

  Future<void> _generateEvent<T>({
    required String streamId,
    required String streamTag,
    required Serializer<T> serializer,
    required T data,
    int? version,
  }) async {
    final event = ProjectionEvent<T>(
      streamType: productAddonEventType,
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
    required String productId,
    required String title,
    required int price,
  }) async {
    var streamId = makeStreamId(productAddonEventType);
    await _generateEvent(
      streamId: streamId,
      streamTag: AddonAdded.tag,
      version: 1,
      serializer: AddonAddedSerializer(),
      data: AddonAdded(
        productId: productId,
        title: title,
        price: price,
      ),
    );
    return streamId;
  }

  Future<void> remove(String streamId) async {
    await _generateEvent(
      streamId: streamId,
      streamTag: AddonRemoved.tag,
      serializer: EmptySerializer(),
      data: null,
    );
  }
}
