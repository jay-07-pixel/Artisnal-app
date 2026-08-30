import 'fabric_property.dart';
import 'photography_guideline.dart';
import 'technique_preset.dart';

/// A documented photography template from the Product Photography Guide.
///
/// Templates are not fold/styling presets. They describe content, grid,
/// placement and guidance for a kind of photograph. Fold presets may *share*
/// technique data with a template when the source supports that overlap, but
/// a fold is not the template.
class PhotographyTemplate {
  const PhotographyTemplate({
    required this.id,
    required this.name,
    required this.content,
    required this.grid,
    required this.composition,
    required this.angle,
    required this.lighting,
    required this.placement,
    required this.guidance,
    required this.highlightedProperties,
    required this.guidelines,
    this.needs,
    this.overlayCaption,
    this.referenceImageAsset,
    this.skipsStyleStep = false,
    this.allowedPresetIds = const [],
  });

  final String id;
  final String name;

  /// Documented content line, shown in the UI as "Content".
  final String content;

  /// Documented setup requirements, shown as "Needs" when the source names any.
  final String? needs;

  final GridOverlayType grid;
  final CompositionRule composition;
  final CameraAngle angle;
  final LightingSetup lighting;
  final String placement;
  final List<String> guidance;
  final List<FabricProperty> highlightedProperties;
  final List<PhotographyGuideline> guidelines;
  final String? overlayCaption;

  /// Reference thumbnail shown on the photo list before a shot is taken.
  final String? referenceImageAsset;

  /// Close-ups skip "How should it look?" — there is no fold to choose.
  final bool skipsStyleStep;

  /// Fold presets offered for this photograph. Empty when [skipsStyleStep].
  final List<String> allowedPresetIds;

  bool get needsStyleStep => !skipsStyleStep && allowedPresetIds.isNotEmpty;

  /// Close-up texture, weave, border and corner detail templates skip the
  /// tutorial video step — live camera guidance is enough.
  bool get skipsTutorialStep =>
      id.contains('texture_weave') ||
      id.contains('embroidery_border') ||
      id.contains('border_corner') ||
      id.contains('corner_stitching');

  TechniquePreset get technique => TechniquePreset(
        angle: angle,
        lighting: lighting,
        composition: composition,
        grid: grid,
        guidelines: guidelines,
      );
}

/// Catalog id for Saree. Kept in domain so templates and slot lists do not
/// import the data layer.
const String sareeCategoryId = 'saree';

/// The five Saree photography templates in the Product Photography Guide.
///
/// These are independent of the four Saree fold/styling presets. They are
/// the Saree photography list — not Hero / Border / Weave / Motif / Styled.
abstract final class SareePhotographyTemplates {
  static const fullDisplay = PhotographyTemplate(
    id: 'saree_full_display',
    name: 'Full Saree Display',
    content: 'Colour, Pattern, Material',
    needs: 'Natural daylight; neutral or contrasting background',
    referenceImageAsset: 'assets/images/templates/saree_full_display.png',
    grid: GridOverlayType.ruleOfThirds,
    composition: CompositionRule.ruleOfThirds,
    // The guide does not name an angle; keep the existing full-product default.
    angle: CameraAngle.eyeLevel,
    lighting: LightingSetup.diffusedDaylight,
    placement: 'Saree spread flat or draped over a surface',
    guidance: [
      'The saree covers most of the frame.',
      'The top border aligns with the top third of the grid.',
      'When draped, pleats align with the vertical grid.',
    ],
    overlayCaption: 'Line the top border up with the top third',
    allowedPresetIds: ['saree_worn_drape', 'saree_roll_display'],
    highlightedProperties: [
      FabricProperty.colour,
      FabricProperty.pattern,
      FabricProperty.material,
    ],
    guidelines: [
      PhotographyGuideline.diverseLighting,
      PhotographyGuideline.complementaryBackgrounds,
      PhotographyGuideline.variousAngles,
    ],
  );

