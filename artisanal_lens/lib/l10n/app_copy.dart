import 'package:flutter/widgets.dart';

import '../domain/entities/capture_feedback.dart';
import '../domain/entities/fabric_material.dart';
import '../domain/entities/fabric_property.dart';
import '../domain/entities/fold_preset.dart';
import '../domain/entities/lighting_advisory.dart';
import '../domain/entities/photography_guideline.dart';
import '../domain/entities/photography_template.dart';
import '../domain/entities/shot_set.dart';
import '../domain/entities/shot_type.dart';
import '../domain/entities/technique_preset.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

/// Presentation-layer lookups for catalog IDs.
///
/// Domain entities stay in English so tests and the catalog source of truth
/// do not change. Screens call these helpers with [AppLocalizations.of].
abstract final class AppCopy {
  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context);

  static String categoryName(AppLocalizations l10n, String id) => switch (id) {
        'saree' => l10n.categorySaree,
        'cushion_cover' => l10n.categoryCushionCover,
        'shawl' => l10n.categoryShawl,
        'stole' => l10n.categoryStole,
        _ => id,
      };

  static String categoryNameLower(AppLocalizations l10n, String id) =>
      switch (id) {
        'saree' => l10n.categorySareeLower,
        'cushion_cover' => l10n.categoryCushionCoverLower,
        'shawl' => l10n.categoryShawlLower,
        'stole' => l10n.categoryStoleLower,
        _ => id,
      };

  static String categoryPlural(AppLocalizations l10n, String id) =>
      switch (id) {
        'saree' => l10n.categorySarees,
        'cushion_cover' => l10n.categoryCushionCovers,
        'shawl' => l10n.categoryShawls,
        'stole' => l10n.categoryStoles,
        _ => id,
      };

  static String productNoun(AppLocalizations l10n, String? categoryId) =>
      switch (categoryId) {
        'saree' => l10n.nounSaree,
        'cushion_cover' => l10n.nounCushionCover,
        'shawl' => l10n.nounShawl,
        'stole' => l10n.nounStole,
        _ => l10n.nounProduct,
      };

  static String materialName(AppLocalizations l10n, String id) => switch (id) {
        'silk' => l10n.materialSilk,
        'cotton' => l10n.materialCotton,
        'wool' => l10n.materialWool,
        'jute' => l10n.materialJute,
        _ => id,
      };

  static String materialNameForHeadline(AppLocalizations l10n, String id) =>
      switch (id) {
        'silk' => l10n.materialSilkLower,
        'cotton' => l10n.materialCottonLower,
        'wool' => l10n.materialWoolLower,
        'jute' => l10n.materialJuteLower,
        _ => id,
      };

  static String silkVarietyName(AppLocalizations l10n, String id) =>
      switch (id) {
        'mulberry' => l10n.silkMulberry,
        'eri' => l10n.silkEri,
        'tasar' => l10n.silkTasar,
        'muga' => l10n.silkMuga,
        _ => id,
      };

  static String shotTypeLabel(AppLocalizations l10n, ShotType type) =>
      switch (type) {
        ShotType.process => l10n.shotProcess,
        ShotType.product => l10n.shotProduct,
        ShotType.detail => l10n.shotDetail,
        ShotType.lifestyle => l10n.shotLifestyle,
        ShotType.sareePhotography => l10n.shotPhotography,
      };

  static String shotTypeLabelLower(AppLocalizations l10n, ShotType type) =>
      switch (type) {
        ShotType.process => l10n.shotProcessLower,
        ShotType.product => l10n.shotProductLower,
        ShotType.detail => l10n.shotDetailLower,
        ShotType.lifestyle => l10n.shotLifestyleLower,
        ShotType.sareePhotography => l10n.shotPhotographyLower,
      };

  static String shotTypeChecklist(AppLocalizations l10n, ShotType type) =>
      switch (type) {
        ShotType.process => l10n.shotProcessChecklist,
        ShotType.product => l10n.shotProductChecklist,
        ShotType.detail => l10n.shotDetailChecklist,
        ShotType.lifestyle => l10n.shotLifestyleChecklist,
        ShotType.sareePhotography => l10n.shotPhotographyChecklist,
      };

  static String slotLabel(
    AppLocalizations l10n,
    ShotType type,
    int index, {
    PhotographyTemplate? template,
  }) {
    if (template != null) return templateName(l10n, template.id);
    return switch ((type, index)) {
      (ShotType.process, 0) => l10n.slotLoomSetup,
      (ShotType.process, 1) => l10n.slotDyeing,
      (ShotType.product, 0) => l10n.slotHeroShot,
      (ShotType.detail, 0) => l10n.slotBorder,
      (ShotType.detail, 1) => l10n.slotWeave,
      (ShotType.detail, 2) => l10n.slotMotif,
      (ShotType.lifestyle, 0) => l10n.slotStyledShot,
      (ShotType.sareePhotography, 0) => l10n.templateFullDisplay,
      (ShotType.sareePhotography, 1) => l10n.templateTextureWeave,
      (ShotType.sareePhotography, 2) => l10n.templateDrapedLook,
      (ShotType.sareePhotography, 3) => l10n.templateEmbroideryBorder,
      (ShotType.sareePhotography, 4) => l10n.templateFoldedStack,
      _ => index >= 0 && index < type.slotLabels.length
          ? type.slotLabels[index]
          : shotTypeLabel(l10n, type),
    };
  }

  static String shotSlotLabel(AppLocalizations l10n, ShotSlot slot) =>
      slotLabel(l10n, slot.shotType, slot.index, template: slot.template);

  static String templateName(AppLocalizations l10n, String id) => switch (id) {
        'saree_full_display' => l10n.templateFullDisplay,
        'saree_texture_weave' => l10n.templateTextureWeave,
        'saree_draped_look' => l10n.templateDrapedLook,
        'saree_embroidery_border' => l10n.templateEmbroideryBorder,
        'saree_folded_stack' => l10n.templateFoldedStack,
        _ => id,
      };

  static String templateNameLower(AppLocalizations l10n, String id) =>
      switch (id) {
        'saree_full_display' => l10n.templateFullDisplayLower,
        'saree_texture_weave' => l10n.templateTextureWeaveLower,
        'saree_draped_look' => l10n.templateDrapedLookLower,
        'saree_embroidery_border' => l10n.templateEmbroideryBorderLower,
        'saree_folded_stack' => l10n.templateFoldedStackLower,
        _ => id,
      };

  static String? templateNameLowerByEnglish(
    AppLocalizations l10n,
    String? englishName,
  ) {
    if (englishName == null) return null;
    for (final template in SareePhotographyTemplates.all) {
      if (template.name == englishName) {
        return templateNameLower(l10n, template.id);
      }
    }
    return englishName;
  }

  static String templateContent(AppLocalizations l10n, String id) =>
      switch (id) {
        'saree_full_display' => l10n.templateFullDisplayContent,
        'saree_texture_weave' => l10n.templateTextureWeaveContent,
        'saree_draped_look' => l10n.templateDrapedLookContent,
        'saree_embroidery_border' => l10n.templateEmbroideryBorderContent,
        'saree_folded_stack' => l10n.templateFoldedStackContent,
        _ => '',
      };

  static String? templateNeeds(AppLocalizations l10n, String id) =>
      switch (id) {
        'saree_full_display' => l10n.templateFullDisplayNeeds,
        'saree_texture_weave' => l10n.templateTextureWeaveNeeds,
        'saree_draped_look' => l10n.templateDrapedLookNeeds,
        'saree_embroidery_border' => l10n.templateEmbroideryBorderNeeds,
        'saree_folded_stack' => l10n.templateFoldedStackNeeds,
        _ => null,
      };

  static String? templatePlacement(AppLocalizations l10n, String id) =>
      switch (id) {
        'saree_full_display' => l10n.templateFullDisplayPlacement,
        'saree_texture_weave' => l10n.templateTextureWeavePlacement,
        'saree_draped_look' => l10n.templateDrapedLookPlacement,
        'saree_embroidery_border' => l10n.templateEmbroideryBorderPlacement,
        'saree_folded_stack' => l10n.templateFoldedStackPlacement,
        _ => null,
      };

  static String? overlayCaptionForTemplate(
    AppLocalizations l10n,
    String? englishName,
  ) {
    if (englishName == null) return null;
    for (final template in SareePhotographyTemplates.all) {
      if (template.name == englishName) {
        return switch (template.id) {
          'saree_full_display' => l10n.templateFullDisplayOverlay,
          'saree_texture_weave' => l10n.templateTextureWeaveOverlay,
          'saree_draped_look' => l10n.templateDrapedLookOverlay,
          'saree_embroidery_border' => l10n.templateEmbroideryBorderOverlay,
          'saree_folded_stack' => l10n.templateFoldedStackOverlay,
          _ => template.overlayCaption,
        };
      }
    }
    return null;
  }

  static String? lightingNotesForTemplate(
    AppLocalizations l10n,
    String? englishName,
  ) {
    if (englishName == null) return null;
    if (englishName == SareePhotographyTemplates.textureAndWeave.name) {
      return l10n.templateTextureWeaveLighting;
    }
    return null;
  }

  static String presetName(AppLocalizations l10n, String id) => switch (id) {
        'saree_pallu_drape' => l10n.presetSareePalluDrapeName,
        'saree_box_fold' => l10n.presetSareeBoxFoldName,
        'saree_worn_drape' => l10n.presetSareeWornDrapeName,
        'saree_roll_display' => l10n.presetSareeRollDisplayName,
        'cushion_flat_lay' => l10n.presetCushionFlatLayName,
        'cushion_stacked_pair' => l10n.presetCushionStackedPairName,
        'cushion_propped' => l10n.presetCushionProppedName,
        'cushion_corner_tuck' => l10n.presetCushionCornerTuckName,
        'shawl_draped_shoulder' => l10n.presetShawlDrapedShoulderName,
        'shawl_folded_stack' => l10n.presetShawlFoldedStackName,
        'shawl_hung_flat' => l10n.presetShawlHungFlatName,
        'shawl_corner_tuck' => l10n.presetShawlCornerTuckName,
        'stole_neck_wrap' => l10n.presetStoleNeckWrapName,
        'stole_flat_spread' => l10n.presetStoleFlatSpreadName,
        'stole_loose_knot' => l10n.presetStoleLooseKnotName,
        'stole_rolled_coil' => l10n.presetStoleRolledCoilName,
        _ => id,
      };

  static String presetNameLower(AppLocalizations l10n, String id) =>
      switch (id) {
        'saree_pallu_drape' => l10n.presetSareePalluDrapeLower,
        'saree_box_fold' => l10n.presetSareeBoxFoldLower,
        'saree_worn_drape' => l10n.presetSareeWornDrapeLower,
        'saree_roll_display' => l10n.presetSareeRollDisplayLower,
        'cushion_flat_lay' => l10n.presetCushionFlatLayLower,
        'cushion_stacked_pair' => l10n.presetCushionStackedPairLower,
        'cushion_propped' => l10n.presetCushionProppedLower,
        'cushion_corner_tuck' => l10n.presetCushionCornerTuckLower,
        'shawl_draped_shoulder' => l10n.presetShawlDrapedShoulderLower,
        'shawl_folded_stack' => l10n.presetShawlFoldedStackLower,
        'shawl_hung_flat' => l10n.presetShawlHungFlatLower,
        'shawl_corner_tuck' => l10n.presetShawlCornerTuckLower,
        'stole_neck_wrap' => l10n.presetStoleNeckWrapLower,
        'stole_flat_spread' => l10n.presetStoleFlatSpreadLower,
        'stole_loose_knot' => l10n.presetStoleLooseKnotLower,
        'stole_rolled_coil' => l10n.presetStoleRolledCoilLower,
        _ => id,
      };

  static String presetPurpose(AppLocalizations l10n, FoldPreset preset) =>
      switch (preset.id) {
        'saree_pallu_drape' => l10n.presetSareePalluDrapePurpose,
        'saree_box_fold' => l10n.presetSareeBoxFoldPurpose,
        'saree_worn_drape' => l10n.presetSareeWornDrapePurpose,
        'saree_roll_display' => l10n.presetSareeRollDisplayPurpose,
        'cushion_flat_lay' => l10n.presetCushionFlatLayPurpose,
        'cushion_stacked_pair' => l10n.presetCushionStackedPairPurpose,
        'cushion_propped' => l10n.presetCushionProppedPurpose,
        'cushion_corner_tuck' => l10n.presetCushionCornerTuckPurpose,
        'shawl_draped_shoulder' => l10n.presetShawlDrapedShoulderPurpose,
        'shawl_folded_stack' => l10n.presetShawlFoldedStackPurpose,
        'shawl_hung_flat' => l10n.presetShawlHungFlatPurpose,
        'shawl_corner_tuck' => l10n.presetShawlCornerTuckPurpose,
        'stole_neck_wrap' => l10n.presetStoleNeckWrapPurpose,
        'stole_flat_spread' => l10n.presetStoleFlatSpreadPurpose,
        'stole_loose_knot' => l10n.presetStoleLooseKnotPurpose,
        'stole_rolled_coil' => l10n.presetStoleRolledCoilPurpose,
        _ => preset.purpose,
      };

  static String presetContent(AppLocalizations l10n, FoldPreset preset) =>
      switch (preset.id) {
        'saree_pallu_drape' => l10n.presetSareePalluDrapeContent,
        'saree_box_fold' => l10n.presetSareeBoxFoldContent,
        'saree_worn_drape' => l10n.presetSareeWornDrapeContent,
        'saree_roll_display' => l10n.presetSareeRollDisplayContent,
        _ => preset.highlightedProperties
            .map((property) => propertyLabel(l10n, property))
            .join(', '),
      };

  static String? presetNeeds(AppLocalizations l10n, FoldPreset preset) =>
      switch (preset.id) {
        'saree_pallu_drape' => l10n.presetSareePalluDrapeNeeds,
        'saree_box_fold' => l10n.presetSareeBoxFoldNeeds,
        'saree_worn_drape' => l10n.presetSareeWornDrapeNeeds,
        'saree_roll_display' => l10n.presetSareeRollDisplayNeeds,
        _ => preset.needsLabel,
      };

  static String propertyLabel(AppLocalizations l10n, FabricProperty property) =>
      switch (property) {
        FabricProperty.colour => l10n.propertyColour,
        FabricProperty.material => l10n.propertyMaterial,
        FabricProperty.quality => l10n.propertyQuality,
        FabricProperty.flimsiness => l10n.propertyFlimsiness,
        FabricProperty.texture => l10n.propertyTexture,
        FabricProperty.thickness => l10n.propertyThickness,
        FabricProperty.transparency => l10n.propertyTransparency,
        FabricProperty.pattern => l10n.propertyPattern,
        FabricProperty.sheen => l10n.propertySheen,
        FabricProperty.embroidery => l10n.propertyEmbroidery,
      };

  static String angleLabel(AppLocalizations l10n, CameraAngle angle) =>
      switch (angle) {
        CameraAngle.eyeLevel => l10n.angleEyeLevel,
        CameraAngle.overheadFlatLay => l10n.angleOverhead,
        CameraAngle.lowAngle => l10n.angleLow,
        CameraAngle.macroCloseUp => l10n.angleMacro,
      };

  static String angleHint(AppLocalizations l10n, CameraAngle angle) =>
      switch (angle) {
        CameraAngle.eyeLevel => l10n.angleEyeLevelHint,
        CameraAngle.overheadFlatLay => l10n.angleOverheadHint,
        CameraAngle.lowAngle => l10n.angleLowHint,
        CameraAngle.macroCloseUp => l10n.angleMacroHint,
      };

  static String lightingLabel(AppLocalizations l10n, LightingSetup lighting) =>
      switch (lighting) {
        LightingSetup.softWindowLight => l10n.lightingSoftWindow,
        LightingSetup.diffusedDaylight => l10n.lightingDiffused,
        LightingSetup.avoidHarshMidday => l10n.lightingAvoidMidday,
        LightingSetup.backlightForSheer => l10n.lightingBacklight,
      };

  static String lightingHint(AppLocalizations l10n, LightingSetup lighting) =>
      switch (lighting) {
        LightingSetup.softWindowLight => l10n.lightingSoftWindowHint,
        LightingSetup.diffusedDaylight => l10n.lightingDiffusedHint,
        LightingSetup.avoidHarshMidday => l10n.lightingAvoidMiddayHint,
        LightingSetup.backlightForSheer => l10n.lightingBacklightHint,
      };

  static String compositionLabel(
    AppLocalizations l10n,
    CompositionRule rule,
  ) =>
      switch (rule) {
        CompositionRule.ruleOfThirds => l10n.compositionRuleOfThirds,
        CompositionRule.centeredProduct => l10n.compositionCentered,
        CompositionRule.negativeSpaceAroundFolds =>
          l10n.compositionNegativeSpace,
        CompositionRule.leadingFabricLines => l10n.compositionLeadingLines,
        CompositionRule.centerFocus => l10n.compositionCentreFocus,
        CompositionRule.detailFrame => l10n.compositionDetailFrame,
      };

  static String compositionHint(
    AppLocalizations l10n,
    CompositionRule rule,
  ) =>
      switch (rule) {
        CompositionRule.ruleOfThirds => l10n.compositionRuleOfThirdsHint,
        CompositionRule.centeredProduct => l10n.compositionCenteredHint,
        CompositionRule.negativeSpaceAroundFolds =>
          l10n.compositionNegativeSpaceHint,
        CompositionRule.leadingFabricLines => l10n.compositionLeadingLinesHint,
        CompositionRule.centerFocus => l10n.compositionCentreFocusHint,
        CompositionRule.detailFrame => l10n.compositionDetailFrameHint,
      };

  static String guidelineTitle(
    AppLocalizations l10n,
    PhotographyGuideline guideline,
  ) =>
      switch (guideline) {
        PhotographyGuideline.closeUpShots => l10n.guidelineG1Title,
        PhotographyGuideline.highlightFabricEdges => l10n.guidelineG2Title,
        PhotographyGuideline.variousAngles => l10n.guidelineG3Title,
        PhotographyGuideline.diverseLighting => l10n.guidelineG4Title,
        PhotographyGuideline.complementaryBackgrounds => l10n.guidelineG5Title,
        PhotographyGuideline.naturalCreases => l10n.guidelineG6Title,
        PhotographyGuideline.weightAndFlow => l10n.guidelineG7Title,
        PhotographyGuideline.tellAStory => l10n.guidelineG8Title,
      };

  static String guidelineBody(
    AppLocalizations l10n,
    PhotographyGuideline guideline,
  ) =>
      switch (guideline) {
        PhotographyGuideline.closeUpShots => l10n.guidelineG1Body,
        PhotographyGuideline.highlightFabricEdges => l10n.guidelineG2Body,
        PhotographyGuideline.variousAngles => l10n.guidelineG3Body,
        PhotographyGuideline.diverseLighting => l10n.guidelineG4Body,
        PhotographyGuideline.complementaryBackgrounds => l10n.guidelineG5Body,
        PhotographyGuideline.naturalCreases => l10n.guidelineG6Body,
        PhotographyGuideline.weightAndFlow => l10n.guidelineG7Body,
        PhotographyGuideline.tellAStory => l10n.guidelineG8Body,
      };

  static String displayedContent(
    AppLocalizations l10n, {
    FoldPreset? preset,
    String? templateName,
    required String fallback,
  }) {
    if (templateName != null) {
      for (final template in SareePhotographyTemplates.all) {
        if (template.name == templateName) {
          return templateContent(l10n, template.id);
        }
      }
    }
    if (preset != null) {
      final mapped = presetContent(l10n, preset);
      if (mapped.isNotEmpty) return mapped;
    }
    return fallback;
  }

  static String? displayedNeeds(
    AppLocalizations l10n, {
    FoldPreset? preset,
    String? templateName,
    String? fallback,
  }) {
    if (templateName != null) {
      for (final template in SareePhotographyTemplates.all) {
        if (template.name == templateName) {
          return templateNeeds(l10n, template.id);
        }
      }
    }
    if (preset != null) {
      final mapped = presetNeeds(l10n, preset);
      if (mapped != null && mapped.isNotEmpty) return mapped;
    }
    return fallback;
  }

  static String? displayedPlacement(
    AppLocalizations l10n, {
    String? templateName,
    String? fallback,
  }) {
    if (templateName != null) {
      for (final template in SareePhotographyTemplates.all) {
        if (template.name == templateName) {
          return templatePlacement(l10n, template.id);
        }
      }
    }
    return fallback;
  }

  static String capturePrompt(
    AppLocalizations l10n,
    CapturePrompt prompt,
    String product,
  ) =>
      switch (prompt) {
        CapturePrompt.waiting => '',
        CapturePrompt.noProduct => l10n.promptNoProduct(product),
        CapturePrompt.moveIntoFrame => l10n.promptMoveIntoFrame(product),
        CapturePrompt.keepInsideFrame => l10n.promptKeepInsideFrame(product),
        CapturePrompt.alignWithHorizontalGuides => l10n.promptAlignHorizontal,
        CapturePrompt.alignWithDiagonalGuides => l10n.promptAlignDiagonal,
        CapturePrompt.holdSteady => l10n.promptHoldSteady,
        CapturePrompt.moveCloser => l10n.promptMoveCloser,
        CapturePrompt.moveFurther => l10n.promptMoveFurther,
        CapturePrompt.centerSubject => l10n.promptCenterSubject(product),
        CapturePrompt.keepTextureInCentre => l10n.promptKeepTextureCentre,
        CapturePrompt.keepBorderInsideFrame => l10n.promptKeepBorderInside,
        CapturePrompt.keepFoldsVisible => l10n.promptKeepFoldsVisible,
        CapturePrompt.backlightDetected => l10n.promptBacklight,
        CapturePrompt.tooDark => l10n.promptTooDark,
        CapturePrompt.lowLight => l10n.promptLowLight,
        CapturePrompt.tooBright => l10n.promptTooBright,
        CapturePrompt.tiltPhone => l10n.promptTiltPhone,
        CapturePrompt.ready => l10n.promptReady,
      };

  static String lightChip(AppLocalizations l10n, LightQuality quality) =>
      switch (quality) {
        LightQuality.tooDark => l10n.lightTooDark,
        LightQuality.low => l10n.lightLow,
        LightQuality.good => l10n.lightOk,
        LightQuality.tooBright => l10n.lightBright,
      };

  static String distanceChip(
    AppLocalizations l10n,
    DistanceQuality quality,
  ) =>
      switch (quality) {
        DistanceQuality.unknown => l10n.chipEmDash,
        DistanceQuality.tooFar => l10n.distanceMoveCloser,
        DistanceQuality.ok => l10n.distanceOk,
        DistanceQuality.tooClose => l10n.distanceMoveBack,
      };

  static String centreChip(AppLocalizations l10n, CentreQuality quality) =>
      switch (quality) {
        CentreQuality.unknown => l10n.chipEmDash,
        CentreQuality.off => l10n.centreMoveIn,
        CentreQuality.ok => l10n.centreOk,
      };

  static String advisoryHeadline(
    AppLocalizations l10n,
    LightingAdvisoryReason reason,
  ) =>
      switch (reason) {
        LightingAdvisoryReason.none => l10n.advisoryGoodHeadline,
        LightingAdvisoryReason.overheadSun => l10n.advisoryOverheadHeadline,
        LightingAdvisoryReason.tooDark => l10n.advisoryDarkHeadline,
        LightingAdvisoryReason.hazyOrCloudy => l10n.advisoryDarkHeadline,
      };

  static String advisoryDetail(
    AppLocalizations l10n,
    LightingAdvisoryReason reason,
  ) =>
      switch (reason) {
        LightingAdvisoryReason.none => l10n.advisoryGoodDetail,
        LightingAdvisoryReason.overheadSun => l10n.advisoryOverheadDetail,
        LightingAdvisoryReason.tooDark => l10n.advisoryDarkDetail,
        LightingAdvisoryReason.hazyOrCloudy => l10n.advisoryDarkDetail,
      };
}
