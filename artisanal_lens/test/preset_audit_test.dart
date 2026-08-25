import 'package:artisanal_lens/data/datasources/preset_catalog.dart';
import 'package:artisanal_lens/domain/entities/photography_template.dart';
import 'package:artisanal_lens/domain/entities/shot_guidance.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:artisanal_lens/domain/entities/technique_preset.dart';
import 'package:flutter_test/flutter_test.dart';

/// Step 2B: Saree-only photography templates, fold catalog isolation,
/// and the unresolved Pallu grid conflict.
void main() {
  const catalog = BundledCatalogDataSource();

  const documentedFolds = <String, List<String>>{
    BundledCatalogDataSource.saree: [
      'Pallu drape (hanger)',
      'Box / flat fold',
      'Worn drape (model)',
      'Roll display',
    ],
    BundledCatalogDataSource.cushionCover: [
      'Flat lay',
      'Stacked pair',
      'Propped on seating',
      'Corner tuck close-up',
    ],
    BundledCatalogDataSource.shawl: [
      'Draped on shoulder',
      'Folded stack',
      'Hung / pinned flat',
      'Corner tuck close-up',
    ],
    BundledCatalogDataSource.stole: [
      'Neck wrap (worn)',
      'Flat spread',
      'Loose knot',
      'Rolled coil',
    ],
  };

  test('the 16 fold/style presets remain unchanged', () {
    for (final entry in documentedFolds.entries) {
      final names = catalog
          .presetsForCategory(entry.key)
          .map((preset) => preset.name)
          .toSet();
      expect(names, entry.value.toSet());
    }
    expect(
      catalog.categories().fold<int>(
        0,
        (sum, category) =>
            sum + catalog.presetsForCategory(category.id).length,
      ),
      16,
    );
  });

  test('category isolation remains intact', () {
    for (final category in catalog.categories()) {
      for (final preset in catalog.presetsForCategory(category.id)) {
        expect(preset.categoryId, category.id);
      }
    }
  });

  test('photography templates remain separate from fold/style names', () {
    for (final template in SareePhotographyTemplates.all) {
      expect(catalog.presetById(template.id), isNull);
      final foldNames = catalog
          .presetsForCategory(BundledCatalogDataSource.saree)
          .map((preset) => preset.name);
      expect(foldNames, isNot(contains(template.name)));
    }
    expect(catalog.presetById('saree_hanger'), isNull);
  });

  group('Saree Weave uses Close-up of Texture and Weave', () {
    final weave = ShotGuidance.forSlot(
      ShotType.detail,
      1,
      categoryId: BundledCatalogDataSource.saree,
    );

    test('uses the Texture and Weave technique', () {
      expect(weave.templateName, 'Close-up of Texture and Weave');
      expect(weave.content, 'Texture, Thickness, Material, Transparency');
      expect(weave.needs, 'Preferably natural light');
    });

    test('uses Center Focus', () {
      expect(weave.technique.grid, GridOverlayType.centerFocus);
      expect(weave.technique.composition, CompositionRule.centerFocus);
    });
  });

  group('Saree Border uses Embroidery and Border Details', () {
    final border = ShotGuidance.forSlot(
      ShotType.detail,
      0,
      categoryId: BundledCatalogDataSource.saree,
    );

    test('uses the Embroidery and Border technique', () {
      expect(border.templateName, 'Embroidery and Border Details');
      expect(border.content, 'Embroidery, Quality');
      expect(border.needs, 'Side lighting; contrast background');
    });

    test('uses Detail Frame + leading lines', () {
      expect(border.technique.grid, GridOverlayType.detailFrame);
      expect(border.technique.composition, CompositionRule.detailFrame);
    });
  });

  test('Weave and Border do not use the same generic Detail technique', () {
    final border = ShotGuidance.forSlot(
      ShotType.detail,
      0,
      categoryId: BundledCatalogDataSource.saree,
    );
    final weave = ShotGuidance.forSlot(
      ShotType.detail,
      1,
      categoryId: BundledCatalogDataSource.saree,
    );
    final generic = ShotType.detail.fallbackTechnique;

    expect(border.technique.grid, isNot(weave.technique.grid));
    expect(border.templateName, isNot(weave.templateName));
    expect(weave.technique.composition, isNot(generic.composition));
    expect(border.technique.grid, isNot(generic.grid));
  });

  group('non-Saree categories do not inherit Saree photography templates', () {
    const others = [
      BundledCatalogDataSource.cushionCover,
      BundledCatalogDataSource.shawl,
      BundledCatalogDataSource.stole,
    ];

    test('Border is not Embroidery and Border Details', () {
      for (final categoryId in others) {
        final border = ShotGuidance.forSlot(
          ShotType.detail,
          0,
          categoryId: categoryId,
        );
        expect(border.templateName, isNull);
        expect(border.content, isEmpty);
        expect(border.needs, isNull);
        expect(
          border.technique.grid,
          ShotType.detail.fallbackTechnique.grid,
        );
      }
    });

    test('Weave is not Close-up of Texture and Weave', () {
      for (final categoryId in others) {
        final weave = ShotGuidance.forSlot(
          ShotType.detail,
          1,
          categoryId: categoryId,
        );
        expect(weave.templateName, isNull);
        expect(weave.content, isEmpty);
        expect(weave.needs, isNull);
        expect(
          weave.technique.grid,
          ShotType.detail.fallbackTechnique.grid,
        );
      }
    });
  });

  group('Pallu source conflict is documented, not silently resolved', () {
    test('Pallu keeps Leading Lines pending a source-owner decision', () {
      final pallu = catalog.presetById('saree_pallu_drape')!;
      expect(pallu.name, 'Pallu drape (hanger)');
      expect(pallu.name, isNot(SareePhotographyTemplates.drapedLook.name));
      expect(pallu.technique.grid, GridOverlayType.leadingLines);
      expect(
        pallu.technique.grid,
        isNot(GridOverlayType.ruleOfThirds),
        reason: 'Deck p.9 Rule of Thirds was not applied; BTP Leading Lines kept.',
      );
    });
  });

  group('documented Saree photography templates', () {
    test('Full Saree Display uses Rule of Thirds', () {
      const template = SareePhotographyTemplates.fullDisplay;
      expect(template.name, 'Full Saree Display');
      expect(template.grid, GridOverlayType.ruleOfThirds);
    });

    test('Close-up of Texture and Weave uses Centre Focus', () {
      const template = SareePhotographyTemplates.textureAndWeave;
      expect(template.name, 'Close-up of Texture and Weave');
      expect(template.grid, GridOverlayType.centerFocus);
    });

    test('Draped Look uses Leading Lines', () {
      expect(
        SareePhotographyTemplates.drapedLook.grid,
        GridOverlayType.leadingLines,
      );
    });

    test('Embroidery and Border Details uses Detail Frame', () {
      const template = SareePhotographyTemplates.embroideryAndBorder;
      expect(template.name, 'Embroidery and Border Details');
      expect(template.grid, GridOverlayType.detailFrame);
    });

    test('Folded Stack uses Horizontal + Diagonal', () {
      expect(
        SareePhotographyTemplates.foldedStack.grid,
        GridOverlayType.horizontalFolds,
      );
    });
  });

  test('without a category, Detail does not apply Saree templates', () {
    final border = ShotGuidance.forSlot(ShotType.detail, 0);
    final weave = ShotGuidance.forSlot(ShotType.detail, 1);
    expect(border.templateName, isNull);
    expect(weave.templateName, isNull);
    expect(border.content, isEmpty);
    expect(weave.content, isEmpty);
  });

  test('Hero and Styled shots inherit the chosen fold technique', () {
    final pallu = catalog.presetById('saree_pallu_drape')!;
    final hero = ShotGuidance.resolve(
      shotType: ShotType.product,
      slotIndex: 0,
      preset: pallu,
      categoryId: BundledCatalogDataSource.saree,
    );
    expect(hero.technique.grid, GridOverlayType.leadingLines);
    expect(hero.templateName, isNull);
  });
}
