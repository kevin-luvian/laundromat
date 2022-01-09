// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final String password;
  final String role;
  User(
      {required this.id,
      required this.name,
      required this.password,
      required this.role});
  factory User.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return User(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      password: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}password'])!,
      role: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}role'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      password: Value(password),
      role: Value(role),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      password: serializer.fromJson<String>(json['password']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(role),
    };
  }

  User copyWith({String? id, String? name, String? password, String? role}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        password: password ?? this.password,
        role: role ?? this.role,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('password: $password, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, password, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.password == this.password &&
          other.role == this.role);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> password;
  final Value<String> role;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    required String password,
    required String role,
  })  : id = Value(id),
        name = Value(name),
        password = Value(password),
        role = Value(role);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? password,
    Expression<String>? role,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? password,
      Value<String>? role}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
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
          ..write('name: $name, ')
          ..write('password: $password, ')
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
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  @override
  late final GeneratedColumn<String?> password = GeneratedColumn<String?>(
      'password', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String?> role = GeneratedColumn<String?>(
      'role', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, password, role];
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
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
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

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final String lang;
  final String theme;
  final String staffId;
  final DateTime loggedInDate;
  Session(
      {required this.id,
      required this.lang,
      required this.theme,
      required this.staffId,
      required this.loggedInDate});
  factory Session.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Session(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      lang: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}lang'])!,
      theme: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}theme'])!,
      staffId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}staff_id'])!,
      loggedInDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}logged_in_date'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lang'] = Variable<String>(lang);
    map['theme'] = Variable<String>(theme);
    map['staff_id'] = Variable<String>(staffId);
    map['logged_in_date'] = Variable<DateTime>(loggedInDate);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      lang: Value(lang),
      theme: Value(theme),
      staffId: Value(staffId),
      loggedInDate: Value(loggedInDate),
    );
  }

  factory Session.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      lang: serializer.fromJson<String>(json['lang']),
      theme: serializer.fromJson<String>(json['theme']),
      staffId: serializer.fromJson<String>(json['staffId']),
      loggedInDate: serializer.fromJson<DateTime>(json['loggedInDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lang': serializer.toJson<String>(lang),
      'theme': serializer.toJson<String>(theme),
      'staffId': serializer.toJson<String>(staffId),
      'loggedInDate': serializer.toJson<DateTime>(loggedInDate),
    };
  }

  Session copyWith(
          {int? id,
          String? lang,
          String? theme,
          String? staffId,
          DateTime? loggedInDate}) =>
      Session(
        id: id ?? this.id,
        lang: lang ?? this.lang,
        theme: theme ?? this.theme,
        staffId: staffId ?? this.staffId,
        loggedInDate: loggedInDate ?? this.loggedInDate,
      );
  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('theme: $theme, ')
          ..write('staffId: $staffId, ')
          ..write('loggedInDate: $loggedInDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lang, theme, staffId, loggedInDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.lang == this.lang &&
          other.theme == this.theme &&
          other.staffId == this.staffId &&
          other.loggedInDate == this.loggedInDate);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<String> lang;
  final Value<String> theme;
  final Value<String> staffId;
  final Value<DateTime> loggedInDate;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.lang = const Value.absent(),
    this.theme = const Value.absent(),
    this.staffId = const Value.absent(),
    this.loggedInDate = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    this.lang = const Value.absent(),
    this.theme = const Value.absent(),
    this.staffId = const Value.absent(),
    this.loggedInDate = const Value.absent(),
  });
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<String>? lang,
    Expression<String>? theme,
    Expression<String>? staffId,
    Expression<DateTime>? loggedInDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lang != null) 'lang': lang,
      if (theme != null) 'theme': theme,
      if (staffId != null) 'staff_id': staffId,
      if (loggedInDate != null) 'logged_in_date': loggedInDate,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? lang,
      Value<String>? theme,
      Value<String>? staffId,
      Value<DateTime>? loggedInDate}) {
    return SessionsCompanion(
      id: id ?? this.id,
      lang: lang ?? this.lang,
      theme: theme ?? this.theme,
      staffId: staffId ?? this.staffId,
      loggedInDate: loggedInDate ?? this.loggedInDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<String>(staffId.value);
    }
    if (loggedInDate.present) {
      map['logged_in_date'] = Variable<DateTime>(loggedInDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('theme: $theme, ')
          ..write('staffId: $staffId, ')
          ..write('loggedInDate: $loggedInDate')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  final GeneratedDatabase _db;
  final String? _alias;
  $SessionsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String?> lang = GeneratedColumn<String?>(
      'lang', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant("id"));
  final VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String?> theme = GeneratedColumn<String?>(
      'theme', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant("red_velvet"));
  final VerificationMeta _staffIdMeta = const VerificationMeta('staffId');
  @override
  late final GeneratedColumn<String?> staffId = GeneratedColumn<String?>(
      'staff_id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(""));
  final VerificationMeta _loggedInDateMeta =
      const VerificationMeta('loggedInDate');
  @override
  late final GeneratedColumn<DateTime?> loggedInDate =
      GeneratedColumn<DateTime?>('logged_in_date', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, lang, theme, staffId, loggedInDate];
  @override
  String get aliasedName => _alias ?? 'sessions';
  @override
  String get actualTableName => 'sessions';
  @override
  VerificationContext validateIntegrity(Insertable<Session> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lang')) {
      context.handle(
          _langMeta, lang.isAcceptableOrUnknown(data['lang']!, _langMeta));
    }
    if (data.containsKey('theme')) {
      context.handle(
          _themeMeta, theme.isAcceptableOrUnknown(data['theme']!, _themeMeta));
    }
    if (data.containsKey('staff_id')) {
      context.handle(_staffIdMeta,
          staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta));
    }
    if (data.containsKey('logged_in_date')) {
      context.handle(
          _loggedInDateMeta,
          loggedInDate.isAcceptableOrUnknown(
              data['logged_in_date']!, _loggedInDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Session.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(_db, alias);
  }
}

abstract class _$DriftDB extends GeneratedDatabase {
  _$DriftDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $UsersTable users = $UsersTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final UserDao userDao = UserDao(this as DriftDB);
  late final SessionDao sessionDao = SessionDao(this as DriftDB);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users, sessions];
}
