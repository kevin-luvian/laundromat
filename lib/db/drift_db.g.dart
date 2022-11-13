// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final String pin;
  final String password;
  final String role;
  final bool active;
  final DateTime? lastLogin;
  User(
      {required this.id,
      required this.name,
      required this.pin,
      required this.password,
      required this.role,
      required this.active,
      this.lastLogin});
  factory User.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return User(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      pin: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pin'])!,
      password: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}password'])!,
      role: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}role'])!,
      active: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}active'])!,
      lastLogin: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_login']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['pin'] = Variable<String>(pin);
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || lastLogin != null) {
      map['last_login'] = Variable<DateTime?>(lastLogin);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      pin: Value(pin),
      password: Value(password),
      role: Value(role),
      active: Value(active),
      lastLogin: lastLogin == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLogin),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      pin: serializer.fromJson<String>(json['pin']),
      password: serializer.fromJson<String>(json['password']),
      role: serializer.fromJson<String>(json['role']),
      active: serializer.fromJson<bool>(json['active']),
      lastLogin: serializer.fromJson<DateTime?>(json['lastLogin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'pin': serializer.toJson<String>(pin),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(role),
      'active': serializer.toJson<bool>(active),
      'lastLogin': serializer.toJson<DateTime?>(lastLogin),
    };
  }

  User copyWith(
          {String? id,
          String? name,
          String? pin,
          String? password,
          String? role,
          bool? active,
          DateTime? lastLogin}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        pin: pin ?? this.pin,
        password: password ?? this.password,
        role: role ?? this.role,
        active: active ?? this.active,
        lastLogin: lastLogin ?? this.lastLogin,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pin: $pin, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('active: $active, ')
          ..write('lastLogin: $lastLogin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, pin, password, role, active, lastLogin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.pin == this.pin &&
          other.password == this.password &&
          other.role == this.role &&
          other.active == this.active &&
          other.lastLogin == this.lastLogin);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> pin;
  final Value<String> password;
  final Value<String> role;
  final Value<bool> active;
  final Value<DateTime?> lastLogin;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pin = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.active = const Value.absent(),
    this.lastLogin = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    required String pin,
    required String password,
    required String role,
    this.active = const Value.absent(),
    this.lastLogin = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        pin = Value(pin),
        password = Value(password),
        role = Value(role);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? pin,
    Expression<String>? password,
    Expression<String>? role,
    Expression<bool>? active,
    Expression<DateTime?>? lastLogin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pin != null) 'pin': pin,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (active != null) 'active': active,
      if (lastLogin != null) 'last_login': lastLogin,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? pin,
      Value<String>? password,
      Value<String>? role,
      Value<bool>? active,
      Value<DateTime?>? lastLogin}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pin: pin ?? this.pin,
      password: password ?? this.password,
      role: role ?? this.role,
      active: active ?? this.active,
      lastLogin: lastLogin ?? this.lastLogin,
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
    if (pin.present) {
      map['pin'] = Variable<String>(pin.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (lastLogin.present) {
      map['last_login'] = Variable<DateTime?>(lastLogin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pin: $pin, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('active: $active, ')
          ..write('lastLogin: $lastLogin')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
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
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _pinMeta = const VerificationMeta('pin');
  @override
  late final GeneratedColumn<String?> pin = GeneratedColumn<String?>(
      'pin', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 4),
      type: const StringType(),
      requiredDuringInsert: true);
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
  final VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool?> active = GeneratedColumn<bool?>(
      'active', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (active IN (0, 1))',
      defaultValue: const Constant(true));
  final VerificationMeta _lastLoginMeta = const VerificationMeta('lastLogin');
  @override
  late final GeneratedColumn<DateTime?> lastLogin = GeneratedColumn<DateTime?>(
      'last_login', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, pin, password, role, active, lastLogin];
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
    if (data.containsKey('pin')) {
      context.handle(
          _pinMeta, pin.isAcceptableOrUnknown(data['pin']!, _pinMeta));
    } else if (isInserting) {
      context.missing(_pinMeta);
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
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('last_login')) {
      context.handle(_lastLoginMeta,
          lastLogin.isAcceptableOrUnknown(data['last_login']!, _lastLoginMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    return User.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String phone;
  final String name;
  final int status;
  final String lastEditorId;
  Customer(
      {required this.id,
      required this.phone,
      required this.name,
      required this.status,
      required this.lastEditorId});
  factory Customer.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Customer(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      phone: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}phone'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
      lastEditorId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_editor_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone'] = Variable<String>(phone);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<int>(status);
    map['last_editor_id'] = Variable<String>(lastEditorId);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      phone: Value(phone),
      name: Value(name),
      status: Value(status),
      lastEditorId: Value(lastEditorId),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      phone: serializer.fromJson<String>(json['phone']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<int>(json['status']),
      lastEditorId: serializer.fromJson<String>(json['lastEditorId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phone': serializer.toJson<String>(phone),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<int>(status),
      'lastEditorId': serializer.toJson<String>(lastEditorId),
    };
  }

  Customer copyWith(
          {String? id,
          String? phone,
          String? name,
          int? status,
          String? lastEditorId}) =>
      Customer(
        id: id ?? this.id,
        phone: phone ?? this.phone,
        name: name ?? this.name,
        status: status ?? this.status,
        lastEditorId: lastEditorId ?? this.lastEditorId,
      );
  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('lastEditorId: $lastEditorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, phone, name, status, lastEditorId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.phone == this.phone &&
          other.name == this.name &&
          other.status == this.status &&
          other.lastEditorId == this.lastEditorId);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> phone;
  final Value<String> name;
  final Value<int> status;
  final Value<String> lastEditorId;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.lastEditorId = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String phone,
    required String name,
    required int status,
    required String lastEditorId,
  })  : id = Value(id),
        phone = Value(phone),
        name = Value(name),
        status = Value(status),
        lastEditorId = Value(lastEditorId);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? phone,
    Expression<String>? name,
    Expression<int>? status,
    Expression<String>? lastEditorId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (lastEditorId != null) 'last_editor_id': lastEditorId,
    });
  }

  CustomersCompanion copyWith(
      {Value<String>? id,
      Value<String>? phone,
      Value<String>? name,
      Value<int>? status,
      Value<String>? lastEditorId}) {
    return CustomersCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      status: status ?? this.status,
      lastEditorId: lastEditorId ?? this.lastEditorId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (lastEditorId.present) {
      map['last_editor_id'] = Variable<String>(lastEditorId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('lastEditorId: $lastEditorId')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String?> phone = GeneratedColumn<String?>(
      'phone', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int?> status = GeneratedColumn<int?>(
      'status', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _lastEditorIdMeta =
      const VerificationMeta('lastEditorId');
  @override
  late final GeneratedColumn<String?> lastEditorId = GeneratedColumn<String?>(
      'last_editor_id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES users (id)');
  @override
  List<GeneratedColumn> get $columns => [id, phone, name, status, lastEditorId];
  @override
  String get aliasedName => _alias ?? 'customers';
  @override
  String get actualTableName => 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('last_editor_id')) {
      context.handle(
          _lastEditorIdMeta,
          lastEditorId.isAcceptableOrUnknown(
              data['last_editor_id']!, _lastEditorIdMeta));
    } else if (isInserting) {
      context.missing(_lastEditorIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Customer.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final String lang;
  final String theme;
  final String staffId;
  final double taxRate;
  final DateTime loggedInDate;
  Session(
      {required this.id,
      required this.lang,
      required this.theme,
      required this.staffId,
      required this.taxRate,
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
      taxRate: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tax_rate'])!,
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
    map['tax_rate'] = Variable<double>(taxRate);
    map['logged_in_date'] = Variable<DateTime>(loggedInDate);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      lang: Value(lang),
      theme: Value(theme),
      staffId: Value(staffId),
      taxRate: Value(taxRate),
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
      taxRate: serializer.fromJson<double>(json['taxRate']),
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
      'taxRate': serializer.toJson<double>(taxRate),
      'loggedInDate': serializer.toJson<DateTime>(loggedInDate),
    };
  }

  Session copyWith(
          {int? id,
          String? lang,
          String? theme,
          String? staffId,
          double? taxRate,
          DateTime? loggedInDate}) =>
      Session(
        id: id ?? this.id,
        lang: lang ?? this.lang,
        theme: theme ?? this.theme,
        staffId: staffId ?? this.staffId,
        taxRate: taxRate ?? this.taxRate,
        loggedInDate: loggedInDate ?? this.loggedInDate,
      );
  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('theme: $theme, ')
          ..write('staffId: $staffId, ')
          ..write('taxRate: $taxRate, ')
          ..write('loggedInDate: $loggedInDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lang, theme, staffId, taxRate, loggedInDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.lang == this.lang &&
          other.theme == this.theme &&
          other.staffId == this.staffId &&
          other.taxRate == this.taxRate &&
          other.loggedInDate == this.loggedInDate);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<String> lang;
  final Value<String> theme;
  final Value<String> staffId;
  final Value<double> taxRate;
  final Value<DateTime> loggedInDate;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.lang = const Value.absent(),
    this.theme = const Value.absent(),
    this.staffId = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.loggedInDate = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    this.lang = const Value.absent(),
    this.theme = const Value.absent(),
    this.staffId = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.loggedInDate = const Value.absent(),
  });
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<String>? lang,
    Expression<String>? theme,
    Expression<String>? staffId,
    Expression<double>? taxRate,
    Expression<DateTime>? loggedInDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lang != null) 'lang': lang,
      if (theme != null) 'theme': theme,
      if (staffId != null) 'staff_id': staffId,
      if (taxRate != null) 'tax_rate': taxRate,
      if (loggedInDate != null) 'logged_in_date': loggedInDate,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? lang,
      Value<String>? theme,
      Value<String>? staffId,
      Value<double>? taxRate,
      Value<DateTime>? loggedInDate}) {
    return SessionsCompanion(
      id: id ?? this.id,
      lang: lang ?? this.lang,
      theme: theme ?? this.theme,
      staffId: staffId ?? this.staffId,
      taxRate: taxRate ?? this.taxRate,
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
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
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
          ..write('taxRate: $taxRate, ')
          ..write('loggedInDate: $loggedInDate')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
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
  final VerificationMeta _taxRateMeta = const VerificationMeta('taxRate');
  @override
  late final GeneratedColumn<double?> taxRate = GeneratedColumn<double?>(
      'tax_rate', aliasedName, false,
      type: const RealType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
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
      [id, lang, theme, staffId, taxRate, loggedInDate];
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
    if (data.containsKey('tax_rate')) {
      context.handle(_taxRateMeta,
          taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta));
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
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String title;
  final String category;
  final int price;
  final String unit;
  final String? imagePath;
  Product(
      {required this.id,
      required this.title,
      required this.category,
      required this.price,
      required this.unit,
      this.imagePath});
  factory Product.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Product(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      category: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}category'])!,
      price: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}price'])!,
      unit: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unit'])!,
      imagePath: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image_path']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['price'] = Variable<int>(price);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String?>(imagePath);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      title: Value(title),
      category: Value(category),
      price: Value(price),
      unit: Value(unit),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      price: serializer.fromJson<int>(json['price']),
      unit: serializer.fromJson<String>(json['unit']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'price': serializer.toJson<int>(price),
      'unit': serializer.toJson<String>(unit),
      'imagePath': serializer.toJson<String?>(imagePath),
    };
  }

  Product copyWith(
          {String? id,
          String? title,
          String? category,
          int? price,
          String? unit,
          String? imagePath}) =>
      Product(
        id: id ?? this.id,
        title: title ?? this.title,
        category: category ?? this.category,
        price: price ?? this.price,
        unit: unit ?? this.unit,
        imagePath: imagePath ?? this.imagePath,
      );
  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('unit: $unit, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, category, price, unit, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.price == this.price &&
          other.unit == this.unit &&
          other.imagePath == this.imagePath);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> category;
  final Value<int> price;
  final Value<String> unit;
  final Value<String?> imagePath;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.price = const Value.absent(),
    this.unit = const Value.absent(),
    this.imagePath = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String title,
    required String category,
    required int price,
    required String unit,
    this.imagePath = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        category = Value(category),
        price = Value(price),
        unit = Value(unit);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? category,
    Expression<int>? price,
    Expression<String>? unit,
    Expression<String?>? imagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (unit != null) 'unit': unit,
      if (imagePath != null) 'image_path': imagePath,
    });
  }

  ProductsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? category,
      Value<int>? price,
      Value<String>? unit,
      Value<String?>? imagePath}) {
    return ProductsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String?>(imagePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('unit: $unit, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<String?> category = GeneratedColumn<String?>(
      'category', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int?> price = GeneratedColumn<int?>(
      'price', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String?> unit = GeneratedColumn<String?>(
      'unit', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _imagePathMeta = const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String?> imagePath = GeneratedColumn<String?>(
      'image_path', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, category, price, unit, imagePath];
  @override
  String get aliasedName => _alias ?? 'products';
  @override
  String get actualTableName => 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Product.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class ProductAddon extends DataClass implements Insertable<ProductAddon> {
  final String id;
  final String productId;
  final String title;
  final int price;
  ProductAddon(
      {required this.id,
      required this.productId,
      required this.title,
      required this.price});
  factory ProductAddon.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ProductAddon(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      productId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product_id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      price: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}price'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['title'] = Variable<String>(title);
    map['price'] = Variable<int>(price);
    return map;
  }

  ProductAddonsCompanion toCompanion(bool nullToAbsent) {
    return ProductAddonsCompanion(
      id: Value(id),
      productId: Value(productId),
      title: Value(title),
      price: Value(price),
    );
  }

  factory ProductAddon.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductAddon(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      title: serializer.fromJson<String>(json['title']),
      price: serializer.fromJson<int>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'title': serializer.toJson<String>(title),
      'price': serializer.toJson<int>(price),
    };
  }

  ProductAddon copyWith(
          {String? id, String? productId, String? title, int? price}) =>
      ProductAddon(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        title: title ?? this.title,
        price: price ?? this.price,
      );
  @override
  String toString() {
    return (StringBuffer('ProductAddon(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('title: $title, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, title, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductAddon &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.title == this.title &&
          other.price == this.price);
}

class ProductAddonsCompanion extends UpdateCompanion<ProductAddon> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> title;
  final Value<int> price;
  const ProductAddonsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.title = const Value.absent(),
    this.price = const Value.absent(),
  });
  ProductAddonsCompanion.insert({
    required String id,
    required String productId,
    required String title,
    required int price,
  })  : id = Value(id),
        productId = Value(productId),
        title = Value(title),
        price = Value(price);
  static Insertable<ProductAddon> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? title,
    Expression<int>? price,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (title != null) 'title': title,
      if (price != null) 'price': price,
    });
  }

  ProductAddonsCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String>? title,
      Value<int>? price}) {
    return ProductAddonsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductAddonsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('title: $title, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }
}

class $ProductAddonsTable extends ProductAddons
    with TableInfo<$ProductAddonsTable, ProductAddon> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductAddonsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _productIdMeta = const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String?> productId = GeneratedColumn<String?>(
      'product_id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES products (id) ON DELETE CASCADE ON UPDATE CASCADE');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int?> price = GeneratedColumn<int?>(
      'price', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, productId, title, price];
  @override
  String get aliasedName => _alias ?? 'product_addons';
  @override
  String get actualTableName => 'product_addons';
  @override
  VerificationContext validateIntegrity(Insertable<ProductAddon> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  ProductAddon map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ProductAddon.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ProductAddonsTable createAlias(String alias) {
    return $ProductAddonsTable(attachedDatabase, alias);
  }
}

class NewOrderCache extends DataClass implements Insertable<NewOrderCache> {
  final String id;
  final double amount;
  NewOrderCache({required this.id, required this.amount});
  factory NewOrderCache.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return NewOrderCache(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      amount: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  NewOrderCachesCompanion toCompanion(bool nullToAbsent) {
    return NewOrderCachesCompanion(
      id: Value(id),
      amount: Value(amount),
    );
  }

  factory NewOrderCache.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NewOrderCache(
      id: serializer.fromJson<String>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amount': serializer.toJson<double>(amount),
    };
  }

  NewOrderCache copyWith({String? id, double? amount}) => NewOrderCache(
        id: id ?? this.id,
        amount: amount ?? this.amount,
      );
  @override
  String toString() {
    return (StringBuffer('NewOrderCache(')
          ..write('id: $id, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NewOrderCache &&
          other.id == this.id &&
          other.amount == this.amount);
}

class NewOrderCachesCompanion extends UpdateCompanion<NewOrderCache> {
  final Value<String> id;
  final Value<double> amount;
  const NewOrderCachesCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
  });
  NewOrderCachesCompanion.insert({
    required String id,
    this.amount = const Value.absent(),
  }) : id = Value(id);
  static Insertable<NewOrderCache> custom({
    Expression<String>? id,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
    });
  }

  NewOrderCachesCompanion copyWith({Value<String>? id, Value<double>? amount}) {
    return NewOrderCachesCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NewOrderCachesCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $NewOrderCachesTable extends NewOrderCaches
    with TableInfo<$NewOrderCachesTable, NewOrderCache> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NewOrderCachesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double?> amount = GeneratedColumn<double?>(
      'amount', aliasedName, false,
      type: const RealType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [id, amount];
  @override
  String get aliasedName => _alias ?? 'new_order_caches';
  @override
  String get actualTableName => 'new_order_caches';
  @override
  VerificationContext validateIntegrity(Insertable<NewOrderCache> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  NewOrderCache map(Map<String, dynamic> data, {String? tablePrefix}) {
    return NewOrderCache.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $NewOrderCachesTable createAlias(String alias) {
    return $NewOrderCachesTable(attachedDatabase, alias);
  }
}

class NewOrderCacheAddon extends DataClass
    implements Insertable<NewOrderCacheAddon> {
  final String newOrderId;
  final String addonId;
  NewOrderCacheAddon({required this.newOrderId, required this.addonId});
  factory NewOrderCacheAddon.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return NewOrderCacheAddon(
      newOrderId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}new_order_id'])!,
      addonId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}addon_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['new_order_id'] = Variable<String>(newOrderId);
    map['addon_id'] = Variable<String>(addonId);
    return map;
  }

  NewOrderCacheAddonsCompanion toCompanion(bool nullToAbsent) {
    return NewOrderCacheAddonsCompanion(
      newOrderId: Value(newOrderId),
      addonId: Value(addonId),
    );
  }

  factory NewOrderCacheAddon.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NewOrderCacheAddon(
      newOrderId: serializer.fromJson<String>(json['newOrderId']),
      addonId: serializer.fromJson<String>(json['addonId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'newOrderId': serializer.toJson<String>(newOrderId),
      'addonId': serializer.toJson<String>(addonId),
    };
  }

  NewOrderCacheAddon copyWith({String? newOrderId, String? addonId}) =>
      NewOrderCacheAddon(
        newOrderId: newOrderId ?? this.newOrderId,
        addonId: addonId ?? this.addonId,
      );
  @override
  String toString() {
    return (StringBuffer('NewOrderCacheAddon(')
          ..write('newOrderId: $newOrderId, ')
          ..write('addonId: $addonId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(newOrderId, addonId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NewOrderCacheAddon &&
          other.newOrderId == this.newOrderId &&
          other.addonId == this.addonId);
}

class NewOrderCacheAddonsCompanion extends UpdateCompanion<NewOrderCacheAddon> {
  final Value<String> newOrderId;
  final Value<String> addonId;
  const NewOrderCacheAddonsCompanion({
    this.newOrderId = const Value.absent(),
    this.addonId = const Value.absent(),
  });
  NewOrderCacheAddonsCompanion.insert({
    required String newOrderId,
    required String addonId,
  })  : newOrderId = Value(newOrderId),
        addonId = Value(addonId);
  static Insertable<NewOrderCacheAddon> custom({
    Expression<String>? newOrderId,
    Expression<String>? addonId,
  }) {
    return RawValuesInsertable({
      if (newOrderId != null) 'new_order_id': newOrderId,
      if (addonId != null) 'addon_id': addonId,
    });
  }

  NewOrderCacheAddonsCompanion copyWith(
      {Value<String>? newOrderId, Value<String>? addonId}) {
    return NewOrderCacheAddonsCompanion(
      newOrderId: newOrderId ?? this.newOrderId,
      addonId: addonId ?? this.addonId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (newOrderId.present) {
      map['new_order_id'] = Variable<String>(newOrderId.value);
    }
    if (addonId.present) {
      map['addon_id'] = Variable<String>(addonId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NewOrderCacheAddonsCompanion(')
          ..write('newOrderId: $newOrderId, ')
          ..write('addonId: $addonId')
          ..write(')'))
        .toString();
  }
}

class $NewOrderCacheAddonsTable extends NewOrderCacheAddons
    with TableInfo<$NewOrderCacheAddonsTable, NewOrderCacheAddon> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NewOrderCacheAddonsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _newOrderIdMeta = const VerificationMeta('newOrderId');
  @override
  late final GeneratedColumn<String?> newOrderId = GeneratedColumn<String?>(
      'new_order_id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES new_order_caches (id)');
  final VerificationMeta _addonIdMeta = const VerificationMeta('addonId');
  @override
  late final GeneratedColumn<String?> addonId = GeneratedColumn<String?>(
      'addon_id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  @override
  List<GeneratedColumn> get $columns => [newOrderId, addonId];
  @override
  String get aliasedName => _alias ?? 'new_order_cache_addons';
  @override
  String get actualTableName => 'new_order_cache_addons';
  @override
  VerificationContext validateIntegrity(Insertable<NewOrderCacheAddon> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('new_order_id')) {
      context.handle(
          _newOrderIdMeta,
          newOrderId.isAcceptableOrUnknown(
              data['new_order_id']!, _newOrderIdMeta));
    } else if (isInserting) {
      context.missing(_newOrderIdMeta);
    }
    if (data.containsKey('addon_id')) {
      context.handle(_addonIdMeta,
          addonId.isAcceptableOrUnknown(data['addon_id']!, _addonIdMeta));
    } else if (isInserting) {
      context.missing(_addonIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  NewOrderCacheAddon map(Map<String, dynamic> data, {String? tablePrefix}) {
    return NewOrderCacheAddon.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $NewOrderCacheAddonsTable createAlias(String alias) {
    return $NewOrderCacheAddonsTable(attachedDatabase, alias);
  }
}

class CustomerCache extends DataClass implements Insertable<CustomerCache> {
  final int id;
  final String customerId;
  CustomerCache({required this.id, required this.customerId});
  factory CustomerCache.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CustomerCache(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      customerId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}customer_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_id'] = Variable<String>(customerId);
    return map;
  }

  CustomerCachesCompanion toCompanion(bool nullToAbsent) {
    return CustomerCachesCompanion(
      id: Value(id),
      customerId: Value(customerId),
    );
  }

  factory CustomerCache.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerCache(
      id: serializer.fromJson<int>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerId': serializer.toJson<String>(customerId),
    };
  }

  CustomerCache copyWith({int? id, String? customerId}) => CustomerCache(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
      );
  @override
  String toString() {
    return (StringBuffer('CustomerCache(')
          ..write('id: $id, ')
          ..write('customerId: $customerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, customerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerCache &&
          other.id == this.id &&
          other.customerId == this.customerId);
}

class CustomerCachesCompanion extends UpdateCompanion<CustomerCache> {
  final Value<int> id;
  final Value<String> customerId;
  const CustomerCachesCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
  });
  CustomerCachesCompanion.insert({
    this.id = const Value.absent(),
    required String customerId,
  }) : customerId = Value(customerId);
  static Insertable<CustomerCache> custom({
    Expression<int>? id,
    Expression<String>? customerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
    });
  }

  CustomerCachesCompanion copyWith(
      {Value<int>? id, Value<String>? customerId}) {
    return CustomerCachesCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerCachesCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId')
          ..write(')'))
        .toString();
  }
}

class $CustomerCachesTable extends CustomerCaches
    with TableInfo<$CustomerCachesTable, CustomerCache> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomerCachesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _customerIdMeta = const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String?> customerId = GeneratedColumn<String?>(
      'customer_id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  @override
  List<GeneratedColumn> get $columns => [id, customerId];
  @override
  String get aliasedName => _alias ?? 'customer_caches';
  @override
  String get actualTableName => 'customer_caches';
  @override
  VerificationContext validateIntegrity(Insertable<CustomerCache> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerCache map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CustomerCache.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CustomerCachesTable createAlias(String alias) {
    return $CustomerCachesTable(attachedDatabase, alias);
  }
}

abstract class _$DriftDB extends GeneratedDatabase {
  _$DriftDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $UsersTable users = $UsersTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductAddonsTable productAddons = $ProductAddonsTable(this);
  late final $NewOrderCachesTable newOrderCaches = $NewOrderCachesTable(this);
  late final $NewOrderCacheAddonsTable newOrderCacheAddons =
      $NewOrderCacheAddonsTable(this);
  late final $CustomerCachesTable customerCaches = $CustomerCachesTable(this);
  late final UserDao userDao = UserDao(this as DriftDB);
  late final CustomerDao customerDao = CustomerDao(this as DriftDB);
  late final SessionDao sessionDao = SessionDao(this as DriftDB);
  late final ProductDao productDao = ProductDao(this as DriftDB);
  late final NewOrderCacheDao newOrderCacheDao =
      NewOrderCacheDao(this as DriftDB);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        customers,
        sessions,
        products,
        productAddons,
        newOrderCaches,
        newOrderCacheAddons,
        customerCaches
      ];
}
