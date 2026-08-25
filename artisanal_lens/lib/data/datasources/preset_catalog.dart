import '../../domain/entities/fabric_property.dart';
import '../../domain/entities/fold_preset.dart';
import '../../domain/entities/photography_guideline.dart';
import '../../domain/entities/product_category.dart';
import '../../domain/entities/shot_type.dart';
import '../../domain/entities/technique_preset.dart';

/// The bundled, offline catalogue of categories and their presets.
///
/// This is the single place new products are added. It is intentionally plain
/// data with no Flutter dependency, so it can later be swapped for a remote or
/// JSON-backed source behind [CatalogDataSource] without touching the UI.
abstract interface class CatalogDataSource {
  List<ProductCategory> categories();

  List<FoldPreset> presetsForCategory(String categoryId);

  FoldPreset? presetById(String presetId);
}

class BundledCatalogDataSource implements CatalogDataSource {
  const BundledCatalogDataSource();

  static const String saree = 'saree';
  static const String cushionCover = 'cushion_cover';
  static const String shawl = 'shawl';
  static const String stole = 'stole';

  @override
  List<ProductCategory> categories() => const [
        ProductCategory(
          id: saree,
          name: 'Saree',
          thumbnailAsset: 'assets/images/categories/saree.png',
          sortOrder: 0,
        ),
        ProductCategory(
          id: cushionCover,
          name: 'Cushion Cover',
          thumbnailAsset: 'assets/images/categories/cushion_cover.png',
          sortOrder: 1,
        ),
        ProductCategory(
          id: shawl,
          name: 'Shawl',
          thumbnailAsset: 'assets/images/categories/shawl.png',
          sortOrder: 2,
        ),
        ProductCategory(
          id: stole,
          name: 'Stole',
          thumbnailAsset: 'assets/images/categories/stole.png',
          sortOrder: 3,
        ),
      ];

  @override
  List<FoldPreset> presetsForCategory(String categoryId) =>
      _all.where((preset) => preset.categoryId == categoryId).toList();

  @override
  FoldPreset? presetById(String presetId) {
    for (final preset in _all) {
      if (preset.id == presetId) return preset;
    }
    return null;
  }

