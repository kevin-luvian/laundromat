import 'package:drift/native.dart';
import 'package:laundry/db/aggregates/plain_order_details.dart';
import 'package:laundry/db/dao/customer.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/dao/orders/orders.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/db/tables/users.dart';
import 'package:laundry/event_source/commands/customer_command.dart';
import 'package:laundry/event_source/commands/order_command.dart';
import 'package:laundry/event_source/commands/product_addon_command.dart';
import 'package:laundry/event_source/commands/product_command.dart';
import 'package:laundry/event_source/commands/user_command.dart';
import 'package:laundry/event_source/events/user_event.dart';
import 'package:laundry/event_source/projectors/projector_listeners.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class _SetupData {
  final String staffId;
  final String customerId;
  final String productId;
  final String addonId;

  _SetupData({
    required this.staffId,
    required this.customerId,
    required this.productId,
    required this.addonId,
  });

  @override
  toString() =>
      "staffId: $staffId, \ncustomerId: $customerId, \nproductId: $productId";
}

void main() {
  late DriftDB ddb;
  late EventDB edb;
  late OrdersDao _ordersDao;
  late OrderCommand _orderCommand;
  late ProjectorListeners listeners;

  setUp(() async {
    edb = EventDB(NativeDatabase.memory());
    ddb = DriftDB(NativeDatabase.memory());
    _ordersDao = OrdersDao(edb);
    _orderCommand = OrderCommand(edb);
    listeners = ProjectorListeners(ddb)..setup();

    await edb.delete(edb.events).go();
    expect((await EventDao(edb).allEvents()).length, equals(0));
  });

  tearDown(() async {
    await edb.close();
    await ddb.close();
    await listeners.dispose();
  });

  Future<_SetupData> setupData() async {
    final staffId = await UserCommand(edb)
        .create(name: "name", password: "pass", role: roleStaff, pin: "1239");
    final customerId = await CustomerCommand(edb, CustomerDao(ddb))
        .create(staffId, "01832", "bob");
    final productId = await ProductCommand(edb)
        .create(category: "abc", title: "asd", price: 12312, unit: "kg");
    final addonId = await ProductAddonCommand(edb)
        .create(productId: productId, title: "bruhh", price: 12412);
    return _SetupData(
      staffId: staffId,
      customerId: customerId!,
      productId: productId,
      addonId: addonId,
    );
  }

  test('find users events', () async {
    final eventDao = EventDao(edb);
    final currDate = DateTime.now();
    final userCommand = UserCommand(edb);
    final staffId = await userCommand.create(
        name: "name", password: "pass", role: roleStaff, pin: "1239");
    userCommand.update(streamId: staffId, updatedBy: staffId, name: "bruhh");

    await waitMilliseconds(500);
    final data = await eventDao.findAllByIdConstrainedByDate(staffId, currDate);
    expect(data.length, 2);
    expect(data.map((u) => u.tag), [
      UserCreated.staticTag,
      UserUpdated.staticTag,
    ]);

    final user = await _ordersDao.findUserWhen(staffId, currDate);
    expect(user, isNotNull);
    expect(user!.name, "bruhh");
  });

  test('get all orders', () async {
    final data = await setupData();

    final order1 = await _orderCommand.create(data.staffId, data.customerId, [
      OrderItem(10, data.productId, []),
    ]);

    final order2 = await _orderCommand.create(data.staffId, data.customerId, [
      OrderItem(10, data.productId, [data.addonId]),
    ]);

    final ordersIds = await _ordersDao.findAllOrdersIds();
    expect(ordersIds.length, 2);
    expect(ordersIds, [order1, order2]);

    final stream = _ordersDao.streamAllOrders();
    stream.listen((o) => o.then((d) => d.forEach(logger.i)));

    await waitMilliseconds(500);
  });
}
