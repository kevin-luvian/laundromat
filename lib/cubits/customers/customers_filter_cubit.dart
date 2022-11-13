import 'package:flutter_bloc/flutter_bloc.dart';
import 'filters/filter_search.dart';
import 'filters/declare.dart';
import 'filters/filter_date.dart';

class CustomersFilterCubit extends Cubit<CustomersFiltersState> {
  CustomersFilterCubit() : super(CustomersFiltersState.initial());

  void clearFilters() => emit(CustomersFiltersState.initial());

  DateTime? get firstDate => state.filterDate.firstDate;
  DateTime? get lastDate => state.filterDate.lastDate;

  void modifyDate(DateTime? firstDate, DateTime? lastDate) {
    emit(state.modify(filterDate: FilterDate(firstDate, lastDate)));
  }

  String? get searchName => state.filterSearch.customerName;
  String? get searchPhone => state.filterSearch.customerPhone;

  void modifySearch(String? name, String? phone) {
    emit(state.modify(
      filterSearch: FilterSearch(customerName: name, customerPhone: phone),
    ));
  }
}

class CustomersFiltersState {
  final FilterDate filterDate;
  final FilterSearch filterSearch;

  CustomersFiltersState({
    required this.filterDate,
    required this.filterSearch,
  });

  CustomersFiltersState modify({
    FilterDate? filterDate,
    FilterSearch? filterSearch,
  }) =>
      CustomersFiltersState(
        filterDate: filterDate ?? this.filterDate,
        filterSearch: filterSearch ?? this.filterSearch,
      );

  factory CustomersFiltersState.initial() => CustomersFiltersState(
        filterDate: FilterDate.empty(),
        filterSearch: FilterSearch.empty(),
      );

  List<Filter> get filters => [filterDate, filterSearch];
}
