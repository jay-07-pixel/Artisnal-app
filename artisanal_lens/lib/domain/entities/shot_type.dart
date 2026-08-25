import 'photography_guideline.dart';
import 'technique_preset.dart';

/// The four shot types, and how many photographs each contributes to a
/// complete set.
///
/// Source of truth: the Figma file "Artisans lens".
///   • Product Setup Flow — PROCESS 0/2, PRODUCT 0/1, DETAIL 0/3, LIFESTYLE 0/1
///     summing to the "0 / 7 Photos" progress counter.
///   • Product Gallery & Viewer — the per-slot captions that name each
///     required photograph.
enum ShotType {
  process(
    id: 'process',
    label: 'Process',
    checklistDescription: 'Show the making process',
    pickerDescription: 'Weaving/Making',
    slotLabels: ['Loom setup', 'Dyeing'],
  ),
  product(
    id: 'product',
    label: 'Product',
    checklistDescription: 'Full shot of the item',
    pickerDescription: 'Main hero photo',
    slotLabels: ['Hero shot'],
  ),
  detail(
    id: 'detail',
    label: 'Detail',
    checklistDescription: 'Close-ups of texture/weave',
    pickerDescription: 'Close-up/Texture',
    slotLabels: ['Border', 'Weave', 'Motif'],
  ),
  lifestyle(
    id: 'lifestyle',
    label: 'Lifestyle',
    checklistDescription: 'In a natural setting',
    pickerDescription: 'Draped/Styled',
    slotLabels: ['Styled shot'],
  );

  const ShotType({
    required this.id,
    required this.label,
    required this.checklistDescription,
    required this.pickerDescription,
    required this.slotLabels,
  });

  final String id;
  final String label;

  /// Caption shown in the "Complete your photo set" checklist.
  final String checklistDescription;

  /// Caption shown on the "What kind of photo do you want?" picker.
  final String pickerDescription;

  /// The named photographs this type requires, in order.
  ///
  /// The gallery labels each captured photo with the slot it filled, which is
  /// why these are named rather than merely counted.
  final List<String> slotLabels;

  /// How many photographs this type contributes to a complete set.
  int get requiredCount => slotLabels.length;

  /// Total photographs in a complete set — 7 in the current design.
  static int get totalRequired =>
      ShotType.values.fold(0, (sum, type) => sum + type.requiredCount);

  /// The order the app walks through types when suggesting what to shoot next.
  ///
  /// Product comes first because the setup screen marks it
  /// "RECOMMENDED NEXT" on a fresh set, and it is the photograph a listing
  /// cannot go live without.
  static const List<ShotType> recommendedOrder = [
    ShotType.product,
    ShotType.detail,
    ShotType.process,
    ShotType.lifestyle,
  ];

  /// Whether the style step is offered for this type.
  ///
  /// Fold presets describe how to *arrange the finished cloth*, so they only
  /// apply to Product and Lifestyle. A Detail shot is framed against a grid
  /// rather than folded, and a Process shot is of the loom or the dye bath —
  /// there is no drape to choose in either case, so both go straight to the
  /// camera and load slot-specific shot guidance.
  bool get skipsStyleStep =>
      this == ShotType.detail || this == ShotType.process;

  /// Last-resort technique when no slot and no fold have been chosen.
  ///
  /// Saree Border and Weave load BTP §7.3 templates instead of this.
  /// Other categories keep this Detail fallback because the photography
  /// guide does not define templates for those categories. Motif uses a
  /// Pattern close-up through `ShotGuidance.forSlot`.
  TechniquePreset get fallbackTechnique => switch (this) {
        // A loom or a dye bath is a scene, not an object. The photography
        // guide does not define a process grid, so the existing rule-of-thirds
        // scene framing is kept.
        ShotType.process => const TechniquePreset(
            angle: CameraAngle.eyeLevel,
            lighting: LightingSetup.diffusedDaylight,
            composition: CompositionRule.ruleOfThirds,
            grid: GridOverlayType.ruleOfThirds,
            guidelines: [
              PhotographyGuideline.tellAStory,
              PhotographyGuideline.diverseLighting,
            ],
          ),
        // Conservative close-up only. Saree Texture & Weave and Embroidery
        // & Border must not read this — they have their own templates.
        _ => const TechniquePreset(
            angle: CameraAngle.macroCloseUp,
            lighting: LightingSetup.softWindowLight,
            composition: CompositionRule.centeredProduct,
            grid: GridOverlayType.centerFocus,
            guidelines: [
              PhotographyGuideline.closeUpShots,
              PhotographyGuideline.weightAndFlow,
            ],
          ),
      };

  static ShotType? fromId(String id) {
    for (final type in ShotType.values) {
      if (type.id == id) return type;
    }
    return null;
  }
}
