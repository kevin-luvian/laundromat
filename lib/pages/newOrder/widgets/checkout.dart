import 'package:flutter/material.dart';
import 'package:laundry/pages/newOrder/widgets/checkoutDrawer.dart';
import 'package:laundry/pages/newOrder/widgets/checkoutHeader.dart';
import 'package:laundry/pages/newOrder/widgets/checkoutOrderItem.dart';
import 'package:laundry/pages/newOrder/widgets/checkoutPayment.dart';
import 'package:laundry/pages/newOrder/widgets/checkoutPaymentAction.dart';

class Checkout extends StatelessWidget {
  const Checkout({Key? key, required this.padding}) : super(key: key);

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
    ]);
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
