import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:laundry/common/icons/my_icons.dart';
import 'package:laundry/cubits/orders/order_drawer_cubit.dart';
import 'package:laundry/cubits/orders/orders_cubit.dart';
import 'package:laundry/db/aggregates/order_details.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/l10n/access_locale.dart';

enum OrderViewStatus { none, sent, deleted }

class OrderViewFlat extends HookWidget {
  const OrderViewFlat({
    required this.streamId,
    required this.orderId,
    required this.title,
    required this.date,
    required this.status,
    String? customer,
  })  : customer = customer ?? "-",
        super(key: null);

  factory OrderViewFlat.fromOrderDetail(OrderDetail detail) => OrderViewFlat(
        streamId: detail.streamId,
        orderId: detail.orderId,
        title: detail.streamId,
        date: detail.createDate,
        customer: detail.customer?.name,
        status: detail.removedDate != null
            ? OrderViewStatus.deleted
            : detail.checkoutDate != null
                ? OrderViewStatus.sent
                : OrderViewStatus.none,
      );

  final String streamId;
  final String orderId;
  final String title;
  final DateTime date;
  final String customer;
  final OrderViewStatus status;

  void onTap(BuildContext context) {
    context.read<OrderDrawerCubit>().open(streamId);
  }

  Widget _slideAble(
    BuildContext context, {
    required Widget child,
    required void Function() handleSend,
    required void Function() handleCancelSend,
    required void Function() handleRemove,
    required void Function() handleRestore,
  }) {
    final isDeleted = status == OrderViewStatus.deleted;
    final isSent = status == OrderViewStatus.sent;
    if (isDeleted) {
      return Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          extentRatio: .25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => handleRestore(),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              icon: Icons.restore_from_trash_rounded,
              label: 'Restore',
            ),
          ],
        ),
        child: child,
      );
    }
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        extentRatio: .25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => handleRemove(),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: capitalizeFirstLetter(l10n(context)?.delete),
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: .25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            autoClose: true,
            onPressed: (_) => isSent ? handleCancelSend() : handleSend(),
            foregroundColor: Colors.white,
            icon: isSent ? MyIcons.cancel_sent : MyIcons.sent,
            backgroundColor: isSent ? Colors.redAccent : Colors.orangeAccent,
            label: isSent
                ? capitalizeFirstLetter(l10n(context)?.cancel)
                : capitalizeFirstLetter(l10n(context)?.send),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _container(BuildContext context) {
    final isSent = status == OrderViewStatus.sent;
    final isDeleted = status == OrderViewStatus.deleted;

    return InkWell(
      onTap: () => onTap(context),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              orderId,
              style: TextStyle(
                fontSize: 15,
                color: colorScheme(context).onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isDeleted)
              const Icon(Icons.remove_circle, color: Colors.redAccent),
            if (isSent)
              Icon(Icons.check_circle, color: colorScheme(context).primary),
          ],
        ),
        subtitle: _infoBar(context),
      ),
    );
  }

  Widget _infoBar(BuildContext context) {
    final color = colorScheme(context).onSurface;
    return Row(
      children: [
        _infoItem(Icons.calendar_today_rounded,
            dateToStringLocale(date, l10n(context)), color),
        const SizedBox(width: 7),
        _infoItem(Icons.account_circle, customer, color),
      ],
    );
  }

  Row _infoItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }

  @override
  build(context) {
    return _slideAble(
      context,
      child: _container(context),
      handleSend: () => context.read<OrdersCubit>().send(streamId),
      handleCancelSend: () => context.read<OrdersCubit>().cancelSend(streamId),
      handleRemove: () => context.read<OrdersCubit>().remove(streamId),
      handleRestore: () {
        logger.i("Restoring");
        context.read<OrdersCubit>().restore(streamId);
      },
    );
  }
}
