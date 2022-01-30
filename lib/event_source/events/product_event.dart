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

class ProductUpdated {
  static const String tag = "ProductUpdated";

  String? category;
  String? title;
  int? price;
  String? unit;

  ProductUpdated({
    this.category,
    this.title,
    this.price,
    this.unit,
  });
}

class ProductDeleted {
  static const String tag = "ProductDeleted";
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

class ProductUpdatedSerializer implements Serializer<ProductUpdated> {
  @override
  ProductUpdated fromJson(data) => ProductUpdated(
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

class ProductDeletedSerializer extends EmptySerializer<ProductDeleted> {
  ProductDeletedSerializer() : super(ProductDeleted());
}
