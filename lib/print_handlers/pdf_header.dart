import 'package:laundry/db/drift_db.dart';
import 'package:laundry/print_handlers/setting/styles.dart';
import 'package:pdf/widgets.dart';

Widget buildPDFHeader(User staff, Customer? customer) {
  return Container(
    color: TextColor.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextWidget.normal("Kasir : ${staff.name}"),
        TextWidget.normal("Order #10"),
      ],
    ),
  );
}
