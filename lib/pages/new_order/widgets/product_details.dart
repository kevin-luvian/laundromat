import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/newOrder/new_order_bloc.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/input_decoration.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:laundry/l10n/access_locale.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Product? product;
  List<ProductAddon> addons = [];
  File? productImage;
  String title = "";
  String unit = "";
  int price = 0;

  double amount = 1;

  List<ProductAddon> selectedAddons = [];

  void fromProductState(OpenedProductState state) {
    setState(() {
      product = state.product;
      addons = state.addons;
      title = state.product.title;
      unit = state.product.unit;
      price = state.product.price;
      if (state.product.imagePath != null) {
        productImage = File(state.product.imagePath!);
      } else {
        productImage = null;
      }

      selectedAddons = state.selectedAddons;
      amount = state.amount;
    });
  }

  void handleSubmit() {
    if (product == null) return;
    context
        .read<NewOrderBloc>()
        .add(ModifyProductEvent(product!, selectedAddons, amount));
  }

  void toggleAddon(ProductAddon addon) {
    setState(() {
      if (!selectedAddons.contains(addon)) {
        selectedAddons.add(addon);
      } else {
        selectedAddons.remove(addon);
      }
    });
  }

  void modifyAmount(double val) {
    if (val < 0) val = 0;
    setState(() => amount = val);
  }

  String get amountStr => doubleToString(amount);

  double get totalPrice {
    double totalPrice = price.toDouble();
    if (selectedAddons.isNotEmpty) {
      totalPrice +=
          selectedAddons.map((a) => a.price).reduce((val, sum) => sum + val);
    }
    return totalPrice * amount;
  }

  @override
  Widget build(context) {
    return BlocListener<NewOrderBloc, NewOrderState>(
      listener: (_, state) {
        switch (state.runtimeType) {
          case OpenedProductState:
            fromProductState(state as OpenedProductState);
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildContents(), _buildActions()],
        ),
      ),
    );
  }

  Widget _buildContents() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          _buildImage(),
          const SizedBox(height: 15),
          _buildDetailElement(
            label: capitalizeFirstLetter(l10n(context)?.price),
            content: Text(customPriceFormat(price) + "/" + unit),
          ),
          const SizedBox(height: 15),
          _addons(),
        ]),
      ),
    );
  }

  Widget _addons() {
    if (addons.isEmpty) return Container();
    final color = colorScheme(context).primary;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            capitalizeFirstLetter(l10n(context)?.addons),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 5),
          for (final addon in addons) _buildAddonElement(addon),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDetailElement({required String label, required Widget content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme(context).primary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        content,
      ],
    );
  }

  Widget _buildAddonElement(ProductAddon addon) {
    final isChecked = selectedAddons.contains(addon);
    final color = colorScheme(context).primary;
    final onColor = colorScheme(context).onPrimary;
    return Row(
      children: [
        Checkbox(
          visualDensity: VisualDensity.compact,
          checkColor: onColor,
          fillColor: MaterialStateProperty.all(color),
          value: isChecked,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onChanged: (_) => toggleAddon(addon),
        ),
        InkWell(
          onTap: () => toggleAddon(addon),
          child: Text(addon.title, style: const TextStyle(height: 1)),
        ),
        const Spacer(),
        Text(customPriceFormat(addon.price)),
      ],
    );
  }

  Widget _buildActions() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RectButton(
                  size: const Size(35, 40),
                  child: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                  onPressed: () => modifyAmount(amount - 1),
                ),
                InkWell(
                  onTap: () async {
                    final amountCtr = TextEditingController(text: amountStr);
                    await showDialog<void>(
                      context: context,
                      builder: (_) => AdjustAmountForm(amountCtr),
                    );
                    final val = double.tryParse(amountCtr.text);
                    if (val != null) modifyAmount(val);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Text(
                      amountStr + " " + unit,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: colorScheme(context).secondary,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ),
                RectButton(
                  size: const Size(35, 40),
                  child: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                  onPressed: () => modifyAmount(amount + 1),
                ),
              ],
            ),
            const SizedBox(height: 10),
            RectButton(
              onPressed: handleSubmit,
              size: const Size.fromHeight(50),
              child: Text(
                amount <= 0
                    ? "${l10n(context)?.remove_order}"
                    : "${l10n(context)?.add_to_order} - ${decimalPriceFormatter.format(totalPrice)}",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

  Widget _buildImage() => productImage == null
      ? Image.asset(
          'assets/images/placeholder.png',
          fit: BoxFit.fitWidth,
          height: 170,
          width: double.infinity,
        )
      : Image.file(
          productImage!,
          fit: BoxFit.fitWidth,
          height: 170,
          width: double.infinity,
        );
}

class AdjustAmountForm extends StatelessWidget {
  const AdjustAmountForm(this.amountCtr, {Key? key}) : super(key: key);

  final TextEditingController amountCtr;

  @override
  Widget build(context) {
    return AlertDialog(
      title: const Text(
        'Change Amount',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 350,
        child: TextFormField(
          controller: amountCtr,
          keyboardType: TextInputType.number,
          decoration: inputDecoration(context, "amount"),
          autofocus: true,
          inputFormatters: [
            // no - whitespace and operator
            FilteringTextInputFormatter.deny(
              RegExp("[\\s\\/+*#(),=]"),
              replacementString: "",
            ),
            // no - behind
            FilteringTextInputFormatter.deny(
              RegExp("(?<!^)-"),
              replacementString: "",
            ),
            // only one . (dot)
            FilteringTextInputFormatter.deny(
              RegExp('[\\.]+'),
              replacementString: '.',
            ),
            FilteringTextInputFormatter(
              RegExp('^[-]?[0-9]+\\.?[0-9]*\$'),
              allow: true,
              replacementString: amountCtr.text,
            ),
          ],
        ),
      ),
    );
  }
}
