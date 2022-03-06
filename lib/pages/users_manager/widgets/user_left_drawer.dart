import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/users/user_editor_bloc.dart';
import 'package:laundry/blocs/users/users_view_bloc.dart';
import 'package:laundry/common/left_persistent_drawer.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/l10n/access_locale.dart';

class UserSelector {
  final String label;
  final void Function() onPressed;

  UserSelector(this.label, this.onPressed);
}

class UserLeftDrawer extends StatefulWidget {
  const UserLeftDrawer({Key? key}) : super(key: key);

  @override
  _UserLeftDrawerState createState() => _UserLeftDrawerState();
}

class _UserLeftDrawerState extends State<UserLeftDrawer> {
  final EdgeInsets _padding = const EdgeInsets.all(10);
  final double _contentGap = 7.0;

  List<UserSelector> selectors = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      selectors = [
        // UserSelector(l10n(context)?.deleted_user ?? "deleted users", () {
        //   context.read<UsersViewBloc>().add(FindDeletedUserEvent());
        // }),
        UserSelector(l10n(context)?.inactive_user ?? "inactive users", () {
          context.read<UsersViewBloc>().add(FindInactiveUserEvent());
        }),
        UserSelector(l10n(context)?.active_user ?? "active users", () {
          context.read<UsersViewBloc>().add(FindActiveUserEvent());
        }),
      ];
      selectedIndex = selectors.length - 1;
      selectors.elementAt(selectedIndex).onPressed();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return LeftPersistentDrawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          _userSelector(),
          _createAddButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12, width: 1.5),
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(_padding.left, _padding.top, _padding.right, 7),
        child: Text(
          capitalizeFirstLetter(l10n(context)?.users),
          style: TextStyle(
            color: colorScheme(context).primary,
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget _userSelector() {
    return Flexible(
      fit: FlexFit.loose,
      child: ListView.builder(
        reverse: true,
        itemCount: selectors.length,
        itemBuilder: (_, i) {
          final elem = selectors.elementAt(i);
          return _selectorButton(
            selectedIndex == i,
            elem.label,
            () {
              setState(() => selectedIndex = i);
              elem.onPressed();
            },
          );
        },
      ),
    );
  }

  Widget _selectorButton(
    bool isSelected,
    String text,
    void Function() onPressed,
  ) {
    final secondary = colorScheme(context).secondary;
    final onSurface = colorScheme(context).onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: RectButton(
        onPressed: onPressed,
        color: isSelected ? secondary : Colors.white,
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : onSurface),
        ),
      ),
    );
  }

  Widget _createAddButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _padding.left,
        _contentGap,
        _padding.right,
        _padding.bottom,
      ),
      child: RectButton(
        onPressed: () =>
            context.read<UserEditorBloc>().add(OpenCreateUserEvent()),
        child: const Icon(Icons.add, size: 20),
      ),
    );
  }
}
