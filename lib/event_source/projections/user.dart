import 'package:drift/drift.dart';
import 'package:laundry/db/dao/user.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/event_source/events/users.dart';

class UserProjections {
  final DriftDB db;

  UserProjections(this.db);

  void create(UserCreated ucEvent) {
    UserDao(db).createUser(UsersCompanion(
      streamID: Value(ucEvent.streamID),
      username: Value(ucEvent.username),
      fullName: Value(ucEvent.fullName),
      password: Value(ucEvent.password),
      role: Value(ucEvent.role),
    ));
  }

  void update(UserUpdated ucEvent) {
    UserDao(db).updateUserByStreamID(
      UsersCompanion(
        streamID: Value(ucEvent.streamID),
      ),
    );
  }

  void deactivate(UserDeactivated ucEvent) {
    UserDao(db).deleteUserByStreamID(ucEvent.streamID);
  }
}
