import 'dart:async';

import 'package:laundry/db/event_db.dart';
import 'package:rxdart/rxdart.dart';

final Event defaultEvent = Event(
  id: 0,
  streamId: "",
  streamType: "",
  tag: "",
  version: 0,
  date: DateTime(10),
  data: <String, dynamic>{},
);

class EventStream {
  static PublishSubject<Event>? _eventStreamController;

  static void close() => get().close();

  static StreamSink<Event> get sink => get().sink;

  static Stream<Event> get stream => get().stream;

  static StreamController<Event> get() {
    if (_eventStreamController?.isClosed ?? true) {
      _eventStreamController = PublishSubject<Event>();
    }
    return _eventStreamController!;
  }
}
