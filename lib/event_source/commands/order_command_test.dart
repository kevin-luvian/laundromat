import 'package:drift/native.dart';
import 'package:laundry/db/aggregates/plain_order_details.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/order_command.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:test/test.dart';

void main() {
  late EventDB db;
  late EventDao eventDao;
  late OrderCommand orderCommand;

  setUp(() async {
    db = EventDB(NativeDatabase.memory());
    eventDao = EventDao(db);
    orderCommand = OrderCommand(db);

    await db.delete(db.events).go();
    expect((await eventDao.allEvents()).length, equals(0));
  });

  tearDown(() async {
    await db.close();
  });

  test('create order successfully', () async {
    await orderCommand.create("ord", "abc", "def", []);

    List<Event> events = await eventDao.allEvents();
    expect(events.length, 1);

    await orderCommand.create("asdas", "abc", "def", [
      OrderItem(10, "abc", ["lkl"]),
      OrderItem(5, "def", ["lkl"]),
    ]);

    events = await eventDao.allEvents();
    expect(events.length, 2);
    logger.d(events);
  });
}
