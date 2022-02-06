import 'package:drift/native.dart';
import 'package:laundry/db/dao/new_order_caches/new_order_cache.dart';
import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/dao/product/product_addon.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  late DriftDB ddb;
  late NewOrderCacheDao _nocDao;
  late ProductDao _pDao;
  late ProductAddonDao _paDao;
  const productId = "abc";
  const addonIds = ["123", "456", "789"];

  setUp(() async {
    ddb = DriftDB(NativeDatabase.memory());
    _nocDao = NewOrderCacheDao(ddb);
    _pDao = ProductDao(ddb);
    _paDao = ProductAddonDao(ddb);

    await _pDao.create(Product(
      id: productId,
      title: "abc",
      category: "category",
      price: 0,
      unit: "unit",
    ));
    await Future.wait(addonIds.map((id) => _paDao.create(ProductAddon(
          id: id,
          productId: productId,
          title: "abc",
          price: 15,
        ))));
  });

  tearDown(() async {
    await ddb.close();
  });

  Future<void> createBlankOrder(String id) async {
    await _pDao.create(
      Product(id: id, title: "", category: "", price: 0, unit: ""),
    );
    await _nocDao.create(NewOrderCache(id: id, amount: 5), []);
  }

  test('get new order cache', () async {
    final noc = NewOrderCache(id: productId, amount: 5);
    await _nocDao.create(noc, []);

    final stream = _nocDao.streamOrderDetails();
    stream.listen(logger.d);
    // expect(
    //   stream.map((o) => o.length),
    //   emitsInOrder([2, 2, 3]),
    // );

    await Future.delayed(const Duration(milliseconds: 200));
  });
}
