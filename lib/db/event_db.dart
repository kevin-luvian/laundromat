import 'package:drift/drift.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/seeder.dart';
import 'package:laundry/db/tables/events.dart';

part 'event_db.g.dart';

const tables = [Events];
const daos = [EventDao];

@DriftDatabase(tables: tables, daos: daos)
class EventDB extends _$EventDB {
  EventDB(QueryExecutor e) : super(e);

  Future<void> open() async {
    await (select(events)..where((tbl) => tbl.id.equals(0))).get();
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          if (details.wasCreated) await Seeder(this).seed();
        },
      );
}
