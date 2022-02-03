import 'package:drift/drift.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/product_addons.dart';

@DriftAccessor(tables: [ProductAddons])
class ProductAddonDao extends DatabaseAccessor<DriftDB> {
  ProductAddonDao(DriftDB db) : super(db);

  $ProductAddonsTable get productAddons => attachedDatabase.productAddons;

  Future<List<ProductAddon>> findAllByProductId(String productId) =>
      (select(productAddons)..where((p) => p.productId.equals(productId)))
          .get();

  Future<void> create(ProductAddon productAddon) =>
      into(productAddons).insert(productAddon);

  Future<void> updateById(String id, ProductAddonsCompanion info) =>
      (update(productAddons)..where((p) => p.id.equals(id))).write(info);

  Future<bool> deleteById(String id) async =>
      await (delete(productAddons)..where((p) => p.id.equals(id))).go() == 1;

  Future<void> deleteByProductId(String productId) =>
      (delete(productAddons)..where((p) => p.productId.equals(productId))).go();
}
