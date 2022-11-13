import 'package:equatable/equatable.dart';
import 'declare.dart';

class FilterSearch extends Equatable implements Filter {
  const FilterSearch({
    required this.customerName,
    required this.customerPhone,
  });

  factory FilterSearch.empty() =>
      const FilterSearch(customerName: null, customerPhone: null);

  final String? customerName;
  final String? customerPhone;

  @override
  bool get hasValue => this != FilterSearch.empty();

  FilterSearch modify({
    String? customerName,
    String? customerPhone,
  }) =>
      FilterSearch(
        customerName: _setText(customerName, this.customerName),
        customerPhone: _setText(customerPhone, this.customerPhone),
      );

  @override
  get props => [customerName, customerPhone];

  static String? _setText(String? val, String? prev) {
    if (val == null) return prev;
    return val.trim().isEmpty ? null : val;
  }

  @override
  bool valid(FilterData data) {
    var isValid = true;
    if (customerName != null) {
      isValid = isValid && data.name.contains(customerName ?? "");
    }
    if (customerPhone != null) {
      isValid = isValid && data.phone.contains(customerPhone ?? "");
    }
    return isValid;
  }
}
