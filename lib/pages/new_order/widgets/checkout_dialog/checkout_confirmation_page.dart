import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/bluetooth/bluetooth_bloc.dart';
import 'package:laundry/blocs/newOrder/save_order_bloc.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/db/aggregates/product_order_details.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:laundry/pages/new_order/widgets/checkout/checkout_order_item.dart';
import 'package:laundry/running_assets/asset_access.dart';
import 'package:laundry/running_assets/dao_access.dart';
import 'package:laundry/running_assets/db_access.dart';
import 'package:laundry/styles/theme.dart';

class CheckoutConfirmationPage extends StatefulWidget {
  const CheckoutConfirmationPage({required this.onClose}) : super(key: null);

  final void Function() onClose;

  @override
  _CheckoutConfirmationPageState createState() =>
      _CheckoutConfirmationPageState();
}

class _CheckoutConfirmationPageState extends State<CheckoutConfirmationPage> {
  late StreamSubscription listener;
  bool bluetoothConnection = false;
  List<ProductOrderDetail> orders = [];
  int subTotalPrice = 0;
  final double taxRate = 10 / 100;
  User? currentUser;
  Customer? customer;
  final SaveOrderBloc _bloc = SaveOrderBloc(driftDB, eventDB);

  void handlePrint() => bluetoothBloc.add(PrintEvent());

  void handleSave() => _bloc.add(SaveEvent());

  void handleClose() => widget.onClose();

  @override
  void initState() {
    super.initState();
    sessionDao.currentUser.then((user) => setState(() => currentUser = user!));
    newOrderCacheDao.currentCustomer
        .then((data) => setState(() => customer = data));
    listener = newOrderCacheDao.streamOrderDetails().listen((data) {
      setState(() {
        orders = data;
        if (orders.isNotEmpty) {
          subTotalPrice = orders.map((o) => o.totalPrice).reduce(sumInt);
        }
      });
    });
    bluetoothBloc.currentConnection
        .then((val) => setState(() => bluetoothConnection = val));
    bluetoothBloc.stream.listen((state) => setState(() {
          switch (state.runtimeType) {
            case BluetoothConnectionState:
              bluetoothConnection = (state as BluetoothConnectionState).conn;
              break;
            default:
              bluetoothConnection = false;
          }
        }));
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
  }

  BlocListener _blocListener({required Widget child}) {
    return BlocListener<SaveOrderBloc, SaveOrderState>(
      bloc: _bloc,
      listener: (_ctx, state) {
        if (state.runtimeType == OrderSavedState) {
          handleClose();
        }
      },
      child: child,
    );
  }

  @override
  build(context) {
    return _blocListener(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _staffInfo(),
            _customerInfo(),
            const SizedBox(height: 15),
            _orderInfo(),
            const SizedBox(height: 15),
            _paymentInfo(),
            const Spacer(),
            _actions(),
          ],
        ),
      ),
    );
  }

  Widget _orderInfo() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: GlobalColor.light),
        borderRadius: BorderRadius.circular(5),
      ),
      constraints: const BoxConstraints(maxHeight: 250),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: orders.length,
        itemBuilder: (_, i) => _orderItem(orders[i]),
        separatorBuilder: (_, i) {
          return const SizedBox(height: 10);
        },
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  Widget _orderItem(ProductOrderDetail order) {
    return CheckoutOrderItem(
      title: order.product.title,
      totalPrice: order.totalPrice,
      unit: order.product.unit,
      addons: order.addonsStr,
      amount: order.amount,
    );
  }

  Widget _staffInfo() {
    final userName = currentUser?.name ?? "";
    return _leftRightInfo("Staff :", userName);
  }

  Widget _customerInfo() {
    String customerDetail = " - ";
    final _customer = customer;
    if (_customer != null) {
      customerDetail = _customer.name + " | " + _customer.phone;
    }
    return _leftRightInfo("Customer :", customerDetail);
  }

  Widget _paymentInfo() {
    // final taxes = subTotalPrice * taxRate;
    final totalPrice = subTotalPrice;
    return Column(
      children: [
        // _leftRightInfo("Subtotal:", customPriceFormat(subTotalPrice)),
        // _leftRightInfo("Tax:", customPriceFormat(taxes)),
        _leftRightInfo("Total:", customPriceFormat(totalPrice)),
      ],
    );
  }

  Widget _actions() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: RectButton(
            color: Colors.blueAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.print_outlined),
                SizedBox(width: 10),
                Text("Print",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
              ],
            ),
            size: const Size.fromHeight(50),
            onPressed: handlePrint,
            disabled: !bluetoothConnection,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 2,
          child: RectButton(
            size: const Size.fromHeight(50),
            child: const Text("Save",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            onPressed: handleSave,
          ),
        ),
      ],
    );
  }

  Widget _leftRightInfo(String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(left, style: boldStyle), Text(right, style: boldStyle)],
    );
  }

  TextStyle get boldStyle => TextStyle(
        color: colorScheme(context).onSurface,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      );
}
