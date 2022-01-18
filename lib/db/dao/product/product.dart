import 'package:drift/drift.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/products.dart';

part 'product.g.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<DriftDB> with _$ProductDaoMixin {
  ProductDao(DriftDB db) : super(db);

  Future<int> create(Product product) => into(products).insert(product);

  Future<List<Product>> all() => select(products).get();

  Future<Product?> findById(String id) =>
      (select(products)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Stream<Product?> streamById(String id) =>
      (select(products)..where((p) => p.id.equals(id))).watchSingleOrNull();
}
