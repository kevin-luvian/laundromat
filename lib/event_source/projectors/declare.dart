import 'dart:async';

import 'package:laundry/db/event_db.dart';

abstract class IProjector {
  Future<void> project(Event event);
}
