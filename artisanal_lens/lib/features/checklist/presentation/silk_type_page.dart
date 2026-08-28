import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/fabric_material.dart';
import '../../../l10n/app_copy.dart';
import '../../../shared/widgets/choice_image_grid.dart';
import '../../../shared/widgets/common.dart';

/// Second New Product step: named varieties for each fibre material.
class SilkTypePage extends StatefulWidget {
  const SilkTypePage({this.materialId, super.key});

  final String? materialId;

  @override
  State<SilkTypePage> createState() => _SilkTypePageState();
}

class _SilkTypePageState extends State<SilkTypePage> {
  String? _selectedId;

  FabricMaterial get _material =>
      FabricMaterial.byId(widget.materialId ?? '') ?? FabricMaterial.silk;

  List<ImageChoice> _choices(AppLocalizations l10n) => switch (_material.id) {
        FabricMaterial.silkId => [
            for (final variety in SilkVariety.all)
              ImageChoice(
                id: variety.id,
                name: AppCopy.materialVarietyName(
                  l10n,
                  _material.id,
                  variety.id,
                ),
                thumbnailAsset: variety.thumbnailAsset,
              ),
          ],
        FabricMaterial.cottonId => [
            for (final variety in CottonVariety.all)
              ImageChoice(
                id: variety.id,
                name: AppCopy.materialVarietyName(
                  l10n,
                  _material.id,
                  variety.id,
                ),
                thumbnailAsset: variety.thumbnailAsset,
              ),
          ],
        FabricMaterial.woolId => [
            for (final variety in WoolVariety.all)
              ImageChoice(
                id: variety.id,
                name: AppCopy.materialVarietyName(
                  l10n,
                  _material.id,
                  variety.id,
                ),
                thumbnailAsset: variety.thumbnailAsset,
              ),
          ],
        FabricMaterial.juteId => [
            for (final variety in JuteVariety.all)
              ImageChoice(
                id: variety.id,
                name: AppCopy.materialVarietyName(
                  l10n,
                  _material.id,
                  variety.id,
                ),
                thumbnailAsset: variety.thumbnailAsset,
              ),
          ],
        _ => const [],
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final choices = _choices(l10n);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.newProduct),
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
            l10n.materialTypeHeadline(
              AppCopy.materialNameForHeadline(l10n, _material.id),
            ),
            style: AppTypography.displayLarge,
          ),
          const SizedBox(height: AppDimens.space20),
          ChoiceImageGrid(
            choices: choices,
            selectedId: _selectedId,
            onSelected: (id) => setState(() => _selectedId = id),
          ),
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: _selectedId == null ? null : _continue,
          icon: const Icon(Icons.arrow_forward, size: 20),
          label: Text(l10n.continueAction),
        ),
      ),
    );
  }

  void _continue() {
    context.pushNamed(
      AppRoute.productSetup,
      queryParameters: {
        'material': _material.id,
        if (_selectedId != null) 'silkType': _selectedId!,
      },
    );
  }
}
