import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckoutPayment extends StatelessWidget {
  const CheckoutPayment(this.padding) : super(key: null);

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: padding.horizontal, vertical: 7),
      child: Column(
        children: [
          _buildInfoSubset("Subtotal", 100000, textColor, 12, null),
          _buildInfoSubset("Taxes", 10000, textColor, 12, null),
          _buildInfoSubset("Total", 90000, textColor, 15, FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildInfoSubset(String field, int value, Color fontColor,
      double? fontSize, FontWeight? fontWeight) {
    final currency = NumberFormat("#,###", "id").format(value);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            field,
            style: TextStyle(
              fontSize: fontSize == null ? null : fontSize + 1,
              fontWeight: fontWeight,
              color: fontColor,
            ),
          ),
          Text(
            "Rp. " + currency,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: fontColor,
            ),
          ),
        ],
      ),
    );
  }
}
