import 'package:equatable/equatable.dart';

/// Why the app is advising the artisan to wait before shooting.
enum LightingAdvisoryReason {
  /// Sun is overhead — harsh shadows and washed-out colour.
  ///
  /// Source: BTP §8.2 — "not to shoot between 12 PM and 3 PM, when sunlight is
  /// excessively harsh and can result in overexposed or washed-out images."
  overheadSun,

  /// Too little daylight left, or before sunrise.
  tooDark,

  /// Overcast or hazy conditions make the light flat and dim.
  ///
  /// Source: BTP §8.2 — "avoid hazy or cloudy days, when light is too dim".
  hazyOrCloudy,

  /// Conditions are good.
  none,
}

/// Guidance about *when* to shoot, shown on the lighting-and-setup screen ahead
/// of every capture.
///
/// The time-of-day rules run entirely on-device so the advisory still works
/// offline, which the deck requires ("Guides and overlays run locally
/// on-device").
class LightingAdvisory extends Equatable {
  const LightingAdvisory({
    required this.reason,
    required this.headline,
    required this.detail,
    this.suggestedRetryTime,
  });

  const LightingAdvisory.clear()
      : reason = LightingAdvisoryReason.none,
        headline = 'Good light right now',
        detail = 'Natural light is soft enough for clear, true colours.',
        suggestedRetryTime = null;

  final LightingAdvisoryReason reason;
  final String headline;
  final String detail;

  /// When conditions are expected to improve, e.g. 3:30 PM after midday sun.
  final DateTime? suggestedRetryTime;

  bool get shouldWait => reason != LightingAdvisoryReason.none;

  /// Evaluates the time-of-day rules from BTP §8.2 against [now].
  ///
  /// Harsh-sun hours are 12:00–15:00; usable daylight is taken as 06:00–18:00.
  factory LightingAdvisory.forTime(DateTime now) {
    final hour = now.hour;

    if (hour >= 12 && hour < 15) {
      final retry = DateTime(now.year, now.month, now.day, 15, 30);
      return LightingAdvisory(
        reason: LightingAdvisoryReason.overheadSun,
        headline: 'Overhead sun',
        detail:
            'Try taking the photo later when the sunlight is softer. Right now, '
            'the overhead sun may cause harsh shadows on your setup.',
        suggestedRetryTime: retry,
      );
    }

    if (hour < 6 || hour >= 18) {
      final retry = hour >= 18
          ? DateTime(now.year, now.month, now.day + 1, 8)
          : DateTime(now.year, now.month, now.day, 8);
      return LightingAdvisory(
        reason: LightingAdvisoryReason.tooDark,
        headline: 'Not enough daylight',
        detail:
            'There is not enough natural light now. Morning light near a window '
            'gives the truest colours.',
        suggestedRetryTime: retry,
      );
    }

    return const LightingAdvisory.clear();
  }

  @override
  List<Object?> get props => [reason, headline, detail, suggestedRetryTime];
}
