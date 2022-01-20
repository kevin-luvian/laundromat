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

abstract class Serializer<T> {
  Map<String, dynamic> toJson(T t);

  T fromJson(Map<String, dynamic> data);
}

int parseIntOrZero(String text) => int.tryParse(text, radix: 10) ?? 0;

final priceFormatter = NumberFormat.currency(
  locale: "id",
  customPattern: 'IDR #,###',
  decimalDigits: 0,
);
