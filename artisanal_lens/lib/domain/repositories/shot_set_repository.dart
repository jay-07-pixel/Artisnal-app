import '../entities/shot_set.dart';

/// Persistence for shoots and the photographs inside them.
///
/// Everything here is local-first: the app must work with no connectivity,
/// which the deck lists as a hard requirement ("Guides and overlays run locally
/// on-device; photos sync when connectivity is available").
abstract interface class ShotSetRepository {
  /// All sets, newest first.
  Future<List<ShotSet>> watchAll();

  Future<ShotSet?> findById(String id);

  /// Creates an empty set for a product and returns it.
  Future<ShotSet> createSet({
    required String productName,
    required String categoryId,
  });

  /// Records an accepted photograph against a set.
  Future<ShotSet> addShot({
    required String setId,
    required CapturedShot shot,
  });

  /// Removes a photograph, e.g. when the artisan deletes a bad frame later.
  Future<ShotSet> removeShot({required String setId, required String shotId});

  Future<void> renameSet({required String setId, required String productName});

  Future<void> deleteSet(String setId);
}
