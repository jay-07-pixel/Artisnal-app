// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Assamese (`as`).
class AppLocalizationsAs extends AppLocalizations {
  AppLocalizationsAs([String locale = 'as']) : super(locale);

  @override
  String get appTitle => 'দ্য আৰ্টিছানেল লেন্স';

  @override
  String get navHome => 'ঘৰ';

  @override
  String get navGallery => 'গেলাৰী';

  @override
  String get navNewProduct => 'নতুন সামগ্ৰী';

  @override
  String get navSettings => 'ছেটিংছ';

  @override
  String get continueAction => 'আগবাঢ়ক';

  @override
  String get openCamera => 'কেমেৰা খোলক';

  @override
  String get language => 'ভাষা';

  @override
  String get photographyGuide => 'ফটোগ্ৰাফী গাইড';

  @override
  String get photographyGuideSubtitle =>
      'এই এপে দিয়া প্ৰতিটো পৰামৰ্শৰ আঁৰৰ নিয়ম।';

  @override
  String get whatPhotographing => 'আজি আপুনি কিৰ\nফটো তুলিব?';

  @override
  String get continuePhotography => 'ফটোগ্ৰাফী অব্যাহত ৰাখক';

  @override
  String get previousSets => 'আগৰ ছেটসমূহ।';

  @override
  String get filterAll => 'সকলো';

  @override
  String get filterFinished => 'সম্পূৰ্ণ';

  @override
  String get filterPending => 'বাকী';

  @override
  String photosCompleted(int done, int total) {
    return '$total খনৰ $done খন ফটো সম্পূৰ্ণ';
  }

  @override
  String get emptyAll => 'এতিয়াও কোনো আগৰ ছেট নাই।';

  @override
  String get emptyFinished => 'এতিয়াও কোনো সম্পূৰ্ণ ছেট নাই।';

  @override
  String get emptyPending => 'কোনো অসম্পূৰ্ণ ছেট নাই।';

  @override
  String get newProduct => 'নতুন সামগ্ৰী';

  @override
  String get gallery => 'গেলাৰী';

  @override
  String get settings => 'ছেটিংছ';

  @override
  String get product => 'সামগ্ৰী';

  @override
  String get photos => 'ফটো';

  @override
  String get setup => 'ছেটআপ';

  @override
  String get tutorial => 'টিউটৰিয়েল';

  @override
  String get review => 'পৰ্যালোচনা';

  @override
  String get materialHeadline => 'আপুনি কোনবিধ কাপোৰৰ\nসৈতে কাম কৰি আছে?';

  @override
  String materialTypeHeadline(String material) {
    return 'আপুনি কি ধৰণৰ $material\nব্যৱহাৰ কৰিছে?';
  }

  @override
  String get giveProductName => 'আপোনাৰ সামগ্ৰীৰ নাম দিয়ক';

  @override
  String nameHint(String category) {
    return 'যেনে নীলা পট $category';
  }

  @override
  String get photosToCapture => 'তুলিবলগীয়া ফটো';

  @override
  String get photosToCaptureBody => 'এইকেইখন ফটো আপুনি তুলিব লাগিব।';

  @override
  String get sareePhotographyTemplatesTitle => 'শাড়ী ফটোগ্ৰাফী টেমপ্লেট';

  @override
  String get sareePhotographyTemplatesBody => 'এই পাঁচখন ফটো তুলিব লাগিব।';

  @override
  String get photographyTemplatesTitle => 'ফটোগ্ৰাফী টেমপ্লেট';

  @override
  String get photographyTemplatesBody => 'এই পাঁচখন ফটো তুলিব লাগিব।';

  @override
  String get viewCompletedSet => 'সম্পূৰ্ণ ছেট চাওক';

  @override
  String get allPhotosCaptured => 'সকলো ফটো তোলা হৈছে';

  @override
  String takeNext(String label) {
    return 'পৰৱৰ্তী তোলক — $label';
  }

  @override
  String get productUnavailable => 'এই সামগ্ৰী এতিয়া উপলব্ধ নহয়।';

  @override
  String get chooseAStyle => 'এটা শৈলী বাছক';

  @override
  String get howShouldItLook => 'ই কেনেকুৱা দেখাব লাগে?';

  @override
  String get stylePickFirst => 'প্ৰথমে তালিকাৰ পৰা এখন ফটো বাছক।';

  @override
  String get styleNoNeeded => 'এই ফটোৰ বাবে কোনো শৈলীৰ প্ৰয়োজন নাই।';

  @override
  String styleSubtitleSaree(String template) {
    return 'এই $template ফটোৰ সজাওক বাছক।';
  }

  @override
  String styleSubtitleShot(String shot) {
    return 'এই $shot ফটোৰ সজাওক বাছক।';
  }

  @override
  String styleSubtitleCategory(String category, String shot) {
    return 'এই $category $shot ফটোৰ সজাওক বাছক।';
  }

  @override
  String get labelContent => 'বিষয়';

  @override
  String get labelNeeds => 'প্ৰয়োজন';

  @override
  String get labelPlacement => 'ৰখাৰ ধৰণ';

  @override
  String get labelLighting => 'পোহৰ';

  @override
  String get labelGrid => 'গ্ৰিড';

  @override
  String contentPrefixed(String value) {
    return 'বিষয়: $value';
  }

  @override
  String needsPrefixed(String value) {
    return 'প্ৰয়োজন: $value';
  }

  @override
  String get lightingAndSetup => 'পোহৰ আৰু ছেটআপ';

  @override
  String get step1of2 => 'পদক্ষেপ ১ৰ ২';

  @override
  String get step2of2 => 'পদক্ষেপ ২ৰ ২';

  @override
  String get beforeYouShoot => 'ফটোৰ আগত';

  @override
  String get setupIllustrationPlaceholder => 'ছেটআপৰ ছবি পিছত যোগ কৰা হ\'ব';

  @override
  String get placeTheProduct => 'সামগ্ৰী ৰাখক';

  @override
  String get setupSection => 'ছেটআপ';

  @override
  String get watchHowToSetUp => 'ছেটআপ কেনেকৈ কৰিব চাওক';

  @override
  String tutorialSubtitlePreset(String name) {
    return '$name কেনেকৈ ছেটআপ কৰিব চাওক।';
  }

  @override
  String tutorialSubtitleTemplate(String name) {
    return '$name কেনেকৈ ছেটআপ কৰিব চাওক।';
  }

  @override
  String get tutorialSubtitleFallback =>
      'ভিডিঅ\' যোগ হোৱাৰ পিছত এই ছেটআপ দেখুওৱা হ\'ব।';

  @override
  String get transcript => 'ট্ৰান্সক্ৰিপ্ট';

  @override
  String get transcriptPlaceholder =>
      'টিউটৰিয়েল ভিডিঅ\' যোগ হোৱাৰ পিছত কোৱা কথা ইয়াত দেখা যাব।';

  @override
  String get tutorialVideoPlaceholder => 'টিউটৰিয়েল ভিডিঅ\' পিছত যোগ কৰা হ\'ব';

  @override
  String get referencePreset => 'সন্দৰ্ভ প্ৰিছেট';

  @override
  String get retake => 'পুনৰ তোলক';

  @override
  String get usePhoto => 'ফটো ব্যৱহাৰ কৰক';

  @override
  String get greatFraming => 'ফ্ৰেম ভাল';

  @override
  String get checkFraming => 'ফ্ৰেম চাওক';

  @override
  String get noPhotoToReview => 'পৰ্যালোচনাৰ বাবে কোনো ফটো নাই।';

  @override
  String get photoSetComplete => 'আপোনাৰ ফটো ছেট সম্পূৰ্ণ হ\'ল 🎉';

  @override
  String get viewPhotoSet => 'ফটো ছেট চাওক';

  @override
  String get startNewProduct => 'নতুন সামগ্ৰী আৰম্ভ কৰক';

  @override
  String get offlineBanner => 'অফলাইন — সংযোগ হ\'লে ফটো ছিংক হ\'ব';

  @override
  String get productNotFound => 'সামগ্ৰী পোৱা নগ\'ল।';

  @override
  String get exportPhotoSet => 'ফটো ছেট পঠিয়াওক';

  @override
  String continueCount(int done, int total) {
    return 'আগবাঢ়ক — $done/$total';
  }

  @override
  String get noPhotosToExport => 'পঠিয়াবলৈ এতিয়াও কোনো ফটো নাই।';

  @override
  String couldNotExport(String error) {
    return 'পঠিয়াব পৰা নগ\'ল: $error';
  }

  @override
  String exportShareText(String name, int count) {
    return '$name — $count খন ফটো, দ্য আৰ্টিছানেল লেন্সৰে তোলা';
  }

  @override
  String couldNotSavePhoto(String error) {
    return 'ফটো ছেভ কৰিব পৰা নগ\'ল: $error';
  }

  @override
  String get galleryEmpty =>
      'এতিয়াও কোনো ফটো ছেট নাই।\nআৰম্ভ কৰিবলৈ নতুন সামগ্ৰী বনাওক।';

  @override
  String get galleryEmptyFiltered => 'এই শ্ৰেণীত এতিয়াও একো নাই।';

  @override
  String get showAll => 'সকলো দেখুৱাওক';

  @override
  String get nextPill => 'পৰৱৰ্তী';

  @override
  String get templateOverline => 'টেমপ্লেট';

  @override
  String get proTipGoodLight =>
      'পৰামৰ্শ: সামগ্ৰীৰ ফটোৰ বাবে এতিয়া প্ৰাকৃতিক পোহৰেই শ্ৰেষ্ঠ।';

  @override
  String get chipLight => 'পোহৰ';

  @override
  String get chipDistance => 'দূৰত্ব';

  @override
  String get chipCentre => 'কেন্দ্ৰ';

  @override
  String get chipEmDash => '—';

  @override
  String get readingTheFrame => 'ফ্ৰেম পঢ়ি আছে…';

  @override
  String fillFrameWith(String slot) {
    return '$slotৰে ফ্ৰেম ভৰাওক';
  }

