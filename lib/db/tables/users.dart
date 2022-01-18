import 'package:drift/drift.dart';

const userRoleAdmin = "admin";
const userRoleStaff = "staff";

@DataClassName("User")
class Users extends Table {
  TextColumn get id => text().customConstraint("UNIQUE")();

  TextColumn get name => text().customConstraint("UNIQUE")();

  IntColumn get pin => integer()();

  TextColumn get password => text()();

  TextColumn get role => text()();

  @override
  Set<Column> get primaryKey => {id};
}
