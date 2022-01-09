import 'package:drift/drift.dart';

@DataClassName("User")
class Users extends Table {
  TextColumn get id => text().customConstraint("UNIQUE")();

  TextColumn get name => text().customConstraint("UNIQUE")();

  TextColumn get password => text()();

  TextColumn get role => text()();

  @override
  Set<Column> get primaryKey => {id};
}
