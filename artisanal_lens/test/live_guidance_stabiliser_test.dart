import 'package:artisanal_lens/domain/entities/capture_feedback.dart';
import 'package:artisanal_lens/domain/services/live_guidance_stabiliser.dart';
import 'package:flutter_test/flutter_test.dart';

CaptureFeedback verdict(
  CapturePrompt prompt, {
  double luminance = 0.5,
  LightQuality light = LightQuality.good,
  DistanceQuality distance = DistanceQuality.unknown,
  CentreQuality centre = CentreQuality.unknown,
}) =>
    CaptureFeedback(
      lightQuality: light,
      angleQuality: AngleQuality.ok,
      prompt: prompt,
      meanLuminance: luminance,
      pitchDegrees: 0,
      subjectFillRatio: 0.6,
      distanceQuality: distance,
      centreQuality: centre,
      productNoun: 'saree',
    );

/// Two matching frames, which is what it takes to leave waiting.
CaptureFeedback show(LiveGuidanceStabiliser s, CapturePrompt prompt) {
  s.accept(verdict(prompt));
  return s.accept(verdict(prompt));
}

void main() {
  test('the first measured verdict has to repeat before it is shown', () {
    final stabiliser = LiveGuidanceStabiliser();

    expect(stabiliser.current.prompt, CapturePrompt.waiting);
    expect(
      stabiliser.accept(verdict(CapturePrompt.moveCloser)).prompt,
      CapturePrompt.waiting,
    );
    expect(
      stabiliser.accept(verdict(CapturePrompt.moveCloser)).prompt,
      CapturePrompt.moveCloser,
    );
  });

  test('a one-frame flicker does not change what is on screen', () {
    final stabiliser = LiveGuidanceStabiliser();
    show(stabiliser, CapturePrompt.moveCloser);

    // A hand crossing the guide for a single frame.
    expect(
      stabiliser.accept(verdict(CapturePrompt.noProduct)).prompt,
      CapturePrompt.moveCloser,
    );
    expect(
      stabiliser.accept(verdict(CapturePrompt.moveCloser)).prompt,
      CapturePrompt.moveCloser,
    );
  });

  test('a verdict that persists takes over', () {
    final stabiliser = LiveGuidanceStabiliser();
    show(stabiliser, CapturePrompt.moveCloser);

    expect(
      stabiliser.accept(verdict(CapturePrompt.centerSubject)).prompt,
      CapturePrompt.moveCloser,
    );
    expect(
      stabiliser.accept(verdict(CapturePrompt.centerSubject)).prompt,
      CapturePrompt.centerSubject,
    );
  });

  test('ready has to hold for longer than any complaint', () {
    final stabiliser = LiveGuidanceStabiliser();
    show(stabiliser, CapturePrompt.centerSubject);

    stabiliser.accept(verdict(CapturePrompt.ready));
    expect(stabiliser.current.prompt, CapturePrompt.centerSubject);
    stabiliser.accept(verdict(CapturePrompt.ready));
    expect(stabiliser.current.prompt, CapturePrompt.centerSubject);

    expect(
      stabiliser.accept(verdict(CapturePrompt.ready)).prompt,
      CapturePrompt.ready,
    );
  });

  test('opening the camera never jumps straight to ready', () {
    final stabiliser = LiveGuidanceStabiliser();

    expect(
      stabiliser.accept(verdict(CapturePrompt.ready)).prompt,
      CapturePrompt.waiting,
    );
    expect(
      stabiliser.accept(verdict(CapturePrompt.ready)).prompt,
      CapturePrompt.waiting,
    );
  });

  test('a single black opening frame does not lock in too dark', () {
    final stabiliser = LiveGuidanceStabiliser();

    expect(
      stabiliser
          .accept(verdict(CapturePrompt.tooDark, light: LightQuality.tooDark))
          .prompt,
      CapturePrompt.waiting,
    );
    expect(
      stabiliser
          .accept(
            verdict(CapturePrompt.moveCloser, distance: DistanceQuality.tooFar),
          )
          .prompt,
      CapturePrompt.waiting,
    );
    expect(
      stabiliser
          .accept(
            verdict(CapturePrompt.moveCloser, distance: DistanceQuality.tooFar),
          )
          .prompt,
      CapturePrompt.moveCloser,
    );
  });

  test('a flickering centre chip does not freeze a distance change', () {
    final stabiliser = LiveGuidanceStabiliser();
    show(stabiliser, CapturePrompt.moveCloser);

    expect(
      stabiliser
          .accept(
            verdict(
              CapturePrompt.centerSubject,
              centre: CentreQuality.off,
            ),
          )
          .prompt,
      CapturePrompt.moveCloser,
    );
    expect(
      stabiliser
          .accept(
            verdict(
              CapturePrompt.centerSubject,
              centre: CentreQuality.ok,
            ),
          )
          .prompt,
      CapturePrompt.centerSubject,
    );
  });

  test('a one-frame chip flicker does not change Distance on screen', () {
    final stabiliser = LiveGuidanceStabiliser();
    stabiliser.accept(
      verdict(CapturePrompt.moveCloser, distance: DistanceQuality.tooFar),
    );
    expect(
      stabiliser
          .accept(
            verdict(CapturePrompt.moveCloser, distance: DistanceQuality.tooFar),
          )
          .distanceQuality,
      DistanceQuality.tooFar,
    );

    expect(
      stabiliser
          .accept(
            verdict(CapturePrompt.moveCloser, distance: DistanceQuality.ok),
          )
          .distanceQuality,
      DistanceQuality.tooFar,
    );
    expect(
      stabiliser
          .accept(
            verdict(CapturePrompt.moveCloser, distance: DistanceQuality.ok),
          )
          .distanceQuality,
      DistanceQuality.ok,
    );
  });

  test('numbers keep updating while the verdict stands', () {
    final stabiliser = LiveGuidanceStabiliser();
    show(stabiliser, CapturePrompt.moveCloser);

    final refreshed =
        stabiliser.accept(verdict(CapturePrompt.moveCloser, luminance: 0.7));

    expect(refreshed.prompt, CapturePrompt.moveCloser);
    expect(refreshed.meanLuminance, 0.7);
  });

  test('switching lens clears the verdict rather than carrying it over', () {
    final stabiliser = LiveGuidanceStabiliser();
    show(stabiliser, CapturePrompt.moveCloser);

    stabiliser.reset();

    expect(stabiliser.current.prompt, CapturePrompt.waiting);
    expect(stabiliser.current.isReadyToShoot, isFalse);
  });
}
