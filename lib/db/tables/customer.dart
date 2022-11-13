import 'package:drift/drift.dart';
import 'package:laundry/db/tables/users.dart';

const int STATUS_ACTIVE = 0;
const int STATUS_DELETED = 1;

class Customers extends Table {
  TextColumn get id => text().customConstraint("UNIQUE")();
  TextColumn get phone => text()();
  TextColumn get name => text()();
  IntColumn get status => integer()();
  TextColumn get lastEditorId => text().references(Users, #id)();
}
