import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/entities/shot_set.dart';
import '../../domain/repositories/shot_set_repository.dart';

/// Holds every shoot on the device, newest first.
///
/// Screens read this rather than the repository directly, so a photograph
/// accepted on the review screen is reflected on the home, checklist and
/// gallery screens without any of them re-querying.
class ShotSetsController extends AsyncNotifier<List<ShotSet>> {
  ShotSetRepository get _repository => ref.read(shotSetRepositoryProvider);

  @override
  Future<List<ShotSet>> build() => _repository.watchAll();

  Future<ShotSet> createSet({
    required String productName,
    required String categoryId,
    String? materialId,
    String? silkTypeId,
  }) async {
    final created = await _repository.createSet(
      productName: productName,
      categoryId: categoryId,
      materialId: materialId,
      silkTypeId: silkTypeId,
    );
    await _refresh();
    await _syncIfSignedIn();
    return created;
  }

  Future<ShotSet> addShot({
    required String setId,
    required CapturedShot shot,
  }) async {
    final updated = await _repository.addShot(setId: setId, shot: shot);
    await _refresh();
    await _syncIfSignedIn();
    return updated;
  }

  Future<void> removeShot({required String setId, required String shotId}) async {
    await _repository.removeShot(setId: setId, shotId: shotId);
    await _refresh();
    await _syncIfSignedIn();
  }

  Future<void> rename({required String setId, required String productName}) async {
    await _repository.renameSet(setId: setId, productName: productName);
    await _refresh();
    await _syncIfSignedIn();
  }

  Future<void> deleteSet(String setId) async {
    await _repository.deleteSet(setId);
    await _refresh();
    await _syncIfSignedIn();
  }

  Future<void> _syncIfSignedIn() async {
    final sync = ref.read(cloudSyncServiceProvider);
    if (!sync.canSync) return;
    try {
      await sync.syncAll();
    } catch (_) {
      // Non-fatal — local work is already saved.
    }
  }

  Future<void> _refresh() async {
    state = AsyncValue.data(await _repository.watchAll());
  }

  /// Reloads from SQLite after a cloud pull.
  Future<void> refreshFromDatabase() => _refresh();
}

final shotSetsProvider =
    AsyncNotifierProvider<ShotSetsController, List<ShotSet>>(
  ShotSetsController.new,
);

/// One shoot by id, kept in sync with [shotSetsProvider].
final shotSetProvider = Provider.family<ShotSet?, String>((ref, setId) {
  final sets = ref.watch(shotSetsProvider).valueOrNull ?? const <ShotSet>[];
  for (final set in sets) {
    if (set.id == setId) return set;
  }
  return null;
});

/// The most recent unfinished shoot, surfaced by the home screen's
/// "CONTINUE PHOTOGRAPHY" card.
final continuableSetProvider = Provider<ShotSet?>((ref) {
  final sets = ref.watch(shotSetsProvider).valueOrNull ?? const <ShotSet>[];
  for (final set in sets) {
    if (!set.isFinished && set.completedCount > 0) return set;
  }
  return null;
});
