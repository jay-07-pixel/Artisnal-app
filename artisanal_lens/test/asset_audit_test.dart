import 'dart:io';

import 'package:artisanal_lens/data/datasources/preset_catalog.dart';
import 'package:artisanal_lens/domain/entities/fabric_material.dart';
import 'package:artisanal_lens/domain/entities/photography_template.dart';
import 'package:artisanal_lens/shared/widgets/asset_placeholder.dart';
import 'package:artisanal_lens/shared/widgets/catalog_video.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_l10n.dart';

/// Step 4: bundled assets that exist must load; missing catalog paths must
/// fail safely. Does not create files.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const catalog = BundledCatalogDataSource();

  Future<bool> isBundled(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  test('existing category thumbnails are bundled', () async {
    for (final category in catalog.categories()) {
      expect(
        await isBundled(category.thumbnailAsset),
        isTrue,
        reason: '${category.thumbnailAsset} is referenced and must load.',
      );
    }
  });

  test('photography template thumbnails are bundled', () async {
    for (final template in PhotographyTemplates.all) {
      final path = template.referenceImageAsset;
      expect(path, isNotNull, reason: template.id);
      expect(path, startsWith('assets/images/templates/'));
      expect(await isBundled(path!), isTrue, reason: path);
    }
  });

  test('material and silk-type thumbnails are bundled', () async {
    for (final material in FabricMaterial.all) {
      expect(
        await isBundled(material.thumbnailAsset),
        isTrue,
        reason: material.thumbnailAsset,
      );
    }
    for (final variety in SilkVariety.all) {
      expect(
        await isBundled(variety.thumbnailAsset),
        isTrue,
        reason: variety.thumbnailAsset,
      );
    }
    for (final variety in CottonVariety.all) {
      expect(
        await isBundled(variety.thumbnailAsset),
        isTrue,
        reason: variety.thumbnailAsset,
      );
    }
    for (final variety in WoolVariety.all) {
      expect(
        await isBundled(variety.thumbnailAsset),
        isTrue,
        reason: variety.thumbnailAsset,
      );
    }
    for (final variety in JuteVariety.all) {
      expect(
        await isBundled(variety.thumbnailAsset),
        isTrue,
        reason: variety.thumbnailAsset,
      );
    }
  });

  test('existing fold thumbnails are bundled', () async {
    for (final category in catalog.categories()) {
      for (final preset in catalog.presetsForCategory(category.id)) {
        final path = preset.referenceImageAsset;
        expect(
          await isBundled(path),
          isTrue,
          reason: '$path should load.',
        );
      }
    }
  });

  test('category assets stay isolated', () {
    const prefixes = <String, String>{
      BundledCatalogDataSource.saree: 'saree_',
      BundledCatalogDataSource.cushionCover: 'cushion_',
      BundledCatalogDataSource.shawl: 'shawl_',
      BundledCatalogDataSource.stole: 'stole_',
    };

    for (final category in catalog.categories()) {
      final prefix = prefixes[category.id]!;
      expect(category.thumbnailAsset.contains('/${category.id}.png') ||
          category.thumbnailAsset.contains('/${category.id.replaceAll('_', '')}') ||
          category.thumbnailAsset.contains(category.id), isTrue);

      for (final preset in catalog.presetsForCategory(category.id)) {
        expect(preset.categoryId, category.id);
        expect(
          preset.referenceImageAsset,
          contains('/$prefix'),
          reason: '${preset.name} must not use another category\'s image.',
        );
        for (final step in preset.setupSteps) {
          expect(step.illustrationAsset, contains('/$prefix'));
        }
        final video = preset.tutorialVideoAsset;
        if (video != null) {
          expect(video, contains('/$prefix'));
        }
      }
    }
  });

  test('every catalog step illustration is still a missing source asset', () async {
    final paths = <String>{};
    for (final category in catalog.categories()) {
      for (final preset in catalog.presetsForCategory(category.id)) {
        for (final step in preset.setupSteps) {
          paths.add(step.illustrationAsset);
        }
      }
    }
    expect(paths, isNotEmpty);
    for (final path in paths) {
      expect(await isBundled(path), isFalse, reason: path);
    }
  });

  test('bundled catalog tutorial videos load', () async {
    const bundled = <String>{
      'assets/videos/cushion_propped.mp4',
    };
    for (final path in bundled) {
      expect(await isBundled(path), isTrue, reason: path);
    }
  });

  test('every other catalog tutorial video is still a missing source asset',
      () async {
    final paths = <String>{};
    for (final category in catalog.categories()) {
      for (final preset in catalog.presetsForCategory(category.id)) {
        final video = preset.tutorialVideoAsset;
        if (video != null) paths.add(video);
      }
    }
    expect(paths.length, 15);
    const bundled = {'assets/videos/cushion_propped.mp4'};
    for (final path in paths) {
      if (bundled.contains(path)) continue;
      expect(await isBundled(path), isFalse, reason: path);
    }
    expect(
      catalog.presetById('saree_roll_display')!.tutorialVideoAsset,
      isNull,
    );
  });

  test('saree_hanger.png is leftover on disk and not a catalog preset', () {
    expect(catalog.presetById('saree_hanger'), isNull);
    expect(
      File('assets/images/presets/saree_hanger.png').existsSync(),
      isTrue,
    );
  });

  testWidgets('missing illustration fails safely', (tester) async {
    await tester.pumpWidget(
      l10nApp(
        home: const CatalogImage(
          assetPath: 'assets/images/steps/saree_pallu_drape_1.png',
          placeholderLabel: 'Setup illustration to be added',
          height: 80,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Setup illustration to be added'), findsOneWidget);
  });

  testWidgets('missing tutorial video fails safely', (tester) async {
    await tester.pumpWidget(
      l10nApp(
        home: const CatalogVideo(assetPath: 'assets/videos/saree_pallu_drape.mp4'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tutorial video to be added'), findsOneWidget);
  });
}
