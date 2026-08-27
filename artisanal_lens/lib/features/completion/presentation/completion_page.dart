import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/common.dart';
import '../../home/shot_sets_controller.dart';

/// Set completion — Figma frame "Gallery & Completion Flow".
///
/// Offline banner, the celebration headline, a grid of the finished set, and
/// the two follow-on actions.
class CompletionPage extends ConsumerWidget {
  const CompletionPage({required this.setId, super.key});

  final String setId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final set = ref.watch(shotSetProvider(setId));

    if (set == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            AppLocalizations.of(context).productNotFound,
            style: AppTypography.bodyMedium,
          ),
        ),
      );
    }

    final pendingSync =
        set.shots.where((shot) => !shot.savedToDeviceGallery).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (pendingSync > 0) const _OfflineBanner(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.pagePadding,
                  AppDimens.space32,
                  AppDimens.pagePadding,
                  AppDimens.space24,
                ),
                children: [
                  Text(
                    AppLocalizations.of(context).photoSetComplete,
                    textAlign: TextAlign.center,
                    style: AppTypography.displayLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimens.space12),
                  Text(
                    set.productName,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLarge,
                  ),
                  const SizedBox(height: AppDimens.space24),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: set.shots.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppDimens.space12,
                      mainAxisSpacing: AppDimens.space12,
                    ),
                    itemBuilder: (context, index) => PhotoThumb(
                      path: set.shots[index].filePath,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusLg),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.pagePadding),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () => context.pushReplacementNamed(
                      AppRoute.productViewer,
                      pathParameters: {'setId': setId},
                    ),
                    child: Text(AppLocalizations.of(context).viewPhotoSet),
                  ),
                  const SizedBox(height: AppDimens.space12),
                  OutlinedButton(
                    onPressed: () {
                      // Reset to home first so the new shoot has somewhere to
                      // go back to — the completion screen replaced the stack.
                      context.goNamed(AppRoute.home);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          context.pushNamed(AppRoute.material);
                        }
                      });
                    },
                    child: Text(AppLocalizations.of(context).startNewProduct),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 32,
      color: AppColors.surfaceMuted,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 15,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppDimens.space8),
          Text(
            AppLocalizations.of(context).offlineBanner,
            style: AppTypography.labelSmall,
          ),
        ],
      ),
    );
  }
}
