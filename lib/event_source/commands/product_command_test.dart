import 'package:drift/native.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/dao/product/product.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/product_command.dart';
import 'package:laundry/event_source/events/product_event.dart';
import 'package:laundry/event_source/projectors/projector_listeners.dart';
import 'package:laundry/event_source/stream.dart';
import 'package:laundry/helpers/utils.dart';
import 'package:test/test.dart';

void main() {
  late EventDB db;
  late DriftDB ddb;
  late EventDao eventDao;
  late ProductDao productDao;
  late ProductCommand productCommand;
  late ProjectorListeners listeners;

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
  });

  tearDown(() async {
    await db.close();
    await ddb.close();
    await listeners.dispose();
  });

  test('create one product command', () async {
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

    await shortDelay();
    final products = await productDao.all();
    expect(products.length, 1);
    expect(products[0].title, "bwoo");
  });

  test('update one product command', () async {
    expect(
      EventStream.stream.map((e) => e.tag),
      emitsInOrder([ProductCreated.tag, ProductUpdated.tag]),
    );

    final streamId = await productCommand.create(
      category: "bwaaa",
      title: "bwoo",
      price: 10000,
      unit: "unit",
    );

    await productCommand.update(streamId: streamId, category: "bwoosh");

    final events = await eventDao.allEvents();
    expect(events.length, 2);

    await shortDelay();
    final products = await productDao.all();
    expect(products.length, 1);
    expect(products[0].category, "bwoosh");
  });

  test('should not update null product', () async {
    expect(
      EventStream.stream.map((e) => e.tag),
      emitsInOrder([ProductCreated.tag]),
    );

    final streamId = await productCommand.create(
      category: "bwaaa",
      title: "bwoo",
      price: 10000,
      unit: "unit",
    );

    await productCommand.update(streamId: streamId);

    final events = await eventDao.allEvents();
    expect(events.length, 1);
  });

  test('delete product command', () async {
    expect(
      EventStream.stream.map((e) => e.tag),
      emitsInOrder([ProductCreated.tag, ProductDeleted.tag]),
    );

    final streamId = await productCommand.create(
      category: "bwaaa",
      title: "bwoo",
      price: 10000,
      unit: "unit",
    );

    await productCommand.delete(streamId: streamId);

    final events = await eventDao.allEvents();
    expect(events.length, 2);

    final products = await productDao.all();
    expect(products.length, 0);
  });
}
