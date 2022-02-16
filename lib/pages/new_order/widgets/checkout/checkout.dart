import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/newOrder/new_order_bloc.dart';
import 'package:laundry/db/aggregates/product_order_details.dart';
import 'package:laundry/pages/new_order/widgets/checkout/checkout_drawer.dart';
import 'package:laundry/pages/new_order/widgets/checkout/checkout_header.dart';
import 'package:laundry/pages/new_order/widgets/checkout/checkout_order_item.dart';
import 'package:laundry/pages/new_order/widgets/checkout/checkout_payment.dart';
import 'package:laundry/pages/new_order/widgets/checkout/checkout_payment_action.dart';
import 'package:laundry/running_assets/dao_access.dart';

class Checkout extends StatelessWidget {
  const Checkout({Key? key, required this.width, required this.padding})
      : super(key: key);

  final double width;
  final EdgeInsets padding;

  @override
  build(context) {
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
                const SizedBox(height: 20),
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
    return StreamBuilder(
      stream: newOrderCacheDao.streamOrderDetails(),
      builder: (_ctx, AsyncSnapshot<List<ProductOrderDetail>> snapshot) {
        if (!snapshot.hasData) return const Spacer();
        final orderDetails = snapshot.data!;
        return Expanded(
          child: ListView.builder(
            itemCount: orderDetails.length,
            itemBuilder: (context, index) => CheckoutOrderItem(
              addons: orderDetails[index]
                  .addons
                  .map((a) => a.title)
                  .toList(growable: false),
              title: orderDetails[index].product.title,
              amount: orderDetails[index].amount,
              totalPrice: orderDetails[index].totalPrice,
              unit: orderDetails[index].product.unit,
              onTap: () => context
                  .read<NewOrderBloc>()
                  .add(OpenProductEvent(orderDetails[index].product)),
            ),
          ),
        );
      },
    );
  }
}
