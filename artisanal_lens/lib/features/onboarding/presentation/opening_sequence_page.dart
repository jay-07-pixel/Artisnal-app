import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimens.dart';
import '../../../app/theme/app_typography.dart';

/// The opening sequence: a saree is dropped, allowed to settle, framed by the
/// capture guide, photographed, and the photograph becomes the app.
///
/// It argues the product in four seconds — *before you take the photo, the app
/// prepares the cloth and shows you what a good photograph looks like* — and
/// then gets out of the way. Tapping anywhere skips straight to Home, which is
/// what a returning artisan will do every time after the first.
///
/// Everything is painted rather than played from a video so it stays a few
/// kilobytes of code, scales to any screen, and uses the real palette.
class OpeningSequencePage extends StatefulWidget {
  const OpeningSequencePage({super.key});

  @override
  State<OpeningSequencePage> createState() => _OpeningSequencePageState();
}

class _OpeningSequencePageState extends State<OpeningSequencePage>
    with SingleTickerProviderStateMixin {
  /// Kept under five seconds deliberately: this runs on every cold start.
  static const Duration _duration = Duration(milliseconds: 4200);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _duration,
  );

  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _finish();
    });

    // Deliberately not started here. The widget is built while the platform
    // launch screen is still covering the window, and an AnimationController
    // advances on wall-clock time — so starting now means the sequence plays
    // out unseen behind the splash and the artisan lands on Home having
    // watched nothing. Waiting for the first frame means it starts when there
    // is actually something on screen to watch.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    if (_leaving || !mounted) return;
    _leaving = true;
    context.goNamed(AppRoute.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _finish,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            return Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(painter: _OpeningPainter(t)),
                _Wordmark(t: t),
                _StatusChips(t: t),
                _SkipHint(t: t),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- timeline ---

/// Progress through the window [start, end], clamped and eased.
double _seg(double t, double start, double end, [Curve curve = Curves.linear]) {
  if (end <= start) return t >= end ? 1 : 0;
  final raw = ((t - start) / (end - start)).clamp(0.0, 1.0);
  return curve.transform(raw);
}

/// The six scenes, as fractions of the whole sequence.
///
/// They overlap on purpose — the frame starts drawing while the cloth is still
/// settling — because hard cuts between stages read as six animations rather
/// than one.
abstract final class _Scene {
  static const double spaceIn = 0.00; //  0.00-0.12  empty photography space
  static const double dropStart = 0.11; //  0.11-0.36  the saree falls
  static const double dropEnd = 0.36;
  static const double unfoldStart = 0.33; //  0.33-0.57  it opens and settles
  static const double unfoldEnd = 0.57;
  static const double guideStart = 0.55; //  0.55-0.74  the capture guide
  static const double guideEnd = 0.74;
  static const double focusStart = 0.72; //  0.72-0.86  focus lock + shutter
  static const double shutterAt = 0.845;
  static const double handoffStart = 0.86; // 0.86-1.00  becomes the app
}

// ----------------------------------------------------------------- painter ---

class _OpeningPainter extends CustomPainter {
  const _OpeningPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Scene 6 pulls the whole composition up into the frame as it hands over,
    // so the last thing on screen is the photograph filling the viewport.
    final handoff = _seg(t, _Scene.handoffStart, 1, Curves.easeInCubic);

    canvas.save();
    if (handoff > 0) {
      final scale = 1 + handoff * 0.9;
      canvas.translate(w / 2, h * 0.46);
      canvas.scale(scale);
      canvas.translate(-w / 2, -h * 0.46);
    }

    _paintSpace(canvas, size);
    _paintCloth(canvas, size);
    _paintGuide(canvas, size);

    canvas.restore();

    _paintShutter(canvas, size);
    _paintHandoffVeil(canvas, size, handoff);
  }

  // --------------------------------------------------- scene 1: the space ---

  /// A warm, empty corner of a workshop: a wash of light from above, a surface
  /// to lay cloth on, and a suggestion of weave in the backdrop.
  void _paintSpace(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fade = _seg(t, _Scene.spaceIn, 0.14, Curves.easeOut);
    final surfaceY = h * 0.72;

    // Backdrop wash — light falling from the upper left, as a window would.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = _gradient(
          from: Offset(w * 0.28, -h * 0.1),
          to: Offset(w, h),
          colors: [
            AppColors.background,
            AppColors.backgroundAlt,
            AppColors.surface,
          ],
          stops: const [0, 0.55, 1],
        ),
    );

    // The surface the cloth is arranged on.
    final surfacePaint = Paint()
      ..shader = _gradient(
        from: Offset(0, surfaceY),
        to: Offset(0, h),
        colors: [
          AppColors.surfaceSand.withValues(alpha: 0.95 * fade),
          AppColors.surfaceMuted.withValues(alpha: 0.85 * fade),
        ],
      );
    canvas.drawRect(Rect.fromLTRB(0, surfaceY, w, h), surfacePaint);
    canvas.drawLine(
      Offset(0, surfaceY),
      Offset(w, surfaceY),
      Paint()
        ..color = AppColors.border.withValues(alpha: 0.55 * fade)
        ..strokeWidth = 1,
    );

    // Textile-inspired detail: a faint warp/weft in the backdrop. Kept very
    // low contrast so it reads as texture, not as pattern.
    final weave = Paint()
      ..color = AppColors.border.withValues(alpha: 0.16 * fade)
      ..strokeWidth = 1;
    const gap = 26.0;
    for (var x = gap; x < w; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, surfaceY), weave);
    }
    for (var y = gap; y < surfaceY; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(w, y), weave);
    }
  }

  // ------------------------------------------- scenes 2 & 3: the saree ---

  /// The cloth itself, drawn as a run of vertical panels.
  ///
  /// Real fabric reads as light catching successive folds, so each panel takes
  /// its tone from a sine running across the width. As the saree opens, the
  /// fold amplitude decays and the panels spread — which is what makes it look
  /// like textile relaxing rather than a rectangle being scaled.
  void _paintCloth(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final drop = _seg(t, _Scene.dropStart, _Scene.dropEnd, Curves.easeInCubic);
    if (drop <= 0) return;

    final unfold =
        _seg(t, _Scene.unfoldStart, _Scene.unfoldEnd, Curves.easeOutCubic);

    // It arrives as a folded bundle and opens into a drape. Width leads and
    // height follows, which is how a folded saree actually falls open — the
    // two curves being offset is most of what sells it as cloth.
    final openWidth = Curves.easeOutCubic.transform(
      (unfold / 0.75).clamp(0.0, 1.0),
    );
    final openHeight = Curves.easeOutCubic.transform(
      ((unfold - 0.18) / 0.82).clamp(0.0, 1.0),
    );

    final bundleWidth = math.min(w * 0.30, 132.0);
    final bundleHeight = bundleWidth * 0.52;
    final fullWidth = math.min(w * 0.66, 320.0);
    final fullHeight = h * 0.32;

    final width = _lerp(bundleWidth, fullWidth, openWidth);
    final clothHeight = _lerp(bundleHeight, fullHeight, openHeight);

    final restTop = h * 0.30;
    final cx = w / 2;

    // Fall, then a small damped settle rather than a dead stop.
    final settle = math.exp(-7 * unfold) * math.sin(unfold * math.pi * 3.2);
    final top = _lerp(-bundleHeight * 2.2, restTop, drop) + settle * 9;

    // Tight creases while folded, relaxed folds once open.
    final foldAmplitude = _lerp(7.0, 11.0, openWidth) + settle * 3;
    final foldCount = _lerp(1.6, 4.0, openWidth);
    final tilt = _lerp(-0.14, 0.0, openWidth) + settle * 0.012;

    // Contact shadow — tight and dark while folded, wide and soft once open.
    final shadowY = top + clothHeight;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, shadowY + 8),
        width: width * _lerp(0.80, 1.10, openWidth),
        height: _lerp(12.0, 24.0, openWidth),
      ),
      Paint()
        ..color = AppColors.textPrimary.withValues(alpha: 0.13 * drop)
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          _lerp(5.0, 13.0, openWidth),
        ),
    );

    canvas.save();
    canvas.translate(cx, top);
    canvas.rotate(tilt);
    canvas.translate(-cx, -top);

    const panels = 30;
    final panelWidth = width / panels;
    final left = cx - width / 2;

    for (var i = 0; i < panels; i++) {
      final u = i / (panels - 1);
      final phase = u * math.pi * foldCount;

      // Where this panel sits, pushed slightly by the fold it belongs to.
      final x = left + i * panelWidth + math.sin(phase) * foldAmplitude * 0.16;

      // The cloth hangs: a shallow sag across the top, a looser wavy hem.
      final sag = (1 - math.cos((u - 0.5) * math.pi * 2)) * 5 * openHeight;
      final panelTop = top + sag;
      final hem = math.sin(phase * 1.15 + 0.6) * foldAmplitude * 0.34 * openHeight;
      final panelBottom = panelTop + clothHeight + hem;

      // Light across the folds.
      final shade = 0.5 + 0.5 * math.sin(phase - 0.5);
      final base = Color.lerp(
        AppColors.primary,
        AppColors.primaryLight,
        shade,
      )!;

      final path = Path()
        ..moveTo(x, panelTop)
        ..lineTo(x + panelWidth * 1.25, panelTop)
        ..lineTo(x + panelWidth * 1.25, panelBottom)
        ..lineTo(x, panelBottom)
        ..close();

      canvas.drawPath(path, Paint()..color = base);

      // The pallu: a woven band near the hem, the part an artisan most wants
      // photographed. It only resolves as the cloth opens.
      if (openHeight > 0.35) {
        final bandHeight = clothHeight * 0.13;
        final bandTop = panelBottom - bandHeight - 6;
        final bandFade = ((openHeight - 0.35) / 0.65).clamp(0.0, 1.0);
        final bandPaint = Paint()
          ..color = Color.lerp(
            AppColors.surfaceSand,
            AppColors.warning,
            0.22 + shade * 0.28,
          )!
              .withValues(alpha: 0.92 * bandFade);
        canvas.drawRect(
          Rect.fromLTRB(x, bandTop, x + panelWidth * 1.25, panelBottom - 6),
          bandPaint,
        );
        // A darker weft line through the band so it reads as woven.
        canvas.drawLine(
          Offset(x, bandTop + bandHeight * 0.45),
          Offset(x + panelWidth * 1.25, bandTop + bandHeight * 0.45),
          Paint()
            ..color = AppColors.primary.withValues(alpha: 0.40 * bandFade)
            ..strokeWidth = 1.4,
        );

        // Fringe at the very bottom edge.
        if (i.isEven) {
          canvas.drawLine(
            Offset(x + panelWidth * 0.6, panelBottom - 6),
            Offset(x + panelWidth * 0.6, panelBottom + 5 * bandFade),
            Paint()
              ..color = AppColors.primary.withValues(alpha: 0.70 * bandFade)
              ..strokeWidth = 1.2,
          );
        }
      }
    }

    // A soft sheen down the lit side, so the cloth has a surface rather than
    // being flat colour.
    canvas.drawRect(
      Rect.fromLTWH(left, top, width, clothHeight),
      Paint()
        ..blendMode = BlendMode.plus
        ..shader = _gradient(
          from: Offset(left, top),
          to: Offset(left + width, top + clothHeight),
          colors: [
            AppColors.white.withValues(alpha: 0.10 * openWidth),
            AppColors.white.withValues(alpha: 0.0),
          ],
        ),
    );

    canvas.restore();
  }

  // ------------------------------------------- scene 4: the capture guide ---

  /// The ghost frame, thirds grid, crosshair and focus brackets — the same
  /// vocabulary as the real Guided Capture screen, so the opening teaches the
  /// screen the artisan is about to use.
  void _paintGuide(Canvas canvas, Size size) {
    final guide = _seg(t, _Scene.guideStart, _Scene.guideEnd, Curves.easeOut);
    if (guide <= 0) return;

    final w = size.width;
    final h = size.height;
    final frame = Rect.fromCenter(
      center: Offset(w / 2, h * 0.46),
      width: math.min(w * 0.78, 340),
      height: h * 0.46,
    );

    // Thirds grid, drawn inside the frame only.
    final gridPaint = Paint()
      ..color = AppColors.textSecondary.withValues(alpha: 0.22 * guide)
      ..strokeWidth = 1;
    for (var i = 1; i < 3; i++) {
      final dx = frame.left + frame.width * i / 3;
      final dy = frame.top + frame.height * i / 3;
      canvas.drawLine(Offset(dx, frame.top), Offset(dx, frame.bottom), gridPaint);
      canvas.drawLine(Offset(frame.left, dy), Offset(frame.right, dy), gridPaint);
    }

    // The ghost frame itself, drawn on as a dashed outline.
    final focus = _seg(t, _Scene.focusStart, _Scene.shutterAt, Curves.easeOut);
    final locked = focus > 0.55;
    final strokeColor = locked ? AppColors.success : AppColors.primary;
    _dashedRRect(
      canvas,
      RRect.fromRectAndRadius(
        frame,
        const Radius.circular(AppDimens.radiusMd),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = strokeColor.withValues(alpha: 0.85 * guide),
      progress: guide,
    );

    // Corner brackets converge as focus locks.
    final inset = _lerp(26.0, 0.0, focus);
    const arm = 18.0;
    final bracket = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..color = strokeColor.withValues(alpha: guide);
    for (final corner in [
      (frame.topLeft.translate(inset, inset), 1.0, 1.0),
      (frame.topRight.translate(-inset, inset), -1.0, 1.0),
      (frame.bottomLeft.translate(inset, -inset), 1.0, -1.0),
      (frame.bottomRight.translate(-inset, -inset), -1.0, -1.0),
    ]) {
      final (point, sx, sy) = corner;
      canvas.drawLine(point, point.translate(arm * sx, 0), bracket);
      canvas.drawLine(point, point.translate(0, arm * sy), bracket);
    }

    // Centre crosshair.
    final centre = frame.center;
    final cross = Paint()
      ..color = AppColors.warning.withValues(alpha: 0.9 * guide)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(centre.translate(-9, 0), centre.translate(9, 0), cross);
    canvas.drawLine(centre.translate(0, -9), centre.translate(0, 9), cross);
  }

  // ------------------------------------------------- scene 5: the shutter ---

  /// One short, soft flash. Not a strobe — a shutter opening and closing.
  void _paintShutter(Canvas canvas, Size size) {
    const half = 0.022;
    final d = (t - _Scene.shutterAt).abs();
    if (d > half) return;
    final intensity = (1 - d / half) * 0.62;
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.white.withValues(alpha: intensity),
    );
  }

  /// Scene 6 fades to the app's own background so the first real screen looks
  /// like it grew out of the photograph rather than replacing it.
  void _paintHandoffVeil(Canvas canvas, Size size, double handoff) {
    if (handoff <= 0) return;
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = AppColors.background.withValues(alpha: handoff.clamp(0, 1)),
    );
  }

  /// Draws [rrect] as a dash pattern, revealed by [progress].
  void _dashedRRect(
    Canvas canvas,
    RRect rrect,
    Paint paint, {
    required double progress,
  }) {
    const dash = 9.0;
    const gap = 7.0;
    final metrics = (Path()..addRRect(rrect)).computeMetrics();
    for (final metric in metrics) {
      final reveal = metric.length * progress;
      var distance = 0.0;
      while (distance < reveal) {
        final next = math.min(distance + dash, reveal);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _OpeningPainter oldDelegate) =>
      oldDelegate.t != t;
}

// ------------------------------------------------------------ small parts ---

Shader _gradient({
  required Offset from,
  required Offset to,
  required List<Color> colors,
  List<double>? stops,
}) {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: colors,
    stops: stops,
  ).createShader(Rect.fromPoints(from, to));
}

