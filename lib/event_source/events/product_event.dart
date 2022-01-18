import 'package:laundry/helpers/utils.dart';

const PRODUCT_EVENT_TYPE = "PRODUCT";

class ProductCreated {
  static const String tag = "ProductCreated";

  String category;
  String title;
  int price;
  String unit;

  ProductCreated({
    required this.category,
    required this.title,
    required this.price,
    required this.unit,
  });
}

class ProductCreatedSerializer implements Serializer<ProductCreated> {
  @override
  ProductCreated fromJson(data) => ProductCreated(
        category: data["category"],
        title: data["title"],
        price: data["price"],
        unit: data["unit"],
      );

  @override
  Map<String, dynamic> toJson(t) => {
        "category": t.category,
        "title": t.title,
        "price": t.price,
        "unit": t.unit,
      };
}
