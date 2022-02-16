import 'dart:async';

import 'package:drift/drift.dart';
import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
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
        return create(event);
      case UserUpdated.staticTag:
        return update(event);
      case UserDeactivated.staticTag:
        return deactivate(event);
      case UserReactivated.staticTag:
        return reactivate(event);
      case UserLoggedIn.staticTag:
        return loggedIn(event);
    }
  }

  Future<void> create(Event event) async {
    final data = ProjectionEvent.fromEvent(event, UserCreatedSerializer()).data;
    await userDao.createUser(User(
      id: event.streamId,
      name: data.name,
      password: data.password,
      role: data.role,
      pin: data.pin,
      active: true,
    ));
  }

  Future<void> update(Event event) async {
    final data = ProjectionEvent.fromEvent(event, UserUpdatedSerializer()).data;
    await userDao.updateUser(
      event.streamId,
      UsersCompanion(
        name: wrapAbsentValue(data.name),
        password: wrapAbsentValue(data.password),
        role: wrapAbsentValue(data.role),
        pin: wrapAbsentValue(data.pin),
      ),
    );
  }

  Future<void> deactivate(Event event) async {
    await userDao.updateUser(
      event.streamId,
      const UsersCompanion(active: Value(false)),
    );
  }

  Future<void> reactivate(Event event) async {
    await userDao.updateUser(
      event.streamId,
      const UsersCompanion(active: Value(true)),
    );
  }

  Future<void> loggedIn(Event event) async {
    await userDao.updateUser(
      event.streamId,
      UsersCompanion(lastLogin: Value(event.date)),
    );
  }

  static User? projectUsers(List<Event> events) {
    assertStreamId(events);

    User? user;
    for (final event in events) {
      switch (event.tag) {
        case UserCreated.staticTag:
          {
            final data = UserCreatedSerializer().fromJson(event.data);
            user = User(
              id: event.streamId,
              name: data.name,
              active: true,
              pin: data.pin,
              role: data.role,
              password: data.password,
            );
          }
          break;
        case UserUpdated.staticTag:
          {
            final data = UserUpdatedSerializer().fromJson(event.data);
            user = modifyUser(data.toUserCompanion(), user!);
          }
          break;
        case UserDeactivated.staticTag:
          user = modifyUser(const UsersCompanion(active: Value(false)), user!);
          break;
        case UserReactivated.staticTag:
          user = modifyUser(const UsersCompanion(active: Value(true)), user!);
          break;
        case UserLoggedIn.staticTag:
          user =
              modifyUser(UsersCompanion(lastLogin: Value(event.date)), user!);
          break;
      }
    }
    return user;
  }
}

User modifyUser(UsersCompanion data, User user) => User(
      id: user.id,
      name: updateValue(data.name, user.name),
      pin: updateValue(data.pin, user.pin),
      password: updateValue(data.password, user.password),
      role: updateValue(data.role, user.role),
      active: updateValue(data.active, user.active),
    );
