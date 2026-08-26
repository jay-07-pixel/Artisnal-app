import 'fold_preset.dart';
import 'shot_guidance.dart';
import 'technique_preset.dart';

/// One setup instruction played over the live camera preview.
///
/// Copy is always source-backed ([SetupStep], template placement/guidance, or
/// the documented composition hint). [illustrationAsset] is optional — missing
/// files are shown as a labelled placeholder, never substituted, and never in
/// place of the camera feed.
class VisualSetupStep {
  const VisualSetupStep({
    required this.number,
    required this.title,
    required this.instruction,
    this.illustrationAsset,
    this.placeholderLabel = 'Setup illustration to be added',
  });

  final int number;
  final String title;
  final String instruction;
  final String? illustrationAsset;
  final String placeholderLabel;

  bool get hasIllustrationPath =>
      illustrationAsset != null && illustrationAsset!.trim().isNotEmpty;
}

/// Which live camera checks this preset/template can actually run.
///
/// Built from [TechniquePreset] so Cushion/Shawl/Stole keep their own grids
/// instead of inheriting Saree template wording. Conditions the analyser
/// cannot measure stay in [undetectableConditions] as future CV work — they
/// are never emitted as fake live prompts.
class CameraGuidanceProfile {
  const CameraGuidanceProfile({
    required this.grid,
    required this.composition,
    required this.detectsLight,
    required this.detectsBacklight,
    required this.detectsAngle,
    required this.detectsSubjectFill,
    required this.detectsOverflow,
    required this.detectsCentring,
    required this.undetectableConditions,
    this.productNoun = 'product',
    this.placementInstruction,
    this.orientationTarget = EdgeOrientationTarget.none,
    this.minTargetCoverage = 0.35,
    this.maxCentringOffset = 0.12,
  });

  final GridOverlayType grid;
  final CompositionRule composition;

  /// What this category is called in prompts — "saree", "cushion cover".
  final String productNoun;

  /// The preset's own documented placement line, shown while nothing is in
  /// view yet. Source-backed; null when the catalog names none.
  final String? placementInstruction;

  /// The fabric direction this preset's grid asks for, where measurable.
  final EdgeOrientationTarget orientationTarget;

  /// How much of the ghost frame this preset wants filled. Close-ups ask for
  /// more of the guide than a full-product shot.
  final double minTargetCoverage;

  /// How far off-centre the subject may sit before it is called out.
  final double maxCentringOffset;

  /// Whether the fabric-direction check can run for this preset.
  bool get detectsOrientation => orientationTarget != EdgeOrientationTarget.none;

  /// Mean luminance too dark / too bright.
  final bool detectsLight;

  /// Border-to-centre brightness ratio (skipped when the technique wants it).
  final bool detectsBacklight;

  /// Device pitch vs the technique's target angle.
  final bool detectsAngle;

  /// Subject fill of the ghost frame ("Move closer").
  final bool detectsSubjectFill;

  /// Texture spilling outside the ghost frame ("Move further").
  final bool detectsOverflow;

  /// Texture centroid vs frame centre.
  final bool detectsCentring;

  /// Source-backed checks that cannot be measured with [FrameAnalyzer] today.
  final List<String> undetectableConditions;

  factory CameraGuidanceProfile.fromTechnique(
    TechniquePreset technique, {
    String productNoun = 'product',
    String? placementInstruction,
  }) {
    // A close-up is asked to fill more of a smaller guide; a full-product
    // shot leaves deliberate space around the cloth.
    final closeUp = technique.angle == CameraAngle.macroCloseUp ||
        technique.grid == GridOverlayType.centerFocus ||
        technique.grid == GridOverlayType.detailFrame ||
        technique.composition == CompositionRule.centerFocus ||
        technique.composition == CompositionRule.detailFrame;

    return CameraGuidanceProfile(
      grid: technique.grid,
      composition: technique.composition,
      productNoun: productNoun,
      placementInstruction: placementInstruction,
      orientationTarget: technique.grid.orientationTarget,
      minTargetCoverage: closeUp ? 0.55 : 0.35,
      maxCentringOffset: closeUp ? 0.10 : 0.14,
      detectsLight: true,
      detectsBacklight: !technique.lighting.expectsBacklight,
      detectsAngle: true,
      detectsSubjectFill: true,
      detectsOverflow: true,
      detectsCentring: true,
      undetectableConditions: _undetectableFor(technique),
    );
  }

