import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/print_handlers/setting/prints.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart' as pr;

const PdfColor white = PdfColor.fromInt(0xffffffff);
const double mm = 72.0 / 25.4;

Future<void> printNewlines(BlueThermalPrinter bluetooth, int n) async {
  for (int i = 0; i < n; i++) {
    await bluetooth.printNewLine();
  }
}

Future<void> printImageBytes(
  BlueThermalPrinter bluetooth,
  BluetoothDevice device,
  Uint8List bytes,
) async {
  if (await reconnect(bluetooth, device)) {
    await bluetooth.printImageBytes(bytes.buffer.asUint8List(
      bytes.offsetInBytes,
      bytes.lengthInBytes,
    ));
  }
}

Future<Uint8List?> pdfWidgetToImage(Widget content) async {
  final pdf = Document();
  pdf.addPage(Page(
    pageTheme: await _pageTheme80mm(),
    build: (_) => content,
  ));

  Uint8List? image;
  try {
    await for (final pg in pr.Printing.raster(await pdf.save(), dpi: 70)) {
      final img = await pg.toImage();
      final imgData = await img.toByteData(format: ui.ImageByteFormat.png);
      image = imgData!.buffer.asUint8List();
    }
  } catch (err) {
    logger.e(err);
  }

  return image;
}

Future<PageTheme> _pageTheme80mm() async {
  return const PageTheme(
    pageFormat: PdfPageFormat(140 * mm, double.infinity),
    margin: EdgeInsets.zero,
  );
}
