import 'photography_guideline.dart';
import 'technique_preset.dart';

/// Shot types that fill a product's required-photo list.
///
/// Cushion Cover, Shawl and Stole keep the Figma seven-slot checklist
/// (Process, Product, Detail, Lifestyle). Saree uses the five BTP
/// photography templates instead — that list is [sareePhotography] only.
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
  ),

  /// Saree-only BTP §7.3 photography templates. Not a fold/style preset.
  ///
  /// Slot labels stay in lockstep with [SareePhotographyTemplates.all].
  sareePhotography(
    id: 'saree_photography',
    label: 'Photography',
    checklistDescription: 'Saree photography templates',
    pickerDescription: 'Saree photography templates',
    slotLabels: [
      'Full Saree Display',
      'Texture & Weave',
      'Draped Look',
      'Embroidery & Border Details',
      'Folded Stack / Saree Stack',
    ],
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

  /// Figma seven-shot total for Cushion Cover, Shawl and Stole.
  ///
  /// Saree does not use this. Its required count is the five BTP templates.
  static int get totalRequired => figmaChecklistTypes.fold(
        0,
        (sum, type) => sum + type.requiredCount,
      );

  /// Process, Product, Detail, Lifestyle — the non-Saree checklist.
  static const List<ShotType> figmaChecklistTypes = [
    process,
    product,
    detail,
    lifestyle,
  ];

  /// Required-photo types for one category. Saree is templates only.
  static List<ShotType> checklistTypesFor(String categoryId) {
    if (categoryId == 'saree') return const [sareePhotography];
    return figmaChecklistTypes;
  }

  /// The order the app walks through types when suggesting what to shoot next.
  ///
  /// Product comes first because the setup screen marks it
  /// "RECOMMENDED NEXT" on a fresh set, and it is the photograph a listing
  /// cannot go live without. Saree ignores this and uses template order.
  static const List<ShotType> recommendedOrder = [
    ShotType.product,
    ShotType.detail,
    ShotType.process,
    ShotType.lifestyle,
  ];

  /// Whether the style step is offered for this type.
  ///
  /// Fold presets describe how to arrange the finished cloth. Product,
  /// Lifestyle and Saree photography all offer that list. Detail and Process
  /// skip it because they are close-ups and making shots, not styled layouts.
  bool get skipsStyleStep =>
      this == ShotType.detail || this == ShotType.process;

  /// Last-resort technique when no slot and no fold have been chosen.
  ///
  /// Saree Border and Weave load BTP §7.3 templates instead of this.
  /// Other categories keep this Detail fallback because the photography
  /// guide does not define templates for those categories. Motif uses a
  /// Pattern close-up through `ShotGuidance.forSlot`.
  TechniquePreset get fallbackTechnique => switch (this) {
        // Saree templates load BTP §7.3 through ShotGuidance.forSlot.
        // This is only the last-resort overlay if a slot index is missing.
        ShotType.sareePhotography => const TechniquePreset(
            angle: CameraAngle.eyeLevel,
            lighting: LightingSetup.diffusedDaylight,
            composition: CompositionRule.ruleOfThirds,
            grid: GridOverlayType.ruleOfThirds,
            guidelines: [
              PhotographyGuideline.diverseLighting,
              PhotographyGuideline.variousAngles,
            ],
          ),
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
