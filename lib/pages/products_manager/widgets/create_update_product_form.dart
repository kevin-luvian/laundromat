import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry/blocs/products/product_editor_bloc.dart';
import 'package:laundry/common/confirmation_dialog.dart';
import 'package:laundry/common/inputs/text_auto_complete.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/input_decoration.dart';
import 'package:laundry/helpers/input_formatter/currency.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:laundry/helpers/validators.dart';
import 'package:laundry/running_assets/dao_access.dart';

class CreateUpdateProductForm extends StatefulWidget {
  const CreateUpdateProductForm({
    Key? key,
    required this.deleteConfirmation,
  }) : super(key: key);

  final void Function(ConfirmationDialog dialog) deleteConfirmation;

  @override
  _CreateProductFormState createState() => _CreateProductFormState();
}

class _CreateProductFormState extends State<CreateUpdateProductForm> {
  final _picker = ImagePicker();

  Product? productToUpdate;
  File? productImage;
  List<Addon> addons = [];
  final _formKey = GlobalKey<FormState>();
  final unitCtr = TextEditingController();
  final categoryCtr = TextEditingController();
  final titleCtr = TextEditingController();
  final priceCtr = TextEditingController(text: "0");

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.dispose();
  }

  void clearState() {
    _formKey.currentState?.reset();
    categoryCtr.clear();
    titleCtr.clear();
    priceCtr.clear();
    unitCtr.clear();
    setState(() {
      productToUpdate = null;
      productImage = null;
      addons = [];
    });
  }

  void fillUpdateState(Product product) {
    categoryCtr.text = product.category;
    titleCtr.text = product.title;
    priceCtr.text = product.price.toString();
    unitCtr.text = product.unit;
    setState(() {
      productToUpdate = product;
      if (product.imagePath != null) {
        productImage = File(product.imagePath!);
      } else {
        productImage = null;
      }
    });
    productAddonDao.findAllByProductId(product.id).then((pAddons) =>
        setState(() => addons = pAddons.map(Addon.fromProductAddon).toList()));
  }

  void handleDelete(ProductEditorBloc bloc) {
    if (productToUpdate == null) {
      bloc.add(ClearProductEvent());
    } else {
      widget.deleteConfirmation(ConfirmationDialog(
        content: "Delete product permanently?",
        onContinue: () => bloc.add(DeleteProductEvent(productToUpdate!)),
      ));
    }
  }

  void submitState(ProductEditorBloc bloc) async {
    if (!cnord(_formKey.currentState?.validate(), false)) {
      return;
    }

    int price;
    try {
      price = priceFormatter.parse(priceCtr.text).toInt();
    } catch (_) {
      price = 0;
    }

    if (productToUpdate != null) {
      String? pathToSave;
      if (productImage != null &&
          productImage!.path != productToUpdate!.imagePath) {
        pathToSave = await saveExtFile(titleCtr.text, productImage!);
      }

      bloc.add(UpdateProductEvent(
        prevProduct: productToUpdate!,
        category: categoryCtr.text,
        title: titleCtr.text,
        price: price,
        unit: unitCtr.text,
        imagePath: pathToSave,
        addons: addons,
      ));
    } else {
      String? pathToSave;
      if (productImage != null) {
        pathToSave = await saveExtFile(titleCtr.text, productImage!);
      }
      bloc.add(CreateProductEvent(
        category: categoryCtr.text,
        title: titleCtr.text,
        price: price,
        unit: unitCtr.text,
        imagePath: pathToSave,
        addons: addons,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductEditorBloc, ProductEditorState>(
      listener: (_ctx, _state) {
        switch (_state.runtimeType) {
          case ClearProductState:
            clearState();
            break;
          case InitiateCreateProductState:
            if (productToUpdate != null) {
              clearState();
            }
            break;
          case InitiateUpdateProductState:
            final product = (_state as InitiateUpdateProductState).product;
            fillUpdateState(product);
            break;
        }
      },
      child: Column(children: [_buildInputs(context), _buildActions(context)]),
    );
  }

  Widget _buildInputs(BuildContext context) => Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  _buildImagePicker(),
                  const SizedBox(height: 15),
                  StreamBuilder(
                    stream: productDao.distinctCategories,
                    builder: (_ctx, AsyncSnapshot<List<String>> snapshot) =>
                        TextAutoComplete(
                            controller: categoryCtr,
                            label: "category",
                            options: snapshot.hasData ? snapshot.data! : [],
                            validator: notEmptyText),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    focusNode: FocusNode(),
                    controller: titleCtr,
                    validator: notEmptyText,
                    decoration: inputDecoration(context, "title"),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: priceCtr,
                    decoration: inputDecoration(context, "price"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(),
                    ],
                  ),
                  const SizedBox(height: 15),
                  StreamBuilder(
                    stream: productDao.distinctUnits,
                    builder: (_ctx, AsyncSnapshot<List<String>> snapshot) =>
                        TextAutoComplete(
                            controller: unitCtr,
                            label: "unit",
                            options: snapshot.hasData ? snapshot.data! : [],
                            validator: notEmptyText),
                  ),
                  _buildAddonsInput(),
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
        ),
      );

  Widget _buildAddonsInput() {
    final color = colorScheme(context).secondary;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 17),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Addons",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => CreateAddonForm(
                  onSubmit: (title, price) =>
                      setState(() => addons.add(Addon(title, price))),
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(30, 30),
                primary: color,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Icon(Icons.add, size: 17),
            ),
          ],
        ),
        Divider(thickness: 2, color: color),
        for (int i = 0; i < addons.length; i++)
          _buildAddonPreview(
            addons.elementAt(i),
            () => setState(() => addons.removeAt(i)),
          )
      ],
    );
  }

  Widget _buildAddonPreview(Addon addon, void Function() handleDelete) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: handleDelete,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(30, 30),
                primary: colorScheme(context).secondary,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Icon(Icons.remove, size: 17),
            ),
            const SizedBox(width: 10),
            Text(addon.title),
          ]),
          Text(priceFormatter.format(addon.price)),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            RectButton(
              size: const Size(50, 45),
              child: const Icon(Icons.delete_outline_rounded),
              onPressed: () => handleDelete(context.read<ProductEditorBloc>()),
            ),
            const SizedBox(width: 10),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: RectButton(
                onPressed: () => submitState(context.read<ProductEditorBloc>()),
                child: const Text("Save", style: TextStyle(fontSize: 17)),
              ),
            ),
          ],
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
          size: Size.zero,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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

class CreateAddonForm extends StatelessWidget {
  CreateAddonForm({Key? key, required this.onSubmit}) : super(key: key);

  final void Function(String title, int price) onSubmit;
  final _formKey = GlobalKey<FormState>();
  final titleCtr = TextEditingController();
  final priceCtr = TextEditingController(text: "0");

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Create New Addon',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Form(
        key: _formKey,
        child: IntrinsicHeight(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 350,
              child: Column(
                children: [
                  const SizedBox(height: 3),
                  TextFormField(
                    focusNode: FocusNode(),
                    controller: titleCtr,
                    validator: notEmptyText,
                    decoration: inputDecoration(context, "title"),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: priceCtr,
                    decoration: inputDecoration(context, "price"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _actions(context),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: null,
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            if (cnord(_formKey.currentState?.validate(), false)) {
              onSubmit(
                titleCtr.text,
                priceFormatter.parse(priceCtr.text).toInt(),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            titleCtr.clear();
            priceCtr.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        )
      ],
    );
  }
}