  static const textureAndWeave = PhotographyTemplate(
    id: 'saree_texture_weave',
    name: 'Texture & Weave',
    content: 'Texture, Thickness, Material, Transparency',
    needs: 'Preferably natural light',
    referenceImageAsset: 'assets/images/templates/saree_texture_weave.png',
    grid: GridOverlayType.centerFocus,
    composition: CompositionRule.centerFocus,
    angle: CameraAngle.macroCloseUp,
    lighting: LightingSetup.softWindowLight,
    placement: 'A well-lit section of the saree, preferably in natural light',
    guidance: [
      'The saree fills the frame.',
      'The texture stays in the centre.',
      'Use soft light.',
      'Avoid harsh reflections.',
    ],
    overlayCaption: 'Keep the texture in the centre',
    skipsStyleStep: true,
    highlightedProperties: [
      FabricProperty.texture,
      FabricProperty.thickness,
      FabricProperty.material,
      FabricProperty.transparency,
    ],
    guidelines: [
      PhotographyGuideline.closeUpShots,
      PhotographyGuideline.diverseLighting,
      PhotographyGuideline.highlightFabricEdges,
    ],
  );

  /// Photography template only. Not the Pallu drape fold.
  ///
  /// SOURCE CONFLICT with Solution Deck p.9 (Pallu drape → Rule of Thirds).
  /// This template keeps BTP §7.3 Leading Lines. The Pallu fold currently
  /// shares this grid; that is an unresolved source conflict, not a claim
  /// that Pallu drape *is* Draped Look.
  static const drapedLook = PhotographyTemplate(
    id: 'saree_draped_look',
    name: 'Draped Look',
    content: 'Flimsiness, Sheen, Flow, Weight',
    needs: 'Hanger, bamboo or mannequin; side lighting',
    referenceImageAsset: 'assets/images/templates/saree_draped_look.png',
    grid: GridOverlayType.leadingLines,
    composition: CompositionRule.leadingFabricLines,
    // The guide does not name an angle; keep the existing drape default.
    angle: CameraAngle.eyeLevel,
    lighting: LightingSetup.softWindowLight,
    placement: 'Hanger, bamboo or mannequin',
    guidance: [
      'Let the fabric fall naturally.',
      'Folds follow the diagonal.',
      'Use side lighting.',
    ],
    overlayCaption: 'Let the folds follow the diagonal',
    allowedPresetIds: ['saree_pallu_drape'],
    highlightedProperties: [
      FabricProperty.flimsiness,
      FabricProperty.sheen,
      FabricProperty.material,
    ],
    guidelines: [
      PhotographyGuideline.weightAndFlow,
      PhotographyGuideline.diverseLighting,
      PhotographyGuideline.variousAngles,
    ],
  );

  static const embroideryAndBorder = PhotographyTemplate(
    id: 'saree_embroidery_border',
    name: 'Embroidery & Border Details',
    content: 'Embroidery, Quality',
    needs: 'Side lighting; contrast background',
    referenceImageAsset: 'assets/images/templates/saree_embroidery_border.png',
    grid: GridOverlayType.detailFrame,
    composition: CompositionRule.detailFrame,
    angle: CameraAngle.macroCloseUp,
    lighting: LightingSetup.softWindowLight,
    placement: 'Close-up of the saree border or an embroidered section',
    guidance: [
      'The embroidery stays inside the frame.',
      'Use side lighting.',
      'Keep the detail sharp and well-lit.',
      'Use a contrast background.',
    ],
    overlayCaption: 'Keep the embroidery inside the frame',
    skipsStyleStep: true,
    highlightedProperties: [
      FabricProperty.embroidery,
      FabricProperty.quality,
    ],
    guidelines: [
      PhotographyGuideline.closeUpShots,
      PhotographyGuideline.diverseLighting,
      PhotographyGuideline.highlightFabricEdges,
      PhotographyGuideline.complementaryBackgrounds,
    ],
  );

