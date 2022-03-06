import 'package:drift/native.dart';
import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/users.dart';
import 'package:test/test.dart';

void main() {
  late DriftDB db;
  late UserDao userDao;

  setUp(() async {
    db = DriftDB(NativeDatabase.memory());
    userDao = UserDao(db);

    expect((await userDao.allUsers()).length, equals(0));
  });

  tearDown(() async {
    await db.close();
  });

  test('stream active users', () async {
    final aStream = await userDao.activeUsers();
    final iStream = await userDao.inactiveUsers();

    expect(aStream.map((user) => user.length), emitsInOrder(<int>[0, 1]));
    expect(iStream.map((user) => user.length), emitsInOrder(<int>[0]));

    await userDao.createUser(User(
      id: "abc12345",
      active: true,
      pin: "1234",
      name: 'bob',
      password: '12345',
      role: roleSuperAdmin,
    ));
    final allUser = await userDao.allUsers();
    expect(allUser.length, 1);
  });
}
