import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

Future shortDelay() => Future<void>.delayed(const Duration(milliseconds: 50));

Future waitMilliseconds(int num) =>
    Future<void>.delayed(Duration(milliseconds: num));

String formatPrice(dynamic value) {
  return NumberFormat("#,###", "id").format(value);
}

Value<T> wrapAbsentValue<T>(T? value) =>
    value == null ? const Value.absent() : Value(value);

T updateValue<T>(Value<T> value, T data) => value.present ? value.value : data;

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

abstract class EventData<T> {
  String get tag;

  Serializer<T> get serializer;
}

class EmptySerializer extends Serializer<void> {
  EmptySerializer();

  @override
  toJson(t) => <String, dynamic>{};

  @override
  fromJson(data) {}
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

String customPriceFormat(dynamic price) =>
    "Rp. " + decimalPriceFormatter.format(price);

String doubleToString(double val) {
  String result;
  if (val % 1 == 0) {
    result = val.toStringAsFixed(0);
  } else {
    result = val.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
  }
  return result;
}

int sumInt(int a, int b) => a + b;
