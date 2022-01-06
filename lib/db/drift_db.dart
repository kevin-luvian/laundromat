import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:laundry/db/dao/event.dart';
import 'package:laundry/db/dao/user.dart';
import 'package:laundry/db/tables/events.dart';
import 'package:laundry/db/tables/users.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'drift_db.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    debugPrint("db folder: " + dbFolder.path);
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Users, Events], daos: [UserDao, EventDao])
class DriftDB extends _$DriftDB {
  DriftDB() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  // TODO: implement migration
  MigrationStrategy get migration =>
      MigrationStrategy(beforeOpen: (details) async {
        if (details.wasCreated) {
          // onCreated
          final userDao = UserDao(this);
          userDao.createUser(const UsersCompanion(
            username: Value("admin"),
            password: Value("password"),
            fullName: Value("the admin"),
            role: Value("admin"),
          ));
        }
      });
}

class DriftDBInstance {
  static DriftDB? _instance;

  static DriftDB getState() {
    _instance ??= DriftDB();
    return _instance!;
  }
}
