import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry/common/inputs/text_auto_complete.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/input_formatter/currency.dart';
import 'package:laundry/helpers/logger.dart';

class CreateProductForm extends StatefulWidget {
  const CreateProductForm({Key? key}) : super(key: key);

  @override
  _CreateProductFormState createState() => _CreateProductFormState();
}

class _CreateProductFormState extends State<CreateProductForm> {
  final _picker = ImagePicker();

  var unitVal = "";
  File? productImage;
  final unitCtr = TextEditingController();
  final categoryCtr = TextEditingController();
  final titleCtr = TextEditingController();
  final priceCtr = TextEditingController();

  clearState() {
    categoryCtr.clear();
    titleCtr.clear();
    priceCtr.clear();
    unitCtr.clear();
    setState(() {
      productImage = null;
    });
  }

  submitState() async {
    logger.i("OnSubmit");
    logger.i(categoryCtr.text);
    logger.i(titleCtr.text);
    logger.i(priceCtr.text);
    logger.i(unitCtr.text);
    if (productImage != null) {
      final pathToSave = await saveExtFile(titleCtr.text, productImage!);
      logger.i(pathToSave);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInputs(context),
        _buildActions(context),
      ],
    );
  }

  Widget _buildActions(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            RectButton(
              size: const Size(40, 45),
              child: const Icon(Icons.delete_outline_rounded),
              onPressed: clearState,
            ),
            const SizedBox(width: 10),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: RectButton(
                onPressed: () => submitState(),
                child: const Text("Save", style: TextStyle(fontSize: 17)),
              ),
            ),
          ],
        ),
      );

  Widget _buildInputs(BuildContext context) => Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
            child: Column(
              children: [
                const SizedBox(height: 15),
                _buildImagePicker(),
                const SizedBox(height: 15),
                TextAutoComplete(
                  controller: categoryCtr,
                  label: "category",
                  options: const [
                    "simple",
                    "package",
                    "simple2",
                    "package2",
                    "simple3",
                    "package3",
                  ],
                ),
                const SizedBox(height: 15),
                TextField(
                  focusNode: FocusNode(),
                  controller: titleCtr,
                  decoration: _decor(context: context, label: "title"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: priceCtr,
                  decoration: _decor(context: context, label: "price"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ],
                ),
                const SizedBox(height: 15),
                TextAutoComplete(
                  controller: unitCtr,
                  label: "unit",
                  options: const ["gr", "kg"],
                ),
                KeyboardVisibilityBuilder(
                  builder: (_, _visible) {
                    final height =
                        _visible ? MediaQuery.of(context).size.height : 1.0;
                    return SizedBox(height: height);
                  },
                ),
              ],
            ),
          ),
        ),
      );

  InputDecoration _decor({
    required BuildContext context,
    required String label,
  }) =>
      InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );

  Widget _buildImagePicker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        productImage != null
            ? Image.file(
                productImage!,
                fit: BoxFit.fitWidth,
                height: 200,
                width: double.infinity,
              )
            : Image.asset(
                'assets/images/placeholder.png',
                fit: BoxFit.fitWidth,
                height: 200,
                width: double.infinity,
              ),
        RectButton(
          size: const Size(70, 40),
          onPressed: () async {
            final pickedFile = await _picker.pickImage(
              source: ImageSource.gallery,
              imageQuality: 50,
            );
            if (pickedFile != null) {
              setState(() => productImage = File(pickedFile.path));
            }
          },
          color: Colors.blueAccent,
          child: const Text(
            "pick image from gallery",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
