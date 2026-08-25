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

  TechniquePreset get technique => TechniquePreset(
        angle: angle,
        lighting: lighting,
        composition: composition,
        grid: grid,
        guidelines: guidelines,
      );
}

/// The five Saree photography templates in the Product Photography Guide.
///
/// These are independent of the four Saree fold/styling presets.
abstract final class SareePhotographyTemplates {
  static const fullDisplay = PhotographyTemplate(
    id: 'saree_full_display',
    name: 'Full Saree Display',
    content: 'Colour, Pattern, Material',
    needs: 'Natural daylight; neutral or contrasting background',
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
    name: 'Close-up of Texture and Weave',
    content: 'Texture, Thickness, Material, Transparency',
    needs: 'Preferably natural light',
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
    name: 'Embroidery and Border Details',
    content: 'Embroidery, Quality',
    needs: 'Side lighting; contrast background',
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
    name: 'Folded Stack',
    content: 'Thickness, Material weight',
    needs: 'Side lighting',
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
}
