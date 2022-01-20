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

  Future<List<Product>> all() => select(products).get();

  Stream<List<Product>> findAllByCategoryAsStream(String category) =>
      (select(products)..where((p) => p.category.equals(category))).watch();

  Future<Product?> findById(String id) =>
      (select(products)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Stream<Product?> streamById(String id) =>
      (select(products)..where((p) => p.id.equals(id))).watchSingleOrNull();

  void updateImageAsync(String id, String path) {
    final productStream = streamById(id);
    late StreamSubscription listener;
    listener = productStream.listen((p) async {
      if (p != null) {
        updateById(id, ProductsCompanion(imagePath: Value(path)));
        listener.cancel();
      }
    });
  }

  Stream<List<String>> distinctCategories() {
    final query = selectOnly(products, distinct: true)
      ..addColumns([products.category]);
    return query.map((row) => row.read(products.category) ?? "").watch();
  }
}
