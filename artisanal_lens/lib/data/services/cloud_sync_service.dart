import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/supabase_config.dart';
import '../datasources/app_database.dart';
import '../datasources/photo_storage.dart';
import 'supabase_initializer.dart';

/// Pushes local shot sets and photographs to Supabase when signed in.
///
/// Local SQLite remains the source of truth on-device; the cloud copy lets
/// artisans sign in on another phone and see their progress.
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

  bool get canSync =>
      _client != null && _client!.auth.currentSession?.user != null;

  /// Pull remote changes, then push pending local rows.
  Future<CloudSyncResult> syncAll() async {
    if (!canSync) {
      return const CloudSyncResult(skipped: true);
    }

    if (!await _isOnline()) {
      return const CloudSyncResult(offline: true);
    }

    final client = _client!;
    final userId = client.auth.currentUser!.id;

    var uploadedSets = 0;
    var uploadedShots = 0;
    var pulledSets = 0;
    var pulledShotsCount = 0;

    pulledSets = await _pullRemote(client, userId, onPulledShot: () {
      pulledShotsCount++;
    });

    final pendingSets = await _database.pendingShotSets();
    for (final row in pendingSets) {
      await client.from('shot_sets').upsert({
        'id': row['id'],
        'user_id': userId,
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
      final storagePath = '$userId/$setId/$shotId.jpg';

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
        'user_id': userId,
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
      pulledShots: pulledShotsCount,
    );
  }

  Future<int> _pullRemote(
    SupabaseClient client,
    String userId, {
    required void Function() onPulledShot,
  }) async {
    var pulledSets = 0;

    final setRows = await client
        .from('shot_sets')
        .select()
        .eq('user_id', userId)
        .order('updated_at');

    for (final remote in setRows) {
      final setId = remote['id'] as String;
      final existingSet = await _database.setRowById(setId);
      final wasNew = existingSet == null;
      await _database.upsertRemoteShotSet(remote);
      if (wasNew) pulledSets++;
    }

    final shotRows = await client
        .from('shots')
        .select()
        .eq('user_id', userId);

    for (final remote in shotRows) {
      final shotId = remote['id'] as String;
      final setId = remote['set_id'] as String;
      final storagePath = remote['storage_path'] as String?;
      final existing = await _database.shotRowById(shotId);

      String filePath = existing?['file_path'] as String? ?? '';
      final hasLocalFile =
          filePath.isNotEmpty && await _photoStorage.readBytes(filePath) != null;

      if (!hasLocalFile && storagePath != null && storagePath.isNotEmpty) {
        try {
          final bytes = await client.storage
              .from(SupabaseConfig.photosBucket)
              .download(storagePath);
          filePath = await _photoStorage.persistBytes(
            Uint8List.fromList(bytes),
            setId: setId,
            shotId: shotId,
          );
          onPulledShot();
        } catch (_) {
          if (filePath.isEmpty) continue;
        }
      }

      if (filePath.isEmpty) continue;

      await _database.upsertRemoteShot(
        remote: remote,
        filePath: filePath,
        storagePath: storagePath ?? '$userId/$setId/$shotId.jpg',
      );
    }

    return pulledSets;
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
    this.pulledShots = 0,
    this.skipped = false,
    this.offline = false,
  });

  final int uploadedSets;
  final int uploadedShots;
  final int pulledSets;
  final int pulledShots;
  final bool skipped;
  final bool offline;

  bool get didWork =>
      uploadedSets > 0 ||
      uploadedShots > 0 ||
      pulledSets > 0 ||
      pulledShots > 0;
}
