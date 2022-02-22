import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/newOrder/new_order_bloc.dart';
import 'package:laundry/common/confirmation_dialog.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/pages/new_order/widgets/checkout_dialog/checkout_dialog.dart';
import 'package:laundry/print_handlers/print_orders.dart';
import 'package:laundry/running_assets/dao_access.dart';

class CheckoutPaymentAction extends StatefulWidget {
  const CheckoutPaymentAction(this.padding) : super(key: null);

  final EdgeInsets padding;

  @override
  _CheckoutPaymentActionState createState() => _CheckoutPaymentActionState();
}

class _CheckoutPaymentActionState extends State<CheckoutPaymentAction> {
  late StreamSubscription _listener;
  int ordersLength = 0;

  @override
  void initState() {
    _listener = newOrderCacheDao
        .streamOrdersLength()
        .listen((length) => setState(() => ordersLength = length));
    super.initState();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  build(context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          widget.padding.left, 0, widget.padding.right, widget.padding.bottom),
      child: Column(
        children: [
          _buildActionCheckout(context),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildButtonActions(context),
          )
        ],
      ),
    );
  }

  List<Widget> _buildButtonActions(BuildContext context) {
    return [
      _buildActionSubset(
        icon: Icons.print_outlined,
        color: Colors.blueAccent,
        onPressed: () async {
          final orders = await newOrderCacheDao.allOrderDetails();
          final staff = await sessionDao.currentUser;
          final customer = await newOrderCacheDao.currentCustomer;
          final orderId = await ordersDao.generateOrderId(DateTime.now());
          final file = await buildOrdersAsFile(
              orderId: orderId,
              orders: orders,
              staff: staff!,
              customer: customer);
          if (file == null) return;
          var decodedImage = await decodeImageFromList(file.readAsBytesSync());
          await showDialog<void>(
            context: context,
            builder: (_ctx) => AlertDialog(
              backgroundColor: colorScheme(context).primary,
              content: Card(
                child: SingleChildScrollView(
                  child: IntrinsicHeight(
                    child: Image.file(
                      file,
                      height: decodedImage.height.toDouble(),
                      width: decodedImage.width.toDouble(),
                    ),
                  ),
                ),
              ),
            ),
          );
          await file.delete();
        },
      ),
    ];
  }

  Widget _buildActionCheckout(BuildContext context) {
    return Row(
      children: [
        RectButton(
          disabled: ordersLength <= 0,
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (_) => ConfirmationDialog(
                content: "Remove current orders?",
                onContinue: () =>
                    context.read<NewOrderBloc>().add(ClearCachesEvent()),
              ),
            );
          },
          color: Colors.redAccent,
          size: const Size(50, 50),
          child: const Icon(Icons.delete),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: RectButton(
            disabled: ordersLength <= 0,
            onPressed: () =>
                showCheckoutDialog(context, context.read<NewOrderBloc>()),
            size: const Size.fromHeight(50),
            child: Text(
              l10n(context)?.checkout ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionSubset({
    required IconData icon,
    required Color color,
    required void Function() onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.all(5),
        minimumSize: const Size.fromRadius(25),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
      ),
      child: Icon(icon, size: 23),
    );
  }
}
