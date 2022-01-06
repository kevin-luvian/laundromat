import 'package:drift/drift.dart';

@DataClassName("User")
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get streamID => text()();

  TextColumn get username => text().customConstraint("UNIQUE")();

  TextColumn get password => text()();

  TextColumn get fullName => text()();

  TextColumn get role => text()();
}
