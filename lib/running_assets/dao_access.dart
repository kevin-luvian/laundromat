import 'package:laundry/db/dao/new_order_caches/new_order_cache.dart';
import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/dao/product/product_addon.dart';
import 'package:laundry/running_assets/db_access.dart';

ProductDao get productDao => ProductDao(driftDB);

ProductAddonDao get productAddonDao => ProductAddonDao(driftDB);

NewOrderCacheDao get newOrderCacheDao => NewOrderCacheDao(driftDB);
