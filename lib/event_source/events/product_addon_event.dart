import 'package:laundry/helpers/utils.dart';

const PRODUCT_ADDON_EVENT_TYPE = "PRODUCT_ADDON";

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
      productId: data["productId"], title: data["title"], price: data["price"]);

  @override
  toJson(t) => {"productId": t.productId, "title": t.title, "price": t.price};
}

class AddonRemoved {
  static const String tag = "AddonRemoved";
}

class AddonRemovedSerializer extends EmptySerializer<AddonRemoved> {
  AddonRemovedSerializer() : super(AddonRemoved());
}
