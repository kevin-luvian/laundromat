import 'package:drift/drift.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/new_order_caches.dart';

part 'new_order_cache.g.dart';

@DriftAccessor(tables: [NewOrderCaches])
class NewOrderCacheDao extends DatabaseAccessor<DriftDB>
    with _$NewOrderCacheDaoMixin {
  NewOrderCacheDao(DriftDB db) : super(db);

  Future<int> create(NewOrderCache data) => into(newOrderCaches).insert(data);

  Future<void> updateById(String id, NewOrderCachesCompanion info) =>
      (update(newOrderCaches)..where((p) => p.id.equals(id)))
          .write(info);
}
