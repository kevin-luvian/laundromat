import 'package:drift/drift.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/helpers/utils.dart';

import '../stream.dart';

abstract class Command {
  final EventDao eventDao;
  final String streamType;

  Command(EventDB db, this.streamType) : eventDao = EventDao(db);

  Future<void> generateEvent({
    required String streamId,
    required EventData data,
    int? version,
  }) async {
    final event = ProjectionEvent<dynamic>(
      streamType: streamType,
      date: DateTime.now(),
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

  Future<void> deleteAllData() => _deleteAll(exceptions: ["users"]);

  Future<void> replayAllEvents() async {
    await _deleteAll();
    final allEvents = await _eventDao.allEvents();
    allEvents.forEach(EventStream.sink.add);
  }

  Future<void> _deleteAll({List<String> exceptions = const []}) async {
    final futures = _ddb.allTables.map((tbl) async {
      if ([...exceptions, "sessions"].contains(tbl.actualTableName)) {
        return;
      }
      await _ddb.delete<Table, dynamic>(tbl).go();
    }).toList();
    await Future.wait(futures);
  }
}
