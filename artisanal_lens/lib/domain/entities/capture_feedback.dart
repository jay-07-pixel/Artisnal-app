import 'package:equatable/equatable.dart';

/// Real-time prompts shown over the camera preview.
///
/// Source: BTP §8.2 "Live prompts on camera" — the exact prompt set added after
/// user testing showed artisans got no feedback on framing or light.
enum CapturePrompt {
  moveCloser(
    id: 'move_closer',
    message: 'Move closer',
    isBlocking: true,
  ),
  moveFurther(
    id: 'move_further',
    message: 'Move further from subject',
    isBlocking: true,
  ),
  centerSubject(
    id: 'center_subject',
    message: 'Center your subject',
    isBlocking: true,
  ),
  backlightDetected(
    id: 'backlight',
    message: 'Backlight detected',
    isBlocking: true,
  ),
  tooDark(
    id: 'too_dark',
    message: 'Too dark — move near a window or outside',
    isBlocking: true,
  ),
  tooBright(
    id: 'too_bright',
    message: 'Too bright — move into open shade',
    isBlocking: true,
  ),
  tiltPhone(
    id: 'tilt_phone',
    message: 'Tilt the phone to match the angle guide',
    isBlocking: true,
  ),
  ready(
    id: 'ready',
    message: 'Ready',
    isBlocking: false,
  );

  const CapturePrompt({
    required this.id,
    required this.message,
    required this.isBlocking,
  });

  final String id;
  final String message;

  /// Whether this prompt indicates the frame is not yet good enough to shoot.
  ///
  /// The shutter stays enabled regardless — user testing showed artisans need
  /// to be able to override guidance — but a blocking prompt is shown in the
  /// warning style rather than the ready style.
  final bool isBlocking;
}

/// How good the light currently is, driven by mean luminance of the preview.
///
/// Rendered as the "Light: Good" chip in the deck's guided-capture screen.
enum LightQuality {
  tooDark(label: 'Too dark'),
  good(label: 'Good'),
  tooBright(label: 'Too bright');

  const LightQuality({required this.label});

  final String label;

  bool get isAcceptable => this == LightQuality.good;
}

/// Whether the device pitch matches the angle the preset asks for.
///
/// Rendered as the "Angle: OK" chip in the deck's guided-capture screen.
enum AngleQuality {
  off(label: 'Off'),
  ok(label: 'OK');

  const AngleQuality({required this.label});

  final String label;

  bool get isAcceptable => this == AngleQuality.ok;
}

/// A single snapshot of live capture analysis, recomputed as frames arrive.
class CaptureFeedback extends Equatable {
  const CaptureFeedback({
    required this.lightQuality,
    required this.angleQuality,
    required this.prompt,
    required this.meanLuminance,
    required this.pitchDegrees,
    required this.subjectFillRatio,
  });

  /// The neutral state shown before the first frame has been analysed.
  const CaptureFeedback.initial()
      : lightQuality = LightQuality.good,
        angleQuality = AngleQuality.ok,
        prompt = CapturePrompt.ready,
        meanLuminance = 0.5,
        pitchDegrees = 0,
        subjectFillRatio = 0;

  final LightQuality lightQuality;
  final AngleQuality angleQuality;

  /// The single most important thing to tell the artisan right now.
  final CapturePrompt prompt;

  /// Mean luminance of the preview frame, normalised to 0..1.
  final double meanLuminance;

  /// Current device pitch in degrees from vertical.
  final double pitchDegrees;

  /// Estimated share of the ghost frame the subject occupies, 0..1.
  final double subjectFillRatio;

  /// True when framing, light and angle are all within tolerance.
  bool get isReadyToShoot => prompt == CapturePrompt.ready;

  @override
  List<Object?> get props => [
        lightQuality,
        angleQuality,
        prompt,
        meanLuminance,
        pitchDegrees,
        subjectFillRatio,
      ];
}
