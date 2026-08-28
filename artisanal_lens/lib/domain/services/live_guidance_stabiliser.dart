import '../entities/capture_feedback.dart';

/// Holds a suggestion on screen until the camera has agreed with itself for
/// long enough to change it.
///
/// Frame analysis is noisy at the margins: a hand crossing the guide or a
/// half-second of motion blur can flip the verdict for one frame. Showing
/// that raw would make the pill strobe. Each new prompt therefore has to
/// repeat before it replaces what the artisan is reading, and the ready state
/// has to hold for longer still, because telling someone to shoot and then
/// taking it back is the worst version of this mistake.
///
/// Prompts and chips are held separately. Requiring Light, Distance and
/// Centre to all sit still before the pill can change used to freeze a bad
/// opening reading (Too dark / Move in) for seconds while auto-exposure
/// hunted. A 1–2 cm wobble on one chip must not block a real framing change.
///
/// This only ever delays a real measurement — it never invents one.
class LiveGuidanceStabiliser {
  LiveGuidanceStabiliser({
    this.framesToChange = 3,
    this.framesToBecomeReady = 4,
    this.framesToChangeChip = 4,
  });

  /// Consecutive frames a new prompt must persist before it is shown.
  final int framesToChange;

  /// Consecutive frames the frame must be good before the artisan is told to
  /// shoot.
  final int framesToBecomeReady;

  /// Consecutive frames a chip must persist before it flips.
  final int framesToChangeChip;

  CaptureFeedback _shown = const CaptureFeedback.initial();
  String _candidateKey = '';
  int _candidateFrames = 0;
  CaptureFeedback? _pending;

  LightQuality _candLight = LightQuality.good;
  int _candLightFrames = 0;
  DistanceQuality _candDistance = DistanceQuality.unknown;
  int _candDistanceFrames = 0;
  CentreQuality _candCentre = CentreQuality.unknown;
  int _candCentreFrames = 0;

  /// What the artisan is currently reading.
  CaptureFeedback get current => _shown;

  /// Feeds in a freshly measured verdict and returns what should be displayed.
  CaptureFeedback accept(CaptureFeedback measured) {
    final promptKey = measured.prompt.id;

    if (_shown.prompt != CapturePrompt.waiting &&
        promptKey == _shown.prompt.id) {
      _candidateKey = '';
      _candidateFrames = 0;
      _pending = null;
      _shown = CaptureFeedback(
        lightQuality: _holdLight(measured.lightQuality),
        angleQuality: measured.angleQuality,
        prompt: measured.prompt,
        meanLuminance: measured.meanLuminance,
        pitchDegrees: measured.pitchDegrees,
        subjectFillRatio: measured.subjectFillRatio,
        distanceQuality: _holdDistance(measured.distanceQuality),
        centreQuality: _holdCentre(measured.centreQuality),
        productNoun: measured.productNoun,
      );
      return _shown;
    }

    if (promptKey != _candidateKey) {
      _candidateKey = promptKey;
      _candidateFrames = 1;
      _pending = measured;
    } else {
      _candidateFrames++;
      _pending = measured;
    }

    final needed = measured.prompt == CapturePrompt.ready
        ? framesToBecomeReady
        : framesToChange;

    // A single black opening frame must not lock in "too dark" / "move in".
    // Ready is never the first thing shown either.
    if (_shown.prompt == CapturePrompt.waiting &&
        measured.prompt == CapturePrompt.ready) {
      return _shown;
    }

    if (_candidateFrames >= needed) {
      _commit(_pending ?? measured);
    }
    return _shown;
  }

  void _commit(CaptureFeedback measured) {
    _shown = measured;
    _candidateKey = '';
    _candidateFrames = 0;
    _pending = null;
    _candLightFrames = 0;
    _candDistanceFrames = 0;
    _candCentreFrames = 0;
    _candLight = measured.lightQuality;
    _candDistance = measured.distanceQuality;
    _candCentre = measured.centreQuality;
  }

  LightQuality _holdLight(LightQuality incoming) {
    if (incoming == _shown.lightQuality) {
      _candLightFrames = 0;
      return incoming;
    }
    if (incoming != _candLight) {
      _candLight = incoming;
      _candLightFrames = 1;
      return _shown.lightQuality;
    }
    _candLightFrames++;
    if (_candLightFrames >= framesToChangeChip) {
      _candLightFrames = 0;
      return incoming;
    }
    return _shown.lightQuality;
  }

  DistanceQuality _holdDistance(DistanceQuality incoming) {
    if (incoming == _shown.distanceQuality) {
      _candDistanceFrames = 0;
      return incoming;
    }
    if (incoming != _candDistance) {
      _candDistance = incoming;
      _candDistanceFrames = 1;
      return _shown.distanceQuality;
    }
    _candDistanceFrames++;
    if (_candDistanceFrames >= framesToChangeChip) {
      _candDistanceFrames = 0;
      return incoming;
    }
    return _shown.distanceQuality;
  }

  CentreQuality _holdCentre(CentreQuality incoming) {
    if (incoming == _shown.centreQuality) {
      _candCentreFrames = 0;
      return incoming;
    }
    if (incoming != _candCentre) {
      _candCentre = incoming;
      _candCentreFrames = 1;
      return _shown.centreQuality;
    }
    _candCentreFrames++;
    if (_candCentreFrames >= framesToChangeChip) {
      _candCentreFrames = 0;
      return incoming;
    }
    return _shown.centreQuality;
  }

  /// Drops back to the opening state, e.g. after switching lens.
  void reset() {
    _shown = const CaptureFeedback.initial();
    _candidateKey = '';
    _candidateFrames = 0;
    _pending = null;
    _candLightFrames = 0;
    _candDistanceFrames = 0;
    _candCentreFrames = 0;
    _candLight = LightQuality.good;
    _candDistance = DistanceQuality.unknown;
    _candCentre = CentreQuality.unknown;
  }
}
