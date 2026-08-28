import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_as.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('as'),
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'The Artisanal Lens'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get navGallery;

  /// No description provided for @navNewProduct.
  ///
  /// In en, this message translates to:
  /// **'New Product'**
  String get navNewProduct;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @openCamera.
  ///
  /// In en, this message translates to:
  /// **'Open Camera'**
  String get openCamera;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @photographyGuide.
  ///
  /// In en, this message translates to:
  /// **'Photography guide'**
  String get photographyGuide;

  /// No description provided for @photographyGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The rules behind every prompt this app gives you.'**
  String get photographyGuideSubtitle;

  /// No description provided for @whatPhotographing.
  ///
  /// In en, this message translates to:
  /// **'What are you\nphotographing today?'**
  String get whatPhotographing;

  /// No description provided for @continuePhotography.
  ///
  /// In en, this message translates to:
  /// **'Continue photography'**
  String get continuePhotography;

  /// No description provided for @previousSets.
  ///
  /// In en, this message translates to:
  /// **'Previous sets.'**
  String get previousSets;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get filterFinished;

  /// No description provided for @filterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get filterPending;

  /// No description provided for @photosCompleted.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} photos completed'**
  String photosCompleted(int done, int total);

  /// No description provided for @emptyAll.
  ///
  /// In en, this message translates to:
  /// **'No previous sets yet.'**
  String get emptyAll;

  /// No description provided for @emptyFinished.
  ///
  /// In en, this message translates to:
  /// **'No finished sets yet.'**
  String get emptyFinished;

  /// No description provided for @emptyPending.
  ///
  /// In en, this message translates to:
  /// **'No pending sets.'**
  String get emptyPending;

  /// No description provided for @newProduct.
  ///
  /// In en, this message translates to:
  /// **'New Product'**
  String get newProduct;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @setup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup;

  /// No description provided for @tutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorial;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @materialHeadline.
  ///
  /// In en, this message translates to:
  /// **'What material are\nyou working with?'**
  String get materialHeadline;

  /// No description provided for @materialTypeHeadline.
  ///
  /// In en, this message translates to:
  /// **'What type of {material}\nare you using?'**
  String materialTypeHeadline(String material);

  /// No description provided for @giveProductName.
  ///
  /// In en, this message translates to:
  /// **'Give your product a name'**
  String get giveProductName;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Blue Silk {category}'**
  String nameHint(String category);

  /// No description provided for @photosToCapture.
  ///
  /// In en, this message translates to:
  /// **'Photos to capture'**
  String get photosToCapture;

  /// No description provided for @photosToCaptureBody.
  ///
  /// In en, this message translates to:
  /// **'These are the photos you need to take.'**
  String get photosToCaptureBody;

  /// No description provided for @sareePhotographyTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saree photography templates'**
  String get sareePhotographyTemplatesTitle;

  /// No description provided for @sareePhotographyTemplatesBody.
  ///
  /// In en, this message translates to:
  /// **'These are the five photographs to take.'**
  String get sareePhotographyTemplatesBody;

  /// No description provided for @photographyTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Photography templates'**
  String get photographyTemplatesTitle;

  /// No description provided for @photographyTemplatesBody.
  ///
  /// In en, this message translates to:
  /// **'These are the five photographs to take.'**
  String get photographyTemplatesBody;

  /// No description provided for @viewCompletedSet.
  ///
  /// In en, this message translates to:
  /// **'View completed set'**
  String get viewCompletedSet;

  /// No description provided for @allPhotosCaptured.
  ///
  /// In en, this message translates to:
  /// **'All photos captured'**
  String get allPhotosCaptured;

  /// No description provided for @takeNext.
  ///
  /// In en, this message translates to:
  /// **'Take next — {label}'**
  String takeNext(String label);

  /// No description provided for @productUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This product is no longer available.'**
  String get productUnavailable;

  /// No description provided for @chooseAStyle.
  ///
  /// In en, this message translates to:
  /// **'Choose a style'**
  String get chooseAStyle;

  /// No description provided for @howShouldItLook.
  ///
  /// In en, this message translates to:
  /// **'How should it look?'**
  String get howShouldItLook;

  /// No description provided for @stylePickFirst.
  ///
  /// In en, this message translates to:
  /// **'Pick a photo from the list first.'**
  String get stylePickFirst;

  /// No description provided for @styleNoNeeded.
  ///
  /// In en, this message translates to:
  /// **'No style is needed for this photo.'**
  String get styleNoNeeded;

  /// No description provided for @styleSubtitleSaree.
  ///
  /// In en, this message translates to:
  /// **'Choose the arrangement for this {template} photo.'**
  String styleSubtitleSaree(String template);

  /// No description provided for @styleSubtitleShot.
  ///
  /// In en, this message translates to:
  /// **'Choose the arrangement for this {shot} photo.'**
  String styleSubtitleShot(String shot);

  /// No description provided for @styleSubtitleCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose the arrangement for this {category} {shot} photo.'**
  String styleSubtitleCategory(String category, String shot);

  /// No description provided for @labelContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get labelContent;

  /// No description provided for @labelNeeds.
  ///
  /// In en, this message translates to:
  /// **'Needs'**
  String get labelNeeds;

  /// No description provided for @labelPlacement.
  ///
  /// In en, this message translates to:
  /// **'Placement'**
  String get labelPlacement;

  /// No description provided for @labelLighting.
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get labelLighting;

  /// No description provided for @labelGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get labelGrid;

  /// No description provided for @contentPrefixed.
  ///
  /// In en, this message translates to:
  /// **'Content: {value}'**
  String contentPrefixed(String value);

  /// No description provided for @needsPrefixed.
  ///
  /// In en, this message translates to:
  /// **'Needs: {value}'**
  String needsPrefixed(String value);

  /// No description provided for @lightingAndSetup.
  ///
  /// In en, this message translates to:
  /// **'Lighting and setup'**
  String get lightingAndSetup;

  /// No description provided for @step1of2.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2'**
  String get step1of2;

  /// No description provided for @step2of2.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 2'**
  String get step2of2;

  /// No description provided for @beforeYouShoot.
  ///
  /// In en, this message translates to:
  /// **'Before you shoot'**
  String get beforeYouShoot;

  /// No description provided for @setupIllustrationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Setup illustration to be added'**
  String get setupIllustrationPlaceholder;

  /// No description provided for @placeTheProduct.
  ///
  /// In en, this message translates to:
  /// **'Place the product'**
  String get placeTheProduct;

  /// No description provided for @setupSection.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setupSection;

  /// No description provided for @watchHowToSetUp.
  ///
  /// In en, this message translates to:
  /// **'Watch how to set up'**
  String get watchHowToSetUp;

  /// No description provided for @tutorialSubtitlePreset.
  ///
  /// In en, this message translates to:
  /// **'Watch how to set up {name}.'**
  String tutorialSubtitlePreset(String name);

  /// No description provided for @tutorialSubtitleTemplate.
  ///
  /// In en, this message translates to:
  /// **'Watch how to set up {name}.'**
  String tutorialSubtitleTemplate(String name);

  /// No description provided for @tutorialSubtitleFallback.
  ///
  /// In en, this message translates to:
  /// **'A short video will show this setup when it is added.'**
  String get tutorialSubtitleFallback;

  /// No description provided for @transcript.
  ///
  /// In en, this message translates to:
  /// **'TRANSCRIPT'**
  String get transcript;

  /// No description provided for @transcriptPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The spoken transcript will appear here once the tutorial video is added.'**
  String get transcriptPlaceholder;

  /// No description provided for @tutorialVideoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tutorial video to be added'**
  String get tutorialVideoPlaceholder;

  /// No description provided for @referencePreset.
  ///
  /// In en, this message translates to:
  /// **'REFERENCE PRESET'**
  String get referencePreset;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @usePhoto.
  ///
  /// In en, this message translates to:
  /// **'Use Photo'**
  String get usePhoto;

  /// No description provided for @greatFraming.
  ///
  /// In en, this message translates to:
  /// **'Great framing'**
  String get greatFraming;

  /// No description provided for @checkFraming.
  ///
  /// In en, this message translates to:
  /// **'Check framing'**
  String get checkFraming;

  /// No description provided for @noPhotoToReview.
  ///
  /// In en, this message translates to:
  /// **'No photo to review.'**
  String get noPhotoToReview;

  /// No description provided for @photoSetComplete.
  ///
  /// In en, this message translates to:
  /// **'Your photo set is complete 🎉'**
  String get photoSetComplete;

  /// No description provided for @viewPhotoSet.
  ///
  /// In en, this message translates to:
  /// **'View Photo Set'**
  String get viewPhotoSet;

  /// No description provided for @startNewProduct.
  ///
  /// In en, this message translates to:
  /// **'Start New Product'**
  String get startNewProduct;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'Offline — photos will sync when connected'**
  String get offlineBanner;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found.'**
  String get productNotFound;

  /// No description provided for @exportPhotoSet.
  ///
  /// In en, this message translates to:
  /// **'Export Photo Set'**
  String get exportPhotoSet;

  /// No description provided for @continueCount.
  ///
  /// In en, this message translates to:
  /// **'Continue — {done}/{total}'**
  String continueCount(int done, int total);

  /// No description provided for @noPhotosToExport.
  ///
  /// In en, this message translates to:
  /// **'No photos to export yet.'**
  String get noPhotosToExport;

  /// No description provided for @couldNotExport.
  ///
  /// In en, this message translates to:
  /// **'Could not export: {error}'**
  String couldNotExport(String error);

  /// No description provided for @exportShareText.
  ///
  /// In en, this message translates to:
  /// **'{name} — {count} photos, shot with The Artisanal Lens'**
  String exportShareText(String name, int count);

  /// No description provided for @couldNotSavePhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not save the photo: {error}'**
  String couldNotSavePhoto(String error);

  /// No description provided for @galleryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No photo sets yet.\nStart a new product to begin.'**
  String get galleryEmpty;

  /// No description provided for @galleryEmptyFiltered.
  ///
  /// In en, this message translates to:
  /// **'Nothing in this category yet.'**
  String get galleryEmptyFiltered;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// No description provided for @nextPill.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get nextPill;

  /// No description provided for @templateOverline.
  ///
  /// In en, this message translates to:
  /// **'TEMPLATE'**
  String get templateOverline;

  /// No description provided for @proTipGoodLight.
  ///
  /// In en, this message translates to:
  /// **'Pro-tip: Natural light is best now for product shots.'**
  String get proTipGoodLight;

  /// No description provided for @chipLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get chipLight;

  /// No description provided for @chipDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get chipDistance;

  /// No description provided for @chipCentre.
  ///
  /// In en, this message translates to:
  /// **'Centre'**
  String get chipCentre;

  /// No description provided for @chipEmDash.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get chipEmDash;

  /// No description provided for @readingTheFrame.
  ///
  /// In en, this message translates to:
  /// **'Reading the frame…'**
  String get readingTheFrame;

  /// No description provided for @fillFrameWith.
  ///
  /// In en, this message translates to:
  /// **'Fill the frame with the {slot}'**
  String fillFrameWith(String slot);

  /// No description provided for @promptNoProduct.
  ///
  /// In en, this message translates to:
  /// **'Place the {product} in view'**
  String promptNoProduct(String product);

  /// No description provided for @promptMoveIntoFrame.
  ///
  /// In en, this message translates to:
  /// **'Move the {product} into the frame'**
  String promptMoveIntoFrame(String product);

  /// No description provided for @promptKeepInsideFrame.
  ///
  /// In en, this message translates to:
  /// **'Keep the {product} inside the frame'**
  String promptKeepInsideFrame(String product);

  /// No description provided for @promptAlignHorizontal.
  ///
  /// In en, this message translates to:
  /// **'Line the folds up with the horizontal guides'**
  String get promptAlignHorizontal;

  /// No description provided for @promptAlignDiagonal.
  ///
  /// In en, this message translates to:
  /// **'Let the fabric follow the diagonal guides'**
  String get promptAlignDiagonal;

  /// No description provided for @promptHoldSteady.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone steady'**
  String get promptHoldSteady;

  /// No description provided for @promptMoveCloser.
  ///
  /// In en, this message translates to:
  /// **'Move closer'**
  String get promptMoveCloser;

  /// No description provided for @promptMoveFurther.
  ///
  /// In en, this message translates to:
  /// **'Move further from subject'**
  String get promptMoveFurther;

  /// No description provided for @promptCenterSubject.
  ///
  /// In en, this message translates to:
  /// **'Center the {product}'**
  String promptCenterSubject(String product);

  /// No description provided for @promptKeepTextureCentre.
  ///
  /// In en, this message translates to:
  /// **'Keep the texture in the centre'**
  String get promptKeepTextureCentre;

  /// No description provided for @promptKeepBorderInside.
  ///
  /// In en, this message translates to:
  /// **'Keep the border inside the frame'**
  String get promptKeepBorderInside;

  /// No description provided for @promptKeepFoldsVisible.
  ///
  /// In en, this message translates to:
  /// **'Keep the folds visible'**
  String get promptKeepFoldsVisible;

  /// No description provided for @promptBacklight.
  ///
  /// In en, this message translates to:
  /// **'Backlight detected'**
  String get promptBacklight;

  /// No description provided for @promptTooDark.
  ///
  /// In en, this message translates to:
  /// **'Too dark — move near a window or outside'**
  String get promptTooDark;

  /// No description provided for @promptLowLight.
  ///
  /// In en, this message translates to:
  /// **'Light is low — move nearer a window'**
  String get promptLowLight;

  /// No description provided for @promptTooBright.
  ///
  /// In en, this message translates to:
  /// **'Too bright — move into open shade'**
  String get promptTooBright;

  /// No description provided for @promptTiltPhone.
  ///
  /// In en, this message translates to:
  /// **'Tilt the phone to match the angle guide'**
  String get promptTiltPhone;

  /// No description provided for @promptReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to capture'**
  String get promptReady;

  /// No description provided for @lightTooDark.
  ///
  /// In en, this message translates to:
  /// **'Too dark'**
  String get lightTooDark;

  /// No description provided for @lightLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get lightLow;

  /// No description provided for @lightOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get lightOk;

  /// No description provided for @lightBright.
  ///
  /// In en, this message translates to:
  /// **'Bright'**
  String get lightBright;

  /// No description provided for @distanceMoveCloser.
  ///
  /// In en, this message translates to:
  /// **'Move closer'**
  String get distanceMoveCloser;

  /// No description provided for @distanceOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get distanceOk;

  /// No description provided for @distanceMoveBack.
  ///
  /// In en, this message translates to:
  /// **'Move back'**
  String get distanceMoveBack;

  /// No description provided for @centreMoveIn.
  ///
  /// In en, this message translates to:
  /// **'Move in'**
  String get centreMoveIn;

  /// No description provided for @centreOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get centreOk;

  /// No description provided for @advisoryGoodHeadline.
  ///
  /// In en, this message translates to:
  /// **'Good light right now'**
  String get advisoryGoodHeadline;

  /// No description provided for @advisoryGoodDetail.
  ///
  /// In en, this message translates to:
  /// **'Natural light is soft enough for clear, true colours.'**
  String get advisoryGoodDetail;

  /// No description provided for @advisoryOverheadHeadline.
  ///
  /// In en, this message translates to:
  /// **'Overhead sun'**
  String get advisoryOverheadHeadline;

  /// No description provided for @advisoryOverheadDetail.
  ///
  /// In en, this message translates to:
  /// **'Try taking the photo later when the sunlight is softer. Right now, the overhead sun may cause harsh shadows on your setup.'**
  String get advisoryOverheadDetail;

  /// No description provided for @advisoryDarkHeadline.
  ///
  /// In en, this message translates to:
  /// **'Not enough daylight'**
  String get advisoryDarkHeadline;

  /// No description provided for @advisoryDarkDetail.
  ///
  /// In en, this message translates to:
  /// **'There is not enough natural light now. Morning light near a window gives the truest colours.'**
  String get advisoryDarkDetail;

  /// No description provided for @openingTagline.
  ///
  /// In en, this message translates to:
  /// **'Guided photography for handcrafted products'**
  String get openingTagline;

  /// No description provided for @openingChipLight.
  ///
  /// In en, this message translates to:
  /// **'Light: Good'**
  String get openingChipLight;

  /// No description provided for @openingChipAngle.
  ///
  /// In en, this message translates to:
  /// **'Angle: Good'**
  String get openingChipAngle;

  /// No description provided for @openingChipFrame.
  ///
  /// In en, this message translates to:
  /// **'Frame: Ready'**
  String get openingChipFrame;

  /// No description provided for @guidelineG1Title.
  ///
  /// In en, this message translates to:
  /// **'Use Close-Up Shots'**
  String get guidelineG1Title;

  /// No description provided for @guidelineG1Body.
  ///
  /// In en, this message translates to:
  /// **'Capture fine details, textures, and craftsmanship of the fabric.'**
  String get guidelineG1Body;

  /// No description provided for @guidelineG2Title.
  ///
  /// In en, this message translates to:
  /// **'Highlight Fabric Edges'**
  String get guidelineG2Title;

  /// No description provided for @guidelineG2Body.
  ///
  /// In en, this message translates to:
  /// **'Capture the edge of the fabric, covering 2/3 of the image with fabric.'**
  String get guidelineG2Body;

  /// No description provided for @guidelineG3Title.
  ///
  /// In en, this message translates to:
  /// **'Shoot from Various Angles'**
  String get guidelineG3Title;

  /// No description provided for @guidelineG3Body.
  ///
  /// In en, this message translates to:
  /// **'Showcase the product from multiple perspectives to highlight its design and structure.'**
  String get guidelineG3Body;

  /// No description provided for @guidelineG4Title.
  ///
  /// In en, this message translates to:
  /// **'Experiment with Diverse Lighting'**
  String get guidelineG4Title;

  /// No description provided for @guidelineG4Body.
  ///
  /// In en, this message translates to:
  /// **'Utilise natural and artificial lighting, indoor and outdoor lighting, front and side lighting, to bring out the true colours and depth of the fabric.'**
  String get guidelineG4Body;

  /// No description provided for @guidelineG5Title.
  ///
  /// In en, this message translates to:
  /// **'Choose Complementary Backgrounds'**
  String get guidelineG5Title;

  /// No description provided for @guidelineG5Body.
  ///
  /// In en, this message translates to:
  /// **'Use backgrounds that enhance the fabric\'s beauty without overpowering it.'**
  String get guidelineG5Body;

  /// No description provided for @guidelineG6Title.
  ///
  /// In en, this message translates to:
  /// **'Embrace Natural Creases'**
  String get guidelineG6Title;

  /// No description provided for @guidelineG6Body.
  ///
  /// In en, this message translates to:
  /// **'Photograph the fabric in its raw, unironed state to give a clear idea of material.'**
  String get guidelineG6Body;

  /// No description provided for @guidelineG7Title.
  ///
  /// In en, this message translates to:
  /// **'Represent Weight and Flow'**
  String get guidelineG7Title;

  /// No description provided for @guidelineG7Body.
  ///
  /// In en, this message translates to:
  /// **'Capture how the fabric drapes, folds, and flows to convey its weight and feel.'**
  String get guidelineG7Body;

  /// No description provided for @guidelineG8Title.
  ///
  /// In en, this message translates to:
  /// **'Tell a Story'**
  String get guidelineG8Title;

  /// No description provided for @guidelineG8Body.
  ///
  /// In en, this message translates to:
  /// **'Frame shots in a way that connects the fabric to its cultural heritage, artisans, and intended use.'**
  String get guidelineG8Body;

  /// No description provided for @categorySaree.
  ///
  /// In en, this message translates to:
  /// **'Saree'**
  String get categorySaree;

  /// No description provided for @categoryCushionCover.
  ///
  /// In en, this message translates to:
  /// **'Cushion Cover'**
  String get categoryCushionCover;

  /// No description provided for @categoryShawl.
  ///
  /// In en, this message translates to:
  /// **'Shawl'**
  String get categoryShawl;

  /// No description provided for @categoryStole.
  ///
  /// In en, this message translates to:
  /// **'Stole'**
  String get categoryStole;

  /// No description provided for @categorySarees.
  ///
  /// In en, this message translates to:
  /// **'Sarees'**
  String get categorySarees;

  /// No description provided for @categoryCushionCovers.
  ///
  /// In en, this message translates to:
  /// **'Cushion Covers'**
  String get categoryCushionCovers;

  /// No description provided for @categoryShawls.
  ///
  /// In en, this message translates to:
  /// **'Shawls'**
  String get categoryShawls;

  /// No description provided for @categoryStoles.
  ///
  /// In en, this message translates to:
  /// **'Stoles'**
  String get categoryStoles;

  /// No description provided for @nounSaree.
  ///
  /// In en, this message translates to:
  /// **'saree'**
  String get nounSaree;

  /// No description provided for @nounCushionCover.
  ///
  /// In en, this message translates to:
  /// **'cushion cover'**
  String get nounCushionCover;

  /// No description provided for @nounShawl.
  ///
  /// In en, this message translates to:
  /// **'shawl'**
  String get nounShawl;

  /// No description provided for @nounStole.
  ///
  /// In en, this message translates to:
  /// **'stole'**
  String get nounStole;

  /// No description provided for @nounProduct.
  ///
  /// In en, this message translates to:
  /// **'product'**
  String get nounProduct;

  /// No description provided for @materialSilk.
  ///
  /// In en, this message translates to:
  /// **'Silk'**
  String get materialSilk;

  /// No description provided for @materialCotton.
  ///
  /// In en, this message translates to:
  /// **'Cotton'**
  String get materialCotton;

  /// No description provided for @materialWool.
  ///
  /// In en, this message translates to:
  /// **'Wool'**
  String get materialWool;

  /// No description provided for @materialJute.
  ///
  /// In en, this message translates to:
  /// **'Jute'**
  String get materialJute;

  /// No description provided for @materialSilkLower.
  ///
  /// In en, this message translates to:
  /// **'silk'**
  String get materialSilkLower;

  /// No description provided for @materialCottonLower.
  ///
  /// In en, this message translates to:
  /// **'cotton'**
  String get materialCottonLower;

  /// No description provided for @materialWoolLower.
  ///
  /// In en, this message translates to:
  /// **'wool'**
  String get materialWoolLower;

  /// No description provided for @materialJuteLower.
  ///
  /// In en, this message translates to:
  /// **'jute'**
  String get materialJuteLower;

  /// No description provided for @silkMulberry.
  ///
  /// In en, this message translates to:
  /// **'Mulberry'**
  String get silkMulberry;

  /// No description provided for @silkEri.
  ///
  /// In en, this message translates to:
  /// **'Eri'**
  String get silkEri;

  /// No description provided for @silkTasar.
  ///
  /// In en, this message translates to:
  /// **'Tasar'**
  String get silkTasar;

  /// No description provided for @silkMuga.
  ///
  /// In en, this message translates to:
  /// **'Muga'**
  String get silkMuga;

  /// No description provided for @shotProcess.
  ///
  /// In en, this message translates to:
  /// **'Process'**
  String get shotProcess;

  /// No description provided for @shotProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get shotProduct;

  /// No description provided for @shotDetail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get shotDetail;

  /// No description provided for @shotLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get shotLifestyle;

  /// No description provided for @shotPhotography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get shotPhotography;

  /// No description provided for @shotProcessChecklist.
  ///
  /// In en, this message translates to:
  /// **'Show the making process'**
  String get shotProcessChecklist;

  /// No description provided for @shotProductChecklist.
  ///
  /// In en, this message translates to:
  /// **'Full shot of the item'**
  String get shotProductChecklist;

  /// No description provided for @shotDetailChecklist.
  ///
  /// In en, this message translates to:
  /// **'Close-ups of texture/weave'**
  String get shotDetailChecklist;

  /// No description provided for @shotLifestyleChecklist.
  ///
  /// In en, this message translates to:
  /// **'In a natural setting'**
  String get shotLifestyleChecklist;

  /// No description provided for @shotPhotographyChecklist.
  ///
  /// In en, this message translates to:
  /// **'Saree photography templates'**
  String get shotPhotographyChecklist;

  /// No description provided for @slotLoomSetup.
  ///
  /// In en, this message translates to:
  /// **'Loom setup'**
  String get slotLoomSetup;

  /// No description provided for @slotDyeing.
  ///
  /// In en, this message translates to:
  /// **'Dyeing'**
  String get slotDyeing;

  /// No description provided for @slotHeroShot.
  ///
  /// In en, this message translates to:
  /// **'Hero shot'**
  String get slotHeroShot;

  /// No description provided for @slotBorder.
  ///
  /// In en, this message translates to:
  /// **'Border'**
  String get slotBorder;

  /// No description provided for @slotWeave.
  ///
  /// In en, this message translates to:
  /// **'Weave'**
  String get slotWeave;

  /// No description provided for @slotMotif.
  ///
  /// In en, this message translates to:
  /// **'Motif'**
  String get slotMotif;

  /// No description provided for @slotStyledShot.
  ///
  /// In en, this message translates to:
  /// **'Styled shot'**
  String get slotStyledShot;

  /// No description provided for @templateFullDisplay.
  ///
  /// In en, this message translates to:
  /// **'Full Saree Display'**
  String get templateFullDisplay;

  /// No description provided for @templateTextureWeave.
  ///
  /// In en, this message translates to:
  /// **'Texture & Weave'**
  String get templateTextureWeave;

  /// No description provided for @templateDrapedLook.
  ///
  /// In en, this message translates to:
  /// **'Draped Look'**
  String get templateDrapedLook;

  /// No description provided for @templateEmbroideryBorder.
  ///
  /// In en, this message translates to:
  /// **'Embroidery & Border Details'**
  String get templateEmbroideryBorder;

  /// No description provided for @templateFoldedStack.
  ///
  /// In en, this message translates to:
  /// **'Folded Stack / Saree Stack'**
  String get templateFoldedStack;

  /// No description provided for @templateFullDisplayLower.
  ///
  /// In en, this message translates to:
  /// **'full saree display'**
  String get templateFullDisplayLower;

  /// No description provided for @templateTextureWeaveLower.
  ///
  /// In en, this message translates to:
  /// **'texture & weave'**
  String get templateTextureWeaveLower;

  /// No description provided for @templateDrapedLookLower.
  ///
  /// In en, this message translates to:
  /// **'draped look'**
  String get templateDrapedLookLower;

  /// No description provided for @templateEmbroideryBorderLower.
  ///
  /// In en, this message translates to:
  /// **'embroidery & border details'**
  String get templateEmbroideryBorderLower;

  /// No description provided for @templateFoldedStackLower.
  ///
  /// In en, this message translates to:
  /// **'folded stack / saree stack'**
  String get templateFoldedStackLower;

  /// No description provided for @templateFullDisplayContent.
  ///
  /// In en, this message translates to:
  /// **'Colour, Pattern, Material'**
  String get templateFullDisplayContent;

  /// No description provided for @templateTextureWeaveContent.
  ///
  /// In en, this message translates to:
  /// **'Texture, Thickness, Material, Transparency'**
  String get templateTextureWeaveContent;

  /// No description provided for @templateDrapedLookContent.
  ///
  /// In en, this message translates to:
  /// **'Flimsiness, Sheen, Flow, Weight'**
  String get templateDrapedLookContent;

  /// No description provided for @templateEmbroideryBorderContent.
  ///
  /// In en, this message translates to:
  /// **'Embroidery, Quality'**
  String get templateEmbroideryBorderContent;

  /// No description provided for @templateFoldedStackContent.
  ///
  /// In en, this message translates to:
  /// **'Thickness, Material weight'**
  String get templateFoldedStackContent;

  /// No description provided for @templateFullDisplayNeeds.
  ///
  /// In en, this message translates to:
  /// **'Natural daylight; neutral or contrasting background'**
  String get templateFullDisplayNeeds;

  /// No description provided for @templateTextureWeaveNeeds.
  ///
  /// In en, this message translates to:
  /// **'Preferably natural light'**
  String get templateTextureWeaveNeeds;

  /// No description provided for @templateDrapedLookNeeds.
  ///
  /// In en, this message translates to:
  /// **'Hanger, bamboo or mannequin; side lighting'**
  String get templateDrapedLookNeeds;

  /// No description provided for @templateEmbroideryBorderNeeds.
  ///
  /// In en, this message translates to:
  /// **'Side lighting; contrast background'**
  String get templateEmbroideryBorderNeeds;

  /// No description provided for @templateFoldedStackNeeds.
  ///
  /// In en, this message translates to:
  /// **'Side lighting'**
  String get templateFoldedStackNeeds;

  /// No description provided for @templateFullDisplayPlacement.
  ///
  /// In en, this message translates to:
  /// **'Saree spread flat or draped over a surface'**
  String get templateFullDisplayPlacement;

  /// No description provided for @templateTextureWeavePlacement.
  ///
  /// In en, this message translates to:
  /// **'A well-lit section of the saree, preferably in natural light'**
  String get templateTextureWeavePlacement;

  /// No description provided for @templateDrapedLookPlacement.
  ///
  /// In en, this message translates to:
  /// **'Hanger, bamboo or mannequin'**
  String get templateDrapedLookPlacement;

  /// No description provided for @templateEmbroideryBorderPlacement.
  ///
  /// In en, this message translates to:
  /// **'Close-up of the saree border or an embroidered section'**
  String get templateEmbroideryBorderPlacement;

  /// No description provided for @templateFoldedStackPlacement.
  ///
  /// In en, this message translates to:
  /// **'Neatly stacked with visible folds'**
  String get templateFoldedStackPlacement;

  /// No description provided for @templateFullDisplayOverlay.
  ///
  /// In en, this message translates to:
  /// **'Line the top border up with the top third'**
  String get templateFullDisplayOverlay;

  /// No description provided for @templateTextureWeaveOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the texture in the centre'**
  String get templateTextureWeaveOverlay;

  /// No description provided for @templateDrapedLookOverlay.
  ///
  /// In en, this message translates to:
  /// **'Let the folds follow the diagonal'**
  String get templateDrapedLookOverlay;

  /// No description provided for @templateEmbroideryBorderOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the embroidery inside the frame'**
  String get templateEmbroideryBorderOverlay;

  /// No description provided for @templateFoldedStackOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the folds parallel to the horizontal lines'**
  String get templateFoldedStackOverlay;

  /// No description provided for @templateTextureWeaveLighting.
  ///
  /// In en, this message translates to:
  /// **'Use soft light. Avoid harsh reflections.'**
  String get templateTextureWeaveLighting;

  /// No description provided for @templateCushionFullCover.
  ///
  /// In en, this message translates to:
  /// **'Full Cover Display'**
  String get templateCushionFullCover;

  /// No description provided for @templateCushionTextureWeave.
  ///
  /// In en, this message translates to:
  /// **'Texture & Weave'**
  String get templateCushionTextureWeave;

  /// No description provided for @templateCushionStackedPair.
  ///
  /// In en, this message translates to:
  /// **'Stacked Pair / Thickness'**
  String get templateCushionStackedPair;

  /// No description provided for @templateCushionCornerStitching.
  ///
  /// In en, this message translates to:
  /// **'Corner & Stitching'**
  String get templateCushionCornerStitching;

  /// No description provided for @templateCushionInUse.
  ///
  /// In en, this message translates to:
  /// **'In Use on Seating'**
  String get templateCushionInUse;

  /// No description provided for @templateCushionFullCoverLower.
  ///
  /// In en, this message translates to:
  /// **'full cover display'**
  String get templateCushionFullCoverLower;

  /// No description provided for @templateCushionTextureWeaveLower.
  ///
  /// In en, this message translates to:
  /// **'texture & weave'**
  String get templateCushionTextureWeaveLower;

  /// No description provided for @templateCushionStackedPairLower.
  ///
  /// In en, this message translates to:
  /// **'stacked pair / thickness'**
  String get templateCushionStackedPairLower;

  /// No description provided for @templateCushionCornerStitchingLower.
  ///
  /// In en, this message translates to:
  /// **'corner & stitching'**
  String get templateCushionCornerStitchingLower;

  /// No description provided for @templateCushionInUseLower.
  ///
  /// In en, this message translates to:
  /// **'in use on seating'**
  String get templateCushionInUseLower;

  /// No description provided for @templateCushionFullCoverContent.
  ///
  /// In en, this message translates to:
  /// **'Colour, Pattern, Material'**
  String get templateCushionFullCoverContent;

  /// No description provided for @templateCushionTextureWeaveContent.
  ///
  /// In en, this message translates to:
  /// **'Texture, Thickness, Material'**
  String get templateCushionTextureWeaveContent;

  /// No description provided for @templateCushionStackedPairContent.
  ///
  /// In en, this message translates to:
  /// **'Thickness, Material, Texture'**
  String get templateCushionStackedPairContent;

  /// No description provided for @templateCushionCornerStitchingContent.
  ///
  /// In en, this message translates to:
  /// **'Quality, Texture, Embroidery'**
  String get templateCushionCornerStitchingContent;

  /// No description provided for @templateCushionInUseContent.
  ///
  /// In en, this message translates to:
  /// **'Colour, Pattern, Quality'**
  String get templateCushionInUseContent;

  /// No description provided for @templateCushionFullCoverNeeds.
  ///
  /// In en, this message translates to:
  /// **'Natural daylight; plain surface'**
  String get templateCushionFullCoverNeeds;

  /// No description provided for @templateCushionTextureWeaveNeeds.
  ///
  /// In en, this message translates to:
  /// **'Preferably natural light'**
  String get templateCushionTextureWeaveNeeds;

  /// No description provided for @templateCushionStackedPairNeeds.
  ///
  /// In en, this message translates to:
  /// **'Side lighting; a matching pair'**
  String get templateCushionStackedPairNeeds;

  /// No description provided for @templateCushionCornerStitchingNeeds.
  ///
  /// In en, this message translates to:
  /// **'Side lighting'**
  String get templateCushionCornerStitchingNeeds;

  /// No description provided for @templateCushionInUseNeeds.
  ///
  /// In en, this message translates to:
  /// **'A chair, sofa or bed'**
  String get templateCushionInUseNeeds;

  /// No description provided for @templateCushionFullCoverPlacement.
  ///
  /// In en, this message translates to:
  /// **'Cover laid flat on a plain surface'**
  String get templateCushionFullCoverPlacement;

  /// No description provided for @templateCushionTextureWeavePlacement.
  ///
  /// In en, this message translates to:
  /// **'A well-lit section of the cover'**
  String get templateCushionTextureWeavePlacement;

  /// No description provided for @templateCushionStackedPairPlacement.
  ///
  /// In en, this message translates to:
  /// **'Two covers stacked with edges facing the camera'**
  String get templateCushionStackedPairPlacement;

  /// No description provided for @templateCushionCornerStitchingPlacement.
  ///
  /// In en, this message translates to:
  /// **'Close-up of a stitched corner'**
  String get templateCushionCornerStitchingPlacement;

  /// No description provided for @templateCushionInUsePlacement.
  ///
  /// In en, this message translates to:
  /// **'Cover propped on a seat, facing the camera'**
  String get templateCushionInUsePlacement;

  /// No description provided for @templateCushionFullCoverOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the edges straight along the grid'**
  String get templateCushionFullCoverOverlay;

  /// No description provided for @templateCushionTextureWeaveOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the texture in the centre'**
  String get templateCushionTextureWeaveOverlay;

  /// No description provided for @templateCushionStackedPairOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the folds parallel to the horizontal lines'**
  String get templateCushionStackedPairOverlay;

  /// No description provided for @templateCushionCornerStitchingOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the stitching inside the frame'**
  String get templateCushionCornerStitchingOverlay;

  /// No description provided for @templateCushionInUseOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the cover in the frame'**
  String get templateCushionInUseOverlay;

  /// No description provided for @templateShawlFullDesign.
  ///
  /// In en, this message translates to:
  /// **'Full Design Display'**
  String get templateShawlFullDesign;

  /// No description provided for @templateShawlTextureWeave.
  ///
  /// In en, this message translates to:
  /// **'Texture & Weave'**
  String get templateShawlTextureWeave;

  /// No description provided for @templateShawlDrapedLook.
  ///
  /// In en, this message translates to:
  /// **'Draped Look'**
  String get templateShawlDrapedLook;

  /// No description provided for @templateShawlBorderCorner.
  ///
  /// In en, this message translates to:
  /// **'Border & Corner'**
  String get templateShawlBorderCorner;

  /// No description provided for @templateShawlFoldedStack.
  ///
  /// In en, this message translates to:
  /// **'Folded Stack'**
  String get templateShawlFoldedStack;

  /// No description provided for @templateShawlFullDesignLower.
  ///
  /// In en, this message translates to:
  /// **'full design display'**
  String get templateShawlFullDesignLower;

  /// No description provided for @templateShawlTextureWeaveLower.
  ///
  /// In en, this message translates to:
  /// **'texture & weave'**
  String get templateShawlTextureWeaveLower;

  /// No description provided for @templateShawlDrapedLookLower.
  ///
  /// In en, this message translates to:
  /// **'draped look'**
  String get templateShawlDrapedLookLower;

  /// No description provided for @templateShawlBorderCornerLower.
  ///
  /// In en, this message translates to:
  /// **'border & corner'**
  String get templateShawlBorderCornerLower;

  /// No description provided for @templateShawlFoldedStackLower.
  ///
  /// In en, this message translates to:
  /// **'folded stack'**
  String get templateShawlFoldedStackLower;

  /// No description provided for @templateShawlFullDesignContent.
  ///
  /// In en, this message translates to:
  /// **'Pattern, Colour, Transparency'**
  String get templateShawlFullDesignContent;

  /// No description provided for @templateShawlTextureWeaveContent.
  ///
  /// In en, this message translates to:
  /// **'Texture, Thickness, Material'**
  String get templateShawlTextureWeaveContent;

  /// No description provided for @templateShawlDrapedLookContent.
  ///
  /// In en, this message translates to:
  /// **'Flimsiness, Material, Pattern'**
  String get templateShawlDrapedLookContent;

  /// No description provided for @templateShawlBorderCornerContent.
  ///
  /// In en, this message translates to:
  /// **'Texture, Quality, Embroidery'**
  String get templateShawlBorderCornerContent;

  /// No description provided for @templateShawlFoldedStackContent.
  ///
  /// In en, this message translates to:
  /// **'Thickness, Material'**
  String get templateShawlFoldedStackContent;

  /// No description provided for @templateShawlFullDesignNeeds.
  ///
  /// In en, this message translates to:
  /// **'A line, bamboo pole or wall to pin against'**
  String get templateShawlFullDesignNeeds;

  /// No description provided for @templateShawlTextureWeaveNeeds.
  ///
  /// In en, this message translates to:
  /// **'Preferably natural light'**
  String get templateShawlTextureWeaveNeeds;

  /// No description provided for @templateShawlDrapedLookNeeds.
  ///
  /// In en, this message translates to:
  /// **'Someone to wear the shawl'**
  String get templateShawlDrapedLookNeeds;

  /// No description provided for @templateShawlBorderCornerNeeds.
  ///
  /// In en, this message translates to:
  /// **'Side lighting'**
  String get templateShawlBorderCornerNeeds;

  /// No description provided for @templateShawlFoldedStackNeeds.
  ///
  /// In en, this message translates to:
  /// **'Side lighting'**
  String get templateShawlFoldedStackNeeds;

  /// No description provided for @templateShawlFullDesignPlacement.
  ///
  /// In en, this message translates to:
  /// **'Shawl hung or pinned flat without sagging'**
  String get templateShawlFullDesignPlacement;

  /// No description provided for @templateShawlTextureWeavePlacement.
  ///
  /// In en, this message translates to:
  /// **'A well-lit section of the shawl'**
  String get templateShawlTextureWeavePlacement;

  /// No description provided for @templateShawlDrapedLookPlacement.
  ///
  /// In en, this message translates to:
  /// **'Shawl over one shoulder, falling naturally'**
  String get templateShawlDrapedLookPlacement;

  /// No description provided for @templateShawlBorderCornerPlacement.
  ///
  /// In en, this message translates to:
  /// **'Close-up of the corner and border'**
  String get templateShawlBorderCornerPlacement;

  /// No description provided for @templateShawlFoldedStackPlacement.
  ///
  /// In en, this message translates to:
  /// **'Neatly stacked with visible folds'**
  String get templateShawlFoldedStackPlacement;

  /// No description provided for @templateShawlFullDesignOverlay.
  ///
  /// In en, this message translates to:
  /// **'Line the border up with the top third'**
  String get templateShawlFullDesignOverlay;

  /// No description provided for @templateShawlTextureWeaveOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the texture in the centre'**
  String get templateShawlTextureWeaveOverlay;

  /// No description provided for @templateShawlDrapedLookOverlay.
  ///
  /// In en, this message translates to:
  /// **'Let the folds follow the diagonal'**
  String get templateShawlDrapedLookOverlay;

  /// No description provided for @templateShawlBorderCornerOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the border inside the frame'**
  String get templateShawlBorderCornerOverlay;

  /// No description provided for @templateShawlFoldedStackOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the folds parallel to the horizontal lines'**
  String get templateShawlFoldedStackOverlay;

  /// No description provided for @templateStoleFullLength.
  ///
  /// In en, this message translates to:
  /// **'Full Length Display'**
  String get templateStoleFullLength;

  /// No description provided for @templateStoleTextureWeave.
  ///
  /// In en, this message translates to:
  /// **'Texture & Weave'**
  String get templateStoleTextureWeave;

  /// No description provided for @templateStoleNeckWrap.
  ///
  /// In en, this message translates to:
  /// **'Worn Neck Wrap'**
  String get templateStoleNeckWrap;

  /// No description provided for @templateStoleSoftnessKnot.
  ///
  /// In en, this message translates to:
  /// **'Softness / Knot'**
  String get templateStoleSoftnessKnot;

  /// No description provided for @templateStoleEdgeThickness.
  ///
  /// In en, this message translates to:
  /// **'Edge & Thickness'**
  String get templateStoleEdgeThickness;

  /// No description provided for @templateStoleFullLengthLower.
  ///
  /// In en, this message translates to:
  /// **'full length display'**
  String get templateStoleFullLengthLower;

  /// No description provided for @templateStoleTextureWeaveLower.
  ///
  /// In en, this message translates to:
  /// **'texture & weave'**
  String get templateStoleTextureWeaveLower;

  /// No description provided for @templateStoleNeckWrapLower.
  ///
  /// In en, this message translates to:
  /// **'worn neck wrap'**
  String get templateStoleNeckWrapLower;

  /// No description provided for @templateStoleSoftnessKnotLower.
  ///
  /// In en, this message translates to:
  /// **'softness / knot'**
  String get templateStoleSoftnessKnotLower;

  /// No description provided for @templateStoleEdgeThicknessLower.
  ///
  /// In en, this message translates to:
  /// **'edge & thickness'**
  String get templateStoleEdgeThicknessLower;

  /// No description provided for @templateStoleFullLengthContent.
  ///
  /// In en, this message translates to:
  /// **'Pattern, Colour, Material'**
  String get templateStoleFullLengthContent;

  /// No description provided for @templateStoleTextureWeaveContent.
  ///
  /// In en, this message translates to:
  /// **'Texture, Thickness, Material'**
  String get templateStoleTextureWeaveContent;

  /// No description provided for @templateStoleNeckWrapContent.
  ///
  /// In en, this message translates to:
  /// **'Flimsiness, Colour, Pattern'**
  String get templateStoleNeckWrapContent;

  /// No description provided for @templateStoleSoftnessKnotContent.
  ///
  /// In en, this message translates to:
  /// **'Flimsiness, Texture, Material'**
  String get templateStoleSoftnessKnotContent;

  /// No description provided for @templateStoleEdgeThicknessContent.
  ///
  /// In en, this message translates to:
  /// **'Thickness, Texture, Material'**
  String get templateStoleEdgeThicknessContent;

  /// No description provided for @templateStoleFullLengthNeeds.
  ///
  /// In en, this message translates to:
  /// **'Natural daylight; plain surface'**
  String get templateStoleFullLengthNeeds;

  /// No description provided for @templateStoleTextureWeaveNeeds.
  ///
  /// In en, this message translates to:
  /// **'Preferably natural light'**
  String get templateStoleTextureWeaveNeeds;

  /// No description provided for @templateStoleNeckWrapNeeds.
  ///
  /// In en, this message translates to:
  /// **'Someone to wear the stole'**
  String get templateStoleNeckWrapNeeds;

  /// No description provided for @templateStoleSoftnessKnotNeeds.
  ///
  /// In en, this message translates to:
  /// **'Soft side light'**
  String get templateStoleSoftnessKnotNeeds;

  /// No description provided for @templateStoleEdgeThicknessNeeds.
  ///
  /// In en, this message translates to:
  /// **'Soft side light'**
  String get templateStoleEdgeThicknessNeeds;

  /// No description provided for @templateStoleFullLengthPlacement.
  ///
  /// In en, this message translates to:
  /// **'Stole spread so its full length is visible'**
  String get templateStoleFullLengthPlacement;

  /// No description provided for @templateStoleTextureWeavePlacement.
  ///
  /// In en, this message translates to:
  /// **'A well-lit section of the stole'**
  String get templateStoleTextureWeavePlacement;

  /// No description provided for @templateStoleNeckWrapPlacement.
  ///
  /// In en, this message translates to:
  /// **'Wrapped once around the neck with both ends visible'**
  String get templateStoleNeckWrapPlacement;

  /// No description provided for @templateStoleSoftnessKnotPlacement.
  ///
  /// In en, this message translates to:
  /// **'One loose knot in the middle'**
  String get templateStoleSoftnessKnotPlacement;

  /// No description provided for @templateStoleEdgeThicknessPlacement.
  ///
  /// In en, this message translates to:
  /// **'Stole rolled loosely into a coil'**
  String get templateStoleEdgeThicknessPlacement;

  /// No description provided for @templateStoleFullLengthOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the stole along the grid'**
  String get templateStoleFullLengthOverlay;

  /// No description provided for @templateStoleTextureWeaveOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the texture in the centre'**
  String get templateStoleTextureWeaveOverlay;

  /// No description provided for @templateStoleNeckWrapOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the wrap in the frame'**
  String get templateStoleNeckWrapOverlay;

  /// No description provided for @templateStoleSoftnessKnotOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the knot in the centre'**
  String get templateStoleSoftnessKnotOverlay;

  /// No description provided for @templateStoleEdgeThicknessOverlay.
  ///
  /// In en, this message translates to:
  /// **'Keep the coil in the centre'**
  String get templateStoleEdgeThicknessOverlay;

  /// No description provided for @presetSareePalluDrapeName.
  ///
  /// In en, this message translates to:
  /// **'Pallu drape (hanger)'**
  String get presetSareePalluDrapeName;

  /// No description provided for @presetSareeBoxFoldName.
  ///
  /// In en, this message translates to:
  /// **'Box / flat fold'**
  String get presetSareeBoxFoldName;

  /// No description provided for @presetSareeWornDrapeName.
  ///
  /// In en, this message translates to:
  /// **'Worn drape (model)'**
  String get presetSareeWornDrapeName;

  /// No description provided for @presetSareeRollDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Roll display'**
  String get presetSareeRollDisplayName;

  /// No description provided for @presetCushionFlatLayName.
  ///
  /// In en, this message translates to:
  /// **'Flat lay'**
  String get presetCushionFlatLayName;

  /// No description provided for @presetCushionStackedPairName.
  ///
  /// In en, this message translates to:
  /// **'Stacked pair'**
  String get presetCushionStackedPairName;

  /// No description provided for @presetCushionProppedName.
  ///
  /// In en, this message translates to:
  /// **'Propped on seating'**
  String get presetCushionProppedName;

  /// No description provided for @presetCushionCornerTuckName.
  ///
  /// In en, this message translates to:
  /// **'Corner tuck close-up'**
  String get presetCushionCornerTuckName;

  /// No description provided for @presetShawlDrapedShoulderName.
  ///
  /// In en, this message translates to:
  /// **'Draped on shoulder'**
  String get presetShawlDrapedShoulderName;

  /// No description provided for @presetShawlFoldedStackName.
  ///
  /// In en, this message translates to:
  /// **'Folded stack'**
  String get presetShawlFoldedStackName;

  /// No description provided for @presetShawlHungFlatName.
  ///
  /// In en, this message translates to:
  /// **'Hung / pinned flat'**
  String get presetShawlHungFlatName;

  /// No description provided for @presetShawlCornerTuckName.
  ///
  /// In en, this message translates to:
  /// **'Corner tuck close-up'**
  String get presetShawlCornerTuckName;

  /// No description provided for @presetStoleNeckWrapName.
  ///
  /// In en, this message translates to:
  /// **'Neck wrap (worn)'**
  String get presetStoleNeckWrapName;

  /// No description provided for @presetStoleFlatSpreadName.
  ///
  /// In en, this message translates to:
  /// **'Flat spread'**
  String get presetStoleFlatSpreadName;

  /// No description provided for @presetStoleLooseKnotName.
  ///
  /// In en, this message translates to:
  /// **'Loose knot'**
  String get presetStoleLooseKnotName;

  /// No description provided for @presetStoleRolledCoilName.
  ///
  /// In en, this message translates to:
  /// **'Rolled coil'**
  String get presetStoleRolledCoilName;

  /// No description provided for @presetSareePalluDrapePurpose.
  ///
  /// In en, this message translates to:
  /// **'Shows flimsiness, sheen, flow and weight.'**
  String get presetSareePalluDrapePurpose;

  /// No description provided for @presetSareeBoxFoldPurpose.
  ///
  /// In en, this message translates to:
  /// **'Shows thickness and material weight.'**
  String get presetSareeBoxFoldPurpose;

  /// No description provided for @presetSareeWornDrapePurpose.
  ///
  /// In en, this message translates to:
  /// **'Shows colour, pattern and material when worn.'**
  String get presetSareeWornDrapePurpose;

  /// No description provided for @presetSareeRollDisplayPurpose.
  ///
  /// In en, this message translates to:
  /// **'Shows colour, pattern and material in a compact roll.'**
  String get presetSareeRollDisplayPurpose;

  /// No description provided for @presetCushionFlatLayPurpose.
  ///
  /// In en, this message translates to:
  /// **'Show the full pattern and colour without distortion.'**
  String get presetCushionFlatLayPurpose;

  /// No description provided for @presetCushionStackedPairPurpose.
  ///
  /// In en, this message translates to:
  /// **'Show thickness and how a pair looks together.'**
  String get presetCushionStackedPairPurpose;

  /// No description provided for @presetCushionProppedPurpose.
  ///
  /// In en, this message translates to:
  /// **'Show the cover in use, at real scale.'**
  String get presetCushionProppedPurpose;

  /// No description provided for @presetCushionCornerTuckPurpose.
  ///
  /// In en, this message translates to:
  /// **'Show stitching quality and the finish at the corner.'**
  String get presetCushionCornerTuckPurpose;

  /// No description provided for @presetShawlDrapedShoulderPurpose.
  ///
  /// In en, this message translates to:
  /// **'Show drape, weight and how it sits when worn.'**
  String get presetShawlDrapedShoulderPurpose;

  /// No description provided for @presetShawlFoldedStackPurpose.
  ///
  /// In en, this message translates to:
  /// **'Show thickness and material weight.'**
  String get presetShawlFoldedStackPurpose;

  /// No description provided for @presetShawlHungFlatPurpose.
  ///
  /// In en, this message translates to:
  /// **'Show the full design, colour and border at once.'**
  String get presetShawlHungFlatPurpose;

  /// No description provided for @presetShawlCornerTuckPurpose.
  ///
  /// In en, this message translates to:
  /// **'Show weave, border detail and craftsmanship.'**
  String get presetShawlCornerTuckPurpose;

  /// No description provided for @presetStoleNeckWrapPurpose.
  ///
  /// In en, this message translates to:
  /// **'Show scale and how the stole sits when worn.'**
  String get presetStoleNeckWrapPurpose;

  /// No description provided for @presetStoleFlatSpreadPurpose.
  ///
  /// In en, this message translates to:
  /// **'Show the full length, pattern and both borders.'**
  String get presetStoleFlatSpreadPurpose;

  /// No description provided for @presetStoleLooseKnotPurpose.
  ///
  /// In en, this message translates to:
  /// **'Show how soft the fabric is and how easily it knots.'**
  String get presetStoleLooseKnotPurpose;

  /// No description provided for @presetStoleRolledCoilPurpose.
  ///
  /// In en, this message translates to:
  /// **'Show the edge, thickness and finish of the weave.'**
  String get presetStoleRolledCoilPurpose;

  /// No description provided for @presetSareePalluDrapeContent.
  ///
  /// In en, this message translates to:
  /// **'Flimsiness, Sheen, Flow, Weight'**
  String get presetSareePalluDrapeContent;

  /// No description provided for @presetSareeBoxFoldContent.
  ///
  /// In en, this message translates to:
  /// **'Thickness, Material weight'**
  String get presetSareeBoxFoldContent;

  /// No description provided for @presetSareeWornDrapeContent.
  ///
  /// In en, this message translates to:
  /// **'Colour, Pattern, Material'**
  String get presetSareeWornDrapeContent;

  /// No description provided for @presetSareeRollDisplayContent.
  ///
  /// In en, this message translates to:
  /// **'Colour, Pattern, Material'**
  String get presetSareeRollDisplayContent;

  /// No description provided for @presetSareePalluDrapeNeeds.
  ///
  /// In en, this message translates to:
  /// **'Hanger, bamboo or mannequin; side lighting'**
  String get presetSareePalluDrapeNeeds;

  /// No description provided for @presetSareeBoxFoldNeeds.
  ///
  /// In en, this message translates to:
  /// **'Side lighting'**
  String get presetSareeBoxFoldNeeds;

  /// No description provided for @presetSareeWornDrapeNeeds.
  ///
  /// In en, this message translates to:
  /// **'Someone to wear the saree; natural daylight; neutral or contrasting background'**
  String get presetSareeWornDrapeNeeds;

  /// No description provided for @presetSareeRollDisplayNeeds.
  ///
  /// In en, this message translates to:
  /// **'Natural daylight; neutral or contrasting background'**
  String get presetSareeRollDisplayNeeds;

  /// No description provided for @presetSareePalluDrapeLower.
  ///
  /// In en, this message translates to:
  /// **'pallu drape (hanger)'**
  String get presetSareePalluDrapeLower;

  /// No description provided for @presetSareeBoxFoldLower.
  ///
  /// In en, this message translates to:
  /// **'box / flat fold'**
  String get presetSareeBoxFoldLower;

  /// No description provided for @presetSareeWornDrapeLower.
  ///
  /// In en, this message translates to:
  /// **'worn drape (model)'**
  String get presetSareeWornDrapeLower;

  /// No description provided for @presetSareeRollDisplayLower.
  ///
  /// In en, this message translates to:
  /// **'roll display'**
  String get presetSareeRollDisplayLower;

  /// No description provided for @presetCushionFlatLayLower.
  ///
  /// In en, this message translates to:
  /// **'flat lay'**
  String get presetCushionFlatLayLower;

  /// No description provided for @presetCushionStackedPairLower.
  ///
  /// In en, this message translates to:
  /// **'stacked pair'**
  String get presetCushionStackedPairLower;

  /// No description provided for @presetCushionProppedLower.
  ///
  /// In en, this message translates to:
  /// **'propped on seating'**
  String get presetCushionProppedLower;

  /// No description provided for @presetCushionCornerTuckLower.
  ///
  /// In en, this message translates to:
  /// **'corner tuck close-up'**
  String get presetCushionCornerTuckLower;

  /// No description provided for @presetShawlDrapedShoulderLower.
  ///
  /// In en, this message translates to:
  /// **'draped on shoulder'**
  String get presetShawlDrapedShoulderLower;

  /// No description provided for @presetShawlFoldedStackLower.
  ///
  /// In en, this message translates to:
  /// **'folded stack'**
  String get presetShawlFoldedStackLower;

  /// No description provided for @presetShawlHungFlatLower.
  ///
  /// In en, this message translates to:
  /// **'hung / pinned flat'**
  String get presetShawlHungFlatLower;

  /// No description provided for @presetShawlCornerTuckLower.
  ///
  /// In en, this message translates to:
  /// **'corner tuck close-up'**
  String get presetShawlCornerTuckLower;

  /// No description provided for @presetStoleNeckWrapLower.
  ///
  /// In en, this message translates to:
  /// **'neck wrap (worn)'**
  String get presetStoleNeckWrapLower;

  /// No description provided for @presetStoleFlatSpreadLower.
  ///
  /// In en, this message translates to:
  /// **'flat spread'**
  String get presetStoleFlatSpreadLower;

  /// No description provided for @presetStoleLooseKnotLower.
  ///
  /// In en, this message translates to:
  /// **'loose knot'**
  String get presetStoleLooseKnotLower;

  /// No description provided for @presetStoleRolledCoilLower.
  ///
  /// In en, this message translates to:
  /// **'rolled coil'**
  String get presetStoleRolledCoilLower;

  /// No description provided for @shotProcessLower.
  ///
  /// In en, this message translates to:
  /// **'process'**
  String get shotProcessLower;

  /// No description provided for @shotProductLower.
  ///
  /// In en, this message translates to:
  /// **'product'**
  String get shotProductLower;

  /// No description provided for @shotDetailLower.
  ///
  /// In en, this message translates to:
  /// **'detail'**
  String get shotDetailLower;

  /// No description provided for @shotLifestyleLower.
  ///
  /// In en, this message translates to:
  /// **'lifestyle'**
  String get shotLifestyleLower;

  /// No description provided for @shotPhotographyLower.
  ///
  /// In en, this message translates to:
  /// **'photography'**
  String get shotPhotographyLower;

  /// No description provided for @categorySareeLower.
  ///
  /// In en, this message translates to:
  /// **'saree'**
  String get categorySareeLower;

  /// No description provided for @categoryCushionCoverLower.
  ///
  /// In en, this message translates to:
  /// **'cushion cover'**
  String get categoryCushionCoverLower;

  /// No description provided for @categoryShawlLower.
  ///
  /// In en, this message translates to:
  /// **'shawl'**
  String get categoryShawlLower;

  /// No description provided for @categoryStoleLower.
  ///
  /// In en, this message translates to:
  /// **'stole'**
  String get categoryStoleLower;

  /// No description provided for @propertyColour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get propertyColour;

  /// No description provided for @propertyMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get propertyMaterial;

  /// No description provided for @propertyQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get propertyQuality;

  /// No description provided for @propertyFlimsiness.
  ///
  /// In en, this message translates to:
  /// **'Flimsiness'**
  String get propertyFlimsiness;

  /// No description provided for @propertyTexture.
  ///
  /// In en, this message translates to:
  /// **'Texture'**
  String get propertyTexture;

  /// No description provided for @propertyThickness.
  ///
  /// In en, this message translates to:
  /// **'Thickness'**
  String get propertyThickness;

  /// No description provided for @propertyTransparency.
  ///
  /// In en, this message translates to:
  /// **'Transparency'**
  String get propertyTransparency;

  /// No description provided for @propertyPattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get propertyPattern;

  /// No description provided for @propertySheen.
  ///
  /// In en, this message translates to:
  /// **'Sheen / Gloss'**
  String get propertySheen;

  /// No description provided for @propertyEmbroidery.
  ///
  /// In en, this message translates to:
  /// **'Embroidery'**
  String get propertyEmbroidery;

  /// No description provided for @angleEyeLevel.
  ///
  /// In en, this message translates to:
  /// **'Eye-level'**
  String get angleEyeLevel;

  /// No description provided for @angleEyeLevelHint.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone at the height of the product, straight on.'**
  String get angleEyeLevelHint;

  /// No description provided for @angleOverhead.
  ///
  /// In en, this message translates to:
  /// **'Overhead (flat lay)'**
  String get angleOverhead;

  /// No description provided for @angleOverheadHint.
  ///
  /// In en, this message translates to:
  /// **'Stand over the product and point the phone straight down.'**
  String get angleOverheadHint;

  /// No description provided for @angleLow.
  ///
  /// In en, this message translates to:
  /// **'Low angle'**
  String get angleLow;

  /// No description provided for @angleLowHint.
  ///
  /// In en, this message translates to:
  /// **'Lower the phone below the product and tilt slightly upward.'**
  String get angleLowHint;

  /// No description provided for @angleMacro.
  ///
  /// In en, this message translates to:
  /// **'Macro close-up'**
  String get angleMacro;

  /// No description provided for @angleMacroHint.
  ///
  /// In en, this message translates to:
  /// **'Move close until the weave fills the frame, then tap to focus.'**
  String get angleMacroHint;

  /// No description provided for @lightingSoftWindow.
  ///
  /// In en, this message translates to:
  /// **'Soft window light'**
  String get lightingSoftWindow;

  /// No description provided for @lightingSoftWindowHint.
  ///
  /// In en, this message translates to:
  /// **'Place the product beside a window, not under a bulb.'**
  String get lightingSoftWindowHint;

  /// No description provided for @lightingDiffused.
  ///
  /// In en, this message translates to:
  /// **'Diffused daylight'**
  String get lightingDiffused;

  /// No description provided for @lightingDiffusedHint.
  ///
  /// In en, this message translates to:
  /// **'Shoot outdoors in open shade, with light coming from one side.'**
  String get lightingDiffusedHint;

  /// No description provided for @lightingAvoidMidday.
  ///
  /// In en, this message translates to:
  /// **'Avoid harsh midday sun'**
  String get lightingAvoidMidday;

  /// No description provided for @lightingAvoidMiddayHint.
  ///
  /// In en, this message translates to:
  /// **'Wait until after 3 PM — overhead sun washes out the colour.'**
  String get lightingAvoidMiddayHint;

  /// No description provided for @lightingBacklight.
  ///
  /// In en, this message translates to:
  /// **'Backlight for sheer fabrics'**
  String get lightingBacklight;

  /// No description provided for @lightingBacklightHint.
  ///
  /// In en, this message translates to:
  /// **'Put the light behind the fabric to show how much passes through.'**
  String get lightingBacklightHint;

  /// No description provided for @compositionRuleOfThirds.
  ///
  /// In en, this message translates to:
  /// **'Rule of thirds'**
  String get compositionRuleOfThirds;

  /// No description provided for @compositionRuleOfThirdsHint.
  ///
  /// In en, this message translates to:
  /// **'Line the border up with the top third of the grid.'**
  String get compositionRuleOfThirdsHint;

  /// No description provided for @compositionCentered.
  ///
  /// In en, this message translates to:
  /// **'Centered product'**
  String get compositionCentered;

  /// No description provided for @compositionCenteredHint.
  ///
  /// In en, this message translates to:
  /// **'Keep the product in the middle box of the grid.'**
  String get compositionCenteredHint;

  /// No description provided for @compositionNegativeSpace.
  ///
  /// In en, this message translates to:
  /// **'Negative space around folds'**
  String get compositionNegativeSpace;

  /// No description provided for @compositionNegativeSpaceHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty space around the folds so they read clearly.'**
  String get compositionNegativeSpaceHint;

  /// No description provided for @compositionLeadingLines.
  ///
  /// In en, this message translates to:
  /// **'Leading fabric lines'**
  String get compositionLeadingLines;

  /// No description provided for @compositionLeadingLinesHint.
  ///
  /// In en, this message translates to:
  /// **'Lay the folds along the diagonal guides.'**
  String get compositionLeadingLinesHint;

  /// No description provided for @compositionCentreFocus.
  ///
  /// In en, this message translates to:
  /// **'Centre focus'**
  String get compositionCentreFocus;

  /// No description provided for @compositionCentreFocusHint.
  ///
  /// In en, this message translates to:
  /// **'Keep the texture in the centre of the frame.'**
  String get compositionCentreFocusHint;

  /// No description provided for @compositionDetailFrame.
  ///
  /// In en, this message translates to:
  /// **'Detail frame'**
  String get compositionDetailFrame;

  /// No description provided for @compositionDetailFrameHint.
  ///
  /// In en, this message translates to:
  /// **'Keep the embroidery inside the highlighted frame.'**
  String get compositionDetailFrameHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['as', 'en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'as':
      return AppLocalizationsAs();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
