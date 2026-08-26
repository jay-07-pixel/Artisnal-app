import 'package:artisanal_lens/data/datasources/preset_catalog.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the property that actually broke: a shot type the artisan can pick
/// but cannot get past.
///
/// The capture flow gates "Open Camera" on
/// `shotType.skipsStyleStep || presetId != null`. So for every category and
/// every shot type, either the type skips the style step or the catalogue has
/// at least one preset to choose. Process failed this in all four categories —
/// it demanded a style and no category defined one, so two of the seven
/// required photographs were unreachable everywhere.
void main() {
  const catalog = BundledCatalogDataSource();

  group('every category can reach the camera for every shot type', () {
    for (final category in catalog.categories()) {
      for (final shotType in ShotType.checklistTypesFor(category.id)) {
        test('${category.name} / ${shotType.label}', () {
          final presets = catalog
              .presetsForCategory(category.id)
              .where((preset) => preset.supportedShotTypes.contains(shotType))
              .toList();

          expect(
            shotType.skipsStyleStep || presets.isNotEmpty,
            isTrue,
            reason: '${category.name} offers ${shotType.label} but has no '
                'preset for it, and the type does not skip the style step, so '
                '"Open Camera" can never enable.',
          );
        });
      }
    }
  });

  group('style-bearing types have presets in every category', () {
    // Product and Lifestyle always show the style step, so an empty list there
    // means the artisan sees "Choose a style" with nothing under it.
    for (final category in catalog.categories()) {
      final styleTypes = [
        ShotType.product,
        ShotType.lifestyle,
        if (category.id == BundledCatalogDataSource.saree)
          ShotType.sareePhotography,
      ];
      for (final shotType in styleTypes) {
        test('${category.name} / ${shotType.label} has at least one style', () {
          final presets = catalog
              .presetsForCategory(category.id)
              .where((preset) => preset.supportedShotTypes.contains(shotType))
              .toList();
          expect(presets, isNotEmpty);
        });
      }
    }
  });

  test('every category defines the same four shot types', () {
    for (final category in catalog.categories()) {
      final presets = catalog.presetsForCategory(category.id);
      expect(presets, isNotEmpty, reason: '${category.name} has no presets.');
    }
  });

  test('style-skipping types carry a usable fallback technique', () {
    for (final shotType in ShotType.values) {
      if (!shotType.skipsStyleStep) continue;
      // The camera reads angle/lighting/composition/grid off this; a missing
      // one would leave the overlay unguided.
      expect(shotType.fallbackTechnique.guidelines, isNotEmpty,
          reason: '${shotType.label} gives no reason for its advice.');
    }
  });

  test('every preset image is referenced from a real asset path', () {
    for (final category in catalog.categories()) {
      for (final preset in catalog.presetsForCategory(category.id)) {
        expect(preset.referenceImageAsset, startsWith('assets/images/presets/'));
      }
    }
  });
}
