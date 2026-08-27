import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/fold_preset.dart';
import '../../../domain/entities/lighting_advisory.dart';
import '../../../domain/entities/photography_template.dart';
import '../../../domain/entities/preset_capture_guidance.dart';
import '../../../domain/entities/shot_guidance.dart';
import '../../../l10n/app_copy.dart';
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
    final slotLabel = _slotLabel(context, session);
    final hasTutorial = hasTutorialContent(preset);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(set?.productName ?? l10n.setup),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.space20,
          AppDimens.pagePadding,
          AppDimens.space32,
        ),
        children: [
          AppPill(label: hasTutorial ? l10n.step1of2 : l10n.beforeYouShoot),
          const SizedBox(height: AppDimens.space16),
          Text(l10n.lightingAndSetup, style: AppTypography.displayLarge),
          if (slotLabel.isNotEmpty) ...[
            const SizedBox(height: AppDimens.space8),
            Text(slotLabel, style: AppTypography.bodyMedium),
          ],
          const SizedBox(height: AppDimens.space20),
          const _DaylightAdvisoryCard(),
          const SizedBox(height: AppDimens.space20),
          CatalogImage(
            assetPath: _lookAsset(
              preset: preset,
              guidance: guidance,
              captureGuidance: captureGuidance,
            ),
            placeholderLabel: l10n.setupIllustrationPlaceholder,
            fit: BoxFit.contain,
            height: 240,
          ),
          const SizedBox(height: AppDimens.space20),
          if (guidance.hasContent) ...[
            _InfoCard(
              icon: Icons.checklist_outlined,
              title: l10n.labelContent,
              body: AppCopy.displayedContent(
                l10n,
                preset: preset,
                templateName: guidance.templateName,
                fallback: guidance.content,
              ),
            ),
            const SizedBox(height: AppDimens.space12),
          ],
          if (guidance.hasNeeds) ...[
            _InfoCard(
              icon: Icons.inventory_2_outlined,
              title: l10n.labelNeeds,
              body: AppCopy.displayedNeeds(
                    l10n,
                    preset: preset,
                    templateName: guidance.templateName,
                    fallback: guidance.needs,
                  ) ??
                  guidance.needs!,
            ),
            const SizedBox(height: AppDimens.space12),
          ],
          if (captureGuidance.placement != null &&
              captureGuidance.placement!.trim().isNotEmpty)
            _InfoCard(
              icon: Icons.place_outlined,
              title: l10n.placeTheProduct,
              body: AppCopy.displayedPlacement(
                    l10n,
                    templateName: guidance.templateName,
                    fallback: captureGuidance.placement,
                  ) ??
                  captureGuidance.placement!,
            )
          else if (guidance.hasPlacement)
            _InfoCard(
              icon: Icons.place_outlined,
              title: l10n.placeTheProduct,
              body: AppCopy.displayedPlacement(
                    l10n,
                    templateName: guidance.templateName,
                    fallback: guidance.placement,
                  ) ??
                  guidance.placement!,
            ),
          if ((captureGuidance.placement != null &&
                  captureGuidance.placement!.trim().isNotEmpty) ||
              guidance.hasPlacement)
            const SizedBox(height: AppDimens.space12),
          if (preset == null && guidance.hasSetupGuidance) ...[
            _InfoCard(
              icon: Icons.tune_outlined,
              title: l10n.setupSection,
              body: guidance.setupGuidance.join('\n'),
            ),
            const SizedBox(height: AppDimens.space12),
          ],
          _InfoCard(
            icon: Icons.smartphone_outlined,
            title: AppCopy.angleLabel(l10n, technique.angle),
            body: AppCopy.angleHint(l10n, technique.angle),
          ),
          const SizedBox(height: AppDimens.space12),
          _InfoCard(
            icon: Icons.wb_sunny_outlined,
            title: AppCopy.lightingLabel(l10n, technique.lighting),
            body: AppCopy.lightingNotesForTemplate(l10n, guidance.templateName) ??
                guidance.lightingNotes ??
                AppCopy.lightingHint(l10n, technique.lighting),
          ),
          if (guidance.templateName != null || preset != null) ...[
            const SizedBox(height: AppDimens.space12),
            _InfoCard(
              icon: Icons.grid_on_outlined,
              title: AppCopy.compositionLabel(l10n, technique.composition),
              body: AppCopy.compositionHint(l10n, technique.composition),
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
          child: Text(hasTutorial ? l10n.continueAction : l10n.openCamera),
        ),
      ),
    );
  }

  static String _slotLabel(BuildContext context, CaptureSession session) {
    final type = session.shotType;
    final index = session.slotIndex;
    if (type == null || index == null || index >= type.slotLabels.length) {
      return '';
    }
    final l10n = AppLocalizations.of(context);
    return '${AppCopy.shotTypeLabel(l10n, type)} · ${AppCopy.slotLabel(l10n, type, index)}';
  }

  /// The photo of how this setup should look.
  ///
  /// Dedicated step drawings are not in the bundle yet. The fold thumbnail
  /// (and, for a Saree template with no fold, the template photo) is the
  /// same picture the artisan already picked on How should it look.
  static String? _lookAsset({
    required FoldPreset? preset,
    required ShotGuidance guidance,
    required PresetCaptureGuidance captureGuidance,
  }) {
    final fromPreset = preset?.referenceImageAsset.trim();
    if (fromPreset != null && fromPreset.isNotEmpty) return fromPreset;

    final templateName = guidance.templateName;
    if (templateName != null) {
      for (final template in SareePhotographyTemplates.all) {
        final path = template.referenceImageAsset?.trim();
        if (template.name == templateName && path != null && path.isNotEmpty) {
          return path;
        }
      }
    }

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
    final l10n = AppLocalizations.of(context);

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
                  AppCopy.advisoryHeadline(l10n, advisory.reason),
                  style: AppTypography.labelLargeBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppCopy.advisoryDetail(l10n, advisory.reason),
                  style: AppTypography.labelSmall,
                ),
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
