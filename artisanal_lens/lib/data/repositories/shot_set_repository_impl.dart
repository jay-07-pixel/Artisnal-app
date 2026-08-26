import 'package:sqflite/sqflite.dart';

import '../../domain/entities/shot_set.dart';
import '../../domain/entities/shot_type.dart';
import '../../domain/repositories/shot_set_repository.dart';
import '../datasources/app_database.dart';

class ShotSetRepositoryImpl implements ShotSetRepository {
  ShotSetRepositoryImpl(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<List<ShotSet>> watchAll() async {
    final setRows = await _db.query(
      AppDatabase.tableSets,
      orderBy: 'created_at DESC',
    );
    if (setRows.isEmpty) return const [];

    final shotRows = await _db.query(AppDatabase.tableShots);
    final shotsBySet = <String, List<CapturedShot>>{};
    for (final row in shotRows) {
      final shot = _shotFromRow(row);
      shotsBySet.putIfAbsent(shot.setId, () => []).add(shot);
    }

    return setRows
        .map((row) => _setFromRow(row, shotsBySet[row['id'] as String] ?? []))
        .toList();
  }

  @override
  Future<ShotSet?> findById(String id) async {
    final setRows = await _db.query(
      AppDatabase.tableSets,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (setRows.isEmpty) return null;

    final shotRows = await _db.query(
      AppDatabase.tableShots,
      where: 'set_id = ?',
      whereArgs: [id],
    );
    return _setFromRow(setRows.first, shotRows.map(_shotFromRow).toList());
  }

  @override
  Future<ShotSet> createSet({
    required String productName,
    required String categoryId,
    String? materialId,
    String? silkTypeId,
  }) async {
    final now = DateTime.now();
    final set = ShotSet(
      id: 'set_${now.microsecondsSinceEpoch}',
      productName: productName,
      categoryId: categoryId,
      materialId: materialId,
      silkTypeId: silkTypeId,
      createdAt: now,
    );

    await _db.insert(AppDatabase.tableSets, {
      'id': set.id,
      'product_name': set.productName,
      'category_id': set.categoryId,
      'material_id': set.materialId,
      'silk_type_id': set.silkTypeId,
      'created_at': set.createdAt.millisecondsSinceEpoch,
    });

    return set;
  }

  @override
  Future<ShotSet> addShot({
    required String setId,
    required CapturedShot shot,
  }) async {
    // Re-shooting a slot replaces whatever was there, which is what the
    // "Retake" path expects.
    await _db.insert(
      AppDatabase.tableShots,
      {
        'id': shot.id,
        'set_id': setId,
        'shot_type': shot.shotType.id,
        'slot_index': shot.slotIndex,
        'file_path': shot.filePath,
        'captured_at': shot.capturedAt.millisecondsSinceEpoch,
        'preset_id': shot.presetId,
        'saved_to_gallery': shot.savedToDeviceGallery ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final updated = await findById(setId);
    if (updated == null) {
      throw StateError('Shot set $setId disappeared while adding a photo.');
    }
    return updated;
  }

  @override
  Future<ShotSet> removeShot({
    required String setId,
    required String shotId,
  }) async {
    await _db.delete(
      AppDatabase.tableShots,
      where: 'id = ?',
      whereArgs: [shotId],
    );
    final updated = await findById(setId);
    if (updated == null) {
      throw StateError('Shot set $setId disappeared while removing a photo.');
    }
    return updated;
  }

  @override
  Future<void> renameSet({
    required String setId,
    required String productName,
  }) async {
    await _db.update(
      AppDatabase.tableSets,
      {'product_name': productName},
      where: 'id = ?',
      whereArgs: [setId],
    );
  }

  @override
  Future<void> deleteSet(String setId) async {
    await _db.delete(
      AppDatabase.tableSets,
      where: 'id = ?',
      whereArgs: [setId],
    );
  }

  // --------------------------------------------------------------- mapping
  ShotSet _setFromRow(Map<String, Object?> row, List<CapturedShot> shots) {
    return ShotSet(
      id: row['id'] as String,
      productName: row['product_name'] as String,
      categoryId: row['category_id'] as String,
      materialId: row['material_id'] as String?,
      silkTypeId: row['silk_type_id'] as String?,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
      shots: shots,
    );
  }

  CapturedShot _shotFromRow(Map<String, Object?> row) {
    final type = ShotType.fromId(row['shot_type'] as String);
    if (type == null) {
      throw StateError('Unknown shot type "${row['shot_type']}" in database.');
    }
    return CapturedShot(
      id: row['id'] as String,
      setId: row['set_id'] as String,
      shotType: type,
      slotIndex: row['slot_index'] as int,
      filePath: row['file_path'] as String,
      capturedAt:
          DateTime.fromMillisecondsSinceEpoch(row['captured_at'] as int),
      presetId: row['preset_id'] as String?,
      savedToDeviceGallery: (row['saved_to_gallery'] as int? ?? 0) == 1,
    );
  }
}
