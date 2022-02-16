import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/event_source/events/product_addon_event.dart';
import 'package:laundry/event_source/events/product_event.dart';
import 'package:laundry/helpers/utils.dart';

class ProductStaticProjector {
  static Product? projectStatic(List<Event> events) {
    Product? product;
    for (final event in events) {
      switch (event.tag) {
        case ProductCreated.staticTag:
          product = _ProductProject._onCreate(event);
          break;
        case ProductUpdated.tag:
          product = _ProductProject._onUpdate(event, product!);
          break;
        case ProductDeleted.tag:
          product = null;
          break;
      }
    }
    return product;
  }
}

class _ProductProject {
  static Product _onCreate(Event event) {
    final data =
        ProjectionEvent.fromEvent(event, ProductCreatedSerializer()).data;
    return Product(
      id: event.streamId,
      title: data.title,
      category: data.category,
      price: data.price,
      unit: data.unit,
    );
  }

  static Product _onUpdate(Event event, Product product) {
    final data = ProjectionEvent.fromEvent(event, ProductUpdatedSerializer())
        .data
        .toCompanion();
    return _modify(data, product);
  }

  static Product _modify(ProductsCompanion data, Product product) => Product(
        id: product.id,
        unit: updateValue(data.unit, product.unit),
        price: updateValue(data.price, product.price),
        category: updateValue(data.category, product.category),
        title: updateValue(data.title, product.title),
      );
}

class AddonStaticProjector {
  static List<ProductAddon> projectManyStatic(List<Event> events) {
    Map<String, ProductAddon?> groupedData = {};

    for (final event in events) {
      switch (event.tag) {
        case AddonAdded.tag:
          groupedData[event.streamId] = _AddonProject._onCreate(event);
          break;
        case AddonRemoved.tag:
          groupedData[event.streamId] = null;
          break;
      }
    }
    List<ProductAddon> addons = [];
    for (final data in groupedData.values) {
      if (data != null) addons.add(data);
    }
    return addons;
  }
}

class _AddonProject {
  static ProductAddon _onCreate(Event event) {
    final data = ProjectionEvent.fromEvent(event, AddonAddedSerializer()).data;
    return ProductAddon(
      id: event.streamId,
      productId: data.productId,
      title: data.title,
      price: data.price,
    );
  }
}
