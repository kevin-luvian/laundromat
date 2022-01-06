// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class User extends DataClass implements Insertable<User> {
  final int id;
  final String streamID;
  final String username;
  final String password;
  final String fullName;
  final String role;
  User(
      {required this.id,
      required this.streamID,
      required this.username,
      required this.password,
      required this.fullName,
      required this.role});
  factory User.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return User(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      streamID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}stream_i_d'])!,
      username: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}username'])!,
      password: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}password'])!,
      fullName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}full_name'])!,
      role: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}role'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['stream_i_d'] = Variable<String>(streamID);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['full_name'] = Variable<String>(fullName);
    map['role'] = Variable<String>(role);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      streamID: Value(streamID),
      username: Value(username),
      password: Value(password),
      fullName: Value(fullName),
      role: Value(role),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      streamID: serializer.fromJson<String>(json['streamID']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      fullName: serializer.fromJson<String>(json['fullName']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'streamID': serializer.toJson<String>(streamID),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'fullName': serializer.toJson<String>(fullName),
      'role': serializer.toJson<String>(role),
    };
  }

  User copyWith(
          {int? id,
          String? streamID,
          String? username,
          String? password,
          String? fullName,
          String? role}) =>
      User(
        id: id ?? this.id,
        streamID: streamID ?? this.streamID,
        username: username ?? this.username,
        password: password ?? this.password,
        fullName: fullName ?? this.fullName,
        role: role ?? this.role,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('streamID: $streamID, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('fullName: $fullName, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, streamID, username, password, fullName, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.streamID == this.streamID &&
          other.username == this.username &&
          other.password == this.password &&
          other.fullName == this.fullName &&
          other.role == this.role);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> streamID;
  final Value<String> username;
  final Value<String> password;
  final Value<String> fullName;
  final Value<String> role;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.streamID = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.fullName = const Value.absent(),
    this.role = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String streamID,
    required String username,
    required String password,
    required String fullName,
    required String role,
  })  : streamID = Value(streamID),
        username = Value(username),
        password = Value(password),
        fullName = Value(fullName),
        role = Value(role);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? streamID,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? fullName,
    Expression<String>? role,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (streamID != null) 'stream_i_d': streamID,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (fullName != null) 'full_name': fullName,
      if (role != null) 'role': role,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? streamID,
      Value<String>? username,
      Value<String>? password,
      Value<String>? fullName,
      Value<String>? role}) {
    return UsersCompanion(
      id: id ?? this.id,
      streamID: streamID ?? this.streamID,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (streamID.present) {
      map['stream_i_d'] = Variable<String>(streamID.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('streamID: $streamID, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('fullName: $fullName, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  final GeneratedDatabase _db;
  final String? _alias;
  $UsersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _streamIDMeta = const VerificationMeta('streamID');
  @override
  late final GeneratedColumn<String?> streamID = GeneratedColumn<String?>(
      'stream_i_d', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _usernameMeta = const VerificationMeta('username');
  @override
  late final GeneratedColumn<String?> username = GeneratedColumn<String?>(
      'username', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  @override
  late final GeneratedColumn<String?> password = GeneratedColumn<String?>(
      'password', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _fullNameMeta = const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String?> fullName = GeneratedColumn<String?>(
      'full_name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String?> role = GeneratedColumn<String?>(
      'role', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, streamID, username, password, fullName, role];
  @override
  String get aliasedName => _alias ?? 'users';
  @override
  String get actualTableName => 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('stream_i_d')) {
      context.handle(_streamIDMeta,
          streamID.isAcceptableOrUnknown(data['stream_i_d']!, _streamIDMeta));
    } else if (isInserting) {
      context.missing(_streamIDMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    return User.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(_db, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final int id;
  final String streamID;
  final String streamType;
  final String tag;
  final int version;
  final Map<String, dynamic> data;
  Event(
      {required this.id,
      required this.streamID,
      required this.streamType,
      required this.tag,
      required this.version,
      required this.data});
  factory Event.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Event(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      streamID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}stream_i_d'])!,
      streamType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}stream_type'])!,
      tag: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tag'])!,
      version: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}version'])!,
      data: $EventsTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['stream_i_d'] = Variable<String>(streamID);
    map['stream_type'] = Variable<String>(streamType);
    map['tag'] = Variable<String>(tag);
    map['version'] = Variable<int>(version);
    {
      final converter = $EventsTable.$converter0;
      map['data'] = Variable<String>(converter.mapToSql(data)!);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      streamID: Value(streamID),
      streamType: Value(streamType),
      tag: Value(tag),
      version: Value(version),
      data: Value(data),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      streamID: serializer.fromJson<String>(json['streamID']),
      streamType: serializer.fromJson<String>(json['streamType']),
      tag: serializer.fromJson<String>(json['tag']),
      version: serializer.fromJson<int>(json['version']),
      data: serializer.fromJson<Map<String, dynamic>>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'streamID': serializer.toJson<String>(streamID),
      'streamType': serializer.toJson<String>(streamType),
      'tag': serializer.toJson<String>(tag),
      'version': serializer.toJson<int>(version),
      'data': serializer.toJson<Map<String, dynamic>>(data),
    };
  }

  Event copyWith(
          {int? id,
          String? streamID,
          String? streamType,
          String? tag,
          int? version,
          Map<String, dynamic>? data}) =>
      Event(
        id: id ?? this.id,
        streamID: streamID ?? this.streamID,
        streamType: streamType ?? this.streamType,
        tag: tag ?? this.tag,
        version: version ?? this.version,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('streamID: $streamID, ')
          ..write('streamType: $streamType, ')
          ..write('tag: $tag, ')
          ..write('version: $version, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, streamID, streamType, tag, version, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.streamID == this.streamID &&
          other.streamType == this.streamType &&
          other.tag == this.tag &&
          other.version == this.version &&
          other.data == this.data);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<String> streamID;
  final Value<String> streamType;
  final Value<String> tag;
  final Value<int> version;
  final Value<Map<String, dynamic>> data;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.streamID = const Value.absent(),
    this.streamType = const Value.absent(),
    this.tag = const Value.absent(),
    this.version = const Value.absent(),
    this.data = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required String streamID,
    required String streamType,
    required String tag,
    required int version,
    required Map<String, dynamic> data,
  })  : streamID = Value(streamID),
        streamType = Value(streamType),
        tag = Value(tag),
        version = Value(version),
        data = Value(data);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<String>? streamID,
    Expression<String>? streamType,
    Expression<String>? tag,
    Expression<int>? version,
    Expression<Map<String, dynamic>>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (streamID != null) 'stream_i_d': streamID,
      if (streamType != null) 'stream_type': streamType,
      if (tag != null) 'tag': tag,
      if (version != null) 'version': version,
      if (data != null) 'data': data,
    });
  }

  EventsCompanion copyWith(
      {Value<int>? id,
      Value<String>? streamID,
      Value<String>? streamType,
      Value<String>? tag,
      Value<int>? version,
      Value<Map<String, dynamic>>? data}) {
    return EventsCompanion(
      id: id ?? this.id,
      streamID: streamID ?? this.streamID,
      streamType: streamType ?? this.streamType,
      tag: tag ?? this.tag,
      version: version ?? this.version,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (streamID.present) {
      map['stream_i_d'] = Variable<String>(streamID.value);
    }
    if (streamType.present) {
      map['stream_type'] = Variable<String>(streamType.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (data.present) {
      final converter = $EventsTable.$converter0;
      map['data'] = Variable<String>(converter.mapToSql(data.value)!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('streamID: $streamID, ')
          ..write('streamType: $streamType, ')
          ..write('tag: $tag, ')
          ..write('version: $version, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  final GeneratedDatabase _db;
  final String? _alias;
  $EventsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _streamIDMeta = const VerificationMeta('streamID');
  @override
  late final GeneratedColumn<String?> streamID = GeneratedColumn<String?>(
      'stream_i_d', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _streamTypeMeta = const VerificationMeta('streamType');
  @override
  late final GeneratedColumn<String?> streamType = GeneratedColumn<String?>(
      'stream_type', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String?> tag = GeneratedColumn<String?>(
      'tag', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _versionMeta = const VerificationMeta('version');
  @override
  late final GeneratedColumn<int?> version = GeneratedColumn<int?>(
      'version', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String?>
      data = GeneratedColumn<String?>('data', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>($EventsTable.$converter0);
  @override
  List<GeneratedColumn> get $columns =>
      [id, streamID, streamType, tag, version, data];
  @override
  String get aliasedName => _alias ?? 'events';
  @override
  String get actualTableName => 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('stream_i_d')) {
      context.handle(_streamIDMeta,
          streamID.isAcceptableOrUnknown(data['stream_i_d']!, _streamIDMeta));
    } else if (isInserting) {
      context.missing(_streamIDMeta);
    }
    if (data.containsKey('stream_type')) {
      context.handle(
          _streamTypeMeta,
          streamType.isAcceptableOrUnknown(
              data['stream_type']!, _streamTypeMeta));
    } else if (isInserting) {
      context.missing(_streamTypeMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
          _tagMeta, tag.isAcceptableOrUnknown(data['tag']!, _tagMeta));
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    context.handle(_dataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Event.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      const JsonConverter();
}

abstract class _$DriftDB extends GeneratedDatabase {
  _$DriftDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $UsersTable users = $UsersTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final UserDao userDao = UserDao(this as DriftDB);
  late final EventDao eventDao = EventDao(this as DriftDB);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users, events];
}
