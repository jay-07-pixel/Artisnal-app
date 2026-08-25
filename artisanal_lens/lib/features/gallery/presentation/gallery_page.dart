import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/shot_set.dart';
import '../../../shared/widgets/common.dart';
import '../../home/shot_sets_controller.dart';

/// Gallery — Figma frame "Gallery & Completion Flow".
///
/// Category filter chips over full-bleed product cards, each showing its name
/// and completion status.
class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({super.key});

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  String? _categoryFilter;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(catalogRepositoryProvider).categories();
    final setsAsync = ref.watch(shotSetsProvider);

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
              'Gallery',
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 64,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePadding,
              vertical: AppDimens.space12,
            ),
            children: [
              _FilterChip(
                label: 'All',
                isSelected: _categoryFilter == null,
                onTap: () => setState(() => _categoryFilter = null),
              ),
              for (final category in categories)
                _FilterChip(
                  label: _plural(category.name),
                  isSelected: _categoryFilter == category.id,
                  onTap: () =>
                      setState(() => _categoryFilter = category.id),
                ),
            ],
          ),
        ),
        Expanded(
          child: setsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('$error')),
            data: (sets) {
              final filter = _categoryFilter == null
                  ? const GalleryFilter.all()
                  : GalleryFilter.category(_categoryFilter!);
              final visible = sets.where(filter.matches).toList();

              if (visible.isEmpty) {
                // A filter that matches nothing is a different problem from
                // having shot nothing at all, and needs a different way out.
                final isFiltered = _categoryFilter != null && sets.isNotEmpty;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.space32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isFiltered
                              ? Icons.filter_alt_off_outlined
                              : Icons.photo_library_outlined,
                          size: 44,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppDimens.space16),
                        Text(
                          isFiltered
                              ? 'Nothing in this category yet.'
                              : 'No photo sets yet.\n'
                                  'Start a new product to begin.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium,
                        ),
                        const SizedBox(height: AppDimens.space20),
                        if (isFiltered)
                          OutlinedButton.icon(
                            onPressed: () =>
                                setState(() => _categoryFilter = null),
                            icon: const Icon(Icons.clear, size: 18),
                            label: const Text('Show all'),
                          )
                        else
                          FilledButton.icon(
                            onPressed: () =>
                                context.pushNamed(AppRoute.productSetup),
                            icon: const Icon(
                              Icons.add_a_photo_outlined,
                              size: 18,
                            ),
                            label: const Text('New Product'),
                          ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.pagePadding,
                  AppDimens.space8,
                  AppDimens.pagePadding,
                  AppDimens.space32,
                ),
                itemCount: visible.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppDimens.space16),
                itemBuilder: (context, index) =>
                    _GalleryCard(set: visible[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  /// The filter chips are pluralised in the design ("Sarees", "Shawls").
  static String _plural(String name) =>
      name.endsWith('s') ? name : '${name}s';
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimens.space8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space20,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceSelected : AppColors.background,
            borderRadius: BorderRadius.circular(AppDimens.radiusPill),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color:
                  isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({required this.set});

  final ShotSet set;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoute.productViewer,
        pathParameters: {'setId': set.id},
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        child: SizedBox(
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PhotoThumb(
                path: set.coverShot?.filePath ?? '',
                borderRadius: BorderRadius.zero,
              ),
              // Scrim so the name stays legible over any photograph.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x99000000)],
                  ),
                ),
              ),
              Positioned(
                left: AppDimens.space16,
                right: AppDimens.space16,
                bottom: AppDimens.space16,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        set.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.displayMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.space8),
                    AppPill(
                      label: '${set.completedCount}/${set.requiredCount}',
                      icon: set.isFinished
                          ? Icons.check_circle_outline
                          : Icons.hourglass_empty,
                      background: AppColors.white.withValues(alpha: 0.9),
                      foreground: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
