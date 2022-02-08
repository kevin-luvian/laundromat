import 'package:laundry/helpers/utils.dart';

class UserEvent {
  static const streamType = "USER";
}

class UserCreated {
  static const String tag = "UserCreated";

  String name;
  String password;
  String role;
  int pin;

  UserCreated({
    required this.name,
    required this.password,
    required this.role,
    required this.pin,
  });
}

class UserUpdated {
  static const String tag = "UserUpdated";

  String? name;
  String? password;
  String? role;
  int? pin;

  UserUpdated({
    this.name,
    this.password,
    this.role,
    this.pin,
  });
}

class UserDeactivated {
  static const String tag = "UserDeactivated";
}

class UserCreatedSerializer implements Serializer<UserCreated> {
  @override
  UserCreated fromJson(data) => UserCreated(
        name: data["name"] as String,
        password: data["password"] as String,
        role: data["role"] as String,
        pin: data["pin"] as int,
      );

  @override
  toJson(t) => <String, dynamic>{
        "name": t.name,
        "password": t.password,
        "role": t.role,
        "pin": t.pin,
      };
}

class UserUpdatedSerializer implements Serializer<UserUpdated> {
  @override
  UserUpdated fromJson(data) => UserUpdated(
        name: data["name"] as String?,
        password: data["password"] as String?,
        role: data["role"] as String?,
        pin: data["pin"] as int?,
      );

  @override
  toJson(t) => <String, dynamic>{
        "name": t.name,
        "password": t.password,
        "role": t.role,
        "pin": t.pin,
      };
}

class UserDeactivatedSerializer extends EmptySerializer<UserDeactivated> {
  UserDeactivatedSerializer() : super(UserDeactivated());
}
