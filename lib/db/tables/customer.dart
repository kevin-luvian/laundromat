import 'package:drift/drift.dart';

class Customers extends Table {
  TextColumn get id => text().customConstraint("UNIQUE")();

  TextColumn get phone => text()();

  TextColumn get name => text()();
}
