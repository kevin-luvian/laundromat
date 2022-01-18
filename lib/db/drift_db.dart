import 'package:drift/drift.dart';
import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/tables/products.dart';
import 'package:laundry/db/tables/sessions.dart';
import 'package:laundry/db/tables/users.dart';
import 'package:laundry/helpers/logger.dart';

part 'drift_db.g.dart';

const tables = [Users, Sessions, Products];
const daos = [UserDao, SessionDao, ProductDao];

@DriftDatabase(tables: tables, daos: daos)
class DriftDB extends _$DriftDB {
  DriftDB(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  open() async {
    await (select(sessions)..where((tbl) => tbl.id.equals(1))).get();
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          logger.i("drift database connected");
        },
      );
}
