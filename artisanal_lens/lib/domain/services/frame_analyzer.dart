import 'dart:math' as math;
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// Raw measurements taken from a single camera preview frame.
///
/// Everything here is measured from the luma plane of the frame in front of
/// the lens. Nothing is inferred from the chosen preset, and nothing is
/// simulated: if a value cannot be measured the field carries its empty-frame
/// default and the evaluator skips the check that depends on it.
class FrameMetrics extends Equatable {
  const FrameMetrics({
    required this.meanLuminance,
    required this.centreLuminance,
    required this.borderLuminance,
    required this.centreDetail,
    required this.borderDetail,
    required this.detailCentroidX,
    required this.detailCentroidY,
    required this.clippedHighlights,
    required this.clippedShadows,
    required this.fineDetail,
    required this.focusRatio,
    required this.subjectCoverage,
    required this.targetCoverage,
    required this.subjectEdgeContact,
    required this.subjectLeft,
    required this.subjectTop,
    required this.subjectRight,
    required this.subjectBottom,
    required this.edgeAngleDegrees,
    required this.edgeCoherence,
    required this.targetArea,
  });

  const FrameMetrics.empty()
      : meanLuminance = 0.5,
        centreLuminance = 0.5,
        borderLuminance = 0.5,
        centreDetail = 0,
        borderDetail = 0,
        detailCentroidX = 0.5,
        detailCentroidY = 0.5,
        clippedHighlights = 0,
        clippedShadows = 0,
        fineDetail = 0,
        focusRatio = 1,
        subjectCoverage = 0,
        targetCoverage = 0,
        subjectEdgeContact = 0,
        subjectLeft = 0,
        subjectTop = 0,
        subjectRight = 1,
        subjectBottom = 1,
        edgeAngleDegrees = 0,
        edgeCoherence = 0,
        targetArea = 0.36;

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

  /// Share of sampled pixels pinned at the top of the range, 0..1.
  ///
  /// Mean brightness can look healthy while a sunlit border is already blown
  /// out, which is exactly the case that destroys weave detail.
  final double clippedHighlights;

  /// Share of sampled pixels crushed at the bottom of the range, 0..1.
  final double clippedShadows;

  /// Mean pixel-to-pixel difference, 0..1. Near zero across a frame that has
  /// broader structure is the signature of a smeared or defocused frame.
  final double fineDetail;

  /// Fine-scale detail as a share of coarse-scale detail.
  ///
  /// Defocus and motion smear wipe out pixel-to-pixel differences long before
  /// they touch the broad shapes, so this ratio collapses when the frame is
  /// blurred and holds up when it is sharp. It is only meaningful when the
  /// frame has coarse structure to begin with — see [canJudgeFocus].
  final double focusRatio;

  /// Share of the whole frame occupied by subject-like (textured) cells, 0..1.
  final double subjectCoverage;

  /// Share of the ghost-frame region occupied by subject-like cells, 0..1.
  final double targetCoverage;

  /// Share of the outermost ring of the frame that the product covers, 0..1.
  ///
  /// A product photographed with room around it touches none of it; one that
  /// runs off the picture covers most of it.
  final double subjectEdgeContact;

  /// Bounding box of the subject cells, normalised 0..1.
  final double subjectLeft;
  final double subjectTop;
  final double subjectRight;
  final double subjectBottom;

  /// Dominant edge direction in degrees, -90..90, where 0 is a horizontal
  /// edge (folds running left to right) and ±45 is a diagonal.
  final double edgeAngleDegrees;

  /// How strongly the frame agrees on that one direction, 0..1.
  ///
  /// Random weave texture has no dominant direction and scores near zero, so
  /// the alignment check stays quiet rather than guessing.
  final double edgeCoherence;

  /// Fraction of the frame the ghost frame covers, which converts between
  /// [targetCoverage] and [subjectCoverage].
  final double targetArea;

