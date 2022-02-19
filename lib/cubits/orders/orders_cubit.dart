import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/db/aggregates/order_details.dart';
import 'package:laundry/db/dao/orders/orders.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/order_command.dart';
import 'package:laundry/helpers/utils.dart';

import 'filters/declare.dart';
import 'orders_filter_cubit.dart';

const LIMIT_SIZE = 10;

class OrdersState {
  final List<OrderDetail> orders;
  final bool noMoreData;

  OrdersState(this.orders, this.noMoreData);

  factory OrdersState.initial() => OrdersState([], false);

  int get length => orders.length;

  bool get isEmpty => orders.isEmpty;

  OrderDetail elementAt(int i) => orders.elementAt(i);
}

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(EventDB edb, DriftDB ddb, this._ordersFilterCubit)
      : _sessionDao = SessionDao(ddb),
        _ordersDao = OrdersDao(edb),
        _orderCommand = OrderCommand(edb),
        super(OrdersState.initial());

  late final List<StreamSubscription> _listeners;
  final OrdersFilterCubit _ordersFilterCubit;
  final SessionDao _sessionDao;
  final OrdersDao _ordersDao;
  final OrderCommand _orderCommand;
  List<Filter> filters = [];
  Iterable<OrderDetail> _orders = [];
  int _limit = LIMIT_SIZE;

  @override
  Future<void> close() async {
    await Future.wait(_listeners.map((l) => l.cancel()));
    return super.close();
  }

  void setup() {
    filters = _ordersFilterCubit.state.filters;
    _listeners = [
      _ordersDao.streamAllOrders().listen((data) => data.then((orders) async {
            // logger.i("Streamed");
            emit(OrdersState.initial());
            _orders = orders;
            await waitMilliseconds(500);
            reEmit();
          })),
      _ordersFilterCubit.stream.listen((data) {
        filters = data.filters;
        _limit = LIMIT_SIZE;
        reEmit();
      })
    ];
  }

  Future<void> remove(String streamId) async {
    final userId = await _sessionDao.currentUserId;
    await _orderCommand.remove(streamId, userId);
    reEmit();
  }

  void loadMore(int toAdd) {
    _limit += toAdd;
    reEmit();
  }

  void reEmit() {
    final newOrders = _orders.where(_filterOrder);
    final newOrdersList = newOrders.take(_limit).toList(growable: false);
    final noMoreData = newOrders.length == newOrdersList.length;
    emit(OrdersState(newOrdersList, noMoreData));
  }

  bool _filterOrder(OrderDetail order) {
    for (final f in filters) {
      if (!f.valid(order)) return false;
    }
    return true;
  }
}
