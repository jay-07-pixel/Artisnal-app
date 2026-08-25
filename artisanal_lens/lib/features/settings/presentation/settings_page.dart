import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/locale_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/photography_guideline.dart';

/// Settings.
///
/// The Figma file lists Settings as a navigation destination but does not
/// detail its contents, so this holds only what the research already
/// specifies: language choice (the 42% who cite language barriers) and the
/// photography guidelines the app's advice is built on.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(localeProvider);
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Container(
            height: AppDimens.appBarHeight,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.backgroundAlt,
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Text(
              'Settings',
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.pagePadding,
              AppDimens.space24,
              AppDimens.pagePadding,
              AppDimens.space32,
            ),
            children: [
              Text('Language', style: AppTypography.displayMedium),
              const SizedBox(height: AppDimens.space12),
              RadioGroup<AppLanguage>(
                groupValue: selected,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(localeProvider.notifier).select(value);
                  }
                },
                child: Column(
                  children: [
                    for (final language in AppLanguage.values)
                      RadioListTile<AppLanguage>(
                        value: language,
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          language.label,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.space24),
              const Divider(),
              const SizedBox(height: AppDimens.space24),
              Text('Photography guide', style: AppTypography.displayMedium),
              const SizedBox(height: AppDimens.space4),
              Text(
                'The rules behind every prompt this app gives you.',
                style: AppTypography.labelSmall,
              ),
              const SizedBox(height: AppDimens.space16),
              for (final guideline in PhotographyGuideline.values) ...[
                _GuidelineTile(guideline: guideline),
                const SizedBox(height: AppDimens.space8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _GuidelineTile extends StatelessWidget {
  const _GuidelineTile({required this.guideline});

  final PhotographyGuideline guideline;

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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space8,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimens.radiusXs),
            ),
            child: Text(
              guideline.code,
              style: AppTypography.navLabel.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guideline.title,
                  style: AppTypography.labelLargeBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  guideline.description,
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
