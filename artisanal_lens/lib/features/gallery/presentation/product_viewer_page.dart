import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/shot_set.dart';
import '../../../domain/entities/shot_type.dart';
import '../../../l10n/app_copy.dart';
import '../../../shared/widgets/common.dart';
import '../../home/shot_sets_controller.dart';
import '../../instruction/instruction_flow.dart';

/// Product gallery & viewer — Figma frame "Product Gallery & Viewer".
///
/// The hero photograph, then one section per shot type showing its filled and
/// still-empty slots. Empty slots are tappable and jump straight back into the
/// capture flow for that specific photograph.
class ProductViewerPage extends ConsumerWidget {
  const ProductViewerPage({required this.setId, super.key});

  final String setId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final set = ref.watch(shotSetProvider(setId));

    if (set == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: Text(AppLocalizations.of(context).product)),
        body: Center(
          child: Text(
            AppLocalizations.of(context).productUnavailable,
            style: AppTypography.bodyMedium,
          ),
        ),
      );
    }

    final hero = set.shotsFor(ShotType.product).firstOrNull ?? set.coverShot;

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
          AppDimens.space16,
          AppDimens.pagePadding,
          AppDimens.space32,
        ),
        children: [
          if (hero != null)
            AspectRatio(
              aspectRatio: 4 / 3,
              child: PhotoThumb(
                path: hero.filePath,
                borderRadius: BorderRadius.circular(AppDimens.radiusLg),
              ),
            ),
          const SizedBox(height: AppDimens.space24),
          for (final type in ShotType.checklistTypesFor(set.categoryId)) ...[
            _TypeSection(set: set, shotType: type, setId: setId),
            const SizedBox(height: AppDimens.space24),
          ],
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: set.isFinished
            ? FilledButton.icon(
                onPressed: () => _exportSet(context, ref, set),
                icon: const Icon(Icons.ios_share, size: 18),
                label: Text(AppLocalizations.of(context).exportPhotoSet),
              )
            : FilledButton.icon(
                onPressed: () => context.pushNamed(
                  AppRoute.photoList,
                  pathParameters: {'setId': setId},
                ),
                icon: const Icon(Icons.photo_camera_outlined, size: 18),
                label: Text(
                  AppLocalizations.of(context).continueCount(
                    set.completedCount,
                    set.requiredCount,
                  ),
                ),
              ),
      ),
    );
  }

  /// Hands the finished set to whatever the artisan already sells through —
  /// WhatsApp, a marketplace app, email. The photographs are the deliverable,
  /// so the set is shared as files rather than as a link or an archive.
  Future<void> _exportSet(
    BuildContext context,
    WidgetRef ref,
    ShotSet set,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final storage = ref.read(photoStorageProvider);

    // Read the bytes rather than passing paths: a photo can go missing if the
    // artisan cleared it, and on the web there are no paths to pass.
    final files = <XFile>[];
    for (final shot in set.shots) {
      final bytes = await storage.readBytes(shot.filePath);
      if (bytes == null) continue;
      files.add(
        XFile.fromData(
          bytes,
          name: '${set.productName}_${files.length + 1}.jpg',
          mimeType: 'image/jpeg',
        ),
      );
    }

    if (files.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.noPhotosToExport)),
      );
      return;
    }

    try {
      await SharePlus.instance.share(
        ShareParams(
          files: files,
          text: l10n.exportShareText(
            set.productName,
            files.length,
          ),
        ),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.couldNotExport('$error')),
        ),
      );
    }
  }
}

class _TypeSection extends ConsumerWidget {
  const _TypeSection({
    required this.set,
    required this.shotType,
    required this.setId,
  });

  final ShotSet set;
  final ShotType shotType;
  final String setId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slots = set.slots.where((slot) => slot.shotType == shotType).toList();
    final done = set.completedCountFor(shotType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppCopy.shotTypeLabel(AppLocalizations.of(context), shotType),
              style: AppTypography.displayMedium,
            ),
            Text(
              '$done/${shotType.requiredCount}',
              style: AppTypography.labelSmall,
            ),
          ],
        ),
        const SizedBox(height: AppDimens.space12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: slots.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: slots.length == 1 ? 1 : 2,
            crossAxisSpacing: AppDimens.space12,
            mainAxisSpacing: AppDimens.space12,
            childAspectRatio: slots.length == 1 ? 4 / 3 : 1,
          ),
          itemBuilder: (context, index) => _SlotTile(
            slot: slots[index],
            onTapEmpty: () => _shootSlot(context, ref, slots[index]),
          ),
        ),
      ],
    );
  }

  void _shootSlot(BuildContext context, WidgetRef ref, ShotSlot slot) {
    beginCaptureForSlot(context, ref, setId: setId, slot: slot);
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({required this.slot, required this.onTapEmpty});

  final ShotSlot slot;
  final VoidCallback onTapEmpty;

  @override
  Widget build(BuildContext context) {
    if (!slot.isFilled) {
      return GestureDetector(
        onTap: onTapEmpty,
        child: DottedPlaceholder(
          label: AppCopy.shotSlotLabel(AppLocalizations.of(context), slot),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PhotoThumb(
          path: slot.shot!.filePath,
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        ),
        Positioned(
          left: AppDimens.space8,
          bottom: AppDimens.space8,
          child: AppPill(
            label: AppCopy.shotSlotLabel(AppLocalizations.of(context), slot),
            background: AppColors.white.withValues(alpha: 0.92),
            foreground: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// An empty slot — a dashed outline naming the photograph still needed.
class DottedPlaceholder extends StatelessWidget {
  const DottedPlaceholder({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_a_photo_outlined,
            color: AppColors.textMuted,
            size: 26,
          ),
          const SizedBox(height: AppDimens.space8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.space8),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}
