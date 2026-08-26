import 'dart:typed_data';

import 'package:artisanal_lens/domain/entities/capture_feedback.dart';
import 'package:artisanal_lens/domain/entities/photography_guideline.dart';
import 'package:artisanal_lens/domain/entities/preset_capture_guidance.dart';
import 'package:artisanal_lens/domain/entities/technique_preset.dart';
import 'package:artisanal_lens/domain/services/capture_guidance_service.dart';
import 'package:artisanal_lens/domain/services/frame_analyzer.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/synthetic_frame.dart';

/// Builds a measurement set, defaulting to a well-framed, evenly lit subject
/// filling the guide, so each test only has to state what it is changing.
FrameMetrics metrics({
  double meanLuminance = 0.5,
  double centreLuminance = 0.5,
  double borderLuminance = 0.5,
  double centreDetail = 0.08,
  double borderDetail = 0.015,
  double detailCentroidX = 0.5,
  double detailCentroidY = 0.5,
  double clippedHighlights = 0,
  double clippedShadows = 0,
  double fineDetail = 0.05,
  double focusRatio = 0.5,
  double subjectCoverage = 0.4,
  double targetCoverage = 0.9,
  double subjectEdgeContact = 0,
  double subjectLeft = 0.2,
  double subjectTop = 0.2,
  double subjectRight = 0.8,
  double subjectBottom = 0.8,
  double edgeAngleDegrees = 0,
  double edgeCoherence = 0,
  double targetArea = 0.36,
}) =>
    FrameMetrics(
      meanLuminance: meanLuminance,
      centreLuminance: centreLuminance,
      borderLuminance: borderLuminance,
      centreDetail: centreDetail,
      borderDetail: borderDetail,
      detailCentroidX: detailCentroidX,
      detailCentroidY: detailCentroidY,
      clippedHighlights: clippedHighlights,
      clippedShadows: clippedShadows,
      fineDetail: fineDetail,
      focusRatio: focusRatio,
      subjectCoverage: subjectCoverage,
      targetCoverage: targetCoverage,
      subjectEdgeContact: subjectEdgeContact,
      subjectLeft: subjectLeft,
      subjectTop: subjectTop,
      subjectRight: subjectRight,
      subjectBottom: subjectBottom,
      edgeAngleDegrees: edgeAngleDegrees,
      edgeCoherence: edgeCoherence,
      targetArea: targetArea,
    );

const _eyeLevelPreset = TechniquePreset(
  angle: CameraAngle.eyeLevel,
  lighting: LightingSetup.softWindowLight,
  composition: CompositionRule.ruleOfThirds,
  grid: GridOverlayType.ruleOfThirds,
  guidelines: [PhotographyGuideline.closeUpShots],
);

const _sheerPreset = TechniquePreset(
  angle: CameraAngle.eyeLevel,
  lighting: LightingSetup.backlightForSheer,
  composition: CompositionRule.centeredProduct,
  grid: GridOverlayType.centerFocus,
  guidelines: [PhotographyGuideline.diverseLighting],
);

