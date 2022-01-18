import 'dart:async';

import 'package:drift/native.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/product_command.dart';
import 'package:laundry/event_source/events/product_event.dart';
import 'package:laundry/event_source/projectors/projector_listeners.dart';
import 'package:laundry/event_source/stream.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:test/test.dart';

void main() {
  late EventDB db;
  late DriftDB ddb;
  late EventDao eventDao;
  late ProductDao productDao;
  late ProductCommand productCommand;
  late ProjectorListeners listeners;
  late StreamSubscription<Event> eventLogger;

  setUp(() async {
    db = EventDB(NativeDatabase.memory());
    ddb = DriftDB(NativeDatabase.memory());
    productCommand = ProductCommand(db);
    eventDao = EventDao(db);
    productDao = ProductDao(ddb);
    listeners = ProjectorListeners(ddb)..setup();

    await db.delete(db.events).go();
    expect((await eventDao.allEvents()).length, equals(0));
    expect((await productDao.all()).length, equals(0));

    eventLogger = EventStream.stream.listen((event) {
      logger.i(event);
    });
  });

  tearDown(() async {
    await db.close();
    await ddb.close();
    await eventLogger.cancel();
    await listeners.dispose();
  });

  test('create one product commanded', () async {
    expect(
      EventStream.stream.map((e) => e.tag),
      emitsAnyOf([equals(ProductCreated.tag)]),
    );

    await productCommand.create(
      category: "bwaaa",
      title: "bwoo",
      price: 10000,
      unit: "unit",
    );

    final events = await eventDao.allEvents();
    expect(events.length, 1);

    final products = await productDao.all();
    logger.d(products);
    expect(products.length, 1);
    expect(products[0].title, "bwoo");
  });
}
