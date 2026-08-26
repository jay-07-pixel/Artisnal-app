import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/preset_capture_guidance.dart';
import '../../../domain/entities/lighting_advisory.dart';
import '../../../shared/widgets/asset_placeholder.dart';
import '../../../shared/widgets/common.dart';
import '../../capture/capture_session_controller.dart';
import '../../home/shot_sets_controller.dart';
import 'tutorial_page.dart';

/// Lighting notes shown before the camera opens.
///
/// Copy and placement advice come from the selected preset's technique and
/// setup steps, plus the on-device daylight advisory. Missing illustrations
/// are shown as labelled placeholders. The step-by-step arranging of the
/// cloth is not done here — that happens over the live preview.
class LightingSetupPage extends ConsumerWidget {
  const LightingSetupPage({required this.setId, super.key});

  final String setId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final set = ref.watch(shotSetProvider(setId));
    final session = ref.watch(captureSessionProvider);
    final preset = ref.watch(selectedPresetProvider);
    final guidance = ref.watch(sessionGuidanceProvider);
    final captureGuidance = ref.watch(sessionCaptureGuidanceProvider);
    final technique = captureGuidance.technique;
    final slotLabel = _slotLabel(session);
    final hasTutorial = hasTutorialContent(preset);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(set?.productName ?? 'Setup'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.space20,
          AppDimens.pagePadding,
          AppDimens.space32,
        ),
        children: [
          AppPill(label: hasTutorial ? 'Step 1 of 2' : 'Before you shoot'),
          const SizedBox(height: AppDimens.space16),
          Text('Lighting and setup', style: AppTypography.displayLarge),
          if (slotLabel.isNotEmpty) ...[
            const SizedBox(height: AppDimens.space8),
            Text(slotLabel, style: AppTypography.bodyMedium),
          ],
          const SizedBox(height: AppDimens.space20),
          const _DaylightAdvisoryCard(),
          const SizedBox(height: AppDimens.space20),
          CatalogImage(
            assetPath: _illustrationAsset(captureGuidance),
            placeholderLabel: 'Setup illustration to be added',
            height: 180,
          ),
          const SizedBox(height: AppDimens.space20),
          if (guidance.hasContent) ...[
            _InfoCard(
              icon: Icons.checklist_outlined,
              title: 'Content',
              body: guidance.content,
            ),
            const SizedBox(height: AppDimens.space12),
          ],
          if (guidance.hasNeeds) ...[
            _InfoCard(
              icon: Icons.inventory_2_outlined,
              title: 'Needs',
              body: guidance.needs!,
            ),
            const SizedBox(height: AppDimens.space12),
          ],
          if (captureGuidance.placement != null &&
              captureGuidance.placement!.trim().isNotEmpty)
            _InfoCard(
              icon: Icons.place_outlined,
              title: 'Place the product',
              body: captureGuidance.placement!,
            )
          else if (guidance.hasPlacement)
            _InfoCard(
              icon: Icons.place_outlined,
              title: 'Place the product',
              body: guidance.placement!,
            ),
          if ((captureGuidance.placement != null &&
                  captureGuidance.placement!.trim().isNotEmpty) ||
              guidance.hasPlacement)
            const SizedBox(height: AppDimens.space12),
          if (preset == null && guidance.hasSetupGuidance) ...[
            _InfoCard(
              icon: Icons.tune_outlined,
              title: 'Setup',
              body: guidance.setupGuidance.join('\n'),
            ),
            const SizedBox(height: AppDimens.space12),
          ],
          _InfoCard(
            icon: Icons.smartphone_outlined,
            title: technique.angle.label,
            body: technique.angle.hint,
          ),
          const SizedBox(height: AppDimens.space12),
          _InfoCard(
            icon: Icons.wb_sunny_outlined,
            title: technique.lighting.label,
            body: guidance.lightingNotes ?? technique.lighting.hint,
          ),
          if (guidance.templateName != null || preset != null) ...[
            const SizedBox(height: AppDimens.space12),
            _InfoCard(
              icon: Icons.grid_on_outlined,
              title: technique.composition.label,
              body: technique.composition.hint,
            ),
          ],
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: FilledButton(
          onPressed: () => context.pushNamed(
            hasTutorial ? AppRoute.tutorial : AppRoute.capture,
            pathParameters: {'setId': setId},
          ),
          child: Text(hasTutorial ? 'Continue' : 'Open Camera'),
        ),
      ),
    );
  }

  static String _slotLabel(CaptureSession session) {
    final type = session.shotType;
    final index = session.slotIndex;
    if (type == null || index == null || index >= type.slotLabels.length) {
      return '';
    }
    return '${type.label} · ${type.slotLabels[index]}';
  }

  /// First setup-step drawing from the resolved guidance, when one is named.
  static String? _illustrationAsset(PresetCaptureGuidance captureGuidance) {
    for (final step in captureGuidance.setupSteps) {
      if (step.hasIllustrationPath) return step.illustrationAsset;
    }
    return null;
  }
}

class _DaylightAdvisoryCard extends StatelessWidget {
  const _DaylightAdvisoryCard();

  @override
  Widget build(BuildContext context) {
    final advisory = LightingAdvisory.forTime(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: advisory.shouldWait
            ? AppColors.surfaceSelected
            : AppColors.surfaceSand,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(
          color: advisory.shouldWait ? AppColors.border : AppColors.successBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            advisory.shouldWait
                ? Icons.wb_twilight_outlined
                : Icons.lightbulb_outline,
            size: 20,
            color: advisory.shouldWait ? AppColors.warning : AppColors.success,
          ),
          const SizedBox(width: AppDimens.space8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  advisory.headline,
                  style: AppTypography.labelLargeBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(advisory.detail, style: AppTypography.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
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
