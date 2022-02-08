import 'package:drift/drift.dart';
import 'package:laundry/db/dao/customer.dart';
import 'package:laundry/db/dao/new_order_caches/new_order_cache.dart';
import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/tables/customer.dart';
import 'package:laundry/db/tables/new_order_caches.dart';
import 'package:laundry/db/tables/product_addons.dart';
import 'package:laundry/db/tables/products.dart';
import 'package:laundry/db/tables/sessions.dart';
import 'package:laundry/db/tables/users.dart';

part 'drift_db.g.dart';

const tables = [
  Users,
  Customers,
  Sessions,
  Products,
  ProductAddons,
  NewOrderCaches,
  NewOrderCacheAddons,
];
const daos = [
  UserDao,
  CustomerDao,
  SessionDao,
  ProductDao,
  NewOrderCacheDao,
];

@DriftDatabase(tables: tables, daos: daos)
class DriftDB extends _$DriftDB {
  DriftDB(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  Future<void> open() async {
    await (select(sessions)..where((tbl) => tbl.id.equals(1))).get();
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          if (details.wasCreated) {}
          // await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
