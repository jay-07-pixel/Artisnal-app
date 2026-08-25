import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Web-only: the same SQL runs against sqlite compiled to WASM.
void configureDatabaseFactory() {
  databaseFactory = databaseFactoryFfiWeb;
}
