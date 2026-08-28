import 'package:artisanal_lens/data/datasources/preset_catalog.dart';
import 'package:artisanal_lens/domain/entities/capture_feedback.dart';
import 'package:artisanal_lens/domain/entities/photography_template.dart';
import 'package:artisanal_lens/domain/entities/shot_guidance.dart';
import 'package:artisanal_lens/domain/entities/shot_set.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:artisanal_lens/domain/entities/technique_preset.dart';
import 'package:artisanal_lens/features/capture/capture_session_controller.dart';
import 'package:artisanal_lens/features/checklist/presentation/photo_list_page.dart';
import 'package:artisanal_lens/features/home/shot_sets_controller.dart';
import 'package:artisanal_lens/features/capture/camera_controller.dart';
import 'package:artisanal_lens/features/capture/presentation/capture_page.dart';
import 'package:artisanal_lens/features/instruction/presentation/lighting_setup_page.dart';
import 'package:artisanal_lens/features/shot_type/presentation/shot_and_style_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/live_camera_harness.dart';
import 'support/test_l10n.dart';

class _SeededSession extends CaptureSessionController {
  _SeededSession(this._seed);

  final CaptureSession _seed;

  @override
  CaptureSession build() => _seed;
}

ShotSet _sareeSet({List<CapturedShot> shots = const []}) => ShotSet(
      id: 'saree_1',
      productName: 'Test Saree',
      categoryId: BundledCatalogDataSource.saree,
      createdAt: DateTime(2026, 8, 26),
      shots: shots,
    );

ShotSet _otherSet(String categoryId) => ShotSet(
      id: 'other_1',
      productName: 'Test Product',
      categoryId: categoryId,
      createdAt: DateTime(2026, 8, 26),
    );

Widget _listHarness(ShotSet set) {
  return ProviderScope(
    overrides: [
      shotSetProvider.overrideWith((ref, id) => set),
    ],
    child: l10nApp(home: PhotoListPage(setId: set.id)),
  );
}

Widget _flowHarness({
  required CaptureSession session,
  required Widget child,
  CaptureFeedback feedback = const CaptureFeedback.initial(),
}) {
  return ProviderScope(
    key: ValueKey('${session.setId}-${session.slotIndex}'),
    overrides: [
      captureSessionProvider.overrideWith(() => _SeededSession(session)),
      shotSetProvider.overrideWith((ref, id) => _sareeSet()),
      guidedCameraProvider.overrideWith(
        () => FakeGuidedCamera(
          GuidedCameraState(
            status: CameraStatus.unavailable,
            feedback: feedback,
            errorMessage: 'No camera in tests',
          ),
        ),
      ),
    ],
    child: l10nApp(home: child),
  );
}

/// The verdict the analyser reports when the guide is empty, which is when
/// the preset's own placement line is worth showing.
final _nothingInView = measuredFeedback(
  CapturePrompt.noProduct,
  productNoun: 'saree',
);

