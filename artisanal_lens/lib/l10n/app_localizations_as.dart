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
}
