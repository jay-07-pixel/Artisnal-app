import 'package:equatable/equatable.dart';

import 'fabric_property.dart';
import 'shot_type.dart';
import 'technique_preset.dart';

/// One illustrated step in the setup sequence shown before capture.
///
/// Source: BTP §7.5 "a sequence of illustrated guides appears to help them set
/// up the fabric correctly", revised in §8.2 so that the primary medium is a
/// short video with a transcript rather than static text.
class SetupStep extends Equatable {
  const SetupStep({
    required this.title,
    required this.instruction,
    required this.illustrationAsset,
  });

  final String title;
  final String instruction;
  final String illustrationAsset;

  @override
  List<Object?> get props => [title, instruction, illustrationAsset];
}

/// A fold / styling preset: how the artisan should arrange the product before
/// shooting, paired with the technique preset that the app loads automatically.
///
/// Source: deck § Fold & Styling Presets (per-category fold lists) combined with
/// BTP §7.3, which specifies the grid type, placement, purpose and guidelines
/// for each preset.
class FoldPreset extends Equatable {
  const FoldPreset({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.purpose,
    required this.technique,
    required this.highlightedProperties,
    required this.referenceImageAsset,
    required this.setupSteps,
    required this.supportedShotTypes,
    this.tutorialVideoAsset,
    this.tutorialTranscript = const [],
    this.requiresProp,
  });

  final String id;

  /// The [ProductCategory.id] this preset belongs to.
  final String categoryId;

  /// Display name, e.g. "Pallu drape (hanger)".
  final String name;

  /// What this preset is for, shown under the name.
  final String purpose;

  /// Angle, lighting, composition and grid loaded when this preset is chosen.
  final TechniquePreset technique;

  /// The fabric properties this composition is designed to communicate.
  final List<FabricProperty> highlightedProperties;

  /// Reference photo shown as the preset thumbnail and again during review.
  final String referenceImageAsset;

  /// Illustrated fallback steps, used when the video cannot be played.
  final List<SetupStep> setupSteps;

  /// Which shot types this preset is offered for.
  final List<ShotType> supportedShotTypes;

  /// Short localised tutorial video demonstrating the setup.
  ///
  /// Source: BTP §8.2 — illustrated tutorials were replaced by one-minute
  /// videos after user testing showed static illustrations were misread.
  final String? tutorialVideoAsset;

  /// Live transcript lines displayed alongside the video.
  final List<String> tutorialTranscript;

  /// An external prop the setup needs, e.g. a bamboo pole or hanger.
  ///
  /// User testing (BTP §8.1) found prop-based setups were markedly harder than
  /// plain grid alignment, so the UI warns and offers extra help when set.
  final String? requiresProp;

  bool get hasVideoTutorial => tutorialVideoAsset != null;

  bool get needsProp => requiresProp != null;

  bool supports(ShotType shotType) => supportedShotTypes.contains(shotType);

  @override
  List<Object?> get props => [id, categoryId, name];
}
