import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimens.dart';
import '../../app/theme/app_typography.dart';
import 'common.dart';

/// One tappable image card in a 2-column catalog grid.
class ImageChoice {
  const ImageChoice({
    required this.id,
    required this.name,
    required this.thumbnailAsset,
  });

  final String id;
  final String name;
  final String thumbnailAsset;
}

/// Category-style 2×2 photo grid used for materials, silk types and products.
class ChoiceImageGrid extends StatelessWidget {
  const ChoiceImageGrid({
    required this.choices,
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  final List<ImageChoice> choices;
  final String? selectedId;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: choices.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimens.space12,
        mainAxisSpacing: AppDimens.space16,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final choice = choices[index];
        final isSelected = choice.id == selectedId;

        return GestureDetector(
          onTap: onSelected == null ? null : () => onSelected!(choice.id),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: PhotoThumb(
                          path: choice.thumbnailAsset,
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusMd),
                        ),
                      ),
                      if (isSelected)
                        const Positioned(
                          top: AppDimens.space8,
                          right: AppDimens.space8,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.check,
                              size: 15,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.space8),
              if (choice.name.isNotEmpty)
                Text(
                  choice.name,
                  textAlign: TextAlign.center,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
