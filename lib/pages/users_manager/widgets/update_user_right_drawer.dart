import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:laundry/blocs/users/user_editor_bloc.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/users.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/input_decoration.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:laundry/helpers/validators.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/running_assets/dao_access.dart';

class UpdateUserForm extends StatefulWidget {
  const UpdateUserForm({Key? key}) : super(key: key);

  @override
  _UpdateUserFormState createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<UpdateUserForm> {
  final _formKey = GlobalKey<FormState>();
  final nameCtr = TextEditingController();
  final passwordCtr = TextEditingController();
  final pinCtr = TextEditingController();

  bool isEditSelf = false;
  bool isActive = true;
  String selectedRole = roleStaff;
  List<String> selectableRoles = [];

  User? userToUpdate;

  @override
  void initState() {
    sessionDao.selectableRoles
        .then((roles) => setState(() => selectableRoles = roles));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (userToUpdate == null) {
      final state = context.read<UserEditorBloc>().state;
      if (state.runtimeType == OpenUpdateUserState) {
        final data = (state as OpenUpdateUserState);
        fillUserState(data.user, data.currentUserId);
      }
    }
  }

  void clearState() {
    setState(() {
      userToUpdate = null;
      selectedRole = roleStaff;
      isActive = false;
      isEditSelf = false;
      nameCtr.text = "";
      passwordCtr.text = "";
      pinCtr.text = "";
    });
  }

  void fillUserState(User user, String currentUserId) {
    setState(() {
      selectedRole = user.role;
      userToUpdate = user;
      isActive = user.active;
      isEditSelf = user.id == currentUserId;
      nameCtr.text = user.name;
      passwordCtr.text = "";
      pinCtr.text = user.pin.toString();
    });
  }

  void submitState(UserEditorBloc userEditorBloc) {
    if (!cnord(_formKey.currentState?.validate(), false)) {
      return;
    }

    final prevUser = userToUpdate;
    if (prevUser != null) {
      userEditorBloc.add(UpdateUserEvent(
        prevUser,
        id: prevUser.id,
        name: nameCtr.text,
        password: passwordCtr.text,
        role: selectedRole,
        pin: pinCtr.text,
        active: isActive,
      ));
    }
  }

  Widget _blocListener({required Widget child}) {
    return BlocListener<UserEditorBloc, UserEditorState>(
      listener: (_ctx, _state) {
        switch (_state.runtimeType) {
          case OpenUpdateUserState:
            final data = (_state as OpenUpdateUserState);
            fillUserState(data.user, data.currentUserId);
            break;
          case SuccessState:
            clearState();
            break;
        }
      },
      child: child,
    );
  }

  @override
  Widget build(context) {
    return _blocListener(
      child: Column(children: [_buildInputs(), _buildActions()]),
    );
  }

  Widget _buildInputs() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 15),
                TextFormField(
                  decoration: inputDecoration(context, l10n(context)?.name),
                  controller: nameCtr,
                  validator: (s) => notEmptyText(context, s),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration:
                      inputDecoration(context, l10n(context)?.new_password),
                  controller: passwordCtr,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12),
                    FilteringTextInputFormatter.deny(RegExp("\\s"),
                        replacementString: ""),
                  ],
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: inputDecoration(context, l10n(context)?.role),
                  value: selectedRole,
                  items: selectableRoles
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(userRoleToString(role)),
                          ))
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedRole = value);
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: inputDecoration(context, "pin"),
                  controller: pinCtr,
                  keyboardType: TextInputType.number,
                  validator: pinValidator,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
                if (!isEditSelf)
                  Column(children: [
                    const SizedBox(height: 15),
                    _buildActiveSwitch(),
                  ]),
                KeyboardVisibilityBuilder(
                  builder: (_, _visible) => SizedBox(
                    height: _visible ? screenSize(context).height : 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSwitch() {
    return Row(
      children: [
        FlutterSwitch(
          activeColor: colorScheme(context).primary,
          width: 70,
          height: 30,
          toggleSize: 30,
          value: isActive,
          borderRadius: 30.0,
          onToggle: (val) => setState(() => isActive = val),
        ),
        const SizedBox(width: 10),
        Text(
          isActive ? "${l10n(context)?.active}" : "${l10n(context)?.inactive}",
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          if (!isEditSelf)
            RectButton(
              disabled: true,
              size: const Size(50, 45),
              child: const Icon(Icons.delete_outline_rounded),
              onPressed: () {},
            ),
          const SizedBox(width: 10),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RectButton(
              onPressed: () => submitState(context.read<UserEditorBloc>()),
              child: Text(capitalizeFirstLetter(l10n(context)?.save),
                  style: const TextStyle(fontSize: 17)),
            ),
          ),
        ],
      ),
    );
  }

  String? pinValidator(String? value) {
    if (value == null || value.isEmpty) {
      return l10n(context)?.please_enter_some_text;
    }
    if (value.length < 4) {
      return l10n(context)?.pin_must_be_a_4_digit_number;
    }
    return null;
  }
}
