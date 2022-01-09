import 'package:drift/drift.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get lang => text().withDefault(const Constant("id"))();

  TextColumn get theme => text().withDefault(const Constant("red_velvet"))();

  TextColumn get staffId => text().withDefault(const Constant(""))();

  DateTimeColumn get loggedInDate =>
      dateTime().withDefault(currentDateAndTime)();
}
