import 'package:drift/drift.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/tables/events.dart';
import 'package:laundry/event_source/commands/user_command.dart';
import 'package:laundry/helpers/logger.dart';

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
          logger.i("event database connected");

          if (details.wasCreated) {
            UserCommand(this).create(
              name: "admin",
              password: "password",
              role: "admin",
              pin: 1234,
            );
            logger.i("Create admin triggered");
          }
        },
      );
}

class EventDBExecutor extends QueryExecutorUser {
  @override
  Future<void> beforeOpen(
    QueryExecutor executor,
    OpeningDetails details,
  ) async {
    logger.i("Executor Open");
  }

  @override
  int get schemaVersion => 1;
}
