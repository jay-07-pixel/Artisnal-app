import 'package:artisanal_lens/domain/services/frame_analyzer.dart';
import 'package:artisanal_lens/domain/services/frame_metrics_smoother.dart';
import 'package:flutter_test/flutter_test.dart';

FrameMetrics box({
  required double left,
  required double top,
  required double right,
  required double bottom,
  double coverage = 0.4,
}) =>
    FrameMetrics(
      meanLuminance: 0.5,
      centreLuminance: 0.5,
      borderLuminance: 0.5,
      centreDetail: 0.08,
      borderDetail: 0.02,
      detailCentroidX: 0.5,
      detailCentroidY: 0.5,
      clippedHighlights: 0,
      clippedShadows: 0,
      fineDetail: 0.05,
      focusRatio: 0.5,
      subjectCoverage: coverage,
      targetCoverage: 0.5,
      subjectEdgeContact: 0,
      subjectLeft: left,
      subjectTop: top,
      subjectRight: right,
      subjectBottom: bottom,
      edgeAngleDegrees: 0,
      edgeCoherence: 0,
      targetArea: 0.64,
      ghostInsetX: 0.1,
      ghostInsetY: 0.16,
    );

void main() {
  test('occupancy box is blended so a one-frame jump is damped', () {
    final smoother = FrameMetricsSmoother(alpha: 0.4);

    smoother.accept(box(left: 0.2, top: 0.2, right: 0.8, bottom: 0.8));
    final jumped = smoother.accept(
      box(left: 0.05, top: 0.05, right: 0.95, bottom: 0.95),
    );

    expect(jumped.subjectLeft, greaterThan(0.05));
    expect(jumped.subjectLeft, lessThan(0.2));
    expect(jumped.subjectRight, lessThan(0.95));
    expect(jumped.subjectRight, greaterThan(0.8));
  });
}
