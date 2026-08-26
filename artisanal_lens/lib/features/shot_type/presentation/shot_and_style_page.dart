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
import '../../../shared/widgets/common.dart';
import '../../capture/capture_session_controller.dart';
import '../../home/shot_sets_controller.dart';

/// Style selection for Product, Lifestyle and Saree photography.
///
/// Shot type (or Saree template) is already chosen on the photo list. This
/// screen is only the fold/style decision, then it hands off to Lighting &
/// Setup. Process and Detail never land here — they skip straight to lighting.
///
/// All four documented folds for the chosen category are listed. They are
/// not filtered by shot type: that mapping was not in the Solution Deck.
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

    final presets = shotType == null
        ? const <FoldPreset>[]
        : catalog.presets(categoryId: set?.categoryId ?? '');

    final needsStyle = shotType != null && !shotType.skipsStyleStep;
    final canContinue = session.canOpenCamera &&
        (!needsStyle || presets.isEmpty || session.presetId != null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(set?.productName ?? 'Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.space20,
          AppDimens.pagePadding,
          AppDimens.space32,
        ),
        children: [
          const AppPill(label: 'Choose a style'),
          const SizedBox(height: AppDimens.space16),
          Text('How should it look?', style: AppTypography.displayLarge),
          const SizedBox(height: AppDimens.space8),
          Text(
            _styleSubtitle(
              shotType: shotType,
              slotIndex: session.slotIndex,
              categoryName: category?.name,
            ),
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppDimens.space20),
          if (presets.isEmpty)
            Text(
              'No style is needed for this photo.',
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
          child: const Text('Continue'),
        ),
      ),
    );
  }

  static String _styleSubtitle({
    required ShotType? shotType,
    required int? slotIndex,
    required String? categoryName,
  }) {
    if (shotType == null) return 'Pick a photo from the list first.';
    if (shotType == ShotType.sareePhotography) {
      final templateName =
          SareePhotographyTemplates.byIndex(slotIndex ?? -1)?.name;
      if (templateName != null) {
        return 'Choose the arrangement for this ${templateName.toLowerCase()} photo.';
      }
    }
    if (categoryName == null) {
      return 'Choose the arrangement for this ${shotType.label.toLowerCase()} photo.';
    }
    return 'Choose the arrangement for this ${categoryName.toLowerCase()} ${shotType.label.toLowerCase()} photo.';
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
                      preset.name,
                      style: AppTypography.labelLargeBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (preset.purpose.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(preset.purpose, style: AppTypography.labelSmall),
                    ],
                    if (preset.contentLabel.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Content: ${preset.contentLabel}',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                    if (preset.needsLabel != null) ...[
                      const SizedBox(height: AppDimens.space4),
                      Text(
                        'Needs: ${preset.needsLabel}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                    if (preset.setupSteps.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Placement: ${preset.setupSteps.first.instruction}',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      'Lighting: ${preset.technique.lighting.label}',
                      style: AppTypography.labelSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Grid: ${preset.technique.composition.label}',
                      style: AppTypography.labelSmall,
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
