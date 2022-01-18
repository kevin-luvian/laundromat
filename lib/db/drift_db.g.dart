// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final int pin;
  final String password;
  final String role;
  User(
      {required this.id,
      required this.name,
      required this.pin,
      required this.password,
      required this.role});
  factory User.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return User(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      pin: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pin'])!,
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
    map['pin'] = Variable<int>(pin);
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      pin: Value(pin),
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
      pin: serializer.fromJson<int>(json['pin']),
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
      'pin': serializer.toJson<int>(pin),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(role),
    };
  }

  User copyWith(
          {String? id,
          String? name,
          int? pin,
          String? password,
          String? role}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        pin: pin ?? this.pin,
        password: password ?? this.password,
        role: role ?? this.role,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pin: $pin, ')
          ..write('password: $password, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, pin, password, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.pin == this.pin &&
          other.password == this.password &&
          other.role == this.role);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> pin;
  final Value<String> password;
  final Value<String> role;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pin = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    required int pin,
    required String password,
    required String role,
  })  : id = Value(id),
        name = Value(name),
        pin = Value(pin),
        password = Value(password),
        role = Value(role);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? pin,
    Expression<String>? password,
    Expression<String>? role,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pin != null) 'pin': pin,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? pin,
      Value<String>? password,
      Value<String>? role}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pin: pin ?? this.pin,
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
    if (pin.present) {
      map['pin'] = Variable<int>(pin.value);
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
          ..write('pin: $pin, ')
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
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _pinMeta = const VerificationMeta('pin');
  @override
  late final GeneratedColumn<int?> pin = GeneratedColumn<int?>(
      'pin', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
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
  List<GeneratedColumn> get $columns => [id, name, pin, password, role];
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

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String title;
  final String category;
  final int price;
  final String unit;
  Product(
      {required this.id,
      required this.title,
      required this.category,
      required this.price,
      required this.unit});
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
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      title: Value(title),
      category: Value(category),
      price: Value(price),
      unit: Value(unit),
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
    };
  }

  Product copyWith(
          {String? id,
          String? title,
          String? category,
          int? price,
          String? unit}) =>
      Product(
        id: id ?? this.id,
        title: title ?? this.title,
        category: category ?? this.category,
        price: price ?? this.price,
        unit: unit ?? this.unit,
      );
  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, category, price, unit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.price == this.price &&
          other.unit == this.unit);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> category;
  final Value<int> price;
  final Value<String> unit;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.price = const Value.absent(),
    this.unit = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String title,
    required String category,
    required int price,
    required String unit,
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (unit != null) 'unit': unit,
    });
  }

  ProductsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? category,
      Value<int>? price,
      Value<String>? unit}) {
    return ProductsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
      unit: unit ?? this.unit,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ProductsTable(this._db, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, title, category, price, unit];
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
    return $ProductsTable(_db, alias);
  }
}

abstract class _$DriftDB extends GeneratedDatabase {
  _$DriftDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $UsersTable users = $UsersTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final UserDao userDao = UserDao(this as DriftDB);
  late final SessionDao sessionDao = SessionDao(this as DriftDB);
  late final ProductDao productDao = ProductDao(this as DriftDB);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, sessions, products];
}