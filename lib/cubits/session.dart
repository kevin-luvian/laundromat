import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/logger.dart';

class SessionCubit extends Cubit<Session?> {
  SessionDao? _dao;

  SessionCubit() : super(null);

  void setup(DriftDB db) async {
    _dao ??= SessionDao(db);
    await _emitCurrentSession();
  }

  void setTheme(ThemeChoice theme) async {
    final info = SessionsCompanion(theme: Value(theme.name));
    _mutate(info);
  }

  void setLocale(LocaleChoice locale) {
    final info = SessionsCompanion(lang: Value(locale.name));
    _mutate(info);
  }

  Future<void> _mutate(SessionsCompanion sc) async {
    try {
      await _dao!.mutate(sc);
      await _emitCurrentSession();
    } catch (err) {
      loggerStack.e(err);
    }
  }

  Future<void> _emitCurrentSession() async {
    final session = await _dao!.find();
    emit(session);
  }
}