  /// Properties no preset can check, because no model on the device reads
  /// them. They are listed so the UI never claims otherwise.
  static const List<String> universalUndetectables = [
    'Fabric type, material and weave quality.',
    'Sheen and transparency.',
    'Embroidery quality.',
    'Whether the cloth was physically folded or draped correctly.',
  ];

  /// TODO(cv): conditions named by the source that the luma analyser cannot
  /// currently measure for this grid, on top of [universalUndetectables].
  static List<String> _undetectableFor(TechniquePreset technique) {
    switch (technique.grid) {
      case GridOverlayType.leadingLines:
        return const [
          ...universalUndetectables,
          'Whether the diagonal fabric run is the pallu specifically, rather '
              'than any diagonal in the frame.',
        ];
      case GridOverlayType.horizontalFolds:
        return const [
          ...universalUndetectables,
          'Whether each individual fold is even — one dominant direction is '
              'measured, not per-fold geometry.',
          'Whether the product itself is level, as distinct from phone pitch.',
        ];
      case GridOverlayType.detailFrame:
        return const [
          ...universalUndetectables,
          'Embroidery-specific containment inside the detail rectangle; the '
              'analyser measures any textured content in the ghost frame.',
        ];
      case GridOverlayType.centerFocus:
        return const [
          ...universalUndetectables,
          'Whether the centred detail is specifically weave texture.',
        ];
      case GridOverlayType.ruleOfThirds:
        return const [
          ...universalUndetectables,
          'Whether a border sits on the top-third line.',
        ];
    }
  }
}

/// Preset- or template-specific setup + live camera guidance.
///
/// Fold/styling presets and Saree photography templates stay separate: a
/// template-backed [ShotGuidance] builds steps from placement / setup /
/// grid copy, not from the chosen fold's hang/drape steps. Each of the 16
/// folds still has its own object via [PresetCaptureGuidance.fromPreset].
class PresetCaptureGuidance {
  const PresetCaptureGuidance({
    required this.setupSteps,
    required this.lighting,
    required this.grid,
    required this.cameraGuidance,
    required this.technique,
    this.presetId,
    this.templateId,
    this.templateName,
    this.placement,
    this.setup = const [],
    this.needs,
    this.alignmentIllustrationAsset,
  });

  /// Catalog fold id when a style was chosen. Null for Detail / Process.
  final String? presetId;

  /// Photography-template id when this photograph uses one. Never a fold id.
  final String? templateId;

  final String? templateName;

  final List<VisualSetupStep> setupSteps;
  final String? placement;
  final List<String> setup;
  final String lighting;
  final String? needs;
  final GridOverlayType grid;
  final CameraGuidanceProfile cameraGuidance;
  final TechniquePreset technique;

  /// Alignment artwork named by the catalog. Null when the source names none.
  final String? alignmentIllustrationAsset;

  bool get hasSetupSteps => setupSteps.isNotEmpty;

  /// Resolves guidance for the photograph about to be taken.
  ///
  /// Saree photography templates win over the chosen fold for setup steps,
  /// grid and camera profile so Texture & Weave is never shown Pallu hang
  /// instructions. Other categories use the fold's documented setup steps.
  factory PresetCaptureGuidance.resolve({
    required ShotGuidance shotGuidance,
    FoldPreset? preset,
    String productNoun = 'product',
  }) {
    if (shotGuidance.templateName != null) {
      return PresetCaptureGuidance.fromShotGuidance(
        shotGuidance,
        presetId: preset?.id,
        productNoun: productNoun,
      );
    }
    if (preset != null) {
      return PresetCaptureGuidance.fromPreset(preset, productNoun: productNoun);
    }
    return PresetCaptureGuidance.fromShotGuidance(
      shotGuidance,
      productNoun: productNoun,
    );
  }