  @override
  String promptNoProduct(String product) {
    return '$productখন সন্মুখত ৰাখক';
  }

  @override
  String promptMoveIntoFrame(String product) {
    return '$productখন ফ্ৰেমৰ ভিতৰলৈ আনক';
  }

  @override
  String promptKeepInsideFrame(String product) {
    return '$productখন ফ্ৰেমৰ ভিতৰত ৰাখক';
  }

  @override
  String get promptAlignHorizontal => 'ভাঁজবোৰ আনুভূমিক গাইডৰ সৈতে মিলাওক';

  @override
  String get promptAlignDiagonal => 'কাপোৰক তিৰ্যক গাইডৰ সৈতে যাবলৈ দিয়ক';

  @override
  String get promptHoldSteady => 'ফোন স্থিৰকৈ ধৰক';

  @override
  String get promptMoveCloser => 'ওচৰলৈ যাওক';

  @override
  String get promptMoveFurther => 'বিষয়ৰ পৰা আৰু আঁতৰলৈ যাওক';

  @override
  String promptCenterSubject(String product) {
    return '$productখন মাজত ৰাখক';
  }

  @override
  String get promptKeepTextureCentre => 'গঠনটো কেন্দ্ৰত ৰাখক';

  @override
  String get promptKeepBorderInside => 'বৰ্ডাৰ ফ্ৰেমৰ ভিতৰত ৰাখক';

  @override
  String get promptKeepFoldsVisible => 'ভাঁজবোৰ দেখা থাকক';

  @override
  String get promptBacklight => 'পিছফালৰ পোহৰ ধৰা পৰিছে';

  @override
  String get promptTooDark => 'বৰ আন্ধাৰ — খিৰিকীৰ ওচৰলৈ বা বাহিৰলৈ যাওক';

  @override
  String get promptLowLight => 'পোহৰ কম — খিৰিকীৰ আৰু ওচৰলৈ যাওক';

  @override
  String get promptTooBright => 'বৰ উজ্জ্বল — খোলা ছাঁত যাওক';

  @override
  String get promptTiltPhone => 'কোণৰ গাইড অনুসৰি ফোন হেলনীয়া কৰক';

  @override
  String get promptReady => 'ফটো তুলিবলৈ সাজু';

  @override
  String get lightTooDark => 'বৰ আন্ধাৰ';

  @override
  String get lightLow => 'কম';

  @override
  String get lightOk => 'ঠিক আছে';

  @override
  String get lightBright => 'উজ্জ্বল';

  @override
  String get distanceMoveCloser => 'ওচৰলৈ যাওক';

  @override
  String get distanceOk => 'ঠিক আছে';

  @override
  String get distanceMoveBack => 'পিছলৈ যাওক';

  @override
  String get centreMoveIn => 'ভিতৰলৈ আনক';

  @override
  String get centreOk => 'ঠিক আছে';

  @override
  String get advisoryGoodHeadline => 'এতিয়া পোহৰ ভাল';

  @override
  String get advisoryGoodDetail =>
      'প্ৰাকৃতিক পোহৰ কোমল, ৰং স্পষ্ট আৰু সঁচা দেখা যাব।';

  @override
  String get advisoryOverheadHeadline => 'মূৰৰ ওপৰৰ ৰ\'দ';

  @override
  String get advisoryOverheadDetail =>
      'পোহৰ কোমল হোৱাৰ পিছত ফটো তোলক। এতিয়া ওপৰৰ ৰ\'দে ছেটআপত কঠিন ছাঁ পেলাব পাৰে।';

  @override
  String get advisoryDarkHeadline => 'দিনৰ পোহৰ যথেষ্ট নহয়';

  @override
  String get advisoryDarkDetail =>
      'এতিয়া প্ৰাকৃতিক পোহৰ কম। ৰাতিপুৱা খিৰিকীৰ ওচৰত ৰং সকলোতকৈ সঁচা দেখা যায়।';

  @override
  String get openingTagline => 'হস্তশিল্প সামগ্ৰীৰ বাবে নিৰ্দেশিত ফটোগ্ৰাফী';

  @override
  String get openingChipLight => 'পোহৰ: ভাল';

  @override
  String get openingChipAngle => 'কোণ: ঠিক';

  @override
  String get openingChipFrame => 'ফ্ৰেম: সাজু';

  @override
  String get guidelineG1Title => 'ক্ল\'জ-আপ শ্বট লওক';

  @override
  String get guidelineG1Body =>
      'কাপোৰৰ সূক্ষ্ম গঠন, বিৱৰণ আৰু কাৰুকাৰ্য দেখুৱাওক।';

  @override
  String get guidelineG2Title => 'কাপোৰৰ কাষ দেখুৱাওক';

  @override
  String get guidelineG2Body =>
      'কাপোৰৰ কাষ তোলক, ছবিৰ দুই-তৃতীয়াংশ কাপোৰেৰে ভৰা থাকক।';

  @override
  String get guidelineG3Title => 'কেইবাটাও কোণৰ পৰা তোলক';

  @override
  String get guidelineG3Body =>
      'ডিজাইন আৰু গঠন দেখুৱাবলৈ সামগ্ৰীক কেইবাটাও দৃষ্টিৰে দেখুৱাওক।';

  @override
  String get guidelineG4Title => 'বিভিন্ন পোহৰ চেষ্টা কৰক';

  @override
  String get guidelineG4Body =>
      'প্ৰাকৃতিক আৰু কৃত্ৰিম পোহৰ, ঘৰৰ ভিতৰত আৰু বাহিৰত, সন্মুখ আৰু কাষৰ পোহৰ — যাতে কাপোৰৰ সঁচা ৰং আৰু গভীৰতা ওলায়।';

  @override
  String get guidelineG5Title => 'সহযোগী পৃষ্ঠভূমি বাছক';

  @override
  String get guidelineG5Body =>
      'এনে পৃষ্ঠভূমি ৰাখক যি কাপোৰৰ সৌন্দৰ্য বাঢ়ায়, কিন্তু তাৰ ওপৰত জয়ী নহয়।';

  @override
  String get guidelineG6Title => 'প্ৰাকৃতিক ভাঁজ থাকিবলৈ দিয়ক';

  @override
  String get guidelineG6Body =>
      'ইস্ত্ৰি নকৰা অৱস্থাতে কাপোৰৰ ফটো তোলক যাতে সামগ্ৰী স্পষ্টকৈ বুজা যায়।';

  @override
  String get guidelineG7Title => 'ওজন আৰু প্ৰবাহ দেখুৱাওক';

  @override
  String get guidelineG7Body =>
      'কাপোৰ কেনেকৈ ওলমে, ভাঁজ খায় আৰু বৈ যায়, সেয়াই তাৰ ওজন আৰু অনুভৱ কয়।';

  @override
  String get guidelineG8Title => 'এটা কাহিনী কওক';

  @override
  String get guidelineG8Body =>
      'এনেদৰে ফ্ৰেম কৰক যাতে কাপোৰ নিজৰ সংস্কৃতি, শিল্পী আৰু ব্যৱহাৰৰ সৈতে জড়িত দেখা যায়।';

  @override
  String get categorySaree => 'শাড়ী';

  @override
  String get categoryCushionCover => 'কুশ্বন কভাৰ';

  @override
  String get categoryShawl => 'শাল';

  @override
  String get categoryStole => 'ষ্টোল';

  @override
  String get categorySarees => 'শাড়ী';

  @override
  String get categoryCushionCovers => 'কুশ্বন কভাৰ';

  @override
  String get categoryShawls => 'শাল';

  @override
  String get categoryStoles => 'ষ্টোল';

  @override
  String get nounSaree => 'শাড়ী';

  @override
  String get nounCushionCover => 'কুশ্বন কভাৰ';

  @override
  String get nounShawl => 'শাল';

  @override
  String get nounStole => 'ষ্টোল';

  @override
  String get nounProduct => 'সামগ্ৰী';

  @override
  String get materialSilk => 'পাট';

  @override
  String get materialCotton => 'কপাহ';

  @override
  String get materialWool => 'উল';

  @override
  String get materialJute => 'পাটশণ';

  @override
  String get materialSilkLower => 'পাট';

  @override
  String get materialCottonLower => 'কপাহ';

  @override
  String get materialWoolLower => 'উল';

  @override
  String get materialJuteLower => 'পাটশণ';

  @override
  String get silkMulberry => 'মালবেৰী';

  @override
  String get silkEri => 'এৰি';

  @override
  String get silkTasar => 'তছৰ';

  @override
  String get silkMuga => 'মুগা';

  @override
  String get cottonKhadi => 'খাদী';

  @override
  String get cottonMuslin => 'মলমল';

  @override
  String get cottonHandloom => 'হাতে তোৰা';

  @override
  String get cottonJamdani => 'জমদানি';

  @override
  String get woolPashmina => 'পশ্মিনা';

  @override
  String get woolAngora => 'এংগোৰা';

  @override
  String get woolMerino => 'মেৰিনো';

  @override
  String get woolHandspun => 'হাতে কটা';

  @override
  String get juteGolden => 'সোণালী';

  @override
  String get juteTossa => 'টোছা';

  @override
  String get juteHessian => 'হেছিয়ান';

  @override
  String get juteBlended => 'মিশ্ৰিত';

  @override
  String get shotProcess => 'প্ৰক্ৰিয়া';

  @override
  String get shotProduct => 'সামগ্ৰী';

  @override
  String get shotDetail => 'বিৱৰণ';

  @override
  String get shotLifestyle => 'লাইফষ্টাইল';

  @override
  String get shotPhotography => 'ফটোগ্ৰাফী';

  @override
  String get shotProcessChecklist => 'বনোৱাৰ প্ৰক্ৰিয়া দেখুৱাওক';

  @override
  String get shotProductChecklist => 'সম্পূৰ্ণ বস্তুৰ ফটো';

  @override
  String get shotDetailChecklist => 'গঠন/বয়নৰ ক্ল\'জ-আপ';

