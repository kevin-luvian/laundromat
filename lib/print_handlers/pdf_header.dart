import 'package:intl/intl.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/print_handlers/setting/styles.dart';
import 'package:pdf/widgets.dart';

Widget buildPDFHeader({
  required String orderId,
  required User staff,
  required String date,
  required String cname,
  required String cphone,
}) {
  return Container(
    color: TextColor.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextWidget.normal("Kasir   : ${staff.name}"),
        SizedBox(height: 1),
        TextWidget.normal(cname),
        SizedBox(height: 1),
        TextWidget.normal(cphone),
        SizedBox(height: 7),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextWidget.normal(orderId),
          TextWidget.normal(date),
        ]),
        Breaker(),
      ],
    ),
  );
}
