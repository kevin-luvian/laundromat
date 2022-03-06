import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/common/right_drawer.dart';
import 'package:laundry/cubits/orders/order_drawer_cubit.dart';
import 'package:laundry/db/aggregates/order_details.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:laundry/l10n/access_locale.dart';
import 'package:laundry/pages/orders_histories/widgets/right_drawer/order_actions.dart';
import 'package:laundry/pages/orders_histories/widgets/right_drawer/receipt_item.dart';
import 'package:laundry/running_assets/dao_access.dart';

class OrderDetailRightDrawerContent extends RightDrawerContent {
  OrderDetailRightDrawerContent(BuildContext context)
      : super(
            label: capitalizeLetter(l10n(context)?.order_detail),
            child: const OrderDetailRightDrawer());
}

class OrderDetailRightDrawer extends StatefulWidget {
  const OrderDetailRightDrawer() : super(key: null);

  @override
  createState() => _OrderDetailRightDrawerState();
}

class _OrderDetailRightDrawerState extends State<OrderDetailRightDrawer> {
  OrderDetail? order;

  Widget _blocListener({Widget? child}) {
    return BlocListener<OrderDrawerCubit, OrderDetail?>(
      listener: (_ctx, _state) {
        setState(() => order = _state);
      },
      child: child,
    );
  }

  void refresh() async {
    final id = order?.streamId;
    if (id == null) return;
    final _order = await ordersDao.findById(id);
    setState(() => order = _order);
  }

  @override
  build(context) {
    return _blocListener(
      child: Column(
        children: [
          divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _date(),
                  divider(),
                  _customer(),
                  divider(),
                  _receipt(),
                  divider(),
                  _payment(),
                ],
              ),
            ),
          ),
          if (order != null) OrderActions(order!, refresh),
        ],
      ),
    );
  }

  Widget _date() {
    final receivedDate = order?.createDate;
    final receivedDateStr = receivedDate == null
        ? "-"
        : dateToStringLocaleFull(receivedDate, l10n(context));

    final sentDate = order?.checkoutDate;
    final sentDateStr = sentDate == null
        ? "-"
        : dateToStringLocaleFull(sentDate, l10n(context));

    return _iconContainer(
      icon: Icons.calendar_today_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _lrText(textBold(capitalizeFirstLetter(l10n(context)?.received)),
              Text(receivedDateStr)),
          spacer(),
          _lrText(textBold(capitalizeFirstLetter(l10n(context)?.sent)),
              Text(sentDateStr)),
        ],
      ),
    );
  }

  Widget _customer() {
    final customerName = order?.customer?.name ?? "-";
    final customerPhone = order?.customer?.phone ?? "-";

    return _iconContainer(
      icon: Icons.account_circle_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _lrText(textBold(capitalizeFirstLetter(l10n(context)?.name)),
              Text(customerName)),
          spacer(),
          _lrText(textBold(capitalizeFirstLetter(l10n(context)?.phone)),
              Text(customerPhone)),
        ],
      ),
    );
  }

  Widget _receipt() {
    final orders = order?.orders ?? [];

    return _iconContainer(
      icon: Icons.receipt_outlined,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orders.length,
        itemBuilder: (_ctx, i) => ReceiptItem(orders.elementAt(i)),
        separatorBuilder: (_ctx, i) => const SizedBox(height: 5),
      ),
    );
  }

  Widget _payment() {
    final total = "Rp. " + formatPrice(order?.totalPrice ?? 0);

    return _iconContainer(
      icon: Icons.attach_money_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_lrText(textBold("Sub Total"), Text(total))],
      ),
    );
  }

  Widget _iconContainer({required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          Icon(icon, size: 27),
          const SizedBox(width: 15),
          Expanded(child: child),
        ],
      ),
    );
  }

  Divider divider() => const Divider(height: 1, thickness: 1);

  SizedBox spacer() => const SizedBox(height: 3);

  Text textBold(String text) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.bold));

  Widget _lrText(Text left, Text right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [left, right],
    );
  }
}