  @override
  String get shotLifestyleChecklist => 'প্ৰাকৃতিক পৰিৱেশত';

  @override
  String get shotPhotographyChecklist => 'শাড়ী ফটোগ্ৰাফী টেমপ্লেট';

  @override
  String get slotLoomSetup => 'তাঁত ছেটআপ';

  @override
  String get slotDyeing => 'ৰং কৰা';

  @override
  String get slotHeroShot => 'মূল ফটো';

  @override
  String get slotBorder => 'বৰ্ডাৰ';

  @override
  String get slotWeave => 'বয়ন';

  @override
  String get slotMotif => 'মটিফ';

  @override
  String get slotStyledShot => 'শৈলীৰ ফটো';

  @override
  String get templateFullDisplay => 'সম্পূৰ্ণ শাড়ী প্ৰদৰ্শন';

  @override
  String get templateTextureWeave => 'গঠন আৰু বয়ন';

  @override
  String get templateDrapedLook => 'ড্ৰেপ লুক';

  @override
  String get templateEmbroideryBorder => 'এমব্ৰয়ডাৰী আৰু বৰ্ডাৰৰ বিৱৰণ';

  @override
  String get templateFoldedStack => 'ভাঁজ কৰা দ\'ম / শাড়ী ষ্টেক';

  @override
  String get templateFullDisplayLower => 'সম্পূৰ্ণ শাড়ী প্ৰদৰ্শন';

  @override
  String get templateTextureWeaveLower => 'গঠন আৰু বয়ন';

  @override
  String get templateDrapedLookLower => 'ড্ৰেপ লুক';

  @override
  String get templateEmbroideryBorderLower => 'এমব্ৰয়ডাৰী আৰু বৰ্ডাৰৰ বিৱৰণ';

  @override
  String get templateFoldedStackLower => 'ভাঁজ কৰা দ\'ম / শাড়ী ষ্টেক';

  @override
  String get templateFullDisplayContent => 'ৰং, আৰ্হি, সামগ্ৰী';

  @override
  String get templateTextureWeaveContent => 'গঠন, ডাঠতা, সামগ্ৰী, স্বচ্ছতা';

  @override
  String get templateDrapedLookContent => 'পাতলতা, চিকমিকনি, প্ৰবাহ, ওজন';

  @override
  String get templateEmbroideryBorderContent => 'এমব্ৰয়ডাৰী, গুণগত মান';

  @override
  String get templateFoldedStackContent => 'ডাঠতা, সামগ্ৰীৰ ওজন';

  @override
  String get templateFullDisplayNeeds =>
      'প্ৰাকৃতিক দিনৰ পোহৰ; নিৰপেক্ষ বা বিপৰীত পৃষ্ঠভূমি';

  @override
  String get templateTextureWeaveNeeds => 'যিমান পাৰি প্ৰাকৃতিক পোহৰ';

  @override
  String get templateDrapedLookNeeds => 'হেংগাৰ, বাঁহ বা পুতলা; কাষৰ পোহৰ';

  @override
  String get templateEmbroideryBorderNeeds => 'কাষৰ পোহৰ; বিপৰীত পৃষ্ঠভূমি';

  @override
  String get templateFoldedStackNeeds => 'কাষৰ পোহৰ';

  @override
  String get templateFullDisplayPlacement =>
      'শাড়ী সমতলকৈ মেলি বা পৃষ্ঠত ওলোমাই ৰাখক';

  @override
  String get templateTextureWeavePlacement =>
      'শাড়ীৰ ভালকৈ পোহৰ পৰা অংশ, ভাল হয় প্ৰাকৃতিক পোহৰত';

  @override
  String get templateDrapedLookPlacement => 'হেংগাৰ, বাঁহ বা পুতলা';

  @override
  String get templateEmbroideryBorderPlacement =>
      'শাড়ীৰ বৰ্ডাৰ বা এমব্ৰয়ডাৰী অংশৰ ক্ল\'জ-আপ';

  @override
  String get templateFoldedStackPlacement => 'চাফা দ\'ম, ভাঁজ দেখা যায়';

  @override
  String get templateFullDisplayOverlay =>
      'ওপৰৰ বৰ্ডাৰ গ্ৰিডৰ ওপৰৰ তৃতীয়াংশৰ সৈতে মিলাওক';

  @override
  String get templateTextureWeaveOverlay => 'গঠনটো কেন্দ্ৰত ৰাখক';

  @override
  String get templateDrapedLookOverlay =>
      'ভাঁজবোৰ তিৰ্যক ৰেখাৰ সৈতে যাবলৈ দিয়ক';

  @override
  String get templateEmbroideryBorderOverlay => 'এমব্ৰয়ডাৰী ফ্ৰেমৰ ভিতৰত ৰাখক';

  @override
  String get templateFoldedStackOverlay =>
      'ভাঁজবোৰ আনুভূমিক ৰেখাৰ সমান্তৰাল ৰাখক';

  @override
  String get templateTextureWeaveLighting =>
      'কোমল পোহৰ ব্যৱহাৰ কৰক। তীব্ৰ প্ৰতিফলন এৰাই চলক।';

  @override
  String get templateCushionFullCover => 'সম্পূৰ্ণ কভাৰ প্ৰদৰ্শন';

  @override
  String get templateCushionTextureWeave => 'গঠন আৰু বয়ন';

  @override
  String get templateCushionStackedPair => 'যোৰাৰ দ\'ম / ডাঠতা';

  @override
  String get templateCushionCornerStitching => 'কোণ আৰু চিলাই';

  @override
  String get templateCushionInUse => 'আসনত ব্যৱহাৰত';

  @override
  String get templateCushionFullCoverLower => 'সম্পূৰ্ণ কভাৰ প্ৰদৰ্শন';

  @override
  String get templateCushionTextureWeaveLower => 'গঠন আৰু বয়ন';

  @override
  String get templateCushionStackedPairLower => 'যোৰাৰ দ\'ম / ডাঠতা';

  @override
  String get templateCushionCornerStitchingLower => 'কোণ আৰু চিলাই';

  @override
  String get templateCushionInUseLower => 'আসনত ব্যৱহাৰত';

  @override
  String get templateCushionFullCoverContent => 'ৰং, আৰ্হি, সামগ্ৰী';

  @override
  String get templateCushionTextureWeaveContent => 'গঠন, ডাঠতা, সামগ্ৰী';

  @override
  String get templateCushionStackedPairContent => 'ডাঠতা, সামগ্ৰী, গঠন';

  @override
  String get templateCushionCornerStitchingContent =>
      'গুণগত মান, গঠন, এমব্ৰয়ডাৰী';

  @override
  String get templateCushionInUseContent => 'ৰং, আৰ্হি, গুণগত মান';

  @override
  String get templateCushionFullCoverNeeds =>
      'প্ৰাকৃতিক দিনৰ পোহৰ; সাধাৰণ পৃষ্ঠ';

  @override
  String get templateCushionTextureWeaveNeeds => 'যিমান পাৰি প্ৰাকৃতিক পোহৰ';

  @override
  String get templateCushionStackedPairNeeds => 'কাষৰ পোহৰ; এযোৰ কভাৰ';

  @override
  String get templateCushionCornerStitchingNeeds => 'কাষৰ পোহৰ';

  @override
  String get templateCushionInUseNeeds => 'কুৰ্ছী, ছোফা বা বিচনা';

  @override
  String get templateCushionFullCoverPlacement =>
      'কভাৰখন সাধাৰণ পৃষ্ঠত সমতলকৈ ৰাখক';

  @override
  String get templateCushionTextureWeavePlacement => 'কভাৰৰ ভালকৈ পোহৰ পৰা অংশ';

  @override
  String get templateCushionStackedPairPlacement =>
      'দুখন কভাৰ এনেদৰে থাপক যাতে কাষবোৰ কেমেৰাৰ ফালে থাকে';

  @override
  String get templateCushionCornerStitchingPlacement =>
      'চিলাই কৰা কোণৰ ক্ল\'জ-আপ';

  @override
  String get templateCushionInUsePlacement =>
      'কভাৰখন আসনত থিয় কৰাই কেমেৰাৰ ফালে ৰাখক';

  @override
  String get templateCushionFullCoverOverlay => 'কাষবোৰ গ্ৰিডৰ সৈতে পোনকৈ ৰাখক';

  @override
  String get templateCushionTextureWeaveOverlay => 'গঠনটো কেন্দ্ৰত ৰাখক';

  @override
  String get templateCushionStackedPairOverlay =>
      'ভাঁজবোৰ আনুভূমিক ৰেখাৰ সমান্তৰাল ৰাখক';

  @override
  String get templateCushionCornerStitchingOverlay => 'চিলাই ফ্ৰেমৰ ভিতৰত ৰাখক';

  @override
  String get templateCushionInUseOverlay => 'কভাৰখন ফ্ৰেমত ৰাখক';

  @override
  String get templateShawlFullDesign => 'সম্পূৰ্ণ ডিজাইন প্ৰদৰ্শন';

  @override
  String get templateShawlTextureWeave => 'গঠন আৰু বয়ন';

  @override
  String get templateShawlDrapedLook => 'ড্ৰেপ লুক';

  @override
  String get templateShawlBorderCorner => 'বৰ্ডাৰ আৰু কোণ';

  @override
  String get templateShawlFoldedStack => 'ভাঁজ কৰা দ\'ম';

  @override
  String get templateShawlFullDesignLower => 'সম্পূৰ্ণ ডিজাইন প্ৰদৰ্শন';

  @override
  String get templateShawlTextureWeaveLower => 'গঠন আৰু বয়ন';

  @override
  String get templateShawlDrapedLookLower => 'ড্ৰেপ লুক';

  @override
  String get templateShawlBorderCornerLower => 'বৰ্ডাৰ আৰু কোণ';

  @override
  String get templateShawlFoldedStackLower => 'ভাঁজ কৰা দ\'ম';

  @override
  String get templateShawlFullDesignContent => 'আৰ্হি, ৰং, স্বচ্ছতা';

