import 'package:laundry/event_source/events/main.dart';

class UserCreated implements IEvent {
  @override
  final String tag = "UserCreated";

  @override
  String streamID;
  String username;
  String fullName;
  String password;
  String role;

  UserCreated({
    required this.streamID,
    required this.username,
    required this.fullName,
    required this.password,
    required this.role,
  });
}

class UserUpdated implements IEvent {
  @override
  final String tag = "UserUpdated";

  @override
  String streamID;
  String? username;
  String? fullName;
  String? password;
  String? role;

  UserUpdated({
    required this.streamID,
    this.username,
    this.fullName,
    this.password,
    this.role,
  });
}

class UserDeactivated implements IEvent {
  @override
  final String tag = "UserDeactivated";

  @override
  String streamID;

  UserDeactivated({required this.streamID});
}
