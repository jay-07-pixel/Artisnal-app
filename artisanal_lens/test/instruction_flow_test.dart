import 'package:artisanal_lens/data/datasources/preset_catalog.dart';
import 'package:artisanal_lens/domain/entities/capture_feedback.dart';
import 'package:artisanal_lens/domain/entities/shot_guidance.dart';
import 'package:artisanal_lens/domain/entities/shot_set.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:artisanal_lens/domain/entities/technique_preset.dart';
import 'package:artisanal_lens/features/capture/capture_session_controller.dart';
import 'package:artisanal_lens/features/home/shot_sets_controller.dart';
import 'package:artisanal_lens/domain/entities/preset_capture_guidance.dart';
import 'package:artisanal_lens/features/capture/presentation/capture_page.dart';
import 'package:artisanal_lens/features/instruction/presentation/lighting_setup_page.dart';
import 'package:artisanal_lens/features/instruction/presentation/tutorial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/live_camera_harness.dart';

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

  testWidgets('Tutorial keeps the catalog video and hands over to the camera',
      (tester) async {
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

    final transcript = spokenTranscriptFor(
      catalog.presetById('saree_pallu_drape'),
    );
    expect(find.text('Watch how to set up'), findsOneWidget);
    expect(find.text(transcript.first), findsOneWidget);
    // Setup steps belong to the camera now, not to this screen.
    expect(find.text('Hang the saree'), findsNothing);
    expect(find.text('Open Camera'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a slot with no catalog tutorial opens the camera from Lighting',
      (tester) async {
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

    expect(hasTutorialContent(null), isFalse);
    expect(find.text('Open Camera'), findsOneWidget);
    expect(find.text('Before you shoot'), findsOneWidget);
  });

  test('Saree Weave takes Centre focus into the camera', () {
    final pallu = catalog.presetById('saree_pallu_drape')!;
    final weave = PresetCaptureGuidance.resolve(
      shotGuidance: ShotGuidance.resolve(
        shotType: ShotType.sareePhotography,
        slotIndex: 1,
        preset: pallu,
        categoryId: BundledCatalogDataSource.saree,
      ),
      preset: pallu,
      productNoun: 'saree',
    );
    expect(weave.technique.grid, GridOverlayType.centerFocus);
    expect(weave.technique.composition.label, 'Centre focus');
  });

  test('Saree Border takes Detail frame into the camera', () {
    final pallu = catalog.presetById('saree_pallu_drape')!;
    final border = PresetCaptureGuidance.resolve(
      shotGuidance: ShotGuidance.resolve(
        shotType: ShotType.sareePhotography,
        slotIndex: 3,
        preset: pallu,
        categoryId: BundledCatalogDataSource.saree,
      ),
      preset: pallu,
      productNoun: 'saree',
    );
    expect(border.technique.grid, GridOverlayType.detailFrame);
    // A detail shot asks for more of its smaller guide to be filled, and its
    // overflow is worded for the border rather than the whole cloth.
    expect(border.cameraGuidance.minTargetCoverage, 0.55);
    expect(
      border.cameraGuidance.orientationTarget,
      EdgeOrientationTarget.none,
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

  testWidgets('the camera waits for a frame instead of scripting steps',
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
        child: const CapturePage(setId: 'set_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reading the frame…'), findsOneWidget);
    expect(find.text('Ready to capture'), findsNothing);
    // Nothing to press: the frame decides what is said next.
    expect(find.text('Next'), findsNothing);
    expect(find.text('Done'), findsNothing);
  });

  testWidgets('a measured verdict replaces the waiting line', (tester) async {
    await tester.pumpWidget(
      cameraHarness(
        session: const CaptureSession(
          setId: 'set_1',
          shotType: ShotType.sareePhotography,
          slotIndex: 1,
          presetId: 'saree_pallu_drape',
        ),
        categoryId: BundledCatalogDataSource.saree,
        feedback: const CaptureFeedback(
          lightQuality: LightQuality.good,
          angleQuality: AngleQuality.ok,
          prompt: CapturePrompt.noProduct,
          meanLuminance: 0.5,
          pitchDegrees: 0,
          subjectFillRatio: 0,
          productNoun: 'saree',
        ),
        child: const CapturePage(setId: 'set_1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Place the saree in view'), findsOneWidget);
    // With nothing in view the preset's own placement line rides along.
    expect(
      find.text('A well-lit section of the saree, preferably in natural light'),
      findsOneWidget,
    );
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
