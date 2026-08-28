import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/supabase_config.dart';
import '../datasources/app_database.dart';
import '../datasources/photo_storage.dart';
import 'supabase_initializer.dart';

/// Pushes local shot sets and photographs to Supabase when enabled.
///
/// Cloud backup is currently disabled — it previously required email/password
/// auth. Local SQLite remains the source of truth.
class CloudSyncService {
  CloudSyncService({
    required AppDatabase database,
    required PhotoStorage photoStorage,
    Connectivity? connectivity,
  })  : _database = database,
        _photoStorage = photoStorage,
        _connectivity = connectivity ?? Connectivity();

  final AppDatabase _database;
  final PhotoStorage _photoStorage;
  final Connectivity _connectivity;

  SupabaseClient? get _client => supabaseClient;

  bool get canSync => false;

  /// Upload pending rows and pull remote changes since the last sync.
  Future<CloudSyncResult> syncAll() async {
    if (!canSync) {
      return const CloudSyncResult(skipped: true);
    }

    if (!await _isOnline()) {
      return const CloudSyncResult(offline: true);
    }

    final client = _client!;

    var uploadedSets = 0;
    var uploadedShots = 0;
    var pulledSets = 0;

    // Push local metadata first.
    final pendingSets = await _database.pendingShotSets();
    for (final row in pendingSets) {
      await client.from('shot_sets').upsert({
        'id': row['id'],
        'product_name': row['product_name'],
        'category_id': row['category_id'],
        'material_id': row['material_id'],
        'silk_type_id': row['silk_type_id'],
        'created_at': DateTime.fromMillisecondsSinceEpoch(
          row['created_at'] as int,
        ).toUtc().toIso8601String(),
        'updated_at': DateTime.fromMillisecondsSinceEpoch(
          row['updated_at'] as int? ?? row['created_at'] as int,
        ).toUtc().toIso8601String(),
      });
      await _database.markShotSetSynced(row['id'] as String);
      uploadedSets++;
    }

    final pendingShots = await _database.pendingShots();
    for (final row in pendingShots) {
      final shotId = row['id'] as String;
      final setId = row['set_id'] as String;
      final filePath = row['file_path'] as String;
      final storagePath = '$setId/$shotId.jpg';

      final bytes = await _readPhotoBytes(filePath);
      if (bytes != null) {
        await client.storage.from(SupabaseConfig.photosBucket).uploadBinary(
              storagePath,
              bytes,
              fileOptions: const FileOptions(
                contentType: 'image/jpeg',
                upsert: true,
              ),
            );
      }

      await client.from('shots').upsert({
        'id': shotId,
        'set_id': setId,
        'shot_type': row['shot_type'],
        'slot_index': row['slot_index'],
        'storage_path': storagePath,
        'captured_at': DateTime.fromMillisecondsSinceEpoch(
          row['captured_at'] as int,
        ).toUtc().toIso8601String(),
        'preset_id': row['preset_id'],
        'saved_to_gallery': (row['saved_to_gallery'] as int? ?? 0) == 1,
        'uploaded_at': DateTime.now().toUtc().toIso8601String(),
      });

      await _database.markShotSynced(shotId, storagePath: storagePath);
      uploadedShots++;
    }

    await _database.setLastRemotePullAt(DateTime.now());
    return CloudSyncResult(
      uploadedSets: uploadedSets,
      uploadedShots: uploadedShots,
      pulledSets: pulledSets,
    );
  }

  Future<bool> _isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<Uint8List?> _readPhotoBytes(String filePath) async {
    try {
      return await _photoStorage.readBytes(filePath);
    } catch (_) {
      return null;
    }
  }
}

class CloudSyncResult {
  const CloudSyncResult({
    this.uploadedSets = 0,
    this.uploadedShots = 0,
    this.pulledSets = 0,
    this.skipped = false,
    this.offline = false,
  });

  final int uploadedSets;
  final int uploadedShots;
  final int pulledSets;
  final bool skipped;
  final bool offline;

  bool get didWork => uploadedSets > 0 || uploadedShots > 0 || pulledSets > 0;
}
