import 'package:drift/drift.dart';
import 'package:laundry/db/tables/users.dart';

class Customers extends Table {
  TextColumn get id => text().customConstraint("UNIQUE")();

  TextColumn get phone => text()();

  TextColumn get name => text()();

  TextColumn get lastEditorId => text().references(Users, #id)();
}
