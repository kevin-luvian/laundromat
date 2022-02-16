import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/utils.dart';

class ProductOrderDetail {
  ProductOrderDetail(this.product, this.addons, this.amount);

  final Product product;
  final List<ProductAddon> addons;
  final double amount;

  int get totalPrice {
    double total = product.price.toDouble();
    if (addons.isNotEmpty) {
      final addonsPrices = addons.map((a) => a.price).reduce(sumInt);
      total += addonsPrices.toDouble();
    }
    total *= amount;
    return total.toInt();
  }

  String get amountStr => doubleToString(amount);

  List<String> get addonsStr => addons.map((a) => a.title).toList();

  @override
  toString() {
    return '''\namount: $amount;\nproduct: $product;\naddons: $addons\n''';
  }
}
