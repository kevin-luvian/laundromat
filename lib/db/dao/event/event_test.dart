import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:laundry/db/event_db.dart';

import 'package:test/test.dart';

import 'event.dart';

void main() {
  late EventDB db;
  late EventDao eventDao;

  setUp(() {
    db = EventDB(NativeDatabase.memory());
    eventDao = EventDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Create Event', () {
    test('create event successfully', () async {
      const streamId = "abc12345";
      final event = EventsCompanion(
        streamId: const Value(streamId),
        streamType: const Value("User"),
        tag: const Value("abc"),
        version: const Value(1),
        date: Value(DateTime(2021)),
        data: const Value({}),
      );
      await eventDao.createEvent(event);
      final eventFromDB = await eventDao.findEventStream(streamId);
      expect(eventFromDB[0].tag, "abc");
      expect(eventFromDB[0].version, 1);
    });

    test('create event should fail if data is null', () async {
      const event = EventsCompanion(
        streamId: Value("abc12345"),
        streamType: Value("User"),
        tag: Value("abc"),
        version: Value(1),
      );
      expect(() async {
        await eventDao.createEvent(event);
      }, throwsA(isA<SqliteException>()));
    });
  });
}
