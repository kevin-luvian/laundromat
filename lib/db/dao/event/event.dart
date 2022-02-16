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

  static OrderingTerm dateOrdering($EventsTable e) =>
      OrderingTerm(expression: e.date, mode: OrderingMode.desc);

  Future<List<Event>> allEvents() =>
      (select(events)..orderBy([(e) => OrderingTerm(expression: e.id)])).get();

  Future<List<Event>> findEventsByType(String streamType) => (select(events)
        ..where((e) => e.streamType.equals(streamType))
        ..orderBy([
          (e) => OrderingTerm(expression: e.id),
          dateOrdering,
          (e) => OrderingTerm(expression: e.version),
        ]))
      .get();

  Future<List<String>> distinctIdByType(String streamType) {
    final query = selectOnly(events, distinct: true)
      ..addColumns([events.streamId])
      ..orderBy(
          [OrderingTerm(expression: events.date, mode: OrderingMode.desc)])
      ..where(events.streamType.equals(streamType));
    return query.map((row) => row.read(events.streamId) ?? "").get();
  }

  Stream<Map<String, List<Event>>> streamByType(String streamType) {
    final query = select(events)
      ..where((tbl) => tbl.streamType.equals(streamType))
      ..orderBy([
        (e) => OrderingTerm(expression: e.version),
        dateOrdering,
      ]);
    return query.watch().map(groupEventsById);
  }

  Future<List<Event>> findAllByIdConstrainedByDate(
      String streamId, DateTime date) {
    final query = select(events)
      ..where((tbl) => tbl.streamId.equals(streamId))
      ..where((tbl) => tbl.date.isSmallerOrEqual(Variable(date)))
      ..orderBy([
        (e) => OrderingTerm(expression: e.version),
        dateOrdering,
      ]);
    return query.get();
  }

  Future<List<Event>> findAllByIdsConstrainedByDate(
      List<String> streamIds, DateTime date) {
    final query = select(events)
      ..where((tbl) => tbl.streamId.isIn(streamIds))
      ..where((tbl) => tbl.date.isSmallerOrEqual(Variable(date)))
      ..orderBy([
        (e) => OrderingTerm(expression: e.version),
        dateOrdering,
      ]);
    return query.get();
  }

  Map<String, List<Event>> groupEventsById(List<Event> events) {
    final groupedData = <String, List<Event>>{};
    for (final event in events) {
      final eList = groupedData.putIfAbsent(event.streamId, () => []);
      eList.add(event);
    }
    return groupedData;
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
