import 'package:artisanal_lens/data/datasources/preset_catalog.dart';
import 'package:artisanal_lens/domain/entities/capture_feedback.dart';
import 'package:artisanal_lens/domain/entities/photography_template.dart';
import 'package:artisanal_lens/domain/entities/preset_capture_guidance.dart';
import 'package:artisanal_lens/domain/entities/shot_guidance.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:artisanal_lens/domain/entities/technique_preset.dart';
import 'package:artisanal_lens/features/capture/capture_session_controller.dart';
import 'package:artisanal_lens/features/capture/presentation/capture_page.dart';
import 'package:artisanal_lens/features/instruction/presentation/lighting_setup_page.dart';
import 'package:artisanal_lens/shared/widgets/asset_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/live_camera_harness.dart';

void main() {
  const catalog = BundledCatalogDataSource();

  const documented = <String, List<({String id, String name})>>{
    BundledCatalogDataSource.saree: [
      (id: 'saree_pallu_drape', name: 'Pallu drape (hanger)'),
      (id: 'saree_box_fold', name: 'Box / flat fold'),
      (id: 'saree_worn_drape', name: 'Worn drape (model)'),
      (id: 'saree_roll_display', name: 'Roll display'),
    ],
    BundledCatalogDataSource.cushionCover: [
      (id: 'cushion_flat_lay', name: 'Flat lay'),
      (id: 'cushion_stacked_pair', name: 'Stacked pair'),
      (id: 'cushion_propped', name: 'Propped on seating'),
      (id: 'cushion_corner_tuck', name: 'Corner tuck close-up'),
    ],
    BundledCatalogDataSource.shawl: [
      (id: 'shawl_draped_shoulder', name: 'Draped on shoulder'),
      (id: 'shawl_folded_stack', name: 'Folded stack'),
      (id: 'shawl_hung_flat', name: 'Hung / pinned flat'),
      (id: 'shawl_corner_tuck', name: 'Corner tuck close-up'),
    ],
    BundledCatalogDataSource.stole: [
      (id: 'stole_neck_wrap', name: 'Neck wrap (worn)'),
      (id: 'stole_flat_spread', name: 'Flat spread'),
      (id: 'stole_loose_knot', name: 'Loose knot'),
      (id: 'stole_rolled_coil', name: 'Rolled coil'),
    ],
  };

  test('every one of the 16 presets resolves its own guidance', () {
    final seen = <String>{};
    for (final entry in documented.entries) {
      for (final row in entry.value) {
        final preset = catalog.presetById(row.id)!;
        final guidance = PresetCaptureGuidance.fromPreset(preset);
        expect(guidance.presetId, row.id);
        expect(guidance.templateId, isNull);
        expect(guidance.templateName, isNull);
        expect(guidance.grid, preset.technique.grid);
        expect(guidance.technique.grid, preset.technique.grid);
        expect(guidance.cameraGuidance.grid, preset.technique.grid);
        expect(guidance.setupSteps, isNotEmpty, reason: row.id);
        expect(
          guidance.setupSteps.any((step) => step.instruction.trim().isNotEmpty),
          isTrue,
          reason: row.id,
        );
        seen.add(row.id);
      }
    }
    expect(seen, hasLength(16));
  });

  test('no preset receives another category\'s guidance', () {
    const prefixes = {
      BundledCatalogDataSource.saree: 'saree_',
      BundledCatalogDataSource.cushionCover: 'cushion_',
      BundledCatalogDataSource.shawl: 'shawl_',
      BundledCatalogDataSource.stole: 'stole_',
    };
    for (final category in catalog.categories()) {
      final prefix = prefixes[category.id]!;
      for (final preset in catalog.presetsForCategory(category.id)) {
        final guidance = PresetCaptureGuidance.fromPreset(preset);
        expect(guidance.presetId, startsWith(prefix));
        expect(guidance.grid, preset.technique.grid);
        for (final other in catalog.categories()) {
          if (other.id == category.id) continue;
          for (final foreign in catalog.presetsForCategory(other.id)) {
            expect(guidance.presetId, isNot(foreign.id));
          }
        }
      }
    }
  });

  test('Saree photography templates stay separate from the four folds', () {
    final pallu = PresetCaptureGuidance.fromPreset(
      catalog.presetById('saree_pallu_drape')!,
    );
    final weave = PresetCaptureGuidance.fromShotGuidance(
      ShotGuidance.fromTemplate(SareePhotographyTemplates.textureAndWeave),
      productNoun: 'saree',
    );
    expect(pallu.presetId, 'saree_pallu_drape');
    expect(pallu.templateId, isNull);
    expect(weave.templateId, 'saree_texture_weave');
    expect(weave.templateName, 'Texture & Weave');
    expect(weave.grid, GridOverlayType.centerFocus);
    expect(pallu.grid, GridOverlayType.leadingLines);
    expect(weave.grid, isNot(pallu.grid));
    expect(catalog.presetById(weave.templateId!), isNull);
  });

  test('Saree template setup is not the chosen fold\'s hang steps', () {
    final pallu = catalog.presetById('saree_pallu_drape')!;
    final resolved = PresetCaptureGuidance.resolve(
      shotGuidance: ShotGuidance.resolve(
        shotType: ShotType.sareePhotography,
        slotIndex: 1,
        preset: pallu,
        categoryId: BundledCatalogDataSource.saree,
      ),
      preset: pallu,
      productNoun: 'saree',
    );
    expect(resolved.presetId, 'saree_pallu_drape');
    expect(resolved.templateName, 'Texture & Weave');
    expect(resolved.grid, GridOverlayType.centerFocus);
    expect(resolved.placement, contains('well-lit section'));
    expect(
      resolved.setupSteps.first.instruction,
      isNot(contains('hanger')),
    );
  });

  test('Cushion Shawl and Stole keep their own grids, not Saree templates', () {
    final cushion = PresetCaptureGuidance.fromPreset(
      catalog.presetById('cushion_flat_lay')!,
    );
    final shawl = PresetCaptureGuidance.fromPreset(
      catalog.presetById('shawl_folded_stack')!,
    );
    final stole = PresetCaptureGuidance.fromPreset(
      catalog.presetById('stole_loose_knot')!,
    );
    expect(cushion.grid, GridOverlayType.ruleOfThirds);
    expect(shawl.grid, GridOverlayType.horizontalFolds);
    expect(stole.grid, GridOverlayType.centerFocus);
    expect(cushion.templateName, isNull);
    expect(shawl.templateName, isNull);
    expect(stole.templateName, isNull);
  });

  test('missing illustrations stay optional paths, not crashes', () {
    for (final category in catalog.categories()) {
      for (final preset in catalog.presetsForCategory(category.id)) {
        final guidance = PresetCaptureGuidance.fromPreset(preset);
        for (final step in guidance.setupSteps) {
          expect(step.placeholderLabel, isNotEmpty);
          expect(
            step.placeholderLabel,
            anyOf(
              'Setup illustration to be added',
              'Alignment illustration to be added',
            ),
          );
        }
      }
    }
  });

  testWidgets('a missing illustration never replaces the camera feed',
      (tester) async {
    await tester.pumpWidget(
      cameraHarness(
        session: const CaptureSession(
          setId: 'set_1',
          shotType: ShotType.product,
          slotIndex: 0,
          presetId: 'saree_pallu_drape',
        ),
        categoryId: BundledCatalogDataSource.saree,
        feedback: measuredFeedback(
          CapturePrompt.noProduct,
          productNoun: 'saree',
        ),
        child: const CapturePage(setId: 'set_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Drape the saree over a hanger, bamboo or mannequin so the pallu '
        'falls freely.',
      ),
      findsOneWidget,
    );
    expect(find.text('Setup illustration to be added'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selected preset survives Lighting and lands on the camera',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const session = CaptureSession(
      setId: 'set_1',
      shotType: ShotType.product,
      slotIndex: 0,
      presetId: 'cushion_flat_lay',
    );

    await tester.pumpWidget(
      cameraHarness(
        session: session,
        categoryId: BundledCatalogDataSource.cushionCover,
        child: const LightingSetupPage(setId: 'set_1'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Lighting and setup'), findsOneWidget);
    expect(find.text('Setup illustration to be added'), findsNothing);
    expect(
      tester.widget<CatalogImage>(find.byType(CatalogImage)).assetPath,
      'assets/images/presets/cushion_flat_lay.png',
    );
    expect(
      find.text('Place the cover flat on a plain, uncluttered surface.',
          skipOffstage: false),
      findsOneWidget,
    );

    await tester.pumpWidget(
      cameraHarness(
        session: session,
        categoryId: BundledCatalogDataSource.cushionCover,
        feedback: measuredFeedback(
          CapturePrompt.noProduct,
          productNoun: 'cushion cover',
        ),
        child: const CapturePage(setId: 'set_1'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Place the cushion cover in view'), findsOneWidget);
    expect(
      find.text('Place the cover flat on a plain, uncluttered surface.'),
      findsOneWidget,
    );
  });

  test('camera grid matches the selected Cushion preset, not a Saree template',
      () {
    final preset = catalog.presetById('cushion_stacked_pair')!;
    final stacked = PresetCaptureGuidance.fromPreset(preset);
    expect(stacked.grid, preset.technique.grid);
    expect(stacked.grid, GridOverlayType.horizontalFolds);
    expect(stacked.technique.composition.label, 'Negative space around folds');
    expect(stacked.templateName, isNull);
    expect(stacked.grid, isNot(GridOverlayType.centerFocus));
    expect(stacked.grid, isNot(GridOverlayType.detailFrame));
  });

  testWidgets('Saree Weave keeps Centre focus on camera after a Pallu fold',
      (tester) async {
    await tester.pumpWidget(
      cameraHarness(
        session: const CaptureSession(
          setId: 'set_1',
          shotType: ShotType.sareePhotography,
          slotIndex: 1,
          presetId: 'saree_pallu_drape',
        ),
        categoryId: BundledCatalogDataSource.saree,
        feedback: measuredFeedback(
          CapturePrompt.noProduct,
          productNoun: 'saree',
        ),
        child: const CapturePage(setId: 'set_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('A well-lit section of the saree, preferably in natural light'),
      findsOneWidget,
    );
    expect(find.textContaining('hanger'), findsNothing);
  });
}
