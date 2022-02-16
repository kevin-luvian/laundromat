import 'package:drift/drift.dart';
import 'package:laundry/db/aggregates/order_details.dart';
import 'package:laundry/db/aggregates/plain_order_details.dart';
import 'package:laundry/db/aggregates/product_order_details.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/db/tables/events.dart';
import 'package:laundry/event_source/events/order_event.dart';
import 'package:laundry/event_source/projectors/customer_projector.dart';
import 'package:laundry/event_source/projectors/order_details_projector.dart';
import 'package:laundry/event_source/projectors/product_aggregate_projector.dart';
import 'package:laundry/event_source/projectors/user_projector.dart';

@DriftAccessor(tables: [Events])
class OrdersDao extends DatabaseAccessor<EventDB> {
  OrdersDao(EventDB db)
      : _eventDao = EventDao(db),
        super(db);

  final EventDao _eventDao;

  $EventsTable get events => attachedDatabase.events;

  Future<List<String>> findAllOrdersIds() =>
      _eventDao.distinctIdByType(orderEventType);

  Stream<Future<List<OrderDetail>>> streamAllOrders() {
    final stream = _eventDao.streamByType(orderEventType);

    return stream.map((eMap) async {
      List<Future<OrderDetail>> futures = [];
      for (final events in eMap.values) {
        final data = OrderDetailsProjector.projectStatic(events);
        if (data != null) futures.add(getOrderDetail(data));
      }
      return await Future.wait(futures);
    });
  }

  Future<User?> findUserWhen(String userId, DateTime date) async {
    final events = await _eventDao.findAllByIdConstrainedByDate(userId, date);
    if (events.isEmpty) return null;
    return UserProjector.projectUsers(events);
  }

  Future<OrderDetail> getOrderDetail(PlainOrderDetail detail) async {
    final data = await _getOrderData(
      staffId: detail.userId,
      createDate: detail.createDate,
      customerId: detail.customerId,
      items: detail.items,
    );
    return OrderDetail(
      streamId: detail.streamId,
      user: data.user,
      customer: data.customer,
      orders: data.products,
      createDate: detail.createDate,
      checkoutDate: detail.checkoutDate,
      removedDate: detail.removedDate,
    );
  }

  Future<_OrderData> _getOrderData({
    required String staffId,
    required DateTime createDate,
    String? customerId,
    List<OrderItem>? items,
  }) async {
    late User staff;
    Customer? customer;
    List<ProductOrderDetail> pods = [];

    Future<void> getStaff() async {
      final events =
          await _eventDao.findAllByIdConstrainedByDate(staffId, createDate);
      staff = UserProjector.projectUsers(events)!;
    }

    Future<void> getCustomer() async {
      if (customerId == null) return;
      final events =
          await _eventDao.findAllByIdConstrainedByDate(customerId, createDate);
      customer = CustomerProjector.projectStatic(events);
    }

    Future<ProductOrderDetail?> getProductOrderDetail(OrderItem detail) async {
      final productEvents = await _eventDao.findAllByIdConstrainedByDate(
          detail.productId, createDate);
      final product = ProductStaticProjector.projectStatic(productEvents);
      if (product == null) return null;

      final addonsEvents = await _eventDao.findAllByIdsConstrainedByDate(
          detail.addonIds, createDate);
      final addons = AddonStaticProjector.projectManyStatic(addonsEvents);

      return ProductOrderDetail(product, addons, detail.amount);
    }

    Future<void> getAllProductOrderDetails() async {
      if (items == null) return;
      final data = await Future.wait(items.map(getProductOrderDetail));
      for (final pod in data) {
        if (pod != null) pods.add(pod);
      }
    }

    await Future.wait<void>(
        [getStaff(), getCustomer(), getAllProductOrderDetails()]);

    return _OrderData(user: staff, customer: customer, products: pods);
  }
}

class _OrderData {
  final User user;
  final Customer? customer;
  final List<ProductOrderDetail> products;

  _OrderData({required this.user, this.customer, required this.products});
}