void main() {
  const expectedNames = [
    'Full Saree Display',
    'Texture & Weave',
    'Draped Look',
    'Embroidery & Border Details',
    'Folded Stack / Saree Stack',
  ];

  test('Saree exposes exactly five photography templates', () {
    expect(SareePhotographyTemplates.all, hasLength(5));
    expect(
      SareePhotographyTemplates.all.map((template) => template.name).toList(),
      expectedNames,
    );
    expect(
      SareePhotographyTemplates.all.map((template) => template.id).toList(),
      [
        'saree_full_display',
        'saree_texture_weave',
        'saree_draped_look',
        'saree_embroidery_border',
        'saree_folded_stack',
      ],
    );
    expect(
      ShotType.sareePhotography.slotLabels,
      expectedNames,
    );
  });

  test('each Saree template has a bundled list thumbnail', () {
    expect(
      SareePhotographyTemplates.all.map((t) => t.referenceImageAsset).toList(),
      [
        'assets/images/templates/saree_full_display.png',
        'assets/images/templates/saree_texture_weave.png',
        'assets/images/templates/saree_draped_look.png',
        'assets/images/templates/saree_embroidery_border.png',
        'assets/images/templates/saree_folded_stack.png',
      ],
    );
  });

  test('template IDs stay unique and separate from fold presets', () {
    const catalog = BundledCatalogDataSource();
    final ids = SareePhotographyTemplates.all.map((t) => t.id).toList();
    expect(ids.toSet(), hasLength(5));
    for (final template in SareePhotographyTemplates.all) {
      expect(catalog.presetById(template.id), isNull);
      expect(
        catalog
            .presetsForCategory(BundledCatalogDataSource.saree)
            .map((preset) => preset.name),
        isNot(contains(template.name)),
      );
    }
    expect(
      catalog
          .presetsForCategory(BundledCatalogDataSource.saree)
          .map((preset) => preset.name)
          .toList(),
      [
        'Pallu drape (hanger)',
        'Box / flat fold',
        'Worn drape (model)',
        'Roll display',
      ],
    );
  });

  test('Full Saree Display uses Rule of Thirds', () {
    const template = SareePhotographyTemplates.fullDisplay;
    expect(template.grid, GridOverlayType.ruleOfThirds);
    expect(
      ShotGuidance.fromTemplate(template).technique.grid,
      GridOverlayType.ruleOfThirds,
    );
  });

  test('Texture & Weave uses Center Focus', () {
    expect(
      SareePhotographyTemplates.textureAndWeave.grid,
      GridOverlayType.centerFocus,
    );
  });

  test('Draped Look uses Leading Lines', () {
    expect(
      SareePhotographyTemplates.drapedLook.grid,
      GridOverlayType.leadingLines,
    );
  });

  test('Embroidery & Border Details uses Detail Frame + leading lines', () {
    expect(
      SareePhotographyTemplates.embroideryAndBorder.grid,
      GridOverlayType.detailFrame,
    );
  });

  test('Folded Stack uses Horizontal + diagonal', () {
    expect(
      SareePhotographyTemplates.foldedStack.grid,
      GridOverlayType.horizontalFolds,
    );
  });

  test('Pallu drape vs Draped Look conflict is left unresolved', () {
    const catalog = BundledCatalogDataSource();
    final pallu = catalog.presetById('saree_pallu_drape')!;
    expect(pallu.technique.grid, GridOverlayType.leadingLines);
    expect(SareePhotographyTemplates.drapedLook.grid, GridOverlayType.leadingLines);
    expect(pallu.name, isNot(SareePhotographyTemplates.drapedLook.name));
  });

  test('Cushion Cover, Shawl and Stole use five photography templates', () {
    for (final categoryId in [
      BundledCatalogDataSource.cushionCover,
      BundledCatalogDataSource.shawl,
      BundledCatalogDataSource.stole,
    ]) {
      final set = _otherSet(categoryId);
      expect(set.usesSareePhotographyTemplates, isFalse);
      expect(set.usesPhotographyTemplates, isTrue);
      expect(set.requiredCount, 5);
      expect(set.slots.length, 5);
      expect(
        set.slots.map((slot) => slot.label),
        isNot(contains('Full Saree Display')),
      );
      expect(
        set.slots.map((slot) => slot.label),
        isNot(contains('Hero shot')),
      );
    }
  });

  test('Saree photography offers How should it look', () {
    expect(ShotType.sareePhotography.skipsStyleStep, isFalse);
    expect(ShotType.detail.skipsStyleStep, isTrue);
    expect(ShotType.process.skipsStyleStep, isTrue);
  });

  testWidgets('Saree photo list shows the five templates, not the old seven',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_listHarness(_sareeSet()));
    await tester.pumpAndSettle();

    expect(find.text('Saree photography templates'), findsOneWidget);
    expect(find.text('0 / 5'), findsOneWidget);
    for (final name in expectedNames) {
      expect(find.text(name, skipOffstage: false), findsOneWidget);
    }
    expect(find.text('Hero shot'), findsNothing);
    expect(find.text('Loom setup'), findsNothing);
    expect(find.text('Dyeing'), findsNothing);
    expect(find.text('Motif'), findsNothing);
    expect(find.text('Styled shot'), findsNothing);
    expect(find.text('Border'), findsNothing);
    expect(find.text('Weave'), findsNothing);
  });

  testWidgets('Saree Full Display offers only worn and roll folds', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _flowHarness(
        session: const CaptureSession(
          setId: 'saree_1',
          shotType: ShotType.sareePhotography,
          slotIndex: 0,
        ),
        child: const ShotAndStylePage(setId: 'saree_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('How should it look?'), findsOneWidget);
    expect(
      find.text('Choose the arrangement for this full saree display photo.'),
      findsOneWidget,
    );
    expect(find.text('Worn drape (model)', skipOffstage: false), findsOneWidget);
    expect(find.text('Roll display', skipOffstage: false), findsOneWidget);
    expect(find.text('Pallu drape (hanger)'), findsNothing);
    expect(find.text('Box / flat fold'), findsNothing);
  });

  testWidgets('Cushion Cover photo list shows five photography templates',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _listHarness(_otherSet(BundledCatalogDataSource.cushionCover)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Photography templates'), findsOneWidget);
    expect(find.text('0 / 5'), findsOneWidget);
    expect(find.text('Full Cover Display', skipOffstage: false), findsOneWidget);
    expect(find.text('Hero shot'), findsNothing);
    expect(find.text('Full Saree Display'), findsNothing);
    expect(find.text('Draped Look'), findsNothing);
  });

  testWidgets('selected Saree template keeps lighting copy after a fold is chosen',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const cases = <({int index, String lighting, String placement})>[
      (
        index: 0,
        lighting: 'Colour, Pattern, Material',
        placement: 'Saree spread flat or draped over a surface',
      ),
      (
        index: 1,
        lighting: 'Texture, Thickness, Material, Transparency',
        placement: 'A well-lit section of the saree, preferably in natural light',
      ),
      (
        index: 2,
        lighting: 'Flimsiness, Sheen, Flow, Weight',
        placement: 'Hanger, bamboo or mannequin',
      ),
      (
        index: 3,
        lighting: 'Embroidery, Quality',
        placement: 'Close-up of the saree border or an embroidered section',
      ),
      (
        index: 4,
        lighting: 'Thickness, Material weight',
        placement: 'Neatly stacked with visible folds',
      ),
    ];

    for (final item in cases) {
      final session = CaptureSession(
        setId: 'saree_1',
        shotType: ShotType.sareePhotography,
        slotIndex: item.index,
        presetId: 'saree_pallu_drape',
      );

      await tester.pumpWidget(
        _flowHarness(
          session: session,
          child: const LightingSetupPage(setId: 'saree_1'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Lighting and setup'), findsOneWidget);
      expect(
        find.text(item.lighting, skipOffstage: false),
        findsOneWidget,
        reason: expectedNames[item.index],
      );

      // With nothing in view, the camera offers this template's own
      // placement copy — never the chosen fold's.
      await tester.pumpWidget(
        _flowHarness(
          session: session,
          feedback: _nothingInView,
          child: const CapturePage(setId: 'saree_1'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Place the saree in view'), findsOneWidget,
          reason: expectedNames[item.index]);
      expect(
        find.text(item.placement),
        findsOneWidget,
        reason: expectedNames[item.index],
      );
      expect(
        find.text('Hang the saree so its fall is clearly visible.'),
        findsNothing,
        reason: expectedNames[item.index],
      );
      expect(find.text('Ready to capture'), findsNothing,
          reason: expectedNames[item.index]);
    }
  });

  testWidgets('completed Saree template stays marked and remains one slot',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final shot = CapturedShot(
      id: 'shot_full',
      setId: 'saree_1',
      shotType: ShotType.sareePhotography,
      slotIndex: 0,
      filePath: '/photos/full.jpg',
      capturedAt: DateTime(2026, 8, 26),
    );
    final set = _sareeSet(shots: [shot]);
    expect(set.completedCount, 1);
    expect(set.requiredCount, 5);
    expect(set.slots.where((slot) => slot.label == 'Full Saree Display'), hasLength(1));

    await tester.pumpWidget(_listHarness(set));
    await tester.pumpAndSettle();
    expect(find.text('1 / 5'), findsOneWidget);
    expect(find.text('Full Saree Display', skipOffstage: false), findsOneWidget);
  });
}
