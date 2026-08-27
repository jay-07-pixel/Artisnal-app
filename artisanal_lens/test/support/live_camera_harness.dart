import 'package:artisanal_lens/domain/entities/capture_feedback.dart';
import 'package:artisanal_lens/domain/entities/preset_capture_guidance.dart';
import 'package:artisanal_lens/domain/entities/shot_set.dart';
import 'package:artisanal_lens/features/capture/camera_controller.dart';
import 'package:artisanal_lens/features/capture/capture_session_controller.dart';
import 'package:artisanal_lens/features/home/shot_sets_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'test_l10n.dart';

/// A session frozen at the state under test.
class SeededSession extends CaptureSessionController {
  SeededSession(this._seed);

  final CaptureSession _seed;

  @override
  CaptureSession build() => _seed;
}

/// A camera that never touches the plugin.
///
/// Widget tests have no camera, so the real controller would report
/// "unavailable". This stands in for the hardware only: the verdict it
/// publishes is whatever the test hands it, and how that verdict is reached
/// from real pixels is covered separately against the analyser itself.
class FakeGuidedCamera extends GuidedCameraController {
  FakeGuidedCamera(this._seed);

  final GuidedCameraState _seed;

  @override
  GuidedCameraState build() => _seed;

  @override
  Future<void> start(PresetCaptureGuidance guidance) async {}
}

/// A verdict shaped like one the analyser has just produced from a frame.
CaptureFeedback measuredFeedback(
  CapturePrompt prompt, {
  String productNoun = 'product',
}) =>
    CaptureFeedback(
      lightQuality: LightQuality.good,
      angleQuality: AngleQuality.ok,
      prompt: prompt,
      meanLuminance: 0.5,
      pitchDegrees: 0,
      subjectFillRatio: prompt == CapturePrompt.noProduct ? 0 : 0.6,
      productNoun: productNoun,
    );

ShotSet testSet({required String id, required String categoryId}) => ShotSet(
      id: id,
      productName: 'Test product',
      categoryId: categoryId,
      createdAt: DateTime(2026, 8, 26),
    );

/// Wraps [child] with a seeded session, shot set and camera state.
Widget cameraHarness({
  required CaptureSession session,
  required String categoryId,
  required Widget child,
  CaptureFeedback feedback = const CaptureFeedback.initial(),
}) {
  return ProviderScope(
    overrides: [
      captureSessionProvider.overrideWith(() => SeededSession(session)),
      shotSetProvider.overrideWith((ref, id) {
        return testSet(id: id, categoryId: categoryId);
      }),
      guidedCameraProvider.overrideWith(
        () => FakeGuidedCamera(
          GuidedCameraState(
            status: CameraStatus.unavailable,
            feedback: feedback,
            errorMessage: 'No camera in tests',
          ),
        ),
      ),
    ],
    child: l10nApp(home: child),
  );
}
