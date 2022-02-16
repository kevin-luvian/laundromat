import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundry/blocs/customer/customer_editor_bloc.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/input_decoration.dart';
import 'package:laundry/helpers/validators.dart';
import 'package:laundry/running_assets/db_access.dart';

void showNewCustomerDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const NewCustomerDialog(),
  );
}

class NewCustomerDialog extends StatefulWidget {
  const NewCustomerDialog() : super(key: null);

  @override
  createState() => _NewCustomerDialogState();
}

class _NewCustomerDialogState extends State<NewCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final nameCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final editorBloc = CustomerEditorBloc(driftDB, eventDB);

  bool get validate {
    bool formValidation = _formKey.currentState?.validate() ?? false;
    if (!formValidation) return false;
    // check customer phone
    return true;
  }

  void handleSave() {
    if (validate) {
      editorBloc.add(CreateCustomerEvent(nameCtr.text, phoneCtr.text));
      Navigator.of(context).pop();
    }
  }

  String? phoneValidation(String? val) {
    if (val == null || val.isEmpty) return 'please enter some text';
    if (val.length < 8) return "phone digit is too short";
  }

  @override
  build(context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      title: Material(
        color: colorScheme(context).surface,
        child: Row(
          children: [
            const SizedBox(width: 80),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Center(
                child: Text(
                  "New Customer",
                  style: TextStyle(
                    color: colorScheme(context).primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Icon(Icons.close, color: colorScheme(context).onSurface),
              ),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
      content: SizedBox(width: screenSize(context).width, child: _contents()),
    );
  }

  Widget _contents() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            children: [
              TextFormField(
                controller: nameCtr,
                validator: notEmptyText,
                keyboardType: TextInputType.name,
                decoration: inputDecoration(context, "name"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneCtr,
                decoration: inputDecoration(context, "phone"),
                validator: phoneValidation,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 20),
              RectButton(onPressed: handleSave, child: const Text("Save")),
            ],
          ),
        ),
      ),
    );
  }
}