  @override
  String get templateShawlTextureWeaveContent => 'গঠন, ডাঠতা, সামগ্ৰী';

  @override
  String get templateShawlDrapedLookContent => 'পাতলতা, সামগ্ৰী, আৰ্হি';

  @override
  String get templateShawlBorderCornerContent => 'গঠন, গুণগত মান, এমব্ৰয়ডাৰী';

  @override
  String get templateShawlFoldedStackContent => 'ডাঠতা, সামগ্ৰী';

  @override
  String get templateShawlFullDesignNeeds => 'ৰছী, বাঁহ বা দেৱাল য\'ত পিন কৰিব';

  @override
  String get templateShawlTextureWeaveNeeds => 'যিমান পাৰি প্ৰাকৃতিক পোহৰ';

  @override
  String get templateShawlDrapedLookNeeds => 'শাল পিন্ধা কোনোবা';

  @override
  String get templateShawlBorderCornerNeeds => 'কাষৰ পোহৰ';

  @override
  String get templateShawlFoldedStackNeeds => 'কাষৰ পোহৰ';

  @override
  String get templateShawlFullDesignPlacement =>
      'শাল নামি নোযোৱাকৈ সমতলকৈ ওলোমাই বা পিন কৰক';

  @override
  String get templateShawlTextureWeavePlacement => 'শালৰ ভালকৈ পোহৰ পৰা অংশ';

  @override
  String get templateShawlDrapedLookPlacement =>
      'শাল এখন কান্ধত, স্বাভাৱিকভাৱে সৰি পৰা';

  @override
  String get templateShawlBorderCornerPlacement => 'কোণ আৰু বৰ্ডাৰৰ ক্ল\'জ-আপ';

  @override
  String get templateShawlFoldedStackPlacement => 'চাফা দ\'ম, ভাঁজ দেখা যায়';

  @override
  String get templateShawlFullDesignOverlay =>
      'বৰ্ডাৰ গ্ৰিডৰ ওপৰৰ তৃতীয়াংশৰ সৈতে মিলাওক';

  @override
  String get templateShawlTextureWeaveOverlay => 'গঠনটো কেন্দ্ৰত ৰাখক';

  @override
  String get templateShawlDrapedLookOverlay =>
      'ভাঁজবোৰ তিৰ্যক ৰেখাৰ সৈতে যাবলৈ দিয়ক';

  @override
  String get templateShawlBorderCornerOverlay => 'বৰ্ডাৰ ফ্ৰেমৰ ভিতৰত ৰাখক';

  @override
  String get templateShawlFoldedStackOverlay =>
      'ভাঁজবোৰ আনুভূমিক ৰেখাৰ সমান্তৰাল ৰাখক';

  @override
  String get templateStoleFullLength => 'সম্পূৰ্ণ দৈৰ্ঘ্যৰ প্ৰদৰ্শন';

  @override
  String get templateStoleTextureWeave => 'গঠন আৰু বয়ন';

  @override
  String get templateStoleNeckWrap => 'পৰিধান কৰা ডিঙি ৰেপ';

  @override
  String get templateStoleSoftnessKnot => 'কোমলতা / গাঁঠি';

  @override
  String get templateStoleEdgeThickness => 'কাষ আৰু ডাঠতা';

  @override
  String get templateStoleFullLengthLower => 'সম্পূৰ্ণ দৈৰ্ঘ্যৰ প্ৰদৰ্শন';

  @override
  String get templateStoleTextureWeaveLower => 'গঠন আৰু বয়ন';

  @override
  String get templateStoleNeckWrapLower => 'পৰিধান কৰা ডিঙি ৰেপ';

  @override
  String get templateStoleSoftnessKnotLower => 'কোমলতা / গাঁঠি';

  @override
  String get templateStoleEdgeThicknessLower => 'কাষ আৰু ডাঠতা';

  @override
  String get templateStoleFullLengthContent => 'আৰ্হি, ৰং, সামগ্ৰী';

  @override
  String get templateStoleTextureWeaveContent => 'গঠন, ডাঠতা, সামগ্ৰী';

  @override
  String get templateStoleNeckWrapContent => 'পাতলতা, ৰং, আৰ্হি';

  @override
  String get templateStoleSoftnessKnotContent => 'পাতলতা, গঠন, সামগ্ৰী';

  @override
  String get templateStoleEdgeThicknessContent => 'ডাঠতা, গঠন, সামগ্ৰী';

  @override
  String get templateStoleFullLengthNeeds =>
      'প্ৰাকৃতিক দিনৰ পোহৰ; সাধাৰণ পৃষ্ঠ';

  @override
  String get templateStoleTextureWeaveNeeds => 'যিমান পাৰি প্ৰাকৃতিক পোহৰ';

  @override
  String get templateStoleNeckWrapNeeds => 'ষ্টোল পিন্ধা কোনোবা';

  @override
  String get templateStoleSoftnessKnotNeeds => 'কোমল কাষৰ পোহৰ';

  @override
  String get templateStoleEdgeThicknessNeeds => 'কোমল কাষৰ পোহৰ';

  @override
  String get templateStoleFullLengthPlacement =>
      'ষ্টোল সম্পূৰ্ণ দৈৰ্ঘ্য দেখা পোৱাকৈ মেলি দিয়ক';

  @override
  String get templateStoleTextureWeavePlacement => 'ষ্টোলৰ ভালকৈ পোহৰ পৰা অংশ';

  @override
  String get templateStoleNeckWrapPlacement =>
      'ডিঙিত এবাৰ মেৰিয়াই দুয়ো মূৰ দেখা যায়';

  @override
  String get templateStoleSoftnessKnotPlacement => 'মাজত এটা ঢিলা গাঁঠি';

  @override
  String get templateStoleEdgeThicknessPlacement => 'ষ্টোল ঢিলাকৈ কুণ্ডলিত কৰক';

  @override
  String get templateStoleFullLengthOverlay => 'ষ্টোল গ্ৰিডৰ সৈতে ৰাখক';

  @override
  String get templateStoleTextureWeaveOverlay => 'গঠনটো কেন্দ্ৰত ৰাখক';

  @override
  String get templateStoleNeckWrapOverlay => 'ৰেপ ফ্ৰেমত ৰাখক';

  @override
  String get templateStoleSoftnessKnotOverlay => 'গাঁঠি কেন্দ্ৰত ৰাখক';

  @override
  String get templateStoleEdgeThicknessOverlay => 'কুণ্ডলী কেন্দ্ৰত ৰাখক';

  @override
  String get presetSareePalluDrapeName => 'পল্লু ড্ৰেপ (হেংগাৰ)';

  @override
  String get presetSareeBoxFoldName => 'বাকচ / সমতল ভাঁজ';

  @override
  String get presetSareeWornDrapeName => 'পৰিধান কৰা ড্ৰেপ (মডেল)';

  @override
  String get presetSareeRollDisplayName => 'ৰোল প্ৰদৰ্শন';

  @override
  String get presetCushionFlatLayName => 'ফ্লেট লে';

  @override
  String get presetCushionStackedPairName => 'যোৰা দ\'ম';

  @override
  String get presetCushionProppedName => 'আসনত থিয় কৰাই';

  @override
  String get presetCushionCornerTuckName => 'কোণৰ ক্ল\'জ-আপ';

  @override
  String get presetShawlDrapedShoulderName => 'কান্ধত ওলোমাই';

  @override
  String get presetShawlFoldedStackName => 'ভাঁজ কৰা দ\'ম';

  @override
  String get presetShawlHungFlatName => 'ওলোমাই / সমতল পিন কৰা';

  @override
  String get presetShawlCornerTuckName => 'কোণৰ ক্ল\'জ-আপ';

  @override
  String get presetStoleNeckWrapName => 'ডিঙিত মেৰাই (পৰিধান)';

  @override
  String get presetStoleFlatSpreadName => 'সমতলকৈ মেলা';

  @override
  String get presetStoleLooseKnotName => 'ঢিলা গাঁঠি';

  @override
  String get presetStoleRolledCoilName => 'ৰোল কুণ্ডলী';

  @override
  String get presetSareePalluDrapePurpose =>
      'পাতলতা, চিকমিকনি, প্ৰবাহ আৰু ওজন দেখুৱায়।';

  @override
  String get presetSareeBoxFoldPurpose => 'ডাঠতা আৰু সামগ্ৰীৰ ওজন দেখুৱায়।';

  @override
  String get presetSareeWornDrapePurpose =>
      'পৰিধান কৰোঁতে ৰং, আৰ্হি আৰু সামগ্ৰী দেখুৱায়।';

  @override
  String get presetSareeRollDisplayPurpose =>
      'সৰু ৰোলত ৰং, আৰ্হি আৰু সামগ্ৰী দেখুৱায়।';

  @override
  String get presetCushionFlatLayPurpose =>
      'সম্পূৰ্ণ আৰ্হি আৰু ৰং বিকৃত নকৰাকৈ দেখুৱাওক।';

  @override
  String get presetCushionStackedPairPurpose =>
      'ডাঠতা আৰু যোৰা কেনেকুৱা দেখা যায়, দেখুৱাওক।';

  @override
  String get presetCushionProppedPurpose =>
      'কভাৰ ব্যৱহাৰত, প্ৰকৃত আকাৰত দেখুৱাওক।';

  @override
  String get presetCushionCornerTuckPurpose => 'কোণত চিলাই আৰু ফিনিচ দেখুৱাওক।';

  @override
  String get presetShawlDrapedShoulderPurpose =>
      'ড্ৰেপ, ওজন আৰু পৰিধানত কেনেকৈ বহে দেখুৱাওক।';

  @override
  String get presetShawlFoldedStackPurpose =>
      'ডাঠতা আৰু সামগ্ৰীৰ ওজন দেখুৱাওক।';

  @override
  String get presetShawlHungFlatPurpose =>
      'সম্পূৰ্ণ ডিজাইন, ৰং আৰু বৰ্ডাৰ একেলগে দেখুৱাওক।';

