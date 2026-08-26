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

/// Home dashboard — Figma frame "Home Dashboard" plus BTP "Previous sets".
///
/// Wordmark app bar, the "What are you photographing today?" headline, the
/// New Product card, a Continue Photography card for the most recent
/// unfinished shoot, and the previous-sets list with All / Finished / Pending.
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
                const SizedBox(height: AppDimens.space32),
                _PreviousSetsSection(sets: sets),
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
        onTap: () => context.pushNamed(AppRoute.material),
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

class _PreviousSetsSection extends StatefulWidget {
  const _PreviousSetsSection({required this.sets});

  final List<ShotSet> sets;

  @override
  State<_PreviousSetsSection> createState() => _PreviousSetsSectionState();
}

class _PreviousSetsSectionState extends State<_PreviousSetsSection> {
  PreviousSetsFilter _filter = PreviousSetsFilter.all;

  @override
  Widget build(BuildContext context) {
    final visible = _filter.apply(widget.sets);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Previous sets.',
          style: AppTypography.displayMedium.copyWith(
            fontFamily: AppTypography.sans,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimens.space16),
        Row(
          children: [
            _ProgressChip(
              label: 'All',
              selected: _filter == PreviousSetsFilter.all,
              onTap: () => setState(() => _filter = PreviousSetsFilter.all),
            ),
            const SizedBox(width: AppDimens.space8),
            _ProgressChip(
              label: 'Finished',
              selected: _filter == PreviousSetsFilter.finished,
              onTap: () =>
                  setState(() => _filter = PreviousSetsFilter.finished),
            ),
            const SizedBox(width: AppDimens.space8),
            _ProgressChip(
              label: 'Pending',
              selected: _filter == PreviousSetsFilter.pending,
              onTap: () => setState(() => _filter = PreviousSetsFilter.pending),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.space16),
        if (visible.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.space12),
            child: Text(
              _emptyMessage,
              style: AppTypography.bodyMedium,
            ),
          )
        else
          ...[
            for (var i = 0; i < visible.length; i++) ...[
              if (i > 0) const SizedBox(height: AppDimens.space12),
              _PreviousSetCard(set: visible[i]),
            ],
          ],
      ],
    );
  }

  String get _emptyMessage => switch (_filter) {
        PreviousSetsFilter.all => 'No previous sets yet.',
        PreviousSetsFilter.finished => 'No finished sets yet.',
        PreviousSetsFilter.pending => 'No pending sets.',
      };
}

class _ProgressChip extends StatelessWidget {
  const _ProgressChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.successBorder : AppColors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? AppColors.successBorder : AppColors.borderLight,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppDimens.minTapTarget),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.space20),
            child: Center(
              child: Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviousSetCard extends StatelessWidget {
  const _PreviousSetCard({required this.set});

  final ShotSet set;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      elevation: 1,
      shadowColor: AppColors.textPrimary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        onTap: () => context.pushNamed(
          set.isFinished ? AppRoute.productViewer : AppRoute.photoList,
          pathParameters: {'setId': set.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space12),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: PhotoThumb(path: set.coverShot?.filePath ?? ''),
              ),
              const SizedBox(width: AppDimens.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      set.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppDimens.space4),
                    Text(
                      formatPreviousSetDate(set.createdAt),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
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
