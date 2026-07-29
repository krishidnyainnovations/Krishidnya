// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Krishidnya';

  @override
  String get appTagline => 'Your trusted farming companion';

  @override
  String get onboardingPage1Title => 'Every season brings challenges';

  @override
  String get onboardingPage1Subtitle =>
      'Unpredictable weather, crop diseases, and rising costs make farming harder every day.';

  @override
  String get onboardingPage2Title => 'Technology can help';

  @override
  String get onboardingPage2Subtitle =>
      'Smart insights and real-time data can turn uncertainty into informed decisions.';

  @override
  String get onboardingPage3Title => 'AI becomes your partner';

  @override
  String get onboardingPage3Subtitle =>
      'Detect diseases early, track your crops, and get personalized recommendations.';

  @override
  String get onboardingPage4Title => 'Welcome to Krishidnya';

  @override
  String get onboardingPage4Subtitle =>
      'Your farm, understood. Let\'s grow together.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get login => 'Login';

  @override
  String get register => 'Create Account';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue your farming journey';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get createAccountTitle => 'Let\'s get to know you';

  @override
  String get createAccountSubtitle =>
      'Tell us a little about yourself to personalize your experience';

  @override
  String get locationPermissionTitle => 'Help us understand your farm';

  @override
  String get locationPermissionSubtitle =>
      'Your location helps us provide accurate weather, crop advice, and local insights.';

  @override
  String get locationPermissionAllow => 'Allow Location';

  @override
  String get locationPermissionSkip => 'Skip for now';

  @override
  String get locationLoading => 'Looking at your surroundings...';

  @override
  String get locationFound => 'We found your location';

  @override
  String get almostReady => 'Almost ready';

  @override
  String get almostReadySubtitle =>
      'We\'re setting up your personalized farming dashboard';

  @override
  String get accountCreated => 'Your farm is now connected';

  @override
  String get accountCreatedSubtitle =>
      'Welcome to Krishidnya. Let\'s begin your journey.';

  @override
  String get continueLabel => 'Continue';

  @override
  String dashboardGreeting(String timeOfDay, String name) {
    return 'Good $timeOfDay, $name';
  }

  @override
  String get morning => 'morning';

  @override
  String get afternoon => 'afternoon';

  @override
  String get evening => 'evening';

  @override
  String get todaysWeather => 'Today\'s Weather';

  @override
  String get farmStatus => 'Farm Status';

  @override
  String get cropStage => 'Crop Stage';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get preparingInsights => 'Preparing today\'s farming insights...';

  @override
  String get checkingSky => 'Looking at today\'s sky...';

  @override
  String get checkingCropHealth => 'Checking your crop\'s health...';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network.';

  @override
  String get retry => 'Try Again';

  @override
  String get home => 'Home';

  @override
  String get farm => 'Farm';

  @override
  String get scan => 'Scan';

  @override
  String get analytics => 'Analytics';

  @override
  String get profile => 'Profile';
}
