import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'database_factory_stub.dart'
    if (dart.library.js_interop) 'database_factory_web.dart';

/// Local SQLite storage for shoots and photographs.
///
/// The app is offline-first — a shoot must survive being closed mid-set with no
/// connectivity — so everything is written locally and nothing here requires a
/// network.
class AppDatabase {
  AppDatabase._(this._db);

  final Database _db;

  Database get db => _db;

  static const String tableSets = 'shot_sets';
  static const String tableShots = 'shots';

  static Future<AppDatabase> open({String fileName = 'artisanal_lens.db'}) async {
    // On the web the same SQL runs against sqlite compiled to WASM. The
    // factory is swapped via a conditional import so Android never loads
    // the web plugin (that caused a MissingPluginException on the phone).
    configureDatabaseFactory();

    final directory = await getDatabasesPath();
    final database = await openDatabase(
      p.join(directory, fileName),
      version: 2,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _createSchema,
      onUpgrade: _upgradeSchema,
    );
    return AppDatabase._(database);
  }

  static Future<void> _createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableSets (
        id           TEXT    PRIMARY KEY,
        product_name TEXT    NOT NULL,
        category_id  TEXT    NOT NULL,
        material_id  TEXT,
        silk_type_id TEXT,
        created_at   INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableShots (
        id                TEXT    PRIMARY KEY,
        set_id            TEXT    NOT NULL,
        shot_type         TEXT    NOT NULL,
        slot_index        INTEGER NOT NULL,
        file_path         TEXT    NOT NULL,
        captured_at       INTEGER NOT NULL,
        preset_id         TEXT,
        saved_to_gallery  INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (set_id) REFERENCES $tableSets (id) ON DELETE CASCADE,
        UNIQUE (set_id, shot_type, slot_index)
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_shots_set ON $tableShots (set_id)',
    );
  }

  static Future<void> _upgradeSchema(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $tableSets ADD COLUMN material_id TEXT',
      );
      await db.execute(
        'ALTER TABLE $tableSets ADD COLUMN silk_type_id TEXT',
      );
    }
  }

  Future<void> close() => _db.close();
}
