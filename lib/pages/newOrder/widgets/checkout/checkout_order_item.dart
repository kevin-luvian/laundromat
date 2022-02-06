import 'package:flutter/material.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/utils.dart';

class CheckoutOrderItem extends StatelessWidget {
  const CheckoutOrderItem({
    Key? key,
    required this.title,
    required this.amount,
    required this.totalPrice,
    required this.unit,
    this.onTap,
  }) : super(key: key);

  final String title;
  final double amount;
  final int totalPrice;
  final String unit;
  final void Function()? onTap;

  String get amountStr => doubleToString(amount);

  @override
  Widget build(context) {
    return Material(
      color: colorScheme(context).surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const SizedBox(width: 3),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title),
                      const SizedBox(height: 2),
                      Text(
                        "$amountStr $unit",
                        style: const TextStyle(
                          color: Color.fromRGBO(109, 109, 109, 1),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text("Rp. " + formatPrice(totalPrice)),
            ],
          ),
        ),
      ),
    );
  }
}
