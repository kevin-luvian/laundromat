import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/db/aggregates/plain_order_details.dart';
import 'package:laundry/db/dao/new_order_caches/new_order_cache.dart';
import 'package:laundry/db/dao/orders/orders.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/order_command.dart';

class SaveOrderBloc extends Bloc<SaveOrderEvent, SaveOrderState> {
  final OrderCommand _orderCommand;
  final OrdersDao _ordersDao;
  final SessionDao _sessionDao;
  final NewOrderCacheDao _newOrderCacheDao;

  SaveOrderBloc(DriftDB db, EventDB edb)
      : _orderCommand = OrderCommand(edb),
        _ordersDao = OrdersDao(edb),
        _sessionDao = SessionDao(db),
        _newOrderCacheDao = NewOrderCacheDao(db),
        super(InitialOrderState()) {
    on<SaveEvent>((event, emit) async {
      final products = await _newOrderCacheDao.allOrderDetails();
      assert(products.isNotEmpty);

      final staff = await _sessionDao.currentUserId;
      final taxRate = (await _sessionDao.find());
      final customerId =
          (await _newOrderCacheDao.getCustomerCache())?.customerId;
      final orderId = await _ordersDao.generateOrderId(DateTime.now());
      await _orderCommand.create(orderId, staff, customerId,
          products.map(OrderItem.fromProductOrderDetail).toList());
      emit(OrderSavedState());
    });
  }
}

abstract class SaveOrderEvent {}

class SaveEvent extends SaveOrderEvent {}

abstract class SaveOrderState extends Equatable {
  @override
  get props => [];
}

class InitialOrderState extends SaveOrderState {}

class OrderSavedState extends SaveOrderState {}
