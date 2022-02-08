import 'dart:async';

import 'package:laundry/db/dao/customer.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/customer_event.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/event_source/projectors/declare.dart';

class CustomerProjector implements IProjector {
  CustomerProjector(DriftDB db) : customerDao = CustomerDao(db);

  final CustomerDao customerDao;

  @override
  project(event) async {
    switch (event.tag) {
      case CustomerCreated.staticTag:
        return create(event);
      case CustomerUpdated.staticTag:
        return update(event);
    }
  }

  Future<void> create(Event event) async {
    final data = ProjectionEvent.fromEvent(
      event,
      CustomerCreatedSerializer(),
    ).data;
    await customerDao.create(Customer(
      name: data.name,
      phone: data.phone,
    ));
  }

  Future<void> update(Event event) async {
    final data = ProjectionEvent.fromEvent(
      event,
      CustomerUpdatedSerializer(),
    ).data;
    await customerDao.updateName(event.streamId, data.name);
  }
}
