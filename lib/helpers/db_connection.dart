import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

LazyDatabase openReadDBConnection() =>
    LazyDatabase(() => _createDatabase("reads"));

Future<NativeDatabase> openReadDBConnection2() => _createDatabase("reads");

LazyDatabase openEventDBConnection() =>
    LazyDatabase(() => _createDatabase("events"));

Future<NativeDatabase> openEventDBConnection2() => _createDatabase("events");

Future<NativeDatabase> _createDatabase(String filename) async {
  final dbFolder = await getApplicationDocumentsDirectory();
  // final dbFolder = await getExternalStorageDirectory();
  final file = File(path.join(dbFolder.path, '$filename.sqlite'));

  logger.i(dbFolder);
  return NativeDatabase(file);
}
