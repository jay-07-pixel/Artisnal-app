import 'fold_preset.dart';
import 'photography_guideline.dart';
import 'photography_template.dart';
import 'shot_type.dart';
import 'technique_preset.dart';

/// Content, needs and technique for one required photograph.
///
/// Fold/styling presets and photography templates stay separate. This object
/// is what the instruction screens and the camera read for a chosen slot
/// (and, when the slot has a style step, the chosen fold).
class ShotGuidance {
  const ShotGuidance({
    required this.content,
    required this.technique,
    required this.guidance,
    this.needs,
    this.placement,
    this.overlayCaption,
    this.templateId,
    this.templateName,
  });

  /// Fabric properties this photograph is for, shown as "Content".
  ///
  /// Empty when the source does not name content for this slot/category.
  final String content;

  /// Documented setup requirements, shown as "Needs" when the source names any.
  final String? needs;

  final String? placement;
  final List<String> guidance;
  final TechniquePreset technique;
  final String? overlayCaption;

  /// Photography-template id and name when this slot uses one. Never a fold.
  final String? templateId;
  final String? templateName;

  bool get hasContent => content.trim().isNotEmpty;

  bool get hasNeeds => needs != null && needs!.trim().isNotEmpty;

  bool get hasPlacement => placement != null && placement!.trim().isNotEmpty;

  bool get hasSetupGuidance => setupGuidance.isNotEmpty;

  /// Lighting sentences already stored on the template/slot, if any.
  ///
  /// Used on Lighting & Setup. Not a transcript and not extra invented copy.
  String? get lightingNotes {
    final notes = guidance.where(_isLightingLine).toList();
    if (notes.isEmpty) return null;
    return notes.join(' ');
  }

  /// Remaining documented setup lines after lighting sentences are taken out.
  List<String> get setupGuidance =>
      guidance.where((line) => !_isLightingLine(line)).toList();

  static bool _isLightingLine(String line) {
    return _lightingPattern.hasMatch(line);
  }

  static final _lightingPattern = RegExp(
    r'\b(light|lighting|lit|reflection|reflections)\b',
    caseSensitive: false,
  );

  /// Resolves guidance for the photograph about to be taken.
  ///
  /// Photography templates win over the chosen fold for grid and camera
  /// copy. The fold is still used for How should it look, placement and
  /// the tutorial transcript. Detail and Process skip the style step and
  /// load slot guidance instead.
  factory ShotGuidance.resolve({
    required ShotType shotType,
    required int slotIndex,
    FoldPreset? preset,
    String? categoryId,
  }) {
    if (shotType.isPhotography) {
      return ShotGuidance.forSlot(
        shotType,
        slotIndex,
        categoryId: categoryId,
      );
    }
    if (preset != null) {
      return ShotGuidance.fromPreset(preset);
    }
    return ShotGuidance.forSlot(
      shotType,
      slotIndex,
      categoryId: categoryId,
    );
  }

  factory ShotGuidance.fromPreset(FoldPreset preset) {
    return ShotGuidance(
      content: preset.contentLabel,
      needs: preset.needsLabel,
      placement: preset.setupSteps.isNotEmpty
          ? preset.setupSteps.first.instruction
          : null,
      guidance: preset.tutorialTranscript,
      technique: preset.technique,
      overlayCaption: preset.technique.composition.hint,
    );
  }

  /// Slot-level guidance used when there is no fold preset (Detail, Process)
  /// or when a photography template owns the slot.
  factory ShotGuidance.forSlot(
    ShotType shotType,
    int slotIndex, {
    String? categoryId,
  }) {
    switch (shotType) {
      case ShotType.sareePhotography:
      case ShotType.photography:
        final template = PhotographyTemplates.byIndex(
              categoryId ?? sareeCategoryId,
              slotIndex,
            ) ??
            (shotType == ShotType.sareePhotography
                ? SareePhotographyTemplates.byIndex(slotIndex)
                : null);
        if (template == null) {
          return ShotGuidance(
            content: '',
            technique: shotType.fallbackTechnique,
            guidance: const [],
            overlayCaption: shotType.fallbackTechnique.composition.hint,
          );
        }
        return ShotGuidance.fromTemplate(template);
      case ShotType.detail:
        return _detailSlot(slotIndex, categoryId);
      case ShotType.process:
        return _processSlot(slotIndex);
      case ShotType.product:
      case ShotType.lifestyle:
        // These slots choose a fold first. Without one, keep the existing
        // type-level technique rather than inventing a template mapping.
        return ShotGuidance(
          content: shotType.checklistDescription,
          technique: shotType.fallbackTechnique,
          guidance: const [],
          overlayCaption: shotType.fallbackTechnique.composition.hint,
        );
    }
  }

