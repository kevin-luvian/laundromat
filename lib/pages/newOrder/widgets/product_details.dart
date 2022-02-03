import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/newOrder/newOrderBloc.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/utils.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<ProductAddon> addons = [];
  String title = "";
  String unit = "";
  int price = 0;

  List<ProductAddon> selectedAddons = [];
  int amount = 1;

  fromProductState(OpenedProductState state) {
    setState(() {
      addons = state.addons;
      title = state.product.title;
      unit = state.product.unit;
      price = state.product.price;

      selectedAddons = [];
      amount = 1;
    });
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

  get totalPrice {
    int totalPrice = price;
    if (selectedAddons.isNotEmpty) {
      totalPrice +=
          selectedAddons.map((a) => a.price).reduce((val, sum) => sum + val);
    }
    totalPrice *= amount;
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewOrderBloc, NewOrderState>(
      listener: (_, state) {
        switch (state.runtimeType) {
          case OpenedProductState:
            fromProductState(state as OpenedProductState);
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [const Spacer(), _buildContent(), _buildActions()],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _addons(),
          _buildDetailElement(
            label: "Price",
            content: Text(customPriceFormat(price) + "/" + unit),
          ),
          const SizedBox(height: 5),
          _buildDetailElement(
            label: "Total",
            content: Text(
              customPriceFormat(totalPrice),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _addons() {
    if (addons.isEmpty) return Container();
    final color = colorScheme(context).primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Addons",
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Divider(thickness: 2, color: color),
        for (final addon in addons) _buildAddonElement(addon),
        const SizedBox(height: 10),
      ],
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
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        Text(priceFormatter.format(addon.price)),
      ],
    );
  }

  Widget _buildActions() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RectButton(
              size: const Size(0, 40),
              child: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => setState(() {
                if (amount == 0) return;
                amount -= 1;
              }),
            ),
            InkWell(
              onTap: () => showSnackBar(context, "clicked"),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  amount.toString() + " " + unit,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            RectButton(
              size: const Size(0, 40),
              child: const Icon(Icons.arrow_forward_ios_rounded),
              onPressed: () => setState(() => amount += 1),
            ),
          ],
        ),
      );
}
