import 'dart:math' as math;
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// Raw measurements taken from a single camera preview frame.
class FrameMetrics extends Equatable {
  const FrameMetrics({
    required this.meanLuminance,
    required this.centreLuminance,
    required this.borderLuminance,
    required this.centreDetail,
    required this.borderDetail,
    required this.detailCentroidX,
    required this.detailCentroidY,
  });

  const FrameMetrics.empty()
      : meanLuminance = 0.5,
        centreLuminance = 0.5,
        borderLuminance = 0.5,
        centreDetail = 0,
        borderDetail = 0,
        detailCentroidX = 0.5,
        detailCentroidY = 0.5;

  /// Average brightness across the whole frame, 0..1.
  final double meanLuminance;

  /// Average brightness inside the ghost-frame region, 0..1.
  final double centreLuminance;

  /// Average brightness of the margin outside the ghost frame, 0..1.
  final double borderLuminance;

  /// Mean absolute neighbour difference inside the ghost frame, 0..1.
  ///
  /// Woven fabric produces a textured, high-variance signal; an empty floor or
  /// wall is comparatively flat. This is what lets the analyser tell "the
  /// subject fills the guide" from "the guide is mostly empty background".
  final double centreDetail;

  /// The same measure for the margin outside the ghost frame.
  final double borderDetail;

  /// Horizontal centre of mass of the textured content, 0 (left) to 1 (right).
  final double detailCentroidX;

  /// Vertical centre of mass of the textured content, 0 (top) to 1 (bottom).
  final double detailCentroidY;

  /// How far the subject sits from the middle of the frame, 0..~0.7.
  ///
  /// Drives the "Center your subject" prompt.
  double get centringOffset {
    final dx = detailCentroidX - 0.5;
    final dy = detailCentroidY - 0.5;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// How much textured content spills outside the ghost frame relative to
  /// inside it. High values mean the product is cropped by the guide, which is
  /// what the "Move further from subject" prompt responds to.
  double get overflowRatio =>
      centreDetail <= 0.001 ? 0 : borderDetail / centreDetail;

  /// How strongly the surroundings out-shine the subject.
  ///
  /// Values above ~1.6 mean the light is behind the fabric, which flattens it
  /// into a silhouette — the condition behind the "Backlight detected" prompt.
  double get backlightRatio =>
      centreLuminance <= 0.001 ? 999 : borderLuminance / centreLuminance;

  /// Rough estimate of how much of the ghost frame the subject occupies, 0..1.
  ///
  /// Derived from how much more textured the framed region is than the margin.
  double get subjectFillRatio {
    if (centreDetail <= 0.001) return 0;
    final contrast = centreDetail / math.max(borderDetail, 0.004);
    // contrast of 1 means the guide holds no more subject than the background;
    // 4 or above means it is comfortably filled.
    return ((contrast - 1) / 3).clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [
        meanLuminance,
        centreLuminance,
        borderLuminance,
        centreDetail,
        borderDetail,
        detailCentroidX,
        detailCentroidY,
      ];
}

/// Extracts [FrameMetrics] from the luma (Y) plane of a YUV420 camera frame.
///
/// Only the Y plane is read, and only every [_sampleStride]-th pixel, so this
/// stays cheap enough to run on the low-end handsets the artisans actually use.
class FrameAnalyzer {
  const FrameAnalyzer();

  /// Sample every Nth pixel in both axes.
  static const int _sampleStride = 8;

  /// The ghost frame is treated as the central 60% of the preview.
  static const double _centreFraction = 0.6;

  /// Analyses one luma plane.
  ///
  /// [bytesPerRow] is the plane's row stride, which is often wider than
  /// [width] because of alignment padding; reading it correctly is what keeps
  /// the measurements from skewing on some devices.
  FrameMetrics analyseLumaPlane({
    required Uint8List luma,
    required int width,
    required int height,
    required int bytesPerRow,
  }) {
    if (width <= 0 || height <= 0 || luma.isEmpty) {
      return const FrameMetrics.empty();
    }

    final marginX = (width * (1 - _centreFraction) / 2).round();
    final marginY = (height * (1 - _centreFraction) / 2).round();
    final centreLeft = marginX;
    final centreRight = width - marginX;
    final centreTop = marginY;
    final centreBottom = height - marginY;

    var totalSum = 0.0;
    var totalCount = 0;
    var centreSum = 0.0;
    var centreCount = 0;
    var borderSum = 0.0;
    var borderCount = 0;
    var centreDetailSum = 0.0;
    var centreDetailCount = 0;
    var borderDetailSum = 0.0;
    var borderDetailCount = 0;
    var detailWeightSum = 0.0;
    var detailWeightedX = 0.0;
    var detailWeightedY = 0.0;

    for (var y = 0; y < height; y += _sampleStride) {
      final rowStart = y * bytesPerRow;
      if (rowStart >= luma.length) break;

      for (var x = 0; x < width; x += _sampleStride) {
        final index = rowStart + x;
        if (index >= luma.length) break;

        final value = luma[index] / 255.0;
        totalSum += value;
        totalCount++;

        // Neighbour difference along the row approximates local texture.
        final neighbourIndex = index + _sampleStride;
        double? detail;
        if (x + _sampleStride < width && neighbourIndex < luma.length) {
          detail = (luma[neighbourIndex] / 255.0 - value).abs();
          detailWeightSum += detail;
          detailWeightedX += detail * (x / width);
          detailWeightedY += detail * (y / height);
        }

        final inCentre = x >= centreLeft &&
            x < centreRight &&
            y >= centreTop &&
            y < centreBottom;

        if (inCentre) {
          centreSum += value;
          centreCount++;
          if (detail != null) {
            centreDetailSum += detail;
            centreDetailCount++;
          }
        } else {
          borderSum += value;
          borderCount++;
          if (detail != null) {
            borderDetailSum += detail;
            borderDetailCount++;
          }
        }
      }
    }

    if (totalCount == 0) return const FrameMetrics.empty();

    return FrameMetrics(
      meanLuminance: totalSum / totalCount,
      centreLuminance: centreCount == 0 ? 0.5 : centreSum / centreCount,
      borderLuminance: borderCount == 0 ? 0.5 : borderSum / borderCount,
      centreDetail:
          centreDetailCount == 0 ? 0 : centreDetailSum / centreDetailCount,
      borderDetail:
          borderDetailCount == 0 ? 0 : borderDetailSum / borderDetailCount,
      detailCentroidX:
          detailWeightSum <= 0.001 ? 0.5 : detailWeightedX / detailWeightSum,
      detailCentroidY:
          detailWeightSum <= 0.001 ? 0.5 : detailWeightedY / detailWeightSum,
    );
  }
}
