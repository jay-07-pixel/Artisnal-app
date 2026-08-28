import 'dart:math' as math;

import '../entities/capture_feedback.dart';
import '../entities/preset_capture_guidance.dart';
import '../entities/technique_preset.dart';
import 'frame_analyzer.dart';

/// Thresholds governing the live prompts.
///
/// Grouped here rather than scattered through the logic so they can be tuned
/// from field testing without hunting through conditionals.
class CaptureThresholds {
  const CaptureThresholds({
    this.tooDarkBelow = 0.24,
    this.lowLightBelow = 0.40,
    this.tooBrightAbove = 0.82,
    this.clippedHighlightsAbove = 0.14,
    this.backlightRatioAbove = 1.6,
    this.minSubjectFill = 0.32,
    this.overflowRatioAbove = 0.80,
    this.maxCentringOffset = 0.10,
    this.minCentreDetail = 0.012,
    this.minSubjectCoverage = 0.012,
    this.minSubjectInsideRatio = 0.45,
    this.maxEdgeContact = 0.34,
    this.blurredBelow = 0.10,
    this.blurredFineDetailBelow = 0.015,
    this.minOrientationCoherence = 0.30,
  });

  /// Mean luminance below which the frame counts as too dark.
  final double tooDarkBelow;

  /// Mean luminance below which the frame is usable but dim — artisans
  /// should still be told to move toward a window.
  final double lowLightBelow;

  /// Mean luminance above which the frame counts as blown out.
  final double tooBrightAbove;

  /// Share of pinned-white pixels above which highlights are being lost even
  /// though the average still looks reasonable.
  final double clippedHighlightsAbove;

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

  /// Share of the frame that must look product-like before the analyser will
  /// say anything is there at all. Small, because a product across the room
  /// is still a product — it just needs "move closer" rather than "place the
  /// saree in view".
  final double minSubjectCoverage;

  /// Share of the subject that must be inside the guide before the problem is
  /// treated as size rather than position.
  final double minSubjectInsideRatio;

  /// Share of the frame's outer ring the product may cover before it counts
  /// as running off the edge of the picture.
  final double maxEdgeContact;

  /// Focus ratio below which the frame is treated as smeared.
  ///
  /// Deliberately low: a false "Hold the phone steady" on a soft fabric is
  /// worse than missing a mildly shaky frame.
  final double blurredBelow;

  /// ...and the fine detail must also have all but vanished. A bold, large
  /// pattern can score a low ratio while still being perfectly sharp, so both
  /// conditions have to hold before the artisan is told to steady the phone.
  final double blurredFineDetailBelow;

  /// Directional agreement needed before the fabric-direction check will
  /// speak. Random weave has no direction and must not be corrected.
  final double minOrientationCoherence;
}

/// Turns the measurements from the current frame into the one prompt worth
/// showing the artisan right now.
///
/// Every branch here is driven by something measured in [FrameMetrics]; the
/// preset only decides which checks apply, how tight they are, and what the
/// resulting prompt is called. Nothing is emitted on a timer, and no check
/// runs unless the profile says the analyser can actually perform it.
///
/// The order is the documented triage order: an artisan cannot act on
/// "improve the light" while the product is still out of shot.
///
///  1. nothing product-like in view
///  2. product in view but outside the guide, or running off the edge
///  3. product too small or too large
///  4. fabric direction against the grid, where measurable
///  5. light
///  6. blur
///  7. centring
///  8. ready
class CaptureGuidanceService {
  const CaptureGuidanceService({
    this.thresholds = const CaptureThresholds(),
  });

  final CaptureThresholds thresholds;

  CaptureFeedback evaluate({
    required FrameMetrics metrics,
    required TechniquePreset technique,
    required double pitchDegrees,
    CameraGuidanceProfile? profile,
    DistanceQuality previousDistance = DistanceQuality.unknown,
    CentreQuality previousCentre = CentreQuality.unknown,
  }) {
    final checks = profile ?? CameraGuidanceProfile.fromTechnique(technique);
    final active = _thresholdsFor(checks);
    final lightQuality = _lightQuality(metrics, active);
    final angleQuality = _angleQuality(technique.angle, pitchDegrees);
    final distanceQuality = _distanceQuality(
      metrics,
      checks,
      active,
      previousDistance,
    );
    final centreQuality = _centreQuality(
      metrics,
      checks,
      active,
      previousCentre,
    );

    return CaptureFeedback(
      lightQuality: lightQuality,
      angleQuality: angleQuality,
      prompt: _prompt(
        metrics: metrics,
        checks: checks,
        thresholds: active,
        lightQuality: lightQuality,
        angleQuality: angleQuality,
        previousDistance: previousDistance,
        previousCentre: previousCentre,
      ),
      meanLuminance: metrics.meanLuminance,
      pitchDegrees: pitchDegrees,
      subjectFillRatio: metrics.subjectFillRatio,
      distanceQuality: distanceQuality,
      centreQuality: centreQuality,
      productNoun: checks.productNoun,
    );
  }

