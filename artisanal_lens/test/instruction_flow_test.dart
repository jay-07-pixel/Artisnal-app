import 'package:artisanal_lens/data/datasources/preset_catalog.dart';
import 'package:artisanal_lens/domain/entities/shot_guidance.dart';
import 'package:artisanal_lens/domain/entities/shot_set.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:artisanal_lens/domain/entities/technique_preset.dart';
import 'package:artisanal_lens/features/capture/capture_session_controller.dart';
import 'package:artisanal_lens/features/home/shot_sets_controller.dart';
import 'package:artisanal_lens/features/instruction/presentation/alignment_page.dart';
import 'package:artisanal_lens/features/instruction/presentation/lighting_setup_page.dart';
import 'package:artisanal_lens/features/instruction/presentation/tutorial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _SeededSession extends CaptureSessionController {
  _SeededSession(this._seed);

  final CaptureSession _seed;

  @override
  CaptureSession build() => _seed;
}

ShotSet _set({required String id, required String categoryId}) => ShotSet(
      id: id,
      productName: 'Test product',
      categoryId: categoryId,
      createdAt: DateTime(2026, 8, 26),
    );

void main() {
  const catalog = BundledCatalogDataSource();

  test('transcript comes only from the fold catalog, never template guidance', () {
    final pallu = catalog.presetById('saree_pallu_drape')!;
    expect(spokenTranscriptFor(pallu), isNotEmpty);
    expect(spokenTranscriptFor(null), isEmpty);

    final weave = ShotGuidance.forSlot(
      ShotType.detail,
      1,
      categoryId: BundledCatalogDataSource.saree,
    );
    expect(weave.guidance, isNotEmpty);
    expect(spokenTranscriptFor(null), isNot(weave.guidance));
  });

  test('Saree Weave lighting copy stays on the Texture & Weave technique', () {
    final weave = ShotGuidance.forSlot(
      ShotType.detail,
      1,
      categoryId: BundledCatalogDataSource.saree,
    );
    expect(weave.content, 'Texture, Thickness, Material, Transparency');
    expect(weave.needs, 'Preferably natural light');
    expect(weave.lightingNotes, contains('soft light'));
    expect(weave.lightingNotes, contains('harsh reflections'));
    expect(weave.technique.grid, GridOverlayType.centerFocus);
  });

  test('Saree Border lighting copy stays on Embroidery & Border', () {
    final border = ShotGuidance.forSlot(
      ShotType.detail,
      0,
      categoryId: BundledCatalogDataSource.saree,
    );
    expect(border.content, 'Embroidery, Quality');
    expect(border.technique.grid, GridOverlayType.detailFrame);
    expect(border.lightingNotes, isNotNull);
  });

  test('camera technique is the same object the instruction screens read', () {
    final weave = ShotGuidance.forSlot(
      ShotType.sareePhotography,
      1,
      categoryId: BundledCatalogDataSource.saree,
    );
    final pallu = catalog.presetById('saree_pallu_drape')!;
    final hero = ShotGuidance.resolve(
      shotType: ShotType.product,
      slotIndex: 0,
      preset: pallu,
      categoryId: BundledCatalogDataSource.saree,
    );
    expect(weave.technique.grid, GridOverlayType.centerFocus);
    expect(hero.technique.grid, GridOverlayType.leadingLines);

    final weaveWithFold = ShotGuidance.resolve(
      shotType: ShotType.sareePhotography,
      slotIndex: 1,
      preset: pallu,
      categoryId: BundledCatalogDataSource.saree,
    );
    expect(weaveWithFold.technique.grid, GridOverlayType.centerFocus);
    expect(weaveWithFold.templateName, 'Texture & Weave');
  });

  test('Pallu alignment illustration path is the catalog step, not the fold thumbnail', () {
    final pallu = catalog.presetById('saree_pallu_drape')!;
    expect(pallu.alignmentIllustrationAsset, isNot(pallu.referenceImageAsset));
    expect(
      pallu.alignmentIllustrationAsset,
      'assets/images/steps/saree_pallu_drape_3.png',
    );
    expect(pallu.technique.grid, GridOverlayType.leadingLines);
  });

  testWidgets('Lighting screen opens with Saree Weave technique copy', (tester) async {
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'set_1',
          shotType: ShotType.sareePhotography,
          slotIndex: 1,
        ),
        categoryId: BundledCatalogDataSource.saree,
        child: const LightingSetupPage(setId: 'set_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lighting and setup'), findsOneWidget);
    expect(
      find.text('Texture, Thickness, Material, Transparency', skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.text('Preferably natural light', skipOffstage: false),
      findsOneWidget,
    );
    await tester.drag(find.byType(ListView), const Offset(0, -2400));
    await tester.pumpAndSettle();
    expect(find.text('Centre focus'), findsOneWidget);
  });

  testWidgets('Tutorial screen opens and missing video does not crash', (tester) async {
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'set_1',
          shotType: ShotType.sareePhotography,
          slotIndex: 1,
        ),
        categoryId: BundledCatalogDataSource.saree,
        child: const TutorialPage(setId: 'set_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Watch how to set up'), findsOneWidget);
    expect(find.text('Tutorial video to be added'), findsOneWidget);
    expect(
      find.text(
        'The spoken transcript will appear here once the tutorial video is added.',
      ),
      findsOneWidget,
    );
    expect(find.text('The saree fills the frame.'), findsNothing);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Pallu tutorial shows catalog transcript, not a fabricated one', (tester) async {
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'set_1',
          shotType: ShotType.product,
          slotIndex: 0,
          presetId: 'saree_pallu_drape',
        ),
        categoryId: BundledCatalogDataSource.saree,
        child: const TutorialPage(setId: 'set_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Hang the saree so its fall is clearly visible.'),
      findsOneWidget,
    );
    expect(find.text('Tutorial video to be added'), findsOneWidget);
  });

  testWidgets('Alignment screen shows Center Focus for Saree Weave', (tester) async {
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'set_1',
          shotType: ShotType.sareePhotography,
          slotIndex: 1,
          presetId: 'saree_pallu_drape',
        ),
        categoryId: BundledCatalogDataSource.saree,
        child: const AlignmentPage(setId: 'set_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Align with the gridlines'), findsOneWidget);
    expect(find.text('Centre focus', skipOffstage: false), findsOneWidget);
    expect(find.text('Open Camera'), findsOneWidget);
  });

  testWidgets('Alignment screen shows Detail frame for Saree Border', (tester) async {
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'set_1',
          shotType: ShotType.sareePhotography,
          slotIndex: 3,
          presetId: 'saree_pallu_drape',
        ),
        categoryId: BundledCatalogDataSource.saree,
        child: const AlignmentPage(setId: 'set_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Detail frame', skipOffstage: false), findsOneWidget);
    expect(
      find.text('Keep the embroidery inside the frame', skipOffstage: false),
      findsWidgets,
    );
  });

  testWidgets('non-Saree Weave lighting does not show Saree template copy', (tester) async {
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'set_2',
          shotType: ShotType.detail,
          slotIndex: 1,
        ),
        categoryId: BundledCatalogDataSource.cushionCover,
        child: const LightingSetupPage(setId: 'set_2'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Texture, Thickness, Material, Transparency'), findsNothing);
    expect(find.text('Preferably natural light'), findsNothing);
      expect(find.text('Close-up of Texture and Weave'), findsNothing);
      expect(find.text('Texture & Weave'), findsNothing);
  });

  testWidgets('Open Camera stays enabled when the session still has its slot', (tester) async {
    await tester.pumpWidget(
      _harness(
        session: const CaptureSession(
          setId: 'set_1',
          shotType: ShotType.sareePhotography,
          slotIndex: 1,
          presetId: 'saree_pallu_drape',
        ),
        categoryId: BundledCatalogDataSource.saree,
        child: const AlignmentPage(setId: 'set_1'),
      ),
    );
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Open Camera'),
    );
    expect(button.onPressed, isNotNull);
  });
}

Widget _harness({
  required CaptureSession session,
  required String categoryId,
  required Widget child,
}) {
  return ProviderScope(
    overrides: [
      captureSessionProvider.overrideWith(() => _SeededSession(session)),
      shotSetProvider.overrideWith((ref, id) {
        return _set(id: id, categoryId: categoryId);
      }),
    ],
    child: MaterialApp(home: child),
  );
}
