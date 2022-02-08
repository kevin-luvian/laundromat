import 'package:drift/native.dart';
import 'package:laundry/db/dao/customer.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/customer_event.dart';
import 'package:laundry/event_source/projectors/projector_listeners.dart';
import 'package:laundry/event_source/stream.dart';
import 'package:test/test.dart';

import 'customer_command.dart';

void main() {
  late EventDB db;
  late DriftDB ddb;
  late EventDao eventDao;
  late CustomerDao customerDao;
  late CustomerCommand customerCommand;
  late ProjectorListeners listeners;

  setUp(() async {
    db = EventDB(NativeDatabase.memory());
    ddb = DriftDB(NativeDatabase.memory());
    customerCommand = CustomerCommand(db);
    eventDao = EventDao(db);
    customerDao = CustomerDao(ddb);
    listeners = ProjectorListeners(ddb)..setup();

    await db.delete(db.events).go();
    expect((await eventDao.allEvents()).length, equals(0));
  });

  tearDown(() async {
    await db.close();
    await ddb.close();
    await listeners.dispose();
  });

  test('create customer successfully', () async {
    expect(
      EventStream.stream.map((e) => e.tag),
      emitsAnyOf(<Matcher>[equals(CustomerCreated.staticTag)]),
    );

    await customerCommand.create("bob", "1234");

    final events = await eventDao.allEvents();
    expect(events.length, greaterThan(0));

    final customers = await customerDao.all();
    expect(customers.length, 1);
  });
}
