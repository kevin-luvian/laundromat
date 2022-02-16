import 'package:drift/drift.dart';
import 'package:laundry/db/tables/product_addons.dart';
import 'package:laundry/db/tables/products.dart';

import 'customer.dart';

@DataClassName("NewOrderCache")
class NewOrderCaches extends Table {
  TextColumn get id =>
      text().customConstraint("UNIQUE").references(Products, #id)();

  RealColumn get amount => real().withDefault(const Constant(1))();
}

class NewOrderCacheAddons extends Table {
  TextColumn get newOrderId => text().references(NewOrderCaches, #id)();

  TextColumn get addonId =>
      text().customConstraint("UNIQUE").references(ProductAddons, #id)();
}

@DataClassName("CustomerCache")
class CustomerCaches extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get customerId =>
      text().customConstraint("UNIQUE").references(Customers, #id)();
}
