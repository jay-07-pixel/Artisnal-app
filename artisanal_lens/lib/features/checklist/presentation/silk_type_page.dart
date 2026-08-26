import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/fabric_material.dart';
import '../../../shared/widgets/choice_image_grid.dart';
import '../../../shared/widgets/common.dart';

/// Second New Product step: silk varieties, or empty type slots for the rest.
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

  @override
  Widget build(BuildContext context) {
    final namedTypes = _material.asksSilkType;
    final choices = namedTypes
        ? [
            for (final variety in SilkVariety.all)
              ImageChoice(
                id: variety.id,
                name: variety.name,
                thumbnailAsset: variety.thumbnailAsset,
              ),
          ]
        : [
            for (var i = 0; i < FabricMaterial.placeholderTypeCount; i++)
              ImageChoice(
                id: '${_material.id}_type_$i',
                name: '',
                thumbnailAsset: '',
              ),
          ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('New Product'),
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
            'What type of ${_material.name.toLowerCase()}\nare you using?',
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
          onPressed: namedTypes && _selectedId == null ? null : _continue,
          icon: const Icon(Icons.arrow_forward, size: 20),
          label: const Text('Continue'),
        ),
      ),
    );
  }

  void _continue() {
    context.pushNamed(
      AppRoute.productSetup,
      queryParameters: {
        'material': _material.id,
        if (_material.asksSilkType && _selectedId != null)
          'silkType': _selectedId!,
      },
    );
  }
}
