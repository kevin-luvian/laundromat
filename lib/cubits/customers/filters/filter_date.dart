import 'package:equatable/equatable.dart';
import 'declare.dart';

class FilterDate extends Equatable implements Filter {
  FilterDate(this.firstDate, this.lastDate)
      : assert(FilterDate.check(firstDate, lastDate));

  factory FilterDate.empty() {
    DateTime date = DateTime.now();
    date = DateTime(date.year, date.month, date.day);
    return FilterDate(null, date);
  }

  final DateTime? firstDate;
  final DateTime? lastDate;

  static bool check(DateTime? firstDate, DateTime? lastDate) {
    if (firstDate == null || lastDate == null) {
      return true;
    } else {
      return firstDate.compareTo(lastDate) <= 0;
    }
  }

  @override
  bool get hasValue => this != FilterDate.empty();

  DateTime setHour(DateTime date, int hour) {
    assert(hour >= 0 && hour <= 24);
    return DateTime(date.year, date.month, date.day, hour);
  }

  @override
  get props => [firstDate, lastDate];

  @override
  bool valid(FilterData data) {
    var isValid = true;
    if (firstDate != null) {
      isValid = isValid && setHour(firstDate!, 0).compareTo(data.date) <= 0;
    }
    if (lastDate != null) {
      isValid = isValid && setHour(lastDate!, 24).compareTo(data.date) >= 0;
    }
    return isValid;
  }
}
