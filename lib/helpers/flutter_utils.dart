import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

Future<String> getFilePath(String filename) async {
  var path = "";
  final extDir = await getExternalStorageDirectory();
  if (extDir != null) {
    path = extDir.path;
  } else {
    final appDir = await getApplicationDocumentsDirectory();
    path = appDir.path;
  }

  path = '$path/images';
  await Directory(path).create();
  return "$path/$filename";
}

Future<String> saveExtFile(String prefix, File file) async {
  final timeStr = DateFormat("yyyyMMdd_HHmmss").format(DateTime.now());
  final filename = "${prefix}_$timeStr${extension(file.path)}";
  final pathToSave = await getFilePath(filename);
  file.copySync(pathToSave);
  return pathToSave;
}

Size screenSize(BuildContext context) => MediaQuery.of(context).size;

ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Text(
      text,
      style: TextStyle(color: colorScheme(context).onSurface),
    ),
    backgroundColor: colorScheme(context).surface,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String dateToStringLocale(DateTime date, AppLocalizations? locale) {
  return "${date.day} ${monthToString(date.month, locale)} ${date.year}";
}

String dateToStringLocaleFull(DateTime date, AppLocalizations? locale) {
  final hourStr = date.hour.toString().padLeft(2, "0");
  final minuteStr = date.minute.toString().padLeft(2, "0");
  final monthStr = capitalizeFirstLetter(monthToString(date.month, locale));
  return "${date.day} $monthStr ${date.year} $hourStr:$minuteStr";
}

String capitalizeFirstLetter(String text) {
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

String monthToString(int month, AppLocalizations? locale) {
  switch (month) {
    case DateTime.january:
      return locale?.january ?? "-";
    case DateTime.february:
      return locale?.february ?? "-";
    case DateTime.march:
      return locale?.march ?? "-";
    case DateTime.april:
      return locale?.april ?? "-";
    case DateTime.may:
      return locale?.may ?? "-";
    case DateTime.june:
      return locale?.june ?? "-";
    case DateTime.july:
      return locale?.july ?? "-";
    case DateTime.august:
      return locale?.august ?? "-";
    case DateTime.september:
      return locale?.september ?? "-";
    case DateTime.october:
      return locale?.october ?? "-";
    case DateTime.november:
      return locale?.november ?? "-";
    case DateTime.december:
      return locale?.december ?? "-";
    default:
      return "-";
  }
}
