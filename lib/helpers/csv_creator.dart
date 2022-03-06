import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:laundry/db/event_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:universal_io/io.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> createCSV(List<Event> events) async {
  String? basePath;
  if (Platform.isAndroid) {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      basePath = (await getExternalStorageDirectories(
              type: StorageDirectory.documents))
          ?.first
          .path;
    }
  } else {
    basePath = (await getExternalStorageDirectory())?.path;
  }

  if (basePath == null) throw "External directory not found";

  final date = DateFormat("dd-MM-yyyy-HH:mm").format(DateTime.now());
  final path = "$basePath/backup-$date.csv";

  List<List<String>> rows = [
    ["id", "stream_id", "stream_type", "tag", "version", "date", "data"]
  ];
  for (final event in events) {
    final row = <String>[];
    row.add("${event.id}");
    row.add(event.streamId);
    row.add(event.streamType);
    row.add(event.tag);
    row.add("${event.version}");
    row.add("${event.date}");
    row.add(json.encode(event.data));
    rows.add(row);
  }

  String? csvData = const ListToCsvConverter().convert(rows);
  final file = await File(path).create(recursive: true);
  await file.writeAsString(csvData, mode: FileMode.write);
  return path;
}

Future<List<Event>> readFromCSV(String path) async {
  final file = File(path).openRead();
  final rows = await file
      .transform(utf8.decoder)
      .transform(const CsvToListConverter())
      .toList();

  final objects = <Map<String, String>>[];
  for (int i = 1; i < rows.length; i++) {
    final header = rows[0];
    final row = rows[i];
    final mObject = <String, String>{};
    for (int _i = 0; _i < row.length; _i++) {
      mObject["${header[_i]}"] = "${row[_i]}";
    }
    objects.add(mObject);
  }

  final events = objects
      .map((o) => Event(
            id: int.parse(o["id"]!),
            streamId: o["stream_id"]!,
            streamType: o["stream_type"]!,
            tag: o["tag"]!,
            version: int.parse(o["version"]!),
            date: DateTime.parse(o["date"]!),
            data: json.decode(o["data"]!) as Map<String, dynamic>,
          ))
      .toList();
  return events;
}