  static const foldedStack = PhotographyTemplate(
    id: 'saree_folded_stack',
    name: 'Folded Stack / Saree Stack',
    content: 'Thickness, Material weight',
    needs: 'Side lighting',
    referenceImageAsset: 'assets/images/templates/saree_folded_stack.png',
    grid: GridOverlayType.horizontalFolds,
    composition: CompositionRule.negativeSpaceAroundFolds,
    // The guide does not name an angle; keep the existing stacked-fold default.
    angle: CameraAngle.eyeLevel,
    lighting: LightingSetup.softWindowLight,
    placement: 'Neatly stacked with visible folds',
    guidance: [
      'Folds stay parallel to the horizontal lines.',
      'Use side lighting.',
      'Keep the edge visible.',
    ],
    overlayCaption: 'Keep the folds parallel to the horizontal lines',
    allowedPresetIds: ['saree_box_fold'],
    highlightedProperties: [
      FabricProperty.thickness,
      FabricProperty.material,
    ],
    guidelines: [
      PhotographyGuideline.highlightFabricEdges,
      PhotographyGuideline.weightAndFlow,
      PhotographyGuideline.diverseLighting,
    ],
  );

  static const List<PhotographyTemplate> all = [
    fullDisplay,
    textureAndWeave,
    drapedLook,
    embroideryAndBorder,
    foldedStack,
  ];

  static PhotographyTemplate? byIndex(int index) {
    if (index < 0 || index >= all.length) return null;
    return all[index];
  }
}

const String cushionCategoryId = 'cushion_cover';
const String shawlCategoryId = 'shawl';
const String stoleCategoryId = 'stole';

/// Photography templates for Cushion Cover. Independent of the four folds.
abstract final class CushionPhotographyTemplates {
  static const fullCover = PhotographyTemplate(
    id: 'cushion_full_cover',
    name: 'Full Cover Display',
    content: 'Colour, Pattern, Material',
    needs: 'Natural daylight; plain surface',
    referenceImageAsset: 'assets/images/templates/cushion_full_cover.png',
    grid: GridOverlayType.ruleOfThirds,
    composition: CompositionRule.centeredProduct,
    angle: CameraAngle.overheadFlatLay,
    lighting: LightingSetup.diffusedDaylight,
    placement: 'Cover laid flat on a plain surface',
    guidance: [
      'Lay the cover flat so the full pattern is visible.',
      'Hold the phone directly above, not at an angle.',
      'Keep the edges straight along the grid.',
    ],
    overlayCaption: 'Keep the edges straight along the grid',
    allowedPresetIds: ['cushion_flat_lay'],
    highlightedProperties: [
      FabricProperty.pattern,
      FabricProperty.colour,
      FabricProperty.material,
    ],
    guidelines: [
      PhotographyGuideline.variousAngles,
      PhotographyGuideline.complementaryBackgrounds,
      PhotographyGuideline.diverseLighting,
    ],
  );

  static const textureAndWeave = PhotographyTemplate(
    id: 'cushion_texture_weave',
    name: 'Texture & Weave',
    content: 'Texture, Thickness, Material',
    needs: 'Preferably natural light',
    referenceImageAsset: 'assets/images/templates/cushion_texture_weave.png',
    grid: GridOverlayType.centerFocus,
    composition: CompositionRule.centerFocus,
    angle: CameraAngle.macroCloseUp,
    lighting: LightingSetup.softWindowLight,
    placement: 'A well-lit section of the cover',
    guidance: [
      'The weave fills the frame.',
      'The texture stays in the centre.',
      'Use soft light.',
      'Avoid harsh reflections.',
    ],
    overlayCaption: 'Keep the texture in the centre',
    skipsStyleStep: true,
    highlightedProperties: [
      FabricProperty.texture,
      FabricProperty.thickness,
      FabricProperty.material,
    ],
    guidelines: [
      PhotographyGuideline.closeUpShots,
      PhotographyGuideline.diverseLighting,
      PhotographyGuideline.highlightFabricEdges,
    ],
  );

