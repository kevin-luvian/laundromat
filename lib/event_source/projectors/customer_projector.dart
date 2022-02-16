import 'dart:async';

import 'package:laundry/db/dao/customer.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/events/customer_event.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/event_source/projectors/declare.dart';
import 'package:laundry/helpers/utils.dart';

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

  Future<void> create(Event event) => customerDao.create(_onCreate(event));

  Future<void> update(Event event) async {
    final data =
        ProjectionEvent.fromEvent(event, CustomerUpdatedSerializer()).data;
    await customerDao.updateName(event.streamId, data.name);
  }

  static Customer? projectStatic(List<Event> events) {
    assertStreamId(events);

    Customer? customer;
    for (final event in events) {
      switch (event.tag) {
        case CustomerCreated.staticTag:
          customer = _onCreate(event);
          break;
        case CustomerUpdated.staticTag:
          customer = _onUpdate(event, customer!);
          break;
      }
      return customer;
    }
  }
}

Customer _onCreate(Event event) {
  final data =
      ProjectionEvent.fromEvent(event, CustomerCreatedSerializer()).data;
  return Customer(
    id: event.streamId,
    name: data.name,
    phone: data.phone,
    lastEditorId: data.createdBy,
  );
}

Customer _onUpdate(Event event, Customer customer) {
  final data =
      ProjectionEvent.fromEvent(event, CustomerUpdatedSerializer()).data;
  return _modify(
    CustomersCompanion(
      name: wrapAbsentValue(data.name),
      phone: wrapAbsentValue(data.phone),
      lastEditorId: wrapAbsentValue(data.updatedBy),
    ),
    customer,
  );
}

Customer _modify(CustomersCompanion data, Customer customer) => Customer(
      id: customer.id,
      name: updateValue(data.name, customer.name),
      phone: updateValue(data.phone, customer.phone),
      lastEditorId: updateValue(data.lastEditorId, customer.lastEditorId),
    );
