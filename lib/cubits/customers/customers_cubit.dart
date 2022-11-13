import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';

import 'filters/declare.dart';
import 'customers_filter_cubit.dart';

const LIMIT_SIZE = 10;

class CustomersState {
  final List<String> customers;
  final bool noMoreData;

  CustomersState(this.customers, this.noMoreData);
  factory CustomersState.initial() => CustomersState([], false);

  int get length => customers.length;
  bool get isEmpty => customers.isEmpty;
  String elementAt(int i) => customers.elementAt(i);
}

class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit(EventDB edb, DriftDB ddb, this._filtersCubit)
      : super(CustomersState.initial());

  late final List<StreamSubscription> _listeners;
  final CustomersFilterCubit _filtersCubit;
  List<Filter> filters = [];
  Iterable<String> _iterator = [];
  int _limit = LIMIT_SIZE;

  @override
  Future<void> close() async {
    await Future.wait(_listeners.map((l) => l.cancel()));
    return super.close();
  }

  void setup() {
    filters = _filtersCubit.state.filters;
    _listeners = [
      // _ordersDao.streamAllOrders().listen((data) => data.then((orders) async {
      //       _orders = orders;
      //       reEmit();
      //     })),
      _filtersCubit.stream.listen((data) {
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
    final all = _iterator.where(_filterValid);
    final trimmed = all.take(_limit).toList(growable: false);
    final noMoreData = all.length <= trimmed.length;
    emit(CustomersState(trimmed, noMoreData));
  }

  bool _filterValid(String s) {
    final data = FilterData(
      date: DateTime.now(),
      name: "",
      phone: "",
    );

    for (final f in filters) {
      if (!f.valid(data)) {
        return false;
      }
    }
    return true;
  }
}
