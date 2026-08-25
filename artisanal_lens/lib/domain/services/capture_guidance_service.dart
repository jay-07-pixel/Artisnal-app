import 'dart:math' as math;

import '../entities/capture_feedback.dart';
import '../entities/technique_preset.dart';
import 'frame_analyzer.dart';

/// Thresholds governing the live prompts.
///
/// Grouped here rather than scattered through the logic so they can be tuned
/// from field testing without hunting through conditionals.
class CaptureThresholds {
  const CaptureThresholds({
    this.tooDarkBelow = 0.18,
    this.tooBrightAbove = 0.86,
    this.backlightRatioAbove = 1.6,
    this.minSubjectFill = 0.35,
    this.overflowRatioAbove = 0.8,
    this.maxCentringOffset = 0.12,
    this.minCentreDetail = 0.012,
  });

  /// Mean luminance below which the frame counts as too dark.
  final double tooDarkBelow;

  /// Mean luminance above which the frame counts as blown out.
  final double tooBrightAbove;

  /// Border-to-centre brightness ratio that indicates backlighting.
  final double backlightRatioAbove;

  /// Minimum share of the ghost frame the subject should occupy.
  final double minSubjectFill;

  /// Border-to-centre texture ratio above which the subject is overflowing
  /// the guide and is likely being cropped.
  final double overflowRatioAbove;

  /// How far off-centre the subject may sit before it is called out.
  final double maxCentringOffset;

  /// Texture level below which the guide is considered empty.
  final double minCentreDetail;
}

/// Turns raw frame measurements and device tilt into the one prompt worth
/// showing the artisan right now.
///
/// The prompt set and their wording come from BTP §8.2 "Live prompts on
/// camera". Ordering matters: light is checked before framing, because a
/// perfectly framed shot in bad light is still unusable, and user testing found
/// light was the thing artisans got wrong most often.
class CaptureGuidanceService {
  const CaptureGuidanceService({
    this.thresholds = const CaptureThresholds(),
  });

  final CaptureThresholds thresholds;

  CaptureFeedback evaluate({
    required FrameMetrics metrics,
    required TechniquePreset technique,
    required double pitchDegrees,
  }) {
    final lightQuality = _lightQuality(metrics);
    final angleQuality = _angleQuality(technique.angle, pitchDegrees);

    return CaptureFeedback(
      lightQuality: lightQuality,
      angleQuality: angleQuality,
      prompt: _prompt(
        metrics: metrics,
        technique: technique,
        lightQuality: lightQuality,
        angleQuality: angleQuality,
      ),
      meanLuminance: metrics.meanLuminance,
      pitchDegrees: pitchDegrees,
      subjectFillRatio: metrics.subjectFillRatio,
    );
  }

  LightQuality _lightQuality(FrameMetrics metrics) {
    if (metrics.meanLuminance < thresholds.tooDarkBelow) {
      return LightQuality.tooDark;
    }
    if (metrics.meanLuminance > thresholds.tooBrightAbove) {
      return LightQuality.tooBright;
    }
    return LightQuality.good;
  }

  AngleQuality _angleQuality(CameraAngle angle, double pitchDegrees) {
    final drift = (pitchDegrees - angle.targetPitchDegrees).abs();
    return drift <= angle.pitchToleranceDegrees
        ? AngleQuality.ok
        : AngleQuality.off;
  }

  CapturePrompt _prompt({
    required FrameMetrics metrics,
    required TechniquePreset technique,
    required LightQuality lightQuality,
    required AngleQuality angleQuality,
  }) {
    // 1. Light first — nothing else can rescue an unusable exposure.
    if (lightQuality == LightQuality.tooDark) return CapturePrompt.tooDark;
    if (lightQuality == LightQuality.tooBright) return CapturePrompt.tooBright;

    // 2. Backlighting, unless the preset deliberately asks for it (sheer
    //    fabrics are shot against the light on purpose).
    if (!technique.lighting.expectsBacklight &&
        metrics.backlightRatio > thresholds.backlightRatioAbove) {
      return CapturePrompt.backlightDetected;
    }

    // 3. Angle, which the artisan fixes by tilting rather than moving.
    if (angleQuality == AngleQuality.off) return CapturePrompt.tiltPhone;

    // 4. Distance. Order matters here: an overflowing subject makes the
    //    border as textured as the centre, which drags subjectFillRatio down
    //    to the same low value an empty guide produces. The two are told apart
    //    by absolute centre texture, so that check has to come first.
    if (metrics.centreDetail < thresholds.minCentreDetail) {
      // Nothing of substance inside the guide at all.
      return CapturePrompt.moveCloser;
    }
    if (metrics.overflowRatio > thresholds.overflowRatioAbove) {
      // Subject is present and spilling past the guide — it is being cropped.
      return CapturePrompt.moveFurther;
    }
    if (metrics.subjectFillRatio < thresholds.minSubjectFill) {
      // Present and contained, but sitting too small inside the guide.
      return CapturePrompt.moveCloser;
    }

    // 5. Centring.
    if (metrics.centringOffset > thresholds.maxCentringOffset) {
      return CapturePrompt.centerSubject;
    }

    return CapturePrompt.ready;
  }

  /// Converts raw accelerometer values into pitch in degrees from vertical.
  ///
  /// 0° is an upright phone; 90° is the phone lying flat, pointing at the
  /// floor — the position the overhead flat-lay preset asks for.
  static double pitchFromAccelerometer({
    required double x,
    required double y,
    required double z,
  }) {
    final horizontal = math.sqrt(x * x + y * y);
    if (horizontal == 0 && z == 0) return 0;
    return math.atan2(z, horizontal) * 180 / math.pi;
  }
}
