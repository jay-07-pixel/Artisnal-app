import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/capture_feedback.dart';
import '../../../domain/entities/shot_type.dart';
import '../../../domain/entities/technique_preset.dart';
import '../../../shared/widgets/common.dart';
import '../../home/shot_sets_controller.dart';
import '../camera_controller.dart';
import '../capture_session_controller.dart';
import 'widgets/guide_overlay.dart';

/// Guided capture — Figma frames "Guided Camera Interface" and
/// "Refined Camera Interface".
///
/// Live preview with the preset's ghost frame and grid, the Angle and Light
/// chips, and the shutter row. The shutter stays enabled even when a prompt is
/// showing: guidance advises, it never blocks.
class CapturePage extends ConsumerStatefulWidget {
  const CapturePage({required this.setId, super.key});

  final String setId;

  @override
  ConsumerState<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends ConsumerState<CapturePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startCamera());
  }

  void _startCamera() {
    ref.read(guidedCameraProvider.notifier).start(_resolveTechnique());
  }

  TechniquePreset _resolveTechnique() {
    return ref.read(sessionTechniqueProvider);
  }

  @override
  Widget build(BuildContext context) {
    final camera = ref.watch(guidedCameraProvider);
    final session = ref.watch(captureSessionProvider);
    final guidance = ref.watch(sessionGuidanceProvider);
    final set = ref.watch(shotSetProvider(widget.setId));

    final technique = guidance.technique;
    final slotLabel = session.shotType == null
        ? ''
        : (session.slotIndex != null &&
                session.slotIndex! < session.shotType!.slotLabels.length
            ? session.shotType!.slotLabels[session.slotIndex!]
            : session.shotType!.label);

    return Scaffold(
      backgroundColor: AppColors.textPrimary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _Preview(camera: camera),
          if (camera.isReady)
            GuideOverlay(
              grid: technique.grid,
              caption: guidance.overlayCaption ??
                  'Fill the frame with the ${slotLabel.toLowerCase()}',
            ),
          _TopBar(
            productName: set?.productName ?? '',
            shotTypeLabel: session.shotType?.label.toUpperCase() ?? '',
            progress: '${(set?.completedCount ?? 0) + 1}'
                '/${ShotType.totalRequired}',
          ),
          if (camera.isReady && GuidedCameraController.isGuidanceSupported)
            _FeedbackChips(feedback: camera.feedback, technique: technique),
          _ShutterBar(
            camera: camera,
            setId: widget.setId,
            capturedCount: set?.completedCount ?? 0,
            lastThumbPath: set?.coverShot?.filePath,
            onCapture: _onCapture,
          ),
        ],
      ),
    );
  }

  Future<void> _onCapture() async {
    final path = await ref.read(guidedCameraProvider.notifier).capture();
    if (path == null || !mounted) return;

    ref.read(captureSessionProvider.notifier).setPendingPhoto(path);
    if (!mounted) return;
    context.pushNamed(
      AppRoute.review,
      pathParameters: {'setId': widget.setId},
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.camera});

  final GuidedCameraState camera;

  @override
  Widget build(BuildContext context) {
    if (camera.isReady) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: camera.controller!.value.previewSize?.height ?? 1,
          height: camera.controller!.value.previewSize?.width ?? 1,
          child: CameraPreview(camera.controller!),
        ),
      );
    }

    final message = switch (camera.status) {
      CameraStatus.permissionDenied =>
        'Camera permission is needed to take photos.\n'
            'Please allow camera access in Settings.',
      CameraStatus.unavailable =>
        camera.errorMessage ?? 'The camera is unavailable.',
      _ => null,
    };

    return ColoredBox(
      color: AppColors.textPrimary,
      child: Center(
        child: message == null
            ? const CircularProgressIndicator(color: AppColors.white)
            : Padding(
                padding: const EdgeInsets.all(AppDimens.space32),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.productName,
    required this.shotTypeLabel,
    required this.progress,
  });

  final String productName;
  final String shotTypeLabel;
  final String progress;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: AppColors.cameraScrim,
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: AppDimens.appBarHeight,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: () => context.pop(),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (shotTypeLabel.isNotEmpty)
                        Text(
                          shotTypeLabel,
                          style: AppTypography.overline.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      Text(
                        productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.displayMedium.copyWith(
                          color: AppColors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: AppDimens.space16),
                  child: Text(
                    progress,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The Angle and Light chips.
class _FeedbackChips extends StatelessWidget {
  const _FeedbackChips({required this.feedback, required this.technique});

  final CaptureFeedback feedback;
  final TechniquePreset technique;

  @override
  Widget build(BuildContext context) {
    final angleOk = feedback.angleQuality.isAcceptable;

    return Positioned(
      top: AppDimens.appBarHeight + 56,
      left: 0,
      right: 0,
      child: Column(
        children: [
          _Chip(
            icon: angleOk ? Icons.check_circle : Icons.screen_rotation,
            label: 'Angle: ${feedback.angleQuality.label}',
            background: angleOk
                ? AppColors.success.withValues(alpha: 0.92)
                : AppColors.primary.withValues(alpha: 0.92),
          ),
          const SizedBox(height: AppDimens.space8),
          _Chip(
            icon: feedback.isReadyToShoot
                ? Icons.check_circle
                : Icons.lightbulb_outline,
            label: feedback.isReadyToShoot
                ? 'Ready'
                : feedback.prompt.message,
            background: feedback.isReadyToShoot
                ? AppColors.success.withValues(alpha: 0.92)
                : AppColors.warning.withValues(alpha: 0.95),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space12,
        vertical: AppDimens.space8,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.white),
          const SizedBox(width: AppDimens.space4 + 2),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

class _ShutterBar extends StatelessWidget {
  const _ShutterBar({
    required this.camera,
    required this.setId,
    required this.capturedCount,
    required this.lastThumbPath,
    required this.onCapture,
  });

  final GuidedCameraState camera;
  final String setId;
  final int capturedCount;
  final String? lastThumbPath;
  final Future<void> Function() onCapture;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: AppColors.cameraScrim,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space20,
              vertical: AppDimens.space16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ThumbBadge(
                  path: lastThumbPath,
                  count: capturedCount,
                  // Figma labels this "Button - View Gallery": it opens the
                  // set being shot, so the artisan can check what they have
                  // without abandoning the camera.
                  onTap: capturedCount == 0
                      ? null
                      : () => context.pushNamed(
                            AppRoute.productViewer,
                            pathParameters: {'setId': setId},
                          ),
                ),
                _ShutterButton(
                  isBusy: camera.isCapturing,
                  onTap: camera.isReady && !camera.isCapturing
                      ? onCapture
                      : null,
                ),
                Row(
                  children: [
                    if (camera.canUseFlash)
                      _RoundIcon(
                        icon: camera.isFlashOn
                            ? Icons.flash_on
                            : Icons.flash_off,
                        onTap: camera.isReady
                            ? () => ProviderScope.containerOf(context)
                                .read(guidedCameraProvider.notifier)
                                .toggleFlash()
                            : null,
                      ),
                    if (camera.canSwitchCamera) ...[
                      if (camera.canUseFlash)
                        const SizedBox(width: AppDimens.space8),
                      _RoundIcon(
                        icon: Icons.flip_camera_ios_outlined,
                        onTap: camera.isReady && !camera.isSwitchingCamera
                            ? () => ProviderScope.containerOf(context)
                                .read(guidedCameraProvider.notifier)
                                .switchCamera()
                            : null,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThumbBadge extends StatelessWidget {
  const _ThumbBadge({required this.path, required this.count, this.onTap});

  final String? path;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: _buildBadge(),
    );
  }

  Widget _buildBadge() {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.5),
                ),
              ),
              child: path == null
                  ? null
                  : PhotoThumb(
                      path: path!,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusMd - 1),
                    ),
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: AppTypography.navLabel.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.isBusy, required this.onTap});

  final bool isBusy;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap == null ? null : () => onTap!(),
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: onTap == null
              ? AppColors.primaryLight.withValues(alpha: 0.5)
              : AppColors.primaryLight,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 4),
        ),
        child: isBusy
            ? const Padding(
                padding: EdgeInsets.all(AppDimens.space20),
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : null,
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 20),
      ),
    );
  }
}
