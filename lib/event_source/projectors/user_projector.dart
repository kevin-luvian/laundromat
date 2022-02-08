import 'dart:async';

import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/event_source/events/user_event.dart';
import 'package:laundry/event_source/projectors/declare.dart';
import 'package:laundry/helpers/utils.dart';

class UserProjector implements IProjector {
  UserProjector(DriftDB db) : userDao = UserDao(db);

  final UserDao userDao;

  @override
  project(event) async {
    switch (event.tag) {
      case UserCreated.staticTag:
        return create(
            ProjectionEvent.fromEvent(event, UserCreatedSerializer()));
      case UserUpdated.staticTag:
        return update(
            ProjectionEvent.fromEvent(event, UserUpdatedSerializer()));
      case UserDeactivated.staticTag:
        return deactivate(
            ProjectionEvent.fromEvent(event, UserDeactivatedSerializer()));
    }
  }

  Future<void> create(ProjectionEvent<UserCreated> event) async {
    await userDao.createUser(User(
      id: event.streamId,
      name: event.data.name,
      password: event.data.password,
      role: event.data.role,
      pin: event.data.pin,
    ));
  }

  Future<void> update(ProjectionEvent<UserUpdated> event) async {
    await userDao.updateUser(
      event.streamId,
      UsersCompanion(
        name: wrapAbsentValue(event.data.name),
        password: wrapAbsentValue(event.data.password),
        role: wrapAbsentValue(event.data.role),
        pin: wrapAbsentValue(event.data.pin),
      ),
    );
  }

  Future<void> deactivate(ProjectionEvent<UserDeactivated> event) async {
    await userDao.deleteUser(event.streamId);
  }
}
