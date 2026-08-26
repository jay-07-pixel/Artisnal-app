import '../entities/capture_feedback.dart';

/// Holds a suggestion on screen until the camera has agreed with itself for
/// long enough to change it.
///
/// Frame analysis is noisy at the margins: a hand crossing the guide or a
/// half-second of motion blur can flip the verdict for one frame. Showing
/// that raw would make the pill strobe. Each new verdict therefore has to
/// repeat before it replaces what the artisan is reading, and the ready state
/// has to hold for longer still, because telling someone to shoot and then
/// taking it back is the worst version of this mistake.
///
/// This only ever delays a real measurement — it never invents one.
class LiveGuidanceStabiliser {
  LiveGuidanceStabiliser({
    this.framesToChange = 2,
    this.framesToBecomeReady = 3,
  });

  /// Consecutive frames a new prompt must persist before it is shown.
  final int framesToChange;

  /// Consecutive frames the frame must be good before the artisan is told to
  /// shoot.
  final int framesToBecomeReady;

  CaptureFeedback _shown = const CaptureFeedback.initial();
  CapturePrompt? _candidate;
  int _candidateFrames = 0;

  /// What the artisan is currently reading.
  CaptureFeedback get current => _shown;

  /// Feeds in a freshly measured verdict and returns what should be displayed.
  CaptureFeedback accept(CaptureFeedback measured) {
    if (measured.prompt == _shown.prompt) {
      _candidate = null;
      _candidateFrames = 0;
      // Same verdict, refreshed numbers.
      _shown = measured;
      return _shown;
    }

    if (measured.prompt != _candidate) {
      _candidate = measured.prompt;
      _candidateFrames = 1;
    } else {
      _candidateFrames++;
    }

    final needed = measured.prompt == CapturePrompt.ready
        ? framesToBecomeReady
        : framesToChange;

    // The very first real verdict replaces the blank opening state at once:
    // there is nothing on screen yet to flicker against.
    final openingFrame = _shown.prompt == CapturePrompt.waiting &&
        measured.prompt != CapturePrompt.ready;

    if (openingFrame || _candidateFrames >= needed) {
      _shown = measured;
      _candidate = null;
      _candidateFrames = 0;
    }
    return _shown;
  }

  /// Drops back to the opening state, e.g. after switching lens.
  void reset() {
    _shown = const CaptureFeedback.initial();
    _candidate = null;
    _candidateFrames = 0;
  }
}
