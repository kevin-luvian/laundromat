import 'dart:async';

import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';
import 'package:laundry/event_source/projectors/customer_projector.dart';
import 'package:laundry/event_source/projectors/product_addon_projector.dart';
import 'package:laundry/event_source/projectors/product_projector.dart';
import 'package:laundry/event_source/projectors/user_projector.dart';
import 'package:laundry/event_source/stream.dart';

class ProjectorListeners {
  final DriftDB _db;
  List<StreamSubscription<Event>> subs = [];

  ProjectorListeners(this._db);

  void setup() {
    subs = [
      UserProjector(_db),
      ProductProjector(_db),
      ProductAddonProjector(_db),
      CustomerProjector(_db),
    ].map((p) => EventStream.stream.listen(p.project)).toList();
  }

  Future<void> dispose() async {
    await Future.wait(subs.map((s) => s.cancel()).toList());
  }
}
