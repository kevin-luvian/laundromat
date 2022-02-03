import 'package:drift/drift.dart';
import 'package:laundry/db/dao/event/event.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/stream.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/helpers/utils.dart';

class ProjectionEvent<T> {
  final Serializer<T> serializer;
  final String streamId;
  final String streamType;
  final String streamTag;
  final DateTime date;
  final int version;
  final T data;

  ProjectionEvent({
    required this.streamId,
    required this.streamType,
    required this.streamTag,
    required this.date,
    required this.version,
    required this.data,
    required this.serializer,
  });

  ProjectionEvent.fromEvent(Event event, this.serializer)
      : streamId = event.streamId,
        streamType = event.streamType,
        date = event.date,
        version = event.version,
        streamTag = event.tag,
        data = serializer.fromJson(event.data);

  EventsCompanion toEvent() {
    return EventsCompanion(
      streamId: Value(streamId),
      streamType: Value(streamType),
      tag: Value(streamTag),
      version: Value(version),
      date: Value(date),
      data: Value(serializer.toJson(data)),
    );
  }
}

class NanEvent implements Serializer {
  @override
  void fromJson(_) {}

  @override
  Map<String, dynamic> toJson(_) => {};
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
