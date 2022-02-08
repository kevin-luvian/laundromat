import 'package:drift/native.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/user_command.dart';
import 'package:laundry/event_source/events/user_event.dart';
import 'package:laundry/event_source/projectors/projector_listeners.dart';
import 'package:laundry/event_source/stream.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:test/test.dart';

void main() {
  late EventDB db;
  late DriftDB ddb;
  late EventDao eventDao;
  late UserDao userDao;
  late UserCommand userCommand;
  late ProjectorListeners listeners;

  setUp(() async {
    db = EventDB(NativeDatabase.memory());
    ddb = DriftDB(NativeDatabase.memory());
    userCommand = UserCommand(db);
    eventDao = EventDao(db);
    userDao = UserDao(ddb);
    listeners = ProjectorListeners(ddb)..setup();

    await db.delete(db.events).go();
    await userDao.truncate();
    expect((await eventDao.allEvents()).length, equals(0));
    expect((await userDao.allUsers()).length, equals(0));
  });

  tearDown(() async {
    await db.close();
    await ddb.close();
    await listeners.dispose();
  });

  test('create user successfully', () async {
    expect(
      EventStream.stream.map((e) => e.tag),
      emitsAnyOf(<Matcher>[equals(UserCreated.staticTag)]),
    );

    await userCommand.create(
      name: "bob",
      password: "bob123",
      role: "fisherman",
      pin: 1234,
    );

    await userCommand.create(
      name: "bob2",
      password: "bob123",
      role: "fisherman",
      pin: 1235,
    );

    final events = await eventDao.allEvents();
    expect(events.length, greaterThan(0));
  });

  test('can update user', () async {
    expect(
      EventStream.stream.map((e) => e.tag),
      emitsInOrder(<String>[UserCreated.staticTag, UserUpdated.staticTag]),
    );

    final streamId = await userCommand.create(
      name: "bob",
      password: "bob123",
      role: "fisherman",
      pin: 1234,
    );

    await userCommand.update(streamId: streamId, name: "uber bob");

    final events = await eventDao.allEvents();
    expect(events.length, 2);

    await shortDelay();
    final users = await userDao.allUsers();
    expect(users.length, 1);
    expect(users[0].name, "uber bob");
  });

  test('can deactivate user', () async {
    expect(
      EventStream.stream.map((e) => e.tag),
      emitsInOrder(<String>[UserCreated.staticTag, UserDeactivated.staticTag]),
    );

    final streamId = await userCommand.create(
      name: "bob",
      password: "bob123",
      role: "fisherman",
      pin: 1234,
    );

    await userCommand.deactivate(streamId: streamId);

    final events = await eventDao.allEvents();
    expect(events.length, 2);

    await shortDelay();
    final users = await userDao.allUsers();
    expect(users.length, 0);
  });
}
