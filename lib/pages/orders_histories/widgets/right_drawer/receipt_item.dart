import 'package:flutter/material.dart';
import 'package:laundry/db/aggregates/product_order_details.dart';
import 'package:laundry/helpers/utils.dart';

class ReceiptItem extends StatelessWidget {
  const ReceiptItem(this.detail) : super(key: null);
  final ProductOrderDetail detail;

  @override
  Widget build(BuildContext context) {
    final title = detail.product.title;
    final addons = detail.addonsStr.map((a) => "- $a");
    final price = "Rp. " + formatPrice(detail.totalPrice);
    final amount = detail.amountStr + " " + detail.product.unit;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              for (final addon in addons) Text(addon),
            ],
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [Text(price), Text(amount)],
          ),
        ),
      ],
    );
  }
}
