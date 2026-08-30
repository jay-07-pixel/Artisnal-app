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

  /// No description provided for @cottonKhadi.
  ///
  /// In en, this message translates to:
  /// **'Khadi'**
  String get cottonKhadi;

  /// No description provided for @cottonMuslin.
  ///
  /// In en, this message translates to:
  /// **'Muslin'**
  String get cottonMuslin;

  /// No description provided for @cottonHandloom.
  ///
  /// In en, this message translates to:
  /// **'Handloom'**
  String get cottonHandloom;

  /// No description provided for @cottonJamdani.
  ///
  /// In en, this message translates to:
  /// **'Jamdani'**
  String get cottonJamdani;

  /// No description provided for @woolPashmina.
  ///
  /// In en, this message translates to:
  /// **'Pashmina'**
  String get woolPashmina;

  /// No description provided for @woolAngora.
  ///
  /// In en, this message translates to:
  /// **'Angora'**
  String get woolAngora;

  /// No description provided for @woolMerino.
  ///
  /// In en, this message translates to:
  /// **'Merino'**
  String get woolMerino;

  /// No description provided for @woolHandspun.
  ///
  /// In en, this message translates to:
  /// **'Handspun'**
  String get woolHandspun;

  /// No description provided for @juteGolden.
  ///
  /// In en, this message translates to:
  /// **'Golden'**
  String get juteGolden;

  /// No description provided for @juteTossa.
  ///
  /// In en, this message translates to:
  /// **'Tossa'**
  String get juteTossa;

  /// No description provided for @juteHessian.
  ///
  /// In en, this message translates to:
  /// **'Hessian'**
  String get juteHessian;

  /// No description provided for @juteBlended.
  ///
  /// In en, this message translates to:
  /// **'Blended'**
  String get juteBlended;

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

  /// No description provided for @accountBackup.
  ///
  /// In en, this message translates to:
  /// **'Account & backup'**
  String get accountBackup;

  /// No description provided for @accountBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a username and password to save progress online.'**
  String get accountBackupSubtitle;

  /// No description provided for @cloudBackupNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup not configured'**
  String get cloudBackupNotConfigured;

  /// No description provided for @cloudBackupNotConfiguredBody.
  ///
  /// In en, this message translates to:
  /// **'This build has no cloud connection. Progress stays on this phone only.'**
  String get cloudBackupNotConfiguredBody;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get signedInAs;

  /// No description provided for @artisanFallback.
  ///
  /// In en, this message translates to:
  /// **'Artisan'**
  String get artisanFallback;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @createAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Create an account to save your work online.'**
  String get createAccountPrompt;

  /// No description provided for @signInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to load your saved products and photos.'**
  String get signInPrompt;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. priya_weaver'**
  String get usernameHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @needAccount.
  ///
  /// In en, this message translates to:
  /// **'Need an account? Create one'**
  String get needAccount;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created. Your progress will sync online.'**
  String get accountCreated;

  /// No description provided for @signedInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in. Your saved work is on this phone.'**
  String get signedInSuccess;

  /// No description provided for @signedOutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed out. Local photos stay on this phone.'**
  String get signedOutSuccess;

  /// No description provided for @syncOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet — sync when you are back online.'**
  String get syncOffline;

  /// No description provided for @syncDone.
  ///
  /// In en, this message translates to:
  /// **'Synced: {sets} products uploaded, {shots} photos uploaded.'**
  String syncDone(int sets, int shots);

  /// No description provided for @syncUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Everything is already up to date.'**
  String get syncUpToDate;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed: {error}'**
  String syncFailed(String error);

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get yourProgress;

  /// No description provided for @productsStarted.
  ///
  /// In en, this message translates to:
  /// **'Products started'**
  String get productsStarted;

  /// No description provided for @finishedSets.
  ///
  /// In en, this message translates to:
  /// **'Finished sets'**
  String get finishedSets;

  /// No description provided for @inProgressSets.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgressSets;

  /// No description provided for @photosCaptured.
  ///
  /// In en, this message translates to:
  /// **'Photos captured'**
  String get photosCaptured;

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 letters or numbers.'**
  String get usernameTooShort;

  /// No description provided for @usernameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Username must be 32 characters or fewer.'**
  String get usernameTooLong;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get passwordTooShort;

  /// No description provided for @fullScreen.
  ///
  /// In en, this message translates to:
  /// **'Full screen'**
  String get fullScreen;

  /// No description provided for @tapToSkip.
  ///
  /// In en, this message translates to:
  /// **'Tap to skip'**
  String get tapToSkip;

  /// No description provided for @cameraPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is needed to take photos.\nPlease allow camera access in Settings.'**
  String get cameraPermissionNeeded;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The camera is unavailable.'**
  String get cameraUnavailable;

  /// No description provided for @noCameraFound.
  ///
  /// In en, this message translates to:
  /// **'No camera found on this device.'**
  String get noCameraFound;

  /// No description provided for @accountCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create your account. Try again.'**
  String get accountCreateFailed;

  /// No description provided for @enterValidUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid username.'**
  String get enterValidUsername;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthDec;

  /// No description provided for @presetCushionFlatLayNeeds.
  ///
  /// In en, this message translates to:
  /// **'Plain uncluttered surface'**
  String get presetCushionFlatLayNeeds;

  /// No description provided for @presetCushionStackedPairNeeds.
  ///
  /// In en, this message translates to:
  /// **'Two covers; side light'**
  String get presetCushionStackedPairNeeds;

  /// No description provided for @presetCushionProppedNeeds.
  ///
  /// In en, this message translates to:
  /// **'A chair, sofa or bed'**
  String get presetCushionProppedNeeds;

  /// No description provided for @presetCushionCornerTuckNeeds.
  ///
  /// In en, this message translates to:
  /// **'Close-up light'**
  String get presetCushionCornerTuckNeeds;

  /// No description provided for @presetShawlDrapedShoulderNeeds.
  ///
  /// In en, this message translates to:
  /// **'Someone to wear the shawl'**
  String get presetShawlDrapedShoulderNeeds;

  /// No description provided for @presetShawlFoldedStackNeeds.
  ///
  /// In en, this message translates to:
  /// **'Side lighting'**
  String get presetShawlFoldedStackNeeds;

  /// No description provided for @presetShawlHungFlatNeeds.
  ///
  /// In en, this message translates to:
  /// **'A line, bamboo pole or wall to pin against'**
  String get presetShawlHungFlatNeeds;

  /// No description provided for @presetShawlCornerTuckNeeds.
  ///
  /// In en, this message translates to:
  /// **'Close-up light'**
  String get presetShawlCornerTuckNeeds;

  /// No description provided for @presetStoleNeckWrapNeeds.
  ///
  /// In en, this message translates to:
  /// **'Someone to wear the stole'**
  String get presetStoleNeckWrapNeeds;

  /// No description provided for @presetStoleFlatSpreadNeeds.
  ///
  /// In en, this message translates to:
  /// **'Plain surface; overhead view'**
  String get presetStoleFlatSpreadNeeds;

  /// No description provided for @presetStoleLooseKnotNeeds.
  ///
  /// In en, this message translates to:
  /// **'Soft side light'**
  String get presetStoleLooseKnotNeeds;

  /// No description provided for @presetStoleRolledCoilNeeds.
  ///
  /// In en, this message translates to:
  /// **'Soft side light'**
  String get presetStoleRolledCoilNeeds;

  /// No description provided for @placementSareePalluDrape.
  ///
  /// In en, this message translates to:
  /// **'Drape the saree over a hanger, bamboo or mannequin so the pallu falls freely.'**
  String get placementSareePalluDrape;

  /// No description provided for @placementSareeBoxFold.
  ///
  /// In en, this message translates to:
  /// **'Fold the saree into even layers and stack them so the edge is visible.'**
  String get placementSareeBoxFold;

  /// No description provided for @placementSareeWornDrape.
  ///
  /// In en, this message translates to:
  /// **'Drape the saree on the person so colour, pattern and border show clearly.'**
  String get placementSareeWornDrape;

  /// No description provided for @placementSareeRollDisplay.
  ///
  /// In en, this message translates to:
  /// **'Roll the saree so the pallu and border face the camera.'**
  String get placementSareeRollDisplay;

  /// No description provided for @placementCushionFlatLay.
  ///
  /// In en, this message translates to:
  /// **'Place the cover flat on a plain, uncluttered surface.'**
  String get placementCushionFlatLay;

  /// No description provided for @placementCushionStackedPair.
  ///
  /// In en, this message translates to:
  /// **'Place one cover neatly on top of the other.'**
  String get placementCushionStackedPair;

  /// No description provided for @placementCushionPropped.
  ///
  /// In en, this message translates to:
  /// **'Prop the cushion on a chair or sofa, facing forward.'**
  String get placementCushionPropped;

  /// No description provided for @placementCushionCornerTuck.
  ///
  /// In en, this message translates to:
  /// **'Turn the cover so one stitched corner faces you.'**
  String get placementCushionCornerTuck;

  /// No description provided for @placementShawlDrapedShoulder.
  ///
  /// In en, this message translates to:
  /// **'Place the shawl over one shoulder, letting it fall.'**
  String get placementShawlDrapedShoulder;

  /// No description provided for @placementShawlFoldedStack.
  ///
  /// In en, this message translates to:
  /// **'Fold the shawl into even layers and stack them neatly.'**
  String get placementShawlFoldedStack;

  /// No description provided for @placementShawlHungFlat.
  ///
  /// In en, this message translates to:
  /// **'Pin both top corners so the shawl hangs without sagging.'**
  String get placementShawlHungFlat;

  /// No description provided for @placementShawlCornerTuck.
  ///
  /// In en, this message translates to:
  /// **'Fold one corner back to show both sides of the weave.'**
  String get placementShawlCornerTuck;

  /// No description provided for @placementStoleNeckWrap.
  ///
  /// In en, this message translates to:
  /// **'Wrap it once around the neck, letting both ends hang.'**
  String get placementStoleNeckWrap;

  /// No description provided for @placementStoleFlatSpread.
  ///
  /// In en, this message translates to:
  /// **'Spread the stole flat so its full length is visible.'**
  String get placementStoleFlatSpread;

  /// No description provided for @placementStoleLooseKnot.
  ///
  /// In en, this message translates to:
  /// **'Tie one loose knot in the middle — do not pull tight.'**
  String get placementStoleLooseKnot;

  /// No description provided for @placementStoleRolledCoil.
  ///
  /// In en, this message translates to:
  /// **'Roll the stole loosely into a flat coil.'**
  String get placementStoleRolledCoil;

  /// No description provided for @transcriptSareePalluDrape1.
  ///
  /// In en, this message translates to:
  /// **'Hang the saree so its fall is clearly visible.'**
  String get transcriptSareePalluDrape1;

  /// No description provided for @transcriptSareePalluDrape2.
  ///
  /// In en, this message translates to:
  /// **'Use a hanger, bamboo pole or mannequin at about shoulder height.'**
  String get transcriptSareePalluDrape2;

  /// No description provided for @transcriptSareePalluDrape3.
  ///
  /// In en, this message translates to:
  /// **'Let the pallu hang freely — do not pull it straight.'**
  String get transcriptSareePalluDrape3;

  /// No description provided for @transcriptSareePalluDrape4.
  ///
  /// In en, this message translates to:
  /// **'Let the folds follow the diagonal lines on your screen.'**
  String get transcriptSareePalluDrape4;

  /// No description provided for @transcriptSareePalluDrape5.
  ///
  /// In en, this message translates to:
  /// **'Keep one light source to the side so the sheen shows.'**
  String get transcriptSareePalluDrape5;

  /// No description provided for @transcriptSareeBoxFold1.
  ///
  /// In en, this message translates to:
  /// **'Fold the saree into a neat stack so the layers stay visible.'**
  String get transcriptSareeBoxFold1;

  /// No description provided for @transcriptSareeBoxFold2.
  ///
  /// In en, this message translates to:
  /// **'Keep the folded edge facing the camera — that edge shows thickness.'**
  String get transcriptSareeBoxFold2;

  /// No description provided for @transcriptSareeBoxFold3.
  ///
  /// In en, this message translates to:
  /// **'Line the folds up with the horizontal guides.'**
  String get transcriptSareeBoxFold3;

  /// No description provided for @transcriptSareeBoxFold4.
  ///
  /// In en, this message translates to:
  /// **'Use light from the side so each layer has depth.'**
  String get transcriptSareeBoxFold4;

  /// No description provided for @transcriptSareeWornDrape1.
  ///
  /// In en, this message translates to:
  /// **'A worn shot shows the full saree — colour, pattern and material.'**
  String get transcriptSareeWornDrape1;

  /// No description provided for @transcriptSareeWornDrape2.
  ///
  /// In en, this message translates to:
  /// **'Stand in open shade so the colour stays true.'**
  String get transcriptSareeWornDrape2;

  /// No description provided for @transcriptSareeWornDrape3.
  ///
  /// In en, this message translates to:
  /// **'Let the saree cover most of the frame.'**
  String get transcriptSareeWornDrape3;

  /// No description provided for @transcriptSareeWornDrape4.
  ///
  /// In en, this message translates to:
  /// **'Line the top border up with the top third of the grid.'**
  String get transcriptSareeWornDrape4;

  /// No description provided for @transcriptSareeWornDrape5.
  ///
  /// In en, this message translates to:
  /// **'If there are pleats, follow the vertical grid lines.'**
  String get transcriptSareeWornDrape5;

  /// No description provided for @transcriptSareeRollDisplay1.
  ///
  /// In en, this message translates to:
  /// **'Roll the saree so the pallu and border face the camera.'**
  String get transcriptSareeRollDisplay1;

  /// No description provided for @transcriptSareeRollDisplay2.
  ///
  /// In en, this message translates to:
  /// **'Let the roll cover most of the frame.'**
  String get transcriptSareeRollDisplay2;

  /// No description provided for @transcriptSareeRollDisplay3.
  ///
  /// In en, this message translates to:
  /// **'Line the top border up with the top third of the grid.'**
  String get transcriptSareeRollDisplay3;

  /// No description provided for @transcriptSareeRollDisplay4.
  ///
  /// In en, this message translates to:
  /// **'Use soft daylight so the colour stays true.'**
  String get transcriptSareeRollDisplay4;

  /// No description provided for @transcriptCushionFlatLay1.
  ///
  /// In en, this message translates to:
  /// **'Lay the cushion cover flat on a plain surface.'**
  String get transcriptCushionFlatLay1;

  /// No description provided for @transcriptCushionFlatLay2.
  ///
  /// In en, this message translates to:
  /// **'Smooth it out but leave the natural texture visible.'**
  String get transcriptCushionFlatLay2;

  /// No description provided for @transcriptCushionFlatLay3.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone directly above, not at an angle.'**
  String get transcriptCushionFlatLay3;

  /// No description provided for @transcriptCushionFlatLay4.
  ///
  /// In en, this message translates to:
  /// **'Keep the edges straight along the grid.'**
  String get transcriptCushionFlatLay4;

  /// No description provided for @transcriptCushionStackedPair1.
  ///
  /// In en, this message translates to:
  /// **'Stack two covers so the buyer can see the thickness.'**
  String get transcriptCushionStackedPair1;

  /// No description provided for @transcriptCushionStackedPair2.
  ///
  /// In en, this message translates to:
  /// **'Keep the stacked edges facing the camera.'**
  String get transcriptCushionStackedPair2;

  /// No description provided for @transcriptCushionStackedPair3.
  ///
  /// In en, this message translates to:
  /// **'Use side light so each layer casts a soft shadow.'**
  String get transcriptCushionStackedPair3;

  /// No description provided for @transcriptCushionPropped1.
  ///
  /// In en, this message translates to:
  /// **'Placing the cushion on a chair shows its real size.'**
  String get transcriptCushionPropped1;

  /// No description provided for @transcriptCushionPropped2.
  ///
  /// In en, this message translates to:
  /// **'Choose a seat that does not compete with the pattern.'**
  String get transcriptCushionPropped2;

  /// No description provided for @transcriptCushionPropped3.
  ///
  /// In en, this message translates to:
  /// **'Shoot at eye level, not from above.'**
  String get transcriptCushionPropped3;

  /// No description provided for @transcriptCushionCornerTuck1.
  ///
  /// In en, this message translates to:
  /// **'The corner shows your stitching most clearly.'**
  String get transcriptCushionCornerTuck1;

  /// No description provided for @transcriptCushionCornerTuck2.
  ///
  /// In en, this message translates to:
  /// **'Move close until the corner fills the small frame.'**
  String get transcriptCushionCornerTuck2;

  /// No description provided for @transcriptCushionCornerTuck3.
  ///
  /// In en, this message translates to:
  /// **'Tap the screen on the stitching to focus.'**
  String get transcriptCushionCornerTuck3;

  /// No description provided for @transcriptShawlDrapedShoulder1.
  ///
  /// In en, this message translates to:
  /// **'Draping the shawl on a shoulder shows how heavy it is.'**
  String get transcriptShawlDrapedShoulder1;

  /// No description provided for @transcriptShawlDrapedShoulder2.
  ///
  /// In en, this message translates to:
  /// **'Let one end hang lower than the other.'**
  String get transcriptShawlDrapedShoulder2;

  /// No description provided for @transcriptShawlDrapedShoulder3.
  ///
  /// In en, this message translates to:
  /// **'Do not pin it — let the fabric fall on its own.'**
  String get transcriptShawlDrapedShoulder3;

  /// No description provided for @transcriptShawlFoldedStack1.
  ///
  /// In en, this message translates to:
  /// **'Stack the shawl neatly with the folds visible.'**
  String get transcriptShawlFoldedStack1;

  /// No description provided for @transcriptShawlFoldedStack2.
  ///
  /// In en, this message translates to:
  /// **'Keep the folds parallel to the horizontal lines.'**
  String get transcriptShawlFoldedStack2;

  /// No description provided for @transcriptShawlFoldedStack3.
  ///
  /// In en, this message translates to:
  /// **'Make sure the edge of the shawl is visible for thickness.'**
  String get transcriptShawlFoldedStack3;

  /// No description provided for @transcriptShawlFoldedStack4.
  ///
  /// In en, this message translates to:
  /// **'Use side lighting so each fold has depth.'**
  String get transcriptShawlFoldedStack4;

  /// No description provided for @transcriptShawlHungFlat1.
  ///
  /// In en, this message translates to:
  /// **'Hanging the shawl flat shows the whole design at once.'**
  String get transcriptShawlHungFlat1;

  /// No description provided for @transcriptShawlHungFlat2.
  ///
  /// In en, this message translates to:
  /// **'Pin both top corners so it does not sag in the middle.'**
  String get transcriptShawlHungFlat2;

  /// No description provided for @transcriptShawlHungFlat3.
  ///
  /// In en, this message translates to:
  /// **'Stand straight in front, not to one side.'**
  String get transcriptShawlHungFlat3;

  /// No description provided for @transcriptShawlCornerTuck1.
  ///
  /// In en, this message translates to:
  /// **'A close-up of the corner shows the weave and the border together.'**
  String get transcriptShawlCornerTuck1;

  /// No description provided for @transcriptShawlCornerTuck2.
  ///
  /// In en, this message translates to:
  /// **'Fold one corner back so both sides are visible.'**
  String get transcriptShawlCornerTuck2;

  /// No description provided for @transcriptShawlCornerTuck3.
  ///
  /// In en, this message translates to:
  /// **'Move close until the weave fills the frame.'**
  String get transcriptShawlCornerTuck3;

  /// No description provided for @transcriptStoleNeckWrap1.
  ///
  /// In en, this message translates to:
  /// **'A worn shot answers the most common question — how big is it?'**
  String get transcriptStoleNeckWrap1;

  /// No description provided for @transcriptStoleNeckWrap2.
  ///
  /// In en, this message translates to:
  /// **'Wrap it once around the neck and let both ends hang.'**
  String get transcriptStoleNeckWrap2;

  /// No description provided for @transcriptStoleNeckWrap3.
  ///
  /// In en, this message translates to:
  /// **'Shoot from the chest up so the ends stay in frame.'**
  String get transcriptStoleNeckWrap3;

  /// No description provided for @transcriptStoleFlatSpread1.
  ///
  /// In en, this message translates to:
  /// **'Spread the stole out so its full length is visible.'**
  String get transcriptStoleFlatSpread1;

  /// No description provided for @transcriptStoleFlatSpread2.
  ///
  /// In en, this message translates to:
  /// **'Leave the natural creases — they show what the fabric is like.'**
  String get transcriptStoleFlatSpread2;

  /// No description provided for @transcriptStoleFlatSpread3.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone directly above the middle.'**
  String get transcriptStoleFlatSpread3;

  /// No description provided for @transcriptStoleLooseKnot1.
  ///
  /// In en, this message translates to:
  /// **'A loose knot shows how soft and light the stole is.'**
  String get transcriptStoleLooseKnot1;

  /// No description provided for @transcriptStoleLooseKnot2.
  ///
  /// In en, this message translates to:
  /// **'Tie it loosely — never pull it tight.'**
  String get transcriptStoleLooseKnot2;

  /// No description provided for @transcriptStoleLooseKnot3.
  ///
  /// In en, this message translates to:
  /// **'Keep the knot in the centre of the frame.'**
  String get transcriptStoleLooseKnot3;

  /// No description provided for @transcriptStoleRolledCoil1.
  ///
  /// In en, this message translates to:
  /// **'Rolling the stole into a coil shows the edge and the thickness.'**
  String get transcriptStoleRolledCoil1;

  /// No description provided for @transcriptStoleRolledCoil2.
  ///
  /// In en, this message translates to:
  /// **'Roll it loosely so the layers stay separate.'**
  String get transcriptStoleRolledCoil2;

  /// No description provided for @transcriptStoleRolledCoil3.
  ///
  /// In en, this message translates to:
  /// **'Shoot straight down onto the coil.'**
  String get transcriptStoleRolledCoil3;

  /// No description provided for @guideSareeFullDisplay1.
  ///
  /// In en, this message translates to:
  /// **'The saree covers most of the frame.'**
  String get guideSareeFullDisplay1;

  /// No description provided for @guideSareeFullDisplay2.
  ///
  /// In en, this message translates to:
  /// **'The top border aligns with the top third of the grid.'**
  String get guideSareeFullDisplay2;

  /// No description provided for @guideSareeFullDisplay3.
  ///
  /// In en, this message translates to:
  /// **'When draped, pleats align with the vertical grid.'**
  String get guideSareeFullDisplay3;

  /// No description provided for @guideSareeTextureWeave1.
  ///
  /// In en, this message translates to:
  /// **'The saree fills the frame.'**
  String get guideSareeTextureWeave1;

  /// No description provided for @guideSareeTextureWeave2.
  ///
  /// In en, this message translates to:
  /// **'The texture stays in the centre.'**
  String get guideSareeTextureWeave2;

  /// No description provided for @guideSareeTextureWeave3.
  ///
  /// In en, this message translates to:
  /// **'Use soft light.'**
  String get guideSareeTextureWeave3;

  /// No description provided for @guideSareeTextureWeave4.
  ///
  /// In en, this message translates to:
  /// **'Avoid harsh reflections.'**
  String get guideSareeTextureWeave4;

  /// No description provided for @guideSareeEmbroideryBorder1.
  ///
  /// In en, this message translates to:
  /// **'The embroidery stays inside the frame.'**
  String get guideSareeEmbroideryBorder1;

  /// No description provided for @guideSareeEmbroideryBorder2.
  ///
  /// In en, this message translates to:
  /// **'Use side lighting.'**
  String get guideSareeEmbroideryBorder2;

  /// No description provided for @guideSareeEmbroideryBorder3.
  ///
  /// In en, this message translates to:
  /// **'Keep the detail sharp and well-lit.'**
  String get guideSareeEmbroideryBorder3;

  /// No description provided for @guideCushionTextureWeave1.
  ///
  /// In en, this message translates to:
  /// **'The weave fills the frame.'**
  String get guideCushionTextureWeave1;

  /// No description provided for @guideCushionTextureWeave2.
  ///
  /// In en, this message translates to:
  /// **'The texture stays in the centre.'**
  String get guideCushionTextureWeave2;

  /// No description provided for @guideShawlFullDesign1.
  ///
  /// In en, this message translates to:
  /// **'Hanging the shawl flat shows the whole design at once.'**
  String get guideShawlFullDesign1;

  /// No description provided for @guideShawlFullDesign2.
  ///
  /// In en, this message translates to:
  /// **'Pin both top corners so it does not sag in the middle.'**
  String get guideShawlFullDesign2;

  /// No description provided for @guideShawlTextureWeave1.
  ///
  /// In en, this message translates to:
  /// **'The weave fills the frame.'**
  String get guideShawlTextureWeave1;

  /// No description provided for @guideShawlTextureWeave2.
  ///
  /// In en, this message translates to:
  /// **'The texture stays in the centre.'**
  String get guideShawlTextureWeave2;

  /// No description provided for @guideStoleFullLength1.
  ///
  /// In en, this message translates to:
  /// **'Spread the stole out so its full length is visible.'**
  String get guideStoleFullLength1;

  /// No description provided for @guideStoleFullLength2.
  ///
  /// In en, this message translates to:
  /// **'Leave the natural creases — they show what the fabric is like.'**
  String get guideStoleFullLength2;

  /// No description provided for @guideStoleTextureWeave1.
  ///
  /// In en, this message translates to:
  /// **'The weave fills the frame.'**
  String get guideStoleTextureWeave1;

  /// No description provided for @guideStoleTextureWeave2.
  ///
  /// In en, this message translates to:
  /// **'The texture stays in the centre.'**
  String get guideStoleTextureWeave2;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password.'**
  String get authInvalidCredentials;

  /// No description provided for @authUserAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'That username is already taken.'**
  String get authUserAlreadyRegistered;

  /// No description provided for @authEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email, then try again.'**
  String get authEmailNotConfirmed;

  /// No description provided for @authGeneric.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in. Try again.'**
  String get authGeneric;

  /// No description provided for @languageAssamese.
  ///
  /// In en, this message translates to:
  /// **'Assamese'**
  String get languageAssamese;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @guideSareeDrapedLook1.
  ///
  /// In en, this message translates to:
  /// **'Let the fabric fall naturally.'**
  String get guideSareeDrapedLook1;

  /// No description provided for @guideSareeDrapedLook2.
  ///
  /// In en, this message translates to:
  /// **'Folds follow the diagonal.'**
  String get guideSareeDrapedLook2;

  /// No description provided for @guideSareeDrapedLook3.
  ///
  /// In en, this message translates to:
  /// **'Use side lighting.'**
  String get guideSareeDrapedLook3;

  /// No description provided for @guideSareeEmbroideryBorder4.
  ///
  /// In en, this message translates to:
  /// **'Use a contrast background.'**
  String get guideSareeEmbroideryBorder4;

  /// No description provided for @guideSareeFoldedStack1.
  ///
  /// In en, this message translates to:
  /// **'Folds stay parallel to the horizontal lines.'**
  String get guideSareeFoldedStack1;

  /// No description provided for @guideSareeFoldedStack2.
  ///
  /// In en, this message translates to:
  /// **'Use side lighting.'**
  String get guideSareeFoldedStack2;

  /// No description provided for @guideSareeFoldedStack3.
  ///
  /// In en, this message translates to:
  /// **'Keep the edge visible.'**
  String get guideSareeFoldedStack3;

  /// No description provided for @guideCushionFullCover1.
  ///
  /// In en, this message translates to:
  /// **'Lay the cover flat so the full pattern is visible.'**
  String get guideCushionFullCover1;

  /// No description provided for @guideCushionFullCover2.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone directly above, not at an angle.'**
  String get guideCushionFullCover2;

  /// No description provided for @guideCushionFullCover3.
  ///
  /// In en, this message translates to:
  /// **'Keep the edges straight along the grid.'**
  String get guideCushionFullCover3;

  /// No description provided for @guideCushionTextureWeave3.
  ///
  /// In en, this message translates to:
  /// **'Use soft light.'**
  String get guideCushionTextureWeave3;

  /// No description provided for @guideCushionTextureWeave4.
  ///
  /// In en, this message translates to:
  /// **'Avoid harsh reflections.'**
  String get guideCushionTextureWeave4;

  /// No description provided for @guideCushionStackedThickness1.
  ///
  /// In en, this message translates to:
  /// **'Stack two covers so the buyer can see the thickness.'**
  String get guideCushionStackedThickness1;

  /// No description provided for @guideCushionStackedThickness2.
  ///
  /// In en, this message translates to:
  /// **'Keep the stacked edges facing the camera.'**
  String get guideCushionStackedThickness2;

  /// No description provided for @guideCushionStackedThickness3.
  ///
  /// In en, this message translates to:
  /// **'Use side light so each layer casts a soft shadow.'**
  String get guideCushionStackedThickness3;

  /// No description provided for @guideCushionCornerStitching1.
  ///
  /// In en, this message translates to:
  /// **'The corner shows stitching most clearly.'**
  String get guideCushionCornerStitching1;

  /// No description provided for @guideCushionCornerStitching2.
  ///
  /// In en, this message translates to:
  /// **'Move close until the corner fills the small frame.'**
  String get guideCushionCornerStitching2;

  /// No description provided for @guideCushionCornerStitching3.
  ///
  /// In en, this message translates to:
  /// **'Keep the stitching sharp and well-lit.'**
  String get guideCushionCornerStitching3;

  /// No description provided for @guideCushionInUse1.
  ///
  /// In en, this message translates to:
  /// **'Placing the cushion on a chair shows its real size.'**
  String get guideCushionInUse1;

  /// No description provided for @guideCushionInUse2.
  ///
  /// In en, this message translates to:
  /// **'Choose a seat that does not compete with the pattern.'**
  String get guideCushionInUse2;

  /// No description provided for @guideCushionInUse3.
  ///
  /// In en, this message translates to:
  /// **'Shoot at eye level, not from above.'**
  String get guideCushionInUse3;

  /// No description provided for @guideShawlFullDesign3.
  ///
  /// In en, this message translates to:
  /// **'Stand straight in front, not to one side.'**
  String get guideShawlFullDesign3;

  /// No description provided for @guideShawlTextureWeave3.
  ///
  /// In en, this message translates to:
  /// **'Use soft light.'**
  String get guideShawlTextureWeave3;

  /// No description provided for @guideShawlTextureWeave4.
  ///
  /// In en, this message translates to:
  /// **'Avoid harsh reflections.'**
  String get guideShawlTextureWeave4;

  /// No description provided for @guideShawlDrapedLook1.
  ///
  /// In en, this message translates to:
  /// **'Draping the shawl on a shoulder shows how heavy it is.'**
  String get guideShawlDrapedLook1;

  /// No description provided for @guideShawlDrapedLook2.
  ///
  /// In en, this message translates to:
  /// **'Let one end hang lower than the other.'**
  String get guideShawlDrapedLook2;

  /// No description provided for @guideShawlDrapedLook3.
  ///
  /// In en, this message translates to:
  /// **'Do not pin it — let the fabric fall on its own.'**
  String get guideShawlDrapedLook3;

  /// No description provided for @guideShawlBorderCorner1.
  ///
  /// In en, this message translates to:
  /// **'A close-up of the corner shows the weave and the border together.'**
  String get guideShawlBorderCorner1;

  /// No description provided for @guideShawlBorderCorner2.
  ///
  /// In en, this message translates to:
  /// **'Fold one corner back so both sides are visible.'**
  String get guideShawlBorderCorner2;

  /// No description provided for @guideShawlBorderCorner3.
  ///
  /// In en, this message translates to:
  /// **'Move close until the weave fills the frame.'**
  String get guideShawlBorderCorner3;

  /// No description provided for @guideShawlStackDisplay1.
  ///
  /// In en, this message translates to:
  /// **'Stack the shawl neatly with the folds visible.'**
  String get guideShawlStackDisplay1;

  /// No description provided for @guideShawlStackDisplay2.
  ///
  /// In en, this message translates to:
  /// **'Keep the folds parallel to the horizontal lines.'**
  String get guideShawlStackDisplay2;

  /// No description provided for @guideShawlStackDisplay3.
  ///
  /// In en, this message translates to:
  /// **'Use side lighting so each fold has depth.'**
  String get guideShawlStackDisplay3;

  /// No description provided for @guideStoleFullLength3.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone directly above the middle.'**
  String get guideStoleFullLength3;

  /// No description provided for @guideStoleTextureWeave3.
  ///
  /// In en, this message translates to:
  /// **'Use soft light.'**
  String get guideStoleTextureWeave3;

  /// No description provided for @guideStoleTextureWeave4.
  ///
  /// In en, this message translates to:
  /// **'Avoid harsh reflections.'**
  String get guideStoleTextureWeave4;

  /// No description provided for @guideStoleWornNeckWrap1.
  ///
  /// In en, this message translates to:
  /// **'A worn shot answers how big the stole is.'**
  String get guideStoleWornNeckWrap1;

  /// No description provided for @guideStoleWornNeckWrap2.
  ///
  /// In en, this message translates to:
  /// **'Wrap it once around the neck and let both ends hang.'**
  String get guideStoleWornNeckWrap2;

  /// No description provided for @guideStoleWornNeckWrap3.
  ///
  /// In en, this message translates to:
  /// **'Shoot from the chest up so the ends stay in frame.'**
  String get guideStoleWornNeckWrap3;

  /// No description provided for @guideStoleSoftnessKnot1.
  ///
  /// In en, this message translates to:
  /// **'A loose knot shows how soft and light the stole is.'**
  String get guideStoleSoftnessKnot1;

  /// No description provided for @guideStoleSoftnessKnot2.
  ///
  /// In en, this message translates to:
  /// **'Tie it loosely — never pull it tight.'**
  String get guideStoleSoftnessKnot2;

  /// No description provided for @guideStoleSoftnessKnot3.
  ///
  /// In en, this message translates to:
  /// **'Keep the knot in the centre of the frame.'**
  String get guideStoleSoftnessKnot3;

  /// No description provided for @guideStoleEdgeThickness1.
  ///
  /// In en, this message translates to:
  /// **'Rolling the stole into a coil shows the edge and the thickness.'**
  String get guideStoleEdgeThickness1;

  /// No description provided for @guideStoleEdgeThickness2.
  ///
  /// In en, this message translates to:
  /// **'Roll it loosely so the layers stay separate.'**
  String get guideStoleEdgeThickness2;

  /// No description provided for @guideStoleEdgeThickness3.
  ///
  /// In en, this message translates to:
  /// **'Shoot straight down onto the coil.'**
  String get guideStoleEdgeThickness3;
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
