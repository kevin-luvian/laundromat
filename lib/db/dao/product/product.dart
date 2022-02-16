import 'dart:async';

import 'package:drift/drift.dart';
import 'package:laundry/db/aggregates/product_order_details.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/product_addons.dart';
import 'package:laundry/db/tables/products.dart';

@DriftAccessor(tables: [Products, ProductAddons])
class ProductDao extends DatabaseAccessor<DriftDB> {
  ProductDao(DriftDB db) : super(db);

  $ProductsTable get products => attachedDatabase.products;

  $ProductAddonsTable get productAddons => attachedDatabase.productAddons;

  Future<void> create(Product product) => into(products).insert(product);

  Future<void> updateById(String id, ProductsCompanion info) =>
      (update(products)..where((p) => p.id.equals(id))).write(info);

  Future<bool> deleteById(String id) async =>
      await (delete(products)..where((p) => p.id.equals(id))).go() == 1;

  Future<List<Product>> all() => select(products).get();

  Stream<List<Product>> findAllByCategoryAsStream(String category) =>
      (select(products)..where((p) => p.category.equals(category))).watch();

  Future<List<Product>> findAll() => select(products).get();

  Future<Product?> findById(String id) =>
      (select(products)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Stream<Product?> streamById(String id) =>
      (select(products)..where((p) => p.id.equals(id))).watchSingleOrNull();

  Future<void> updateImageSync(String id, String path) async {
    await for (final product in streamById(id)) {
      if (product != null) {
        await updateById(id, ProductsCompanion(imagePath: Value(path)));
        return;
      }
    }
  }

  Stream<List<String>> get distinctCategories {
    final query = selectOnly(products, distinct: true)
      ..addColumns([products.category])
      ..orderBy([OrderingTerm(expression: products.category)]);
    return query.map((row) => row.read(products.category) ?? "").watch();
  }

  Stream<List<String>> get distinctUnits {
    final query = selectOnly(products, distinct: true)
      ..addColumns([products.unit])
      ..orderBy([OrderingTerm(expression: products.unit)]);
    return query.map((row) => row.read(products.unit) ?? "").watch();
  }

  Future<ProductOrderDetail> findProductOrderDetail(
      String productId, List<String> addonsIds, double amount) async {
    final query =
        (select(products)..where((tbl) => tbl.id.equals(productId))).join([
      leftOuterJoin(productAddons, productAddons.id.isIn(addonsIds)),
    ]);

    final rows = await query.get();
    return _rowsToProductOrderDetail(rows, amount);
  }

  ProductOrderDetail _rowsToProductOrderDetail(
      List<TypedResult> rows, double amount) {
    late Product product;
    final List<ProductAddon> addons = [];
    for (int i = 0; i < rows.length; i++) {
      if (i == 0) {
        product = rows[i].readTable(products);
      }
      final addon = rows[i].readTableOrNull(productAddons);
      if (addon != null) {
        addons.add(addon);
      }
    }
    return ProductOrderDetail(product, addons, amount);
  }
}
