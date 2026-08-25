import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/fold_preset.dart';
import '../../../domain/entities/shot_type.dart';
import '../../../shared/widgets/common.dart';
import '../../capture/capture_session_controller.dart';
import '../../home/shot_sets_controller.dart';

/// Shot type and style selection — Figma frame "Shot & Preset Selection".
///
/// Step 1 of 2 picks the kind of photo; step 2 of 2 picks the style preset.
/// Step 2 is skipped entirely for Detail shots, which are framed against a
/// grid rather than arranged into a fold.
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

    // Detail shots have no style step, so the camera is reachable as soon as a
    // type is chosen.
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
          // Process and Detail have no style step, so this is the only screen
          // between the checklist and the camera.
          AppPill(label: needsStyle ? 'Step 1 of 2' : 'Step 1 of 1'),
          const SizedBox(height: AppDimens.space16),
          Text(
            'What kind of photo do\nyou want?',
            style: AppTypography.displayLarge,
          ),
          const SizedBox(height: AppDimens.space20),
          _ShotTypeGrid(
            selected: shotType,
            onSelected: (type) {
              final slot = set?.nextSlotFor(type);
              ref.read(captureSessionProvider.notifier).chooseShotType(
                    type,
                    slotIndex: slot?.index ?? 0,
                  );
            },
          ),
          if (needsStyle && presets.isNotEmpty) ...[
            const SizedBox(height: AppDimens.space32),
            const Divider(),
            const SizedBox(height: AppDimens.space20),
            const AppPill(label: 'Step 2 of 2'),
            const SizedBox(height: AppDimens.space16),
            Text('Choose a style', style: AppTypography.displayLarge),
            const SizedBox(height: AppDimens.space20),
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
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: canContinue
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
}

class _ShotTypeGrid extends StatelessWidget {
  const _ShotTypeGrid({required this.selected, required this.onSelected});

  final ShotType? selected;
  final ValueChanged<ShotType> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ShotType.values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimens.space12,
        mainAxisSpacing: AppDimens.space12,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) {
        final type = ShotType.values[index];
        final isSelected = type == selected;

        return Material(
          color: isSelected ? AppColors.surfaceSelected : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            onTap: () => onSelected(type),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _iconFor(type),
                    size: 34,
                    color:
                        isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                  const SizedBox(height: AppDimens.space12),
                  Text(
                    type.label,
                    style: AppTypography.labelLargeBold.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    type.pickerDescription,
                    style: AppTypography.labelSmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static IconData _iconFor(ShotType type) => switch (type) {
        ShotType.process => Icons.handyman_outlined,
        ShotType.product => Icons.inventory_2_outlined,
        ShotType.detail => Icons.zoom_in,
        ShotType.lifestyle => Icons.accessibility_new,
      };
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
                width: 64,
                height: 64,
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
                    const SizedBox(height: 2),
                    Text(preset.purpose, style: AppTypography.labelSmall),
                    if (preset.needsProp) ...[
                      const SizedBox(height: AppDimens.space4),
                      Text(
                        'Needs: ${preset.requiresProp}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
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