  /// Applies the preset's own tolerances on top of the defaults.
  CaptureThresholds _thresholdsFor(CameraGuidanceProfile checks) {
    return CaptureThresholds(
      tooDarkBelow: thresholds.tooDarkBelow,
      lowLightBelow: thresholds.lowLightBelow,
      tooBrightAbove: thresholds.tooBrightAbove,
      clippedHighlightsAbove: thresholds.clippedHighlightsAbove,
      backlightRatioAbove: thresholds.backlightRatioAbove,
      minSubjectFill: math.max(thresholds.minSubjectFill, 0),
      overflowRatioAbove: thresholds.overflowRatioAbove,
      maxCentringOffset: checks.maxCentringOffset,
      minCentreDetail: thresholds.minCentreDetail,
      minSubjectCoverage: thresholds.minSubjectCoverage,
      minSubjectInsideRatio: thresholds.minSubjectInsideRatio,
      maxEdgeContact: thresholds.maxEdgeContact,
      blurredBelow: thresholds.blurredBelow,
      blurredFineDetailBelow: thresholds.blurredFineDetailBelow,
      minOrientationCoherence: thresholds.minOrientationCoherence,
    );
  }

  LightQuality _lightQuality(FrameMetrics metrics, CaptureThresholds active) {
    if (metrics.meanLuminance < active.tooDarkBelow) {
      return LightQuality.tooDark;
    }
    if (metrics.meanLuminance > active.tooBrightAbove ||
        metrics.clippedHighlights > active.clippedHighlightsAbove) {
      return LightQuality.tooBright;
    }
    if (metrics.meanLuminance < active.lowLightBelow) {
      return LightQuality.low;
    }
    return LightQuality.good;
  }

  DistanceQuality _distanceQuality(
    FrameMetrics metrics,
    CameraGuidanceProfile checks,
    CaptureThresholds thresholds,
    DistanceQuality previous,
  ) {
    if (metrics.subjectCoverage < thresholds.minSubjectCoverage) {
      return DistanceQuality.unknown;
    }
    // Full-product shot with cloth covering the whole picture — too close.
    // (Close-ups are allowed to fill the frame; empty tiled floors lack the
    // matching border texture and fall through to the floor swallow below.)
    if (_isWallToWallProduct(metrics, checks)) {
      return DistanceQuality.tooClose;
    }
    // A blob that is the whole picture without wall-to-wall fabric texture
    // is usually the floor, not a measured close-up.
    if (_isWholePictureBlob(metrics)) {
      return DistanceQuality.ok;
    }
    // Product spilling past the dashed guide is too close — check before
    // silencing Distance for edge placement, or a cropped cushion stays OK.
    if (_isOverflowing(metrics, checks, thresholds)) {
      return DistanceQuality.tooClose;
    }
    // Off the picture edge is a placement problem — the Distance chip
    // stays quiet so it does not fight "keep inside the frame".
    if (metrics.subjectEdgeContact > thresholds.maxEdgeContact &&
        !metrics.boxFitsInsideGhost) {
      return DistanceQuality.ok;
    }
    if (checks.detectsSubjectFill &&
        _isUnderFilled(metrics, checks, previous)) {
      return DistanceQuality.tooFar;
    }
    return DistanceQuality.ok;
  }

  bool _isWholePictureBlob(FrameMetrics metrics) {
    return metrics.subjectLeft <= 0.005 &&
        metrics.subjectTop <= 0.005 &&
        metrics.subjectRight >= 0.995 &&
        metrics.subjectBottom >= 0.995;
  }

  /// Cloth fills the picture edge-to-edge — the artisan is too close for a
  /// full-product shot.
  ///
  /// Needs matching texture in the margin so a busy floor that occupancy
  /// swallowed (high coverage, quiet border detail) is not told to move back.
  bool _isWallToWallProduct(
    FrameMetrics metrics,
    CameraGuidanceProfile checks,
  ) {
    if (checks.isCloseUp || !checks.detectsOverflow) return false;
    if (metrics.centreDetail < 0.03) return false;
    final borderShare = metrics.borderDetail / metrics.centreDetail;
    if (borderShare < 0.45) return false;
    if (_isWholePictureBlob(metrics)) return true;
    // Cropped on opposite picture edges while filling the guide.
    if (metrics.touchesOppositePictureEdges &&
        metrics.boxFillOfGhost > 0.55) {
      return true;
    }
    // Nearly full frame with fabric continuing past the ghost.
    return metrics.subjectEdgeContact > 0.40 &&
        metrics.boxFillOfGhost > 0.70 &&
        metrics.boxOverflowsGhost;
  }

