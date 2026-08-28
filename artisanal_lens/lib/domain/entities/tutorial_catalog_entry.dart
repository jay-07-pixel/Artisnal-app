/// Tutorial metadata stored in Supabase (`public.tutorial_videos`).
///
/// Videos and step images live in Storage; this row holds display names,
/// transcript lines, and keys that resolve to public URLs.
class TutorialCatalogEntry {
  const TutorialCatalogEntry({
    required this.presetId,
    required this.categoryId,
    required this.name,
    required this.videoStorageKey,
    this.thumbnailStorageKey,
    this.transcript = const [],
    this.stepImages = const [],
  });

  final String presetId;
  final String categoryId;
  final String name;
  final String videoStorageKey;
  final String? thumbnailStorageKey;
  final List<String> transcript;
  final List<TutorialStepImage> stepImages;

  bool get hasTranscript => transcript.isNotEmpty;
  bool get hasStepImages => stepImages.isNotEmpty;

  factory TutorialCatalogEntry.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['step_images'];
    final steps = <TutorialStepImage>[];
    if (rawSteps is List) {
      for (final item in rawSteps) {
        if (item is Map<String, dynamic>) {
          steps.add(TutorialStepImage.fromJson(item));
        }
      }
    }

    final rawTranscript = json['transcript'];
    final transcript = <String>[];
    if (rawTranscript is List) {
      for (final line in rawTranscript) {
        if (line is String && line.trim().isNotEmpty) {
          transcript.add(line.trim());
        }
      }
    }

    return TutorialCatalogEntry(
      presetId: json['preset_id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      videoStorageKey: json['video_storage_key'] as String,
      thumbnailStorageKey: json['thumbnail_storage_key'] as String?,
      transcript: transcript,
      stepImages: steps,
    );
  }
}

class TutorialStepImage {
  const TutorialStepImage({
    this.title,
    this.instruction,
    this.storageKey,
    this.bundledAsset,
  });

  final String? title;
  final String? instruction;
  final String? storageKey;
  final String? bundledAsset;

  bool get hasStorageKey =>
      storageKey != null && storageKey!.trim().isNotEmpty;

  bool get hasBundledAsset =>
      bundledAsset != null && bundledAsset!.trim().isNotEmpty;

  factory TutorialStepImage.fromJson(Map<String, dynamic> json) {
    return TutorialStepImage(
      title: json['title'] as String?,
      instruction: json['instruction'] as String?,
      storageKey: json['storage_key'] as String?,
      bundledAsset: json['bundled_asset'] as String?,
    );
  }
}
