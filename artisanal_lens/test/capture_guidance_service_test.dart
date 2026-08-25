import 'dart:typed_data';

import 'package:artisanal_lens/domain/entities/capture_feedback.dart';
import 'package:artisanal_lens/domain/entities/photography_guideline.dart';
import 'package:artisanal_lens/domain/entities/technique_preset.dart';
import 'package:artisanal_lens/domain/services/capture_guidance_service.dart';
import 'package:artisanal_lens/domain/services/frame_analyzer.dart';
import 'package:flutter_test/flutter_test.dart';

/// A well-framed, evenly lit subject filling the guide.
const _wellFramed = FrameMetrics(
  meanLuminance: 0.5,
  centreLuminance: 0.5,
  borderLuminance: 0.5,
  centreDetail: 0.08,
  borderDetail: 0.015,
  detailCentroidX: 0.5,
  detailCentroidY: 0.5,
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
    FrameMetrics metrics, {
    TechniquePreset technique = _eyeLevelPreset,
    double pitch = 0,
  }) =>
      service.evaluate(
        metrics: metrics,
        technique: technique,
        pitchDegrees: pitch,
      );

  group('CaptureGuidanceService prompt priority', () {
    test('reports Ready when light, angle and framing are all good', () {
      final feedback = evaluate(_wellFramed);

      expect(feedback.prompt, CapturePrompt.ready);
      expect(feedback.isReadyToShoot, isTrue);
      expect(feedback.lightQuality, LightQuality.good);
      expect(feedback.angleQuality, AngleQuality.ok);
    });

    test('darkness outranks every framing problem', () {
      // Badly framed AND dark — the artisan is told about the light first,
      // because framing cannot rescue an unusable exposure.
      const darkAndOffCentre = FrameMetrics(
        meanLuminance: 0.08,
        centreLuminance: 0.08,
        borderLuminance: 0.08,
        centreDetail: 0.002,
        borderDetail: 0.001,
        detailCentroidX: 0.9,
        detailCentroidY: 0.5,
      );

      expect(evaluate(darkAndOffCentre).prompt, CapturePrompt.tooDark);
      expect(evaluate(darkAndOffCentre).lightQuality, LightQuality.tooDark);
    });

    test('flags an overexposed frame', () {
      const blownOut = FrameMetrics(
        meanLuminance: 0.95,
        centreLuminance: 0.95,
        borderLuminance: 0.95,
        centreDetail: 0.08,
        borderDetail: 0.015,
        detailCentroidX: 0.5,
        detailCentroidY: 0.5,
      );

      expect(evaluate(blownOut).prompt, CapturePrompt.tooBright);
      expect(evaluate(blownOut).lightQuality, LightQuality.tooBright);
    });
  });

  group('backlight handling', () {
    const backlit = FrameMetrics(
      meanLuminance: 0.5,
      centreLuminance: 0.25,
      borderLuminance: 0.75,
      centreDetail: 0.08,
      borderDetail: 0.015,
      detailCentroidX: 0.5,
      detailCentroidY: 0.5,
    );

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

  group('framing prompts', () {
    test('asks the artisan to move closer when the guide is empty', () {
      const emptyGuide = FrameMetrics(
        meanLuminance: 0.5,
        centreLuminance: 0.5,
        borderLuminance: 0.5,
        centreDetail: 0.003,
        borderDetail: 0.002,
        detailCentroidX: 0.5,
        detailCentroidY: 0.5,
      );

      expect(evaluate(emptyGuide).prompt, CapturePrompt.moveCloser);
    });

    test('asks the artisan to back off when the subject overflows', () {
      const overflowing = FrameMetrics(
        meanLuminance: 0.5,
        centreLuminance: 0.5,
        borderLuminance: 0.5,
        centreDetail: 0.09,
        borderDetail: 0.085,
        detailCentroidX: 0.5,
        detailCentroidY: 0.5,
      );

      expect(evaluate(overflowing).prompt, CapturePrompt.moveFurther);
    });

    test('asks for centring when the subject sits to one side', () {
      const offCentre = FrameMetrics(
        meanLuminance: 0.5,
        centreLuminance: 0.5,
        borderLuminance: 0.5,
        centreDetail: 0.08,
        borderDetail: 0.015,
        detailCentroidX: 0.78,
        detailCentroidY: 0.5,
      );

      expect(evaluate(offCentre).prompt, CapturePrompt.centerSubject);
    });
  });

  group('angle guidance', () {
    test('accepts an upright phone for an eye-level preset', () {
      expect(evaluate(_wellFramed, pitch: 5).angleQuality, AngleQuality.ok);
    });

    test('rejects an upright phone for an overhead flat-lay preset', () {
      const overhead = TechniquePreset(
        angle: CameraAngle.overheadFlatLay,
        lighting: LightingSetup.diffusedDaylight,
        composition: CompositionRule.centeredProduct,
        grid: GridOverlayType.ruleOfThirds,
      );

      final feedback = evaluate(_wellFramed, technique: overhead, pitch: 0);

      expect(feedback.angleQuality, AngleQuality.off);
      expect(feedback.prompt, CapturePrompt.tiltPhone);
    });

    test('accepts a phone pointing down for an overhead preset', () {
      const overhead = TechniquePreset(
        angle: CameraAngle.overheadFlatLay,
        lighting: LightingSetup.diffusedDaylight,
        composition: CompositionRule.centeredProduct,
        grid: GridOverlayType.ruleOfThirds,
      );

      final feedback = evaluate(_wellFramed, technique: overhead, pitch: 88);

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

    test('measures a uniformly mid-grey frame as mid luminance, no detail', () {
      const width = 160;
      const height = 120;
      final luma = Uint8List(width * height)..fillRange(0, width * height, 128);

      final metrics = analyzer.analyseLumaPlane(
        luma: luma,
        width: width,
        height: height,
        bytesPerRow: width,
      );

      expect(metrics.meanLuminance, closeTo(0.502, 0.01));
      expect(metrics.centreDetail, closeTo(0, 0.001));
      expect(metrics.subjectFillRatio, 0);
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

      final metrics = analyzer.analyseLumaPlane(
        luma: luma,
        width: width,
        height: height,
        bytesPerRow: width,
      );

      expect(metrics.centreLuminance, lessThan(metrics.borderLuminance));
      expect(metrics.backlightRatio, greaterThan(1.6));
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

      final metrics = analyzer.analyseLumaPlane(
        luma: luma,
        width: width,
        height: height,
        bytesPerRow: bytesPerRow,
      );

      expect(metrics.meanLuminance, closeTo(200 / 255, 0.01));
    });

    test('returns neutral metrics for an empty plane', () {
      final metrics = analyzer.analyseLumaPlane(
        luma: Uint8List(0),
        width: 0,
        height: 0,
        bytesPerRow: 0,
      );

      expect(metrics, const FrameMetrics.empty());
    });
  });
}