  static const stackedPair = PhotographyTemplate(
    id: 'cushion_stacked_thickness',
    name: 'Stacked Pair / Thickness',
    content: 'Thickness, Material, Texture',
    needs: 'Side lighting; a matching pair',
    referenceImageAsset: 'assets/images/templates/cushion_stacked_pair.png',
    grid: GridOverlayType.horizontalFolds,
    composition: CompositionRule.negativeSpaceAroundFolds,
    angle: CameraAngle.eyeLevel,
    lighting: LightingSetup.softWindowLight,
    placement: 'Two covers stacked with edges facing the camera',
    guidance: [
      'Stack two covers so the buyer can see the thickness.',
      'Keep the stacked edges facing the camera.',
      'Use side light so each layer casts a soft shadow.',
    ],
    overlayCaption: 'Keep the folds parallel to the horizontal lines',
    allowedPresetIds: ['cushion_stacked_pair'],
    highlightedProperties: [
      FabricProperty.thickness,
      FabricProperty.material,
      FabricProperty.texture,
    ],
    guidelines: [
      PhotographyGuideline.highlightFabricEdges,
      PhotographyGuideline.weightAndFlow,
    ],
  );

  static const cornerStitching = PhotographyTemplate(
    id: 'cushion_corner_stitching',
    name: 'Corner & Stitching',
    content: 'Quality, Texture, Embroidery',
    needs: 'Side lighting',
    referenceImageAsset: 'assets/images/templates/cushion_corner_stitching.png',
    grid: GridOverlayType.detailFrame,
    composition: CompositionRule.detailFrame,
    angle: CameraAngle.macroCloseUp,
    lighting: LightingSetup.softWindowLight,
    placement: 'Close-up of a stitched corner',
    guidance: [
      'The corner shows stitching most clearly.',
      'Move close until the corner fills the small frame.',
      'Keep the stitching sharp and well-lit.',
    ],
    overlayCaption: 'Keep the stitching inside the frame',
    skipsStyleStep: true,
    highlightedProperties: [
      FabricProperty.quality,
      FabricProperty.texture,
      FabricProperty.embroidery,
    ],
    guidelines: [
      PhotographyGuideline.closeUpShots,
      PhotographyGuideline.highlightFabricEdges,
      PhotographyGuideline.diverseLighting,
    ],
  );

  static const inUse = PhotographyTemplate(
    id: 'cushion_in_use',
    name: 'In Use on Seating',
    content: 'Colour, Pattern, Quality',
    needs: 'A chair, sofa or bed',
    referenceImageAsset: 'assets/images/templates/cushion_in_use.png',
    grid: GridOverlayType.ruleOfThirds,
    composition: CompositionRule.ruleOfThirds,
    angle: CameraAngle.eyeLevel,
    lighting: LightingSetup.softWindowLight,
    placement: 'Cover propped on a seat, facing the camera',
    guidance: [
      'Placing the cushion on a chair shows its real size.',
      'Choose a seat that does not compete with the pattern.',
      'Shoot at eye level, not from above.',
    ],
    overlayCaption: 'Keep the cover in the frame',
    allowedPresetIds: ['cushion_propped'],
    highlightedProperties: [
      FabricProperty.colour,
      FabricProperty.pattern,
      FabricProperty.quality,
    ],
    guidelines: [
      PhotographyGuideline.tellAStory,
      PhotographyGuideline.complementaryBackgrounds,
    ],
  );

  static const List<PhotographyTemplate> all = [
    fullCover,
    textureAndWeave,
    stackedPair,
    cornerStitching,
    inUse,
  ];
}

/// Photography templates for Shawl. Independent of the four folds.
abstract final class ShawlPhotographyTemplates {
  static const fullDesign = PhotographyTemplate(
    id: 'shawl_full_design',
    name: 'Full Design Display',
    content: 'Pattern, Colour, Transparency',
    needs: 'A line, bamboo pole or wall to pin against',
    referenceImageAsset: 'assets/images/templates/shawl_full_design.png',
    grid: GridOverlayType.ruleOfThirds,
    composition: CompositionRule.ruleOfThirds,
    angle: CameraAngle.eyeLevel,
    lighting: LightingSetup.diffusedDaylight,
    placement: 'Shawl hung or pinned flat without sagging',
    guidance: [
      'Hanging the shawl flat shows the whole design at once.',
      'Pin both top corners so it does not sag in the middle.',
      'Stand straight in front, not to one side.',
    ],
    overlayCaption: 'Line the border up with the top third',
    allowedPresetIds: ['shawl_hung_flat'],
    highlightedProperties: [
      FabricProperty.pattern,
      FabricProperty.colour,
      FabricProperty.transparency,
    ],
    guidelines: [
      PhotographyGuideline.variousAngles,
      PhotographyGuideline.complementaryBackgrounds,
    ],
  );

