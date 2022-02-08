import 'package:laundry/helpers/utils.dart';

const userEventType = "USER";

class UserCreated extends EventData<UserCreated> {
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

  @override
  get tag => staticTag;
  static const staticTag = "UserCreated";

  @override
  get serializer => UserCreatedSerializer();
}

class UserUpdated extends EventData<UserUpdated> {
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

  static const staticTag = "UserUpdated";

  @override
  get serializer => UserUpdatedSerializer();

  @override
  get tag => staticTag;
}

class UserDeactivated extends EventData<UserDeactivated> {
  @override
  get serializer => UserDeactivatedSerializer();

  @override
  get tag => staticTag;
  static const String staticTag = "UserDeactivated";
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
