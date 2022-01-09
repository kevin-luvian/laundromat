import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/event_db.dart';

class DriftViewer extends StatelessWidget {
  const DriftViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          _driftDBViewer(context),
          const SizedBox(height: 10),
          _eventDBViewer(context)
        ],
    );
  }

  Widget _driftDBViewer(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DriftDbViewer(GetIt.I.get<DriftDB>()),
        ));
      },
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).colorScheme.primary,
        minimumSize: const Size.fromHeight(60.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
      ),
      child: const Text("View Drift DB Data"),
    );
  }

  Widget _eventDBViewer(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DriftDbViewer(GetIt.I.get<EventDB>()),
        ));
      },
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).colorScheme.primary,
        minimumSize: const Size.fromHeight(60.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
      ),
      child: const Text("View Event DB Data"),
    );
  }
}
