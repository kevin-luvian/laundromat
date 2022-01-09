import 'dart:ui' as dui;

import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/l10n/supported_locale.dart';

class LocaleCubit extends Cubit<dui.Locale> {
  final SessionDao _dao;

  LocaleCubit(DriftDB db)
      : _dao = SessionDao(db),
        super(const dui.Locale("id"));

  void setupLocale() async {
    final session = await _dao.find();
    emit(dui.Locale(session.lang));
  }

  void setLocale(dui.Locale locale) async {
    if (!L10n.support.contains(locale)) return;
    try {
      await _dao.mutate(SessionsCompanion(lang: Value(locale.languageCode)));
      emit(locale);
    } catch (err) {
      loggerStack.e(err);
    }
  }
}
