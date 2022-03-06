import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:laundry/blocs/auth/bloc.dart';
import 'package:laundry/blocs/auth/event.dart';
import 'package:laundry/blocs/auth/state.dart';
import 'package:laundry/l10n/access_locale.dart';

class LogoutSetting extends StatelessWidget {
  const LogoutSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (_, _state) {
      if (_state.runtimeType == Authenticated) {
        return ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(Logout());
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.primary,
            minimumSize: const Size.fromHeight(60.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
          ),
          child: Text(l10n(context)?.change_account ?? ""),
        );
      }
      return Container();
    });
  }
}
