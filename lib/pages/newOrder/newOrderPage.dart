import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:laundry/pages/newOrder/widgets/checkout.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: const [
      Checkout(
        width: 250,
        padding: EdgeInsets.all(10),
      )
    ]);
  }
}
