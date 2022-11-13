import 'package:laundry/db/dao/customer/customer.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/dao/new_order_caches/new_order_cache.dart';
import 'package:laundry/db/dao/orders/orders.dart';
import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/dao/product/product_addon.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/running_assets/db_access.dart';

EventDao get eventDao => EventDao(eventDB);

ProductDao get productDao => ProductDao(driftDB);

ProductAddonDao get productAddonDao => ProductAddonDao(driftDB);

NewOrderCacheDao get newOrderCacheDao => NewOrderCacheDao(driftDB);

CustomerDao get customerDao => CustomerDao(driftDB);

SessionDao get sessionDao => SessionDao(driftDB);

OrdersDao get ordersDao => OrdersDao(eventDB);
