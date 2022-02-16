import 'package:equatable/equatable.dart';
import 'package:laundry/cubits/orders/filters/declare.dart';

class FilterNames extends Equatable implements Filter {
  const FilterNames({
    required this.customerName,
    required this.staffName,
  });

  factory FilterNames.empty() =>
      const FilterNames(customerName: null, staffName: null);

  final String? customerName;
  final String? staffName;

  @override
  bool get hasValue => this != FilterNames.empty();

  @override
  valid(order) {
    bool isValid = true;
    if (customerName != null) {
      if (order.customer == null) return false;
      isValid = isValid && order.customer!.name.contains(customerName!);
    }
    isValid = isValid && order.user.name.contains(staffName ?? "");
    return isValid;
  }

  FilterNames modify({
    String? customerName,
    String? staffName,
  }) =>
      FilterNames(
        customerName: _setText(customerName, this.customerName),
        staffName: _setText(staffName, this.staffName),
      );

  static String? _setText(String? val, String? prev) {
    if (val == null) return prev;
    return val.trim().isEmpty ? null : val;
  }

  @override
  get props => [customerName, staffName];
}