  @override
  String get presetShawlCornerTuckPurpose =>
      'বয়ন, বৰ্ডাৰ আৰু কাৰুকাৰ্য দেখুৱাওক।';

  @override
  String get presetStoleNeckWrapPurpose =>
      'আকাৰ আৰু পৰিধানত ষ্টোল কেনেকৈ বহে দেখুৱাওক।';

  @override
  String get presetStoleFlatSpreadPurpose =>
      'সম্পূৰ্ণ দৈৰ্ঘ্য, আৰ্হি আৰু দুয়োখন বৰ্ডাৰ দেখুৱাওক।';

  @override
  String get presetStoleLooseKnotPurpose =>
      'কাপোৰ কিমান কোমল আৰু কিমান সহজে গাঁঠি হয় দেখুৱাওক।';

  @override
  String get presetStoleRolledCoilPurpose =>
      'কাষ, ডাঠতা আৰু বয়নৰ ফিনিচ দেখুৱাওক।';

  @override
  String get presetSareePalluDrapeContent => 'পাতলতা, চিকমিকনি, প্ৰবাহ, ওজন';

  @override
  String get presetSareeBoxFoldContent => 'ডাঠতা, সামগ্ৰীৰ ওজন';

  @override
  String get presetSareeWornDrapeContent => 'ৰং, আৰ্হি, সামগ্ৰী';

  @override
  String get presetSareeRollDisplayContent => 'ৰং, আৰ্হি, সামগ্ৰী';

  @override
  String get presetSareePalluDrapeNeeds => 'হেংগাৰ, বাঁহ বা পুতলা; কাষৰ পোহৰ';

  @override
  String get presetSareeBoxFoldNeeds => 'কাষৰ পোহৰ';

  @override
  String get presetSareeWornDrapeNeeds =>
      'শাড়ী পিন্ধিবলৈ কোনোবা; প্ৰাকৃতিক দিনৰ পোহৰ; নিৰপেক্ষ বা বিপৰীত পৃষ্ঠভূমি';

  @override
  String get presetSareeRollDisplayNeeds =>
      'প্ৰাকৃতিক দিনৰ পোহৰ; নিৰপেক্ষ বা বিপৰীত পৃষ্ঠভূমি';

  @override
  String get presetSareePalluDrapeLower => 'পল্লু ড্ৰেপ (হেংগাৰ)';

  @override
  String get presetSareeBoxFoldLower => 'বাকচ / সমতল ভাঁজ';

  @override
  String get presetSareeWornDrapeLower => 'পৰিধান কৰা ড্ৰেপ (মডেল)';

  @override
  String get presetSareeRollDisplayLower => 'ৰোল প্ৰদৰ্শন';

  @override
  String get presetCushionFlatLayLower => 'ফ্লেট লে';

  @override
  String get presetCushionStackedPairLower => 'যোৰা দ\'ম';

  @override
  String get presetCushionProppedLower => 'আসনত থিয় কৰাই';

  @override
  String get presetCushionCornerTuckLower => 'কোণৰ ক্ল\'জ-আপ';

  @override
  String get presetShawlDrapedShoulderLower => 'কান্ধত ওলোমাই';

  @override
  String get presetShawlFoldedStackLower => 'ভাঁজ কৰা দ\'ম';

  @override
  String get presetShawlHungFlatLower => 'ওলোমাই / সমতল পিন কৰা';

  @override
  String get presetShawlCornerTuckLower => 'কোণৰ ক্ল\'জ-আপ';

  @override
  String get presetStoleNeckWrapLower => 'ডিঙিত মেৰাই (পৰিধান)';

  @override
  String get presetStoleFlatSpreadLower => 'সমতলকৈ মেলা';

  @override
  String get presetStoleLooseKnotLower => 'ঢিলা গাঁঠি';

  @override
  String get presetStoleRolledCoilLower => 'ৰোল কুণ্ডলী';

  @override
  String get shotProcessLower => 'প্ৰক্ৰিয়া';

  @override
  String get shotProductLower => 'সামগ্ৰী';

  @override
  String get shotDetailLower => 'বিৱৰণ';

  @override
  String get shotLifestyleLower => 'লাইফষ্টাইল';

  @override
  String get shotPhotographyLower => 'ফটোগ্ৰাফী';

  @override
  String get categorySareeLower => 'শাড়ী';

  @override
  String get categoryCushionCoverLower => 'কুশ্বন কভাৰ';

  @override
  String get categoryShawlLower => 'শাল';

  @override
  String get categoryStoleLower => 'ষ্টোল';

  @override
  String get propertyColour => 'ৰং';

  @override
  String get propertyMaterial => 'সামগ্ৰী';

  @override
  String get propertyQuality => 'গুণগত মান';

  @override
  String get propertyFlimsiness => 'পাতলতা';

  @override
  String get propertyTexture => 'গঠন';

  @override
  String get propertyThickness => 'ডাঠতা';

  @override
  String get propertyTransparency => 'স্বচ্ছতা';

  @override
  String get propertyPattern => 'আৰ্হি';

  @override
  String get propertySheen => 'চিকমিকনি';

  @override
  String get propertyEmbroidery => 'এমব্ৰয়ডাৰী';

  @override
  String get angleEyeLevel => 'চকুৰ উচ্চতা';

  @override
  String get angleEyeLevelHint => 'ফোন সামগ্ৰীৰ উচ্চতাত, পোনকৈ সন্মুখত ৰাখক।';

  @override
  String get angleOverhead => 'ওপৰৰ পৰা (ফ্লেট লে)';

  @override
  String get angleOverheadHint => 'সামগ্ৰীৰ ওপৰত থিয় হৈ ফোন পোনকৈ তললৈ কৰক।';

  @override
  String get angleLow => 'তলৰ কোণ';

  @override
  String get angleLowHint => 'ফোন সামগ্ৰীতকৈ তললৈ কৰি অলপ ওপৰলৈ হেলনীয়া কৰক।';

  @override
  String get angleMacro => 'মেক্ৰ\' ক্ল\'জ-আপ';

  @override
  String get angleMacroHint =>
      'বয়নে ফ্ৰেম ভৰোৱালৈকে ওচৰলৈ যাওক, তাৰ পিছত ফ\'কাছৰ বাবে টেপ কৰক।';

  @override
  String get lightingSoftWindow => 'কোমল খিৰিকীৰ পোহৰ';

  @override
  String get lightingSoftWindowHint =>
      'সামগ্ৰী খিৰিকীৰ কাষত ৰাখক, বাল্বৰ তলত নহয়।';

  @override
  String get lightingDiffused => 'বিস্তৃত দিনৰ পোহৰ';

  @override
  String get lightingDiffusedHint =>
      'বাহিৰৰ খোলা ছাঁত তোলক, পোহৰ এফালৰ পৰা আহক।';

  @override
  String get lightingAvoidMidday => 'দুপৰীয়াৰ তীব্ৰ ৰ\'দ এৰাই চলক';

  @override
  String get lightingAvoidMiddayHint =>
      'দুপৰীয়া ৩ বজাৰ পিছত তোলক — ওপৰৰ ৰ\'দে ৰং উৰাই দিয়ে।';

  @override
  String get lightingBacklight => 'পাতল কাপোৰৰ বাবে পিছফালৰ পোহৰ';

  @override
  String get lightingBacklightHint =>
      'পোহৰ কাপোৰৰ পিছফালে ৰাখক যাতে স্বচ্ছতা দেখা যায়।';

  @override
  String get compositionRuleOfThirds => 'তৃতীয়াংশৰ নিয়ম';

  @override
  String get compositionRuleOfThirdsHint =>
      'বৰ্ডাৰ গ্ৰিডৰ ওপৰৰ তৃতীয়াংশৰ সৈতে মিলাওক।';

  @override
  String get compositionCentered => 'কেন্দ্ৰত সামগ্ৰী';

  @override
  String get compositionCenteredHint => 'সামগ্ৰী গ্ৰিডৰ মাজৰ বাকচত ৰাখক।';

  @override
  String get compositionNegativeSpace => 'ভাঁজৰ চাৰিওফালে খালী ঠাই';

  @override
  String get compositionNegativeSpaceHint =>
      'ভাঁজবোৰ স্পষ্টকৈ দেখাবলৈ চাৰিওফালে খালী ঠাই এৰক।';

  @override
  String get compositionLeadingLines => 'কাপোৰৰ তিৰ্যক ৰেখা';

  @override
  String get compositionLeadingLinesHint =>
      'ভাঁজবোৰ তিৰ্যক গাইডৰ সৈতে মেলি ৰাখক।';

  @override
  String get compositionCentreFocus => 'কেন্দ্ৰ ফ\'কাছ';

  @override
  String get compositionCentreFocusHint => 'গঠনটো ফ্ৰেমৰ কেন্দ্ৰত ৰাখক।';

  @override
  String get compositionDetailFrame => 'বিৱৰণ ফ্ৰেম';

  @override
  String get compositionDetailFrameHint =>
      'এমব্ৰয়ডাৰী হাইলাইট কৰা ফ্ৰেমৰ ভিতৰত ৰাখক।';

  @override
  String get accountBackup => 'একাউণ্ট আৰু বেকআপ';

  @override
  String get accountBackupSubtitle =>
      'অগ্ৰগতি অনলাইন সংৰক্ষণ কৰিবলৈ ব্যৱহাৰকাৰী নাম আৰু পাছৱৰ্ড সৃষ্টি কৰক।';

  @override
  String get cloudBackupNotConfigured => 'ক্লাউড বেকআপ সাজু নহয়';

  @override
  String get cloudBackupNotConfiguredBody =>
      'এই বিল্ডত ক্লাউড সংযোগ নাই। অগ্ৰগতি কেৱল এই ফোনতে থাকিব।';

  @override
  String get signedInAs => 'ছাইন ইন আছে';

  @override
  String get artisanFallback => 'কাৰিকৰ';

  @override
  String get syncNow => 'এতিয়া ছিংক কৰক';