  static const textureAndWeave = PhotographyTemplate(
    id: 'shawl_texture_weave',
    name: 'Texture & Weave',
    content: 'Texture, Thickness, Material',
    needs: 'Preferably natural light',
    referenceImageAsset: 'assets/images/templates/shawl_texture_weave.png',
    grid: GridOverlayType.centerFocus,
    composition: CompositionRule.centerFocus,
    angle: CameraAngle.macroCloseUp,
    lighting: LightingSetup.softWindowLight,
    placement: 'A well-lit section of the shawl',
    guidance: [
      'The weave fills the frame.',
      'The texture stays in the centre.',
      'Use soft light.',
      'Avoid harsh reflections.',
    ],
    overlayCaption: 'Keep the texture in the centre',
    skipsStyleStep: true,
    highlightedProperties: [
      FabricProperty.texture,
      FabricProperty.thickness,
      FabricProperty.material,
    ],
    guidelines: [
      PhotographyGuideline.closeUpShots,
      PhotographyGuideline.diverseLighting,
      PhotographyGuideline.highlightFabricEdges,
    ],
  );

  static const drapedLook = PhotographyTemplate(
    id: 'shawl_draped_look',
    name: 'Draped Look',
    content: 'Flimsiness, Material, Pattern',
    needs: 'Someone to wear the shawl',
    referenceImageAsset: 'assets/images/templates/shawl_draped_look.png',
    grid: GridOverlayType.leadingLines,
    composition: CompositionRule.leadingFabricLines,
    angle: CameraAngle.eyeLevel,
    lighting: LightingSetup.diffusedDaylight,
    placement: 'Shawl over one shoulder, falling naturally',
    guidance: [
      'Draping the shawl on a shoulder shows how heavy it is.',
      'Let one end hang lower than the other.',
      'Do not pin it — let the fabric fall on its own.',
    ],
    overlayCaption: 'Let the folds follow the diagonal',
    allowedPresetIds: ['shawl_draped_shoulder'],
    highlightedProperties: [
      FabricProperty.flimsiness,
      FabricProperty.material,
      FabricProperty.pattern,
    ],
    guidelines: [
      PhotographyGuideline.weightAndFlow,
      PhotographyGuideline.tellAStory,
    ],
  );

  static const borderCorner = PhotographyTemplate(
    id: 'shawl_border_corner',
    name: 'Border & Corner',
    content: 'Texture, Quality, Embroidery',
    needs: 'Side lighting',
    referenceImageAsset: 'assets/images/templates/shawl_border_corner.png',
    grid: GridOverlayType.detailFrame,
    composition: CompositionRule.detailFrame,
    angle: CameraAngle.macroCloseUp,
    lighting: LightingSetup.softWindowLight,
    placement: 'Close-up of the corner and border',
    guidance: [
      'A close-up of the corner shows the weave and the border together.',
      'Fold one corner back so both sides are visible.',
      'Move close until the weave fills the frame.',
    ],
    overlayCaption: 'Keep the border inside the frame',
    skipsStyleStep: true,
    highlightedProperties: [
      FabricProperty.texture,
      FabricProperty.quality,
      FabricProperty.embroidery,
    ],
    guidelines: [
      PhotographyGuideline.closeUpShots,
      PhotographyGuideline.highlightFabricEdges,
      PhotographyGuideline.diverseLighting,
    ],
  );

