import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/event_source/commands/full_command.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/running_assets/db_access.dart';

class DriftViewer extends StatelessWidget {
  const DriftViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _button(
                context: context,
                text: "Delete All Data",
                onPressed: () async {
                  await FullCommand(driftDB, eventDB).deleteAllData();

                  final snackBar = SnackBar(
                    content: const Text('all data deleted'),
                    backgroundColor: colorScheme(context).primary,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _button(
                context: context,
                text: "Replay All Events",
                onPressed: () async {
                  await FullCommand(driftDB, eventDB).replayAllEvents();

                  final snackBar = SnackBar(
                    content: const Text('all events replayed'),
                    backgroundColor: colorScheme(context).primary,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _button(
          context: context,
          text: "View Drift DB Data",
          onPressed: () => Navigator.of(context).push<void>(MaterialPageRoute(
            builder: (_) => DriftDbViewer(driftDB),
          )),
        ),
        const SizedBox(height: 10),
        _button(
          context: context,
          text: "View Event DB Data",
          onPressed: () => Navigator.of(context).push<void>(MaterialPageRoute(
            builder: (_) => DriftDbViewer(eventDB),
          )),
        ),
      ],
    );
  }

  Widget _button({
    required BuildContext context,
    required String text,
    required void Function() onPressed,
  }) {
    return RectButton(
      size: const Size.fromHeight(60),
      child: Text(text),
      color: colorScheme(context).primary,
      onPressed: onPressed,
    );
  }
}
