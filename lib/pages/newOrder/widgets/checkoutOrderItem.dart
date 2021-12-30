import 'package:flutter/material.dart';
import 'package:laundry/helpers/utils.dart';

class CheckoutOrderItem extends StatelessWidget {
  const CheckoutOrderItem({
    Key? key,
    required this.title,
    required this.amount,
    required this.price,
    required this.unit,
  }) : super(key: key);

  final String title;
  final int amount;
  final double price;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  padding: const EdgeInsets.all(5),
                  minimumSize: const Size.fromWidth(10),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  elevation: 0.0,
                ),
                child: const Icon(Icons.edit, size: 15),
              ),
              const SizedBox(width: 5),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(
                    "$amount $unit",
                    style: const TextStyle(
                      color: Color.fromRGBO(109, 109, 109, 1),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text("Rp. " + formatPrice(price * amount)),
      ],
    );
  }
}
