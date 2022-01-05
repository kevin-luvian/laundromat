import 'dart:ui' as dui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:laundry/blocs/account/bloc.dart';
import 'package:laundry/cubits/locale.dart';
import 'package:laundry/l10n/supported_locale.dart';
import 'package:laundry/layouts/authStaff.dart';
import 'package:laundry/styles/theme.dart';

void main() {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountBloc>(
          create: (_) => AccountBloc(),
        ),
        BlocProvider<LocaleCubit>(
          create: (_) => LocaleCubit(),
        ),
      ],
      child: child,
    );
  }
}
