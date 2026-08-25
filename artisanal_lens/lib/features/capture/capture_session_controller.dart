import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/entities/fold_preset.dart';
import '../../domain/entities/shot_type.dart';

/// The choices the artisan has made for the photograph they are about to take.
///
/// The flow is deliberately one decision per screen (shot type → style →
/// camera), so this carries the accumulated answers between those screens
/// instead of threading them through navigation arguments.
class CaptureSession extends Equatable {
  const CaptureSession({
    this.setId,
    this.shotType,
    this.slotIndex,
    this.presetId,
    this.pendingPhotoPath,
  });

  final String? setId;
  final ShotType? shotType;

  /// Which named slot of [shotType] is being filled.
  final int? slotIndex;

  /// Chosen style preset; null for Detail shots, which skip that step.
  final String? presetId;

  /// A photograph taken but not yet accepted on the review screen.
  final String? pendingPhotoPath;

  bool get canOpenCamera =>
      setId != null &&
      shotType != null &&
      slotIndex != null &&
      (shotType!.skipsStyleStep || presetId != null);

  CaptureSession copyWith({
    String? setId,
    ShotType? shotType,
    int? slotIndex,
    String? presetId,
    String? pendingPhotoPath,
    bool clearPreset = false,
    bool clearPendingPhoto = false,
  }) {
    return CaptureSession(
      setId: setId ?? this.setId,
      shotType: shotType ?? this.shotType,
      slotIndex: slotIndex ?? this.slotIndex,
      presetId: clearPreset ? null : (presetId ?? this.presetId),
      pendingPhotoPath: clearPendingPhoto
          ? null
          : (pendingPhotoPath ?? this.pendingPhotoPath),
    );
  }

  @override
  List<Object?> get props =>
      [setId, shotType, slotIndex, presetId, pendingPhotoPath];
}

class CaptureSessionController extends Notifier<CaptureSession> {
  @override
  CaptureSession build() => const CaptureSession();

  /// Begins a shoot for a set, clearing anything left from a previous one.
  void startFor(String setId) {
    state = CaptureSession(setId: setId);
  }

  /// Records the chosen shot type and the slot it will fill.
  ///
  /// Changing the type invalidates any previously chosen style, because styles
  /// are scoped to the type.
  void chooseShotType(ShotType shotType, {required int slotIndex}) {
    state = state.copyWith(
      shotType: shotType,
      slotIndex: slotIndex,
      clearPreset: true,
    );
  }

  void choosePreset(String presetId) {
    state = state.copyWith(presetId: presetId);
  }

  void setPendingPhoto(String path) {
    state = state.copyWith(pendingPhotoPath: path);
  }

  void discardPendingPhoto() {
    state = state.copyWith(clearPendingPhoto: true);
  }

  /// Clears everything except the set, ready for the next photograph.
  void completeShot() {
    state = CaptureSession(setId: state.setId);
  }

  /// The preset object for [CaptureSession.presetId], if one is chosen.
  FoldPreset? get selectedPreset {
    final id = state.presetId;
    if (id == null) return null;
    return ref.read(catalogRepositoryProvider).presetById(id);
  }
}

final captureSessionProvider =
    NotifierProvider<CaptureSessionController, CaptureSession>(
  CaptureSessionController.new,
);

/// The currently selected style preset, or null when none applies.
final selectedPresetProvider = Provider<FoldPreset?>((ref) {
  final presetId = ref.watch(captureSessionProvider).presetId;
  if (presetId == null) return null;
  return ref.watch(catalogRepositoryProvider).presetById(presetId);
});
