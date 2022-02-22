import 'package:flutter/material.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/running_assets/dao_access.dart';

class CheckoutHeader extends StatelessWidget {
  const CheckoutHeader(this.padding) : super(key: null);

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1.5,
          ),
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(padding.left, padding.top, padding.right, 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<int>(
              stream: ordersDao.streamTodayOrdersLength(),
              builder: (_ctx, snapshot) {
                int index = 1;
                if (snapshot.hasData) {
                  logger.i(snapshot.data);
                  index = snapshot.data! + 1;
                }
                return Text(
                  "Order #$index",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 17),
                );
              },
            ),
            Text(
              "opened 07:00 pm",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
