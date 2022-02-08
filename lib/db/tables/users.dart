import 'package:drift/drift.dart';

const roleSuperAdmin = "SUPER_ADMIN";
const roleAdmin = "ADMIN";
const roleStaff = "STAFF";

@DataClassName("User")
class Users extends Table {
  TextColumn get id => text().customConstraint("UNIQUE")();

  TextColumn get name => text().customConstraint("UNIQUE")();

  IntColumn get pin => integer()();

  TextColumn get password => text()();

  TextColumn get role => text()();
}
