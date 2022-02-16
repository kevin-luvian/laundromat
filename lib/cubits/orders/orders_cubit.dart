import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/db/aggregates/order_details.dart';
import 'package:laundry/db/dao/orders/orders.dart';
import 'package:laundry/db/event_db.dart';

import 'filters/declare.dart';
import 'orders_filter_cubit.dart';

const LIMIT_SIZE = 10;

class OrdersState {
  final List<OrderDetail> orders;
  final bool noMoreData;

  OrdersState(this.orders, this.noMoreData);

  factory OrdersState.initial() => OrdersState([], false);

  int get length => orders.length;

  OrderDetail elementAt(int i) => orders.elementAt(i);
}

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(EventDB edb, this._ordersFilterCubit)
      : _ordersDao = OrdersDao(edb),
        super(OrdersState.initial());

  late final List<StreamSubscription> _listeners;
  final OrdersFilterCubit _ordersFilterCubit;
  final OrdersDao _ordersDao;
  List<Filter> filters = [];
  Iterable<OrderDetail> _orders = [];
  int _limit = LIMIT_SIZE;

  @override
  Future<void> close() async {
    await Future.wait(_listeners.map((l) => l.cancel()));
    return super.close();
  }

  void setup() {
    _listeners = [
      _ordersDao.streamAllOrders().listen((data) => data.then((orders) {
            _orders = orders;
            reEmit();
          })),
      _ordersFilterCubit.stream.listen((data) {
        filters = data.filters;
        _limit = LIMIT_SIZE;
        reEmit();
      })
    ];
  }

  void loadMore(int toAdd) {
    _limit += toAdd;
    reEmit();
  }

  void reEmit() {
    final newOrders =
        _orders.where(_filterOrder).take(_limit).toList(growable: false);
    if (state.length == newOrders.length ||
        newOrders.length == _orders.length ||
        newOrders.length < LIMIT_SIZE) {
      emit(OrdersState(newOrders, true));
    } else {
      emit(OrdersState(newOrders, false));
    }
  }

  bool _filterOrder(OrderDetail order) {
    for (final f in filters) {
      if (!f.valid(order)) return false;
    }
    return true;
  }
}
