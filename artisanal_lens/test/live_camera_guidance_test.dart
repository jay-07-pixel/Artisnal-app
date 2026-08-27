import 'package:artisanal_lens/data/datasources/preset_catalog.dart';
import 'package:artisanal_lens/domain/entities/capture_feedback.dart';
import 'package:artisanal_lens/domain/entities/preset_capture_guidance.dart';
import 'package:artisanal_lens/domain/entities/technique_preset.dart';
import 'package:artisanal_lens/domain/services/capture_guidance_service.dart';
import 'package:artisanal_lens/domain/services/frame_analyzer.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/synthetic_frame.dart';

/// The 16 documented folds, and what each category is called on screen.
const _folds = <String, List<String>>{
  BundledCatalogDataSource.saree: [
    'saree_pallu_drape',
    'saree_box_fold',
    'saree_worn_drape',
    'saree_roll_display',
  ],
  BundledCatalogDataSource.cushionCover: [
    'cushion_flat_lay',
    'cushion_stacked_pair',
    'cushion_propped',
    'cushion_corner_tuck',
  ],
  BundledCatalogDataSource.shawl: [
    'shawl_draped_shoulder',
    'shawl_folded_stack',
    'shawl_hung_flat',
    'shawl_corner_tuck',
  ],
  BundledCatalogDataSource.stole: [
    'stole_neck_wrap',
    'stole_flat_spread',
    'stole_loose_knot',
    'stole_rolled_coil',
  ],
};

const _nouns = <String, String>{
  BundledCatalogDataSource.saree: 'saree',
  BundledCatalogDataSource.cushionCover: 'cushion cover',
  BundledCatalogDataSource.shawl: 'shawl',
  BundledCatalogDataSource.stole: 'stole',
};

const _analyzer = FrameAnalyzer();
const _service = CaptureGuidanceService();

/// Runs a frame through the same analyser and evaluator the phone uses.
CaptureFeedback inspect(
  SyntheticFrame frame,
  PresetCaptureGuidance guidance, {
  double left = 0,
  double top = 0,
  double right = 1,
  double bottom = 1,
  double? pitchDegrees,
}) {
  final grid = guidance.technique.grid;
  final metrics = _analyzer.analyseLumaPlane(
    luma: frame.build(left: left, top: top, right: right, bottom: bottom),
    width: frame.width,
    height: frame.height,
    bytesPerRow: frame.width,
    insetX: grid.ghostInsetX,
    insetY: grid.ghostInsetY,
  );
  return _service.evaluate(
    metrics: metrics,
    technique: guidance.technique,
    pitchDegrees:
        pitchDegrees ?? guidance.technique.angle.targetPitchDegrees.toDouble(),
    profile: guidance.cameraGuidance,
  );
}

/// Cloth woven the way this preset's grid asks for, so a well-placed frame is
/// not failed on a direction check it was never going to satisfy.
FabricGrain grainFor(PresetCaptureGuidance guidance) =>
    switch (guidance.cameraGuidance.orientationTarget) {
      EdgeOrientationTarget.horizontal => FabricGrain.horizontal,
      EdgeOrientationTarget.diagonal => FabricGrain.diagonal,
      EdgeOrientationTarget.none => FabricGrain.isotropic,
    };

/// Fills this preset's own ghost frame exactly.
({double left, double top, double right, double bottom}) filling(
  PresetCaptureGuidance guidance,
) {
  final grid = guidance.technique.grid;
  return (
    left: grid.ghostInsetX,
    top: grid.ghostInsetY,
    right: 1 - grid.ghostInsetX,
    bottom: 1 - grid.ghostInsetY,
  );
}

