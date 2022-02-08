import 'package:drift/drift.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/new_order_caches.dart';
import 'package:laundry/db/tables/product_addons.dart';
import 'package:laundry/db/tables/products.dart';
import 'package:laundry/helpers/utils.dart';

part 'new_order_cache.g.dart';

@DriftAccessor(
    tables: [NewOrderCaches, NewOrderCacheAddons, Products, ProductAddons])
class NewOrderCacheDao extends DatabaseAccessor<DriftDB>
    with _$NewOrderCacheDaoMixin {
  NewOrderCacheDao(DriftDB db) : super(db);

  Future<void> create(
      NewOrderCache newOrderCache, List<String> addonIds) async {
    await into(newOrderCaches).insert(newOrderCache);
    final futures = addonIds.map(
      (addonId) => into(newOrderCacheAddons).insert(NewOrderCacheAddon(
        newOrderId: newOrderCache.id,
        addonId: addonId,
      )),
    );
    await Future.wait(futures);
  }

  Future<void> updateById(String id, NewOrderCachesCompanion info) =>
      (update(newOrderCaches)..where((o) => o.id.equals(id))).write(info);

  Future<void> deleteById(String id) async {
    await (delete(newOrderCaches)..where((o) => o.id.equals(id))).go();
    await (delete(newOrderCacheAddons)..where((o) => o.newOrderId.equals(id)))
        .go();
  }

  Future<void> deleteAll() async {
    await delete(newOrderCaches).go();
    await delete(newOrderCacheAddons).go();
  }

  Future<NewOrderCache?> findById(String id) =>
      (select(newOrderCaches)..where((o) => o.id.equals(id))).getSingleOrNull();

  Future<List<ProductAddon>> findSelectedAddons(String productId) async {
    final query = (select(newOrderCacheAddons)
          ..where((o) => o.newOrderId.equals(productId)))
        .join([
      innerJoin(
        productAddons,
        productAddons.id.equalsExp(newOrderCacheAddons.addonId),
      )
    ]);
    final rows = await query.get();
    return rows.map((row) => row.readTable(productAddons)).toList();
  }

  Stream<List<OrderDetail>> streamOrderDetails() {
    final query = select(newOrderCaches).join([
      innerJoin(products, products.id.equalsExp(newOrderCaches.id)),
      leftOuterJoin(
        newOrderCacheAddons,
        newOrderCacheAddons.newOrderId.equalsExp(newOrderCaches.id),
        useColumns: false,
      ),
      leftOuterJoin(
        productAddons,
        productAddons.id.equalsExp(newOrderCacheAddons.addonId),
      )
    ])
      ..orderBy([OrderingTerm(expression: products.title)]);

    return query.watch().map(rowsToOrderDetail);
  }

  Future<List<OrderDetail>> allOrderDetails() async {
    final query = select(newOrderCaches).join([
      innerJoin(products, products.id.equalsExp(newOrderCaches.id)),
      leftOuterJoin(
        newOrderCacheAddons,
        newOrderCacheAddons.newOrderId.equalsExp(newOrderCaches.id),
        useColumns: false,
      ),
      leftOuterJoin(
        productAddons,
        productAddons.id.equalsExp(newOrderCacheAddons.addonId),
      )
    ])
      ..orderBy([OrderingTerm(expression: products.title)]);

    return rowsToOrderDetail(await query.get());
  }

  List<OrderDetail> rowsToOrderDetail(List<TypedResult> rows) {
    final groupedData = <String, OrderDetail>{};
    for (final row in rows) {
      final newOrder = row.readTable(newOrderCaches);
      final product = row.readTable(products);
      final addon = row.readTableOrNull(productAddons);

      final oDetail = groupedData.putIfAbsent(
        product.id,
        () => OrderDetail(product, [], newOrder.amount),
      );
      if (addon != null) oDetail.addons.add(addon);
    }
    final List<OrderDetail> orderDetails = [];
    groupedData.forEach((_, data) => orderDetails.add(data));
    return orderDetails;
  }
}

class OrderDetail {
  OrderDetail(this.product, this.addons, this.amount);

  final Product product;
  final List<ProductAddon> addons;
  final double amount;

  int get totalPrice {
    double total = product.price.toDouble();
    if (addons.isNotEmpty) {
      final addonsPrices = addons.map((a) => a.price).reduce((t, p) => t + p);
      total += addonsPrices.toDouble();
    }
    total *= amount;
    return total.toInt();
  }

  String get amountStr => doubleToString(amount);

  @override
  toString() {
    return '''amount: $amount, product: ${product.toString()}, addons: ${addons.toString()}''';
  }
}
