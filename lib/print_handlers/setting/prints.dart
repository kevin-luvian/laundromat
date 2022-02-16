import 'package:blue_thermal_printer/blue_thermal_printer.dart';

Future<bool> reconnect(
  BlueThermalPrinter bluetooth,
  BluetoothDevice device,
) async {
  if (await bluetooth.isConnected ?? false) {
    await bluetooth.disconnect();
  }
  await bluetooth.connect(device);
  return await bluetooth.isConnected ?? false;
}
