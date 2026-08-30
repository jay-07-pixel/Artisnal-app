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
      version: 3,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _createSchema,
      onUpgrade: _upgradeSchema,
    );
    return AppDatabase._(database);
  }

  static const String tableSyncMeta = 'sync_meta';
  static const String syncMetaLastPullKey = 'last_remote_pull_at';

  static Future<void> _createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableSets (
        id           TEXT    PRIMARY KEY,
        product_name TEXT    NOT NULL,
        category_id  TEXT    NOT NULL,
        material_id  TEXT,
        silk_type_id TEXT,
        created_at   INTEGER NOT NULL,
        updated_at   INTEGER NOT NULL,
        sync_status  TEXT    NOT NULL DEFAULT 'pending'
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
        storage_path      TEXT,
        sync_status       TEXT    NOT NULL DEFAULT 'pending',
        FOREIGN KEY (set_id) REFERENCES $tableSets (id) ON DELETE CASCADE,
        UNIQUE (set_id, shot_type, slot_index)
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_shots_set ON $tableShots (set_id)',
    );

    await db.execute('''
      CREATE TABLE $tableSyncMeta (
        key   TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
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
    if (oldVersion < 3) {
      await db.execute(
        "ALTER TABLE $tableSets ADD COLUMN updated_at INTEGER",
      );
      await db.execute(
        "ALTER TABLE $tableSets ADD COLUMN sync_status TEXT NOT NULL DEFAULT 'pending'",
      );
      await db.execute(
        "UPDATE $tableSets SET updated_at = created_at WHERE updated_at IS NULL",
      );

      await db.execute(
        "ALTER TABLE $tableShots ADD COLUMN storage_path TEXT",
      );
      await db.execute(
        "ALTER TABLE $tableShots ADD COLUMN sync_status TEXT NOT NULL DEFAULT 'pending'",
      );

      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableSyncMeta (
          key   TEXT PRIMARY KEY,
          value TEXT NOT NULL
        )
      ''');
    }
  }

  // ----------------------------------------------------------- cloud sync
  Future<List<Map<String, Object?>>> pendingShotSets() => _db.query(
        tableSets,
        where: "sync_status = 'pending'",
      );

  Future<List<Map<String, Object?>>> pendingShots() => _db.query(
        tableShots,
        where: "sync_status = 'pending'",
      );

  Future<void> markShotSetSynced(String setId) => _db.update(
        tableSets,
        {'sync_status': 'synced'},
        where: 'id = ?',
        whereArgs: [setId],
      );

  Future<void> markShotSynced(
    String shotId, {
    required String storagePath,
  }) =>
      _db.update(
        tableShots,
        {
          'sync_status': 'synced',
          'storage_path': storagePath,
        },
        where: 'id = ?',
        whereArgs: [shotId],
      );

  Future<DateTime> lastRemotePullAt() async {
    final rows = await _db.query(
      tableSyncMeta,
      where: 'key = ?',
      whereArgs: [syncMetaLastPullKey],
      limit: 1,
    );
    if (rows.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.fromMillisecondsSinceEpoch(
      int.parse(rows.first['value']! as String),
    );
  }

  Future<void> setLastRemotePullAt(DateTime at) => _db.insert(
        tableSyncMeta,
        {
          'key': syncMetaLastPullKey,
          'value': '${at.millisecondsSinceEpoch}',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  /// Inserts or updates a remote set when cloud data is newer or local is synced.
  Future<void> upsertRemoteShotSet(Map<dynamic, dynamic> remote) async {
    final id = remote['id'] as String;
    final remoteUpdated = DateTime.parse(
      remote['updated_at'] as String? ?? remote['created_at'] as String,
    ).millisecondsSinceEpoch;

    final existing = await _db.query(
      tableSets,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      final row = existing.first;
      final localUpdated =
          row['updated_at'] as int? ?? row['created_at'] as int? ?? 0;
      final localPending = (row['sync_status'] as String?) == 'pending';
      if (localPending && localUpdated >= remoteUpdated) return;
    }

    final createdAt = DateTime.parse(remote['created_at'] as String);
    await _db.insert(
      tableSets,
      {
        'id': id,
        'product_name': remote['product_name'],
        'category_id': remote['category_id'],
        'material_id': remote['material_id'],
        'silk_type_id': remote['silk_type_id'],
        'created_at': createdAt.millisecondsSinceEpoch,
        'updated_at': remoteUpdated,
        'sync_status': 'synced',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Inserts or replaces a shot row from the cloud, keeping a local file path.
  Future<void> upsertRemoteShot({
    required Map<dynamic, dynamic> remote,
    required String filePath,
    required String storagePath,
  }) async {
    final capturedAt = DateTime.parse(remote['captured_at'] as String);
    await _db.insert(
      tableShots,
      {
        'id': remote['id'],
        'set_id': remote['set_id'],
        'shot_type': remote['shot_type'],
        'slot_index': remote['slot_index'],
        'file_path': filePath,
        'captured_at': capturedAt.millisecondsSinceEpoch,
        'preset_id': remote['preset_id'],
        'saved_to_gallery':
            (remote['saved_to_gallery'] as bool? ?? false) ? 1 : 0,
        'storage_path': storagePath,
        'sync_status': 'synced',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, Object?>?> setRowById(String setId) async {
    final rows = await _db.query(
      tableSets,
      where: 'id = ?',
      whereArgs: [setId],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<Map<String, Object?>?> shotRowById(String shotId) async {
    final rows = await _db.query(
      tableShots,
      where: 'id = ?',
      whereArgs: [shotId],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<void> touchShotSet(String setId) => _db.update(
        tableSets,
        {
          'updated_at': DateTime.now().millisecondsSinceEpoch,
          'sync_status': 'pending',
        },
        where: 'id = ?',
        whereArgs: [setId],
      );

  Future<void> close() => _db.close();
}
