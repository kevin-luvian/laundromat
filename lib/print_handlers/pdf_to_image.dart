import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/print_handlers/pdf_orders.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart' as pr;

const PdfColor white = PdfColor.fromInt(0xffffffff);
const double mm = 72.0 / 25.4;

Future<void> printImageBytes(
  BlueThermalPrinter bluetooth,
  BluetoothDevice device,
  Uint8List bytes,
) async {
  await bluetooth.disconnect();
  await bluetooth.connect(device);
  final isConnected = await bluetooth.isConnected ?? false;
  if (isConnected) {
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
    build: (_) => _pageWrapper(content),
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

Widget _pageWrapper(Widget child) {
  return Expanded(
    child: Container(
      color: white,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 70),
          child: Column(
            children: [
              senyumHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 80),
                child: child,
              ),
              senyumFooter(),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget senyumHeader() {
  return Center(child: TextWidget.big("SENYUM"));
}

Widget senyumFooter() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "Terima kasih sudah berbelanja pada jasa laundry senyum.",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 23),
      ),
    ),
  );
}

Future<PageTheme> _pageTheme80mm() async {
  return const PageTheme(
    pageFormat: PdfPageFormat(140 * mm, double.infinity),
  );
}
