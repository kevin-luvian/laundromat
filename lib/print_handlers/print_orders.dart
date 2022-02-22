import 'dart:io';
import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:laundry/db/aggregates/product_order_details.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:laundry/print_handlers/pdf_header.dart';
import 'package:laundry/print_handlers/pdf_orders.dart';
import 'package:laundry/print_handlers/pdf_to_image.dart';
import 'package:laundry/print_handlers/setting/prints.dart';
import 'package:laundry/print_handlers/wrapper/senyum_wrapper.dart';
import 'package:path_provider/path_provider.dart';

Future<void> printOrders(
  BlueThermalPrinter bluetooth,
  BluetoothDevice device, {
  required String orderId,
  required List<ProductOrderDetail> orders,
  required User staff,
  required DateTime date,
  Customer? customer,
}) async {
  final content = SenyumPageWrapper(children: [
    buildPDFHeader(
      orderId: orderId,
      staff: staff,
      date: date,
      customer: customer,
    ),
    buildOrdersWidget(orders),
  ]);
  await waitMilliseconds(50);
  final bytes = await pdfWidgetToImage(content);
  if (bytes != null) {
    await reconnect(bluetooth, device);
    await printImageBytes(bluetooth, device, bytes);
  }
}

Future<File?> buildOrdersAsFile({
  required String orderId,
  required List<ProductOrderDetail> orders,
  required User staff,
  Customer? customer,
}) async {
  final content = SenyumPageWrapper(children: [
    buildPDFHeader(
      orderId: orderId,
      staff: staff,
      customer: customer,
      date: DateTime.now(),
    ),
    buildOrdersWidget(orders),
  ]);
  final bytes = await pdfWidgetToImage(content);
  if (bytes != null) return tempWriteToFile(bytes);
}

Future<File> tempWriteToFile(Uint8List data) async {
  final tempDir = (await getExternalCacheDirectories())?.first;
  String tempPath = tempDir!.path;
  final filePath = tempPath + '/file_01.png';
  return File(filePath).writeAsBytes(data);
}
