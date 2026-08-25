import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimens.dart';
import '../../app/theme/app_typography.dart';

/// Uppercase section header, e.g. "CONTINUE PHOTOGRAPHY".
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title.toUpperCase(), style: AppTypography.sectionHeader),
        ?trailing,
      ],
    );
  }
}

/// The thin rounded progress bar used on the home and setup screens.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({required this.value, this.height = 6, super.key});

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: AppColors.surfaceMuted,
        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
      ),
    );
  }
}

/// A rounded pill, used for step chips, counters and status badges.
class AppPill extends StatelessWidget {
  const AppPill({
    required this.label,
    this.icon,
    this.background = AppColors.surface,
    this.foreground = AppColors.textSecondary,
    this.borderColor,
    super.key,
  });

  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space12,
        vertical: AppDimens.space4 + 2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: AppDimens.space4 + 2),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}

/// Full-width primary action anchored to the bottom of a screen.
class BottomAction extends StatelessWidget {
  const BottomAction({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.space12,
        AppDimens.pagePadding,
        AppDimens.space12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

/// Displays a captured photograph, or a neutral placeholder when it can no
/// longer be read.
///
/// The photograph is resolved through [PhotoStorage] rather than opened
/// directly, because a handle is a file path on a phone and a key into memory
/// in a browser.
class PhotoThumb extends ConsumerWidget {
  const PhotoThumb({
    required this.path,
    this.fit = BoxFit.cover,
    this.borderRadius,
    super.key,
  });

  final String path;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radius = borderRadius ?? BorderRadius.circular(AppDimens.radiusMd);
    final provider = ref.watch(photoStorageProvider).imageProvider(path);

    final image = provider == null
        ? _fallback(context, 'missing', null)
        : Image(image: provider, fit: fit, errorBuilder: _fallback);

    return ClipRRect(borderRadius: radius, child: image);
  }

  static Widget _fallback(BuildContext context, Object error, StackTrace? _) {
    return Container(
      color: AppColors.surfaceMuted,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.textMuted,
        size: 28,
      ),
    );
  }
}
