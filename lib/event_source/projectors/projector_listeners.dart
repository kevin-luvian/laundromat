import 'dart:async';

import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/projectors/user_projector.dart';
import 'package:laundry/event_source/stream.dart';

class ProjectorListeners {
  final DriftDB _db;
  final List<StreamSubscription<Event>> subs = [];

  ProjectorListeners(this._db);

  setup() {
    subs.add(UserProjector(_db).listen(EventStream.stream));
  }

  Future<void> dispose() async {
    for (final s in subs) {
      await s.cancel();
    }
  }
}
