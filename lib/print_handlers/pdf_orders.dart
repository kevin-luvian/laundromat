import 'package:laundry/db/dao/new_order_caches/new_order_cache.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

const double mm = 72.0 / 25.4;
const double cm = 72.0 / 2.54;

const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
const PdfColor white = PdfColor.fromInt(0xffffffff);
const PdfColor black = PdfColor.fromInt(0xff000000);

class TextWidget {
  static Text big(String text) =>
      Text(text, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));

  static Text normal(String text) =>
      Text(text, style: const TextStyle(fontSize: 26));

  static Text sub(String text) =>
      Text(text, style: const TextStyle(fontSize: 22));
}

Widget buildOrdersWidget(List<OrderDetail> orders) {
  final int total;
  if (orders.isNotEmpty) {
    total = orders.map((o) => o.totalPrice).reduce(sumInt);
  } else {
    total = 0;
  }

  return Expanded(
    child: Container(
      color: white,
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
          _breaker(),
          SizedBox(height: 20),
        ],
      ),
    ),
  );
}

Widget _buildOrder(OrderDetail order) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextWidget.normal(customPriceFormat(order.totalPrice)),
              SizedBox(height: 2),
              TextWidget.normal(order.amountStr + " " + order.product.unit),
            ],
          ),
        ],
      ),
      _breaker(),
    ],
  );
}

Widget _breaker() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
    child: Center(child: Divider(color: black, thickness: 2)),
  );
}

Future<PageTheme> pageTheme80mm() async {
  return const PageTheme(
    pageFormat: PdfPageFormat(140 * mm, double.infinity),
  );
}
