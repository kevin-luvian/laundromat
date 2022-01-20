import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/running_assets/db_access.dart';

ProductDao get productDao => ProductDao(driftDB);
