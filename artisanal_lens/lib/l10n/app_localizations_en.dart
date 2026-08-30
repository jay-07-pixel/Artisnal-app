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
  String get photographyTemplatesTitle => 'Photography templates';

  @override
  String get photographyTemplatesBody =>
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
  String get cottonKhadi => 'Khadi';

  @override
  String get cottonMuslin => 'Muslin';

  @override
  String get cottonHandloom => 'Handloom';

  @override
  String get cottonJamdani => 'Jamdani';

  @override
  String get woolPashmina => 'Pashmina';

  @override
  String get woolAngora => 'Angora';

  @override
  String get woolMerino => 'Merino';

  @override
  String get woolHandspun => 'Handspun';

  @override
  String get juteGolden => 'Golden';

  @override
  String get juteTossa => 'Tossa';

  @override
  String get juteHessian => 'Hessian';

  @override
  String get juteBlended => 'Blended';

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
  String get templateCushionFullCover => 'Full Cover Display';

  @override
  String get templateCushionTextureWeave => 'Texture & Weave';

  @override
  String get templateCushionStackedPair => 'Stacked Pair / Thickness';

  @override
  String get templateCushionCornerStitching => 'Corner & Stitching';

  @override
  String get templateCushionInUse => 'In Use on Seating';

  @override
  String get templateCushionFullCoverLower => 'full cover display';

  @override
  String get templateCushionTextureWeaveLower => 'texture & weave';

  @override
  String get templateCushionStackedPairLower => 'stacked pair / thickness';

  @override
  String get templateCushionCornerStitchingLower => 'corner & stitching';

  @override
  String get templateCushionInUseLower => 'in use on seating';

  @override
  String get templateCushionFullCoverContent => 'Colour, Pattern, Material';

  @override
  String get templateCushionTextureWeaveContent =>
      'Texture, Thickness, Material';

  @override
  String get templateCushionStackedPairContent =>
      'Thickness, Material, Texture';

  @override
  String get templateCushionCornerStitchingContent =>
      'Quality, Texture, Embroidery';

  @override
  String get templateCushionInUseContent => 'Colour, Pattern, Quality';

  @override
  String get templateCushionFullCoverNeeds => 'Natural daylight; plain surface';

  @override
  String get templateCushionTextureWeaveNeeds => 'Preferably natural light';

  @override
  String get templateCushionStackedPairNeeds =>
      'Side lighting; a matching pair';

  @override
  String get templateCushionCornerStitchingNeeds => 'Side lighting';

  @override
  String get templateCushionInUseNeeds => 'A chair, sofa or bed';

  @override
  String get templateCushionFullCoverPlacement =>
      'Cover laid flat on a plain surface';

  @override
  String get templateCushionTextureWeavePlacement =>
      'A well-lit section of the cover';

  @override
  String get templateCushionStackedPairPlacement =>
      'Two covers stacked with edges facing the camera';

  @override
  String get templateCushionCornerStitchingPlacement =>
      'Close-up of a stitched corner';

  @override
  String get templateCushionInUsePlacement =>
      'Cover propped on a seat, facing the camera';

  @override
  String get templateCushionFullCoverOverlay =>
      'Keep the edges straight along the grid';

  @override
  String get templateCushionTextureWeaveOverlay =>
      'Keep the texture in the centre';

  @override
  String get templateCushionStackedPairOverlay =>
      'Keep the folds parallel to the horizontal lines';

  @override
  String get templateCushionCornerStitchingOverlay =>
      'Keep the stitching inside the frame';

  @override
  String get templateCushionInUseOverlay => 'Keep the cover in the frame';

  @override
  String get templateShawlFullDesign => 'Full Design Display';

  @override
  String get templateShawlTextureWeave => 'Texture & Weave';

  @override
  String get templateShawlDrapedLook => 'Draped Look';

  @override
  String get templateShawlBorderCorner => 'Border & Corner';

  @override
  String get templateShawlFoldedStack => 'Folded Stack';

  @override
  String get templateShawlFullDesignLower => 'full design display';

  @override
  String get templateShawlTextureWeaveLower => 'texture & weave';

  @override
  String get templateShawlDrapedLookLower => 'draped look';

  @override
  String get templateShawlBorderCornerLower => 'border & corner';

  @override
  String get templateShawlFoldedStackLower => 'folded stack';

  @override
  String get templateShawlFullDesignContent => 'Pattern, Colour, Transparency';

  @override
  String get templateShawlTextureWeaveContent => 'Texture, Thickness, Material';

  @override
  String get templateShawlDrapedLookContent => 'Flimsiness, Material, Pattern';

  @override
  String get templateShawlBorderCornerContent => 'Texture, Quality, Embroidery';

  @override
  String get templateShawlFoldedStackContent => 'Thickness, Material';

  @override
  String get templateShawlFullDesignNeeds =>
      'A line, bamboo pole or wall to pin against';

  @override
  String get templateShawlTextureWeaveNeeds => 'Preferably natural light';

  @override
  String get templateShawlDrapedLookNeeds => 'Someone to wear the shawl';

  @override
  String get templateShawlBorderCornerNeeds => 'Side lighting';

  @override
  String get templateShawlFoldedStackNeeds => 'Side lighting';

  @override
  String get templateShawlFullDesignPlacement =>
      'Shawl hung or pinned flat without sagging';

  @override
  String get templateShawlTextureWeavePlacement =>
      'A well-lit section of the shawl';

  @override
  String get templateShawlDrapedLookPlacement =>
      'Shawl over one shoulder, falling naturally';

  @override
  String get templateShawlBorderCornerPlacement =>
      'Close-up of the corner and border';

  @override
  String get templateShawlFoldedStackPlacement =>
      'Neatly stacked with visible folds';

  @override
  String get templateShawlFullDesignOverlay =>
      'Line the border up with the top third';

  @override
  String get templateShawlTextureWeaveOverlay =>
      'Keep the texture in the centre';

  @override
  String get templateShawlDrapedLookOverlay =>
      'Let the folds follow the diagonal';

  @override
  String get templateShawlBorderCornerOverlay =>
      'Keep the border inside the frame';

  @override
  String get templateShawlFoldedStackOverlay =>
      'Keep the folds parallel to the horizontal lines';

  @override
  String get templateStoleFullLength => 'Full Length Display';

  @override
  String get templateStoleTextureWeave => 'Texture & Weave';

  @override
  String get templateStoleNeckWrap => 'Worn Neck Wrap';

  @override
  String get templateStoleSoftnessKnot => 'Softness / Knot';

  @override
  String get templateStoleEdgeThickness => 'Edge & Thickness';

  @override
  String get templateStoleFullLengthLower => 'full length display';

  @override
  String get templateStoleTextureWeaveLower => 'texture & weave';

  @override
  String get templateStoleNeckWrapLower => 'worn neck wrap';

  @override
  String get templateStoleSoftnessKnotLower => 'softness / knot';

  @override
  String get templateStoleEdgeThicknessLower => 'edge & thickness';

  @override
  String get templateStoleFullLengthContent => 'Pattern, Colour, Material';

  @override
  String get templateStoleTextureWeaveContent => 'Texture, Thickness, Material';

  @override
  String get templateStoleNeckWrapContent => 'Flimsiness, Colour, Pattern';

  @override
  String get templateStoleSoftnessKnotContent =>
      'Flimsiness, Texture, Material';

  @override
  String get templateStoleEdgeThicknessContent =>
      'Thickness, Texture, Material';

  @override
  String get templateStoleFullLengthNeeds => 'Natural daylight; plain surface';

  @override
  String get templateStoleTextureWeaveNeeds => 'Preferably natural light';

  @override
  String get templateStoleNeckWrapNeeds => 'Someone to wear the stole';

  @override
  String get templateStoleSoftnessKnotNeeds => 'Soft side light';

  @override
  String get templateStoleEdgeThicknessNeeds => 'Soft side light';

  @override
  String get templateStoleFullLengthPlacement =>
      'Stole spread so its full length is visible';

  @override
  String get templateStoleTextureWeavePlacement =>
      'A well-lit section of the stole';

  @override
  String get templateStoleNeckWrapPlacement =>
      'Wrapped once around the neck with both ends visible';

  @override
  String get templateStoleSoftnessKnotPlacement =>
      'One loose knot in the middle';

  @override
  String get templateStoleEdgeThicknessPlacement =>
      'Stole rolled loosely into a coil';

  @override
  String get templateStoleFullLengthOverlay => 'Keep the stole along the grid';

  @override
  String get templateStoleTextureWeaveOverlay =>
      'Keep the texture in the centre';

  @override
  String get templateStoleNeckWrapOverlay => 'Keep the wrap in the frame';

  @override
  String get templateStoleSoftnessKnotOverlay => 'Keep the knot in the centre';

  @override
  String get templateStoleEdgeThicknessOverlay => 'Keep the coil in the centre';

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

  @override
  String get accountBackup => 'Account & backup';

  @override
  String get accountBackupSubtitle =>
      'Create a username and password to save progress online.';

  @override
  String get cloudBackupNotConfigured => 'Cloud backup not configured';

  @override
  String get cloudBackupNotConfiguredBody =>
      'This build has no cloud connection. Progress stays on this phone only.';

  @override
  String get signedInAs => 'Signed in as';

  @override
  String get artisanFallback => 'Artisan';

  @override
  String get syncNow => 'Sync now';

  @override
  String get signOut => 'Sign out';

  @override
  String get createAccountPrompt =>
      'Create an account to save your work online.';

  @override
  String get signInPrompt => 'Sign in to load your saved products and photos.';

  @override
  String get username => 'Username';

  @override
  String get usernameHint => 'e.g. priya_weaver';

  @override
  String get password => 'Password';

  @override
  String get createAccount => 'Create account';

  @override
  String get signIn => 'Sign in';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get needAccount => 'Need an account? Create one';

  @override
  String get accountCreated =>
      'Account created. Your progress will sync online.';

  @override
  String get signedInSuccess => 'Signed in. Your saved work is on this phone.';

  @override
  String get signedOutSuccess => 'Signed out. Local photos stay on this phone.';

  @override
  String get syncOffline => 'No internet — sync when you are back online.';

  @override
  String syncDone(int sets, int shots) {
    return 'Synced: $sets products uploaded, $shots photos uploaded.';
  }

  @override
  String get syncUpToDate => 'Everything is already up to date.';

  @override
  String syncFailed(String error) {
    return 'Sync failed: $error';
  }

  @override
  String get yourProgress => 'Your progress';

  @override
  String get productsStarted => 'Products started';

  @override
  String get finishedSets => 'Finished sets';

  @override
  String get inProgressSets => 'In progress';

  @override
  String get photosCaptured => 'Photos captured';

  @override
  String get usernameTooShort =>
      'Username must be at least 3 letters or numbers.';

  @override
  String get usernameTooLong => 'Username must be 32 characters or fewer.';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters.';

  @override
  String get fullScreen => 'Full screen';

  @override
  String get tapToSkip => 'Tap to skip';

  @override
  String get cameraPermissionNeeded =>
      'Camera permission is needed to take photos.\nPlease allow camera access in Settings.';

  @override
  String get cameraUnavailable => 'The camera is unavailable.';

  @override
  String get noCameraFound => 'No camera found on this device.';

  @override
  String get accountCreateFailed => 'Could not create your account. Try again.';

  @override
  String get enterValidUsername => 'Enter a valid username.';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Apr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Aug';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dec';

  @override
  String get presetCushionFlatLayNeeds => 'Plain uncluttered surface';

  @override
  String get presetCushionStackedPairNeeds => 'Two covers; side light';

  @override
  String get presetCushionProppedNeeds => 'A chair, sofa or bed';

  @override
  String get presetCushionCornerTuckNeeds => 'Close-up light';

  @override
  String get presetShawlDrapedShoulderNeeds => 'Someone to wear the shawl';

  @override
  String get presetShawlFoldedStackNeeds => 'Side lighting';

  @override
  String get presetShawlHungFlatNeeds =>
      'A line, bamboo pole or wall to pin against';

  @override
  String get presetShawlCornerTuckNeeds => 'Close-up light';

  @override
  String get presetStoleNeckWrapNeeds => 'Someone to wear the stole';

  @override
  String get presetStoleFlatSpreadNeeds => 'Plain surface; overhead view';

  @override
  String get presetStoleLooseKnotNeeds => 'Soft side light';

  @override
  String get presetStoleRolledCoilNeeds => 'Soft side light';

  @override
  String get placementSareePalluDrape =>
      'Drape the saree over a hanger, bamboo or mannequin so the pallu falls freely.';

  @override
  String get placementSareeBoxFold =>
      'Fold the saree into even layers and stack them so the edge is visible.';

  @override
  String get placementSareeWornDrape =>
      'Drape the saree on the person so colour, pattern and border show clearly.';

  @override
  String get placementSareeRollDisplay =>
      'Roll the saree so the pallu and border face the camera.';

  @override
  String get placementCushionFlatLay =>
      'Place the cover flat on a plain, uncluttered surface.';

  @override
  String get placementCushionStackedPair =>
      'Place one cover neatly on top of the other.';

  @override
  String get placementCushionPropped =>
      'Prop the cushion on a chair or sofa, facing forward.';

  @override
  String get placementCushionCornerTuck =>
      'Turn the cover so one stitched corner faces you.';

  @override
  String get placementShawlDrapedShoulder =>
      'Place the shawl over one shoulder, letting it fall.';

  @override
  String get placementShawlFoldedStack =>
      'Fold the shawl into even layers and stack them neatly.';

  @override
  String get placementShawlHungFlat =>
      'Pin both top corners so the shawl hangs without sagging.';

  @override
  String get placementShawlCornerTuck =>
      'Fold one corner back to show both sides of the weave.';

  @override
  String get placementStoleNeckWrap =>
      'Wrap it once around the neck, letting both ends hang.';

  @override
  String get placementStoleFlatSpread =>
      'Spread the stole flat so its full length is visible.';

  @override
  String get placementStoleLooseKnot =>
      'Tie one loose knot in the middle — do not pull tight.';

  @override
  String get placementStoleRolledCoil =>
      'Roll the stole loosely into a flat coil.';

  @override
  String get transcriptSareePalluDrape1 =>
      'Hang the saree so its fall is clearly visible.';

  @override
  String get transcriptSareePalluDrape2 =>
      'Use a hanger, bamboo pole or mannequin at about shoulder height.';

  @override
  String get transcriptSareePalluDrape3 =>
      'Let the pallu hang freely — do not pull it straight.';

  @override
  String get transcriptSareePalluDrape4 =>
      'Let the folds follow the diagonal lines on your screen.';

  @override
  String get transcriptSareePalluDrape5 =>
      'Keep one light source to the side so the sheen shows.';

  @override
  String get transcriptSareeBoxFold1 =>
      'Fold the saree into a neat stack so the layers stay visible.';

  @override
  String get transcriptSareeBoxFold2 =>
      'Keep the folded edge facing the camera — that edge shows thickness.';

  @override
  String get transcriptSareeBoxFold3 =>
      'Line the folds up with the horizontal guides.';

  @override
  String get transcriptSareeBoxFold4 =>
      'Use light from the side so each layer has depth.';

  @override
  String get transcriptSareeWornDrape1 =>
      'A worn shot shows the full saree — colour, pattern and material.';

  @override
  String get transcriptSareeWornDrape2 =>
      'Stand in open shade so the colour stays true.';

  @override
  String get transcriptSareeWornDrape3 =>
      'Let the saree cover most of the frame.';

  @override
  String get transcriptSareeWornDrape4 =>
      'Line the top border up with the top third of the grid.';

  @override
  String get transcriptSareeWornDrape5 =>
      'If there are pleats, follow the vertical grid lines.';

  @override
  String get transcriptSareeRollDisplay1 =>
      'Roll the saree so the pallu and border face the camera.';

  @override
  String get transcriptSareeRollDisplay2 =>
      'Let the roll cover most of the frame.';

  @override
  String get transcriptSareeRollDisplay3 =>
      'Line the top border up with the top third of the grid.';

  @override
  String get transcriptSareeRollDisplay4 =>
      'Use soft daylight so the colour stays true.';

  @override
  String get transcriptCushionFlatLay1 =>
      'Lay the cushion cover flat on a plain surface.';

  @override
  String get transcriptCushionFlatLay2 =>
      'Smooth it out but leave the natural texture visible.';

  @override
  String get transcriptCushionFlatLay3 =>
      'Hold the phone directly above, not at an angle.';

  @override
  String get transcriptCushionFlatLay4 =>
      'Keep the edges straight along the grid.';

  @override
  String get transcriptCushionStackedPair1 =>
      'Stack two covers so the buyer can see the thickness.';

  @override
  String get transcriptCushionStackedPair2 =>
      'Keep the stacked edges facing the camera.';

  @override
  String get transcriptCushionStackedPair3 =>
      'Use side light so each layer casts a soft shadow.';

  @override
  String get transcriptCushionPropped1 =>
      'Placing the cushion on a chair shows its real size.';

  @override
  String get transcriptCushionPropped2 =>
      'Choose a seat that does not compete with the pattern.';

  @override
  String get transcriptCushionPropped3 => 'Shoot at eye level, not from above.';

  @override
  String get transcriptCushionCornerTuck1 =>
      'The corner shows your stitching most clearly.';

  @override
  String get transcriptCushionCornerTuck2 =>
      'Move close until the corner fills the small frame.';

  @override
  String get transcriptCushionCornerTuck3 =>
      'Tap the screen on the stitching to focus.';

  @override
  String get transcriptShawlDrapedShoulder1 =>
      'Draping the shawl on a shoulder shows how heavy it is.';

  @override
  String get transcriptShawlDrapedShoulder2 =>
      'Let one end hang lower than the other.';

  @override
  String get transcriptShawlDrapedShoulder3 =>
      'Do not pin it — let the fabric fall on its own.';

  @override
  String get transcriptShawlFoldedStack1 =>
      'Stack the shawl neatly with the folds visible.';

  @override
  String get transcriptShawlFoldedStack2 =>
      'Keep the folds parallel to the horizontal lines.';

  @override
  String get transcriptShawlFoldedStack3 =>
      'Make sure the edge of the shawl is visible for thickness.';

  @override
  String get transcriptShawlFoldedStack4 =>
      'Use side lighting so each fold has depth.';

  @override
  String get transcriptShawlHungFlat1 =>
      'Hanging the shawl flat shows the whole design at once.';

  @override
  String get transcriptShawlHungFlat2 =>
      'Pin both top corners so it does not sag in the middle.';

  @override
  String get transcriptShawlHungFlat3 =>
      'Stand straight in front, not to one side.';

  @override
  String get transcriptShawlCornerTuck1 =>
      'A close-up of the corner shows the weave and the border together.';

  @override
  String get transcriptShawlCornerTuck2 =>
      'Fold one corner back so both sides are visible.';

  @override
  String get transcriptShawlCornerTuck3 =>
      'Move close until the weave fills the frame.';

  @override
  String get transcriptStoleNeckWrap1 =>
      'A worn shot answers the most common question — how big is it?';

  @override
  String get transcriptStoleNeckWrap2 =>
      'Wrap it once around the neck and let both ends hang.';

  @override
  String get transcriptStoleNeckWrap3 =>
      'Shoot from the chest up so the ends stay in frame.';

  @override
  String get transcriptStoleFlatSpread1 =>
      'Spread the stole out so its full length is visible.';

  @override
  String get transcriptStoleFlatSpread2 =>
      'Leave the natural creases — they show what the fabric is like.';

  @override
  String get transcriptStoleFlatSpread3 =>
      'Hold the phone directly above the middle.';

  @override
  String get transcriptStoleLooseKnot1 =>
      'A loose knot shows how soft and light the stole is.';

  @override
  String get transcriptStoleLooseKnot2 =>
      'Tie it loosely — never pull it tight.';

  @override
  String get transcriptStoleLooseKnot3 =>
      'Keep the knot in the centre of the frame.';

  @override
  String get transcriptStoleRolledCoil1 =>
      'Rolling the stole into a coil shows the edge and the thickness.';

  @override
  String get transcriptStoleRolledCoil2 =>
      'Roll it loosely so the layers stay separate.';

  @override
  String get transcriptStoleRolledCoil3 => 'Shoot straight down onto the coil.';

  @override
  String get guideSareeFullDisplay1 => 'The saree covers most of the frame.';

  @override
  String get guideSareeFullDisplay2 =>
      'The top border aligns with the top third of the grid.';

  @override
  String get guideSareeFullDisplay3 =>
      'When draped, pleats align with the vertical grid.';

  @override
  String get guideSareeTextureWeave1 => 'The saree fills the frame.';

  @override
  String get guideSareeTextureWeave2 => 'The texture stays in the centre.';

  @override
  String get guideSareeTextureWeave3 => 'Use soft light.';

  @override
  String get guideSareeTextureWeave4 => 'Avoid harsh reflections.';

  @override
  String get guideSareeEmbroideryBorder1 =>
      'The embroidery stays inside the frame.';

  @override
  String get guideSareeEmbroideryBorder2 => 'Use side lighting.';

  @override
  String get guideSareeEmbroideryBorder3 =>
      'Keep the detail sharp and well-lit.';

  @override
  String get guideCushionTextureWeave1 => 'The weave fills the frame.';

  @override
  String get guideCushionTextureWeave2 => 'The texture stays in the centre.';

  @override
  String get guideShawlFullDesign1 =>
      'Hanging the shawl flat shows the whole design at once.';

  @override
  String get guideShawlFullDesign2 =>
      'Pin both top corners so it does not sag in the middle.';

  @override
  String get guideShawlTextureWeave1 => 'The weave fills the frame.';

  @override
  String get guideShawlTextureWeave2 => 'The texture stays in the centre.';

  @override
  String get guideStoleFullLength1 =>
      'Spread the stole out so its full length is visible.';

  @override
  String get guideStoleFullLength2 =>
      'Leave the natural creases — they show what the fabric is like.';

  @override
  String get guideStoleTextureWeave1 => 'The weave fills the frame.';

  @override
  String get guideStoleTextureWeave2 => 'The texture stays in the centre.';

  @override
  String get authInvalidCredentials => 'Incorrect username or password.';

  @override
  String get authUserAlreadyRegistered => 'That username is already taken.';

  @override
  String get authEmailNotConfirmed => 'Confirm your email, then try again.';

  @override
  String get authGeneric => 'Could not sign in. Try again.';

  @override
  String get languageAssamese => 'Assamese';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languageEnglish => 'English';

  @override
  String get guideSareeDrapedLook1 => 'Let the fabric fall naturally.';

  @override
  String get guideSareeDrapedLook2 => 'Folds follow the diagonal.';

  @override
  String get guideSareeDrapedLook3 => 'Use side lighting.';

  @override
  String get guideSareeEmbroideryBorder4 => 'Use a contrast background.';

  @override
  String get guideSareeFoldedStack1 =>
      'Folds stay parallel to the horizontal lines.';

  @override
  String get guideSareeFoldedStack2 => 'Use side lighting.';

  @override
  String get guideSareeFoldedStack3 => 'Keep the edge visible.';

  @override
  String get guideCushionFullCover1 =>
      'Lay the cover flat so the full pattern is visible.';

  @override
  String get guideCushionFullCover2 =>
      'Hold the phone directly above, not at an angle.';

  @override
  String get guideCushionFullCover3 =>
      'Keep the edges straight along the grid.';

  @override
  String get guideCushionTextureWeave3 => 'Use soft light.';

  @override
  String get guideCushionTextureWeave4 => 'Avoid harsh reflections.';

  @override
  String get guideCushionStackedThickness1 =>
      'Stack two covers so the buyer can see the thickness.';

  @override
  String get guideCushionStackedThickness2 =>
      'Keep the stacked edges facing the camera.';

  @override
  String get guideCushionStackedThickness3 =>
      'Use side light so each layer casts a soft shadow.';

  @override
  String get guideCushionCornerStitching1 =>
      'The corner shows stitching most clearly.';

  @override
  String get guideCushionCornerStitching2 =>
      'Move close until the corner fills the small frame.';

  @override
  String get guideCushionCornerStitching3 =>
      'Keep the stitching sharp and well-lit.';

  @override
  String get guideCushionInUse1 =>
      'Placing the cushion on a chair shows its real size.';

  @override
  String get guideCushionInUse2 =>
      'Choose a seat that does not compete with the pattern.';

  @override
  String get guideCushionInUse3 => 'Shoot at eye level, not from above.';

  @override
  String get guideShawlFullDesign3 =>
      'Stand straight in front, not to one side.';

  @override
  String get guideShawlTextureWeave3 => 'Use soft light.';

  @override
  String get guideShawlTextureWeave4 => 'Avoid harsh reflections.';

  @override
  String get guideShawlDrapedLook1 =>
      'Draping the shawl on a shoulder shows how heavy it is.';

  @override
  String get guideShawlDrapedLook2 => 'Let one end hang lower than the other.';

  @override
  String get guideShawlDrapedLook3 =>
      'Do not pin it — let the fabric fall on its own.';

  @override
  String get guideShawlBorderCorner1 =>
      'A close-up of the corner shows the weave and the border together.';

  @override
  String get guideShawlBorderCorner2 =>
      'Fold one corner back so both sides are visible.';

  @override
  String get guideShawlBorderCorner3 =>
      'Move close until the weave fills the frame.';

  @override
  String get guideShawlStackDisplay1 =>
      'Stack the shawl neatly with the folds visible.';

  @override
  String get guideShawlStackDisplay2 =>
      'Keep the folds parallel to the horizontal lines.';

  @override
  String get guideShawlStackDisplay3 =>
      'Use side lighting so each fold has depth.';

  @override
  String get guideStoleFullLength3 =>
      'Hold the phone directly above the middle.';

  @override
  String get guideStoleTextureWeave3 => 'Use soft light.';

  @override
  String get guideStoleTextureWeave4 => 'Avoid harsh reflections.';

  @override
  String get guideStoleWornNeckWrap1 =>
      'A worn shot answers how big the stole is.';

  @override
  String get guideStoleWornNeckWrap2 =>
      'Wrap it once around the neck and let both ends hang.';

  @override
  String get guideStoleWornNeckWrap3 =>
      'Shoot from the chest up so the ends stay in frame.';

  @override
  String get guideStoleSoftnessKnot1 =>
      'A loose knot shows how soft and light the stole is.';

  @override
  String get guideStoleSoftnessKnot2 => 'Tie it loosely — never pull it tight.';

  @override
  String get guideStoleSoftnessKnot3 =>
      'Keep the knot in the centre of the frame.';

  @override
  String get guideStoleEdgeThickness1 =>
      'Rolling the stole into a coil shows the edge and the thickness.';

  @override
  String get guideStoleEdgeThickness2 =>
      'Roll it loosely so the layers stay separate.';

  @override
  String get guideStoleEdgeThickness3 => 'Shoot straight down onto the coil.';
}
