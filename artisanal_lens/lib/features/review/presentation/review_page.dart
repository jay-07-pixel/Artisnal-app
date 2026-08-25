import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/shot_set.dart';
import '../../../shared/widgets/common.dart';
import '../../capture/camera_controller.dart';
import '../../capture/capture_session_controller.dart';
import '../../home/shot_sets_controller.dart';
import '../../instruction/instruction_flow.dart';

/// Review & retake — Figma frame "Refined Photo Review".
///
/// The new photograph is shown against the reference preset so a mismatch is
/// obvious before it is accepted. "Use Photo" persists the shot and advances
/// the checklist; "Retake" discards it and returns to the camera.
class ReviewPage extends ConsumerStatefulWidget {
  const ReviewPage({required this.setId, super.key});

  final String setId;

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(captureSessionProvider);
    final preset = ref.watch(selectedPresetProvider);
    final set = ref.watch(shotSetProvider(widget.setId));
    final photoPath = session.pendingPhotoPath;

    if (photoPath == null) {
      // Nothing to review — most likely a back-navigation into a stale route.
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: Text(set?.productName ?? 'Review')),
        body: Center(
          child: Text('No photo to review.', style: AppTypography.bodyMedium),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _retake,
        ),
        title: Text(set?.productName ?? 'Review'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: PhotoThumb(
                    path: photoPath,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                Positioned(
                  top: AppDimens.space16,
                  right: AppDimens.space16,
                  child: AppPill(
                    label: _qualityLabel,
                    icon: Icons.check_circle,
                    background: AppColors.white,
                    foreground: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimens.pagePadding),
            child: Column(
              children: [
                if (preset != null)
                  Container(
                    padding: const EdgeInsets.all(AppDimens.space12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSelected,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusLg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child:
                              PhotoThumb(path: preset.referenceImageAsset),
                        ),
                        const SizedBox(width: AppDimens.space12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'REFERENCE PRESET',
                                style: AppTypography.overline,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                preset.name,
                                style: AppTypography.displaySmall
                                    .copyWith(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppDimens.space20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isSaving ? null : _retake,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Retake'),
                      ),
                    ),
                    const SizedBox(width: AppDimens.space12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _isSaving ? null : _accept,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Icon(Icons.check, size: 18),
                        label: const Text('Use Photo'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Feedback carried over from the moment of capture.
  String get _qualityLabel {
    final feedback = ref.read(guidedCameraProvider).feedback;
    return feedback.isReadyToShoot ? 'Great framing' : 'Check framing';
  }

  Future<void> _retake() async {
    ref.read(captureSessionProvider.notifier).discardPendingPhoto();
    await ref.read(guidedCameraProvider.notifier).resumePreview();
    if (mounted) context.pop();
  }

  Future<void> _accept() async {
    final session = ref.read(captureSessionProvider);
    final path = session.pendingPhotoPath;
    final shotType = session.shotType;
    final slotIndex = session.slotIndex;

    if (path == null || shotType == null || slotIndex == null) return;

    setState(() => _isSaving = true);
    try {
      // Move the capture out of the camera's temporary directory into app
      // storage so it survives the OS clearing caches.
      final stored = await _persistPhoto(path);
      final savedToGallery = await ref.read(photoStorageProvider).saveToDeviceGallery(stored);

      final shot = CapturedShot(
        id: 'shot_${DateTime.now().microsecondsSinceEpoch}',
        setId: widget.setId,
        shotType: shotType,
        slotIndex: slotIndex,
        filePath: stored,
        capturedAt: DateTime.now(),
        presetId: session.presetId,
        savedToDeviceGallery: savedToGallery,
      );

      await ref
          .read(shotSetsProvider.notifier)
          .addShot(setId: widget.setId, shot: shot);

      ref.read(captureSessionProvider.notifier).completeShot();
      if (!mounted) return;

      // The photo list is the hub: the new photograph shows as complete and
      // the next required slot is highlighted.
      returnToPhotoList(context, widget.setId);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save the photo: $error')),
      );
    }
  }

  Future<String> _persistPhoto(String tempPath) {
    return ref
        .read(photoStorageProvider)
        .persist(tempPath, setId: widget.setId);
  }
}
