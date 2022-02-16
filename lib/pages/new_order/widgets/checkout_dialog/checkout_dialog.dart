import 'package:flutter/material.dart';
import 'package:laundry/blocs/newOrder/new_order_bloc.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/running_assets/dao_access.dart';

import 'checkout_confirmation_page.dart';
import 'customer_select_page.dart';

void showCheckoutDialog(BuildContext context, NewOrderBloc bloc) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_ctx) => CheckoutDialog(bloc),
  );
}

class CheckoutDialog extends StatefulWidget {
  const CheckoutDialog(this.bloc) : super(key: null);

  final NewOrderBloc bloc;

  @override
  _CheckoutDialogState createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  Customer? selectedCustomer;
  int currIndex = 0;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 2);
    _controller
        .addListener(() => setState(() => currIndex = _controller.index));
    newOrderCacheDao.currentCustomer
        .then((data) => setState(() => selectedCustomer = data));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void close() => Navigator.of(context).pop();

  void clearOrder() => widget.bloc.add(ClearCachesEvent());

  void handleCustomerContinue() => _controller.animateTo(1);

  @override
  build(context) {
    const buttonPadding = EdgeInsets.symmetric(vertical: 15, horizontal: 30);
    const buttonRadius = BorderRadius.all(Radius.circular(5));
    final buttonColor = colorScheme(context).onSurface;
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      title: Material(
        color: colorScheme(context).surface,
        child: Row(
          children: [
            currIndex == 1
                ? InkWell(
                    borderRadius: buttonRadius,
                    onTap: () => _controller.animateTo(0),
                    child: Padding(
                      padding: buttonPadding,
                      child: Icon(Icons.arrow_back_ios_rounded,
                          color: buttonColor, size: 20),
                    ),
                  )
                : const SizedBox(width: 80),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Center(
                child: Text(
                  "Checkout",
                  style: TextStyle(
                    color: colorScheme(context).primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            InkWell(
              borderRadius: buttonRadius,
              onTap: close,
              child: Padding(
                padding: buttonPadding,
                child: Icon(Icons.close, color: buttonColor),
              ),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
      content: SizedBox(
        height: screenSize(context).height,
        width: screenSize(context).width,
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
            CustomerSelectPage(onContinue: handleCustomerContinue),
            CheckoutConfirmationPage(onClose: () {
              clearOrder();
              close();
            }),
          ],
        ),
      ),
    );
  }
}
