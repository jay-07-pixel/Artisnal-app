import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/fold_preset.dart';
import '../../../shared/widgets/common.dart';
import '../../capture/capture_session_controller.dart';
import '../../home/shot_sets_controller.dart';

/// Style selection for Product and Lifestyle shots.
///
/// Shot type is already chosen on the photo list. This screen is only the
/// fold/style decision, then it hands off to Lighting & Setup. Process and
/// Detail never land here — they skip straight to lighting.
class ShotAndStylePage extends ConsumerWidget {
  const ShotAndStylePage({required this.setId, super.key});

  final String setId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final set = ref.watch(shotSetProvider(setId));
    final session = ref.watch(captureSessionProvider);
    final shotType = session.shotType;

    final presets = shotType == null
        ? const <FoldPreset>[]
        : ref.watch(catalogRepositoryProvider).presets(
              categoryId: set?.categoryId ?? '',
              shotType: shotType,
            );

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
            shotType == null
                ? 'Pick a photo from the list first.'
                : 'Choose the arrangement for this ${shotType.label.toLowerCase()} photo.',
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
}

class _StyleRow extends StatelessWidget {
  const _StyleRow({
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