  CentreQuality _centreQuality(
    FrameMetrics metrics,
    CameraGuidanceProfile checks,
    CaptureThresholds thresholds,
    CentreQuality previous,
  ) {
    if (metrics.subjectCoverage < thresholds.minSubjectCoverage) {
      return CentreQuality.unknown;
    }
    final offset = _centringOffset(metrics, checks);
    final max = thresholds.maxCentringOffset;
    // Hysteresis: a 1–2 cm wobble must not flip Centre every tick.
    if (previous == CentreQuality.off) {
      return offset > max - 0.04 ? CentreQuality.off : CentreQuality.ok;
    }
    if (previous == CentreQuality.ok) {
      return offset > max + 0.04 ? CentreQuality.off : CentreQuality.ok;
    }
    return offset > max ? CentreQuality.off : CentreQuality.ok;
  }

  /// Full-product shots follow the cloth's box. Close-ups follow the weave
  /// in the middle of the ghost, which is the thing those grids ask for.
  double _centringOffset(FrameMetrics metrics, CameraGuidanceProfile checks) {
    if (checks.composition == CompositionRule.centerFocus ||
        checks.composition == CompositionRule.detailFrame) {
      return metrics.centringOffset;
    }
    return metrics.boxCentringOffset;
  }

  AngleQuality _angleQuality(CameraAngle angle, double pitchDegrees) {
    final drift = (pitchDegrees - angle.targetPitchDegrees).abs();
    return drift <= angle.pitchToleranceDegrees
        ? AngleQuality.ok
        : AngleQuality.off;
  }

  CapturePrompt _prompt({
    required FrameMetrics metrics,
    required CameraGuidanceProfile checks,
    required CaptureThresholds thresholds,
    required LightQuality lightQuality,
    required AngleQuality angleQuality,
    DistanceQuality previousDistance = DistanceQuality.unknown,
    CentreQuality previousCentre = CentreQuality.unknown,
  }) {
    // 1. Is anything there? A frame this dark cannot be judged for content,
    //    so darkness is the honest answer rather than "place the saree".
    if (metrics.subjectCoverage < thresholds.minSubjectCoverage) {
      // An exposure this far gone hides the product rather than proving it is
      // absent, so the light is the honest thing to report.
      if (metrics.meanLuminance < thresholds.tooDarkBelow) {
        return CapturePrompt.tooDark;
      }
      if (metrics.meanLuminance > thresholds.tooBrightAbove ||
          metrics.clippedHighlights > thresholds.clippedHighlightsAbove) {
        return CapturePrompt.tooBright;
      }
      return CapturePrompt.noProduct;
    }

    // 2. It is in the room but not in the picture.
    if (metrics.subjectInsideRatio < thresholds.minSubjectInsideRatio &&
        metrics.targetCoverage < checks.minTargetCoverage) {
      return CapturePrompt.moveIntoFrame;
    }
    // Wall-to-wall cloth outranks "keep inside the frame" — the artisan
    // must back up before placement tips make sense.
    if (_isWallToWallProduct(metrics, checks)) {
      return _wordOverflow(checks);
    }
    // Floor tiles reaching the picture edge are not the product running
    // off it. Only clip when the measured box itself leaves the ghost.
    if (metrics.subjectEdgeContact > thresholds.maxEdgeContact &&
        !metrics.boxFitsInsideGhost) {
      return _wordClipping(checks);
    }

    // 3. Size. Overflow first: a subject spilling past the guide makes the
    //    margin as textured as the middle, which drags the fill measure down
    //    to the same low value an empty guide produces. A small distant
    //    product can look the same on the ratio alone, so overflow only
    //    speaks when the guide itself is actually filled.
    if (!_isWholePictureBlob(metrics) &&
        _isOverflowing(metrics, checks, thresholds)) {
      return _wordOverflow(checks);
    }
    if (checks.detectsSubjectFill &&
        _isUnderFilled(metrics, checks, previousDistance)) {
      return CapturePrompt.moveCloser;
    }

    // 4. Fabric direction, only for the grids whose source guidance names one
    //    and only when the frame agrees on a direction at all.
    if (checks.detectsOrientation &&
        metrics.edgeCoherence >= thresholds.minOrientationCoherence) {
      final drift = checks.orientationTarget.driftFrom(metrics.edgeAngleDegrees);
      if (drift > checks.orientationTarget.toleranceDegrees) {
        return checks.orientationTarget == EdgeOrientationTarget.horizontal
            ? CapturePrompt.alignWithHorizontalGuides
            : CapturePrompt.alignWithDiagonalGuides;
      }
    }

    // 5. Light, including backlighting unless the preset asks for it.
    if (checks.detectsLight) {
      if (lightQuality == LightQuality.tooDark) return CapturePrompt.tooDark;
      if (lightQuality == LightQuality.tooBright) {
        return CapturePrompt.tooBright;
      }
    }
    if (checks.detectsBacklight &&
        metrics.backlightRatio > thresholds.backlightRatioAbove) {
      return CapturePrompt.backlightDetected;
    }
    if (checks.detectsLight && lightQuality == LightQuality.low) {
      return CapturePrompt.lowLight;
    }

    // 6. Blur, judged only where there is structure to lose.
    if (metrics.canJudgeFocus &&
        metrics.focusRatio < thresholds.blurredBelow &&
        metrics.fineDetail < thresholds.blurredFineDetailBelow) {
      return CapturePrompt.holdSteady;
    }

    // 7. Angle and centring are the last refinements.
    if (checks.detectsAngle && angleQuality == AngleQuality.off) {
      return CapturePrompt.tiltPhone;
    }
    if (checks.detectsCentring &&
        _centreQuality(metrics, checks, thresholds, previousCentre) ==
            CentreQuality.off) {
      return _wordCentring(checks);
    }

    return CapturePrompt.ready;
  }

