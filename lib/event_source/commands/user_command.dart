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
  }) async {
    password = Crypt.sha256(password).toString();
    var streamId = UserEvent.streamType + "-" + uuid.v4();

    final event = UserCreated(
      streamId: streamId,
      name: name,
      password: password,
      role: role,
      date: DateTime.now(),
      version: 1,
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

    final event = UserUpdated(
      streamId: streamId,
      date: DateTime.now(),
      version: await _eventDao.lastVersion(streamId) + 1,
      name: name,
      password: password,
      role: role,
    );

    await persistEvent(_eventDao, event);
  }

  Future<void> deactivate({required String streamId}) async {
    final event = UserDeactivated(
      streamId: streamId,
      date: DateTime.now(),
      version: await _eventDao.lastVersion(streamId) + 1,
    );

    await persistEvent(_eventDao, event);
  }
}
