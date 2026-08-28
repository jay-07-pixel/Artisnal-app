import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/fold_preset.dart';
import '../../../domain/entities/tutorial_catalog_entry.dart';
import '../../../l10n/app_copy.dart';
import '../../../shared/widgets/catalog_video.dart';
import '../../../shared/widgets/common.dart';
import '../../capture/capture_session_controller.dart';
import '../../home/shot_sets_controller.dart';
import 'tutorial_step_gallery.dart';

List<String> spokenTranscriptFor(
  FoldPreset? preset, {
  TutorialCatalogEntry? catalogEntry,
}) {
  if (catalogEntry != null && catalogEntry.hasTranscript) {
    return catalogEntry.transcript;
  }
  if (preset == null) return const [];
  return preset.tutorialTranscript;
}

bool hasTutorialContent(FoldPreset? preset) {
  if (preset == null) return false;
  return preset.hasVideoTutorial || preset.tutorialTranscript.isNotEmpty;
}

class TutorialPage extends ConsumerWidget {
  const TutorialPage({required this.setId, super.key});

  final String setId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final set = ref.watch(shotSetProvider(setId));
    final preset = ref.watch(selectedPresetProvider);
    final guidance = ref.watch(sessionGuidanceProvider);
    final catalogAsync = ref.watch(tutorialCatalogEntryProvider(preset?.id));
    final catalogService = ref.watch(tutorialCatalogServiceProvider);
    final catalogEntry = catalogAsync.valueOrNull;
    final videoKey =
        catalogEntry?.videoStorageKey ?? preset?.tutorialVideoAsset;
    final transcript = spokenTranscriptFor(preset, catalogEntry: catalogEntry);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(set?.productName ?? l10n.tutorial),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.space20,
          AppDimens.pagePadding,
          AppDimens.space32,
        ),
        children: [
          AppPill(label: l10n.step2of2),
          const SizedBox(height: AppDimens.space16),
          Text(l10n.watchHowToSetUp, style: AppTypography.displayLarge),
          const SizedBox(height: AppDimens.space8),
          Text(
            _subtitle(
              l10n: l10n,
              preset: preset,
              catalogEntry: catalogEntry,
              templateName: guidance.templateName,
            ),
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppDimens.space20),
          CatalogVideo(videoKey: videoKey),
          if (catalogEntry != null && catalogEntry.hasStepImages) ...[
            const SizedBox(height: AppDimens.space24),
            TutorialStepGallery(
              steps: catalogEntry.stepImages,
              catalogService: catalogService,
            ),
          ],
          const SizedBox(height: AppDimens.space24),
          Text(l10n.transcript, style: AppTypography.sectionHeader),
          const SizedBox(height: AppDimens.space12),
          if (transcript.isEmpty)
            Text(
              l10n.transcriptPlaceholder,
              style: AppTypography.bodyMedium,
            )
          else
            for (var i = 0; i < transcript.length; i++) ...[
              _TranscriptLine(index: i + 1, text: transcript[i]),
              if (i != transcript.length - 1)
                const SizedBox(height: AppDimens.space12),
            ],
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: FilledButton(
          onPressed: () => context.pushNamed(
            AppRoute.capture,
            pathParameters: {'setId': setId},
          ),
          child: Text(l10n.openCamera),
        ),
      ),
    );
  }

  static String _subtitle({
    required AppLocalizations l10n,
    required FoldPreset? preset,
    required TutorialCatalogEntry? catalogEntry,
    required String? templateName,
  }) {
    if (catalogEntry != null) {
      return l10n.tutorialSubtitlePreset(catalogEntry.name.toLowerCase());
    }
    if (preset != null) {
      return l10n.tutorialSubtitlePreset(AppCopy.presetNameLower(l10n, preset.id));
    }
    final localizedTemplate =
        AppCopy.templateNameLowerByEnglish(l10n, templateName);
    if (localizedTemplate != null) {
      return l10n.tutorialSubtitleTemplate(localizedTemplate);
    }
    return l10n.tutorialSubtitleFallback;
  }
}

class _TranscriptLine extends StatelessWidget {
  const _TranscriptLine({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.surfaceSelected,
          child: Text(
            '$index',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.space12),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
