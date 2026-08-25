import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimens.dart';
import '../../app/theme/app_typography.dart';

/// Marked empty slot for an illustration or video that is not in the bundle yet.
///
/// Catalog entries already name the files; this widget is what the artisan
/// sees until those files are dropped into `assets/`.
class AssetPlaceholder extends StatelessWidget {
  const AssetPlaceholder({
    required this.label,
    this.icon = Icons.image_outlined,
    this.height,
    super.key,
  });

  final String label;
  final IconData icon;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36, color: AppColors.textMuted),
          const SizedBox(height: AppDimens.space12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall,
          ),
        ],
      ),
    );
  }
}

/// Loads a bundled image, falling back to [AssetPlaceholder] if the file is
/// missing so a catalog path never crashes the screen.
class CatalogImage extends StatelessWidget {
  const CatalogImage({
    required this.assetPath,
    required this.placeholderLabel,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.height,
    super.key,
  });

  final String? assetPath;
  final String placeholderLabel;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final path = assetPath;
    final radius = borderRadius ?? BorderRadius.circular(AppDimens.radiusLg);

    if (path == null || path.isEmpty) {
      return AssetPlaceholder(label: placeholderLabel, height: height);
    }

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Image.asset(
          path,
          fit: fit,
          errorBuilder: (_, _, _) => AssetPlaceholder(
            label: placeholderLabel,
            height: height,
          ),
        ),
      ),
    );
  }
}
