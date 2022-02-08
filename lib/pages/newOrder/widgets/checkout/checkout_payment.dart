import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundry/db/dao/new_order_caches/new_order_cache.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:laundry/running_assets/dao_access.dart';

const double taxRate = 10 / 100;

class CheckoutPayment extends StatefulWidget {
  const CheckoutPayment(this.padding) : super(key: null);
  final EdgeInsets padding;

  @override
  _CheckoutPaymentState createState() => _CheckoutPaymentState();
}

class _CheckoutPaymentState extends State<CheckoutPayment> {
  late final StreamSubscription<List<OrderDetail>> orderListener;
  int subtotal = 0;

  @override
  void initState() {
    orderListener = newOrderCacheDao.streamOrderDetails().listen((orders) {
      if (orders.isEmpty) {
        setState(() => subtotal = 0);
        return;
      }
      setState(() => subtotal = orders.map((o) => o.totalPrice).reduce(sumInt));
    });

    super.initState();
  }

  int get taxes => (subtotal * taxRate).toInt();

  int get total => subtotal + taxes;

  @override
  void dispose() {
    orderListener.cancel();

    super.dispose();
  }

  @override
  Widget build(context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.padding.horizontal,
        vertical: 7,
      ),
      child: Column(
        children: [
          _buildInfoSubset("Subtotal", subtotal, textColor, 12, null),
          _buildInfoSubset("Taxes", taxes, textColor, 12, null),
          _buildInfoSubset("Total", total, textColor, 15, FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildInfoSubset(String field, int value, Color fontColor,
      double? fontSize, FontWeight? fontWeight) {
    final currency = NumberFormat("#,###", "id").format(value);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            field,
            style: TextStyle(
              fontSize: fontSize == null ? null : fontSize + 1,
              fontWeight: fontWeight,
              color: fontColor,
            ),
          ),
          Text(
            "Rp. " + currency,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: fontColor,
            ),
          ),
        ],
      ),
    );
  }
}
