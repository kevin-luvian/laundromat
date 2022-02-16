import 'package:crypt/crypt.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/commands/full_command.dart';
import 'package:laundry/event_source/events/user_event.dart';
import 'package:laundry/helpers/utils.dart';

class UserCommand extends Command {
  UserCommand(EventDB _db) : super(_db, userEventType);

  Future<String> create({
    String? createdBy,
    required String name,
    required String password,
    required String role,
    required String pin,
  }) async {
    assert(int.tryParse(pin) != null);
    assert(pin.toString().length == 4);

    password = Crypt.sha256(password).toString();
    var streamId = makeStreamId(userEventType);

    await generateEvent(
        streamId: streamId,
        version: 1,
        data: UserCreated(
          createdBy: createdBy ?? "",
          name: name,
          password: password,
          role: role,
          pin: pin,
        ));

    return streamId;
  }

  Future<void> update({
    required String streamId,
    required String updatedBy,
    String? name,
    String? password,
    String? role,
    String? pin,
  }) =>
      generateEvent(
          streamId: streamId,
          data: UserUpdated(
            updatedBy: updatedBy,
            name: name,
            password:
                password != null ? Crypt.sha256(password).toString() : null,
            role: role,
            pin: pin,
          ));

  Future<void> reactivate(String streamId, String updatedBy) async {
    assert(streamId != updatedBy);
    await generateEvent(streamId: streamId, data: UserReactivated(updatedBy));
  }

  Future<void> deactivate(String streamId, String updatedBy) async {
    assert(streamId != updatedBy);
    await generateEvent(streamId: streamId, data: UserDeactivated(updatedBy));
  }

  Future<void> login(String streamId) =>
      generateEvent(streamId: streamId, data: UserLoggedIn());
}
