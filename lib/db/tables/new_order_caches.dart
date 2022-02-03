import 'package:drift/drift.dart';
import 'package:laundry/db/tables/product_addons.dart';
import 'package:laundry/db/tables/products.dart';

@DataClassName("NewOrderCache")
class NewOrderCaches extends Table {
  TextColumn get id =>
      text().customConstraint("UNIQUE").references(Products, #id)();

  IntColumn get amount => integer().withDefault(const Constant(1))();
}

class NewOrderCacheAddons extends Table {
  TextColumn get newOrderId => text().references(NewOrderCaches, #id)();

  TextColumn get addonId =>
      text().customConstraint("UNIQUE").references(ProductAddons, #id)();
}
