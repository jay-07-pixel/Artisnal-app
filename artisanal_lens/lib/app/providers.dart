import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/app_database.dart';
import '../data/datasources/photo_storage.dart';
import '../data/datasources/preset_catalog.dart';
import '../data/repositories/catalog_repository_impl.dart';
import '../data/repositories/shot_set_repository_impl.dart';
import '../domain/repositories/catalog_repository.dart';
import '../domain/repositories/shot_set_repository.dart';
import '../data/services/cloud_sync_service.dart';
import '../domain/services/capture_guidance_service.dart';
import '../domain/services/frame_analyzer.dart';

/// Opened once at startup and overridden in [ProviderScope] so the rest of the
/// tree can depend on it synchronously.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(
    'databaseProvider must be overridden in ProviderScope with the instance '
    'opened during bootstrap.',
  ),
);

/// Where captured photographs are kept — files on a phone, bytes in a browser.
final photoStorageProvider = Provider<PhotoStorage>(
  (ref) => createPhotoStorage(),
);

final catalogDataSourceProvider = Provider<CatalogDataSource>(
  (ref) => const BundledCatalogDataSource(),
);

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => CatalogRepositoryImpl(ref.watch(catalogDataSourceProvider)),
);

final shotSetRepositoryProvider = Provider<ShotSetRepository>(
  (ref) => ShotSetRepositoryImpl(ref.watch(databaseProvider)),
);

final frameAnalyzerProvider = Provider<FrameAnalyzer>(
  (ref) => const FrameAnalyzer(),
);

final captureGuidanceServiceProvider = Provider<CaptureGuidanceService>(
  (ref) => const CaptureGuidanceService(),
);

final cloudSyncServiceProvider = Provider<CloudSyncService>(
  (ref) => CloudSyncService(
    database: ref.watch(databaseProvider),
    photoStorage: ref.watch(photoStorageProvider),
  ),
);
