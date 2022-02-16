import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/utils.dart';

const productEventType = "PRODUCT";

class ProductCreated implements EventData<ProductCreated> {
  static const String staticTag = "ProductCreated";

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

  @override
  get serializer => ProductCreatedSerializer();

  @override
  get tag => staticTag;
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

  ProductsCompanion toCompanion() => ProductsCompanion(
        category: wrapAbsentValue(category),
        title: wrapAbsentValue(title),
        price: wrapAbsentValue(price),
        unit: wrapAbsentValue(unit),
      );
}

class ProductDeleted {
  static const String tag = "ProductDeleted";
}

class ProductCreatedSerializer implements Serializer<ProductCreated> {
  @override
  ProductCreated fromJson(data) => ProductCreated(
        category: data["category"] as String,
        title: data["title"] as String,
        price: data["price"] as int,
        unit: data["unit"] as String,
      );

  @override
  toJson(t) => <String, dynamic>{
        "category": t.category,
        "title": t.title,
        "price": t.price,
        "unit": t.unit,
      };
}

class ProductUpdatedSerializer implements Serializer<ProductUpdated> {
  @override
  ProductUpdated fromJson(data) => ProductUpdated(
        category: data["category"] as String?,
        title: data["title"] as String?,
        price: data["price"] as int?,
        unit: data["unit"] as String?,
      );

  @override
  toJson(t) => <String, dynamic>{
        "category": t.category,
        "title": t.title,
        "price": t.price,
        "unit": t.unit,
      };
}
