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
    this.ghostInsetX = 0.2,
    this.ghostInsetY = 0.2,
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
        targetArea = 0.36,
        ghostInsetX = 0.2,
        ghostInsetY = 0.2;

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

  /// Ghost-frame inset from the left/right, matching the overlay the artisan
  /// sees. Distance is judged against this rectangle, not against leftover
  /// floor texture.
  final double ghostInsetX;

  /// Ghost-frame inset from the top/bottom.
  final double ghostInsetY;

  /// How far the weave's centre of mass sits from the middle of the frame.
  ///
  /// Useful for close-up texture shots. A busy bedspread can pull this
  /// toward the middle even when the product itself is at the edge, so
  /// full-product centring uses [boxCentringOffset] instead.
  double get centringOffset {
    final dx = detailCentroidX - 0.5;
    final dy = detailCentroidY - 0.5;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// How far the product's bounding box sits from the middle of the frame.
  double get boxCentringOffset {
    final dx = (subjectLeft + subjectRight) / 2 - 0.5;
    final dy = (subjectTop + subjectBottom) / 2 - 0.5;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Share of the dashed ghost that the product's box actually covers, 0..1.
  double get boxFillOfGhost {
    final ghostLeft = ghostInsetX;
    final ghostTop = ghostInsetY;
    final ghostRight = 1 - ghostInsetX;
    final ghostBottom = 1 - ghostInsetY;
    final left = math.max(subjectLeft, ghostLeft);
    final top = math.max(subjectTop, ghostTop);
    final right = math.min(subjectRight, ghostRight);
    final bottom = math.min(subjectBottom, ghostBottom);
    if (right <= left || bottom <= top) return 0;
    final ghostArea =
        math.max(ghostRight - ghostLeft, 0.001) * math.max(ghostBottom - ghostTop, 0.001);
    return ((right - left) * (bottom - top) / ghostArea).clamp(0.0, 1.0);
  }

  /// True when the measured product box sits inside the dashed ghost.
  ///
  /// Used to silence "keep inside the frame" when the cloth is already in
  /// the guide and only the floor texture reaches the picture edge.
  bool get boxFitsInsideGhost {
    const slack = 0.04;
    return subjectLeft >= ghostInsetX - slack &&
        subjectTop >= ghostInsetY - slack &&
        subjectRight <= 1 - ghostInsetX + slack &&
        subjectBottom <= 1 - ghostInsetY + slack;
  }

  /// True when the product's box spills past the dashed ghost on at least
  /// two sides. One side is a placement problem, not distance.
  ///
  /// A box that reaches the picture rim is occupancy swallowing the floor,
  /// not a close-up — that used to stick Distance on "Move back".
  bool get boxOverflowsGhost {
    if (subjectEdgeContact > 0.34) return false;

    const slack = 0.14;
    var sides = 0;
    if (subjectLeft < ghostInsetX - slack) sides++;
    if (subjectTop < ghostInsetY - slack) sides++;
    if (subjectRight > 1 - ghostInsetX + slack) sides++;
    if (subjectBottom > 1 - ghostInsetY + slack) sides++;
    return sides >= 2;
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

  /// True when the lens has not yet exposed — a black opening frame.
  ///
  /// Auto-exposure on many phones starts this way. Those frames must not be
  /// read as "too dark" or "move in".
  bool get isUnexposedPreview =>
      meanLuminance < 0.12 &&
      centreDetail < 0.008 &&
      subjectCoverage < 0.02;

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
        ghostInsetX,
        ghostInsetY,
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
  static const double _relativeSubjectThreshold = 0.32;

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
      ghostInsetX: insetX,
      ghostInsetY: insetY,
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
  ///
  /// Distance then follows a compact blob that does not swallow the floor.
  /// Tiled grout is as textured as weave, so the product is the region that
  /// differs in brightness from the picture rim — the cloth sitting on that
  /// floor — not the largest textured area.
  _Occupancy _measureOccupancy({
    required List<double> cellDetail,
    required List<int> cellCount,
    required List<double> cellLuma,
    required List<int> cellLumaCount,
    required double insetX,
    required double insetY,
  }) {
    var strongestTexture = 0.0;
    var strongestTextureIndex = 0;
    final ringLumas = <double>[];
    final textureMean = List<double>.filled(_cells * _cells, 0);
    final lumaMean = List<double>.filled(_cells * _cells, 0);

    for (var cy = 0; cy < _cells; cy++) {
      for (var cx = 0; cx < _cells; cx++) {
        final i = cy * _cells + cx;
        if (cellCount[i] > 0) {
          textureMean[i] = cellDetail[i] / cellCount[i];
          if (textureMean[i] > strongestTexture) {
            strongestTexture = textureMean[i];
            strongestTextureIndex = i;
          }
        }
        if (cellLumaCount[i] > 0) {
          lumaMean[i] = cellLuma[i] / cellLumaCount[i];
        }
        final onRing =
            cx == 0 || cy == 0 || cx == _cells - 1 || cy == _cells - 1;
        if (onRing && cellLumaCount[i] > 0) {
          ringLumas.add(lumaMean[i]);
        }
      }
    }
    if (ringLumas.isEmpty) return const _Occupancy.empty();

    ringLumas.sort();
    final surroundLuma = ringLumas[ringLumas.length ~/ 2];

    final textureThreshold = math.max(
      _absoluteSubjectThreshold,
      strongestTexture * _relativeSubjectThreshold,
    );
    final textureCoreThreshold = math.max(
      _absoluteSubjectThreshold,
      strongestTexture * 0.40,
    );

    final firstTargetX = (insetX * _cells).floor();
    final lastTargetX = (_cells - insetX * _cells).ceil() - 1;
    final firstTargetY = (insetY * _cells).floor();
    final lastTargetY = (_cells - insetY * _cells).ceil() - 1;

    var strongestLumaDev = 0.0;
    var strongestLumaIndex = 0;
    final lumaDev = List<double>.filled(_cells * _cells, 0);
    for (var i = 0; i < _cells * _cells; i++) {
      lumaDev[i] = (lumaMean[i] - surroundLuma).abs();
      if (lumaDev[i] > strongestLumaDev) {
        strongestLumaDev = lumaDev[i];
        strongestLumaIndex = i;
      }
    }

    final lumaThreshold = math.max(
      _lumaDeviationThreshold,
      strongestLumaDev * 0.50,
    );

    var targetCells = 0;
    var ringCells = 0;
    final isSubject = List<bool>.filled(_cells * _cells, false);
    final lumaMask = List<bool>.filled(_cells * _cells, false);
    final textureMask = List<bool>.filled(_cells * _cells, false);

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
        lumaMask[i] = lumaDev[i] >= lumaThreshold;
        textureMask[i] = textureMean[i] >= textureCoreThreshold;
        isSubject[i] = textureMask[i] ||
            textureMean[i] >= textureThreshold ||
            lumaDev[i] >= _lumaDeviationThreshold;
      }
    }

    final blob = _pickProductBlob(
      lumaMask: lumaMask,
      textureMask: textureMask,
      isSubject: isSubject,
      strongestLumaIndex: strongestLumaIndex,
      strongestTextureIndex: strongestTextureIndex,
      firstTargetX: firstTargetX,
      lastTargetX: lastTargetX,
      firstTargetY: firstTargetY,
      lastTargetY: lastTargetY,
    );
    if (blob.isEmpty) return const _Occupancy.empty();

    var ringSubjectCells = 0;
    var targetSubjectCells = 0;
    var minX = _cells, minY = _cells, maxX = -1, maxY = -1;
    for (final i in blob) {
      final cx = i % _cells;
      final cy = i ~/ _cells;
      if (cx >= firstTargetX &&
          cx <= lastTargetX &&
          cy >= firstTargetY &&
          cy <= lastTargetY) {
        targetSubjectCells++;
      }
      if (cx == 0 || cy == 0 || cx == _cells - 1 || cy == _cells - 1) {
        ringSubjectCells++;
      }
      if (cx < minX) minX = cx;
      if (cy < minY) minY = cy;
      if (cx > maxX) maxX = cx;
      if (cy > maxY) maxY = cy;
    }

    return _Occupancy(
      coverage: blob.length / (_cells * _cells),
      targetCoverage: targetCells == 0 ? 0 : targetSubjectCells / targetCells,
      edgeContact: ringCells == 0 ? 0 : ringSubjectCells / ringCells,
      left: minX / _cells,
      top: minY / _cells,
      right: (maxX + 1) / _cells,
      bottom: (maxY + 1) / _cells,
    );
  }

  /// Prefers a compact cloth on the floor over the floor itself.
  ///
  /// Tiles reach the picture rim and match its brightness. The product
  /// usually does neither: it sits inside the frame at a different
  /// brightness. A smeared but well-placed cloth still has that brightness
  /// step even after the weave is gone, so blur can be judged instead of
  /// "move into the frame".
  List<int> _pickProductBlob({
    required List<bool> lumaMask,
    required List<bool> textureMask,
    required List<bool> isSubject,
    required int strongestLumaIndex,
    required int strongestTextureIndex,
    required int firstTargetX,
    required int lastTargetX,
    required int firstTargetY,
    required int lastTargetY,
  }) {
    List<int> bestOf(List<List<int>> blobs) => _bestBlob(
          blobs,
          firstTargetX: firstTargetX,
          lastTargetX: lastTargetX,
          firstTargetY: firstTargetY,
          lastTargetY: lastTargetY,
        );

    final lumaBlobs = _allBlobs(lumaMask);
    final lumaPick = _pickFromBlobs(
      lumaBlobs,
      seedIndex: strongestLumaIndex,
      bestOf: bestOf,
    );
    if (lumaPick.isNotEmpty) return lumaPick;

    final textureBlobs = _allBlobs(textureMask);
    final texturePick = _pickFromBlobs(
      textureBlobs,
      seedIndex: strongestTextureIndex,
      bestOf: bestOf,
    );
    if (texturePick.isNotEmpty) return texturePick;

    final subjectBlobs = _allBlobs(isSubject);
    return _pickFromBlobs(
      subjectBlobs,
      seedIndex: strongestLumaIndex,
      bestOf: bestOf,
    );
  }

  /// A weave can punch holes in the brightness mask, so one cloth becomes
  /// many tiny blobs. Ignore fragments, or merge them, rather than treating
  /// a 2-cell speck as the product.
  List<int> _pickFromBlobs(
    List<List<int>> blobs, {
    required int seedIndex,
    required List<int> Function(List<List<int>>) bestOf,
  }) {
    if (blobs.isEmpty) return const [];

    final interior = blobs.where(_isInteriorBlob).toList();
    // Holey weave is many interior specks of one cloth — merge them so
    // the box is the product, not the brightest patch.
    if (_totalCells(interior) >= 8) return _mergeBlobs(interior);

    final usable = blobs.where(_isUsableBlob).toList();
    if (usable.isNotEmpty) {
      return _blobContaining(usable, seedIndex) ?? bestOf(usable);
    }
    if (_totalCells(blobs) >= 4) return _mergeBlobs(blobs);
    return const [];
  }

  bool _isUsableBlob(List<int> blob) => blob.length >= 8;

  int _totalCells(List<List<int>> blobs) {
    var n = 0;
    for (final blob in blobs) {
      n += blob.length;
    }
    return n;
  }

  List<int> _mergeBlobs(List<List<int>> blobs) {
    final merged = <int>[];
    for (final blob in blobs) {
      merged.addAll(blob);
    }
    return merged;
  }

  bool _isInteriorBlob(List<int> blob) {
    for (final i in blob) {
      final cx = i % _cells;
      final cy = i ~/ _cells;
      if (cx == 0 || cy == 0 || cx == _cells - 1 || cy == _cells - 1) {
        return false;
      }
    }
    return true;
  }

  List<int>? _blobContaining(List<List<int>> blobs, int index) {
    for (final blob in blobs) {
      if (blob.contains(index)) return blob;
    }
    return null;
  }

  List<int> _bestBlob(
    List<List<int>> blobs, {
    required int firstTargetX,
    required int lastTargetX,
    required int firstTargetY,
    required int lastTargetY,
  }) {
    var best = blobs.first;
    var bestScore = -1.0;
    for (final blob in blobs) {
      var inGhost = 0;
      for (final i in blob) {
        final cx = i % _cells;
        final cy = i ~/ _cells;
        if (cx >= firstTargetX &&
            cx <= lastTargetX &&
            cy >= firstTargetY &&
            cy <= lastTargetY) {
          inGhost++;
        }
      }
      final score = inGhost * 4.0 + blob.length;
      if (score > bestScore) {
        bestScore = score;
        best = blob;
      }
    }
    return best;
  }

  List<List<int>> _allBlobs(List<bool> mask) {
    final seen = List<bool>.filled(_cells * _cells, false);
    final blobs = <List<int>>[];
    for (var start = 0; start < mask.length; start++) {
      if (!mask[start] || seen[start]) continue;
      blobs.add(_flood(start, mask, seen));
    }
    return blobs;
  }

  List<int> _flood(int start, List<bool> mask, List<bool> seen) {
    final blob = <int>[];
    final stack = <int>[start];
    seen[start] = true;
    while (stack.isNotEmpty) {
      final i = stack.removeLast();
      blob.add(i);
      final cx = i % _cells;
      const neighbours = [1, -1, _cells, -_cells];
      for (final delta in neighbours) {
        if (delta == 1 && cx == _cells - 1) continue;
        if (delta == -1 && cx == 0) continue;
        final next = i + delta;
        if (next < 0 || next >= mask.length) continue;
        if (!mask[next] || seen[next]) continue;
        seen[next] = true;
        stack.add(next);
      }
    }
    return blob;
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
