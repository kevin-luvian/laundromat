import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/declare.dart';

class UserEvent {
  static const streamType = "USER";
}

class UserCreated extends ProjectionEvent {
  static const String tag = "UserCreated";

  String name;
  String password;
  String role;

  UserCreated({
    required String streamId,
    required DateTime date,
    required int version,
    required this.name,
    required this.password,
    required this.role,
  }) : super(
          streamId: streamId,
          streamType: UserEvent.streamType,
          streamTag: tag,
          date: date,
          version: version,
        );

  factory UserCreated.fromEvent(Event event) => UserCreated(
      streamId: event.streamId,
      version: event.version,
      date: event.date,
      name: event.data["name"],
      password: event.data["password"],
      role: event.data["role"]);

  @override
  Map<String, dynamic> dataToMap() {
    return {"name": name, "password": password, "role": role};
  }
}

class UserUpdated extends ProjectionEvent {
  static const String tag = "UserUpdated";

  String? name;
  String? password;
  String? role;

  UserUpdated({
    required String streamId,
    required DateTime date,
    required int version,
    this.name,
    this.password,
    this.role,
  }) : super(
          streamId: streamId,
          streamType: UserEvent.streamType,
          streamTag: UserUpdated.tag,
          date: date,
          version: version,
        );

  factory UserUpdated.fromEvent(Event event) => UserUpdated(
      streamId: event.streamId,
      version: event.version,
      date: event.date,
      name: event.data["name"],
      password: event.data["password"],
      role: event.data["role"]);

  @override
  Map<String, dynamic> dataToMap() {
    return {"name": name, "password": password, "role": role};
  }
}

class UserDeactivated extends ProjectionEvent {
  static const String tag = "UserDeactivated";

  UserDeactivated({
    required String streamId,
    required DateTime date,
    required int version,
  }) : super(
          streamId: streamId,
          streamType: UserEvent.streamType,
          streamTag: UserDeactivated.tag,
          date: date,
          version: version,
        );

  factory UserDeactivated.fromEvent(Event event) {
    return UserDeactivated(
      streamId: event.streamId,
      date: event.date,
      version: event.version,
    );
  }
}
