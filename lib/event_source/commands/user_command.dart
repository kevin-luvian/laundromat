import 'package:crypt/crypt.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/event_source/events/user_event.dart';
import 'package:laundry/helpers/utils.dart';

class UserCommand {
  final EventDao _eventDao;

  UserCommand(EventDB _db) : _eventDao = EventDao(_db);

  Future<String> create({
    required String name,
    required String password,
    required String role,
    required int pin,
  }) async {
    if (pin.toString().length != 4) {
      throw Exception("pin must be a four digit integer");
    }

    password = Crypt.sha256(password).toString();
    var streamId = makeStreamId(UserEvent.streamType);

    final event = ProjectionEvent(
      streamId: streamId,
      streamTag: UserCreated.tag,
      streamType: UserEvent.streamType,
      date: DateTime.now(),
      version: 1,
      serializer: UserCreatedSerializer(),
      data: UserCreated(
        name: name,
        password: password,
        role: role,
        pin: pin,
      ),
    );

    await persistEvent(_eventDao, event);
    return streamId;
  }

  Future<void> update({
    required String streamId,
    String? name,
    String? password,
    String? role,
  }) async {
    password = password != null ? Crypt.sha256(password).toString() : null;

    final event = ProjectionEvent(
      streamId: streamId,
      streamTag: UserUpdated.tag,
      streamType: UserEvent.streamType,
      date: DateTime.now(),
      version: await _eventDao.lastVersion(streamId) + 1,
      data: UserUpdated(
        name: name,
        password: password,
        role: role,
      ),
      serializer: UserUpdatedSerializer(),
    );

    await persistEvent(_eventDao, event);
  }

  Future<void> deactivate({required String streamId}) async {
    final event = ProjectionEvent(
      streamId: streamId,
      streamTag: UserDeactivated.tag,
      streamType: UserEvent.streamType,
      date: DateTime.now(),
      version: await _eventDao.lastVersion(streamId) + 1,
      data: UserDeactivated(),
      serializer: UserDeactivatedSerializer(),
    );

    await persistEvent(_eventDao, event);
  }
}