  /// True when the cloth has filled the guide and is spilling past it.
  ///
  /// The ratio alone is not enough: an empty ghost frame with a tiny product
  /// in the middle also has more texture in the margin than in the guide,
  /// and that must stay "move closer", never "move further".
  bool _isOverflowing(
    FrameMetrics metrics,
    CameraGuidanceProfile checks,
    CaptureThresholds thresholds,
  ) {
    if (!checks.detectsOverflow) return false;
    // Texture close-ups may fill past the guide on purpose.
    if (checks.isCloseUp &&
        checks.composition == CompositionRule.centerFocus) {
      return false;
    }
    // Whole-picture floor swallow is handled separately — do not call it
    // "move further" without wall-to-wall fabric texture.
    if (_isWholePictureBlob(metrics)) return false;
    return metrics.boxOverflowsGhost;
  }

  /// True when the product's box says the ghost is under-filled.
  ///
  /// Texture contrast alone is not enough: a tiled floor is as busy as a
  /// cushion cover, which used to look like "move closer" on a well-filled
  /// dashed box. Hysteresis keeps a tiny fill wobble from flipping Distance.
  bool _isUnderFilled(
    FrameMetrics metrics,
    CameraGuidanceProfile checks,
    DistanceQuality previous,
  ) {
    final fill = metrics.boxFillOfGhost;
    final min = checks.minTargetCoverage;
    if (previous == DistanceQuality.tooFar) {
      return fill < min + 0.08;
    }
    if (previous == DistanceQuality.ok ||
        previous == DistanceQuality.tooClose) {
      return fill < min - 0.06;
    }
    return fill < min;
  }

  /// The product is running out of the picture entirely.
  CapturePrompt _wordClipping(CameraGuidanceProfile checks) {
    if (checks.composition == CompositionRule.detailFrame) {
      return CapturePrompt.keepBorderInsideFrame;
    }
    return CapturePrompt.keepInsideFrame;
  }

  /// Overflow means the subject is cropped by the ghost frame. Detail and
  /// stacked-fold grids reuse that measurement with source wording.
  CapturePrompt _wordOverflow(CameraGuidanceProfile checks) {
    if (checks.grid == GridOverlayType.detailFrame ||
        checks.composition == CompositionRule.detailFrame) {
      return CapturePrompt.keepBorderInsideFrame;
    }
    if (checks.grid == GridOverlayType.horizontalFolds ||
        checks.composition == CompositionRule.negativeSpaceAroundFolds) {
      return CapturePrompt.keepFoldsVisible;
    }
    return CapturePrompt.moveFurther;
  }

  CapturePrompt _wordCentring(CameraGuidanceProfile checks) {
    if (checks.composition == CompositionRule.centerFocus) {
      return CapturePrompt.keepTextureInCentre;
    }
    if (checks.composition == CompositionRule.detailFrame) {
      return CapturePrompt.keepBorderInsideFrame;
    }
    return CapturePrompt.centerSubject;
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
