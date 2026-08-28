import 'package:artisanal_lens/data/datasources/preset_catalog.dart';
import 'package:artisanal_lens/domain/entities/photography_template.dart';
import 'package:artisanal_lens/domain/entities/shot_set.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:artisanal_lens/features/capture/capture_session_controller.dart';
import 'package:artisanal_lens/features/home/shot_sets_controller.dart';
import 'package:artisanal_lens/features/capture/camera_controller.dart';
import 'package:artisanal_lens/features/capture/presentation/capture_page.dart';
import 'package:artisanal_lens/features/instruction/presentation/lighting_setup_page.dart';
import 'package:artisanal_lens/features/instruction/presentation/tutorial_page.dart';
import 'package:artisanal_lens/features/shot_type/presentation/shot_and_style_page.dart';
import 'package:artisanal_lens/shared/widgets/asset_placeholder.dart';
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

ShotSet _set({
  required String id,
  required String categoryId,
  required String productName,
}) =>
    ShotSet(
      id: id,
      productName: productName,
      categoryId: categoryId,
      createdAt: DateTime(2026, 8, 26),
    );

Widget _harness({
  required CaptureSession session,
  required String categoryId,
  required String productName,
  required Widget child,
}) {
  return ProviderScope(
    key: ValueKey('${session.setId}-${session.presetId}'),
    overrides: [
      captureSessionProvider.overrideWith(() => _SeededSession(session)),
      shotSetProvider.overrideWith((ref, id) {
        return _set(id: id, categoryId: categoryId, productName: productName);
      }),
      guidedCameraProvider.overrideWith(
        () => FakeGuidedCamera(
          const GuidedCameraState(
            status: CameraStatus.unavailable,
            errorMessage: 'No camera in tests',
          ),
        ),
      ),
    ],
    child: l10nApp(home: child),
  );
}

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

  test('exactly 16 fold/style presets exist', () {
    final all = catalog
        .categories()
        .expand((category) => catalog.presetsForCategory(category.id));
    expect(all.length, 16);
  });

  test('each category has exactly four documented presets', () {
    for (final entry in documented.entries) {
      final presets = catalog.presetsForCategory(entry.key);
      expect(presets, hasLength(4), reason: entry.key);
      expect(
        presets.map((preset) => preset.name).toList(),
        entry.value.map((row) => row.name).toList(),
      );
      expect(
        presets.map((preset) => preset.id).toList(),
        entry.value.map((row) => row.id).toList(),
      );
    }
  });

  test('preset IDs are unique', () {
    final ids = catalog
        .categories()
        .expand((category) => catalog.presetsForCategory(category.id))
        .map((preset) => preset.id)
        .toList();
    expect(ids.toSet(), hasLength(ids.length));
  });

  test('no category exposes another category\'s presets', () {
    const prefixes = {
      BundledCatalogDataSource.saree: 'saree_',
      BundledCatalogDataSource.cushionCover: 'cushion_',
      BundledCatalogDataSource.shawl: 'shawl_',
      BundledCatalogDataSource.stole: 'stole_',
    };
    for (final category in catalog.categories()) {
      final prefix = prefixes[category.id]!;
      for (final preset in catalog.presetsForCategory(category.id)) {
        expect(preset.categoryId, category.id);
        expect(preset.id, startsWith(prefix));
        expect(preset.referenceImageAsset, contains('/$prefix'));
      }
    }
  });

  test('Saree photography templates stay separate from fold presets', () {
    for (final template in SareePhotographyTemplates.all) {
      expect(catalog.presetById(template.id), isNull);
      expect(
        catalog
            .presetsForCategory(BundledCatalogDataSource.saree)
            .map((preset) => preset.name),
        isNot(contains(template.name)),
      );
    }
    expect(catalog.presetById('saree_hanger'), isNull);
    expect(SareePhotographyTemplates.all, hasLength(5));
  });

  testWidgets('Saree style list shows only the four Saree folds', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'saree_1',
          shotType: ShotType.product,
          slotIndex: 0,
        ),
        categoryId: BundledCatalogDataSource.saree,
        productName: 'Test Saree',
        child: const ShotAndStylePage(setId: 'saree_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pallu drape (hanger)', skipOffstage: false), findsOneWidget);
    expect(find.text('Box / flat fold', skipOffstage: false), findsOneWidget);
    expect(find.text('Worn drape (model)', skipOffstage: false), findsOneWidget);
    expect(find.text('Roll display', skipOffstage: false), findsOneWidget);
    expect(find.text('Flat lay'), findsNothing);
    expect(find.text('Draped on shoulder'), findsNothing);
    expect(find.text('Neck wrap (worn)'), findsNothing);
  });

  testWidgets('Saree Full Display offers only worn and roll folds',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'saree_1',
          shotType: ShotType.sareePhotography,
          slotIndex: 0,
        ),
        categoryId: BundledCatalogDataSource.saree,
        productName: 'Test Saree',
        child: const ShotAndStylePage(setId: 'saree_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Worn drape (model)', skipOffstage: false), findsOneWidget);
    expect(find.text('Roll display', skipOffstage: false), findsOneWidget);
    expect(find.text('Pallu drape (hanger)'), findsNothing);
    expect(find.text('Box / flat fold'), findsNothing);
  });

  testWidgets('Cushion Full Cover Display offers only Flat lay', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'cushion_1',
          shotType: ShotType.photography,
          slotIndex: 0,
        ),
        categoryId: BundledCatalogDataSource.cushionCover,
        productName: 'Test Cushion',
        child: const ShotAndStylePage(setId: 'cushion_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Flat lay', skipOffstage: false), findsOneWidget);
    expect(find.text('Stacked pair'), findsNothing);
    expect(find.text('Propped on seating'), findsNothing);
    expect(find.text('Corner tuck close-up'), findsNothing);
  });

  testWidgets('Cushion style list shows all four Cushion folds on Product',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'cushion_1',
          shotType: ShotType.product,
          slotIndex: 0,
        ),
        categoryId: BundledCatalogDataSource.cushionCover,
        productName: 'Test Cushion',
        child: const ShotAndStylePage(setId: 'cushion_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Flat lay', skipOffstage: false), findsOneWidget);
    expect(find.text('Stacked pair', skipOffstage: false), findsOneWidget);
    expect(find.text('Propped on seating', skipOffstage: false), findsOneWidget);
    expect(find.text('Corner tuck close-up', skipOffstage: false), findsOneWidget);
    expect(find.text('Pallu drape (hanger)'), findsNothing);
    expect(find.textContaining('cushion cover product photo'), findsOneWidget);
  });

  testWidgets('Shawl and Stole style lists stay isolated', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'shawl_1',
          shotType: ShotType.product,
          slotIndex: 0,
        ),
        categoryId: BundledCatalogDataSource.shawl,
        productName: 'Test Shawl',
        child: const ShotAndStylePage(setId: 'shawl_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Draped on shoulder', skipOffstage: false), findsOneWidget);
    expect(find.text('Folded stack', skipOffstage: false), findsOneWidget);
    expect(find.text('Hung / pinned flat', skipOffstage: false), findsOneWidget);
    expect(find.text('Corner tuck close-up', skipOffstage: false), findsOneWidget);
    expect(find.text('Neck wrap (worn)'), findsNothing);
    expect(find.text('Flat lay'), findsNothing);
  });

  testWidgets('Stole style list shows only the four Stole folds', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'stole_style',
          shotType: ShotType.product,
          slotIndex: 0,
        ),
        categoryId: BundledCatalogDataSource.stole,
        productName: 'Test Stole',
        child: const ShotAndStylePage(setId: 'stole_style'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Neck wrap (worn)', skipOffstage: false), findsOneWidget);
    expect(find.text('Flat spread', skipOffstage: false), findsOneWidget);
    expect(find.text('Loose knot', skipOffstage: false), findsOneWidget);
    expect(find.text('Rolled coil', skipOffstage: false), findsOneWidget);
    expect(find.text('Pallu drape (hanger)'), findsNothing);
    expect(find.text('Draped on shoulder'), findsNothing);
  });

  testWidgets('Roll display thumbnail loads', (tester) async {
    await tester.pumpWidget(
      l10nApp(
        home: CatalogImage(
          assetPath: 'assets/images/presets/saree_roll_display.png',
          placeholderLabel: 'Preset image to be added',
          height: 88,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Preset image to be added'), findsNothing);
    expect(find.byType(Image), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selected preset persists through Lighting Tutorial and Camera',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const cases = <({
      String setId,
      String categoryId,
      String productName,
      String presetId,
      String setupTitle,
    })>[
      (
        setId: 'saree_persist',
        categoryId: BundledCatalogDataSource.saree,
        productName: 'Test Saree',
        presetId: 'saree_pallu_drape',
        setupTitle: 'Hang the saree',
      ),
      (
        setId: 'cushion_persist',
        categoryId: BundledCatalogDataSource.cushionCover,
        productName: 'Test Cushion',
        presetId: 'cushion_flat_lay',
        setupTitle: 'Lay it flat',
      ),
      (
        setId: 'shawl_persist',
        categoryId: BundledCatalogDataSource.shawl,
        productName: 'Test Shawl',
        presetId: 'shawl_draped_shoulder',
        setupTitle: 'Drape the shawl',
      ),
      (
        setId: 'stole_1',
        categoryId: BundledCatalogDataSource.stole,
        productName: 'Test Stole',
        presetId: 'stole_neck_wrap',
        setupTitle: 'Wrap the stole',
      ),
    ];

    for (final item in cases) {
      final session = CaptureSession(
        setId: item.setId,
        shotType: ShotType.product,
        slotIndex: 0,
        presetId: item.presetId,
      );

      await tester.pumpWidget(
        _harness(
          session: session,
          categoryId: item.categoryId,
          productName: item.productName,
          child: LightingSetupPage(setId: item.setId),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Lighting and setup'), findsOneWidget, reason: item.presetId);
      expect(find.text('Place the product', skipOffstage: false), findsWidgets,
          reason: item.presetId);

      await tester.pumpWidget(
        _harness(
          session: session,
          categoryId: item.categoryId,
          productName: item.productName,
          child: TutorialPage(setId: item.setId),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Watch how to set up'), findsOneWidget,
          reason: item.presetId);
      expect(find.text('Open Camera'), findsOneWidget, reason: item.presetId);

      // The camera opens straight into live inspection: no scripted steps to
      // walk through, and nothing claiming the shot is good yet.
      await tester.pumpWidget(
        _harness(
          session: session,
          categoryId: item.categoryId,
          productName: item.productName,
          child: CapturePage(setId: item.setId),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Reading the frame…'), findsOneWidget,
          reason: item.presetId);
      expect(find.text('Ready to capture'), findsNothing,
          reason: item.presetId);
      expect(find.text('Next'), findsNothing, reason: item.presetId);
    }
  });
}
