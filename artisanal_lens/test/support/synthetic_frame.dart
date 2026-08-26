import 'dart:math' as math;
import 'dart:typed_data';

/// Which way the woven pattern runs.
enum FabricGrain {
  /// Stripes running left to right, as folds stacked on top of each other do.
  horizontal,

  /// Stripes running top to bottom.
  vertical,

  /// Stripes running corner to corner, as a draped pallu does.
  diagonal,

  /// No dominant direction — a plain weave.
  isotropic,
}

/// Builds luma planes that stand in for a camera pointed at a piece of cloth.
///
/// These are not mocked verdicts: the bytes go through the same
/// [FrameAnalyzer] the phone uses, so a test that moves the cloth in the
/// picture exercises exactly the code path the artisan does.
class SyntheticFrame {
  const SyntheticFrame({
    this.width = 640,
    this.height = 480,
    this.background = 120,
    this.productMid = 150,
    this.contrast = 55,
    this.grain = FabricGrain.isotropic,
    this.stripePeriod = 10,
    this.noise = 4,
    this.defocused = false,
  });

  final int width;
  final int height;

  /// Flat surround the cloth is lying on.
  final int background;

  /// Average brightness of the cloth itself.
  final int productMid;

  /// How strongly the weave modulates that brightness.
  final int contrast;

  final FabricGrain grain;
  final double stripePeriod;

  /// Sensor grain, which every real frame has and which the focus measure
  /// depends on being able to see.
  final int noise;

  /// Smears the weave away, leaving only the broad shape — a defocused or
  /// motion-blurred frame.
  final bool defocused;

  /// Renders the cloth as a rectangle in normalised coordinates.
  Uint8List build({
    double left = 0.2,
    double top = 0.2,
    double right = 0.8,
    double bottom = 0.8,
  }) {
    final luma = Uint8List(width * height);
    final random = math.Random(7);
    final x0 = (left * width).round();
    final x1 = (right * width).round();
    final y0 = (top * height).round();
    final y1 = (bottom * height).round();

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final inProduct = x >= x0 && x < x1 && y >= y0 && y < y1;
        var value = inProduct ? _weave(x, y, random) : background;
        if (noise > 0) {
          value += random.nextInt(noise * 2 + 1) - noise;
        }
        luma[y * width + x] = value.clamp(0, 255);
      }
    }
    return luma;
  }

  int _weave(int x, int y, math.Random random) {
    if (defocused) {
      // Only a slow swell survives a smear; the weave itself is gone.
      final swell = math.sin(2 * math.pi * (x + y) / 120);
      return (productMid + contrast * 0.35 * swell).round();
    }

    final phase = switch (grain) {
      FabricGrain.horizontal => y / stripePeriod,
      FabricGrain.vertical => x / stripePeriod,
      FabricGrain.diagonal => (x + y) / (stripePeriod * math.sqrt2),
      FabricGrain.isotropic => 0.0,
    };

    if (grain == FabricGrain.isotropic) {
      return productMid + random.nextInt(contrast) - contrast ~/ 2;
    }
    return (productMid + contrast * math.sin(2 * math.pi * phase)).round();
  }
}
