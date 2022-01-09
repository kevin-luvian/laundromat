import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

formatPrice(double value) {
  return NumberFormat("#,###", "id").format(value);
}

Value<T> wrapAbsentValue<T>(T? value) =>
    value == null ? const Value.absent() : Value(value);

const uuid = Uuid();
