import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/common/confirmation_dialog.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/db/tables/users.dart';
import 'package:laundry/event_source/commands/full_command.dart';
import 'package:laundry/helpers/csv_creator.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/hooks/use_user_role_checker.dart';
import 'package:laundry/pages/settings/widgets/setting_card.dart';
import 'package:laundry/running_assets/dao_access.dart';
import 'package:laundry/running_assets/db_access.dart';

const driftViewerCard = RoleSettingCard(
  title: "View And Access Drift DB",
  child: DriftViewer(),
  allowedRoles: [roleSuperAdmin],
);

class DriftViewer extends HookWidget {
  const DriftViewer() : super(key: null);

  void generateCSV(BuildContext context) async {
    final events = await eventDao.findAll();
    final path = await createCSV(events);
    logger.i("PATH: $path");

    showSnackBar(context, path);
  }

  void readCSVFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final path = result.files.single.path;
      if (path != null) {
        final events = await readFromCSV(path);
        await eventDao.replaceEvents(events);

        final snackBar = SnackBar(
          content: const Text('events replaced'),
          backgroundColor: colorScheme(context).primary,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      // User canceled the picker
    }
  }

  void deleteAllEvents(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => ConfirmationDialog(
        onContinue: () => eventDao.truncate(),
        content: "delete all events?",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = useUserRoleChecker();
    if (!role.isSuperAdmin) {
      return Container();
    }
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
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _button(
                context: context,
                text: "Event DB Data To Excel",
                onPressed: () => generateCSV(context),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _button(
                context: context,
                text: "Excel To Event DB Data",
                onPressed: () => readCSVFile(context),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _button(
                context: context,
                text: "Delete All Event DB Data",
                onPressed: () => deleteAllEvents(context),
                color: colorScheme(context).secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _button({
    required void Function() onPressed,
    required BuildContext context,
    required String text,
    Color? color,
  }) =>
      RectButton(
        size: const Size.fromHeight(60),
        child: Text(text),
        color: color ?? colorScheme(context).primary,
        onPressed: onPressed,
      );
}
