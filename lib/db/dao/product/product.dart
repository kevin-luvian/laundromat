import 'dart:async';

import 'package:drift/drift.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/products.dart';

part 'product.g.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<DriftDB> with _$ProductDaoMixin {
  ProductDao(DriftDB db) : super(db);

  Future<int> create(Product product) => into(products).insert(product);

  Future<void> updateById(String id, ProductsCompanion info) =>
      (update(products)..where((p) => p.id.equals(id))).write(info);

  Future<bool> deleteById(String id) async =>
      await (delete(products)..where((p) => p.id.equals(id))).go() == 1;

  Future<List<Product>> all() => select(products).get();

  Stream<List<Product>> findAllByCategoryAsStream(String category) =>
      (select(products)..where((p) => p.category.equals(category))).watch();

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

  Stream<List<String>> distinctCategories() {
    final query = selectOnly(products, distinct: true)
      ..addColumns([products.category])
      ..orderBy([OrderingTerm(expression: products.category)]);
    return query.map((row) => row.read(products.category) ?? "").watch();
  }

  Stream<List<String>> distinctUnits() {
    final query = selectOnly(products, distinct: true)
      ..addColumns([products.unit])
      ..orderBy([OrderingTerm(expression: products.unit)]);
    return query.map((row) => row.read(products.unit) ?? "").watch();
  }
}
