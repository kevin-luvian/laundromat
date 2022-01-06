import "package:collection/collection.dart";
import 'package:drift/drift.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/events.dart';

part 'event.g.dart';

@DriftAccessor(tables: [Events])
class EventDao extends DatabaseAccessor<DriftDB> with _$EventDaoMixin {
  EventDao(DriftDB db) : super(db);

  Future<int> createEvent(EventsCompanion event) => into(events).insert(event);

  Future<List<Event>> findEventStream(String streamID) {
    return (select(events)
          ..where((e) => e.streamID.equals(streamID))
          ..orderBy([(e) => OrderingTerm(expression: e.version)]))
        .get();
  }

  Future<Map<String, List<Event>>> findEventsByType(String streamType) async {
    final allEventTypes = await (select(events)
          ..where((e) => e.streamType.equals(streamType))
          ..orderBy([(e) => OrderingTerm(expression: e.version)]))
        .get();

    return groupBy(allEventTypes, (Event obj) => obj.streamID);
  }
}
