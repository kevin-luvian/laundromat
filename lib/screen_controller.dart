import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/auth/bloc.dart';
import 'package:laundry/blocs/auth/state.dart';
import 'package:laundry/common/page_loader.dart';
import 'package:laundry/layouts/auth_admin.dart';
import 'package:laundry/layouts/auth_staff.dart';
import 'package:laundry/layouts/auth_super_admin.dart';
import 'package:laundry/pages/login/login.dart';
import 'package:laundry/pages/pin_input/pin_input.dart';

import 'l10n/access_locale.dart';

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
                } else if (authState.isSuperAdmin) {
                  return const AuthSuperAdminLayout();
                } else {
                  return const AuthStaffLayout();
                }
              case Authenticating:
                return PageLoader(text: l10n(context)?.authenticating ?? "");
              case AuthenticatingPin:
              case AuthenticatingPinFailed:
                return PinInputPage((_state as AuthenticatingPin).pin);
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
