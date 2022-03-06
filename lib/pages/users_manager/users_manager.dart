import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/users/user_editor_bloc.dart';
import 'package:laundry/blocs/users/users_view_bloc.dart';
import 'package:laundry/common/right_drawer.dart';
import 'package:laundry/cubits/right_drawer.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/pages/users_manager/widgets/create_user_right_drawer.dart';
import 'package:laundry/pages/users_manager/widgets/update_user_right_drawer.dart';
import 'package:laundry/pages/users_manager/widgets/user_left_drawer.dart';
import 'package:laundry/pages/users_manager/widgets/users_view.dart';
import 'package:laundry/running_assets/db_access.dart';

class UsersManagerPage extends StatelessWidget {
  const UsersManagerPage({Key? key}) : super(key: key);

  MultiBlocProvider _attachProviders({required Widget child}) =>
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => RightDrawerCubit()),
          BlocProvider(create: (_) => UsersViewBloc(driftDB)),
          BlocProvider(
            create: (_ctx) =>
                UserEditorBloc(driftDB, eventDB, _ctx.read<RightDrawerCubit>()),
          ),
        ],
        child: child,
      );

  @override
  Widget build(context) {
    return _attachProviders(
      child: _buildDrawer(
        context: context,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [UserLeftDrawer(), UsersView()],
        ),
      ),
    );
  }

  Widget _buildDrawer({required BuildContext context, required Widget child}) =>
      BlocBuilder<RightDrawerCubit, RightDrawerState>(
        builder: (_, state) {
          late RightDrawerContent content;
          if (state.index == createUserIndex) {
            content = RightDrawerContent(
                label: capitalizeLetter(l10n(context)?.create_user),
                child: const CreateUserForm());
          } else {
            content = RightDrawerContent(
                label: capitalizeLetter(l10n(context)?.update_user),
                child: const UpdateUserForm());
          }
          return RightDrawer(content: content, child: child);
        },
      );
}
