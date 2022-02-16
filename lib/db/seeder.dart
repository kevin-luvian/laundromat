import 'package:laundry/db/aggregates/plain_order_details.dart';
import 'package:laundry/db/tables/users.dart';
import 'package:laundry/event_source/commands/order_command.dart';
import 'package:laundry/event_source/commands/product_addon_command.dart';
import 'package:laundry/event_source/commands/product_command.dart';
import 'package:laundry/event_source/commands/user_command.dart';

import 'event_db.dart';

class Seeder {
  final EventDB edb;

  const Seeder(this.edb);

  Future<void> seed() async {
    final userCommand = UserCommand(edb);
    final userId = await userCommand.create(
      name: "admin",
      password: "password",
      role: roleSuperAdmin,
      pin: "0000",
    );

    final product1 = await createProduct1();
    createOrders(
      userId: userId,
      productId: product1[0],
      addonsIds: product1.sublist(1),
    );
  }

  Future<void> createOrders({
    required String userId,
    required String productId,
    required List<String> addonsIds,
  }) async {
    final orderCommand = OrderCommand(edb);
    DateTime now = DateTime.now();
    for (int i = 0; i < 50; i++) {
      now = now.add(const Duration(days: 1));
      orderCommand.mTempCreate(userId, null,
          [OrderItem(5000.0 * (1 + i), productId, addonsIds)], now);
    }
  }

  Future<List<String>> createProduct1() async {
    final productCommand = ProductCommand(edb);
    final addonCommand = ProductAddonCommand(edb);

    final productId = await productCommand.create(
      category: "socks",
      title: "The Socks",
      price: 9000,
      unit: "kg",
    );
    final ids = <String>[productId];
    for (int i = 0; i < 5; i++) {
      final addonId = await addonCommand.create(
        productId: productId,
        title: "addon$i",
        price: 500 * (i + 1),
      );
      ids.add(addonId);
    }
    return ids;
  }
}
