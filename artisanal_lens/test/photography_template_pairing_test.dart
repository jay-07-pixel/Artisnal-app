import 'package:artisanal_lens/data/datasources/preset_catalog.dart';
import 'package:artisanal_lens/domain/entities/photography_template.dart';
import 'package:artisanal_lens/domain/entities/shot_set.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const catalog = BundledCatalogDataSource();

  test('every category has five photography templates', () {
    for (final category in catalog.categories()) {
      final templates = PhotographyTemplates.forCategory(category.id);
      expect(templates, hasLength(5), reason: category.name);
      expect(ShotSet(
        id: 'set',
        productName: 'Test',
        categoryId: category.id,
        createdAt: DateTime(2026, 8, 27),
      ).requiredCount, 5);
    }
  });

  test('template ids never collide with fold presets', () {
    for (final template in PhotographyTemplates.all) {
      expect(catalog.presetById(template.id), isNull, reason: template.id);
    }
  });

  test('close-ups skip style and styled templates name real presets', () {
    const expected = {
      'saree_full_display': ['saree_worn_drape', 'saree_roll_display'],
      'saree_texture_weave': <String>[],
      'saree_draped_look': ['saree_pallu_drape'],
      'saree_embroidery_border': <String>[],
      'saree_folded_stack': ['saree_box_fold'],
      'cushion_full_cover': ['cushion_flat_lay'],
      'cushion_texture_weave': <String>[],
      'cushion_stacked_thickness': ['cushion_stacked_pair'],
      'cushion_corner_stitching': <String>[],
      'cushion_in_use': ['cushion_propped'],
      'shawl_full_design': ['shawl_hung_flat'],
      'shawl_texture_weave': <String>[],
      'shawl_draped_look': ['shawl_draped_shoulder'],
      'shawl_border_corner': <String>[],
      'shawl_stack_display': ['shawl_folded_stack'],
      'stole_full_length': ['stole_flat_spread'],
      'stole_texture_weave': <String>[],
      'stole_worn_neck_wrap': ['stole_neck_wrap'],
      'stole_softness_knot': ['stole_loose_knot'],
      'stole_edge_thickness': ['stole_rolled_coil'],
    };

    expect(PhotographyTemplates.all, hasLength(expected.length));
    for (final template in PhotographyTemplates.all) {
      expect(template.allowedPresetIds, expected[template.id], reason: template.id);
      expect(template.skipsStyleStep, expected[template.id]!.isEmpty);
      for (final presetId in template.allowedPresetIds) {
        final preset = catalog.presetById(presetId);
        expect(preset, isNotNull, reason: '$presetId for ${template.id}');
        expect(preset!.categoryId, isNotEmpty);
      }
    }
  });

  test('Cushion Shawl and Stole do not reuse Saree template names as ids', () {
    expect(
      PhotographyTemplates.forCategory(BundledCatalogDataSource.cushionCover)
          .map((t) => t.id),
      isNot(contains('saree_full_display')),
    );
    expect(
      ShotType.checklistTypesFor(BundledCatalogDataSource.cushionCover),
      [ShotType.photography],
    );
    expect(
      ShotType.checklistTypesFor(BundledCatalogDataSource.saree),
      [ShotType.sareePhotography],
    );
  });
}
