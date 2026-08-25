import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/fold_preset.dart';
import '../../../domain/entities/shot_guidance.dart';
import '../../../domain/entities/technique_preset.dart';
import '../../../shared/widgets/asset_placeholder.dart';
import '../../../shared/widgets/common.dart';
import '../../capture/capture_session_controller.dart';
import '../../capture/presentation/widgets/guide_overlay.dart';
import '../../home/shot_sets_controller.dart';

/// Alignment illustration shown immediately before the existing camera.
///
/// The grid drawn inside the phone frame is the same [GridOverlayType] the
/// live camera will use. Alignment artwork comes from the catalog's alignment
/// step, when that file exists. Missing files stay a labelled placeholder —
/// the fold thumbnail is not used as a stand-in illustration.
class AlignmentPage extends ConsumerWidget {
  const AlignmentPage({required this.setId, super.key});

  final String setId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final set = ref.watch(shotSetProvider(setId));
    final session = ref.watch(captureSessionProvider);
    final preset = ref.watch(selectedPresetProvider);
    final guidance = ref.watch(sessionGuidanceProvider);
    final technique = guidance.technique;
    final canOpen = session.canOpenCamera;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(set?.productName ?? 'Align'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.space20,
          AppDimens.pagePadding,
          AppDimens.space32,
        ),
        children: [
          const AppPill(label: 'Step 3 of 3'),
          const SizedBox(height: AppDimens.space16),
          Text('Align with the gridlines', style: AppTypography.displayLarge),
          const SizedBox(height: AppDimens.space8),
          Text(
            _alignmentInstruction(preset, guidance),
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppDimens.space24),
          _PhonePreview(
            technique: technique,
            illustrationAsset: preset?.alignmentIllustrationAsset,
            caption: guidance.overlayCaption ?? technique.composition.hint,
          ),
          const SizedBox(height: AppDimens.space20),
          _InfoRow(
            icon: Icons.grid_on_outlined,
            title: technique.composition.label,
            body: technique.composition.hint,
          ),
          const SizedBox(height: AppDimens.space12),
          _InfoRow(
            icon: Icons.photo_camera_outlined,
            title: technique.angle.label,
            body: technique.angle.hint,
          ),
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: canOpen
              ? () => context.pushNamed(
                    AppRoute.capture,
                    pathParameters: {'setId': setId},
                  )
              : null,
          icon: const Icon(Icons.photo_camera_outlined, size: 20),
          label: const Text('Open Camera'),
        ),
      ),
    );
  }

  static String _alignmentInstruction(
    FoldPreset? preset,
    ShotGuidance guidance,
  ) {
    if (preset != null) {
      for (final step in preset.setupSteps) {
        final haystack = '${step.title} ${step.instruction}'.toLowerCase();
        if (haystack.contains('align') || haystack.contains('grid')) {
          return step.instruction;
        }
      }
    }
    if (guidance.overlayCaption != null &&
        guidance.overlayCaption!.trim().isNotEmpty) {
      return guidance.overlayCaption!;
    }
    return guidance.technique.composition.hint;
  }
}

class _PhonePreview extends StatelessWidget {
  const _PhonePreview({
    required this.technique,
    required this.illustrationAsset,
    required this.caption,
  });

  final TechniquePreset technique;
  final String? illustrationAsset;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 220,
        padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
        decoration: BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: AppColors.textPrimary,
                  child: CatalogImage(
                    assetPath: illustrationAsset,
                    placeholderLabel: 'Alignment illustration to be added',
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                GuideOverlay(grid: technique.grid, caption: caption),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLargeBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(body, style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