  @override
  String get signOut => 'ছাইন আউট';

  @override
  String get createAccountPrompt =>
      'আপোনাৰ কাম অনলাইন সংৰক্ষণ কৰিবলৈ একাউণ্ট সৃষ্টি কৰক।';

  @override
  String get signInPrompt => 'সংৰক্ষিত সামগ্ৰী আৰু ফটো লোড কৰিবলৈ ছাইন ইন কৰক।';

  @override
  String get username => 'ব্যৱহাৰকাৰী নাম';

  @override
  String get usernameHint => 'যেনে priya_weaver';

  @override
  String get password => 'পাছৱৰ্ড';

  @override
  String get createAccount => 'একাউণ্ট সৃষ্টি কৰক';

  @override
  String get signIn => 'ছাইন ইন';

  @override
  String get alreadyHaveAccount => 'ইতিমধ্যে একাউণ্ট আছে? ছাইন ইন কৰক';

  @override
  String get needAccount => 'একাউণ্ট লাগে? এটা সৃষ্টি কৰক';

  @override
  String get accountCreated =>
      'একাউণ্ট সৃষ্টি হ’ল। আপোনাৰ অগ্ৰগতি অনলাইন ছিংক হ’ব।';

  @override
  String get signedInSuccess => 'ছাইন ইন হ’ল। আপোনাৰ সংৰক্ষিত কাম এই ফোনত আছে।';

  @override
  String get signedOutSuccess => 'ছাইন আউট হ’ল। স্থানীয় ফটো এই ফোনতে থাকিব।';

  @override
  String get syncOffline => 'ইণ্টাৰনেট নাই — অনলাইন হ’লে ছিংক কৰক।';

  @override
  String syncDone(int sets, int shots) {
    return 'ছিংক হ’ল: $sets সামগ্ৰী আপলোড, $shots ফটো আপলোড।';
  }

  @override
  String get syncUpToDate => 'সকলো ইতিমধ্যে আপডেট আছে।';

  @override
  String syncFailed(String error) {
    return 'ছিংক ব্যৰ্থ: $error';
  }

  @override
  String get yourProgress => 'আপোনাৰ অগ্ৰগতি';

  @override
  String get productsStarted => 'আৰম্ভ কৰা সামগ্ৰী';

  @override
  String get finishedSets => 'সম্পূৰ্ণ ছেট';

  @override
  String get inProgressSets => 'চলি আছে';

  @override
  String get photosCaptured => 'তোলা ফটো';

  @override
  String get usernameTooShort =>
      'ব্যৱহাৰকাৰী নাম কমেও ৩টা আখৰ বা সংখ্যা হ’ব লাগিব।';

  @override
  String get usernameTooLong => 'ব্যৱহাৰকাৰী নাম ৩২ আখৰতকৈ বেছি হ’ব নোৱাৰে।';

  @override
  String get passwordTooShort => 'পাছৱৰ্ড কমেও ৬টা আখৰ হ’ব লাগিব।';

  @override
  String get fullScreen => 'সম্পূৰ্ণ স্ক্ৰীন';

  @override
  String get tapToSkip => 'এৰিবলৈ টেপ কৰক';

  @override
  String get cameraPermissionNeeded =>
      'ফটো তুলিবলৈ কেমেৰাৰ অনুমতি লাগে।\nঅনুগ্ৰহ কৰি ছেটিংছত কেমেৰা এক্সেছ দিয়ক।';

  @override
  String get cameraUnavailable => 'কেমেৰা উপলব্ধ নহয়।';

  @override
  String get noCameraFound => 'এই ডিভাইচত কোনো কেমেৰা পোৱা নগ’ল।';

  @override
  String get accountCreateFailed =>
      'একাউণ্ট সৃষ্টি কৰিব পৰা নগ’ল। পুনৰ চেষ্টা কৰক।';

  @override
  String get enterValidUsername => 'সঠিক ব্যৱহাৰকাৰী নাম দিয়ক।';

  @override
  String get monthJan => 'জানু';

  @override
  String get monthFeb => 'ফেব্ৰু';

  @override
  String get monthMar => 'মাৰ্চ';

  @override
  String get monthApr => 'এপ্ৰিল';

  @override
  String get monthMay => 'মে’';

  @override
  String get monthJun => 'জুন';

  @override
  String get monthJul => 'জুলাই';

  @override
  String get monthAug => 'আগ';

  @override
  String get monthSep => 'চেপ্টে';

  @override
  String get monthOct => 'অক্টো';

  @override
  String get monthNov => 'নৱে';

  @override
  String get monthDec => 'ডিচে';

  @override
  String get presetCushionFlatLayNeeds => 'সৰল, পৰিষ্কাৰ পৃষ্ঠ';

  @override
  String get presetCushionStackedPairNeeds => 'দুটা কভাৰ; কাষৰ পোহৰ';

  @override
  String get presetCushionProppedNeeds => 'চকী, ছোফা বা বিচনা';

  @override
  String get presetCushionCornerTuckNeeds => 'ক্ল’জ-আপ পোহৰ';

  @override
  String get presetShawlDrapedShoulderNeeds => 'শাল পিন্ধোৱা কোনো ব্যক্তি';

  @override
  String get presetShawlFoldedStackNeeds => 'কাষৰ পোহৰ';

  @override
  String get presetShawlHungFlatNeeds => 'ৰছী, বাঁহ বা দেৱাল য’ত পিন কৰিব';

  @override
  String get presetShawlCornerTuckNeeds => 'ক্ল’জ-আপ পোহৰ';

  @override
  String get presetStoleNeckWrapNeeds => 'ষ্টোল পিন্ধোৱা কোনো ব্যক্তি';

  @override
  String get presetStoleFlatSpreadNeeds => 'সৰল পৃষ্ঠ; ওপৰৰ পৰা দৃশ্য';

  @override
  String get presetStoleLooseKnotNeeds => 'কোমল কাষৰ পোহৰ';

  @override
  String get presetStoleRolledCoilNeeds => 'কোমল কাষৰ পোহৰ';

  @override
  String get placementSareePalluDrape =>
      'শাড়ী হেংগাৰ, বাঁহ বা মেনেকিনত ওলোৱাওক যাতে পল্লু মুক্তকৈ ওলমে।';

  @override
  String get placementSareeBoxFold =>
      'শাড়ী সমান স্তৰত ভাঁজ কৰি দ’ম কৰক যাতে কাষ দেখা যায়।';

  @override
  String get placementSareeWornDrape =>
      'ব্যক্তিত শাড়ী এনেদৰে মেৰাই দিয়ক যাতে ৰং, আৰ্হি আৰু বৰ্ডাৰ স্পষ্ট দেখা যায়।';

  @override
  String get placementSareeRollDisplay =>
      'শাড়ী এনেদৰে ৰোল কৰক যাতে পল্লু আৰু বৰ্ডাৰ কেমেৰাৰ ফালে থাকে।';

  @override
  String get placementCushionFlatLay =>
      'কভাৰ সৰল, পৰিষ্কাৰ পৃষ্ঠত সমতলকৈ ৰাখক।';

  @override
  String get placementCushionStackedPair =>
      'এটা কভাৰ আনটোৰ ওপৰত পৰিষ্কাৰকৈ ৰাখক।';

  @override
  String get placementCushionPropped =>
      'কুশ্বন চকী বা ছোফাত আগফালে থিয় কৰাই ৰাখক।';

  @override
  String get placementCushionCornerTuck =>
      'কভাৰ ঘূৰাওক যাতে চিলাই কৰা এটা কোণ আপোনাৰ সন্মুখত থাকে।';

  @override
  String get placementShawlDrapedShoulder =>
      'শাল এখন কান্ধত ৰাখি ওলোমাই দিয়ক।';

  @override
  String get placementShawlFoldedStack =>
      'শাল সমান স্তৰত ভাঁজ কৰি পৰিষ্কাৰকৈ দ’ম কৰক।';

  @override
  String get placementShawlHungFlat =>
      'দুয়োটা ওপৰৰ কোণ পিন কৰক যাতে শাল মাজত নামি নাযায়।';

  @override
  String get placementShawlCornerTuck =>
      'এটা কোণ পাছলৈ ভাঁজ কৰক যাতে বয়নৰ দুয়োফাল দেখা যায়।';

  @override
  String get placementStoleNeckWrap =>
      'ডিঙিত এবাৰ মেৰাই দুয়োটা মূৰ ওলোমাই দিয়ক।';

  @override
  String get placementStoleFlatSpread =>
      'ষ্টোল সমতলকৈ মেলি দিয়ক যাতে সম্পূৰ্ণ দৈৰ্ঘ্য দেখা যায়।';

  @override
  String get placementStoleLooseKnot =>
      'মাজত এটা ঢিলা গাঁঠি বান্ধক — টানি টান নকৰিব।';

  @override
  String get placementStoleRolledCoil => 'ষ্টোল ঢিলাকৈ সমতল কুণ্ডলীত ৰোল কৰক।';

  @override
  String get transcriptSareePalluDrape1 =>
      'শাড়ী এনেদৰে ওলোৱাওক যাতে ইয়াৰ পতন স্পষ্ট দেখা যায়।';

  @override
  String get transcriptSareePalluDrape2 =>
      'কান্ধৰ উচ্চতাত হেংগাৰ, বাঁহ বা মেনেকিন ব্যৱহাৰ কৰক।';

  @override
  String get transcriptSareePalluDrape3 =>
      'পল্লু মুক্তকৈ ওলোমাই দিয়ক — পোনকৈ টানি নধৰিব।';

  @override
  String get transcriptSareePalluDrape4 =>
      'ভাঁজবোৰে স্ক্ৰীনৰ তিৰ্যক ৰেখা অনুসৰণ কৰক।';

  @override
  String get transcriptSareePalluDrape5 =>
      'চিকমিকনি দেখুৱাবলৈ এটা পোহৰ কাষত ৰাখক।';

