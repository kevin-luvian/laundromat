import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';

import '../stream.dart';

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
      await _ddb.delete(tbl).go();
    }).toList();
    await Future.wait(futures);
  }
}
