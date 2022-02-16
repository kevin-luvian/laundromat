import 'package:laundry/db/aggregates/product_order_details.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:laundry/print_handlers/setting/styles.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Widget buildOrdersWidget(List<ProductOrderDetail> orders) {
  final int total;
  if (orders.isNotEmpty) {
    total = orders.map((o) => o.totalPrice).reduce(sumInt);
  } else {
    total = 0;
  }

  return Container(
    color: TextColor.white,
    child: Column(
      children: [
        SizedBox(height: 20),
        for (final order in orders) _buildOrder(order),
        SizedBox(height: 70),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget.big("Total"),
            TextWidget.big(customPriceFormat(total))
          ],
        ),
        Breaker(),
      ],
    ),
  );
}

Widget _buildOrder(ProductOrderDetail order) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget.normal(order.product.title),
                for (final addon in order.addons)
                  Row(children: [
                    SizedBox(width: 20),
                    TextWidget.normal(addon.title)
                  ]),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextWidget.normal(customPriceFormat(order.totalPrice),
                    align: TextAlign.right),
                SizedBox(height: 2),
                TextWidget.normal(order.amountStr + " " + order.product.unit,
                    align: TextAlign.right),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 15),
    ],
  );
}

PageTheme pageTheme80mm() =>
    const PageTheme(pageFormat: PdfPageFormat(140 * Sizes.mm, double.infinity));
