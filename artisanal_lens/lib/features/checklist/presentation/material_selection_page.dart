import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/fabric_material.dart';
import '../../../shared/widgets/choice_image_grid.dart';
import '../../../shared/widgets/common.dart';

/// First New Product step: Silk, Cotton, Wool or Jute.
class MaterialSelectionPage extends StatefulWidget {
  const MaterialSelectionPage({super.key});

  @override
  State<MaterialSelectionPage> createState() => _MaterialSelectionPageState();
}

class _MaterialSelectionPageState extends State<MaterialSelectionPage> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final selected = FabricMaterial.byId(_selectedId ?? '');

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
            'What material are\nyou working with?',
            style: AppTypography.displayLarge,
          ),
          const SizedBox(height: AppDimens.space20),
          ChoiceImageGrid(
            choices: [
              for (final material in FabricMaterial.all)
                ImageChoice(
                  id: material.id,
                  name: material.name,
                  thumbnailAsset: material.thumbnailAsset,
                ),
            ],
            selectedId: _selectedId,
            onSelected: (id) => setState(() => _selectedId = id),
          ),
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: selected == null ? null : () => _continue(selected),
          icon: const Icon(Icons.arrow_forward, size: 20),
          label: const Text('Continue'),
        ),
      ),
    );
  }

  void _continue(FabricMaterial material) {
    context.pushNamed(
      AppRoute.silkType,
      queryParameters: {'material': material.id},
    );
  }
}
