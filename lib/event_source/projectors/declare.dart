import 'dart:async';

import 'package:laundry/db/event_db.dart';

abstract class IProjector {
  Future<void> project(Event event);
}

void assertStreamId(List<Event> events) {
  assert(events.isNotEmpty);
  final streamId = events.first.streamId;
  assert(events.every((e) => e.streamId == streamId));
}
