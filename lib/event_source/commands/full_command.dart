import 'package:drift/drift.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/helpers/utils.dart';

import '../stream.dart';

abstract class Command {
  final EventDao eventDao;
  final String streamType;

  Command(EventDB db, this.streamType) : eventDao = EventDao(db);

  String generateId() => makeStreamId(streamType);

  Future<void> generateEvent({
    required String streamId,
    required EventData data,
    int? version,
    DateTime? date,
  }) async {
    final event = ProjectionEvent<dynamic>(
      streamType: streamType,
      date: date ?? DateTime.now(),
      version: version ?? await eventDao.lastVersion(streamId) + 1,
      streamId: streamId,
      streamTag: data.tag,
      serializer: data.serializer,
      data: data,
    );
    await persistEvent(eventDao, event);
  }
}

class FullCommand {
  final DriftDB _ddb;
  final EventDao _eventDao;

  FullCommand(this._ddb, EventDB _edb) : _eventDao = EventDao(_edb);

  Future<void> deleteAllData() => _deleteAllSave();

  Future<void> replayAllEvents() async {
    await _deleteAll();
    final allEvents = await _eventDao.allEvents();
    allEvents.forEach(EventStream.sink.add);
  }

  Future<void> _deleteAllSave() async {
    final futures = _ddb.allTables.map((tbl) async {
      if (["sessions"].contains(tbl.actualTableName)) {
        return;
      } else if (tbl.actualTableName == "users") {
        await UserDao(_ddb).deleteAllExceptSuperAdmin();
      } else {
        await _ddb.delete<Table, dynamic>(tbl).go();
      }
    }).toList();
    await Future.wait(futures);
  }

  Future<void> _deleteAll() async {
    final futures = _ddb.allTables.map((tbl) async {
      if (["sessions"].contains(tbl.actualTableName)) {
        return;
      } else {
        await _ddb.delete<Table, dynamic>(tbl).go();
      }
    }).toList();
    await Future.wait(futures);
  }
}
