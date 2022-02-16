import 'dart:async';

import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/event_source/events/product_event.dart';
import 'package:laundry/helpers/utils.dart';

import 'declare.dart';

class ProductProjector implements IProjector {
  ProductProjector(DriftDB db) : _dao = ProductDao(db);

  final ProductDao _dao;

  @override
  project(event) async {
    switch (event.tag) {
      case ProductCreated.staticTag:
        return create(
          ProjectionEvent.fromEvent(event, ProductCreatedSerializer()),
        );
      case ProductUpdated.tag:
        return update(
          ProjectionEvent.fromEvent(event, ProductUpdatedSerializer()),
        );
      case ProductDeleted.tag:
        return delete(event.streamId);
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

  Future<void> update(ProjectionEvent<ProductUpdated> event) async {
    await _dao.updateById(
      event.streamId,
      ProductsCompanion(
        title: wrapAbsentValue(event.data.title),
        category: wrapAbsentValue(event.data.category),
        price: wrapAbsentValue(event.data.price),
        unit: wrapAbsentValue(event.data.unit),
      ),
    );
  }

  Future<void> delete(String id) async {
    await _dao.deleteById(id);
  }
}
