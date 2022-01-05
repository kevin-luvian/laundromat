import 'dart:ui' as dui;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/l10n/supported_locale.dart';

class LocaleCubit extends Cubit<dui.Locale> {
  LocaleCubit() : super(const dui.Locale("id"));

  void setLocale(dui.Locale locale) {
    if (!L10n.support.contains(locale)) return;
    emit(locale);
  }
}
