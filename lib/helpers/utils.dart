import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

Future shortDelay() => Future.delayed(const Duration(milliseconds: 50));

formatPrice(double value) {
  return NumberFormat("#,###", "id").format(value);
}

Value<T> wrapAbsentValue<T>(T? value) =>
    value == null ? const Value.absent() : Value(value);

const uuid = Uuid();

String makeStreamId(String streamType) => "$streamType-${uuid.v4()}";

T? toUpdate<T>(T? value, T? prevValue) {
  return value == prevValue ? null : value;
}

T cnord<T>(T? val, T def) {
  if (val == null) return def;
  return val;
}

abstract class Serializer<T> {
  Map<String, dynamic> toJson(T t);

  T fromJson(Map<String, dynamic> data);
}

class EmptySerializer<T> extends Serializer<T> {
  T t;

  EmptySerializer(this.t);

  @override
  toJson(T t) => {};

  @override
  fromJson(data) => t;
}

int parseIntOrZero(String text) => int.tryParse(text, radix: 10) ?? 0;

final priceFormatter = NumberFormat.currency(
  locale: "id",
  customPattern: 'IDR #,###',
  decimalDigits: 0,
);

final decimalPriceFormatter = NumberFormat.currency(
  customPattern: '#,###',
  decimalDigits: 0,
);