  /// How far the subject sits from the middle of the frame, 0..~0.7.
  double get centringOffset {
    final dx = detailCentroidX - 0.5;
    final dy = detailCentroidY - 0.5;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// How much textured content spills outside the ghost frame relative to
  /// inside it.
  double get overflowRatio =>
      centreDetail <= 0.001 ? 0 : borderDetail / centreDetail;

  /// How strongly the surroundings out-shine the subject.
  ///
  /// Values above ~1.6 mean the light is behind the fabric, which flattens it
  /// into a silhouette — the condition behind the "Backlight detected" prompt.
  double get backlightRatio =>
      centreLuminance <= 0.001 ? 999 : borderLuminance / centreLuminance;

  /// Rough estimate of how much of the ghost frame the subject occupies, 0..1.
  double get subjectFillRatio {
    if (centreDetail <= 0.001) return 0;
    final contrast = centreDetail / math.max(borderDetail, 0.004);
    // contrast of 1 means the guide holds no more subject than the background;
    // 4 or above means it is comfortably filled.
    return ((contrast - 1) / 3).clamp(0.0, 1.0);
  }

  /// Share of the subject that has made it inside the ghost frame, 0..1.
  ///
  /// Separates "the product is too small" from "the product is off to one
  /// side": both leave the guide under-filled, only the second leaves most of
  /// the subject outside it.
  double get subjectInsideRatio {
    if (subjectCoverage <= 0.0001) return 0;
    // targetCoverage is a share of the guide, subjectCoverage a share of the
    // frame, so the guide's own area converts between them.
    final insideArea = targetCoverage * targetArea;
    return (insideArea / subjectCoverage).clamp(0.0, 1.0);
  }

  /// Whether the frame has enough coarse structure for [focusRatio] to mean
  /// anything. A blank wall is not "blurred", it is simply empty.
  bool get canJudgeFocus => centreDetail > 0.02 || borderDetail > 0.02;

  @override
  List<Object?> get props => [
        meanLuminance,
        centreLuminance,
        borderLuminance,
        centreDetail,
        borderDetail,
        detailCentroidX,
        detailCentroidY,
        clippedHighlights,
        clippedShadows,
        fineDetail,
        focusRatio,
        subjectCoverage,
        targetCoverage,
        subjectEdgeContact,
        subjectLeft,
        subjectTop,
        subjectRight,
        subjectBottom,
        edgeAngleDegrees,
        edgeCoherence,
        targetArea,
      ];
}

/// Extracts [FrameMetrics] from the luma (Y) plane of a YUV420 camera frame.
///
/// Only the Y plane is read, and only every [_sampleStride]-th pixel, so this
/// stays cheap enough to run on the low-end handsets the artisans actually
/// use. One pass produces every measurement: brightness, texture, a coarse
/// occupancy map of where the product is, focus, and the dominant fabric
/// direction.
class FrameAnalyzer {
  const FrameAnalyzer();

  /// Sample every Nth pixel in both axes.
  static const int _sampleStride = 8;

  /// The occupancy map is this many cells across and down.
  static const int _cells = 16;

  /// A cell counts as subject when its texture clears this share of the
  /// strongest cell in the frame.
  static const double _relativeSubjectThreshold = 0.30;

  /// ...and this absolute floor, which keeps sensor noise on a blank wall
  /// from being read as a product.
  static const double _absoluteSubjectThreshold = 0.06;

  /// A cell also counts as subject when it is this much brighter or darker
  /// than the surface around the edge of the frame. Without it a plain, flat
  /// cushion cover would be invisible to a texture-only test.
  static const double _lumaDeviationThreshold = 0.10;

  /// Luma at or above this counts as a blown highlight.
  static const int _highlightClip = 250;

  /// Luma at or below this counts as a crushed shadow.
  static const int _shadowClip = 6;