  static const foldedStack = PhotographyTemplate(
    id: 'shawl_stack_display',
    name: 'Folded Stack',
    content: 'Thickness, Material',
    needs: 'Side lighting',
    referenceImageAsset: 'assets/images/templates/shawl_folded_stack.png',
    grid: GridOverlayType.horizontalFolds,
    composition: CompositionRule.negativeSpaceAroundFolds,
    angle: CameraAngle.eyeLevel,
    lighting: LightingSetup.softWindowLight,
    placement: 'Neatly stacked with visible folds',
    guidance: [
      'Stack the shawl neatly with the folds visible.',
      'Keep the folds parallel to the horizontal lines.',
      'Use side lighting so each fold has depth.',
    ],
    overlayCaption: 'Keep the folds parallel to the horizontal lines',
    allowedPresetIds: ['shawl_folded_stack'],
    highlightedProperties: [
      FabricProperty.thickness,
      FabricProperty.material,
    ],
    guidelines: [
      PhotographyGuideline.highlightFabricEdges,
      PhotographyGuideline.weightAndFlow,
      PhotographyGuideline.diverseLighting,
    ],
  );

  static const List<PhotographyTemplate> all = [
    fullDesign,
    textureAndWeave,
    drapedLook,
    borderCorner,
    foldedStack,
  ];
}

/// Photography templates for Stole. Independent of the four folds.
abstract final class StolePhotographyTemplates {
  static const fullLength = PhotographyTemplate(
    id: 'stole_full_length',
    name: 'Full Length Display',
    content: 'Pattern, Colour, Material',
    needs: 'Natural daylight; plain surface',
    referenceImageAsset: 'assets/images/templates/stole_full_length.png',
    grid: GridOverlayType.ruleOfThirds,
    composition: CompositionRule.ruleOfThirds,
    angle: CameraAngle.overheadFlatLay,
    lighting: LightingSetup.diffusedDaylight,
    placement: 'Stole spread so its full length is visible',
    guidance: [
      'Spread the stole out so its full length is visible.',
      'Leave the natural creases — they show what the fabric is like.',
      'Hold the phone directly above the middle.',
    ],
    overlayCaption: 'Keep the stole along the grid',
    allowedPresetIds: ['stole_flat_spread'],
    highlightedProperties: [
      FabricProperty.pattern,
      FabricProperty.colour,
      FabricProperty.material,
    ],
    guidelines: [
      PhotographyGuideline.variousAngles,
      PhotographyGuideline.complementaryBackgrounds,
      PhotographyGuideline.naturalCreases,
    ],
  );

  static const textureAndWeave = PhotographyTemplate(
    id: 'stole_texture_weave',
    name: 'Texture & Weave',
    content: 'Texture, Thickness, Material',
    needs: 'Preferably natural light',
    referenceImageAsset: 'assets/images/templates/stole_texture_weave.png',
    grid: GridOverlayType.centerFocus,
    composition: CompositionRule.centerFocus,
    angle: CameraAngle.macroCloseUp,
    lighting: LightingSetup.softWindowLight,
    placement: 'A well-lit section of the stole',
    guidance: [
      'The weave fills the frame.',
      'The texture stays in the centre.',
      'Use soft light.',
      'Avoid harsh reflections.',
    ],
    overlayCaption: 'Keep the texture in the centre',
    skipsStyleStep: true,
    highlightedProperties: [
      FabricProperty.texture,
      FabricProperty.thickness,
      FabricProperty.material,
    ],
    guidelines: [
      PhotographyGuideline.closeUpShots,
      PhotographyGuideline.diverseLighting,
      PhotographyGuideline.highlightFabricEdges,
    ],
  );

  static const neckWrap = PhotographyTemplate(
    id: 'stole_worn_neck_wrap',
    name: 'Worn Neck Wrap',
    content: 'Flimsiness, Colour, Pattern',
    needs: 'Someone to wear the stole',
    referenceImageAsset: 'assets/images/templates/stole_neck_wrap.png',
    grid: GridOverlayType.ruleOfThirds,
    composition: CompositionRule.ruleOfThirds,
    angle: CameraAngle.eyeLevel,
    lighting: LightingSetup.diffusedDaylight,
    placement: 'Wrapped once around the neck with both ends visible',
    guidance: [
      'A worn shot answers how big the stole is.',
      'Wrap it once around the neck and let both ends hang.',
      'Shoot from the chest up so the ends stay in frame.',
    ],
    overlayCaption: 'Keep the wrap in the frame',
    allowedPresetIds: ['stole_neck_wrap'],
    highlightedProperties: [
      FabricProperty.flimsiness,
      FabricProperty.colour,
      FabricProperty.pattern,
    ],
    guidelines: [
      PhotographyGuideline.tellAStory,
      PhotographyGuideline.weightAndFlow,
    ],
  );

