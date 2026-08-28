import 'frame_analyzer.dart';

/// Blends occupancy geometry across frames so a 1–2 cm phone wobble does not
/// flip Distance / Centre every analysis tick.
///
/// Leaf patterns on a busy floor make the raw blob jump between patches.
/// Smoothing the box (not inventing one) keeps the chips readable.
class FrameMetricsSmoother {
  FrameMetricsSmoother({this.alpha = 0.4});

  /// Weight of the newest frame. Lower = calmer chips, slower to track a
  /// real move of the cloth.
  final double alpha;

  FrameMetrics? _previous;

  FrameMetrics accept(FrameMetrics next) {
    final previous = _previous;
    if (previous == null ||
        next.subjectCoverage < 0.012 ||
        previous.subjectCoverage < 0.012) {
      _previous = next;
      return next;
    }

    final blended = FrameMetrics(
      meanLuminance: _lerp(previous.meanLuminance, next.meanLuminance),
      centreLuminance: _lerp(previous.centreLuminance, next.centreLuminance),
      borderLuminance: _lerp(previous.borderLuminance, next.borderLuminance),
      centreDetail: _lerp(previous.centreDetail, next.centreDetail),
      borderDetail: _lerp(previous.borderDetail, next.borderDetail),
      detailCentroidX: _lerp(previous.detailCentroidX, next.detailCentroidX),
      detailCentroidY: _lerp(previous.detailCentroidY, next.detailCentroidY),
      clippedHighlights:
          _lerp(previous.clippedHighlights, next.clippedHighlights),
      clippedShadows: _lerp(previous.clippedShadows, next.clippedShadows),
      fineDetail: _lerp(previous.fineDetail, next.fineDetail),
      focusRatio: _lerp(previous.focusRatio, next.focusRatio),
      subjectCoverage: _lerp(previous.subjectCoverage, next.subjectCoverage),
      targetCoverage: _lerp(previous.targetCoverage, next.targetCoverage),
      subjectEdgeContact:
          _lerp(previous.subjectEdgeContact, next.subjectEdgeContact),
      subjectLeft: _lerp(previous.subjectLeft, next.subjectLeft),
      subjectTop: _lerp(previous.subjectTop, next.subjectTop),
      subjectRight: _lerp(previous.subjectRight, next.subjectRight),
      subjectBottom: _lerp(previous.subjectBottom, next.subjectBottom),
      edgeAngleDegrees: _lerp(previous.edgeAngleDegrees, next.edgeAngleDegrees),
      edgeCoherence: _lerp(previous.edgeCoherence, next.edgeCoherence),
      targetArea: next.targetArea,
      ghostInsetX: next.ghostInsetX,
      ghostInsetY: next.ghostInsetY,
    );
    _previous = blended;
    return blended;
  }

  void reset() => _previous = null;

  double _lerp(double from, double to) => from + (to - from) * alpha;
}
