import 'package:drift/drift.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/sessions.dart';

part 'session.g.dart';

enum ThemeChoice { crimson, ocean }
enum LocaleChoice { id, en }

const _sessionId = 10;
final defaultSession = Session(
  id: _sessionId,
  lang: LocaleChoice.id.name,
  theme: ThemeChoice.crimson.name,
  loggedInDate: DateTime(0),
  staffId: '',
);

@DriftAccessor(tables: [Sessions])
class SessionDao extends DatabaseAccessor<DriftDB> with _$SessionDaoMixin {
  SessionDao(DriftDB db) : super(db);

  Future<Session> find() async {
    final session = await (select(sessions)
          ..where((s) => s.id.equals(_sessionId)))
        .getSingleOrNull();
    if (session == null) {
      await into(sessions).insert(defaultSession);
      return find();
    }
    return session;
  }

  Future<void> mutate(SessionsCompanion s) async {
    final session = await find();
    await (update(sessions)..where((s) => s.id.equals(session.id))).write(s);
  }
}
