import 'package:flutter/material.dart';
import 'package:laundry/pages/newOrder/widgets/checkout.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [_buildSidebar(context)]);
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      child: const SizedBox(
        width: 250,
        child: Checkout(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, .05),
            offset: Offset(6, 0),
            blurRadius: 6,
            spreadRadius: 0,
          )
        ],
      ),
    );
  }
}
