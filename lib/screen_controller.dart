import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:laundry/blocs/auth/bloc.dart';
import 'package:laundry/blocs/auth/event.dart';
import 'package:laundry/blocs/auth/state.dart';
import 'package:laundry/common/PageLoader.dart';
import 'package:laundry/layouts/auth_admin.dart';
import 'package:laundry/pages/login/login.dart';

class ScreenController extends StatelessWidget {
  const ScreenController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          builder: (_, _state) {
            switch (_state.runtimeType) {
              case Authenticated:
                final authState = _state as Authenticated;
                if (authState.isAdmin) {
                  return const AuthAdminLayout();
                } else {
                  return Row(children: [
                    Text(
                        "user ${authState.user.name} is authenticated as staff"),
                    TextButton(
                        onPressed: () => context.read<AuthBloc>().add(Logout()),
                        child: const Text("logout")),
                  ]);
                }
              case Authenticating:
                return PageLoader(
                    text: AppLocalizations.of(context)?.authenticating ?? "");
              default:
                return const LoginPage();
            }
          },
          listener: (_, _state) {},
        ),
      ),
    );
  }
}
