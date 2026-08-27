// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'The Artisanal Lens';

  @override
  String get navHome => 'Home';

  @override
  String get navGallery => 'Gallery';

  @override
  String get navNewProduct => 'New Product';

  @override
  String get navSettings => 'Settings';

  @override
  String get continueAction => 'Continue';

  @override
  String get openCamera => 'Open Camera';

  @override
  String get language => 'Language';

  @override
  String get photographyGuide => 'Photography guide';

  @override
  String get photographyGuideSubtitle =>
      'The rules behind every prompt this app gives you.';

  @override
  String get whatPhotographing => 'What are you\nphotographing today?';

  @override
  String get continuePhotography => 'Continue photography';

  @override
  String get previousSets => 'Previous sets.';

  @override
  String get filterAll => 'All';

  @override
  String get filterFinished => 'Finished';

  @override
  String get filterPending => 'Pending';

  @override
  String photosCompleted(int done, int total) {
    return '$done of $total photos completed';
  }

  @override
  String get emptyAll => 'No previous sets yet.';

  @override
  String get emptyFinished => 'No finished sets yet.';

  @override
  String get emptyPending => 'No pending sets.';

  @override
  String get newProduct => 'New Product';

  @override
  String get gallery => 'Gallery';

  @override
  String get settings => 'Settings';

  @override
  String get product => 'Product';

  @override
  String get photos => 'Photos';

  @override
  String get setup => 'Setup';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get review => 'Review';

  @override
  String get materialHeadline => 'What material are\nyou working with?';

  @override
  String materialTypeHeadline(String material) {
    return 'What type of $material\nare you using?';
  }

  @override
  String get giveProductName => 'Give your product a name';

  @override
  String nameHint(String category) {
    return 'e.g. Blue Silk $category';
  }

  @override
  String get photosToCapture => 'Photos to capture';

  @override
  String get photosToCaptureBody => 'These are the photos you need to take.';

  @override
  String get sareePhotographyTemplatesTitle => 'Saree photography templates';

  @override
  String get sareePhotographyTemplatesBody =>
      'These are the five photographs to take.';

  @override
  String get viewCompletedSet => 'View completed set';

  @override
  String get allPhotosCaptured => 'All photos captured';

  @override
  String takeNext(String label) {
    return 'Take next — $label';
  }

  @override
  String get productUnavailable => 'This product is no longer available.';

  @override
  String get chooseAStyle => 'Choose a style';

  @override
  String get howShouldItLook => 'How should it look?';

  @override
  String get stylePickFirst => 'Pick a photo from the list first.';

  @override
  String get styleNoNeeded => 'No style is needed for this photo.';

  @override
  String styleSubtitleSaree(String template) {
    return 'Choose the arrangement for this $template photo.';
  }

  @override
  String styleSubtitleShot(String shot) {
    return 'Choose the arrangement for this $shot photo.';
  }

  @override
  String styleSubtitleCategory(String category, String shot) {
    return 'Choose the arrangement for this $category $shot photo.';
  }

  @override
  String get labelContent => 'Content';

  @override
  String get labelNeeds => 'Needs';

  @override
  String get labelPlacement => 'Placement';

  @override
  String get labelLighting => 'Lighting';

  @override
  String get labelGrid => 'Grid';

  @override
  String contentPrefixed(String value) {
    return 'Content: $value';
  }

  @override
  String needsPrefixed(String value) {
    return 'Needs: $value';
  }

  @override
  String get lightingAndSetup => 'Lighting and setup';

  @override
  String get step1of2 => 'Step 1 of 2';

  @override
  String get step2of2 => 'Step 2 of 2';

  @override
  String get beforeYouShoot => 'Before you shoot';

  @override
  String get setupIllustrationPlaceholder => 'Setup illustration to be added';

  @override
  String get placeTheProduct => 'Place the product';

  @override
  String get setupSection => 'Setup';

  @override
  String get watchHowToSetUp => 'Watch how to set up';

  @override
  String tutorialSubtitlePreset(String name) {
    return 'Watch how to set up $name.';
  }

  @override
  String tutorialSubtitleTemplate(String name) {
    return 'Watch how to set up $name.';
  }

  @override
  String get tutorialSubtitleFallback =>
      'A short video will show this setup when it is added.';

  @override
  String get transcript => 'TRANSCRIPT';

  @override
  String get transcriptPlaceholder =>
      'The spoken transcript will appear here once the tutorial video is added.';

  @override
  String get tutorialVideoPlaceholder => 'Tutorial video to be added';

  @override
  String get referencePreset => 'REFERENCE PRESET';

  @override
  String get retake => 'Retake';

  @override
  String get usePhoto => 'Use Photo';

  @override
  String get greatFraming => 'Great framing';

  @override
  String get checkFraming => 'Check framing';

  @override
  String get noPhotoToReview => 'No photo to review.';

  @override
  String get photoSetComplete => 'Your photo set is complete 🎉';

  @override
  String get viewPhotoSet => 'View Photo Set';

  @override
  String get startNewProduct => 'Start New Product';

  @override
  String get offlineBanner => 'Offline — photos will sync when connected';

  @override
  String get productNotFound => 'Product not found.';

  @override
  String get exportPhotoSet => 'Export Photo Set';

  @override
  String continueCount(int done, int total) {
    return 'Continue — $done/$total';
  }

  @override
  String get noPhotosToExport => 'No photos to export yet.';

  @override
  String couldNotExport(String error) {
    return 'Could not export: $error';
  }

  @override
  String exportShareText(String name, int count) {
    return '$name — $count photos, shot with The Artisanal Lens';
  }

  @override
  String couldNotSavePhoto(String error) {
    return 'Could not save the photo: $error';
  }

  @override
  String get galleryEmpty =>
      'No photo sets yet.\nStart a new product to begin.';

  @override
  String get galleryEmptyFiltered => 'Nothing in this category yet.';

  @override
  String get showAll => 'Show all';

  @override
  String get nextPill => 'NEXT';

  @override
  String get templateOverline => 'TEMPLATE';

  @override
  String get proTipGoodLight =>
      'Pro-tip: Natural light is best now for product shots.';

  @override
  String get chipLight => 'Light';

  @override
  String get chipDistance => 'Distance';

  @override
  String get chipCentre => 'Centre';

  @override
  String get chipEmDash => '—';

  @override
  String get readingTheFrame => 'Reading the frame…';

  @override
  String fillFrameWith(String slot) {
    return 'Fill the frame with the $slot';
  }

  @override
  String promptNoProduct(String product) {
    return 'Place the $product in view';
  }

  @override
  String promptMoveIntoFrame(String product) {
    return 'Move the $product into the frame';
  }

  @override
  String promptKeepInsideFrame(String product) {
    return 'Keep the $product inside the frame';
  }

  @override
  String get promptAlignHorizontal =>
      'Line the folds up with the horizontal guides';

  @override
  String get promptAlignDiagonal => 'Let the fabric follow the diagonal guides';

  @override
  String get promptHoldSteady => 'Hold the phone steady';

  @override
  String get promptMoveCloser => 'Move closer';

  @override
  String get promptMoveFurther => 'Move further from subject';

  @override
  String promptCenterSubject(String product) {
    return 'Center the $product';
  }

  @override
  String get promptKeepTextureCentre => 'Keep the texture in the centre';

  @override
  String get promptKeepBorderInside => 'Keep the border inside the frame';

  @override
  String get promptKeepFoldsVisible => 'Keep the folds visible';

  @override
  String get promptBacklight => 'Backlight detected';

  @override
  String get promptTooDark => 'Too dark — move near a window or outside';

  @override
  String get promptLowLight => 'Light is low — move nearer a window';

  @override
  String get promptTooBright => 'Too bright — move into open shade';

  @override
  String get promptTiltPhone => 'Tilt the phone to match the angle guide';

  @override
  String get promptReady => 'Ready to capture';

  @override
  String get lightTooDark => 'Too dark';

  @override
  String get lightLow => 'Low';

  @override
  String get lightOk => 'OK';

  @override
  String get lightBright => 'Bright';

  @override
  String get distanceMoveCloser => 'Move closer';

  @override
  String get distanceOk => 'OK';

  @override
  String get distanceMoveBack => 'Move back';

  @override
  String get centreMoveIn => 'Move in';

  @override
  String get centreOk => 'OK';

  @override
  String get advisoryGoodHeadline => 'Good light right now';

  @override
  String get advisoryGoodDetail =>
      'Natural light is soft enough for clear, true colours.';

  @override
  String get advisoryOverheadHeadline => 'Overhead sun';

  @override
  String get advisoryOverheadDetail =>
      'Try taking the photo later when the sunlight is softer. Right now, the overhead sun may cause harsh shadows on your setup.';

  @override
  String get advisoryDarkHeadline => 'Not enough daylight';

  @override
  String get advisoryDarkDetail =>
      'There is not enough natural light now. Morning light near a window gives the truest colours.';

  @override
  String get openingTagline => 'Guided photography for handcrafted products';

  @override
  String get openingChipLight => 'Light: Good';

  @override
  String get openingChipAngle => 'Angle: Good';

  @override
  String get openingChipFrame => 'Frame: Ready';

  @override
  String get guidelineG1Title => 'Use Close-Up Shots';

  @override
  String get guidelineG1Body =>
      'Capture fine details, textures, and craftsmanship of the fabric.';

  @override
  String get guidelineG2Title => 'Highlight Fabric Edges';

  @override
  String get guidelineG2Body =>
      'Capture the edge of the fabric, covering 2/3 of the image with fabric.';

  @override
  String get guidelineG3Title => 'Shoot from Various Angles';

  @override
  String get guidelineG3Body =>
      'Showcase the product from multiple perspectives to highlight its design and structure.';

  @override
  String get guidelineG4Title => 'Experiment with Diverse Lighting';

  @override
  String get guidelineG4Body =>
      'Utilise natural and artificial lighting, indoor and outdoor lighting, front and side lighting, to bring out the true colours and depth of the fabric.';

  @override
  String get guidelineG5Title => 'Choose Complementary Backgrounds';

  @override
  String get guidelineG5Body =>
      'Use backgrounds that enhance the fabric\'s beauty without overpowering it.';

  @override
  String get guidelineG6Title => 'Embrace Natural Creases';

  @override
  String get guidelineG6Body =>
      'Photograph the fabric in its raw, unironed state to give a clear idea of material.';

  @override
  String get guidelineG7Title => 'Represent Weight and Flow';

  @override
  String get guidelineG7Body =>
      'Capture how the fabric drapes, folds, and flows to convey its weight and feel.';

  @override
  String get guidelineG8Title => 'Tell a Story';

  @override
  String get guidelineG8Body =>
      'Frame shots in a way that connects the fabric to its cultural heritage, artisans, and intended use.';

  @override
  String get categorySaree => 'Saree';

  @override
  String get categoryCushionCover => 'Cushion Cover';

  @override
  String get categoryShawl => 'Shawl';

  @override
  String get categoryStole => 'Stole';

  @override
  String get categorySarees => 'Sarees';

  @override
  String get categoryCushionCovers => 'Cushion Covers';

  @override
  String get categoryShawls => 'Shawls';

  @override
  String get categoryStoles => 'Stoles';

  @override
  String get nounSaree => 'saree';

  @override
  String get nounCushionCover => 'cushion cover';

  @override
  String get nounShawl => 'shawl';

  @override
  String get nounStole => 'stole';

  @override
  String get nounProduct => 'product';

  @override
  String get materialSilk => 'Silk';

  @override
  String get materialCotton => 'Cotton';

  @override
  String get materialWool => 'Wool';

  @override
  String get materialJute => 'Jute';

  @override
  String get materialSilkLower => 'silk';

  @override
  String get materialCottonLower => 'cotton';

  @override
  String get materialWoolLower => 'wool';

  @override
  String get materialJuteLower => 'jute';

  @override
  String get silkMulberry => 'Mulberry';

  @override
  String get silkEri => 'Eri';

  @override
  String get silkTasar => 'Tasar';

  @override
  String get silkMuga => 'Muga';

  @override
  String get shotProcess => 'Process';

  @override
  String get shotProduct => 'Product';

  @override
  String get shotDetail => 'Detail';

  @override
  String get shotLifestyle => 'Lifestyle';

  @override
  String get shotPhotography => 'Photography';

  @override
  String get shotProcessChecklist => 'Show the making process';

  @override
  String get shotProductChecklist => 'Full shot of the item';

  @override
  String get shotDetailChecklist => 'Close-ups of texture/weave';

  @override
  String get shotLifestyleChecklist => 'In a natural setting';

  @override
  String get shotPhotographyChecklist => 'Saree photography templates';

  @override
  String get slotLoomSetup => 'Loom setup';

  @override
  String get slotDyeing => 'Dyeing';

  @override
  String get slotHeroShot => 'Hero shot';

  @override
  String get slotBorder => 'Border';

  @override
  String get slotWeave => 'Weave';

  @override
  String get slotMotif => 'Motif';

  @override
  String get slotStyledShot => 'Styled shot';

  @override
  String get templateFullDisplay => 'Full Saree Display';

  @override
  String get templateTextureWeave => 'Texture & Weave';

  @override
  String get templateDrapedLook => 'Draped Look';

  @override
  String get templateEmbroideryBorder => 'Embroidery & Border Details';

  @override
  String get templateFoldedStack => 'Folded Stack / Saree Stack';

  @override
  String get templateFullDisplayLower => 'full saree display';

  @override
  String get templateTextureWeaveLower => 'texture & weave';

  @override
  String get templateDrapedLookLower => 'draped look';

  @override
  String get templateEmbroideryBorderLower => 'embroidery & border details';

  @override
  String get templateFoldedStackLower => 'folded stack / saree stack';

  @override
  String get templateFullDisplayContent => 'Colour, Pattern, Material';

  @override
  String get templateTextureWeaveContent =>
      'Texture, Thickness, Material, Transparency';

  @override
  String get templateDrapedLookContent => 'Flimsiness, Sheen, Flow, Weight';

  @override
  String get templateEmbroideryBorderContent => 'Embroidery, Quality';

  @override
  String get templateFoldedStackContent => 'Thickness, Material weight';

  @override
  String get templateFullDisplayNeeds =>
      'Natural daylight; neutral or contrasting background';

  @override
  String get templateTextureWeaveNeeds => 'Preferably natural light';

  @override
  String get templateDrapedLookNeeds =>
      'Hanger, bamboo or mannequin; side lighting';

  @override
  String get templateEmbroideryBorderNeeds =>
      'Side lighting; contrast background';

  @override
  String get templateFoldedStackNeeds => 'Side lighting';

  @override
  String get templateFullDisplayPlacement =>
      'Saree spread flat or draped over a surface';

  @override
  String get templateTextureWeavePlacement =>
      'A well-lit section of the saree, preferably in natural light';

  @override
  String get templateDrapedLookPlacement => 'Hanger, bamboo or mannequin';

  @override
  String get templateEmbroideryBorderPlacement =>
      'Close-up of the saree border or an embroidered section';

  @override
  String get templateFoldedStackPlacement =>
      'Neatly stacked with visible folds';

  @override
  String get templateFullDisplayOverlay =>
      'Line the top border up with the top third';

  @override
  String get templateTextureWeaveOverlay => 'Keep the texture in the centre';

  @override
  String get templateDrapedLookOverlay => 'Let the folds follow the diagonal';

  @override
  String get templateEmbroideryBorderOverlay =>
      'Keep the embroidery inside the frame';

  @override
  String get templateFoldedStackOverlay =>
      'Keep the folds parallel to the horizontal lines';

  @override
  String get templateTextureWeaveLighting =>
      'Use soft light. Avoid harsh reflections.';

  @override
  String get presetSareePalluDrapeName => 'Pallu drape (hanger)';

  @override
  String get presetSareeBoxFoldName => 'Box / flat fold';

  @override
  String get presetSareeWornDrapeName => 'Worn drape (model)';

  @override
  String get presetSareeRollDisplayName => 'Roll display';

  @override
  String get presetCushionFlatLayName => 'Flat lay';

  @override
  String get presetCushionStackedPairName => 'Stacked pair';

  @override
  String get presetCushionProppedName => 'Propped on seating';

  @override
  String get presetCushionCornerTuckName => 'Corner tuck close-up';

  @override
  String get presetShawlDrapedShoulderName => 'Draped on shoulder';

  @override
  String get presetShawlFoldedStackName => 'Folded stack';

  @override
  String get presetShawlHungFlatName => 'Hung / pinned flat';

  @override
  String get presetShawlCornerTuckName => 'Corner tuck close-up';

  @override
  String get presetStoleNeckWrapName => 'Neck wrap (worn)';

  @override
  String get presetStoleFlatSpreadName => 'Flat spread';

  @override
  String get presetStoleLooseKnotName => 'Loose knot';

  @override
  String get presetStoleRolledCoilName => 'Rolled coil';

  @override
  String get presetSareePalluDrapePurpose =>
      'Shows flimsiness, sheen, flow and weight.';

  @override
  String get presetSareeBoxFoldPurpose =>
      'Shows thickness and material weight.';

  @override
  String get presetSareeWornDrapePurpose =>
      'Shows colour, pattern and material when worn.';

  @override
  String get presetSareeRollDisplayPurpose =>
      'Shows colour, pattern and material in a compact roll.';

  @override
  String get presetCushionFlatLayPurpose =>
      'Show the full pattern and colour without distortion.';

  @override
  String get presetCushionStackedPairPurpose =>
      'Show thickness and how a pair looks together.';

  @override
  String get presetCushionProppedPurpose =>
      'Show the cover in use, at real scale.';

  @override
  String get presetCushionCornerTuckPurpose =>
      'Show stitching quality and the finish at the corner.';

  @override
  String get presetShawlDrapedShoulderPurpose =>
      'Show drape, weight and how it sits when worn.';

  @override
  String get presetShawlFoldedStackPurpose =>
      'Show thickness and material weight.';

  @override
  String get presetShawlHungFlatPurpose =>
      'Show the full design, colour and border at once.';

  @override
  String get presetShawlCornerTuckPurpose =>
      'Show weave, border detail and craftsmanship.';

  @override
  String get presetStoleNeckWrapPurpose =>
      'Show scale and how the stole sits when worn.';

  @override
  String get presetStoleFlatSpreadPurpose =>
      'Show the full length, pattern and both borders.';

  @override
  String get presetStoleLooseKnotPurpose =>
      'Show how soft the fabric is and how easily it knots.';

  @override
  String get presetStoleRolledCoilPurpose =>
      'Show the edge, thickness and finish of the weave.';

  @override
  String get presetSareePalluDrapeContent => 'Flimsiness, Sheen, Flow, Weight';

  @override
  String get presetSareeBoxFoldContent => 'Thickness, Material weight';

  @override
  String get presetSareeWornDrapeContent => 'Colour, Pattern, Material';

  @override
  String get presetSareeRollDisplayContent => 'Colour, Pattern, Material';

  @override
  String get presetSareePalluDrapeNeeds =>
      'Hanger, bamboo or mannequin; side lighting';

  @override
  String get presetSareeBoxFoldNeeds => 'Side lighting';

  @override
  String get presetSareeWornDrapeNeeds =>
      'Someone to wear the saree; natural daylight; neutral or contrasting background';

  @override
  String get presetSareeRollDisplayNeeds =>
      'Natural daylight; neutral or contrasting background';

  @override
  String get presetSareePalluDrapeLower => 'pallu drape (hanger)';

  @override
  String get presetSareeBoxFoldLower => 'box / flat fold';

  @override
  String get presetSareeWornDrapeLower => 'worn drape (model)';

  @override
  String get presetSareeRollDisplayLower => 'roll display';

  @override
  String get presetCushionFlatLayLower => 'flat lay';

  @override
  String get presetCushionStackedPairLower => 'stacked pair';

  @override
  String get presetCushionProppedLower => 'propped on seating';

  @override
  String get presetCushionCornerTuckLower => 'corner tuck close-up';

  @override
  String get presetShawlDrapedShoulderLower => 'draped on shoulder';

  @override
  String get presetShawlFoldedStackLower => 'folded stack';

  @override
  String get presetShawlHungFlatLower => 'hung / pinned flat';

  @override
  String get presetShawlCornerTuckLower => 'corner tuck close-up';

  @override
  String get presetStoleNeckWrapLower => 'neck wrap (worn)';

  @override
  String get presetStoleFlatSpreadLower => 'flat spread';

  @override
  String get presetStoleLooseKnotLower => 'loose knot';

  @override
  String get presetStoleRolledCoilLower => 'rolled coil';

  @override
  String get shotProcessLower => 'process';

  @override
  String get shotProductLower => 'product';

  @override
  String get shotDetailLower => 'detail';

  @override
  String get shotLifestyleLower => 'lifestyle';

  @override
  String get shotPhotographyLower => 'photography';

  @override
  String get categorySareeLower => 'saree';

  @override
  String get categoryCushionCoverLower => 'cushion cover';

  @override
  String get categoryShawlLower => 'shawl';

  @override
  String get categoryStoleLower => 'stole';

  @override
  String get propertyColour => 'Colour';

  @override
  String get propertyMaterial => 'Material';

  @override
  String get propertyQuality => 'Quality';

  @override
  String get propertyFlimsiness => 'Flimsiness';

  @override
  String get propertyTexture => 'Texture';

  @override
  String get propertyThickness => 'Thickness';

  @override
  String get propertyTransparency => 'Transparency';

  @override
  String get propertyPattern => 'Pattern';

  @override
  String get propertySheen => 'Sheen / Gloss';

  @override
  String get propertyEmbroidery => 'Embroidery';

  @override
  String get angleEyeLevel => 'Eye-level';

  @override
  String get angleEyeLevelHint =>
      'Hold the phone at the height of the product, straight on.';

  @override
  String get angleOverhead => 'Overhead (flat lay)';

  @override
  String get angleOverheadHint =>
      'Stand over the product and point the phone straight down.';

  @override
  String get angleLow => 'Low angle';

  @override
  String get angleLowHint =>
      'Lower the phone below the product and tilt slightly upward.';

  @override
  String get angleMacro => 'Macro close-up';

  @override
  String get angleMacroHint =>
      'Move close until the weave fills the frame, then tap to focus.';

  @override
  String get lightingSoftWindow => 'Soft window light';

  @override
  String get lightingSoftWindowHint =>
      'Place the product beside a window, not under a bulb.';

  @override
  String get lightingDiffused => 'Diffused daylight';

  @override
  String get lightingDiffusedHint =>
      'Shoot outdoors in open shade, with light coming from one side.';

  @override
  String get lightingAvoidMidday => 'Avoid harsh midday sun';

  @override
  String get lightingAvoidMiddayHint =>
      'Wait until after 3 PM — overhead sun washes out the colour.';

  @override
  String get lightingBacklight => 'Backlight for sheer fabrics';

  @override
  String get lightingBacklightHint =>
      'Put the light behind the fabric to show how much passes through.';

  @override
  String get compositionRuleOfThirds => 'Rule of thirds';

  @override
  String get compositionRuleOfThirdsHint =>
      'Line the border up with the top third of the grid.';

  @override
  String get compositionCentered => 'Centered product';

  @override
  String get compositionCenteredHint =>
      'Keep the product in the middle box of the grid.';

  @override
  String get compositionNegativeSpace => 'Negative space around folds';

  @override
  String get compositionNegativeSpaceHint =>
      'Leave empty space around the folds so they read clearly.';

  @override
  String get compositionLeadingLines => 'Leading fabric lines';

  @override
  String get compositionLeadingLinesHint =>
      'Lay the folds along the diagonal guides.';

  @override
  String get compositionCentreFocus => 'Centre focus';

  @override
  String get compositionCentreFocusHint =>
      'Keep the texture in the centre of the frame.';

  @override
  String get compositionDetailFrame => 'Detail frame';

  @override
  String get compositionDetailFrameHint =>
      'Keep the embroidery inside the highlighted frame.';
}
