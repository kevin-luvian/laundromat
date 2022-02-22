import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/blocs/bluetooth/bluetooth_bloc.dart';
import 'package:laundry/common/confirmation_dialog.dart';
import 'package:laundry/common/icons/my_icons.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/cubits/orders/orders_cubit.dart';
import 'package:laundry/db/aggregates/order_details.dart';
import 'package:laundry/hooks/use_bluetooth_connection.dart';
import 'package:laundry/running_assets/asset_access.dart';
import 'package:laundry/styles/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderActions extends HookWidget {
  const OrderActions(this.order, this.refresh) : super(key: null);

  final OrderDetail order;
  final void Function() refresh;

  void handlePrint(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => ConfirmationDialog(
        content: "print receipt?",
        onContinue: () => bluetoothBloc.add(PrintHistoryEvent(order)),
      ),
    );
  }

  void handleSend(BuildContext context) {
    context.read<OrdersCubit>().send(order.streamId).then((value) => refresh());
  }

  void handleCancelSend(BuildContext context) {
    context
        .read<OrdersCubit>()
        .cancelSend(order.streamId)
        .then((value) => refresh());
  }

  @override
  build(context) {
    final conn = useBlueConnection(bluetoothBloc);
    const _spacer = SizedBox(width: 20);

    final isSent = order.checkoutDate != null;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: GlobalColor.light),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RectButton(
              disabled: !conn.value,
              onPressed: () => handlePrint(context),
              color: Colors.blueAccent,
              size: const Size(50, 50),
              child: const Icon(Icons.print_outlined)),
          _spacer,
          RectButton(
              onPressed: () {},
              size: const Size(50, 50),
              color: const Color.fromRGBO(78, 203, 92, 1),
              child: const Icon(MyIcons.whatsapp, size: 35)),
          _spacer,
          RectButton(
              onPressed: () =>
                  isSent ? handleCancelSend(context) : handleSend(context),
              size: const Size(50, 50),
              color: isSent ? Colors.redAccent : Colors.orangeAccent,
              child:
                  Icon(isSent ? MyIcons.cancel_sent : MyIcons.sent, size: 35)),
        ],
      ),
    );
  }
}
