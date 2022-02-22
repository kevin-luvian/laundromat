import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/db/aggregates/order_details.dart';
import 'package:laundry/db/dao/orders/orders.dart';

import '../right_drawer.dart';

class OrderDrawerCubit extends Cubit<OrderDetail?> {
  OrderDrawerCubit(this._ordersDao, this._rCubit) : super(null);

  final RightDrawerCubit _rCubit;
  final OrdersDao _ordersDao;

  void open(String streamId) async {
    final order = await _ordersDao.findById(streamId);
    _rCubit.showDrawer();
    emit(order);
  }

  void closeDrawer() {
    _rCubit.closeDrawer();
  }
}
