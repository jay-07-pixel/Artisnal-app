import 'package:artisanal_lens/data/datasources/preset_catalog.dart';
import 'package:artisanal_lens/domain/entities/photography_template.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards that every photography template can reach the camera.
///
/// Styled templates must name at least one real fold. Close-ups skip style.
void main() {
  const catalog = BundledCatalogDataSource();

  group('every category can reach the camera for every photography template', () {
    for (final category in catalog.categories()) {
      for (final template in PhotographyTemplates.forCategory(category.id)) {
        test('${category.name} / ${template.name}', () {
          expect(
            template.skipsStyleStep || template.allowedPresetIds.isNotEmpty,
            isTrue,
            reason: '${category.name} / ${template.name} has no fold and '
                'does not skip style, so the camera cannot open.',
          );
          for (final presetId in template.allowedPresetIds) {
            expect(catalog.presetById(presetId), isNotNull);
          }
        });
      }
    }
  });

  group('style-bearing templates have presets in every category', () {
    for (final category in catalog.categories()) {
      test('${category.name} has at least one styled photograph', () {
        final styled = PhotographyTemplates.forCategory(category.id)
            .where((template) => template.needsStyleStep);
        expect(styled, isNotEmpty);
      });
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
