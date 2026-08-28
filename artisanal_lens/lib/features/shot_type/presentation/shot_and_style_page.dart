import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/fold_preset.dart';
import '../../../domain/entities/photography_template.dart';
import '../../../domain/entities/shot_type.dart';
import '../../../l10n/app_copy.dart';
import '../../../shared/widgets/common.dart';
import '../../capture/capture_session_controller.dart';
import '../../home/shot_sets_controller.dart';

/// Style selection for photographs that need a fold.
///
/// Shot type (or photography template) is already chosen on the photo list.
/// Close-ups never land here. Only the presets paired with that photograph
/// are listed.
class ShotAndStylePage extends ConsumerWidget {
  const ShotAndStylePage({required this.setId, super.key});

  final String setId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final set = ref.watch(shotSetProvider(setId));
    final session = ref.watch(captureSessionProvider);
    final shotType = session.shotType;
    final catalog = ref.watch(catalogRepositoryProvider);
    final category = catalog.categoryById(set?.categoryId ?? '');
    final template = (shotType != null && shotType.isPhotography)
        ? PhotographyTemplates.byIndex(
            set?.categoryId ?? '',
            session.slotIndex ?? -1,
          )
        : null;

    final allPresets = shotType == null
        ? const <FoldPreset>[]
        : catalog.presets(categoryId: set?.categoryId ?? '');
    final presets = template == null
        ? allPresets
        : allPresets
            .where((preset) => template.allowedPresetIds.contains(preset.id))
            .toList();

    final needsStyle = template != null
        ? template.needsStyleStep
        : shotType != null && !shotType.skipsStyleStep;
    final canContinue = session.canOpenCamera &&
        (!needsStyle || presets.isEmpty || session.presetId != null);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(set?.productName ?? l10n.product),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.space20,
          AppDimens.pagePadding,
          AppDimens.space32,
        ),
        children: [
          AppPill(label: l10n.chooseAStyle),
          const SizedBox(height: AppDimens.space16),
          Text(l10n.howShouldItLook, style: AppTypography.displayLarge),
          const SizedBox(height: AppDimens.space8),
          Text(
            _styleSubtitle(
              l10n: l10n,
              shotType: shotType,
              slotIndex: session.slotIndex,
              categoryId: category?.id,
              template: template,
            ),
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppDimens.space20),
          if (presets.isEmpty)
            Text(
              l10n.styleNoNeeded,
              style: AppTypography.bodyMedium,
            )
          else
            for (final preset in presets) ...[
              _StyleRow(
                key: ValueKey(preset.id),
                preset: preset,
                isSelected: session.presetId == preset.id,
                onTap: () => ref
                    .read(captureSessionProvider.notifier)
                    .choosePreset(preset.id),
              ),
              const SizedBox(height: AppDimens.space12),
            ],
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: FilledButton(
          onPressed: canContinue
              ? () => context.pushNamed(
                    AppRoute.lightingSetup,
                    pathParameters: {'setId': setId},
                  )
              : null,
          child: Text(l10n.continueAction),
        ),
      ),
    );
  }

  static String _styleSubtitle({
    required AppLocalizations l10n,
    required ShotType? shotType,
    required int? slotIndex,
    required String? categoryId,
    PhotographyTemplate? template,
  }) {
    if (shotType == null) return l10n.stylePickFirst;
    if (template != null) {
      return l10n.styleSubtitleSaree(
        AppCopy.templateNameLower(l10n, template.id),
      );
    }
    if (shotType == ShotType.sareePhotography) {
      final saree = SareePhotographyTemplates.byIndex(slotIndex ?? -1);
      if (saree != null) {
        return l10n.styleSubtitleSaree(
          AppCopy.templateNameLower(l10n, saree.id),
        );
      }
    }
    if (categoryId == null) {
      return l10n.styleSubtitleShot(AppCopy.shotTypeLabelLower(l10n, shotType));
    }
    return l10n.styleSubtitleCategory(
      AppCopy.categoryNameLower(l10n, categoryId),
      AppCopy.shotTypeLabelLower(l10n, shotType),
    );
  }
}

class _StyleRow extends StatelessWidget {
  const _StyleRow({
    super.key,
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  final FoldPreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: isSelected ? AppColors.surfaceSelected : AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppDimens.space12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                height: 88,
                child: PhotoThumb(path: preset.referenceImageAsset),
              ),
              const SizedBox(width: AppDimens.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppCopy.presetName(l10n, preset.id),
                      style: AppTypography.labelLargeBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (preset.purpose.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        AppCopy.presetPurpose(l10n, preset),
                        style: AppTypography.labelSmall,
                      ),
                    ],
                    if (preset.contentLabel.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      _LabeledValue(
                        label: l10n.labelContent,
                        value: AppCopy.presetContent(l10n, preset),
                      ),
                    ],
                    if (preset.needsLabel != null) ...[
                      const SizedBox(height: AppDimens.space4),
                      _LabeledValue(
                        label: l10n.labelNeeds,
                        value: AppCopy.presetNeeds(l10n, preset) ??
                            preset.needsLabel!,
                      ),
                    ],
                    if (preset.setupSteps.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      _LabeledValue(
                        label: l10n.labelPlacement,
                        value: preset.setupSteps.first.instruction,
                      ),
                    ],
                    const SizedBox(height: 2),
                    _LabeledValue(
                      label: l10n.labelLighting,
                      value: AppCopy.lightingLabel(l10n, preset.technique.lighting),
                    ),
                    const SizedBox(height: 2),
                    _LabeledValue(
                      label: l10n.labelGrid,
                      value: AppCopy.compositionLabel(
                        l10n,
                        preset.technique.composition,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimens.space8),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color:
                    isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Terracotta label, body-colour value — easier to scan on fold cards.
class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
          TextSpan(
            text: value,
            style: AppTypography.labelSmall,
          ),
        ],
      ),
    );
  }
}
