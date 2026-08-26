import 'package:artisanal_lens/domain/entities/capture_feedback.dart';
import 'package:artisanal_lens/domain/services/live_guidance_stabiliser.dart';
import 'package:flutter_test/flutter_test.dart';

CaptureFeedback verdict(CapturePrompt prompt, {double luminance = 0.5}) =>
    CaptureFeedback(
      lightQuality: LightQuality.good,
      angleQuality: AngleQuality.ok,
      prompt: prompt,
      meanLuminance: luminance,
      pitchDegrees: 0,
      subjectFillRatio: 0.6,
      productNoun: 'saree',
    );

void main() {
  test('the first measured verdict appears immediately', () {
    final stabiliser = LiveGuidanceStabiliser();

    expect(stabiliser.current.prompt, CapturePrompt.waiting);
    expect(
      stabiliser.accept(verdict(CapturePrompt.moveCloser)).prompt,
      CapturePrompt.moveCloser,
    );
  });

  test('a one-frame flicker does not change what is on screen', () {
    final stabiliser = LiveGuidanceStabiliser();
    stabiliser.accept(verdict(CapturePrompt.moveCloser));

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
    stabiliser.accept(verdict(CapturePrompt.moveCloser));

    stabiliser.accept(verdict(CapturePrompt.centerSubject));
    expect(
      stabiliser.accept(verdict(CapturePrompt.centerSubject)).prompt,
      CapturePrompt.centerSubject,
    );
  });

  test('ready has to hold for longer than any complaint', () {
    final stabiliser = LiveGuidanceStabiliser();
    stabiliser.accept(verdict(CapturePrompt.centerSubject));

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
  });

  test('numbers keep updating while the verdict stands', () {
    final stabiliser = LiveGuidanceStabiliser();
    stabiliser.accept(verdict(CapturePrompt.moveCloser, luminance: 0.5));

    final refreshed =
        stabiliser.accept(verdict(CapturePrompt.moveCloser, luminance: 0.7));

    expect(refreshed.prompt, CapturePrompt.moveCloser);
    expect(refreshed.meanLuminance, 0.7);
  });

  test('switching lens clears the verdict rather than carrying it over', () {
    final stabiliser = LiveGuidanceStabiliser();
    stabiliser.accept(verdict(CapturePrompt.moveCloser));

    stabiliser.reset();

    expect(stabiliser.current.prompt, CapturePrompt.waiting);
    expect(stabiliser.current.isReadyToShoot, isFalse);
  });
}
