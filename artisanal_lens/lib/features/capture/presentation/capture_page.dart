import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/capture_feedback.dart';
import '../../../domain/entities/preset_capture_guidance.dart';
import '../../../domain/entities/shot_type.dart';
import '../../../l10n/app_copy.dart';
import '../../../shared/widgets/common.dart';
import '../../home/shot_sets_controller.dart';
import '../camera_controller.dart';
import '../capture_session_controller.dart';
import 'widgets/guide_overlay.dart';

/// Guided capture — Figma frames "Guided Camera Interface" and
/// "Refined Camera Interface".
///
/// The camera inspects what is actually in front of the lens and says one
/// thing about it. Every message on this screen comes from the current frame:
/// there is no step sequence to walk through and no way to advance by
/// pressing anything. The shutter stays enabled throughout — guidance
/// advises, it never blocks.
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
    ref
        .read(guidedCameraProvider.notifier)
        .start(ref.read(sessionCaptureGuidanceProvider));
  }

  @override
  Widget build(BuildContext context) {
    final camera = ref.watch(guidedCameraProvider);
    final session = ref.watch(captureSessionProvider);
    final guidance = ref.watch(sessionGuidanceProvider);
    final captureGuidance = ref.watch(sessionCaptureGuidanceProvider);
    final set = ref.watch(shotSetProvider(widget.setId));

    final technique = captureGuidance.technique;
    final l10n = AppLocalizations.of(context);
    final slotLabel = session.shotType == null
        ? ''
        : (session.slotIndex != null &&
                session.slotIndex! < session.shotType!.slotLabels.length
            ? AppCopy.slotLabel(
                l10n,
                session.shotType!,
                session.slotIndex!,
              )
            : AppCopy.shotTypeLabel(l10n, session.shotType!));
    final overlayCaption = camera.feedback.hasVisiblePrompt
        ? ''
        : (AppCopy.overlayCaptionForTemplate(l10n, guidance.templateName) ??
            (slotLabel.isEmpty
                ? ''
                : l10n.fillFrameWith(
                    l10n.localeName == 'en'
                        ? slotLabel.toLowerCase()
                        : slotLabel,
                  )));

    return Scaffold(
      backgroundColor: AppColors.textPrimary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _Preview(camera: camera),
          if (camera.isReady)
            GuideOverlay(
              grid: technique.grid,
              // Live analysis already names the one thing to change. The
              // catalog caption is a static setup line and fights it.
              caption: overlayCaption,
            ),
          _TopBar(
            productName: set?.productName ?? '',
            shotTypeLabel: session.shotType == null
                ? ''
                : AppCopy.shotTypeLabel(l10n, session.shotType!).toUpperCase(),
            progress: '${(set?.completedCount ?? 0) + 1}'
                '/${set?.requiredCount ?? ShotType.totalRequired}',
          ),
          _StatusChips(
            feedback: camera.feedback,
            analysisAvailable: GuidedCameraController.isGuidanceSupported,
          ),
          _LiveGuidancePill(
            feedback: camera.feedback,
            guidance: captureGuidance,
            analysisAvailable: GuidedCameraController.isGuidanceSupported,
            categoryId: set?.categoryId,
          ),
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

/// Always-on Light / Distance / Centre readouts.
///
/// The pill below still names the one action to take. These chips stay
/// visible so a dim room is not hidden behind "Center the saree".
class _StatusChips extends StatelessWidget {
  const _StatusChips({
    required this.feedback,
    required this.analysisAvailable,
  });

  final CaptureFeedback feedback;
  final bool analysisAvailable;

  @override
  Widget build(BuildContext context) {
    if (!analysisAvailable) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final top = MediaQuery.paddingOf(context).top + AppDimens.appBarHeight + 8;
    final measured = feedback.hasVisiblePrompt;

    return Positioned(
      top: top,
      left: AppDimens.pagePadding,
      right: AppDimens.pagePadding,
      child: Row(
        children: [
          _StatusChip(
            label: l10n.chipLight,
            value: measured
                ? AppCopy.lightChip(l10n, feedback.lightQuality)
                : l10n.chipEmDash,
            ok: measured && feedback.lightQuality.isAcceptable,
          ),
          const SizedBox(width: AppDimens.space8),
          _StatusChip(
            label: l10n.chipDistance,
            value: measured
                ? AppCopy.distanceChip(l10n, feedback.distanceQuality)
                : l10n.chipEmDash,
            ok: measured && feedback.distanceQuality.isAcceptable,
          ),
          const SizedBox(width: AppDimens.space8),
          _StatusChip(
            label: l10n.chipCentre,
            value: measured
                ? AppCopy.centreChip(l10n, feedback.centreQuality)
                : l10n.chipEmDash,
            ok: measured && feedback.centreQuality.isAcceptable,
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.value,
    required this.ok,
  });

  final String label;
  final String value;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final waiting = value == '—';
    final color = waiting
        ? AppColors.white.withValues(alpha: 0.55)
        : ok
            ? AppColors.success
            : AppColors.warning;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cameraScrim,
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          border: Border.all(color: color.withValues(alpha: 0.85), width: ok || waiting ? 1 : 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: AppTypography.navLabel.copyWith(
                color: AppColors.white.withValues(alpha: 0.75),
                fontWeight: FontWeight.w500,
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: AppTypography.labelSmall.copyWith(
                  color: waiting ? AppColors.white.withValues(alpha: 0.8) : color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The single live suggestion, floated over the preview.
///
/// Small on purpose: the product is what the artisan needs to see, so this
/// carries one sentence and nothing else. Its wording is whatever the last
/// analysed frame produced, so it changes as the cloth and the phone move.
/// Green only ever appears when the analyser has confirmed every check the
/// preset can actually run.
class _LiveGuidancePill extends StatelessWidget {
  const _LiveGuidancePill({
    required this.feedback,
    required this.guidance,
    required this.analysisAvailable,
    this.categoryId,
  });

  final CaptureFeedback feedback;
  final PresetCaptureGuidance guidance;

  /// False where the platform gives no frame stream (web). Nothing is
  /// measured there, so the pill falls back to the preset's own rule and
  /// never claims the shot is ready.
  final bool analysisAvailable;
  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ready = analysisAvailable && feedback.isReadyToShoot;
    final measured = analysisAvailable && feedback.hasVisiblePrompt;
    final noun = AppCopy.productNoun(l10n, categoryId);

    final text = measured
        ? AppCopy.capturePrompt(l10n, feedback.prompt, noun)
        : analysisAvailable
            ? l10n.readingTheFrame
            : AppCopy.compositionHint(l10n, guidance.technique.composition);

    // Nothing in view is the one moment where the preset's own placement
    // line helps more than a measurement can.
    final detail = measured && feedback.prompt == CapturePrompt.noProduct
        ? guidance.cameraGuidance.placementInstruction
        : null;

    return Positioned(
      left: AppDimens.pagePadding,
      right: AppDimens.pagePadding,
      bottom: 128,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Container(
            key: ValueKey(text),
            constraints: const BoxConstraints(maxWidth: 340),
            padding: const EdgeInsets.fromLTRB(
              AppDimens.space16,
              AppDimens.space8 + 2,
              AppDimens.space16,
              AppDimens.space8 + 2,
            ),
            decoration: BoxDecoration(
              color: ready
                  ? AppColors.success.withValues(alpha: 0.94)
                  : measured
                      ? AppColors.warning.withValues(alpha: 0.95)
                      : AppColors.cameraScrim,
              borderRadius: BorderRadius.circular(AppDimens.radiusPill),
              border: measured
                  ? null
                  : Border.all(color: AppColors.white.withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _iconFor(ready, measured),
                      size: 16,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: AppDimens.space8),
                    Flexible(
                      child: Text(
                        text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelLargeBold.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                if (detail != null) ...[
                  const SizedBox(height: AppDimens.space4),
                  Text(
                    detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(bool ready, bool measured) {
    if (ready) return Icons.check_circle;
    if (!measured) return Icons.hourglass_empty;
    return switch (feedback.prompt) {
      CapturePrompt.tooDark ||
      CapturePrompt.lowLight ||
      CapturePrompt.tooBright ||
      CapturePrompt.backlightDetected =>
        Icons.wb_sunny_outlined,
      CapturePrompt.holdSteady => Icons.pan_tool_outlined,
      CapturePrompt.tiltPhone => Icons.screen_rotation_outlined,
      CapturePrompt.noProduct => Icons.center_focus_weak,
      _ => Icons.center_focus_strong,
    };
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
