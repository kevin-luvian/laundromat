import 'dart:convert';

import 'package:drift/drift.dart';

class JsonConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonConverter();

  @override
  Map<String, dynamic>? mapToDart(String? fromDb) =>
      fromDb == null ? null : json.decode(fromDb);

  @override
  String? mapToSql(Map<String, dynamic>? value) => json.encode(value);
}

@DataClassName("Event")
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get streamId => text()();

  TextColumn get streamType => text()();

  TextColumn get tag => text()();

  IntColumn get version => integer()();

  DateTimeColumn get date => dateTime().withDefault(currentDate)();

  TextColumn get data => text().map(const JsonConverter())();

  @override
  List<String> get customConstraints => ['UNIQUE (stream_id, version)'];
}
