import 'package:flutter/material.dart';
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

ColorScheme colorScheme(BuildContext context) {
  return Theme.of(context).colorScheme;
}
