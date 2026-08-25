import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/shot_set.dart';
import '../../../shared/widgets/common.dart';
import '../shot_sets_controller.dart';

/// Home dashboard — Figma frame "Home Dashboard".
///
/// Wordmark app bar, the "What are you photographing today?" headline, the
/// New Product card, a Continue Photography card for the most recent
/// unfinished shoot, and a Recent Products grid.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(shotSetsProvider);
    final continuable = ref.watch(continuableSetProvider);

    return Column(
      children: [
        const _HomeAppBar(),
        Expanded(
          child: setsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _ErrorState(message: '$error'),
            data: (sets) => ListView(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.pagePadding,
                AppDimens.space24,
                AppDimens.pagePadding,
                AppDimens.space32,
              ),
              children: [
                Text(
                  'What are you\nphotographing today?',
                  style: AppTypography.displayLarge,
                ),
                const SizedBox(height: AppDimens.space24),
                const _NewProductCard(),
                if (continuable != null) ...[
                  const SizedBox(height: AppDimens.space32),
                  const SectionHeader('Continue photography'),
                  const SizedBox(height: AppDimens.space12),
                  _ContinueCard(set: continuable),
                ],
                if (sets.isNotEmpty) ...[
                  const SizedBox(height: AppDimens.space32),
                  SectionHeader(
                    'Recent products',
                    trailing: TextButton(
                      onPressed: () => context.goNamed(AppRoute.gallery),
                      child: const Text('View All'),
                    ),
                  ),
                  const SizedBox(height: AppDimens.space12),
                  _RecentGrid(sets: sets.take(4).toList()),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundAlt,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: AppDimens.appBarHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.pagePadding,
          ),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'The Artisanal Lens',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              // Figma draws this as a plain glyph. It reads as a button, so
              // it behaves as one — Settings is the only account-shaped
              // destination the app has.
              IconButton(
                onPressed: () => context.goNamed(AppRoute.settings),
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: AppColors.textPrimary,
                  size: 28,
                ),
                tooltip: 'Settings',
                splashRadius: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewProductCard extends StatelessWidget {
  const _NewProductCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        onTap: () => context.pushNamed(AppRoute.productSetup),
        child: SizedBox(
          height: 136,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: AppColors.primary),
              ),
              const SizedBox(height: AppDimens.space12),
              Text(
                'New Product',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.set});

  final ShotSet set;

  @override
  Widget build(BuildContext context) {
    final cover = set.coverShot;

    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSelected,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            height: 88,
            child: cover == null
                ? const PhotoThumb(path: '')
                : PhotoThumb(path: cover.filePath),
          ),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  set.productName,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimens.space4),
                Text(
                  '${set.completedCount} of ${set.requiredCount} photos completed',
                  style: AppTypography.labelSmall,
                ),
                const SizedBox(height: AppDimens.space8),
                AppProgressBar(value: set.completionRatio),
                const SizedBox(height: AppDimens.space12),
                OutlinedButton(
                  onPressed: () => context.pushNamed(
                    AppRoute.photoList,
                    pathParameters: {'setId': set.id},
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentGrid extends StatelessWidget {
  const _RecentGrid({required this.sets});

  final List<ShotSet> sets;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sets.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimens.space12,
        mainAxisSpacing: AppDimens.space12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => _RecentCard(set: sets[index]),
    );
  }
}

class _RecentCard extends StatelessWidget {
  const _RecentCard({required this.set});

  final ShotSet set;

  @override
  Widget build(BuildContext context) {
    final cover = set.coverShot;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        onTap: () => context.pushNamed(
          set.isFinished ? AppRoute.productViewer : AppRoute.photoList,
          pathParameters: {'setId': set.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: PhotoThumb(path: cover?.filePath ?? ''),
                    ),
                    if (set.isFinished)
                      const Positioned(
                        top: AppDimens.space8,
                        right: AppDimens.space8,
                        child: CircleAvatar(
                          radius: 13,
                          backgroundColor: AppColors.success,
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
              const SizedBox(height: AppDimens.space8),
              Text(
                set.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimens.space4),
              if (set.isFinished)
                Text(
                  '${set.completedCount}/${set.requiredCount} Complete',
                  style: AppTypography.labelSmall,
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: AppProgressBar(value: set.completionRatio),
                    ),
                    const SizedBox(width: AppDimens.space8),
                    Text(
                      '${set.completedCount}/${set.requiredCount}',
                      style: AppTypography.labelSmall,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space24),
        child: Text(message, style: AppTypography.bodyMedium),
      ),
    );
  }
}