void main() {
  const service = CaptureGuidanceService();

  CaptureFeedback evaluate(
    FrameMetrics measured, {
    TechniquePreset technique = _eyeLevelPreset,
    double pitch = 0,
    String productNoun = 'saree',
  }) =>
      service.evaluate(
        metrics: measured,
        technique: technique,
        pitchDegrees: pitch,
        profile: CameraGuidanceProfile.fromTechnique(
          technique,
          productNoun: productNoun,
        ),
      );

  group('prompt priority', () {
    test('reports ready when every measurable check passes', () {
      final feedback = evaluate(metrics());

      expect(feedback.prompt, CapturePrompt.ready);
      expect(feedback.message, 'Ready to capture');
      expect(feedback.isReadyToShoot, isTrue);
      expect(feedback.lightQuality, LightQuality.good);
      expect(feedback.angleQuality, AngleQuality.ok);
    });

    test('initial camera state is not ready', () {
      const initial = CaptureFeedback.initial();
      expect(initial.prompt, CapturePrompt.waiting);
      expect(initial.isReadyToShoot, isFalse);
      expect(initial.hasVisiblePrompt, isFalse);
    });

    test('an empty frame is reported before anything else', () {
      // Nothing in view and the light is poor: there is no point discussing
      // the exposure of a picture with no product in it.
      final feedback = evaluate(
        metrics(subjectCoverage: 0, targetCoverage: 0, centreDetail: 0.001),
      );

      expect(feedback.prompt, CapturePrompt.noProduct);
      expect(feedback.message, 'Place the saree in view');
    });

    test('a product outside the guide outranks a lighting problem', () {
      final feedback = evaluate(
        metrics(
          subjectCoverage: 0.30,
          targetCoverage: 0.05,
          meanLuminance: 0.92,
          clippedHighlights: 0.4,
        ),
      );

      expect(feedback.prompt, CapturePrompt.moveIntoFrame);
      expect(feedback.message, 'Move the saree into the frame');
      // The light was still measured, it just is not the headline.
      expect(feedback.lightQuality, LightQuality.tooBright);
    });

    test('a product running off the edge outranks size and light', () {
      final feedback = evaluate(
        metrics(subjectEdgeContact: 0.6, meanLuminance: 0.05),
      );

      expect(feedback.prompt, CapturePrompt.keepInsideFrame);
      expect(feedback.message, 'Keep the saree inside the frame');
    });

    test('size outranks light', () {
      // A small product, but squarely in the guide: the problem is distance.
      final feedback = evaluate(
        metrics(
          subjectCoverage: 0.03,
          targetCoverage: 0.08,
          meanLuminance: 0.1,
        ),
      );

      expect(feedback.prompt, CapturePrompt.moveCloser);
    });

    test('light outranks blur and centring', () {
      final feedback = evaluate(
        metrics(
          meanLuminance: 0.08,
          focusRatio: 0.01,
          fineDetail: 0.001,
          detailCentroidX: 0.85,
        ),
      );

      expect(feedback.prompt, CapturePrompt.tooDark);
      expect(feedback.lightQuality, LightQuality.tooDark);
    });

    test('blur outranks centring', () {
      final feedback = evaluate(
        metrics(focusRatio: 0.02, fineDetail: 0.002, detailCentroidX: 0.85),
      );

      expect(feedback.prompt, CapturePrompt.holdSteady);
    });

    test('centring is the last thing left to say', () {
      final feedback = evaluate(metrics(detailCentroidX: 0.78));

      expect(feedback.prompt, CapturePrompt.centerSubject);
      expect(feedback.message, 'Center the saree');
    });

    test('clipped highlights count as overexposure', () {
      final feedback = evaluate(
        metrics(meanLuminance: 0.7, clippedHighlights: 0.3),
      );

      expect(feedback.lightQuality, LightQuality.tooBright);
      expect(feedback.prompt, CapturePrompt.tooBright);
    });
  });

  group('backlight handling', () {
    final backlit = metrics(centreLuminance: 0.25, borderLuminance: 0.75);

    test('warns when light comes from behind the fabric', () {
      expect(evaluate(backlit).prompt, CapturePrompt.backlightDetected);
    });

    test('stays silent for sheer presets that want backlighting', () {
      // BTP §7.2: transparency is shown by holding fabric against a light
      // source, so the same frame must not be treated as an error here.
      final feedback = evaluate(backlit, technique: _sheerPreset);

      expect(feedback.prompt, isNot(CapturePrompt.backlightDetected));
      expect(feedback.prompt, CapturePrompt.ready);
    });
  });

  group('framing wording follows the preset', () {
    test('asks the artisan to move closer when the guide is under-filled', () {
      expect(
        evaluate(
          metrics(
            subjectCoverage: 0.03,
            targetCoverage: 0.1,
            centreDetail: 0.02,
            borderDetail: 0.004,
          ),
        ).prompt,
        CapturePrompt.moveCloser,
      );
    });

    test('asks the artisan to back off when the subject overflows', () {
      expect(
        evaluate(metrics(centreDetail: 0.09, borderDetail: 0.085)).prompt,
        CapturePrompt.moveFurther,
      );
    });

    test('centre-focus presets keep the texture in the centre', () {
      const texture = TechniquePreset(
        angle: CameraAngle.macroCloseUp,
        lighting: LightingSetup.softWindowLight,
        composition: CompositionRule.centerFocus,
        grid: GridOverlayType.centerFocus,
      );

      expect(
        evaluate(metrics(detailCentroidX: 0.78), technique: texture, pitch: 45)
            .prompt,
        CapturePrompt.keepTextureInCentre,
      );
    });

    test('detail-frame overflow asks to keep the border inside the frame', () {
      const border = TechniquePreset(
        angle: CameraAngle.macroCloseUp,
        lighting: LightingSetup.softWindowLight,
        composition: CompositionRule.detailFrame,
        grid: GridOverlayType.detailFrame,
      );

      expect(
        evaluate(
          metrics(centreDetail: 0.09, borderDetail: 0.085),
          technique: border,
          pitch: 45,
        ).prompt,
        CapturePrompt.keepBorderInsideFrame,
      );
    });

    test('horizontal-fold overflow asks to keep the folds visible', () {
      const stack = TechniquePreset(
        angle: CameraAngle.eyeLevel,
        lighting: LightingSetup.softWindowLight,
        composition: CompositionRule.negativeSpaceAroundFolds,
        grid: GridOverlayType.horizontalFolds,
      );

      expect(
        evaluate(metrics(centreDetail: 0.09, borderDetail: 0.085),
                technique: stack)
            .prompt,
        CapturePrompt.keepFoldsVisible,
      );
    });
  });

  group('fabric direction', () {
    const stack = TechniquePreset(
      angle: CameraAngle.eyeLevel,
      lighting: LightingSetup.softWindowLight,
      composition: CompositionRule.negativeSpaceAroundFolds,
      grid: GridOverlayType.horizontalFolds,
    );

    test('is corrected when the frame clearly runs the wrong way', () {
      expect(
        evaluate(metrics(edgeAngleDegrees: 80, edgeCoherence: 0.7),
                technique: stack)
            .prompt,
        CapturePrompt.alignWithHorizontalGuides,
      );
    });

    test('is left alone when the frame has no dominant direction', () {
      expect(
        evaluate(metrics(edgeAngleDegrees: 80, edgeCoherence: 0.05),
                technique: stack)
            .prompt,
        CapturePrompt.ready,
      );
    });

    test('is never raised for a grid that does not ask for one', () {
      expect(
        evaluate(metrics(edgeAngleDegrees: 80, edgeCoherence: 0.9)).prompt,
        CapturePrompt.ready,
      );
    });
  });

  group('angle guidance', () {
    const overhead = TechniquePreset(
      angle: CameraAngle.overheadFlatLay,
      lighting: LightingSetup.diffusedDaylight,
      composition: CompositionRule.centeredProduct,
      grid: GridOverlayType.ruleOfThirds,
    );

    test('accepts an upright phone for an eye-level preset', () {
      expect(evaluate(metrics(), pitch: 5).angleQuality, AngleQuality.ok);
    });

    test('rejects an upright phone for an overhead flat-lay preset', () {
      final feedback = evaluate(metrics(), technique: overhead, pitch: 0);

      expect(feedback.angleQuality, AngleQuality.off);
      expect(feedback.prompt, CapturePrompt.tiltPhone);
    });

    test('accepts a phone pointing down for an overhead preset', () {
      final feedback = evaluate(metrics(), technique: overhead, pitch: 88);

      expect(feedback.angleQuality, AngleQuality.ok);
      expect(feedback.prompt, CapturePrompt.ready);
    });
  });

  group('pitchFromAccelerometer', () {
    test('reads an upright phone as roughly 0 degrees', () {
      // Gravity along -Y: the phone is held vertically.
      final pitch = CaptureGuidanceService.pitchFromAccelerometer(
        x: 0,
        y: -9.8,
        z: 0,
      );

      expect(pitch.abs(), lessThan(1));
    });

    test('reads a phone lying flat as roughly 90 degrees', () {
      // Gravity along Z: the phone is face-up, camera pointing down.
      final pitch = CaptureGuidanceService.pitchFromAccelerometer(
        x: 0,
        y: 0,
        z: 9.8,
      );

      expect(pitch, closeTo(90, 1));
    });
  });

  group('FrameAnalyzer', () {
    const analyzer = FrameAnalyzer();

    FrameMetrics analyse(Uint8List luma, {int width = 640, int height = 480}) =>
        analyzer.analyseLumaPlane(
          luma: luma,
          width: width,
          height: height,
          bytesPerRow: width,
        );

    test('measures a uniformly mid-grey frame as mid luminance, no detail', () {
      const width = 160;
      const height = 120;
      final luma = Uint8List(width * height)..fillRange(0, width * height, 128);

      final measured = analyse(luma, width: width, height: height);

      expect(measured.meanLuminance, closeTo(0.502, 0.01));
      expect(measured.centreDetail, closeTo(0, 0.001));
      expect(measured.subjectFillRatio, 0);
      expect(measured.subjectCoverage, 0);
    });

    test('detects a bright border around a dark centre as backlighting', () {
      const width = 160;
      const height = 120;
      final luma = Uint8List(width * height);
      for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
          final inCentre = x > width * 0.2 &&
              x < width * 0.8 &&
              y > height * 0.2 &&
              y < height * 0.8;
          luma[y * width + x] = inCentre ? 40 : 220;
        }
      }

      final measured = analyse(luma, width: width, height: height);

      expect(measured.centreLuminance, lessThan(measured.borderLuminance));
      expect(measured.backlightRatio, greaterThan(1.6));
    });

    test('handles row stride padding without skewing the reading', () {
      const width = 100;
      const height = 80;
      const bytesPerRow = 128; // padded stride
      final luma = Uint8List(bytesPerRow * height);
      for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
          luma[y * bytesPerRow + x] = 200;
        }
        // Padding bytes stay 0 and must be excluded from the measurement.
      }

      final measured = analyzer.analyseLumaPlane(
        luma: luma,
        width: width,
        height: height,
        bytesPerRow: bytesPerRow,
      );

      expect(measured.meanLuminance, closeTo(200 / 255, 0.01));
    });

    test('returns neutral metrics for an empty plane', () {
      final measured = analyzer.analyseLumaPlane(
        luma: Uint8List(0),
        width: 0,
        height: 0,
        bytesPerRow: 0,
      );

      expect(measured, const FrameMetrics.empty());
    });

    test('finds the product and its bounding box', () {
      const frame = SyntheticFrame();
      final measured = analyse(
        frame.build(left: 0.25, top: 0.3, right: 0.75, bottom: 0.7),
      );

      expect(measured.subjectCoverage, greaterThan(0.1));
      expect(measured.subjectLeft, closeTo(0.25, 0.08));
      expect(measured.subjectRight, closeTo(0.75, 0.08));
      expect(measured.subjectTop, closeTo(0.3, 0.08));
      expect(measured.subjectBottom, closeTo(0.7, 0.08));
      expect(measured.subjectEdgeContact, 0);
    });

    test('sees a product that runs off the edge of the picture', () {
      const frame = SyntheticFrame();
      final measured = analyse(
        frame.build(left: 0, top: 0, right: 1, bottom: 1),
      );

      expect(measured.subjectEdgeContact, greaterThan(0.9));
    });

    test('reads an empty surface as holding no product', () {
      const frame = SyntheticFrame();
      final measured = analyse(
        frame.build(left: 0, top: 0, right: 0, bottom: 0),
      );

      expect(measured.subjectCoverage, lessThan(0.012));
    });

    test('reads the direction the weave runs in', () {
      const frame = SyntheticFrame(grain: FabricGrain.horizontal);
      final measured = analyse(frame.build());

      expect(measured.edgeAngleDegrees.abs(), lessThan(15));
      expect(measured.edgeCoherence, greaterThan(0.3));
    });

    test('reports no direction for a plain weave', () {
      const frame = SyntheticFrame(grain: FabricGrain.isotropic);
      final measured = analyse(frame.build());

      expect(measured.edgeCoherence, lessThan(0.3));
    });

    test('separates a smeared frame from a sharp one', () {
      const sharp = SyntheticFrame(grain: FabricGrain.horizontal);
      const smeared = SyntheticFrame(defocused: true, noise: 0);

      expect(analyse(sharp.build()).focusRatio, greaterThan(0.1));
      expect(analyse(smeared.build()).focusRatio, lessThan(0.1));
    });

    test('sees blown highlights the average brightness hides', () {
      const width = 160;
      const height = 120;
      final luma = Uint8List(width * height);
      for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
          // A third of the frame is pinned at white, the rest is dark.
          luma[y * width + x] = x < width / 3 ? 255 : 60;
        }
      }

      final measured = analyse(luma, width: width, height: height);

      expect(measured.meanLuminance, lessThan(0.6));
      expect(measured.clippedHighlights, greaterThan(0.25));
    });
  });
}
