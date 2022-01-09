import 'package:drift/drift.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/sessions.dart';

part 'session.g.dart';

const defaultSession =
    SessionsCompanion(lang: Value("id"), theme: Value("red_velvet"));

@DriftAccessor(tables: [Sessions])
class SessionDao extends DatabaseAccessor<DriftDB> with _$SessionDaoMixin {
  SessionDao(DriftDB db) : super(db);

  Future<Session> find() async {
    final setting = await (select(sessions)..limit(1)).getSingleOrNull();
    if (setting == null) {
      return await into(sessions).insertReturning(defaultSession);
    }
    return setting;
  }

  Future<void> mutate(SessionsCompanion s) async {
    final setting = await find();
    await (update(sessions)..where((s) => s.id.equals(setting.id))).write(s);
  }
}
