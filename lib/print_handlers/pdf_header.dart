import 'package:intl/intl.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/print_handlers/setting/styles.dart';
import 'package:pdf/widgets.dart';

Widget buildPDFHeader({
  required String orderId,
  required User staff,
  required DateTime date,
  required Customer? customer,
}) {
  // final dateStr = "${date.hour}:${date.minute}";
  final dateStr = DateFormat("HH:mm aa").format(date);
  return Container(
    color: TextColor.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextWidget.normal("Kasir   : ${staff.name}"),
        if (customer != null) TextWidget.normal("Nama  : ${customer.name}"),
        if (customer != null) TextWidget.normal("Nomor : ${customer.phone}"),
        SizedBox(height: 7),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextWidget.normal(orderId),
          TextWidget.normal(dateStr),
        ]),
        Breaker(),
      ],
    ),
  );
}