  @override
  String get transcriptSareeBoxFold1 =>
      'শাড়ী পৰিষ্কাৰ দ’মত ভাঁজ কৰক যাতে স্তৰবোৰ দেখা যায়।';

  @override
  String get transcriptSareeBoxFold2 =>
      'ভাঁজ কৰা কাষ কেমেৰাৰ ফালে ৰাখক — সেই কাষে ডাঠতা দেখুৱায়।';

  @override
  String get transcriptSareeBoxFold3 => 'ভাঁজবোৰ আনুভূমিক গাইডৰ সৈতে মিলাওক।';

  @override
  String get transcriptSareeBoxFold4 =>
      'প্ৰতিটো স্তৰত গভীৰতাৰ বাবে কাষৰ পৰা পোহৰ লওক।';

  @override
  String get transcriptSareeWornDrape1 =>
      'পৰিধান কৰা ফটোৱে সম্পূৰ্ণ শাড়ী দেখুৱায় — ৰং, আৰ্হি আৰু সামগ্ৰী।';

  @override
  String get transcriptSareeWornDrape2 => 'ৰং সঠিক থাকিবলৈ খোলা ছাঁত থিয় হওক।';

  @override
  String get transcriptSareeWornDrape3 => 'শাড়ীয়ে ফ্ৰেমৰ বেছিভাগ ঢাকক।';

  @override
  String get transcriptSareeWornDrape4 =>
      'ওপৰৰ বৰ্ডাৰ গ্ৰিডৰ ওপৰৰ তৃতীয়াংশৰ সৈতে মিলাওক।';

  @override
  String get transcriptSareeWornDrape5 =>
      'প্লিট থাকিলে উলম্ব গ্ৰিড ৰেখা অনুসৰণ কৰক।';

  @override
  String get transcriptSareeRollDisplay1 =>
      'শাড়ী এনেদৰে ৰোল কৰক যাতে পল্লু আৰু বৰ্ডাৰ কেমেৰাৰ ফালে থাকে।';

  @override
  String get transcriptSareeRollDisplay2 => 'ৰোলে ফ্ৰেমৰ বেছিভাগ ঢাকক।';

  @override
  String get transcriptSareeRollDisplay3 =>
      'ওপৰৰ বৰ্ডাৰ গ্ৰিডৰ ওপৰৰ তৃতীয়াংশৰ সৈতে মিলাওক।';

  @override
  String get transcriptSareeRollDisplay4 =>
      'ৰং সঠিক থাকিবলৈ কোমল দিনৰ পোহৰ লওক।';

  @override
  String get transcriptCushionFlatLay1 => 'কুশ্বন কভাৰ সৰল পৃষ্ঠত সমতলকৈ ৰাখক।';

  @override
  String get transcriptCushionFlatLay2 =>
      'সমতল কৰক কিন্তু প্ৰাকৃতিক গঠন থাকিব দিয়ক।';

  @override
  String get transcriptCushionFlatLay3 => 'ফোন পোনকৈ ওপৰত ৰাখক, কোণত নহয়।';

  @override
  String get transcriptCushionFlatLay4 => 'কাষবোৰ গ্ৰিডৰ সৈতে পোনকৈ ৰাখক।';

  @override
  String get transcriptCushionStackedPair1 =>
      'দুটা কভাৰ দ’ম কৰক যাতে ক্ৰেতাই ডাঠতা দেখিব পাৰে।';

  @override
  String get transcriptCushionStackedPair2 => 'দ’মৰ কাষ কেমেৰাৰ ফালে ৰাখক।';

  @override
  String get transcriptCushionStackedPair3 =>
      'প্ৰতিটো স্তৰৰ ছাঁৰ বাবে কাষৰ পোহৰ লওক।';

  @override
  String get transcriptCushionPropped1 =>
      'চকীত কুশ্বন ৰাখিলে ইয়াৰ প্ৰকৃত আকাৰ দেখা যায়।';

  @override
  String get transcriptCushionPropped2 =>
      'আৰ্হিৰ সৈতে প্ৰতিযোগিতা নকৰা আসন বাছক।';

  @override
  String get transcriptCushionPropped3 =>
      'চকুৰ উচ্চতাৰ পৰা তোলক, ওপৰৰ পৰা নহয়।';

  @override
  String get transcriptCushionCornerTuck1 =>
      'কোণে আপোনাৰ চিলাই সৰ্বাধিক স্পষ্টকৈ দেখুৱায়।';

  @override
  String get transcriptCushionCornerTuck2 =>
      'কোণে সৰু ফ্ৰেম ভৰোৱালৈকে ওচৰলৈ যাওক।';

  @override
  String get transcriptCushionCornerTuck3 =>
      'ফ’কাছৰ বাবে চিলাইত স্ক্ৰীন টেপ কৰক।';

  @override
  String get transcriptShawlDrapedShoulder1 =>
      'কান্ধত শাল ওলোৱাই ইয়াৰ ওজন দেখুৱায়।';

  @override
  String get transcriptShawlDrapedShoulder2 =>
      'এটা মূৰ আনটোতকৈ তললৈ ওলোমাই দিয়ক।';

  @override
  String get transcriptShawlDrapedShoulder3 =>
      'পিন নকৰিব — কাপোৰ নিজেই পৰিব দিয়ক।';

  @override
  String get transcriptShawlFoldedStack1 =>
      'ভাঁজ দেখা যোৱাকৈ শাল পৰিষ্কাৰকৈ দ’ম কৰক।';

  @override
  String get transcriptShawlFoldedStack2 =>
      'ভাঁজবোৰ আনুভূমিক ৰেখাৰ সমান্তৰাল ৰাখক।';

  @override
  String get transcriptShawlFoldedStack3 => 'ডাঠতাৰ বাবে শালৰ কাষ দেখা যাওক।';

  @override
  String get transcriptShawlFoldedStack4 =>
      'প্ৰতিটো ভাঁজত গভীৰতাৰ বাবে কাষৰ পোহৰ লওক।';

  @override
  String get transcriptShawlHungFlat1 =>
      'সমতলকৈ ওলোৱাই সম্পূৰ্ণ ডিজাইন একেলগে দেখুৱায়।';

  @override
  String get transcriptShawlHungFlat2 =>
      'দুয়োটা ওপৰৰ কোণ পিন কৰক যাতে মাজত নামি নাযায়।';

  @override
  String get transcriptShawlHungFlat3 => 'পোনকৈ সন্মুখত থিয় হওক, এফালে নহয়।';

  @override
  String get transcriptShawlCornerTuck1 =>
      'কোণৰ ক্ল’জ-আপে বয়ন আৰু বৰ্ডাৰ একেলগে দেখুৱায়।';

  @override
  String get transcriptShawlCornerTuck2 =>
      'এটা কোণ পাছলৈ ভাঁজ কৰক যাতে দুয়োফাল দেখা যায়।';

  @override
  String get transcriptShawlCornerTuck3 => 'বয়নে ফ্ৰেম ভৰোৱালৈকে ওচৰলৈ যাওক।';

  @override
  String get transcriptStoleNeckWrap1 =>
      'পৰিধান কৰা ফটোৱে সাধাৰণ প্ৰশ্নৰ উত্তৰ দিয়ে — কিমান ডাঙৰ?';

  @override
  String get transcriptStoleNeckWrap2 =>
      'ডিঙিত এবাৰ মেৰাই দুয়োটা মূৰ ওলোমাই দিয়ক।';

  @override
  String get transcriptStoleNeckWrap3 =>
      'বুকুৰ পৰা ওপৰলৈ তোলক যাতে মূৰবোৰ ফ্ৰেমত থাকে।';

  @override
  String get transcriptStoleFlatSpread1 =>
      'ষ্টোল মেলি দিয়ক যাতে সম্পূৰ্ণ দৈৰ্ঘ্য দেখা যায়।';

  @override
  String get transcriptStoleFlatSpread2 =>
      'প্ৰাকৃতিক ভাঁজ থাকিব দিয়ক — সেইবোৰে কাপোৰৰ স্বভাৱ দেখুৱায়।';

  @override
  String get transcriptStoleFlatSpread3 => 'ফোন পোনকৈ মাজৰ ওপৰত ৰাখক।';

  @override
  String get transcriptStoleLooseKnot1 =>
      'ঢিলা গাঁঠিয়ে ষ্টোল কিমান কোমল আৰু পাতল দেখুৱায়।';

  @override
  String get transcriptStoleLooseKnot2 =>
      'ঢিলাকৈ বান্ধক — কেতিয়াও টানি টান নকৰিব।';

  @override
  String get transcriptStoleLooseKnot3 => 'গাঁঠি ফ্ৰেমৰ কেন্দ্ৰত ৰাখক।';

  @override
  String get transcriptStoleRolledCoil1 =>
      'কুণ্ডলীত ৰোল কৰিলে কাষ আৰু ডাঠতা দেখা যায়।';

  @override
  String get transcriptStoleRolledCoil2 =>
      'ঢিলাকৈ ৰোল কৰক যাতে স্তৰবোৰ পৃথক থাকে।';

  @override
  String get transcriptStoleRolledCoil3 => 'কুণ্ডলীৰ ওপৰত পোনকৈ তললৈ তোলক।';

  @override
  String get guideSareeFullDisplay1 => 'শাড়ীয়ে ফ্ৰেমৰ বেছিভাগ অংশ ঢাকে।';

  @override
  String get guideSareeFullDisplay2 =>
      'ওপৰৰ বৰ্ডাৰ গ্ৰিডৰ ওপৰৰ তৃতীয়াংশৰ সৈতে মিলে।';

  @override
  String get guideSareeFullDisplay3 =>
      'ড্ৰেপত প্লীটবোৰ উলম্ব গ্ৰিডৰ সৈতে মিলে।';

  @override
  String get guideSareeTextureWeave1 => 'শাড়ীয়ে গোটেই ফ্ৰেম ভৰায়।';

  @override
  String get guideSareeTextureWeave2 => 'বয়ন মাজত থাকে।';

