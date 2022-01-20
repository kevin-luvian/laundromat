import 'package:drift/drift.dart';

class Products extends Table {
  TextColumn get id => text().customConstraint("UNIQUE")();

  TextColumn get title => text().withLength(max: 50)();

  TextColumn get category => text()();

  IntColumn get price => integer()();

  TextColumn get unit => text()();

  TextColumn get imagePath => text().nullable()();
}
