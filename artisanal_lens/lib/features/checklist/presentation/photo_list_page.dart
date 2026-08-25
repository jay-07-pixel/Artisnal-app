import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/shot_guidance.dart';
import '../../../domain/entities/shot_set.dart';
import '../../../domain/entities/shot_type.dart';
import '../../../shared/widgets/common.dart';
import '../../home/shot_sets_controller.dart';
import '../../instruction/instruction_flow.dart';

/// The required-photo checklist — the hub of the photography journey.
///
/// After product details, and again after each accepted photograph, the
/// artisan lands here so they can see what is done, what remains, and which
/// photograph to take next.
class PhotoListPage extends ConsumerWidget {
  const PhotoListPage({required this.setId, super.key});

  final String setId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final set = ref.watch(shotSetProvider(setId));

    if (set == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Photos')),
        body: Center(
          child: Text(
            'This product is no longer available.',
            style: AppTypography.bodyMedium,
          ),
        ),
      );
    }

    final slots = _orderedSlots(set);
    final next = set.nextSlot;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(set.productName),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.space20,
          AppDimens.pagePadding,
          AppDimens.space32,
        ),
        children: [
          Text('Photos to capture', style: AppTypography.displayLarge),
          const SizedBox(height: AppDimens.space8),
          Text(
            'These are the photos you need to take.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppDimens.space16),
          Row(
            children: [
              Expanded(child: AppProgressBar(value: set.completionRatio)),
              const SizedBox(width: AppDimens.space12),
              Text(
                '${set.completedCount} / ${set.requiredCount}',
                style: AppTypography.labelLargeBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.space24),
          for (var i = 0; i < slots.length; i++) ...[
            _PhotoSlotCard(
              slot: slots[i],
              categoryId: set.categoryId,
              isNext: next != null &&
                  next.shotType == slots[i].shotType &&
                  next.index == slots[i].index,
              onTap: slots[i].isFilled
                  ? null
                  : () => beginCaptureForSlot(
                        context,
                        ref,
                        setId: setId,
                        slot: slots[i],
                      ),
            ),
            if (i != slots.length - 1) const SizedBox(height: AppDimens.space12),
          ],
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: set.isFinished
            ? FilledButton.icon(
                onPressed: () => context.pushNamed(
                  AppRoute.completion,
                  pathParameters: {'setId': setId},
                ),
                icon: const Icon(Icons.check, size: 20),
                label: const Text('View completed set'),
              )
            : FilledButton.icon(
                onPressed: next == null
                    ? null
                    : () => beginCaptureForSlot(
                          context,
                          ref,
                          setId: setId,
                          slot: next,
                        ),
                icon: const Icon(Icons.photo_camera_outlined, size: 20),
                label: Text(
                  next == null
                      ? 'All photos captured'
                      : 'Take next — ${next.label}',
                ),
              ),
      ),
    );
  }
}

/// Checklist order follows the recommended shooting order, not enum order,
/// so the next photograph sits where the artisan expects it.
List<ShotSlot> _orderedSlots(ShotSet set) {
  final lookup = {
    for (final slot in set.slots) '${slot.shotType.id}-${slot.index}': slot,
  };
  return [
    for (final type in ShotType.recommendedOrder)
      for (var i = 0; i < type.requiredCount; i++)
        lookup['${type.id}-$i']!,
  ];
}

class _PhotoSlotCard extends StatelessWidget {
  const _PhotoSlotCard({
    required this.slot,
    required this.categoryId,
    required this.isNext,
    required this.onTap,
  });

  final ShotSlot slot;
  final String categoryId;
  final bool isNext;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final filled = slot.isFilled;
    final guidance = slot.shotType.skipsStyleStep
        ? ShotGuidance.forSlot(
            slot.shotType,
            slot.index,
            categoryId: categoryId,
          )
        : null;
    final borderColor = isNext
        ? AppColors.primary
        : filled
            ? AppColors.successBorder
            : AppColors.border;
    final background = isNext
        ? AppColors.surfaceSelected
        : filled
            ? AppColors.background
            : AppColors.surface;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppDimens.space12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            border: Border.all(
              color: borderColor,
              width: isNext ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                height: 88,
                child: filled
                    ? PhotoThumb(path: slot.shot!.filePath)
                    : const PhotoThumb(path: ''),
              ),
              const SizedBox(width: AppDimens.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slot.shotType.label.toUpperCase(),
                      style: AppTypography.overline,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      slot.label,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (guidance != null && guidance.hasContent) ...[
                      Text(
                        'Content: ${guidance.content}',
                        style: AppTypography.labelSmall,
                      ),
                      if (guidance.hasNeeds) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Needs: ${guidance.needs}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ] else
                      Text(
                        slot.shotType.checklistDescription,
                        style: AppTypography.labelSmall,
                      ),
                    if (isNext) ...[
                      const SizedBox(height: AppDimens.space8),
                      const AppPill(
                        label: 'NEXT',
                        background: AppColors.primary,
                        foreground: AppColors.textOnPrimary,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppDimens.space8),
              if (filled)
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.success,
                  child: Icon(Icons.check, size: 16, color: AppColors.white),
                )
              else
                Icon(
                  Icons.photo_camera_outlined,
                  color: isNext ? AppColors.primary : AppColors.textMuted,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
