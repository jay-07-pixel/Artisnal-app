import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../data/services/tutorial_catalog_service.dart';
import '../../../domain/entities/tutorial_catalog_entry.dart';
import '../../../shared/widgets/asset_placeholder.dart';

/// Horizontal strip of step cards from Supabase (with bundled fallbacks).
class TutorialStepGallery extends StatelessWidget {
  const TutorialStepGallery({
    required this.steps,
    required this.catalogService,
    super.key,
  });

  final List<TutorialStepImage> steps;
  final TutorialCatalogService catalogService;

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How-to steps', style: AppTypography.sectionHeader),
        const SizedBox(height: AppDimens.space12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: steps.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppDimens.space12),
            itemBuilder: (context, index) {
              final step = steps[index];
              return _StepCard(
                index: index + 1,
                step: step,
                imageUrl: catalogService.publicImageUrl(step.storageKey),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.index,
    required this.step,
    required this.imageUrl,
  });

  final int index;
  final TutorialStepImage step;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.62;

    return SizedBox(
      width: width.clamp(200, 280),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusLg),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  color: AppColors.surface,
                ),
                child: _StepImage(
                  imageUrl: imageUrl,
                  bundledAsset: step.bundledAsset,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.space8),
          if (step.title != null && step.title!.trim().isNotEmpty)
            Text(
              '$index. ${step.title!}',
              style: AppTypography.labelLargeBold,
              maxLines: 2,
            ),
          if (step.instruction != null && step.instruction!.trim().isNotEmpty)
            Text(
              step.instruction!,
              style: AppTypography.labelSmall,
              maxLines: 3,
            ),
        ],
      ),
    );
  }
}

class _StepImage extends StatelessWidget {
  const _StepImage({
    required this.imageUrl,
    required this.bundledAsset,
  });

  final String? imageUrl;
  final String? bundledAsset;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => CatalogImage(
          assetPath: bundledAsset,
          placeholderLabel: 'Step illustration',
          fit: BoxFit.cover,
          height: double.infinity,
        ),
      );
    }

    return CatalogImage(
      assetPath: bundledAsset,
      placeholderLabel: 'Step illustration',
      fit: BoxFit.cover,
      height: double.infinity,
    );
  }
}
