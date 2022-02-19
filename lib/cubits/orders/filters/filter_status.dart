import 'package:equatable/equatable.dart';
import 'package:laundry/cubits/orders/filters/declare.dart';

class FilterStatus extends Equatable implements Filter {
  const FilterStatus(this.sent, this.waiting, this.deleted);

  factory FilterStatus.empty() => const FilterStatus(true, true, false);

  final bool sent;
  final bool waiting;
  final bool deleted;

  @override
  bool get hasValue => this != FilterStatus.empty();

  FilterStatus modify({bool? sent, bool? waiting, bool? deleted}) =>
      FilterStatus(
          sent ?? this.sent, waiting ?? this.waiting, deleted ?? this.deleted);

  @override
  valid(order) {
    final isCheckedOut = order.checkoutDate != null;
    final isRemoved = order.removedDate != null;
    if (!deleted && isRemoved) return false;
    return (sent && isCheckedOut) ||
        (waiting && !isCheckedOut) ||
        (deleted && isRemoved);
  }

  @override
  get props => [sent, waiting, deleted];
}
