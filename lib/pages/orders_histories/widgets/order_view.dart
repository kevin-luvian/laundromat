import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:laundry/cubits/orders/orders_cubit.dart';
import 'package:laundry/db/aggregates/order_details.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/l10n/access_locale.dart';

class OrderView extends StatelessWidget {
  const OrderView({
    required this.streamId,
    required this.title,
    required this.date,
    String? customer,
  })  : customer = customer ?? "-",
        super(key: null);

  factory OrderView.fromOrderDetail(OrderDetail detail) => OrderView(
        streamId: detail.streamId,
        title: detail.streamId,
        date: detail.createDate,
        customer: detail.customer?.name,
      );

  final String streamId;
  final String title;
  final DateTime date;
  final String customer;

  Future<void> removeThis(BuildContext context) =>
      context.read<OrdersCubit>().remove(streamId);

  void doNothing(BuildContext context) {}

  Widget _slideAble({required BuildContext context, required Widget child}) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => removeThis(context),
          dismissThreshold: .7,
          closeOnCancel: true,
        ),
        children: [
          SlidableAction(
            onPressed: removeThis,
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _cardContainer(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: colorScheme(context).onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              _infoBar(context),
            ],
          ),
        ),
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
    return _slideAble(child: _cardContainer(context), context: context);
  }
}
