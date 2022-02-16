import 'package:crypt/crypt.dart';
import 'package:drift/drift.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/users.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<DriftDB> {
  $UsersTable get users => attachedDatabase.users;

  UserDao(DriftDB db) : super(db);

  Future<List<User>> allUsers() {
    return select(users).get();
  }

  Future<User?> findUser(String id) {
    return (select(users)..where((user) => user.id.equals(id)))
        .getSingleOrNull();
  }

  Future<User?> authenticate(String name, String password) async {
    final user = await (select(users)
          ..where((user) => user.name.equals(name))
          ..where((user) => user.active)
          ..limit(1))
        .getSingleOrNull();
    if (user != null && Crypt(user.password).match(password)) {
      return user;
    }
    return null;
  }

  Future<int> createUser(User user) {
    return into(users).insert(user);
  }

  Future<void> updateUser(String id, UsersCompanion user) async {
    await (update(users)..where((usr) => usr.id.equals(id))).write(user);
  }

  Future<void> deleteUser(String id) async {
    await (delete(users)..where((user) => user.id.equals(id))).go();
  }

  Future<void> truncate() async {
    await delete(users).go();
  }

  Future<void> deleteAllExceptSuperAdmin() async {
    await (delete(users)..where((tbl) => tbl.role.equals(roleSuperAdmin).not()))
        .go();
  }

  Stream<List<User>> activeUsers() {
    final query = select(users)
      ..where((user) => user.active.equals(true))
      ..orderBy([(e) => OrderingTerm(expression: e.name)]);
    return query.watch();
  }

  Stream<List<User>> inactiveUsers() {
    final query = select(users)
      ..where((user) => user.active.equals(false))
      ..orderBy([(e) => OrderingTerm(expression: e.name)]);
    return query.watch();
  }
}
