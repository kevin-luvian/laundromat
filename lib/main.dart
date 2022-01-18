import 'dart:ui' as dui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:laundry/blocs/auth/bloc.dart';
import 'package:laundry/blocs/auth/event.dart';
import 'package:laundry/common/DismissKeyboard.dart';
import 'package:laundry/common/PageLoader.dart';
import 'package:laundry/cubits/session.dart';
import 'package:laundry/db/dao/session/session.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/user_command.dart';
import 'package:laundry/event_source/projectors/projector_listeners.dart';
import 'package:laundry/helpers/db_connection.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/l10n/supported_locale.dart';
import 'package:laundry/screen_controller.dart';
import 'package:laundry/styles/ocean_theme.dart';
import 'package:laundry/styles/theme.dart';

Future<bool> _registerGetIt() async {
  GetIt.I.registerSingleton(DriftDB(await openReadDBConnection2())..open());
  logger.i("Drift DB connected");

  GetIt.I.registerSingleton(EventDB(await openEventDBConnection2())..open());
  logger.i("Event DB connected");

  GetIt.I.registerSingleton(UserCommand(GetIt.I.get<EventDB>()));
  ProjectorListeners(GetIt.I.get<DriftDB>()).setup();

  // session cubit is registered on main
  GetIt.I.get<SessionCubit>().setup(GetIt.I.get<DriftDB>());
  await Future.delayed(const Duration(milliseconds: 500));
  return true;
}

void main() {
  GetIt.I.registerSingleton(SessionCubit());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<bool> _register = _registerGetIt();

  @override
  Widget build(context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return _materialApp(
      child: FutureBuilder(
        future: _register,
        builder: (_ctx, state) => BlocBuilder<SessionCubit, Session?>(
          builder: (_, _session) {
            if (state.hasData && _session != null) {
              return _globalStates(
                context: _ctx,
                child: const DismissKeyboard(child: ScreenController()),
              );
            }
            return Scaffold(
              body: PageLoader(text: l10n(_ctx)?.loading ?? "..."),
            );
          },
        ),
      ),
    );
  }

  Widget _materialApp({required Widget child}) {
    return BlocProvider<SessionCubit>(
      create: (_) => GetIt.I.get<SessionCubit>(),
      child: BlocBuilder<SessionCubit, Session?>(
        builder: (_, _session) {
          final lang = _session != null ? _session.lang : "id";
          return MaterialApp(
            title: 'Laundromat',
            theme: _whichTheme(_session?.theme),
            home: child,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: dui.Locale(lang),
            supportedLocales: L10n.support,
          );
        },
      ),
    );
  }

  Widget _globalStates({required Widget child, required BuildContext context}) {
    final _db = GetIt.I.get<DriftDB>();
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(_db)..add(CheckAuth())),
      ],
      child: child,
    );
  }

  ThemeData _whichTheme(String? tc) {
    if (tc == ThemeChoice.ocean.name) {
      return oceanTheme;
    }
    return mainTheme;
  }
}
