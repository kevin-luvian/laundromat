import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:laundry/blocs/users/user_editor_bloc.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/db/tables/users.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/input_decoration.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:laundry/helpers/validators.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/running_assets/dao_access.dart';

class CreateUserForm extends StatefulWidget {
  const CreateUserForm({Key? key}) : super(key: key);

  @override
  _CreateUserFormState createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  final _formKey = GlobalKey<FormState>();
  final nameCtr = TextEditingController();
  final passwordCtr = TextEditingController();
  final pinCtr = TextEditingController();
  String selectedRole = roleStaff;
  List<String> selectableRoles = [];

  @override
  void initState() {
    sessionDao.selectableRoles
        .then((roles) => setState(() => selectableRoles = roles));
    super.initState();
  }

  void clearState() {
    _formKey.currentState?.reset();
    setState(() => selectedRole = roleStaff);
    nameCtr.clear();
    passwordCtr.clear();
    pinCtr.clear();
  }

  void submitState(UserEditorBloc userEditorBloc) {
    if (!cnord(_formKey.currentState?.validate(), false)) {
      return;
    }

    userEditorBloc.add(CreateUserEvent(
        nameCtr.text, passwordCtr.text, selectedRole, pinCtr.text));
  }

  Widget _blocListener({required Widget child}) {
    return BlocListener<UserEditorBloc, UserEditorState>(
      listener: (_ctx, _state) {
        switch (_state.runtimeType) {
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
                  decoration: inputDecoration(context, "password"),
                  controller: passwordCtr,
                  validator: (s) => notEmptyText(context, s),
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

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          RectButton(
            size: const Size(50, 45),
            child: const Icon(Icons.delete_outline_rounded),
            onPressed: clearState,
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
      return "${l10n(context)?.please_enter_some_text}";
    }
    if (value.length < 4) {
      return "${l10n(context)?.pin_must_be_a_4_digit_number}";
    }
    return null;
  }
}
