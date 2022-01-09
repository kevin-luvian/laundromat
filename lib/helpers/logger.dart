import 'package:logger/logger.dart';

var loggerStack = Logger();

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
