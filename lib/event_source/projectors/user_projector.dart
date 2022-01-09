import 'dart:async';

import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/user_event.dart';
import 'package:laundry/helpers/utils.dart';

class UserProjector {
  final UserDao userDao;

  UserProjector(DriftDB db) : userDao = UserDao(db);

  StreamSubscription<Event> listen(Stream<Event> eventStream) =>
      eventStream.listen(project);

  Future<void> project(Event event) async {
    switch (event.tag) {
      case "UserCreated":
        return create(UserCreated.fromEvent(event));
      case "UserUpdated":
        return update(UserUpdated.fromEvent(event));
      case "UserDeactivated":
        return deactivate(UserDeactivated.fromEvent(event));
    }
  }

  Future<void> create(UserCreated ucEvent) async {
    await userDao.createUser(User(
      id: ucEvent.streamId,
      name: ucEvent.name,
      password: ucEvent.password,
      role: ucEvent.role,
    ));
  }

  Future<void> update(UserUpdated uEvent) async {
    await userDao.updateUser(
      uEvent.streamId,
      UsersCompanion(
        name: wrapAbsentValue(uEvent.name),
        password: wrapAbsentValue(uEvent.password),
        role: wrapAbsentValue(uEvent.role),
      ),
    );
  }

  Future<void> deactivate(UserDeactivated uEvent) async {
    await userDao.deleteUser(uEvent.streamId);
  }
}