  /// One of the 16 fold/style presets, independent of photography templates.
  factory PresetCaptureGuidance.fromPreset(
    FoldPreset preset, {
    String productNoun = 'product',
  }) {
    final steps = <VisualSetupStep>[];
    for (var i = 0; i < preset.setupSteps.length; i++) {
      final step = preset.setupSteps[i];
      final instruction = step.instruction.trim();
      if (instruction.isEmpty) continue;
      steps.add(
        VisualSetupStep(
          number: steps.length + 1,
          title: step.title,
          instruction: instruction,
          illustrationAsset: step.illustrationAsset,
          placeholderLabel: _placeholderFor(step.title, instruction),
        ),
      );
    }

    final placement = preset.setupSteps.isNotEmpty
        ? preset.setupSteps.first.instruction
        : null;
    final arrange = preset.setupSteps.length > 1
        ? preset.setupSteps
            .skip(1)
            .map((step) => step.instruction)
            .where((line) => line.trim().isNotEmpty)
            .toList()
        : const <String>[];

    return PresetCaptureGuidance(
      presetId: preset.id,
      setupSteps: steps,
      placement: placement,
      setup: arrange,
      lighting: preset.technique.lighting.hint,
      needs: preset.needsLabel,
      grid: preset.technique.grid,
      cameraGuidance: CameraGuidanceProfile.fromTechnique(
        preset.technique,
        productNoun: productNoun,
        placementInstruction: placement,
      ),
      technique: preset.technique,
      alignmentIllustrationAsset: preset.alignmentIllustrationAsset,
    );
  }

  /// Slot / photography-template guidance (Saree templates, Detail, Process).
  factory PresetCaptureGuidance.fromShotGuidance(
    ShotGuidance shotGuidance, {
    String? presetId,
    String productNoun = 'product',
  }) {
    final steps = <VisualSetupStep>[];

    if (shotGuidance.hasPlacement) {
      steps.add(
        VisualSetupStep(
          number: steps.length + 1,
          title: 'Place your $productNoun',
          instruction: shotGuidance.placement!,
        ),
      );
    }

    if (shotGuidance.hasSetupGuidance) {
      steps.add(
        VisualSetupStep(
          number: steps.length + 1,
          title: 'Arrange your $productNoun',
          instruction: shotGuidance.setupGuidance.join(' '),
        ),
      );
    }

    final alignInstruction = (shotGuidance.overlayCaption ?? '').trim().isEmpty
        ? shotGuidance.technique.composition.hint
        : shotGuidance.overlayCaption!;
    final alreadyHasAlign = steps.any(
      (step) =>
          step.title.toLowerCase().contains('align') ||
          step.instruction.toLowerCase() == alignInstruction.toLowerCase(),
    );
    if (alignInstruction.trim().isNotEmpty && !alreadyHasAlign) {
      steps.add(
        VisualSetupStep(
          number: steps.length + 1,
          title: 'Align with the gridlines',
          instruction: alignInstruction,
          placeholderLabel: 'Alignment illustration to be added',
        ),
      );
    }

    final templateId = _templateIdFor(shotGuidance.templateName);

    return PresetCaptureGuidance(
      presetId: presetId,
      templateId: templateId,
      templateName: shotGuidance.templateName,
      setupSteps: steps,
      placement: shotGuidance.placement,
      setup: shotGuidance.setupGuidance,
      lighting: shotGuidance.lightingNotes ?? shotGuidance.technique.lighting.hint,
      needs: shotGuidance.needs,
      grid: shotGuidance.technique.grid,
      cameraGuidance: CameraGuidanceProfile.fromTechnique(
        shotGuidance.technique,
        productNoun: productNoun,
        placementInstruction: shotGuidance.placement,
      ),
      technique: shotGuidance.technique,
    );
  }

  static String _placeholderFor(String title, String instruction) {
    final haystack = '$title $instruction'.toLowerCase();
    if (haystack.contains('align') || haystack.contains('grid')) {
      return 'Alignment illustration to be added';
    }
    return 'Setup illustration to be added';
  }

  static String? _templateIdFor(String? name) {
    switch (name) {
      case 'Full Saree Display':
        return 'saree_full_display';
      case 'Texture & Weave':
        return 'saree_texture_weave';
      case 'Draped Look':
        return 'saree_draped_look';
      case 'Embroidery & Border Details':
        return 'saree_embroidery_border';
      case 'Folded Stack / Saree Stack':
        return 'saree_folded_stack';
      default:
        return null;
    }
  }
}
