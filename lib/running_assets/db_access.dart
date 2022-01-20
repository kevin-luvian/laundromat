import 'package:get_it/get_it.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';

DriftDB get driftDB {
  return GetIt.I.get<DriftDB>();
}

EventDB get eventDB {
  return GetIt.I.get<EventDB>();
}
