import 'package:drift/drift.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/db/tables/events.dart';

part 'event.g.dart';

@DriftAccessor(tables: [Events])
class EventDao extends DatabaseAccessor<EventDB> with _$EventDaoMixin {
  EventDao(EventDB db) : super(db);

  Future<Event> createEvent(EventsCompanion event) =>
      into(events).insertReturning(event);

  /// read all event based on stream id, ordered by the version number.
  Future<List<Event>> findEventStream(String streamId) {
    return (select(events)
          ..where((e) => e.streamId.equals(streamId))
          ..orderBy([(e) => OrderingTerm(expression: e.version)]))
        .get();
  }

  Future<List<Event>> allEvents() => select(events).get();

  Future<List<Event>> findEventsByType(String streamType) => (select(events)
        ..where((e) => e.streamType.equals(streamType))
        ..orderBy([
          (e) => OrderingTerm(expression: e.id),
          (e) => OrderingTerm(expression: e.date, mode: OrderingMode.desc),
          (e) => OrderingTerm(expression: e.version),
        ]))
      .get();

  Future<List<List<Event>>> findEventsByType2(String streamType) async {
    final allEvents = await (select(events)
          ..where((e) => e.streamType.equals(streamType))
          ..orderBy([
            (e) => OrderingTerm(expression: e.id),
            (e) => OrderingTerm(expression: e.date, mode: OrderingMode.desc),
            (e) => OrderingTerm(expression: e.streamId),
            (e) => OrderingTerm(expression: e.version),
          ]))
        .get();

    // allEvents.sortBy((e) => e.streamId);
    final List<List<Event>> eventsLists = [];
    for (final event in allEvents) {
      if (eventsLists.isEmpty ||
          event.streamId != eventsLists.last.first.streamId) {
        eventsLists.add([event]);
      } else {
        eventsLists.last.add(event);
      }
    }

    // return groupBy(allEventTypes, (Event obj) => obj.streamId);
    return eventsLists;
  }

  Future<int> lastVersion(String streamId) async {
    final event = await (select(events)
          ..where((e) => e.streamId.equals(streamId))
          ..orderBy([
            (e) => OrderingTerm(expression: e.version, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingleOrNull();
    return event?.version ?? 1;
  }
}
