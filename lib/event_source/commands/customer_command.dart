import 'package:laundry/db/dao/customer/customer.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/full_command.dart';
import 'package:laundry/event_source/events/customer_event.dart';
import 'package:laundry/helpers/utils.dart';

class CustomerCommand extends Command {
  final CustomerDao _customerDao;

  CustomerCommand(EventDB db, this._customerDao) : super(db, customerEventType);

  Future<String?> create(String createdBy, String phone, String name) async {
    final isUnique = (await _customerDao.findByPhone(phone) == null);
    if (!isUnique) return null;

    var streamId = makeStreamId(streamType);
    await generateEvent(
      streamId: streamId,
      version: 1,
      data: CustomerCreated(name: name, phone: phone, createdBy: createdBy),
    );
    return streamId;
  }

  Future<void> update(String streamId, String updatedBy,
      {String? phone, String? name}) async {
    await generateEvent(
      streamId: streamId,
      data: CustomerUpdated(name: name, phone: phone, updatedBy: updatedBy),
    );
  }
}
