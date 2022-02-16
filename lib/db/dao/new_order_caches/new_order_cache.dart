import 'package:drift/drift.dart';
import 'package:laundry/db/aggregates/product_order_details.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/customer.dart';
import 'package:laundry/db/tables/new_order_caches.dart';
import 'package:laundry/db/tables/product_addons.dart';
import 'package:laundry/db/tables/products.dart';

part 'new_order_cache.g.dart';

const _customerCacheId = 10;

@DriftAccessor(tables: [
  NewOrderCaches,
  NewOrderCacheAddons,
  CustomerCaches,
  Customers,
  Products,
  ProductAddons
])
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
    await delete(customerCaches).go();
  }

  Future<CustomerCache?> getCustomerCache() =>
      (select(customerCaches)..where((tbl) => tbl.id.equals(_customerCacheId)))
          .getSingleOrNull();

  Future<Customer?> get currentCustomer async {
    final query = (select(customerCaches)
          ..where((tbl) => tbl.id.equals(_customerCacheId)))
        .join([
      innerJoin(customers, customers.id.equalsExp(customerCaches.customerId)),
    ]);
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return row.readTableOrNull(customers);
  }

  Future<void> changeCustomer(String customerId) async {
    final isCustomerExist = (await getCustomerCache()) != null;
    if (isCustomerExist) {
      await (update(customerCaches)
            ..where((o) => o.id.equals(_customerCacheId)))
          .write(CustomerCachesCompanion(customerId: Value(customerId)));
    } else {
      await into(customerCaches).insert(CustomerCache(
        id: _customerCacheId,
        customerId: customerId,
      ));
    }
  }

  Future<void> removeCustomer() async {
    await delete(customerCaches).go();
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

  Stream<int> streamOrdersLength() {
    final counts = countAll();
    final query = select(newOrderCaches).addColumns([counts]).map((row) {
      return row.read(counts);
    });
    return query.watchSingle();
  }

  Stream<List<ProductOrderDetail>> streamOrderDetails() {
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

  Future<List<String>> allOrderIds() =>
      select(newOrderCaches).map((order) => order.id).get();

  Future<List<ProductOrderDetail>> allOrderDetails() async {
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

  List<ProductOrderDetail> rowsToOrderDetail(List<TypedResult> rows) {
    final groupedData = <String, ProductOrderDetail>{};
    for (final row in rows) {
      final newOrder = row.readTable(newOrderCaches);
      final product = row.readTable(products);
      final addon = row.readTableOrNull(productAddons);

      final oDetail = groupedData.putIfAbsent(
        product.id,
        () => ProductOrderDetail(product, [], newOrder.amount),
      );
      if (addon != null) oDetail.addons.add(addon);
    }
    final List<ProductOrderDetail> orderDetails = [];
    groupedData.forEach((_, data) => orderDetails.add(data));
    return orderDetails;
  }
}
