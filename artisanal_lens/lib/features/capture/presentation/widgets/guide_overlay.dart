import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../domain/entities/technique_preset.dart';

/// The ghost frame and grid drawn over the live camera preview.
///
/// Both come from the chosen preset: the grid type is preset-specific
/// (rule of thirds, centre focus, leading lines, detail frame, horizontal
/// folds) and the dashed ghost frame marks where the product should sit.
class GuideOverlay extends StatelessWidget {
  const GuideOverlay({
    required this.grid,
    required this.caption,
    super.key,
  });

  final GridOverlayType grid;

  /// Instruction rendered under the ghost frame, e.g. "Align pallu here".
  /// Empty while the guidance card is carrying the words instead.
  final String caption;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _GuidePainter(grid: grid)),
              ),
              if (caption.trim().isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  // Clears the guidance card that sits above the shutter.
                  bottom: constraints.maxHeight * 0.28,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cameraScrim,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        caption,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          height: 16 / 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _GuidePainter extends CustomPainter {
  const _GuidePainter({required this.grid});

  final GridOverlayType grid;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final framePaint = Paint()
      ..color = AppColors.guideStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    switch (grid) {
      case GridOverlayType.ruleOfThirds:
        _drawThirds(canvas, size, gridPaint);
      case GridOverlayType.centerFocus:
        _drawThirds(canvas, size, gridPaint);
      case GridOverlayType.leadingLines:
        _drawDiagonals(canvas, size, gridPaint);
      case GridOverlayType.detailFrame:
        // Photography Guide Preset 4: detail frame + leading (diagonal) lines.
        _drawDiagonals(canvas, size, gridPaint);
      case GridOverlayType.horizontalFolds:
        // Photography Guide Preset 5: horizontal folds with diagonal assists.
        _drawHorizontals(canvas, size, gridPaint);
        _drawDiagonals(canvas, size, gridPaint);
    }

    // The dashed rectangle is the region the analyser measures, so both read
    // the same numbers off the grid rather than keeping private copies.
    _dashedRect(
      canvas,
      _inset(size, grid.ghostInsetX, grid.ghostInsetY),
      framePaint,
    );
  }

  Rect _inset(Size size, double dx, double dy) => Rect.fromLTRB(
        size.width * dx,
        size.height * dy,
        size.width * (1 - dx),
        size.height * (1 - dy),
      );

  void _drawThirds(Canvas canvas, Size size, Paint paint) {
    for (var i = 1; i < 3; i++) {
      final x = size.width * i / 3;
      final y = size.height * i / 3;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawHorizontals(Canvas canvas, Size size, Paint paint) {
    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawDiagonals(Canvas canvas, Size size, Paint paint) {
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  /// Draws the ghost frame as a dashed rectangle.
  void _dashedRect(Canvas canvas, Rect rect, Paint paint) {
    const dash = 12.0;
    const gap = 8.0;

    void dashedLine(Offset from, Offset to) {
      final delta = to - from;
      final length = delta.distance;
      if (length == 0) return;
      final step = delta / length;
      var travelled = 0.0;
      while (travelled < length) {
        final segment = (travelled + dash).clamp(0.0, length);
        canvas.drawLine(
          from + step * travelled,
          from + step * segment,
          paint,
        );
        travelled += dash + gap;
      }
    }

    dashedLine(rect.topLeft, rect.topRight);
    dashedLine(rect.topRight, rect.bottomRight);
    dashedLine(rect.bottomRight, rect.bottomLeft);
    dashedLine(rect.bottomLeft, rect.topLeft);
  }

  @override
  bool shouldRepaint(covariant _GuidePainter oldDelegate) =>
      oldDelegate.grid != grid;
}
