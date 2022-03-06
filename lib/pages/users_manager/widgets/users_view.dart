import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/users/user_editor_bloc.dart';
import 'package:laundry/blocs/users/users_view_bloc.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/users.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/l10n/access_locale.dart';

const _cardRadius = 12.0;
const _cardPaddingVert = 12.0;

class UsersView extends StatelessWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<UsersViewBloc, UsersViewState>(
        builder: (_, _state) {
          if (_state.runtimeType == StreamUsersState) {
            return StreamBuilder<List<User>>(
              stream: (_state as StreamUsersState).stream,
              builder: (_, snapshot) {
                List<User> users = [];
                if (snapshot.hasData) {
                  users = snapshot.data!;
                }
                return users.isNotEmpty
                    ? ListView.separated(
                        itemCount: users.length,
                        itemBuilder: (_ctx, i) =>
                            userCard(_ctx, users.elementAt(i)),
                        separatorBuilder: (_, _i) => const SizedBox(height: 2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15))
                    : const Center(child: Text("Not Found 404"));
              },
            );
          }
          return const Center(child: Text("Error 400"));
        },
      ),
    );
  }

  Widget userCard(BuildContext context, User user) {
    Color accent = Colors.white;
    switch (user.role) {
      case roleSuperAdmin:
        accent = Colors.deepPurpleAccent;
        break;
      case roleAdmin:
        accent = Colors.blueAccent;
        break;
      case roleStaff:
        accent = Colors.yellowAccent;
        break;
    }
    final ago = l10n(context)?.ago;
    final lastLoginDiff = user.lastLogin?.difference(DateTime.now()).abs();
    String lastLoginStr = "-";
    if (lastLoginDiff != null) {
      if (lastLoginDiff.inDays > 0) {
        lastLoginStr =
            lastLoginDiff.inDays.toString() + " ${l10n(context)?.days} $ago";
      } else if (lastLoginDiff.inHours > 0) {
        lastLoginStr =
            lastLoginDiff.inHours.toString() + " ${l10n(context)?.hours} $ago";
      } else if (lastLoginDiff.inMinutes > 0) {
        lastLoginStr = lastLoginDiff.inMinutes.toString() +
            " ${l10n(context)?.minutes} $ago";
      } else {
        lastLoginStr = lastLoginDiff.inSeconds.toString() +
            " ${l10n(context)?.seconds} $ago";
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(_cardRadius),
        onTap: () {
          context.read<UserEditorBloc>().add(OpenUpdateUserEvent(user));
        },
        child: SizedBox(
          height: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(_cardRadius),
                      bottomLeft: Radius.circular(_cardRadius),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: _cardPaddingVert,
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          color: colorScheme(context).onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(userRoleToString(user.role)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    0, _cardPaddingVert, 30, _cardPaddingVert),
                child: Text(
                  "${l10n(context)?.last_login}: $lastLoginStr",
                  style: TextStyle(color: colorScheme(context).onSurface),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