  /// Analyses one luma plane.
  ///
  /// [bytesPerRow] is the plane's row stride, which is often wider than
  /// [width] because of alignment padding; reading it correctly is what keeps
  /// the measurements from skewing on some devices. [insetX] and [insetY]
  /// place the ghost frame, so the region measured is the region drawn.
  FrameMetrics analyseLumaPlane({
    required Uint8List luma,
    required int width,
    required int height,
    required int bytesPerRow,
    double insetX = 0.2,
    double insetY = 0.2,
  }) {
    if (width <= 0 || height <= 0 || luma.isEmpty) {
      return const FrameMetrics.empty();
    }

    final centreLeft = (width * insetX).round();
    final centreRight = width - centreLeft;
    final centreTop = (height * insetY).round();
    final centreBottom = height - centreTop;

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
    var highlightCount = 0;
    var shadowCount = 0;
    var fineSum = 0.0;
    var fineCount = 0;

    // Structure tensor accumulators for the dominant edge direction.
    var jxx = 0.0;
    var jyy = 0.0;
    var jxy = 0.0;

    final cellDetail = List<double>.filled(_cells * _cells, 0);
    final cellCount = List<int>.filled(_cells * _cells, 0);
    final cellLuma = List<double>.filled(_cells * _cells, 0);
    final cellLumaCount = List<int>.filled(_cells * _cells, 0);

    for (var y = 0; y < height; y += _sampleStride) {
      final rowStart = y * bytesPerRow;
      if (rowStart >= luma.length) break;
      final belowRow = (y + _sampleStride) * bytesPerRow;
      final hasBelow = y + _sampleStride < height && belowRow < luma.length;
      final aboveRow = (y - _sampleStride) * bytesPerRow;
      final hasAbove = y - _sampleStride >= 0;

      for (var x = 0; x < width; x += _sampleStride) {
        final index = rowStart + x;
        if (index >= luma.length) break;

        final raw = luma[index];
        final value = raw / 255.0;
        totalSum += value;
        totalCount++;
        if (raw >= _highlightClip) highlightCount++;
        if (raw <= _shadowClip) shadowCount++;

        final lumaCell = (y * _cells ~/ height).clamp(0, _cells - 1) * _cells +
            (x * _cells ~/ width).clamp(0, _cells - 1);
        cellLuma[lumaCell] += value;
        cellLumaCount[lumaCell]++;

        final hasRight = x + _sampleStride < width;

        // Signed coarse gradients drive the texture measures.
        double gx = 0;
        double gy = 0;
        if (hasRight && index + _sampleStride < luma.length) {
          gx = luma[index + _sampleStride] / 255.0 - value;
        }
        if (hasBelow && belowRow + x < luma.length) {
          gy = luma[belowRow + x] / 255.0 - value;
        }

        // Direction is measured with central differences instead. Forward
        // differences both subtract this pixel, so its noise appears in each
        // axis and fakes a diagonal out of a directionless weave.
        final hasLeft = x - _sampleStride >= 0;
        if (hasLeft && hasRight && hasAbove && hasBelow) {
          final cx = (luma[index + _sampleStride] -
                  luma[index - _sampleStride]) /
              255.0;
          final cy =
              (luma[belowRow + x] - luma[aboveRow + x]) / 255.0;
          jxx += cx * cx;
          jyy += cy * cy;
          jxy += cx * cy;
        }

        // Pixel-to-pixel difference, which blur destroys first. Both axes are
        // read: a cloth of horizontal stripes has no detail along a row at
        // all, and reading only rows would call it an empty frame.
        if (x + 1 < width && index + 1 < luma.length) {
          fineSum += (luma[index + 1] / 255.0 - value).abs();
          fineCount++;
        }
        if (y + 1 < height && (y + 1) * bytesPerRow + x < luma.length) {
          fineSum += (luma[(y + 1) * bytesPerRow + x] / 255.0 - value).abs();
          fineCount++;
        }

        final detail = hasRight || hasBelow ? gx.abs() + gy.abs() : null;
        if (detail != null) {
          detailWeightSum += detail;
          detailWeightedX += detail * (x / width);
          detailWeightedY += detail * (y / height);

          final cellX = (x * _cells ~/ width).clamp(0, _cells - 1);
          final cellY = (y * _cells ~/ height).clamp(0, _cells - 1);
          final cell = cellY * _cells + cellX;
          cellDetail[cell] += detail;
          cellCount[cell]++;
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

    final coarseDetail = detailWeightSum /
        math.max(centreDetailCount + borderDetailCount, 1);
    final occupancy = _measureOccupancy(
      cellDetail: cellDetail,
      cellCount: cellCount,
      cellLuma: cellLuma,
      cellLumaCount: cellLumaCount,
      insetX: insetX,
      insetY: insetY,
    );

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
      clippedHighlights: highlightCount / totalCount,
      clippedShadows: shadowCount / totalCount,
      fineDetail: fineCount == 0 ? 0 : fineSum / fineCount,
      focusRatio: _focusRatio(
        fineMean: fineCount == 0 ? 0 : fineSum / fineCount,
        coarseMean: coarseDetail,
      ),
      subjectCoverage: occupancy.coverage,
      targetCoverage: occupancy.targetCoverage,
      subjectEdgeContact: occupancy.edgeContact,
      subjectLeft: occupancy.left,
      subjectTop: occupancy.top,
      subjectRight: occupancy.right,
      subjectBottom: occupancy.bottom,
      edgeAngleDegrees: _edgeAngle(jxx, jyy, jxy),
      edgeCoherence: _coherence(jxx, jyy, jxy),
      targetArea: (1 - 2 * insetX) * (1 - 2 * insetY),
    );
  }

  /// Turns the per-cell maps into where the product actually is.
  ///
  /// A cell is product if it is noticeably woven, or noticeably brighter or
  /// darker than the surface running around the edge of the picture. Judging
  /// both keeps a textureless cushion cover visible without letting sensor
  /// grain on an empty table read as cloth.
  ///
  /// The surround is read from the outer ring rather than the whole frame: a
  /// cloth that covers most of the picture would otherwise become the
  /// "typical" brightness and the table around it would be mistaken for the
  /// product. When the cloth reaches the edge too, the ring is the cloth, the
  /// brightness test simply finds nothing, and the texture test carries it.
  _Occupancy _measureOccupancy({
    required List<double> cellDetail,
    required List<int> cellCount,
    required List<double> cellLuma,
    required List<int> cellLumaCount,
    required double insetX,
    required double insetY,
  }) {
    var strongest = 0.0;
    final ringLumas = <double>[];
    for (var cy = 0; cy < _cells; cy++) {
      for (var cx = 0; cx < _cells; cx++) {
        final i = cy * _cells + cx;
        if (cellCount[i] > 0) {
          final mean = cellDetail[i] / cellCount[i];
          if (mean > strongest) strongest = mean;
        }
        final onRing =
            cx == 0 || cy == 0 || cx == _cells - 1 || cy == _cells - 1;
        if (onRing && cellLumaCount[i] > 0) {
          ringLumas.add(cellLuma[i] / cellLumaCount[i]);
        }
      }
    }
    if (ringLumas.isEmpty) return const _Occupancy.empty();

    ringLumas.sort();
    final surroundLuma = ringLumas[ringLumas.length ~/ 2];

    final threshold = math.max(
      _absoluteSubjectThreshold,
      strongest * _relativeSubjectThreshold,
    );

    final firstTargetX = (insetX * _cells).floor();
    final lastTargetX = (_cells - insetX * _cells).ceil() - 1;
    final firstTargetY = (insetY * _cells).floor();
    final lastTargetY = (_cells - insetY * _cells).ceil() - 1;

    var subjectCells = 0;
    var targetCells = 0;
    var targetSubjectCells = 0;
    var ringCells = 0;
    var ringSubjectCells = 0;
    var minX = _cells, minY = _cells, maxX = -1, maxY = -1;

    for (var cy = 0; cy < _cells; cy++) {
      for (var cx = 0; cx < _cells; cx++) {
        final i = cy * _cells + cx;
        final inTarget = cx >= firstTargetX &&
            cx <= lastTargetX &&
            cy >= firstTargetY &&
            cy <= lastTargetY;
        if (inTarget) targetCells++;
        final onRing =
            cx == 0 || cy == 0 || cx == _cells - 1 || cy == _cells - 1;
        if (onRing) ringCells++;

        if (cellCount[i] == 0 && cellLumaCount[i] == 0) continue;
        final texture = cellCount[i] == 0 ? 0.0 : cellDetail[i] / cellCount[i];
        final lumaDeviation = cellLumaCount[i] == 0
            ? 0.0
            : (cellLuma[i] / cellLumaCount[i] - surroundLuma).abs();
        final isSubject = texture >= threshold ||
            lumaDeviation >= _lumaDeviationThreshold;
        if (!isSubject) continue;

        subjectCells++;
        if (inTarget) targetSubjectCells++;
        if (onRing) ringSubjectCells++;
        if (cx < minX) minX = cx;
        if (cy < minY) minY = cy;
        if (cx > maxX) maxX = cx;
        if (cy > maxY) maxY = cy;
      }
    }

    if (subjectCells == 0) return const _Occupancy.empty();

    return _Occupancy(
      coverage: subjectCells / (_cells * _cells),
      targetCoverage: targetCells == 0 ? 0 : targetSubjectCells / targetCells,
      edgeContact: ringCells == 0 ? 0 : ringSubjectCells / ringCells,
      left: minX / _cells,
      top: minY / _cells,
      right: (maxX + 1) / _cells,
      bottom: (maxY + 1) / _cells,
    );
  }

  /// Fine detail as a share of coarse detail, clamped to a readable 0..1.
  double _focusRatio({required double fineMean, required double coarseMean}) {
    if (coarseMean <= 0.001) return 1;
    return (fineMean / coarseMean).clamp(0.0, 1.0);
  }

  /// Dominant edge direction from the structure tensor, in degrees.
  ///
  /// The tensor gives the direction the brightness changes in; the edge itself
  /// runs at right angles to that, which is the number the fold and diagonal
  /// guides are expressed in.
  double _edgeAngle(double jxx, double jyy, double jxy) {
    if (jxx + jyy <= 1e-9) return 0;
    final gradientRadians = 0.5 * math.atan2(2 * jxy, jxx - jyy);
    var degrees = gradientRadians * 180 / math.pi + 90;
    while (degrees > 90) {
      degrees -= 180;
    }
    while (degrees < -90) {
      degrees += 180;
    }
    return degrees;
  }

  /// How much the frame agrees on one direction, 0 (isotropic) to 1 (a clean
  /// set of parallel lines).
  double _coherence(double jxx, double jyy, double jxy) {
    final trace = jxx + jyy;
    if (trace <= 1e-9) return 0;
    final diff = jxx - jyy;
    return (math.sqrt(diff * diff + 4 * jxy * jxy) / trace).clamp(0.0, 1.0);
  }
}

/// Where the product sits, read off the coarse texture map.
class _Occupancy {
  const _Occupancy({
    required this.coverage,
    required this.targetCoverage,
    required this.edgeContact,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  const _Occupancy.empty()
      : coverage = 0,
        targetCoverage = 0,
        edgeContact = 0,
        left = 0,
        top = 0,
        right = 1,
        bottom = 1;

  final double coverage;
  final double targetCoverage;
  final double edgeContact;
  final double left;
  final double top;
  final double right;
  final double bottom;
}
