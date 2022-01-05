import 'package:drift/drift.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/users.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<DriftDB> with _$UsersDaoMixin {
  UsersDao(DriftDB db) : super(db);

  Stream<List<User>> allUsers() {
    return select(users).watch();
  }

  Future<int> createUser(User user) {
    return into(users).insert(user);
  }

  void deleteUser(int id) {
    delete(users).where((user) => user.id.equals(id));
  }
}
