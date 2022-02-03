import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/dao/product/product_addon.dart';
import 'package:laundry/running_assets/db_access.dart';

ProductDao get productDao => ProductDao(driftDB);
ProductAddonDao get productAddonDao => ProductAddonDao(driftDB);
