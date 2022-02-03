import 'package:drift/drift.dart';

class ProductAddons extends Table {
  TextColumn get id => text().customConstraint("UNIQUE")();

  TextColumn get productId => text().customConstraint(
      'NOT NULL REFERENCES products (id) ON DELETE CASCADE ON UPDATE CASCADE')();

  TextColumn get title => text()();

  IntColumn get price => integer()();
}
