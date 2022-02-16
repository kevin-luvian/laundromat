import 'package:flutter_bloc/flutter_bloc.dart';

import 'filters/declare.dart';
import 'filters/filter_date.dart';
import 'filters/filter_names.dart';
import 'filters/filter_status.dart';

class OrdersFilterCubit extends Cubit<OrdersFiltersState> {
  OrdersFilterCubit() : super(OrdersFiltersState.initial());

  void modifyNames({String? customerName, String? staffName}) {
    emit(
      state.modify(
          filterNames: state.filterNames
              .modify(customerName: customerName, staffName: staffName)),
    );
  }

  void modifyStatuses({bool? sent, bool? waiting, bool? deleted}) {
    emit(
      state.modify(
          filterStatus: state.filterStatus
              .modify(sent: sent, waiting: waiting, deleted: deleted)),
    );
  }

  void modifyDate(DateTime? firstDate, DateTime? lastDate) {
    emit(state.modify(filterDate: FilterDate(firstDate, lastDate)));
  }

  void clearFilters() => emit(OrdersFiltersState.initial());

  DateTime? get firstDate => state.filterDate.firstDate;

  DateTime? get lastDate => state.filterDate.lastDate;

  String? get staffName => state.filterNames.staffName;

  String? get customerName => state.filterNames.customerName;

  FilterStatus get statuses => state.filterStatus;
}

class OrdersFiltersState {
  final FilterDate filterDate;
  final FilterNames filterNames;
  final FilterStatus filterStatus;

  OrdersFiltersState({
    required this.filterDate,
    required this.filterNames,
    required this.filterStatus,
  });

  OrdersFiltersState modify({
    FilterDate? filterDate,
    FilterNames? filterNames,
    FilterStatus? filterStatus,
  }) =>
      OrdersFiltersState(
        filterDate: filterDate ?? this.filterDate,
        filterNames: filterNames ?? this.filterNames,
        filterStatus: filterStatus ?? this.filterStatus,
      );

  factory OrdersFiltersState.initial() => OrdersFiltersState(
        filterDate: FilterDate.empty(),
        filterNames: FilterNames.empty(),
        filterStatus: FilterStatus.empty(),
      );

  List<Filter> get filters => [filterDate, filterNames, filterStatus];
}