  /// Every preset in the catalogue.
  ///
  /// Fold names are the category-specific fold/styling presets from the
  /// Artisanal Lens specification (four per category). They are not the
  /// photography-guide templates. Templates load through shot-slot guidance.
  ///
  /// A fold may share angle / lighting / grid data with a template when the
  /// source supports that overlap (for example Pallu drape uses hanger /
  /// bamboo / mannequin, which the Draped Look template also names). Sharing
  /// data is not the same as treating the fold as the template.
  static final List<FoldPreset> _all = [
    // ---------------------------------------------------------------- Saree
    // SOURCE CONFLICT — product-owner decision required. Do not reconcile.
    // Solution Deck p.9 sample flow: Pallu drape → Rule of Thirds.
    // BTP §7.3 Draped Look (hanger / bamboo / mannequin): Leading Lines.
    // This fold is not the Draped Look template. The current grid is Leading
    // Lines, matching BTP Draped Look placement overlap (hanger). Left
    // unchanged until the sources are decided.
    FoldPreset(
      id: 'saree_pallu_drape',
      categoryId: saree,
      name: 'Pallu drape (hanger)',
      purpose: 'Shows flimsiness, sheen, flow and weight.',
      content: 'Flimsiness, Sheen, Flow, Weight',
      needs: 'Hanger, bamboo or mannequin; side lighting',
      technique: const TechniquePreset(
        angle: CameraAngle.eyeLevel,
        lighting: LightingSetup.softWindowLight,
        composition: CompositionRule.leadingFabricLines,
        grid: GridOverlayType.leadingLines,
        guidelines: [
          PhotographyGuideline.weightAndFlow,
          PhotographyGuideline.diverseLighting,
          PhotographyGuideline.variousAngles,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.flimsiness,
        FabricProperty.sheen,
        FabricProperty.material,
      ],
      referenceImageAsset: 'assets/images/presets/saree_pallu_drape.png',
      requiresProp: 'A hanger, bamboo pole or mannequin',
      supportedShotTypes: const [ShotType.product, ShotType.lifestyle],
      tutorialVideoAsset: 'assets/videos/saree_pallu_drape.mp4',
      tutorialTranscript: const [
        'Hang the saree so its fall is clearly visible.',
        'Use a hanger, bamboo pole or mannequin at about shoulder height.',
        'Let the pallu hang freely — do not pull it straight.',
        'Let the folds follow the diagonal lines on your screen.',
        'Keep one light source to the side so the sheen shows.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Hang the saree',
          instruction:
              'Drape the saree over a hanger, bamboo or mannequin so the pallu falls freely.',
          illustrationAsset: 'assets/images/steps/saree_pallu_drape_1.png',
        ),
        SetupStep(
          title: 'Let the folds settle',
          instruction:
              'Do not flatten the folds — let them fall naturally to show weight and flow.',
          illustrationAsset: 'assets/images/steps/saree_pallu_drape_2.png',
        ),
        SetupStep(
          title: 'Align with the gridlines',
          instruction:
              'Match the drape to the diagonal guides. Side light shows the sheen.',
          illustrationAsset: 'assets/images/steps/saree_pallu_drape_3.png',
        ),
      ],
    ),
    FoldPreset(
      id: 'saree_box_fold',
      categoryId: saree,
      name: 'Box / flat fold',
      purpose: 'Shows thickness and material weight.',
      content: 'Thickness, Material weight',
      needs: 'Side lighting',
      technique: const TechniquePreset(
        angle: CameraAngle.eyeLevel,
        lighting: LightingSetup.softWindowLight,
        composition: CompositionRule.negativeSpaceAroundFolds,
        grid: GridOverlayType.horizontalFolds,
        guidelines: [
          PhotographyGuideline.highlightFabricEdges,
          PhotographyGuideline.weightAndFlow,
          PhotographyGuideline.diverseLighting,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.thickness,
        FabricProperty.material,
      ],
      referenceImageAsset: 'assets/images/presets/saree_box_fold.png',
      supportedShotTypes: const [ShotType.product],
      tutorialVideoAsset: 'assets/videos/saree_box_fold.mp4',
      tutorialTranscript: const [
        'Fold the saree into a neat stack so the layers stay visible.',
        'Keep the folded edge facing the camera — that edge shows thickness.',
        'Line the folds up with the horizontal guides.',
        'Use light from the side so each layer has depth.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Stack the folds',
          instruction:
              'Fold the saree into even layers and stack them so the edge is visible.',
          illustrationAsset: 'assets/images/steps/saree_box_fold_1.png',
        ),
        SetupStep(
          title: 'Face the edge forward',
          instruction:
              'Turn the stack so the saree edge faces the camera for a thickness reference.',
          illustrationAsset: 'assets/images/steps/saree_box_fold_2.png',
        ),
        SetupStep(
          title: 'Align with the gridlines',
          instruction:
              'Keep the folds parallel to the horizontal guides. Side light gives each fold depth.',
          illustrationAsset: 'assets/images/steps/saree_box_fold_4.png',
        ),
      ],
    ),
    FoldPreset(
      id: 'saree_worn_drape',
      categoryId: saree,
      name: 'Worn drape (model)',
      purpose: 'Shows colour, pattern and material when worn.',
      content: 'Colour, Pattern, Material',
      needs:
          'Someone to wear the saree; natural daylight; neutral or contrasting background',
      technique: const TechniquePreset(
        angle: CameraAngle.eyeLevel,
        lighting: LightingSetup.diffusedDaylight,
        composition: CompositionRule.ruleOfThirds,
        grid: GridOverlayType.ruleOfThirds,
        guidelines: [
          PhotographyGuideline.weightAndFlow,
          PhotographyGuideline.tellAStory,
          PhotographyGuideline.variousAngles,
          PhotographyGuideline.diverseLighting,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.colour,
        FabricProperty.pattern,
        FabricProperty.material,
      ],
      referenceImageAsset: 'assets/images/presets/saree_worn_drape.png',
      requiresProp: 'Someone to wear the saree',
      supportedShotTypes: const [ShotType.product, ShotType.lifestyle],
      tutorialVideoAsset: 'assets/videos/saree_worn_drape.mp4',
      tutorialTranscript: const [
        'A worn shot shows the full saree — colour, pattern and material.',
        'Stand in open shade so the colour stays true.',
        'Let the saree cover most of the frame.',
        'Line the top border up with the top third of the grid.',
        'If there are pleats, follow the vertical grid lines.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Drape the saree',
          instruction:
              'Drape the saree on the person so it covers most of the frame.',
          illustrationAsset: 'assets/images/steps/saree_worn_drape_1.png',
        ),
        SetupStep(
          title: 'Stand in open shade',
          instruction: 'Move out of direct sun so the colour stays true.',
          illustrationAsset: 'assets/images/steps/saree_worn_drape_2.png',
        ),
        SetupStep(
          title: 'Align with the gridlines',
          instruction:
              'Line the top border with the top third. Keep pleats on the vertical guides.',
          illustrationAsset: 'assets/images/steps/saree_worn_drape_3.png',
        ),
      ],
    ),
    FoldPreset(
      id: 'saree_roll_display',
      categoryId: saree,
      name: 'Roll display',
      purpose: 'Shows colour, pattern and material in a compact roll.',
      content: 'Colour, Pattern, Material',
      needs: 'Natural daylight; neutral or contrasting background',
      technique: const TechniquePreset(
        angle: CameraAngle.eyeLevel,
        lighting: LightingSetup.diffusedDaylight,
        composition: CompositionRule.ruleOfThirds,
        grid: GridOverlayType.ruleOfThirds,
        guidelines: [
          PhotographyGuideline.variousAngles,
          PhotographyGuideline.diverseLighting,
          PhotographyGuideline.complementaryBackgrounds,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.colour,
        FabricProperty.pattern,
        FabricProperty.material,
      ],
      referenceImageAsset: 'assets/images/presets/saree_roll_display.png',
      supportedShotTypes: const [ShotType.product],
      tutorialTranscript: const [
        'Roll the saree so the pallu and border face the camera.',
        'Let the roll cover most of the frame.',
        'Line the top border up with the top third of the grid.',
        'Use soft daylight so the colour stays true.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Roll the saree',
          instruction:
              'Roll the saree so the pallu and border face the camera.',
          illustrationAsset: 'assets/images/steps/saree_roll_display_1.png',
        ),
        SetupStep(
          title: 'Fill the frame',
          instruction: 'Step in until the roll covers most of the frame.',
          illustrationAsset: 'assets/images/steps/saree_roll_display_2.png',
        ),
        SetupStep(
          title: 'Align with the gridlines',
          instruction:
              'Line the top border up with the top third of the grid.',
          illustrationAsset: 'assets/images/steps/saree_roll_display_3.png',
        ),
      ],
    ),

    // -------------------------------------------------------- Cushion Cover
    FoldPreset(
      id: 'cushion_flat_lay',
      categoryId: cushionCover,
      name: 'Flat lay',
      purpose: 'Show the full pattern and colour without distortion.',
      technique: const TechniquePreset(
        angle: CameraAngle.overheadFlatLay,
        lighting: LightingSetup.diffusedDaylight,
        composition: CompositionRule.centeredProduct,
        grid: GridOverlayType.ruleOfThirds,
        guidelines: [
          PhotographyGuideline.variousAngles,
          PhotographyGuideline.complementaryBackgrounds,
          PhotographyGuideline.diverseLighting,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.pattern,
        FabricProperty.colour,
        FabricProperty.material,
      ],
      referenceImageAsset: 'assets/images/presets/cushion_flat_lay.png',
      supportedShotTypes: const [ShotType.product],
      tutorialVideoAsset: 'assets/videos/cushion_flat_lay.mp4',
      tutorialTranscript: const [
        'Lay the cushion cover flat on a plain surface.',
        'Smooth it out but leave the natural texture visible.',
        'Hold the phone directly above, not at an angle.',
        'Keep the edges straight along the grid.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Lay it flat',
          instruction: 'Place the cover flat on a plain, uncluttered surface.',
          illustrationAsset: 'assets/images/steps/cushion_flat_lay_1.png',
        ),
        SetupStep(
          title: 'Square the edges',
          instruction: 'Line the edges up with the grid so it is not tilted.',
          illustrationAsset: 'assets/images/steps/cushion_flat_lay_2.png',
        ),
      ],
    ),
    FoldPreset(
      id: 'cushion_stacked_pair',
      categoryId: cushionCover,
      name: 'Stacked pair',
      purpose: 'Show thickness and how a pair looks together.',
      technique: const TechniquePreset(
        angle: CameraAngle.eyeLevel,
        lighting: LightingSetup.softWindowLight,
        composition: CompositionRule.negativeSpaceAroundFolds,
        grid: GridOverlayType.horizontalFolds,
        guidelines: [
          PhotographyGuideline.highlightFabricEdges,
          PhotographyGuideline.weightAndFlow,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.thickness,
        FabricProperty.material,
        FabricProperty.texture,
      ],
      referenceImageAsset: 'assets/images/presets/cushion_stacked_pair.png',
      supportedShotTypes: const [ShotType.product],
      tutorialVideoAsset: 'assets/videos/cushion_stacked_pair.mp4',
      tutorialTranscript: const [
        'Stack two covers so the buyer can see the thickness.',
        'Keep the stacked edges facing the camera.',
        'Use side light so each layer casts a soft shadow.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Stack the covers',
          instruction: 'Place one cover neatly on top of the other.',
          illustrationAsset: 'assets/images/steps/cushion_stacked_pair_1.png',
        ),
        SetupStep(
          title: 'Face the edges forward',
          instruction: 'Turn the stack so the folded edges face the camera.',
          illustrationAsset: 'assets/images/steps/cushion_stacked_pair_2.png',
        ),
      ],
    ),
    FoldPreset(
      id: 'cushion_propped',
      categoryId: cushionCover,
      name: 'Propped on seating',
      purpose: 'Show the cover in use, at real scale.',
      technique: const TechniquePreset(
        angle: CameraAngle.eyeLevel,
        lighting: LightingSetup.softWindowLight,
        composition: CompositionRule.ruleOfThirds,
        grid: GridOverlayType.ruleOfThirds,
        guidelines: [
          PhotographyGuideline.tellAStory,
          PhotographyGuideline.complementaryBackgrounds,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.colour,
        FabricProperty.pattern,
        FabricProperty.quality,
      ],
      referenceImageAsset: 'assets/images/presets/cushion_propped.png',
      requiresProp: 'A chair, sofa or bed',
      supportedShotTypes: const [ShotType.lifestyle],
      tutorialVideoAsset: 'assets/videos/cushion_propped.mp4',
      tutorialTranscript: const [
        'Placing the cushion on a chair shows its real size.',
        'Choose a seat that does not compete with the pattern.',
        'Shoot at eye level, not from above.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Place the cushion',
          instruction: 'Prop the cushion on a chair or sofa, facing forward.',
          illustrationAsset: 'assets/images/steps/cushion_propped_1.png',
        ),
        SetupStep(
          title: 'Sit level with it',
          instruction: 'Lower the phone until it is level with the cushion.',
          illustrationAsset: 'assets/images/steps/cushion_propped_2.png',
        ),
      ],
    ),
    FoldPreset(
      id: 'cushion_corner_tuck',
      categoryId: cushionCover,
      name: 'Corner tuck close-up',
      purpose: 'Show stitching quality and the finish at the corner.',
      technique: const TechniquePreset(
        angle: CameraAngle.macroCloseUp,
        lighting: LightingSetup.softWindowLight,
        composition: CompositionRule.centeredProduct,
        grid: GridOverlayType.detailFrame,
        guidelines: [
          PhotographyGuideline.closeUpShots,
          PhotographyGuideline.highlightFabricEdges,
          PhotographyGuideline.diverseLighting,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.quality,
        FabricProperty.texture,
        FabricProperty.embroidery,
      ],
      referenceImageAsset: 'assets/images/presets/cushion_corner_tuck.png',
      supportedShotTypes: const [ShotType.detail],
      tutorialVideoAsset: 'assets/videos/cushion_corner_tuck.mp4',
      tutorialTranscript: const [
        'The corner shows your stitching most clearly.',
        'Move close until the corner fills the small frame.',
        'Tap the screen on the stitching to focus.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Find the corner',
          instruction: 'Turn the cover so one stitched corner faces you.',
          illustrationAsset: 'assets/images/steps/cushion_corner_tuck_1.png',
        ),
        SetupStep(
          title: 'Move in close',
          instruction: 'Move close until the corner fills the detail frame.',
          illustrationAsset: 'assets/images/steps/cushion_corner_tuck_2.png',
        ),
      ],
    ),

    // ---------------------------------------------------------------- Shawl
    FoldPreset(
      id: 'shawl_draped_shoulder',
      categoryId: shawl,
      name: 'Draped on shoulder',
      purpose: 'Show drape, weight and how it sits when worn.',
      technique: const TechniquePreset(
        angle: CameraAngle.eyeLevel,
        lighting: LightingSetup.diffusedDaylight,
        composition: CompositionRule.leadingFabricLines,
        grid: GridOverlayType.leadingLines,
        guidelines: [
          PhotographyGuideline.weightAndFlow,
          PhotographyGuideline.tellAStory,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.flimsiness,
        FabricProperty.material,
        FabricProperty.pattern,
      ],
      referenceImageAsset: 'assets/images/presets/shawl_draped_shoulder.png',
      requiresProp: 'Someone to wear the shawl',
      supportedShotTypes: const [ShotType.lifestyle],
      tutorialVideoAsset: 'assets/videos/shawl_draped_shoulder.mp4',
      tutorialTranscript: const [
        'Draping the shawl on a shoulder shows how heavy it is.',
        'Let one end hang lower than the other.',
        'Do not pin it — let the fabric fall on its own.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Drape the shawl',
          instruction: 'Place the shawl over one shoulder, letting it fall.',
          illustrationAsset:
              'assets/images/steps/shawl_draped_shoulder_1.png',
        ),
        SetupStep(
          title: 'Follow the diagonal',
          instruction: 'Line the falling edge up with the diagonal guide.',
          illustrationAsset:
              'assets/images/steps/shawl_draped_shoulder_2.png',
        ),
      ],
    ),
    FoldPreset(
      id: 'shawl_folded_stack',
      categoryId: shawl,
      name: 'Folded stack',
      purpose: 'Show thickness and material weight.',
      technique: const TechniquePreset(
        angle: CameraAngle.eyeLevel,
        lighting: LightingSetup.softWindowLight,
        composition: CompositionRule.negativeSpaceAroundFolds,
        grid: GridOverlayType.horizontalFolds,
        guidelines: [
          PhotographyGuideline.highlightFabricEdges,
          PhotographyGuideline.weightAndFlow,
          PhotographyGuideline.diverseLighting,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.thickness,
        FabricProperty.material,
      ],
      referenceImageAsset: 'assets/images/presets/shawl_folded_stack.png',
      supportedShotTypes: const [ShotType.product],
      tutorialVideoAsset: 'assets/videos/shawl_folded_stack.mp4',
      tutorialTranscript: const [
        'Stack the shawl neatly with the folds visible.',
        'Keep the folds parallel to the horizontal lines.',
        'Make sure the edge of the shawl is visible for thickness.',
        'Use side lighting so each fold has depth.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Fold the shawl',
          instruction: 'Fold the shawl into even layers and stack them neatly.',
          illustrationAsset: 'assets/images/steps/shawl_folded_stack_1.png',
        ),
        SetupStep(
          title: 'Show the edge',
          instruction:
              'Turn the stack so the folded edge is visible for thickness.',
          illustrationAsset: 'assets/images/steps/shawl_folded_stack_2.png',
        ),
      ],
    ),
    FoldPreset(
      id: 'shawl_hung_flat',
      categoryId: shawl,
      name: 'Hung / pinned flat',
      purpose: 'Show the full design, colour and border at once.',
      technique: const TechniquePreset(
        angle: CameraAngle.eyeLevel,
        lighting: LightingSetup.diffusedDaylight,
        composition: CompositionRule.ruleOfThirds,
        grid: GridOverlayType.ruleOfThirds,
        guidelines: [
          PhotographyGuideline.variousAngles,
          PhotographyGuideline.complementaryBackgrounds,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.pattern,
        FabricProperty.colour,
        FabricProperty.transparency,
      ],
      referenceImageAsset: 'assets/images/presets/shawl_hung_flat.png',
      requiresProp: 'A line, bamboo pole or wall to pin against',
      supportedShotTypes: const [ShotType.product],
      tutorialVideoAsset: 'assets/videos/shawl_hung_flat.mp4',
      tutorialTranscript: const [
        'Hanging the shawl flat shows the whole design at once.',
        'Pin both top corners so it does not sag in the middle.',
        'Stand straight in front, not to one side.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Pin it flat',
          instruction: 'Pin both top corners so the shawl hangs without sagging.',
          illustrationAsset: 'assets/images/steps/shawl_hung_flat_1.png',
        ),
        SetupStep(
          title: 'Stand square to it',
          instruction: 'Stand directly in front so the shape is not skewed.',
          illustrationAsset: 'assets/images/steps/shawl_hung_flat_2.png',
        ),
      ],
    ),
    FoldPreset(
      id: 'shawl_corner_tuck',
      categoryId: shawl,
      name: 'Corner tuck close-up',
      purpose: 'Show weave, border detail and craftsmanship.',
      technique: const TechniquePreset(
        angle: CameraAngle.macroCloseUp,
        lighting: LightingSetup.softWindowLight,
        composition: CompositionRule.centeredProduct,
        grid: GridOverlayType.detailFrame,
        guidelines: [
          PhotographyGuideline.closeUpShots,
          PhotographyGuideline.highlightFabricEdges,
          PhotographyGuideline.diverseLighting,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.texture,
        FabricProperty.quality,
        FabricProperty.embroidery,
      ],
      referenceImageAsset: 'assets/images/presets/shawl_corner_tuck.png',
      supportedShotTypes: const [ShotType.detail],
      tutorialVideoAsset: 'assets/videos/shawl_corner_tuck.mp4',
      tutorialTranscript: const [
        'A close-up of the corner shows the weave and the border together.',
        'Fold one corner back so both sides are visible.',
        'Move close until the weave fills the frame.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Fold the corner back',
          instruction: 'Fold one corner back to show both sides of the weave.',
          illustrationAsset: 'assets/images/steps/shawl_corner_tuck_1.png',
        ),
        SetupStep(
          title: 'Fill the frame',
          instruction: 'Move close until the weave fills the detail frame.',
          illustrationAsset: 'assets/images/steps/shawl_corner_tuck_2.png',
        ),
      ],
    ),

    // ---------------------------------------------------------------- Stole
    FoldPreset(
      id: 'stole_neck_wrap',
      categoryId: stole,
      name: 'Neck wrap (worn)',
      purpose: 'Show scale and how the stole sits when worn.',
      technique: const TechniquePreset(
        angle: CameraAngle.eyeLevel,
        lighting: LightingSetup.diffusedDaylight,
        composition: CompositionRule.ruleOfThirds,
        grid: GridOverlayType.ruleOfThirds,
        guidelines: [
          PhotographyGuideline.tellAStory,
          PhotographyGuideline.weightAndFlow,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.flimsiness,
        FabricProperty.colour,
        FabricProperty.pattern,
      ],
      referenceImageAsset: 'assets/images/presets/stole_neck_wrap.png',
      requiresProp: 'Someone to wear the stole',
      supportedShotTypes: const [ShotType.lifestyle],
      tutorialVideoAsset: 'assets/videos/stole_neck_wrap.mp4',
      tutorialTranscript: const [
        'A worn shot answers the most common question — how big is it?',
        'Wrap it once around the neck and let both ends hang.',
        'Shoot from the chest up so the ends stay in frame.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Wrap the stole',
          instruction: 'Wrap it once around the neck, letting both ends hang.',
          illustrationAsset: 'assets/images/steps/stole_neck_wrap_1.png',
        ),
        SetupStep(
          title: 'Frame chest up',
          instruction: 'Frame from the chest up so both ends stay visible.',
          illustrationAsset: 'assets/images/steps/stole_neck_wrap_2.png',
        ),
      ],
    ),
    FoldPreset(
      id: 'stole_flat_spread',
      categoryId: stole,
      name: 'Flat spread',
      purpose: 'Show the full length, pattern and both borders.',
      technique: const TechniquePreset(
        angle: CameraAngle.overheadFlatLay,
        lighting: LightingSetup.diffusedDaylight,
        composition: CompositionRule.ruleOfThirds,
        grid: GridOverlayType.ruleOfThirds,
        guidelines: [
          PhotographyGuideline.variousAngles,
          PhotographyGuideline.complementaryBackgrounds,
          PhotographyGuideline.naturalCreases,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.pattern,
        FabricProperty.colour,
        FabricProperty.material,
      ],
      referenceImageAsset: 'assets/images/presets/stole_flat_spread.png',
      supportedShotTypes: const [ShotType.product],
      tutorialVideoAsset: 'assets/videos/stole_flat_spread.mp4',
      tutorialTranscript: const [
        'Spread the stole out so its full length is visible.',
        'Leave the natural creases — they show what the fabric is like.',
        'Hold the phone directly above the middle.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Spread it out',
          instruction: 'Spread the stole flat so its full length is visible.',
          illustrationAsset: 'assets/images/steps/stole_flat_spread_1.png',
        ),
        SetupStep(
          title: 'Shoot from above',
          instruction: 'Hold the phone directly above the centre of the stole.',
          illustrationAsset: 'assets/images/steps/stole_flat_spread_2.png',
        ),
      ],
    ),
    FoldPreset(
      id: 'stole_loose_knot',
      categoryId: stole,
      name: 'Loose knot',
      purpose: 'Show how soft the fabric is and how easily it knots.',
      technique: const TechniquePreset(
        angle: CameraAngle.eyeLevel,
        lighting: LightingSetup.softWindowLight,
        composition: CompositionRule.centeredProduct,
        grid: GridOverlayType.centerFocus,
        guidelines: [
          PhotographyGuideline.weightAndFlow,
          PhotographyGuideline.naturalCreases,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.flimsiness,
        FabricProperty.texture,
        FabricProperty.material,
      ],
      referenceImageAsset: 'assets/images/presets/stole_loose_knot.png',
      supportedShotTypes: const [ShotType.product],
      tutorialVideoAsset: 'assets/videos/stole_loose_knot.mp4',
      tutorialTranscript: const [
        'A loose knot shows how soft and light the stole is.',
        'Tie it loosely — never pull it tight.',
        'Keep the knot in the centre of the frame.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Tie a loose knot',
          instruction: 'Tie one loose knot in the middle — do not pull tight.',
          illustrationAsset: 'assets/images/steps/stole_loose_knot_1.png',
        ),
        SetupStep(
          title: 'Centre the knot',
          instruction: 'Keep the knot inside the centre box on your screen.',
          illustrationAsset: 'assets/images/steps/stole_loose_knot_2.png',
        ),
      ],
    ),
    FoldPreset(
      id: 'stole_rolled_coil',
      categoryId: stole,
      name: 'Rolled coil',
      purpose: 'Show the edge, thickness and finish of the weave.',
      technique: const TechniquePreset(
        angle: CameraAngle.overheadFlatLay,
        lighting: LightingSetup.softWindowLight,
        composition: CompositionRule.centeredProduct,
        grid: GridOverlayType.centerFocus,
        guidelines: [
          PhotographyGuideline.highlightFabricEdges,
          PhotographyGuideline.closeUpShots,
        ],
      ),
      highlightedProperties: const [
        FabricProperty.thickness,
        FabricProperty.texture,
        FabricProperty.material,
      ],
      referenceImageAsset: 'assets/images/presets/stole_rolled_coil.png',
      supportedShotTypes: const [ShotType.product, ShotType.detail],
      tutorialVideoAsset: 'assets/videos/stole_rolled_coil.mp4',
      tutorialTranscript: const [
        'Rolling the stole into a coil shows the edge and the thickness.',
        'Roll it loosely so the layers stay separate.',
        'Shoot straight down onto the coil.',
      ],
      setupSteps: const [
        SetupStep(
          title: 'Roll into a coil',
          instruction: 'Roll the stole loosely into a flat coil.',
          illustrationAsset: 'assets/images/steps/stole_rolled_coil_1.png',
        ),
        SetupStep(
          title: 'Shoot from above',
          instruction: 'Hold the phone directly above the centre of the coil.',
          illustrationAsset: 'assets/images/steps/stole_rolled_coil_2.png',
        ),
      ],
    ),
  ];
}