  static const softnessKnot = PhotographyTemplate(
    id: 'stole_softness_knot',
    name: 'Softness / Knot',
    content: 'Flimsiness, Texture, Material',
    needs: 'Soft side light',
    referenceImageAsset: 'assets/images/templates/stole_softness_knot.png',
    grid: GridOverlayType.centerFocus,
    composition: CompositionRule.centeredProduct,
    angle: CameraAngle.eyeLevel,
    lighting: LightingSetup.softWindowLight,
    placement: 'One loose knot in the middle',
    guidance: [
      'A loose knot shows how soft and light the stole is.',
      'Tie it loosely — never pull it tight.',
      'Keep the knot in the centre of the frame.',
    ],
    overlayCaption: 'Keep the knot in the centre',
    allowedPresetIds: ['stole_loose_knot'],
    highlightedProperties: [
      FabricProperty.flimsiness,
      FabricProperty.texture,
      FabricProperty.material,
    ],
    guidelines: [
      PhotographyGuideline.weightAndFlow,
      PhotographyGuideline.naturalCreases,
    ],
  );

  static const edgeThickness = PhotographyTemplate(
    id: 'stole_edge_thickness',
    name: 'Edge & Thickness',
    content: 'Thickness, Texture, Material',
    needs: 'Soft side light',
    referenceImageAsset: 'assets/images/templates/stole_edge_thickness.png',
    grid: GridOverlayType.centerFocus,
    composition: CompositionRule.centeredProduct,
    angle: CameraAngle.overheadFlatLay,
    lighting: LightingSetup.softWindowLight,
    placement: 'Stole rolled loosely into a coil',
    guidance: [
      'Rolling the stole into a coil shows the edge and the thickness.',
      'Roll it loosely so the layers stay separate.',
      'Shoot straight down onto the coil.',
    ],
    overlayCaption: 'Keep the coil in the centre',
    allowedPresetIds: ['stole_rolled_coil'],
    highlightedProperties: [
      FabricProperty.thickness,
      FabricProperty.texture,
      FabricProperty.material,
    ],
    guidelines: [
      PhotographyGuideline.highlightFabricEdges,
      PhotographyGuideline.closeUpShots,
    ],
  );

  static const List<PhotographyTemplate> all = [
    fullLength,
    textureAndWeave,
    neckWrap,
    softnessKnot,
    edgeThickness,
  ];
}

/// Category → photography-template list. Fold presets are not in this catalog.
abstract final class PhotographyTemplates {
  static List<PhotographyTemplate> forCategory(String categoryId) =>
      switch (categoryId) {
        sareeCategoryId => SareePhotographyTemplates.all,
        cushionCategoryId => CushionPhotographyTemplates.all,
        shawlCategoryId => ShawlPhotographyTemplates.all,
        stoleCategoryId => StolePhotographyTemplates.all,
        _ => const [],
      };

  static bool usesTemplates(String categoryId) =>
      forCategory(categoryId).isNotEmpty;

  static PhotographyTemplate? byIndex(String categoryId, int index) {
    final templates = forCategory(categoryId);
    if (index < 0 || index >= templates.length) return null;
    return templates[index];
  }

  static PhotographyTemplate? byId(String id) {
    for (final template in all) {
      if (template.id == id) return template;
    }
    return null;
  }

  static PhotographyTemplate? byName(String? name) {
    if (name == null) return null;
    for (final template in all) {
      if (template.name == name) return template;
    }
    return null;
  }

  static List<PhotographyTemplate> get all => [
        ...SareePhotographyTemplates.all,
        ...CushionPhotographyTemplates.all,
        ...ShawlPhotographyTemplates.all,
        ...StolePhotographyTemplates.all,
      ];
}
