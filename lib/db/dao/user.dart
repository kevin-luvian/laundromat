import 'package:drift/drift.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/users.dart';

part 'user.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<DriftDB> with _$UserDaoMixin {
  UserDao(DriftDB db) : super(db);

  Stream<List<User>> allUsers() {
    return select(users).watch();
  }

  Future<int> createUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  Future<void> updateUserByStreamID(UsersCompanion user) async {
    update(users).where((usr) => usr.streamID.equals(user.streamID.value));
  }

  void deleteUser(int id) {
    delete(users).where((user) => user.id.equals(id));
  }

  void deleteUserByStreamID(String streamID) {
    delete(users).where((user) => user.streamID.equals(streamID));
  }
}