double _lerp(double a, double b, double t) => a + (b - a) * t;

/// The wordmark holds the first beat, then clears out before the guide appears
/// so it never competes with the frame.
class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.t});

  final double t;

  @override
  Widget build(BuildContext context) {
    final show = _seg(t, 0.02, 0.16, Curves.easeOut);
    final hide = _seg(t, 0.19, 0.29, Curves.easeIn);
    final opacity = (show - hide).clamp(0.0, 1.0);
    if (opacity <= 0) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      right: 0,
      top: MediaQuery.sizeOf(context).height * 0.11,
      child: Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(0, 10 * (1 - show)),
          child: Column(
            children: [
              Text(
                'THE ARTISANAL LENS',
                textAlign: TextAlign.center,
                style: AppTypography.overline.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 3.4,
                ),
              ),
              const SizedBox(height: AppDimens.space8),
              Text(
                'Guided photography for handcrafted products',
                textAlign: TextAlign.center,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Light: Good", "Angle: Good", "Frame: Ready" — the readouts the artisan
/// will look for on the real capture screen, arriving one after another.
class _StatusChips extends StatelessWidget {
  const _StatusChips({required this.t});

  final double t;

  static const List<({String label, double at})> _chips = [
    (label: 'Light: Good', at: 0.60),
    (label: 'Angle: Good', at: 0.66),
    (label: 'Frame: Ready', at: 0.72),
  ];

  @override
  Widget build(BuildContext context) {
    final leaving = _seg(t, _Scene.handoffStart, 0.94, Curves.easeIn);
    if (leaving >= 1) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      right: 0,
      bottom: MediaQuery.sizeOf(context).height * 0.12,
      child: Opacity(
        opacity: 1 - leaving,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: AppDimens.space8,
          runSpacing: AppDimens.space8,
          children: [
            for (final chip in _chips)
              _Chip(label: chip.label, progress: _seg(t, chip.at, chip.at + 0.07, Curves.easeOutBack)),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.progress});

  final String label;
  final double progress;

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();
    return Opacity(
      opacity: progress.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: 0.86 + 0.14 * progress.clamp(0.0, 1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 13,
                color: AppColors.white,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: AppTypography.navLabel.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A quiet affordance, held back until the sequence has shown enough to be
/// worth skipping.
class _SkipHint extends StatelessWidget {
  const _SkipHint({required this.t});

  final double t;

  @override
  Widget build(BuildContext context) {
    final show = _seg(t, 0.20, 0.34, Curves.easeOut);
    final hide = _seg(t, _Scene.handoffStart, 0.94, Curves.easeIn);
    final opacity = (show - hide).clamp(0.0, 1.0);
    if (opacity <= 0) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      right: 0,
      bottom: AppDimens.space32,
      child: Opacity(
        opacity: opacity * 0.75,
        child: Text(
          'Tap to skip',
          textAlign: TextAlign.center,
          style: AppTypography.navLabel.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}
