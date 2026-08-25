import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/fold_preset.dart';
import '../../../shared/widgets/catalog_video.dart';
import '../../../shared/widgets/common.dart';
import '../../capture/capture_session_controller.dart';
import '../../home/shot_sets_controller.dart';

/// Spoken-video transcript from the catalog fold only.
///
/// Photography-template [ShotGuidance.guidance] is setup copy, not a
/// transcript. Detail and Process slots have no catalog video, so they
/// show the unavailable transcript state.
List<String> spokenTranscriptFor(FoldPreset? preset) {
  if (preset == null) return const [];
  return preset.tutorialTranscript;
}

/// Video tutorial with on-screen transcript.
///
/// Catalog entries already name the `.mp4` files. Until those files are in
/// `assets/videos/`, this screen shows a labelled placeholder. Transcript
/// lines are shown only when the selected fold lists them.
class TutorialPage extends ConsumerWidget {
  const TutorialPage({required this.setId, super.key});

  final String setId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final set = ref.watch(shotSetProvider(setId));
    final preset = ref.watch(selectedPresetProvider);
    final guidance = ref.watch(sessionGuidanceProvider);
    final videoAsset = preset?.tutorialVideoAsset;
    final transcript = spokenTranscriptFor(preset);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(set?.productName ?? 'Tutorial'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.space20,
          AppDimens.pagePadding,
          AppDimens.space32,
        ),
        children: [
          const AppPill(label: 'Step 2 of 3'),
          const SizedBox(height: AppDimens.space16),
          Text('Watch how to set up', style: AppTypography.displayLarge),
          const SizedBox(height: AppDimens.space8),
          Text(
            _subtitle(preset: preset, templateName: guidance.templateName),
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppDimens.space20),
          CatalogVideo(assetPath: videoAsset),
          const SizedBox(height: AppDimens.space24),
          Text('TRANSCRIPT', style: AppTypography.sectionHeader),
          const SizedBox(height: AppDimens.space12),
          if (transcript.isEmpty)
            Text(
              'The spoken transcript will appear here once the tutorial video is added.',
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
            AppRoute.alignment,
            pathParameters: {'setId': setId},
          ),
          child: const Text('Continue'),
        ),
      ),
    );
  }

  static String _subtitle({
    required FoldPreset? preset,
    required String? templateName,
  }) {
    if (preset != null) {
      return 'Watch how to set up ${preset.name.toLowerCase()}.';
    }
    if (templateName != null) {
      return 'Watch how to set up ${templateName.toLowerCase()}.';
    }
    return 'A short video will show this setup when it is added.';
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
