import 'dart:async';

import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/event_source/events/product_event.dart';

import 'declare.dart';

class ProductProjector implements IProjector {
  ProductProjector(DriftDB db) : _dao = ProductDao(db);

  final ProductDao _dao;

  @override
  project(event) async {
    switch (event.tag) {
      case ProductCreated.tag:
        return create(ProjectionEvent.fromEvent(event, ProductCreatedSerializer()));
    }
  }

  Future<void> create(ProjectionEvent<ProductCreated> event) async {
    await _dao.create(Product(
      id: event.streamId,
      title: event.data.title,
      category: event.data.category,
      price: event.data.price,
      unit: event.data.unit,
    ));
  }
}
