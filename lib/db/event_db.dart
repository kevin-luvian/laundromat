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

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          logger.i("event database connected");

          if (details.wasCreated) {
            // UserCommand(this).create(
            //   username: "admin",
            //   password: "password",
            //   fullName: "the admin",
            //   role: "admin",
            // );
          }
        },
      );
}