  @override
  String get guideSareeTextureWeave3 => 'কোমল পোহৰ ব্যৱহাৰ কৰক।';

  @override
  String get guideSareeTextureWeave4 => 'কঠোৰ প্ৰতিফলন এৰাই চলক।';

  @override
  String get guideSareeEmbroideryBorder1 => 'এমব্ৰয়ডাৰী ফ্ৰেমৰ ভিতৰত থাকে।';

  @override
  String get guideSareeEmbroideryBorder2 => 'কাষৰ পৰা পোহৰ লওক।';

  @override
  String get guideSareeEmbroideryBorder3 =>
      'বিৱৰণ তীক্ষ্ণ আৰু ভালকৈ পোহৰত ৰাখক।';

  @override
  String get guideCushionTextureWeave1 => 'বয়নে ফ্ৰেম ভৰায়।';

  @override
  String get guideCushionTextureWeave2 => 'বয়ন মাজত থাকে।';

  @override
  String get guideShawlFullDesign1 =>
      'শাল সমতলকৈ ওলোমাই গোটেই ডিজাইন একেলগে দেখা যায়।';

  @override
  String get guideShawlFullDesign2 =>
      'দুয়োটা ওপৰৰ কোণ পিন কৰক যাতে মাজত নামি নাযায়।';

  @override
  String get guideShawlTextureWeave1 => 'বয়নে ফ্ৰেম ভৰায়।';

  @override
  String get guideShawlTextureWeave2 => 'বয়ন মাজত থাকে।';

  @override
  String get guideStoleFullLength1 =>
      'ষ্টোল মেলি দিয়ক যাতে সম্পূৰ্ণ দৈৰ্ঘ্য দেখা যায়।';

  @override
  String get guideStoleFullLength2 =>
      'স্বাভাৱিক ভাঁজ থাকিবলৈ দিয়ক — সেইবোৰে কাপোৰৰ স্বভাৱ দেখুৱায়।';

  @override
  String get guideStoleTextureWeave1 => 'বয়নে ফ্ৰেম ভৰায়।';

  @override
  String get guideStoleTextureWeave2 => 'বয়ন মাজত থাকে।';

  @override
  String get authInvalidCredentials => 'ভুল ব্যৱহাৰকাৰী নাম বা পাছৱৰ্ড।';

  @override
  String get authUserAlreadyRegistered =>
      'এই ব্যৱহাৰকাৰী নাম ইতিমধ্যে লোৱা হৈছে।';

  @override
  String get authEmailNotConfirmed => 'ইমেইল নিশ্চিত কৰক, তাৰ পিছত চেষ্টা কৰক।';

  @override
  String get authGeneric => 'ছাইন ইন কৰিব পৰা নগ’ল। পুনৰ চেষ্টা কৰক।';

  @override
  String get languageAssamese => 'অসমীয়া';

  @override
  String get languageHindi => 'হিন্দী';

  @override
  String get languageEnglish => 'ইংৰাজী';

  @override
  String get guideSareeDrapedLook1 => 'কাপোৰ স্বাভাৱিকভাৱে পৰিবলৈ দিয়ক।';

  @override
  String get guideSareeDrapedLook2 => 'ভাঁজবোৰ তিৰ্যক ৰেখাৰে যায়।';

  @override
  String get guideSareeDrapedLook3 => 'কাষৰ পৰা পোহৰ লওক।';

  @override
  String get guideSareeEmbroideryBorder4 =>
      'কনট্ৰাষ্ট বেকগ্ৰাউণ্ড ব্যৱহাৰ কৰক।';

  @override
  String get guideSareeFoldedStack1 => 'ভাঁজবোৰ আনুভূমিক ৰেখাৰ সমান্তৰাল থাকে।';

  @override
  String get guideSareeFoldedStack2 => 'কাষৰ পৰা পোহৰ লওক।';

  @override
  String get guideSareeFoldedStack3 => 'কাষ দেখা যায়।';

  @override
  String get guideCushionFullCover1 =>
      'কভাৰ সমতলকৈ ৰাখক যাতে সম্পূৰ্ণ নক্সা দেখা যায়।';

  @override
  String get guideCushionFullCover2 =>
      'ফোন পোনপটীয়াকৈ ওপৰৰ পৰা ধৰক, কোণত নহয়।';

  @override
  String get guideCushionFullCover3 => 'কাষবোৰ গ্ৰিডৰ সৈতে পোনকৈ ৰাখক।';

  @override
  String get guideCushionTextureWeave3 => 'কোমল পোহৰ ব্যৱহাৰ কৰক।';

  @override
  String get guideCushionTextureWeave4 => 'কঠোৰ প্ৰতিফলন এৰাই চলক।';

  @override
  String get guideCushionStackedThickness1 =>
      'দুটা কভাৰ এনেকৈ ৰাখক যাতে ডাঠতা দেখা যায়।';

  @override
  String get guideCushionStackedThickness2 => 'স্তূপৰ কাষ কেমেৰাৰ ফালে ৰাখক।';

  @override
  String get guideCushionStackedThickness3 =>
      'কাষৰ পোহৰে প্ৰতিটো স্তৰৰ কোমল ছাঁ পেলায়।';

  @override
  String get guideCushionCornerStitching1 => 'কোণত চিলাই স্পষ্টকৈ দেখা যায়।';

  @override
  String get guideCushionCornerStitching2 =>
      'কাষ চাপি যাওক যেতিয়ালৈকে কোণে সৰু ফ্ৰেম ভৰায়।';

  @override
  String get guideCushionCornerStitching3 =>
      'চিলাই তীক্ষ্ণ আৰু ভালকৈ পোহৰত ৰাখক।';

  @override
  String get guideCushionInUse1 => 'চেয়াৰত ৰাখিলে প্ৰকৃত আকাৰ দেখা যায়।';

  @override
  String get guideCushionInUse2 =>
      'এনে আসন বাছি লওক যি নক্সাৰ সৈতে প্ৰতিযোগিতা নকৰে।';

  @override
  String get guideCushionInUse3 => 'চকুৰ স্তৰত তোলক, ওপৰৰ পৰা নহয়।';

  @override
  String get guideShawlFullDesign3 =>
      'পোনপটীয়াকৈ সন্মুখত থিয় হওক, এফালে নহয়।';

  @override
  String get guideShawlTextureWeave3 => 'কোমল পোহৰ ব্যৱহাৰ কৰক।';

  @override
  String get guideShawlTextureWeave4 => 'কঠোৰ প্ৰতিফলন এৰাই চলক।';

  @override
  String get guideShawlDrapedLook1 =>
      'কান্ধত শাল ড্ৰেপ কৰিলে ই কিমান গধুৰ তাক দেখুৱায়।';

  @override
  String get guideShawlDrapedLook2 => 'এটা মূৰ আনটোতকৈ তললৈ ওলমিবলৈ দিয়ক।';

  @override
  String get guideShawlDrapedLook3 => 'পিন নকৰিব — কাপোৰ নিজে পৰিবলৈ দিয়ক।';

  @override
  String get guideShawlBorderCorner1 =>
      'কোণৰ ক্ল\'জ-আপে বয়ন আৰু বৰ্ডাৰ একেলগে দেখুৱায়।';

  @override
  String get guideShawlBorderCorner2 =>
      'এটা কোণ পাছলৈ ভাঁজ কৰক যাতে দুয়োফাল দেখা যায়।';

  @override
  String get guideShawlBorderCorner3 =>
      'কাষ চাপি যাওক যেতিয়ালৈকে বয়নে ফ্ৰেম ভৰায়।';

  @override
  String get guideShawlStackDisplay1 =>
      'শাল পৰিষ্কাৰকৈ স্তূপ কৰক, ভাঁজ দেখা যায়।';

  @override
  String get guideShawlStackDisplay2 => 'ভাঁজ আনুভূমিক ৰেখাৰ সমান্তৰাল ৰাখক।';

  @override
  String get guideShawlStackDisplay3 => 'কাষৰ পোহৰে প্ৰতিটো ভাঁজত গভীৰতা আনে।';

  @override
  String get guideStoleFullLength3 => 'ফোন পোনপটীয়াকৈ মাজৰ ওপৰত ধৰক।';

  @override
  String get guideStoleTextureWeave3 => 'কোমল পোহৰ ব্যৱহাৰ কৰক।';

  @override
  String get guideStoleTextureWeave4 => 'কঠোৰ প্ৰতিফলন এৰাই চলক।';

  @override
  String get guideStoleWornNeckWrap1 =>
      'পৰিধান কৰা শটে ষ্টোল কিমান ডাঙৰ তাক উত্তৰ দিয়ে।';

  @override
  String get guideStoleWornNeckWrap2 =>
      'ডিঙিত এবাৰ মেৰিয়াই দুয়োটা মূৰ ওলমিবলৈ দিয়ক।';

  @override
  String get guideStoleWornNeckWrap3 =>
      'বুকৰ পৰা ওপৰলৈ তোলক যাতে মূৰবোৰ ফ্ৰেমত থাকে।';

  @override
  String get guideStoleSoftnessKnot1 =>
      'ঢিলা গাঁঠিয়ে ষ্টোল কিমান কোমল আৰু পাতল তাক দেখুৱায়।';

  @override
  String get guideStoleSoftnessKnot2 => 'ঢিলাকৈ বান্ধক — কেতিয়াও টান নকৰিব।';

  @override
  String get guideStoleSoftnessKnot3 => 'গাঁঠি ফ্ৰেমৰ মাজত ৰাখক।';

  @override
  String get guideStoleEdgeThickness1 =>
      'ষ্টোল কুণ্ডলিত কৰিলে কাষ আৰু ডাঠতা দেখা যায়।';

  @override
  String get guideStoleEdgeThickness2 =>
      'ঢিলাকৈ মেৰিয়াওক যাতে স্তৰবোৰ পৃথক থাকে।';

  @override
  String get guideStoleEdgeThickness3 => 'কুণ্ডলীৰ ওপৰৰ পৰা পোনকৈ তোলক।';
}
