import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

LazyDatabase openReadDBConnection() => _openConnection("reads");

LazyDatabase openEventDBConnection() => _openConnection("events");

LazyDatabase _openConnection(String filename) => LazyDatabase(() async {
      // final dbFolder = await getApplicationDocumentsDirectory();
      final dbFolder = (await getExternalCacheDirectories())![0];
      final file = File(path.join(dbFolder.path, '$filename.sqlite'));

      logger.i(dbFolder);
      return NativeDatabase(file);
    });
