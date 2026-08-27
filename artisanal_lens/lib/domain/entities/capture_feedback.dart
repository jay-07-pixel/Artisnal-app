import 'package:equatable/equatable.dart';

/// Real-time prompts shown over the camera preview.
///
/// Source: BTP §8.2 "Live prompts on camera" — the exact prompt set added after
/// user testing showed artisans got no feedback on framing or light.
enum CapturePrompt {
  /// Shown before the first analysed frame. Never rendered as ready.
  waiting(
    id: 'waiting',
    message: '',
    isBlocking: true,
  ),

  /// Nothing product-like is in the frame at all.
  noProduct(
    id: 'no_product',
    message: 'Place the {product} in view',
    isBlocking: true,
  ),

  /// Something is there, but almost none of it is inside the guide.
  moveIntoFrame(
    id: 'move_into_frame',
    message: 'Move the {product} into the frame',
    isBlocking: true,
  ),

  /// The product runs off the edge of the picture.
  keepInsideFrame(
    id: 'keep_inside_frame',
    message: 'Keep the {product} inside the frame',
    isBlocking: true,
  ),

  /// Folds should be parallel to the horizontal guides.
  alignWithHorizontalGuides(
    id: 'align_horizontal',
    message: 'Line the folds up with the horizontal guides',
    isBlocking: true,
  ),

  /// Fabric should run along the diagonal guides.
  alignWithDiagonalGuides(
    id: 'align_diagonal',
    message: 'Let the fabric follow the diagonal guides',
    isBlocking: true,
  ),

  /// The frame is too smeared to judge anything else from.
  holdSteady(
    id: 'hold_steady',
    message: 'Hold the phone steady',
    isBlocking: true,
  ),
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
    message: 'Center the {product}',
    isBlocking: true,
  ),
  keepTextureInCentre(
    id: 'keep_texture_centre',
    message: 'Keep the texture in the centre',
    isBlocking: true,
  ),
  keepBorderInsideFrame(
    id: 'keep_border_inside',
    message: 'Keep the border inside the frame',
    isBlocking: true,
  ),
  keepFoldsVisible(
    id: 'keep_folds_visible',
    message: 'Keep the folds visible',
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
  lowLight(
    id: 'low_light',
    message: 'Light is low — move nearer a window',
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
    message: 'Ready to capture',
    isBlocking: false,
  );

  const CapturePrompt({
    required this.id,
    required this.message,
    required this.isBlocking,
  });

  final String id;

  /// The prompt's wording, with `{product}` still in place where the message
  /// names what is being photographed.
  final String message;

  /// The wording with `{product}` resolved to the category's own noun, so a
  /// saree is called a saree and a cushion cover a cushion cover.
  String messageFor(String product) =>
      message.replaceAll('{product}', product);

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
  low(label: 'Low'),
  good(label: 'OK'),
  tooBright(label: 'Bright');

  const LightQuality({required this.label});

  final String label;

  bool get isAcceptable => this == LightQuality.good;
}

/// How far the product sits from a well-filled ghost frame.
enum DistanceQuality {
  unknown(label: '—'),
  tooFar(label: 'Move closer'),
  ok(label: 'OK'),
  tooClose(label: 'Move back');

  const DistanceQuality({required this.label});

  final String label;

  bool get isAcceptable => this == DistanceQuality.ok;
}

/// Whether the product sits in the middle of the frame.
enum CentreQuality {
  unknown(label: '—'),
  off(label: 'Move in'),
  ok(label: 'OK');

  const CentreQuality({required this.label});

  final String label;

  bool get isAcceptable => this == CentreQuality.ok;
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
    this.distanceQuality = DistanceQuality.unknown,
    this.centreQuality = CentreQuality.unknown,
    this.productNoun = 'product',
  });

  /// The state shown before the first frame has been analysed.
  ///
  /// Must not report Ready — opening the camera is not a framing verdict.
  const CaptureFeedback.initial()
      : lightQuality = LightQuality.good,
        angleQuality = AngleQuality.off,
        prompt = CapturePrompt.waiting,
        meanLuminance = 0.5,
        pitchDegrees = 0,
        subjectFillRatio = 0,
        distanceQuality = DistanceQuality.unknown,
        centreQuality = CentreQuality.unknown,
        productNoun = 'product';

  final LightQuality lightQuality;
  final AngleQuality angleQuality;
  final DistanceQuality distanceQuality;
  final CentreQuality centreQuality;

  /// The single most important thing to tell the artisan right now.
  ///
  /// Empty [CapturePrompt.waiting] messages are not drawn.
  final CapturePrompt prompt;

  /// What this category is called, so prompts can name it.
  final String productNoun;

  /// The prompt as the artisan reads it.
  String get message => prompt.messageFor(productNoun);

  bool get hasVisiblePrompt => message.trim().isNotEmpty;

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
        distanceQuality,
        centreQuality,
        productNoun,
      ];
}
