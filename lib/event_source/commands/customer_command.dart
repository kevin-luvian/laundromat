import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/full_command.dart';
import 'package:laundry/event_source/events/customer_event.dart';
import 'package:laundry/helpers/utils.dart';

class CustomerCommand extends Command {
  CustomerCommand(EventDB db) : super(db, customerEventType);

  Future<String> create(String phone, String name) async {
    var streamId = makeStreamId(streamType);
    await generateEvent(
      streamId: streamId,
      version: 1,
      data: CustomerCreated(name: name, phone: phone),
    );
    return streamId;
  }

  Future<void> update(String streamId, {String? phone, String? name}) async {
    await generateEvent(
      streamId: streamId,
      data: CustomerUpdated(name: name, phone: phone),
    );
  }
}