void main() {
  const catalog = BundledCatalogDataSource();

  PresetCaptureGuidance guidanceFor(String categoryId, String presetId) =>
      PresetCaptureGuidance.fromPreset(
        catalog.presetById(presetId)!,
        productNoun: _nouns[categoryId]!,
      );

  group('live inspection drives every preset', () {
    for (final entry in _folds.entries) {
      final noun = _nouns[entry.key]!;
      for (final presetId in entry.value) {
        test(presetId, () {
          final guidance = guidanceFor(entry.key, presetId);
          final cloth = SyntheticFrame(grain: grainFor(guidance));
          final frame = filling(guidance);

          // 1. An empty surface: nothing to photograph, named for this
          //    category rather than a generic "product".
          final empty = inspect(
            SyntheticFrame(grain: grainFor(guidance)),
            guidance,
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
          );
          expect(empty.prompt, CapturePrompt.noProduct, reason: presetId);
          expect(empty.message, 'Place the $noun in view');

          // 2. Cloth in the corner, mostly outside the guide.
          final offToOneSide = inspect(
            cloth,
            guidance,
            left: 0.02,
            top: 0.02,
            right: 0.24,
            bottom: 0.22,
          );
          expect(
            offToOneSide.prompt,
            anyOf(
              CapturePrompt.moveIntoFrame,
              CapturePrompt.keepInsideFrame,
              CapturePrompt.moveCloser,
            ),
            reason: presetId,
          );
          expect(offToOneSide.isReadyToShoot, isFalse);

          // 3. Small and centred: in the right place, too far away.
          final tooFar = inspect(
            cloth,
            guidance,
            left: 0.42,
            top: 0.44,
            right: 0.58,
            bottom: 0.56,
          );
          expect(tooFar.prompt, CapturePrompt.moveCloser, reason: presetId);

          // 4. Cloth running off every edge.
          final overflowing = inspect(
            cloth,
            guidance,
            left: 0,
            top: 0,
            right: 1,
            bottom: 1,
          );
          expect(overflowing.isReadyToShoot, isFalse, reason: presetId);
          expect(
            overflowing.message,
            anyOf(
              'Keep the $noun inside the frame',
              'Keep the border inside the frame',
              'Move further from subject',
              'Keep the folds visible',
            ),
            reason: presetId,
          );

          // 5. Filling the guide, evenly lit, held at the preset's angle.
          final good = inspect(
            cloth,
            guidance,
            left: frame.left,
            top: frame.top,
            right: frame.right,
            bottom: frame.bottom,
          );
          expect(good.prompt, CapturePrompt.ready, reason: presetId);
          expect(good.message, 'Ready to capture');
        });
      }
    }
  });

  group('the suggestion follows the product around the frame', () {
    final guidance = PresetCaptureGuidance.fromPreset(
      const BundledCatalogDataSource().presetById('saree_box_fold')!,
      productNoun: 'saree',
    );
    final cloth = SyntheticFrame(grain: grainFor(guidance));
    final frame = filling(guidance);

    test('the same cloth reads differently as it is moved', () {
      final seen = <String>[];
      for (final placement in [
        (left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
        (left: 0.40, top: 0.42, right: 0.56, bottom: 0.54),
        (left: 0.0, top: 0.0, right: 1.0, bottom: 1.0),
        (
          left: frame.left,
          top: frame.top,
          right: frame.right,
          bottom: frame.bottom
        ),
      ]) {
        seen.add(
          inspect(
            cloth,
            guidance,
            left: placement.left,
            top: placement.top,
            right: placement.right,
            bottom: placement.bottom,
          ).message,
        );
      }

      expect(seen.toSet().length, seen.length,
          reason: 'each placement should read differently: $seen');
      expect(seen.first, 'Place the saree in view');
      expect(seen.last, 'Ready to capture');
    });

    test('sliding the cloth off centre brings the centring prompt back', () {
      final width = frame.right - frame.left;
      final centred = inspect(
        cloth,
        guidance,
        left: frame.left,
        top: frame.top,
        right: frame.right,
        bottom: frame.bottom,
      );
      final shifted = inspect(
        cloth,
        guidance,
        left: frame.left + width * 0.55,
        top: frame.top,
        right: frame.right + width * 0.30,
        bottom: frame.bottom,
      );

      expect(centred.prompt, CapturePrompt.ready);
      expect(shifted.isReadyToShoot, isFalse);
    });

    test('a product sitting low in the frame is not called centred', () {
      final feedback = inspect(
        cloth,
        guidance,
        left: frame.left,
        top: 0.62,
        right: frame.right,
        bottom: 0.95,
      );

      expect(feedback.centreQuality, CentreQuality.off);
    });
  });

  group('light and focus are read from the frame', () {
    final guidance = PresetCaptureGuidance.fromPreset(
      const BundledCatalogDataSource().presetById('cushion_flat_lay')!,
      productNoun: 'cushion cover',
    );
    final frame = filling(guidance);

    test('a well-framed shot in a dim room is called out for light', () {
      final feedback = inspect(
        const SyntheticFrame(background: 30, productMid: 40, contrast: 30),
        guidance,
        left: frame.left,
        top: frame.top,
        right: frame.right,
        bottom: frame.bottom,
      );

      expect(feedback.lightQuality, LightQuality.tooDark);
      expect(feedback.prompt, CapturePrompt.tooDark);
    });

    test('a well-framed shot that is merely dim is low light, not ready', () {
      final feedback = inspect(
        const SyntheticFrame(background: 70, productMid: 90, contrast: 35),
        guidance,
        left: frame.left,
        top: frame.top,
        right: frame.right,
        bottom: frame.bottom,
      );

      expect(feedback.lightQuality, LightQuality.low);
      expect(feedback.prompt, CapturePrompt.lowLight);
      expect(feedback.distanceQuality, DistanceQuality.ok);
      expect(feedback.centreQuality, CentreQuality.ok);
    });

    test('a blown-out frame is called out', () {
      final feedback = inspect(
        const SyntheticFrame(background: 252, productMid: 254, contrast: 3),
        guidance,
        left: frame.left,
        top: frame.top,
        right: frame.right,
        bottom: frame.bottom,
      );

      expect(feedback.lightQuality, LightQuality.tooBright);
      expect(feedback.prompt, CapturePrompt.tooBright);
    });

    test('a smeared frame asks the artisan to steady the phone', () {
      final feedback = inspect(
        const SyntheticFrame(defocused: true, noise: 0),
        guidance,
        left: frame.left,
        top: frame.top,
        right: frame.right,
        bottom: frame.bottom,
      );

      expect(feedback.prompt, CapturePrompt.holdSteady);
    });

    test('a small product on a tiled floor is told to move closer', () {
      final feedback = inspect(
        const SyntheticFrame(
          tiledFloor: true,
          background: 175,
          productMid: 80,
          contrast: 40,
        ),
        guidance,
        left: 0.38,
        top: 0.40,
        right: 0.62,
        bottom: 0.60,
      );

      expect(feedback.distanceQuality, DistanceQuality.tooFar);
      expect(feedback.prompt, CapturePrompt.moveCloser);
      expect(feedback.prompt, isNot(CapturePrompt.keepInsideFrame));
    });

    test('filling the dashed box on a tiled floor is not told to move back', () {
      final feedback = inspect(
        const SyntheticFrame(
          tiledFloor: true,
          background: 175,
          productMid: 80,
          contrast: 40,
        ),
        guidance,
        left: frame.left,
        top: frame.top,
        right: frame.right,
        bottom: frame.bottom,
      );

      expect(feedback.distanceQuality, DistanceQuality.ok);
      expect(feedback.prompt, isNot(CapturePrompt.moveFurther));
      expect(feedback.prompt, isNot(CapturePrompt.keepInsideFrame));
    });

    test('a sharp bold weave is not mistaken for a shaky one', () {
      final feedback = inspect(
        const SyntheticFrame(grain: FabricGrain.horizontal, contrast: 70),
        guidance,
        left: frame.left,
        top: frame.top,
        right: frame.right,
        bottom: frame.bottom,
      );

      expect(feedback.prompt, isNot(CapturePrompt.holdSteady));
    });
  });

  group('fabric direction, only where the grid asks for it', () {
    final folded = PresetCaptureGuidance.fromPreset(
      const BundledCatalogDataSource().presetById('shawl_folded_stack')!,
      productNoun: 'shawl',
    );
    final pallu = PresetCaptureGuidance.fromPreset(
      const BundledCatalogDataSource().presetById('saree_pallu_drape')!,
      productNoun: 'saree',
    );

    test('the stacked-folds grid measures a horizontal run', () {
      expect(folded.technique.grid, GridOverlayType.horizontalFolds);
      expect(
        folded.cameraGuidance.orientationTarget,
        EdgeOrientationTarget.horizontal,
      );

      final frame = filling(folded);
      final aligned = inspect(
        const SyntheticFrame(grain: FabricGrain.horizontal),
        folded,
        left: frame.left,
        top: frame.top,
        right: frame.right,
        bottom: frame.bottom,
      );
      final turned = inspect(
        const SyntheticFrame(grain: FabricGrain.vertical),
        folded,
        left: frame.left,
        top: frame.top,
        right: frame.right,
        bottom: frame.bottom,
      );

      expect(aligned.prompt, CapturePrompt.ready);
      expect(turned.prompt, CapturePrompt.alignWithHorizontalGuides);
      expect(turned.message, 'Line the folds up with the horizontal guides');
    });

    test('the leading-lines grid measures a diagonal run', () {
      expect(pallu.technique.grid, GridOverlayType.leadingLines);

      final frame = filling(pallu);
      final aligned = inspect(
        const SyntheticFrame(grain: FabricGrain.diagonal),
        pallu,
        left: frame.left,
        top: frame.top,
        right: frame.right,
        bottom: frame.bottom,
      );
      final flat = inspect(
        const SyntheticFrame(grain: FabricGrain.horizontal),
        pallu,
        left: frame.left,
        top: frame.top,
        right: frame.right,
        bottom: frame.bottom,
      );

      expect(aligned.prompt, CapturePrompt.ready);
      expect(flat.prompt, CapturePrompt.alignWithDiagonalGuides);
    });

    test('a rule-of-thirds preset never invents a direction complaint', () {
      final cushion = PresetCaptureGuidance.fromPreset(
        const BundledCatalogDataSource().presetById('cushion_flat_lay')!,
        productNoun: 'cushion cover',
      );
      expect(
        cushion.cameraGuidance.orientationTarget,
        EdgeOrientationTarget.none,
      );

      final frame = filling(cushion);
      for (final grain in FabricGrain.values) {
        final feedback = inspect(
          SyntheticFrame(grain: grain),
          cushion,
          left: frame.left,
          top: frame.top,
          right: frame.right,
          bottom: frame.bottom,
        );
        expect(
          feedback.prompt,
          isNot(anyOf(
            CapturePrompt.alignWithHorizontalGuides,
            CapturePrompt.alignWithDiagonalGuides,
          )),
          reason: grain.name,
        );
      }
    });

    test('a directionless weave is left alone', () {
      // Nothing in the picture runs one way, so there is no honest correction
      // to make and the fold check must stay quiet.
      final frame = filling(folded);
      final feedback = inspect(
        const SyntheticFrame(grain: FabricGrain.isotropic),
        folded,
        left: frame.left,
        top: frame.top,
        right: frame.right,
        bottom: frame.bottom,
      );

      expect(feedback.prompt, isNot(CapturePrompt.alignWithHorizontalGuides));
    });
  });

  test('presets keep their own grid, tolerances and wording', () {
    final pallu = guidanceFor(BundledCatalogDataSource.saree,
        'saree_pallu_drape');
    final cushion = guidanceFor(
        BundledCatalogDataSource.cushionCover, 'cushion_flat_lay');
    final shawl = guidanceFor(BundledCatalogDataSource.shawl,
        'shawl_folded_stack');
    final stole = guidanceFor(BundledCatalogDataSource.stole,
        'stole_rolled_coil');

    expect(pallu.technique.grid, GridOverlayType.leadingLines);
    expect(cushion.technique.grid, GridOverlayType.ruleOfThirds);
    expect(shawl.technique.grid, GridOverlayType.horizontalFolds);
    expect(stole.technique.grid, GridOverlayType.centerFocus);

    expect(pallu.cameraGuidance.productNoun, 'saree');
    expect(cushion.cameraGuidance.productNoun, 'cushion cover');

    // A close-up asks for more of its (smaller) guide to be filled.
    expect(
      stole.cameraGuidance.minTargetCoverage,
      greaterThan(cushion.cameraGuidance.minTargetCoverage),
    );

    // The placement line the pill shows while nothing is in view is the
    // catalog's own, not invented copy.
    expect(
      pallu.cameraGuidance.placementInstruction,
      const BundledCatalogDataSource()
          .presetById('saree_pallu_drape')!
          .setupSteps
          .first
          .instruction,
    );
  });

  test('no preset claims to judge fabric, sheen or folding quality', () {
    for (final entry in _folds.entries) {
      for (final presetId in entry.value) {
        final guidance = guidanceFor(entry.key, presetId);
        expect(
          guidance.cameraGuidance.undetectableConditions,
          containsAll(CameraGuidanceProfile.universalUndetectables),
          reason: presetId,
        );
      }
    }
  });
}
