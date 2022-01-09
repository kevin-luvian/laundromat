import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:test/test.dart';

void main() {
  late DriftDB db;
  late SessionDao sessionDao;

  setUp(() {
    db = DriftDB(NativeDatabase.memory());
    sessionDao = SessionDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('should be default session', () async {
    final setting = await sessionDao.find();
    expect(setting.lang, defaultSession.lang.value);
    expect(setting.theme, defaultSession.theme.value);
  });

  test('create one session', () async {
    const setting = SessionsCompanion(lang: Value("en"), theme: Value("ocean"));
    await sessionDao.mutate(setting);
    final s = await sessionDao.find();
    expect(s.lang, "en");
    expect(s.theme, "ocean");
  });
}
