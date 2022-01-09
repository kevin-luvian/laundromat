import 'package:drift/drift.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/stream.dart';
import 'package:laundry/helpers/logger.dart';

class ProjectionEvent {
  final String streamId;
  final String streamType;
  final String streamTag;
  final DateTime date;
  final int version;

  ProjectionEvent({
    required this.streamId,
    required this.streamType,
    required this.date,
    required this.version,
    required this.streamTag,
  });

  Map<String, dynamic> dataToMap() => {};

  EventsCompanion toEvent() => EventsCompanion(
        streamId: Value(streamId),
        streamType: Value(streamType),
        tag: Value(streamTag),
        version: Value(version),
        date: Value(date),
        data: Value(dataToMap()),
      );
}

class NanEvent extends ProjectionEvent {
  NanEvent()
      : super(
          streamId: "",
          streamType: "",
          streamTag: "",
          date: DateTime(0),
          version: 0,
        );
}

Future<Event?> persistEvent(EventDao dao, ProjectionEvent e) async {
  try {
    final event = await dao.createEvent(e.toEvent());
    EventStream.sink.add(event);
    return event;
  } catch (err) {
    loggerStack.e(err);
    EventStream.sink.addError(err);
    return null;
  }
}
