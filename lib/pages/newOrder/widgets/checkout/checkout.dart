import 'package:flutter/material.dart';
import 'package:laundry/pages/newOrder/widgets/checkout/checkoutDrawer.dart';
import 'package:laundry/pages/newOrder/widgets/checkout/checkoutHeader.dart';
import 'package:laundry/pages/newOrder/widgets/checkout/checkoutOrderItem.dart';
import 'package:laundry/pages/newOrder/widgets/checkout/checkoutPayment.dart';
import 'package:laundry/pages/newOrder/widgets/checkout/checkoutPaymentAction.dart';

class Checkout extends StatelessWidget {
  const Checkout({Key? key, required this.width, required this.padding}) : super(key: key);

  final double width;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: width,
        child: Column(children: [
          CheckoutHeader(padding),
          _buildItems(),
          CheckoutDrawer(
            child: Column(
              children: [
                CheckoutPayment(padding),
                CheckoutPaymentAction(padding),
              ],
            ),
          ),
        ]),
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

  Widget _buildItems() {
    List<MockOrderItem> orderItemList =
        List.generate(20, (index) => MockOrderItem());
    return Expanded(
      child: ListView.builder(
        itemCount: orderItemList.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
          child: CheckoutOrderItem(
            title: orderItemList[index].title,
            amount: orderItemList[index].amount,
            price: orderItemList[index].price,
            unit: orderItemList[index].unit,
          ),
        ),
      ),
    );
  }
}

class MockOrderItem {
  String title = "regular wash";
  int amount = 10;
  double price = 1000.0;
  String unit = "Kg";
}
