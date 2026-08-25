import 'photography_guideline.dart';

/// Camera angle options offered by the technique presets.
///
/// Source: "The Artisanal Lens" deck — Photography Technique Presets § Angle.
enum CameraAngle {
  eyeLevel(
    id: 'eye_level',
    label: 'Eye-level',
    hint: 'Hold the phone at the height of the product, straight on.',
  ),
  overheadFlatLay(
    id: 'overhead',
    label: 'Overhead (flat lay)',
    hint: 'Stand over the product and point the phone straight down.',
  ),
  lowAngle(
    id: 'low_angle',
    label: 'Low angle',
    hint: 'Lower the phone below the product and tilt slightly upward.',
  ),
  macroCloseUp(
    id: 'macro',
    label: 'Macro close-up',
    hint: 'Move close until the weave fills the frame, then tap to focus.',
  );

  const CameraAngle({
    required this.id,
    required this.label,
    required this.hint,
  });

  final String id;
  final String label;
  final String hint;

  /// Target pitch of the device, in degrees from horizontal, used by the live
  /// angle indicator on the capture screen.
  ///
  /// 0° means the phone is upright (screen vertical); 90° means it is pointing
  /// straight down at the floor.
  double get targetPitchDegrees => switch (this) {
        CameraAngle.eyeLevel => 0,
        CameraAngle.overheadFlatLay => 90,
        CameraAngle.lowAngle => -20,
        CameraAngle.macroCloseUp => 45,
      };

  /// How far the live pitch may drift from [targetPitchDegrees] before the
  /// angle chip flips out of its "OK" state.
  double get pitchToleranceDegrees => switch (this) {
        CameraAngle.macroCloseUp => 25,
        _ => 12,
      };
}

/// Lighting setups offered by the technique presets.
///
/// Source: deck § Lighting, refined by the user-testing finding that artisans
/// could not identify good light unaided (BTP §8.1).
enum LightingSetup {
  softWindowLight(
    id: 'soft_window',
    label: 'Soft window light',
    hint: 'Place the product beside a window, not under a bulb.',
  ),
  diffusedDaylight(
    id: 'diffused_daylight',
    label: 'Diffused daylight',
    hint: 'Shoot outdoors in open shade, with light coming from one side.',
  ),
  avoidHarshMidday(
    id: 'avoid_midday',
    label: 'Avoid harsh midday sun',
    hint: 'Wait until after 3 PM — overhead sun washes out the colour.',
  ),
  backlightForSheer(
    id: 'backlight_sheer',
    label: 'Backlight for sheer fabrics',
    hint: 'Put the light behind the fabric to show how much passes through.',
  );

  const LightingSetup({
    required this.id,
    required this.label,
    required this.hint,
  });

  final String id;
  final String label;
  final String hint;

  /// Backlighting is deliberate for sheer fabrics, so the capture screen must
  /// not warn about it in that preset.
  ///
  /// Source: BTP §8.2 live prompt "Backlight detected".
  bool get expectsBacklight => this == LightingSetup.backlightForSheer;
}

/// Composition rules offered by the technique presets.
///
/// Source: deck § Composition.
enum CompositionRule {
  ruleOfThirds(
    id: 'rule_of_thirds',
    label: 'Rule of thirds',
    hint: 'Line the border up with the top third of the grid.',
  ),
  centeredProduct(
    id: 'centered',
    label: 'Centered product',
    hint: 'Keep the product in the middle box of the grid.',
  ),
  negativeSpaceAroundFolds(
    id: 'negative_space',
    label: 'Negative space around folds',
    hint: 'Leave empty space around the folds so they read clearly.',
  ),
  leadingFabricLines(
    id: 'leading_lines',
    label: 'Leading fabric lines',
    hint: 'Lay the folds along the diagonal guides.',
  ),

  /// Photography Guide — Texture & Weave: texture stays in the centre.
  centerFocus(
    id: 'center_focus',
    label: 'Centre focus',
    hint: 'Keep the texture in the centre of the frame.',
  ),

  /// Photography Guide — Embroidery & Border: detail stays inside the frame.
  detailFrame(
    id: 'detail_frame',
    label: 'Detail frame',
    hint: 'Keep the embroidery inside the highlighted frame.',
  );

  const CompositionRule({
    required this.id,
    required this.label,
    required this.hint,
  });

  final String id;
  final String label;
  final String hint;
}

/// The grid drawn over the live camera feed.
///
/// Source: BTP §7.3 preset definitions — each preset names its own grid type.
enum GridOverlayType {
  /// 3x3 rule-of-thirds grid.
  ruleOfThirds,

  /// Centre box that guides the artisan to focus on a small section.
  centerFocus,

  /// Diagonal guides that the fabric flow should follow.
  leadingLines,

  /// Small rectangle framing an embroidery or border detail, with diagonal
  /// leading lines (Photography Guide Preset 4).
  detailFrame,

  /// Horizontal guides for aligning folds, with diagonal assists
  /// (Photography Guide Preset 5).
  horizontalFolds,
}

/// The angle + lighting + composition + grid combination that a fold preset
/// loads automatically.
///
/// Source: deck § Fold & Styling Presets — "Each fold preset pairs
/// automatically with a matching angle, lighting and composition combination".
class TechniquePreset {
  const TechniquePreset({
    required this.angle,
    required this.lighting,
    required this.composition,
    required this.grid,
    this.guidelines = const [],
  });

  final CameraAngle angle;
  final LightingSetup lighting;
  final CompositionRule composition;
  final GridOverlayType grid;

  /// The guidelines this combination puts into practice, surfaced in the UI so
  /// the advice is never anonymous.
  final List<PhotographyGuideline> guidelines;
}
