import 'dart:ui' as dui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:laundry/blocs/auth/bloc.dart';
import 'package:laundry/cubits/locale.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/helpers/db_connection.dart';
import 'package:laundry/l10n/supported_locale.dart';
import 'package:laundry/layouts/authStaff.dart';
import 'package:laundry/styles/theme.dart';

void _registerGetIt() {
  GetIt.I.registerSingleton(DriftDB(openReadDBConnection()));
  GetIt.I.registerSingleton(EventDB(openEventDBConnection()));
}

void main() {
  _registerGetIt();
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return _globalStates(BlocBuilder<LocaleCubit, dui.Locale>(
      builder: (context, currLocale) {
        return MaterialApp(
          title: 'Flutter Demos',
          theme: mainTheme,
          home: const AuthStaffLayout(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: currLocale,
          supportedLocales: L10n.support,
        );
      },
    ));
  }

  Widget _globalStates(Widget child) {
    final _db = GetIt.I.get<DriftDB>();
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(_db)),
        BlocProvider<LocaleCubit>(
          create: (_) => LocaleCubit(_db)..setupLocale(),
        ),
      ],
      child: child,
    );
  }
}
