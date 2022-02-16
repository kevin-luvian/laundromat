import 'package:drift/drift.dart';
import 'package:laundry/db/dao/user/user.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/sessions.dart';
import 'package:laundry/db/tables/users.dart';

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
  taxRate: 10,
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

  Future<String> get currentUserId async => (await find()).staffId;

  Future<User?> get currentUser async {
    final id = (await find()).staffId;
    return UserDao(db).findUser(id);
  }

  Future<List<String>> get selectableRoles async {
    final role = (await currentUser)?.role ?? roleStaff;
    switch (role) {
      case roleSuperAdmin:
        return allRoles;
      case roleAdmin:
        return adminSelectableRoles;
      default:
        return [];
    }
  }
}
