import 'package:equatable/equatable.dart';

import 'shot_type.dart';

/// A single photograph the artisan captured and accepted.
class CapturedShot extends Equatable {
  const CapturedShot({
    required this.id,
    required this.setId,
    required this.shotType,
    required this.slotIndex,
    required this.filePath,
    required this.capturedAt,
    this.presetId,
    this.savedToDeviceGallery = false,
  });

  final String id;
  final String setId;
  final ShotType shotType;

  /// Which of the type's named slots this photograph fills.
  ///
  /// Detail slot 0 is "Border", 1 is "Weave", 2 is "Motif", and so on — the
  /// gallery captions each thumbnail with this label.
  final int slotIndex;

  /// Absolute path to the image inside app storage.
  final String filePath;

  final DateTime capturedAt;

  /// The style preset used, absent for Detail shots which skip the style step.
  final String? presetId;

  /// Whether the copy in the device gallery was written successfully.
  final bool savedToDeviceGallery;

  /// The caption shown under this photograph in the gallery.
  String get slotLabel => slotIndex >= 0 && slotIndex < shotType.slotLabels.length
      ? shotType.slotLabels[slotIndex]
      : shotType.label;

  CapturedShot copyWith({bool? savedToDeviceGallery, String? filePath}) =>
      CapturedShot(
        id: id,
        setId: setId,
        shotType: shotType,
        slotIndex: slotIndex,
        filePath: filePath ?? this.filePath,
        capturedAt: capturedAt,
        presetId: presetId,
        savedToDeviceGallery: savedToDeviceGallery ?? this.savedToDeviceGallery,
      );

  @override
  List<Object?> get props => [id, setId, shotType, slotIndex, filePath];
}

/// One required photograph in a set, filled or not.
class ShotSlot extends Equatable {
  const ShotSlot({
    required this.shotType,
    required this.index,
    required this.label,
    this.shot,
  });

  final ShotType shotType;
  final int index;
  final String label;

  /// The photograph filling this slot, if one has been accepted.
  final CapturedShot? shot;

  bool get isFilled => shot != null;

  @override
  List<Object?> get props => [shotType, index, label, shot];
}

/// Filter states offered on the gallery screen.
///
/// The design shows these as chips: All, Sarees, Shawls, Stoles, Cushion
/// Covers — i.e. "all", or one category.
class GalleryFilter extends Equatable {
  const GalleryFilter.all() : categoryId = null;

  const GalleryFilter.category(String this.categoryId);

  /// Null means "All".
  final String? categoryId;

  bool matches(ShotSet set) =>
      categoryId == null || set.categoryId == categoryId;

  @override
  List<Object?> get props => [categoryId];
}

/// A photo shoot for one product — the unit the home and gallery screens list
/// and the checklist tracks.
class ShotSet extends Equatable {
  const ShotSet({
    required this.id,
    required this.productName,
    required this.categoryId,
    required this.createdAt,
    this.shots = const [],
  });

  final String id;

  /// Artisan-supplied name, e.g. "Blue Silk Saree".
  final String productName;

  final String categoryId;
  final DateTime createdAt;
  final List<CapturedShot> shots;

  /// Every required photograph in the set, in checklist order, each paired
  /// with the shot filling it if there is one.
  List<ShotSlot> get slots {
    final result = <ShotSlot>[];
    for (final type in ShotType.values) {
      for (var i = 0; i < type.requiredCount; i++) {
        result.add(
          ShotSlot(
            shotType: type,
            index: i,
            label: type.slotLabels[i],
            shot: _shotFor(type, i),
          ),
        );
      }
    }
    return result;
  }

  CapturedShot? _shotFor(ShotType type, int index) {
    for (final shot in shots) {
      if (shot.shotType == type && shot.slotIndex == index) return shot;
    }
    return null;
  }

  /// Photographs accepted for a given type.
  int completedCountFor(ShotType type) =>
      shots.where((shot) => shot.shotType == type).length;

  List<CapturedShot> shotsFor(ShotType type) =>
      shots.where((shot) => shot.shotType == type).toList()
        ..sort((a, b) => a.slotIndex.compareTo(b.slotIndex));

  /// Total accepted photographs, capped at what the set actually requires.
  int get completedCount => shots.length;

  int get requiredCount => ShotType.totalRequired;

  bool get isFinished => completedCount >= requiredCount;

  double get completionRatio =>
      requiredCount == 0 ? 1 : (completedCount / requiredCount).clamp(0.0, 1.0);

  /// The next empty slot, following the recommended order.
  ///
  /// This drives the "RECOMMENDED NEXT" badge and the "Start with …" button.
  ShotSlot? get nextSlot {
    for (final type in ShotType.recommendedOrder) {
      for (var i = 0; i < type.requiredCount; i++) {
        if (_shotFor(type, i) == null) {
          return ShotSlot(
            shotType: type,
            index: i,
            label: type.slotLabels[i],
          );
        }
      }
    }
    return null;
  }

  /// Next empty slot within one type, used after the artisan picks a type.
  ShotSlot? nextSlotFor(ShotType type) {
    for (var i = 0; i < type.requiredCount; i++) {
      if (_shotFor(type, i) == null) {
        return ShotSlot(shotType: type, index: i, label: type.slotLabels[i]);
      }
    }
    return null;
  }

  /// Most recent photograph, used as the card thumbnail.
  CapturedShot? get coverShot {
    if (shots.isEmpty) return null;
    final sorted = [...shots]
      ..sort((a, b) => b.capturedAt.compareTo(a.capturedAt));
    return sorted.first;
  }

  ShotSet copyWith({String? productName, List<CapturedShot>? shots}) => ShotSet(
        id: id,
        productName: productName ?? this.productName,
        categoryId: categoryId,
        createdAt: createdAt,
        shots: shots ?? this.shots,
      );

  @override
  List<Object?> get props => [id, productName, categoryId, createdAt, shots];
}