  static ShotGuidance _detailSlot(int slotIndex, String? categoryId) {
    final isSaree = categoryId == sareeCategoryId;

    switch (slotIndex) {
      case 0:
        if (!isSaree) return _unspecifiedDetail;
        return ShotGuidance.fromTemplate(
          SareePhotographyTemplates.embroideryAndBorder,
        );
      case 1:
        if (!isSaree) return _unspecifiedDetail;
        return ShotGuidance.fromTemplate(
          SareePhotographyTemplates.textureAndWeave,
        );
      default:
        // Motif uses BTP §7.2 Pattern close-up, which is not a Saree
        // photography template. The guide names no Motif grid.
        return const ShotGuidance(
          content: 'Pattern',
          placement: 'Close-up of the intricate design',
          guidance: [
            'Use a close-up to showcase intricate designs or weaving details.',
            'A flat lay shows the full pattern without distortion.',
            'A draped or worn shot shows pattern placement.',
          ],
          technique: _motifTechnique,
          overlayCaption: 'Fill the frame with the motif',
        );
    }
  }

  static ShotGuidance _processSlot(int slotIndex) {
    if (slotIndex == 1) {
      // Dyeing → BTP §7.2 material / storytelling / prop guidance.
      return const ShotGuidance(
        content: 'Material',
        needs: 'Natural dyes, material yarn',
        placement: 'The dye work, with material yarn or natural dyes in frame',
        guidance: [
          'Use props along with the fabric such as natural dyes, material yarn.',
          'Capture close-up shots to highlight fabric weave or fibre structure.',
          'Frame the shot so it connects the fabric to the artisan and the making.',
        ],
        technique: _processTechnique,
        overlayCaption: 'Keep the dye work in frame',
      );
    }

    // Loom setup → BTP §7.2 quality / storytelling. No extra grid.
    return const ShotGuidance(
      content: 'Quality',
      placement: 'The loom and the making in a natural working setting',
      guidance: [
        'Frame the shot so it connects the fabric to its heritage and artisan.',
        'Include the hand of the artisan touching the fabric where it is natural.',
        'Show the edges of the fabric when they are part of the work.',
      ],
      technique: _processTechnique,
      overlayCaption: 'Keep the loom setup in frame',
    );
  }

  factory ShotGuidance.fromTemplate(PhotographyTemplate template) {
    return ShotGuidance(
      content: template.content,
      needs: template.needs,
      placement: template.placement,
      guidance: template.guidance,
      technique: template.technique,
      overlayCaption: template.overlayCaption ?? template.composition.hint,
      templateId: template.id,
      templateName: template.name,
    );
  }
}

/// Detail fallback when the source does not define a category-specific
/// photography template. Content and Needs stay empty so the UI does not
/// display Saree template copy on Cushion Cover, Shawl or Stole.
final ShotGuidance _unspecifiedDetail = ShotGuidance(
  content: '',
  technique: ShotType.detail.fallbackTechnique,
  guidance: const [],
  overlayCaption: ShotType.detail.fallbackTechnique.composition.hint,
);

/// Process photographs keep the existing scene technique. The photography
/// guide does not define a loom or dyeing grid.
const TechniquePreset _processTechnique = TechniquePreset(
  angle: CameraAngle.eyeLevel,
  lighting: LightingSetup.diffusedDaylight,
  composition: CompositionRule.ruleOfThirds,
  grid: GridOverlayType.ruleOfThirds,
  guidelines: [
    PhotographyGuideline.tellAStory,
    PhotographyGuideline.diverseLighting,
  ],
);

/// Motif is a Pattern close-up. The guide does not name a Motif grid, so this
/// keeps the existing centred close-up overlay rather than inventing one.
const TechniquePreset _motifTechnique = TechniquePreset(
  angle: CameraAngle.macroCloseUp,
  lighting: LightingSetup.softWindowLight,
  composition: CompositionRule.centeredProduct,
  grid: GridOverlayType.centerFocus,
  guidelines: [
    PhotographyGuideline.closeUpShots,
    PhotographyGuideline.weightAndFlow,
  ],
);
