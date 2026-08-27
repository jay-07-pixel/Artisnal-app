import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/lighting_advisory.dart';
import '../../../l10n/app_copy.dart';
import '../../../shared/widgets/choice_image_grid.dart';
import '../../../shared/widgets/common.dart';
import '../../home/shot_sets_controller.dart';

/// Product setup — Figma frame "Product Setup Flow".
///
/// Category grid and product name, then the photo list. Category is locked
/// once a shoot exists so its presets stay scoped to it.
class ProductSetupPage extends ConsumerStatefulWidget {
  const ProductSetupPage({
    this.setId,
    this.materialId,
    this.silkTypeId,
    super.key,
  });

  final String? setId;
  final String? materialId;
  final String? silkTypeId;

  @override
  ConsumerState<ProductSetupPage> createState() => _ProductSetupPageState();
}

class _ProductSetupPageState extends ConsumerState<ProductSetupPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedCategoryId;
  bool _isStarting = false;

  /// Guards the one-time copy of a resumed shoot into the form fields.
  bool _hydrated = false;

  /// The shoot this screen is tracking.
  ///
  /// Starts as [ProductSetupPage.setId], but a screen opened for a brand-new
  /// product creates its set on the first "Start with …" tap and adopts that
  /// id here. Without this the page would still believe it was an empty form
  /// when the capture flow pops back to it, and would show 0 / 7 forever.
  String? _activeSetId;

  @override
  void initState() {
    super.initState();
    _activeSetId = widget.setId;
  }

  bool get _isExistingSet => _activeSetId != null;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(catalogRepositoryProvider).categories();
    final existingSet = _activeSetId == null
        ? null
        : ref.watch(shotSetProvider(_activeSetId!));

    // When resuming, mirror the stored set into the form once the set has
    // loaded. Done after the frame because assigning to a TextEditingController
    // notifies its listeners, which must not happen during build.
    if (existingSet != null && !_hydrated) {
      _hydrated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _selectedCategoryId = existingSet.categoryId;
          _nameController.text = existingSet.productName;
        });
      });
    }

    final selectedCategory = _selectedCategoryId == null
        ? null
        : ref.watch(catalogRepositoryProvider).categoryById(_selectedCategoryId!);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          existingSet?.productName.isNotEmpty == true
              ? existingSet!.productName
              : AppLocalizations.of(context).newProduct,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.space24,
          AppDimens.pagePadding,
          AppDimens.space32,
        ),
        children: [
          Text(
            AppLocalizations.of(context).whatPhotographing,
            style: AppTypography.displayLarge,
          ),
          const SizedBox(height: AppDimens.space20),
          ChoiceImageGrid(
            choices: [
              for (final category in categories)
                ImageChoice(
                  id: category.id,
                  name: AppCopy.categoryName(
                    AppLocalizations.of(context),
                    category.id,
                  ),
                  thumbnailAsset: category.thumbnailAsset,
                ),
            ],
            selectedId: _selectedCategoryId,
            onSelected: _isExistingSet
                ? null
                : (id) => setState(() => _selectedCategoryId = id),
          ),
          if (selectedCategory != null) ...[
            const SizedBox(height: AppDimens.space32),
            const Divider(),
            const SizedBox(height: AppDimens.space24),
            Text(
              AppCopy.categoryName(
                AppLocalizations.of(context),
                selectedCategory.id,
              ),
              style: AppTypography.displayMedium,
            ),
            const SizedBox(height: AppDimens.space12),
            Text(
              AppLocalizations.of(context).giveProductName,
              style: AppTypography.labelSmall,
            ),
            const SizedBox(height: AppDimens.space8),
            TextField(
              controller: _nameController,
              enabled: !_isExistingSet,
              textCapitalization: TextCapitalization.words,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).nameHint(
                  AppCopy.categoryName(
                    AppLocalizations.of(context),
                    selectedCategory.id,
                  ),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppDimens.space24),
            const _ProTipBanner(),
          ],
        ],
      ),
      // Hands over to the photo list, which is the hub for the shoot.
      bottomNavigationBar: selectedCategory == null
          ? null
          : BottomAction(
              child: FilledButton.icon(
                onPressed: _canStart && !_isStarting ? _start : null,
                icon: const Icon(Icons.arrow_forward, size: 20),
                label: Text(AppLocalizations.of(context).continueAction),
              ),
            ),
    );
  }

  bool get _canStart =>
      _selectedCategoryId != null && _nameController.text.trim().isNotEmpty;

  Future<void> _start() async {
    if (_isStarting) return;

    FocusScope.of(context).unfocus();
    setState(() => _isStarting = true);

    try {
      final controller = ref.read(shotSetsProvider.notifier);
      var setId = _activeSetId;

      // A brand-new product is only persisted once the artisan continues, so
      // abandoning the form leaves nothing behind.
      if (setId == null) {
        final created = await controller.createSet(
          productName: _nameController.text.trim(),
          categoryId: _selectedCategoryId!,
          materialId: widget.materialId,
          silkTypeId: widget.silkTypeId,
        );
        setId = created.id;
        if (mounted) setState(() => _activeSetId = setId);
      }

      if (!mounted) return;
      context.pushReplacementNamed(
        AppRoute.photoList,
        pathParameters: {'setId': setId},
      );
    } finally {
      if (mounted) setState(() => _isStarting = false);
    }
  }
}

class _ProTipBanner extends StatelessWidget {
  const _ProTipBanner();

  @override
  Widget build(BuildContext context) {
    final advisory = LightingAdvisory.forTime(DateTime.now());
    final l10n = AppLocalizations.of(context);
    final message = advisory.shouldWait
        ? '${AppCopy.advisoryHeadline(l10n, advisory.reason)}: ${AppCopy.advisoryDetail(l10n, advisory.reason)}'
        : l10n.proTipGoodLight;

    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSand,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.successBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            size: 18,
            color: AppColors.success,
          ),
          const SizedBox(width: AppDimens.space8),
          Expanded(
            child: Text(
              message,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
