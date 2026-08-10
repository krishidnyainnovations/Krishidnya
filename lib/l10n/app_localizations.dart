import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
    Locale('en'),
    Locale('hi'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Krishidnya'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your trusted farming companion'**
  String get appTagline;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Every season brings challenges'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Unpredictable weather, crop diseases, and rising costs make farming harder every day.'**
  String get onboardingPage1Subtitle;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Technology can help'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart insights and real-time data can turn uncertainty into informed decisions.'**
  String get onboardingPage2Subtitle;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'AI becomes your partner'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Detect diseases early, track your crops, and get personalized recommendations.'**
  String get onboardingPage3Subtitle;

  /// No description provided for @onboardingPage4Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Krishidnya'**
  String get onboardingPage4Title;

  /// No description provided for @onboardingPage4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your farm, understood. Let\'s grow together.'**
  String get onboardingPage4Subtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get register;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your farming journey'**
  String get loginSubtitle;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @alreadyHaveAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccountLogin;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get to know you'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us a little about yourself to personalize your experience'**
  String get createAccountSubtitle;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Help us understand your farm'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your location helps us provide accurate weather, crop advice, and local insights.'**
  String get locationPermissionSubtitle;

  /// No description provided for @locationPermissionSubtitleExtended.
  ///
  /// In en, this message translates to:
  /// **'Your location helps us provide accurate weather, crop advice, and local insights tailored to your region.'**
  String get locationPermissionSubtitleExtended;

  /// No description provided for @locationPermissionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow Location'**
  String get locationPermissionAllow;

  /// No description provided for @locationPermissionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get locationPermissionSkip;

  /// No description provided for @locationLoading.
  ///
  /// In en, this message translates to:
  /// **'Looking at your surroundings...'**
  String get locationLoading;

  /// No description provided for @locationFound.
  ///
  /// In en, this message translates to:
  /// **'We found your location'**
  String get locationFound;

  /// No description provided for @locationDetected.
  ///
  /// In en, this message translates to:
  /// **'Location detected'**
  String get locationDetected;

  /// No description provided for @almostReady.
  ///
  /// In en, this message translates to:
  /// **'Almost ready'**
  String get almostReady;

  /// No description provided for @almostReadySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re setting up your personalized farming dashboard'**
  String get almostReadySubtitle;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Your farm is now connected'**
  String get accountCreated;

  /// No description provided for @accountCreatedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Krishidnya. Let\'s begin your journey.'**
  String get accountCreatedSubtitle;

  /// No description provided for @enterDashboard.
  ///
  /// In en, this message translates to:
  /// **'Enter Dashboard'**
  String get enterDashboard;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @dashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good {timeOfDay}, {name}'**
  String dashboardGreeting(String timeOfDay, String name);

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'evening'**
  String get evening;

  /// No description provided for @todaysWeather.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Weather'**
  String get todaysWeather;

  /// No description provided for @farmStatus.
  ///
  /// In en, this message translates to:
  /// **'Farm Status'**
  String get farmStatus;

  /// No description provided for @cropStage.
  ///
  /// In en, this message translates to:
  /// **'Crop Stage'**
  String get cropStage;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @preparingInsights.
  ///
  /// In en, this message translates to:
  /// **'Preparing today\'s farming insights...'**
  String get preparingInsights;

  /// No description provided for @checkingSky.
  ///
  /// In en, this message translates to:
  /// **'Looking at today\'s sky...'**
  String get checkingSky;

  /// No description provided for @checkingCropHealth.
  ///
  /// In en, this message translates to:
  /// **'Checking your crop\'s health...'**
  String get checkingCropHealth;

  /// No description provided for @loadingRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Loading recommendations...'**
  String get loadingRecommendations;

  /// No description provided for @cropsTracked.
  ///
  /// In en, this message translates to:
  /// **'{count} crops tracked'**
  String cropsTracked(int count);

  /// No description provided for @noCropsTracked.
  ///
  /// In en, this message translates to:
  /// **'No crops tracked yet'**
  String get noCropsTracked;

  /// No description provided for @addCropsHint.
  ///
  /// In en, this message translates to:
  /// **'Add crops in Analytics to track your farm'**
  String get addCropsHint;

  /// No description provided for @defaultFarmerName.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get defaultFarmerName;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get errorNetwork;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get retry;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @farm.
  ///
  /// In en, this message translates to:
  /// **'Farm'**
  String get farm;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @governmentSchemes.
  ///
  /// In en, this message translates to:
  /// **'Government Schemes'**
  String get governmentSchemes;

  /// No description provided for @schemesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Benefits designed for farmers like you'**
  String get schemesSubtitle;

  /// No description provided for @tapToViewForecast.
  ///
  /// In en, this message translates to:
  /// **'Tap to view forecast'**
  String get tapToViewForecast;

  /// No description provided for @cropRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Crop Recommendation'**
  String get cropRecommendation;

  /// No description provided for @cropRecommendationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered crop picks'**
  String get cropRecommendationSubtitle;

  /// No description provided for @scanCrop.
  ///
  /// In en, this message translates to:
  /// **'Scan Crop'**
  String get scanCrop;

  /// No description provided for @scanCropSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Detect diseases early'**
  String get scanCropSubtitle;

  /// No description provided for @marketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplace;

  /// No description provided for @marketplaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Buy, sell & rent'**
  String get marketplaceSubtitle;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @viewHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Crop & soil records'**
  String get viewHistorySubtitle;

  /// No description provided for @mandiPrices.
  ///
  /// In en, this message translates to:
  /// **'Mandi Prices'**
  String get mandiPrices;

  /// No description provided for @mandiPricesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily market rates'**
  String get mandiPricesSubtitle;

  /// No description provided for @analyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Farm expense tracker'**
  String get analyticsSubtitle;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validEmail;

  /// No description provided for @validMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit number'**
  String get validMobile;

  /// No description provided for @validMobileLogin.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit mobile number'**
  String get validMobileLogin;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNoMatch;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enterPassword;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Tejas Barguje'**
  String get fullNameHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get emailHint;

  /// No description provided for @mobileHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile number'**
  String get mobileHint;

  /// No description provided for @mobileHintLogin.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get mobileHintLogin;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @loginWithOtpInstead.
  ///
  /// In en, this message translates to:
  /// **'Login with OTP instead'**
  String get loginWithOtpInstead;

  /// No description provided for @loginWithPasswordInstead.
  ///
  /// In en, this message translates to:
  /// **'Login with password instead'**
  String get loginWithPasswordInstead;

  /// No description provided for @otpLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login with OTP'**
  String get otpLoginTitle;

  /// No description provided for @otpLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to receive a one-time password.'**
  String get otpLoginSubtitle;

  /// No description provided for @otpLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otpLabel;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyAndLogin.
  ///
  /// In en, this message translates to:
  /// **'Verify & Login'**
  String get verifyAndLogin;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to your mobile'**
  String get otpSent;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP'**
  String get enterOtp;

  /// No description provided for @enterValidMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number'**
  String get enterValidMobile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Krishidnya v1.0.0'**
  String get appVersion;

  /// No description provided for @logOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOutConfirmTitle;

  /// No description provided for @logOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logOutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @tellUsAboutFarm.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your farm'**
  String get tellUsAboutFarm;

  /// No description provided for @soilType.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get soilType;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get season;

  /// No description provided for @farmAreaAcres.
  ///
  /// In en, this message translates to:
  /// **'Farm Area (acres)'**
  String get farmAreaAcres;

  /// No description provided for @wateringMethod.
  ///
  /// In en, this message translates to:
  /// **'Watering Method'**
  String get wateringMethod;

  /// No description provided for @getTop4Crops.
  ///
  /// In en, this message translates to:
  /// **'Get Top 4 Crops'**
  String get getTop4Crops;

  /// No description provided for @topCropPicks.
  ///
  /// In en, this message translates to:
  /// **'Top Crop Picks'**
  String get topCropPicks;

  /// No description provided for @weatherAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Weather Analysis'**
  String get weatherAnalysis;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @expectedRain.
  ///
  /// In en, this message translates to:
  /// **'Expected Rain'**
  String get expectedRain;

  /// No description provided for @whyGrow.
  ///
  /// In en, this message translates to:
  /// **'Why grow'**
  String get whyGrow;

  /// No description provided for @waterRequired.
  ///
  /// In en, this message translates to:
  /// **'Water required'**
  String get waterRequired;

  /// No description provided for @daysToHarvest.
  ///
  /// In en, this message translates to:
  /// **'Days to harvest'**
  String get daysToHarvest;

  /// No description provided for @growingPeriod.
  ///
  /// In en, this message translates to:
  /// **'Growing period'**
  String get growingPeriod;

  /// No description provided for @expectedProfit.
  ///
  /// In en, this message translates to:
  /// **'Expected profit'**
  String get expectedProfit;

  /// No description provided for @scanYourCrop.
  ///
  /// In en, this message translates to:
  /// **'Scan your crop'**
  String get scanYourCrop;

  /// No description provided for @scanCropHelpText.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of affected leaves. Our AI detects diseases and suggests organic & chemical cures with exact dosages.'**
  String get scanCropHelpText;

  /// No description provided for @analyzingCropImage.
  ///
  /// In en, this message translates to:
  /// **'Analyzing crop image...'**
  String get analyzingCropImage;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @organicCureRecommended.
  ///
  /// In en, this message translates to:
  /// **'Organic Cure (Recommended)'**
  String get organicCureRecommended;

  /// No description provided for @chemicalCure.
  ///
  /// In en, this message translates to:
  /// **'Chemical Cure'**
  String get chemicalCure;

  /// No description provided for @recommendedProducts.
  ///
  /// In en, this message translates to:
  /// **'Recommended Products'**
  String get recommendedProducts;

  /// No description provided for @dosageLabel.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosageLabel;

  /// No description provided for @confidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {value}'**
  String confidenceLabel(String value);

  /// No description provided for @crop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get crop;

  /// No description provided for @stateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get stateLabel;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @fetchTodaysPrices.
  ///
  /// In en, this message translates to:
  /// **'Fetch Today\'s Prices'**
  String get fetchTodaysPrices;

  /// No description provided for @saveCropToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Save crop to favorites'**
  String get saveCropToFavorites;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @noPriceData.
  ///
  /// In en, this message translates to:
  /// **'No price data found for this crop and state.'**
  String get noPriceData;

  /// No description provided for @todaysMarketRates.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Market Rates'**
  String get todaysMarketRates;

  /// No description provided for @marketLabel.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get marketLabel;

  /// No description provided for @listItem.
  ///
  /// In en, this message translates to:
  /// **'List Item'**
  String get listItem;

  /// No description provided for @listItemTooltip.
  ///
  /// In en, this message translates to:
  /// **'List item'**
  String get listItemTooltip;

  /// No description provided for @noListingsYet.
  ///
  /// In en, this message translates to:
  /// **'No listings yet'**
  String get noListingsYet;

  /// No description provided for @marketplaceEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to list tractors, seeds, or livestock.'**
  String get marketplaceEmptySubtitle;

  /// No description provided for @listAnItem.
  ///
  /// In en, this message translates to:
  /// **'List an Item'**
  String get listAnItem;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @categoryHint.
  ///
  /// In en, this message translates to:
  /// **'Category (Machinery, Livestock, Seeds...)'**
  String get categoryHint;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @unitHint.
  ///
  /// In en, this message translates to:
  /// **'Unit (day, kg, piece)'**
  String get unitHint;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone'**
  String get contactPhone;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterNameAndPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter name and price'**
  String get enterNameAndPrice;

  /// No description provided for @itemListedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Item listed successfully!'**
  String get itemListedSuccess;

  /// No description provided for @contactSeller.
  ///
  /// In en, this message translates to:
  /// **'Contact Seller'**
  String get contactSeller;

  /// No description provided for @noContactAvailable.
  ///
  /// In en, this message translates to:
  /// **'No contact available'**
  String get noContactAvailable;

  /// No description provided for @couldNotOpenDialer.
  ///
  /// In en, this message translates to:
  /// **'Could not open phone dialer'**
  String get couldNotOpenDialer;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @farmHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your farm history'**
  String get farmHistoryTitle;

  /// No description provided for @farmHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Past crop scans, soil tests, and recommendations appear here.'**
  String get farmHistorySubtitle;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @noHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan crops or get recommendations to build your history.'**
  String get noHistorySubtitle;

  /// No description provided for @farmAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Farm Analytics'**
  String get farmAnalytics;

  /// No description provided for @syncToCloud.
  ///
  /// In en, this message translates to:
  /// **'Sync to cloud'**
  String get syncToCloud;

  /// No description provided for @farmDataSynced.
  ///
  /// In en, this message translates to:
  /// **'Farm data synced'**
  String get farmDataSynced;

  /// No description provided for @addCrop.
  ///
  /// In en, this message translates to:
  /// **'Add Crop'**
  String get addCrop;

  /// No description provided for @digitalFarmNotebook.
  ///
  /// In en, this message translates to:
  /// **'Your digital farm notebook'**
  String get digitalFarmNotebook;

  /// No description provided for @digitalFarmNotebookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track sowing, fertilizers, labour, spraying, and harvest costs.'**
  String get digitalFarmNotebookSubtitle;

  /// No description provided for @digitalFarmNotebookSubtitleLong.
  ///
  /// In en, this message translates to:
  /// **'Track sowing, fertilizers, labour, spraying, and harvest costs. Auto-calculate profit and margins per crop.'**
  String get digitalFarmNotebookSubtitleLong;

  /// No description provided for @monthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly Income'**
  String get monthlyIncome;

  /// No description provided for @monthlyIncomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This month from harvested crops'**
  String get monthlyIncomeSubtitle;

  /// No description provided for @cropName.
  ///
  /// In en, this message translates to:
  /// **'Crop Name'**
  String get cropName;

  /// No description provided for @areaAcres.
  ///
  /// In en, this message translates to:
  /// **'Area (acres)'**
  String get areaAcres;

  /// No description provided for @sowingDate.
  ///
  /// In en, this message translates to:
  /// **'Sowing Date (YYYY-MM-DD)'**
  String get sowingDate;

  /// No description provided for @enterCropName.
  ///
  /// In en, this message translates to:
  /// **'Enter crop name'**
  String get enterCropName;

  /// No description provided for @acresSown.
  ///
  /// In en, this message translates to:
  /// **'{area} acres · Sown {date}'**
  String acresSown(String area, String date);

  /// No description provided for @profitLabel.
  ///
  /// In en, this message translates to:
  /// **'Profit ₹{amount}'**
  String profitLabel(String amount);

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @expenseType.
  ///
  /// In en, this message translates to:
  /// **'Type (Fertilizer, Labour, Spray, Cultivation)'**
  String get expenseType;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount (₹)'**
  String get amountLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @saveExpense.
  ///
  /// In en, this message translates to:
  /// **'Save Expense'**
  String get saveExpense;

  /// No description provided for @recordHarvestSale.
  ///
  /// In en, this message translates to:
  /// **'Record Harvest & Sale'**
  String get recordHarvestSale;

  /// No description provided for @totalSellingValue.
  ///
  /// In en, this message translates to:
  /// **'Total Selling Value (₹)'**
  String get totalSellingValue;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// No description provided for @sellingValue.
  ///
  /// In en, this message translates to:
  /// **'Selling Value'**
  String get sellingValue;

  /// No description provided for @profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get profit;

  /// No description provided for @margin.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get margin;

  /// No description provided for @expenseBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Expense Breakdown'**
  String get expenseBreakdown;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded yet. Tap Add Expense to log costs.'**
  String get noExpensesYet;

  /// No description provided for @searchSchemes.
  ///
  /// In en, this message translates to:
  /// **'Search schemes'**
  String get searchSchemes;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @couldNotLoadSchemes.
  ///
  /// In en, this message translates to:
  /// **'Could not load schemes: {error}'**
  String couldNotLoadSchemes(String error);

  /// No description provided for @noSchemesMatch.
  ///
  /// In en, this message translates to:
  /// **'No schemes match your search'**
  String get noSchemesMatch;

  /// No description provided for @applyForTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply for {title}'**
  String applyForTitle(String title);

  /// No description provided for @teamFillForm.
  ///
  /// In en, this message translates to:
  /// **'Our team will fill the form for you'**
  String get teamFillForm;

  /// No description provided for @villageName.
  ///
  /// In en, this message translates to:
  /// **'Village Name'**
  String get villageName;

  /// No description provided for @submitApplication.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get submitApplication;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @applicationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Application submitted! Our team will contact you.'**
  String get applicationSubmitted;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @schemeDetails.
  ///
  /// In en, this message translates to:
  /// **'Scheme Details'**
  String get schemeDetails;

  /// No description provided for @couldNotLoadScheme.
  ///
  /// In en, this message translates to:
  /// **'Could not load scheme: {error}'**
  String couldNotLoadScheme(String error);

  /// No description provided for @eligibility.
  ///
  /// In en, this message translates to:
  /// **'Eligibility'**
  String get eligibility;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits;

  /// No description provided for @howToApply.
  ///
  /// In en, this message translates to:
  /// **'How to Apply'**
  String get howToApply;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get applyNow;

  /// No description provided for @weatherForecast.
  ///
  /// In en, this message translates to:
  /// **'Weather Forecast'**
  String get weatherForecast;

  /// No description provided for @updateLocationInProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Location in Profile'**
  String get updateLocationInProfile;

  /// No description provided for @extendedForecast.
  ///
  /// In en, this message translates to:
  /// **'15-Day Extended Forecast'**
  String get extendedForecast;

  /// No description provided for @forecastLoadingHint.
  ///
  /// In en, this message translates to:
  /// **'Forecast data is loading from your location. If this persists, ensure your profile has GPS coordinates set.'**
  String get forecastLoadingHint;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Weather alerts, scheme updates, and community activity appear here.'**
  String get notificationsEmptySubtitle;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get allCaughtUp;

  /// No description provided for @noNewNotifications.
  ///
  /// In en, this message translates to:
  /// **'You have no new notifications.'**
  String get noNewNotifications;

  /// No description provided for @nearbyFarmers.
  ///
  /// In en, this message translates to:
  /// **'Nearby Farmers'**
  String get nearbyFarmers;

  /// No description provided for @nearbyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Nearby farmers unavailable'**
  String get nearbyUnavailable;

  /// No description provided for @noFarmersNearby.
  ///
  /// In en, this message translates to:
  /// **'No farmers nearby'**
  String get noFarmersNearby;

  /// No description provided for @updateLocationNearby.
  ///
  /// In en, this message translates to:
  /// **'Update your location in profile to find farmers around you.'**
  String get updateLocationNearby;

  /// No description provided for @kmAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String kmAway(String distance);

  /// No description provided for @harvestShort.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get harvestShort;
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
