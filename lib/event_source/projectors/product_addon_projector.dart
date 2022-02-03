import 'dart:async';

import 'package:laundry/db/dao/product/product_addon.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/event_source/events/product_addon_event.dart';
import 'package:laundry/event_source/events/product_event.dart';

import 'declare.dart';

class ProductAddonProjector implements IProjector {
  ProductAddonProjector(DriftDB db) : _dao = ProductAddonDao(db);

  final ProductAddonDao _dao;

  @override
  project(event) async {
    switch (event.tag) {
      case AddonAdded.tag:
        return create(
          ProjectionEvent.fromEvent(event, AddonAddedSerializer()),
        );
      case AddonRemoved.tag:
        return remove(event.streamId);
      case ProductDeleted.tag:
        return removeAllProductAddons(event.streamId);
    }
  }

  Future<void> create(ProjectionEvent<AddonAdded> event) async {
    await _dao.create(ProductAddon(
      id: event.streamId,
      productId: event.data.productId,
      title: event.data.title,
      price: event.data.price,
    ));
  }

  Future<void> remove(String id) async {
    await _dao.deleteById(id);
  }

  Future<void> removeAllProductAddons(String productId) async {
    await _dao.deleteByProductId(productId);
  }
}
