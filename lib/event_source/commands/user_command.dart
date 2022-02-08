import 'package:crypt/crypt.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/full_command.dart';
import 'package:laundry/event_source/events/declare.dart';
import 'package:laundry/event_source/events/user_event.dart';
import 'package:laundry/helpers/utils.dart';

class UserCommand extends Command {
  UserCommand(EventDB _db) : super(_db, userEventType);

  Future<String> create({
    required String name,
    required String password,
    required String role,
    required int pin,
  }) async {
    if (pin.toString().length != 4) {
      throw Exception("pin must be a four digit integer");
    }

    password = Crypt.sha256(password).toString();
    var streamId = makeStreamId(userEventType);

    await generateEvent(
        streamId: streamId,
        version: 1,
        data: UserCreated(
          name: name,
          password: password,
          role: role,
          pin: pin,
        ));

    return streamId;
  }

  Future<void> update({
    required String streamId,
    String? name,
    String? password,
    String? role,
  }) async {
    password = password != null ? Crypt.sha256(password).toString() : null;

    await generateEvent(
        streamId: streamId,
        data: UserUpdated(
          name: name,
          password: password,
          role: role,
        ));
  }

  Future<void> deactivate({required String streamId}) async {
    await generateEvent(streamId: streamId, data: UserDeactivated());
  }
}
