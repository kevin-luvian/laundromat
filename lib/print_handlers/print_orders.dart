import 'dart:io';
import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:laundry/db/dao/new_order_caches/new_order_cache.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/print_handlers/pdf_orders.dart';
import 'package:laundry/print_handlers/pdf_to_image.dart';
import 'package:path_provider/path_provider.dart';

void printOrders(
  BlueThermalPrinter bluetooth,
  BluetoothDevice device,
  List<OrderDetail> orders,
) async {
  await bluetooth.disconnect();
  await bluetooth.connect(device);
  final isConnected = await bluetooth.isConnected ?? false;
  if (isConnected) {
    final bytes = await pdfWidgetToImage(buildOrdersWidget(orders));
    if (bytes != null) {
      bluetooth.printNewLine();
      await bluetooth.printImageBytes(bytes.buffer.asUint8List(
        bytes.offsetInBytes,
        bytes.lengthInBytes,
      ));
      bluetooth.paperCut();
    }
  } else {
    logger.e("not connected");
  }
}

Future<File?> buildOrdersAsFile(List<OrderDetail> orders) async {
  final ordersWidget = buildOrdersWidget(orders);
  final bytes = await pdfWidgetToImage(ordersWidget);
  if (bytes != null) return tempWriteToFile(bytes);
}

Future<File> tempWriteToFile(Uint8List data) async {
  final tempDir = (await getExternalCacheDirectories())?.first;
  String tempPath = tempDir!.path;
  final filePath = tempPath + '/file_01.png';
  return File(filePath).writeAsBytes(data);
}
