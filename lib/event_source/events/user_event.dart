import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/utils.dart';

const userEventType = "USER";

class UserCreated extends EventData<UserCreated> {
  String createdBy;
  String name;
  String password;
  String role;
  String pin;

  UserCreated({
    required this.createdBy,
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
  String updatedBy;
  String? name;
  String? password;
  String? role;
  String? pin;

  static const staticTag = "UserUpdated";

  UserUpdated({
    required this.updatedBy,
    this.name,
    this.password,
    this.role,
    this.pin,
  });

  @override
  get serializer => UserUpdatedSerializer();

  @override
  get tag => staticTag;

  UsersCompanion toUserCompanion() {
    return UsersCompanion(
      name: wrapAbsentValue(name),
      password: wrapAbsentValue(password),
      pin: wrapAbsentValue(pin),
      role: wrapAbsentValue(role),
    );
  }
}

class UserDeactivated extends EventData<UserDeactivated> {
  final String updatedBy;

  UserDeactivated(this.updatedBy);

  @override
  get serializer => UserDeactivatedSerializer();

  @override
  get tag => staticTag;
  static const String staticTag = "UserDeactivated";
}

class UserReactivated extends EventData<UserReactivated> {
  final String updatedBy;

  UserReactivated(this.updatedBy);

  @override
  get serializer => UserReactivatedSerializer();

  @override
  get tag => staticTag;
  static const String staticTag = "UserReactivated";
}

class UserLoggedIn implements EventData<void> {
  @override
  get serializer => EmptySerializer();

  @override
  get tag => staticTag;
  static const String staticTag = "UserLoggedIn";
}

class UserCreatedSerializer implements Serializer<UserCreated> {
  @override
  UserCreated fromJson(data) => UserCreated(
        createdBy: data["createdBy"] as String,
        name: data["name"] as String,
        password: data["password"] as String,
        role: data["role"] as String,
        pin: data["pin"] as String,
      );

  @override
  toJson(t) => <String, dynamic>{
        "name": t.name,
        "password": t.password,
        "role": t.role,
        "pin": t.pin,
        "createdBy": t.createdBy,
      };
}

class UserUpdatedSerializer implements Serializer<UserUpdated> {
  @override
  UserUpdated fromJson(data) => UserUpdated(
        updatedBy: data["updatedBy"] as String,
        name: data["name"] as String?,
        password: data["password"] as String?,
        role: data["role"] as String?,
        pin: data["pin"] as String?,
      );

  @override
  toJson(t) => <String, dynamic>{
        "updatedBy": t.updatedBy,
        "name": t.name,
        "password": t.password,
        "role": t.role,
        "pin": t.pin,
      };
}

class UserDeactivatedSerializer implements Serializer<UserDeactivated> {
  @override
  fromJson(data) => UserDeactivated(data["updatedBy"] as String);

  @override
  toJson(t) => <String, dynamic>{"updatedBy": t.updatedBy};
}

class UserReactivatedSerializer implements Serializer<UserReactivated> {
  @override
  fromJson(data) => UserReactivated(data["updatedBy"] as String);

  @override
  toJson(t) => <String, dynamic>{"updatedBy": t.updatedBy};
}
