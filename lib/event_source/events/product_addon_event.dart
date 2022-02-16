import 'package:laundry/helpers/utils.dart';

const productAddonEventType = "PRODUCT_ADDON";

class AddonAdded {
  static const String tag = "AddonAdded";

  String productId;
  String title;
  int price;

  AddonAdded(
      {required this.productId, required this.title, required this.price});
}

class AddonAddedSerializer implements Serializer<AddonAdded> {
  @override
  fromJson(data) => AddonAdded(
        productId: data["productId"] as String,
        title: data["title"] as String,
        price: data["price"] as int,
      );

  @override
  toJson(t) => <String, dynamic>{
        "productId": t.productId,
        "title": t.title,
        "price": t.price,
      };
}

class AddonRemoved {
  static const String tag = "AddonRemoved";
}
