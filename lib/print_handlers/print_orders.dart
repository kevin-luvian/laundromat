import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:laundry/db/dao/new_order_caches/new_order_cache.dart';

void printOrders(BlueThermalPrinter bluetooth, List<OrderDetail> orders) async {
  //SIZE
  // 0- normal size text
  // 1- only bold text
  // 2- bold with medium text
  // 3- bold with large text
  //ALIGN
  // 0- ESC_ALIGN_LEFT
  // 1- ESC_ALIGN_CENTER
  // 2- ESC_ALIGN_RIGHT
  bluetooth.isConnected.then((isConnected) {
    if (isConnected ?? false) {
      bluetooth.printNewLine();
      bluetooth.printCustom("HEADER", 3, 1);
      bluetooth.printNewLine();
      for (final order in orders) {
        bluetooth.printCustom(order.product.title, 0, 0);
      }
      bluetooth.paperCut();
    }
  });
}
