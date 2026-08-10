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
  String get alreadyHaveAccountLogin => 'Already have an account? Login';

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
  String get locationPermissionSubtitleExtended =>
      'Your location helps us provide accurate weather, crop advice, and local insights tailored to your region.';

  @override
  String get locationPermissionAllow => 'Allow Location';

  @override
  String get locationPermissionSkip => 'Skip for now';

  @override
  String get locationLoading => 'Looking at your surroundings...';

  @override
  String get locationFound => 'We found your location';

  @override
  String get locationDetected => 'Location detected';

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
  String get enterDashboard => 'Enter Dashboard';

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
  String get loadingRecommendations => 'Loading recommendations...';

  @override
  String cropsTracked(int count) {
    return '$count crops tracked';
  }

  @override
  String get noCropsTracked => 'No crops tracked yet';

  @override
  String get addCropsHint => 'Add crops in Analytics to track your farm';

  @override
  String get defaultFarmerName => 'Farmer';

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

  @override
  String get chat => 'Chat';

  @override
  String get community => 'Community';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get governmentSchemes => 'Government Schemes';

  @override
  String get schemesSubtitle => 'Benefits designed for farmers like you';

  @override
  String get tapToViewForecast => 'Tap to view forecast';

  @override
  String get cropRecommendation => 'Crop Recommendation';

  @override
  String get cropRecommendationSubtitle => 'AI-powered crop picks';

  @override
  String get scanCrop => 'Scan Crop';

  @override
  String get scanCropSubtitle => 'Detect diseases early';

  @override
  String get marketplace => 'Marketplace';

  @override
  String get marketplaceSubtitle => 'Buy, sell & rent';

  @override
  String get viewHistory => 'View History';

  @override
  String get viewHistorySubtitle => 'Crop & soil records';

  @override
  String get mandiPrices => 'Mandi Prices';

  @override
  String get mandiPricesSubtitle => 'Daily market rates';

  @override
  String get analyticsSubtitle => 'Farm expense tracker';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get validEmail => 'Please enter a valid email';

  @override
  String get validMobile => 'Enter a valid 10-digit number';

  @override
  String get validMobileLogin => 'Please enter a valid 10-digit mobile number';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get passwordsNoMatch => 'Passwords do not match';

  @override
  String get enterPassword => 'Please enter your password';

  @override
  String get fullNameHint => 'e.g. Tejas Barguje';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get mobileHint => '10-digit mobile number';

  @override
  String get mobileHintLogin => 'Enter your mobile number';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get loginWithOtpInstead => 'Login with OTP instead';

  @override
  String get loginWithPasswordInstead => 'Login with password instead';

  @override
  String get otpLoginTitle => 'Login with OTP';

  @override
  String get otpLoginSubtitle =>
      'Enter your mobile number to receive a one-time password.';

  @override
  String get otpLabel => 'OTP';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyAndLogin => 'Verify & Login';

  @override
  String get otpSent => 'OTP sent to your mobile';

  @override
  String get enterOtp => 'Enter the OTP';

  @override
  String get enterValidMobile => 'Enter a valid mobile number';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get appLanguage => 'App Language';

  @override
  String get account => 'Account';

  @override
  String get logOut => 'Log Out';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get legal => 'Legal';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'Krishidnya v1.0.0';

  @override
  String get logOutConfirmTitle => 'Log Out';

  @override
  String get logOutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get tellUsAboutFarm => 'Tell us about your farm';

  @override
  String get soilType => 'Soil Type';

  @override
  String get season => 'Season';

  @override
  String get farmAreaAcres => 'Farm Area (acres)';

  @override
  String get wateringMethod => 'Watering Method';

  @override
  String get getTop4Crops => 'Get Top 4 Crops';

  @override
  String get topCropPicks => 'Top Crop Picks';

  @override
  String get weatherAnalysis => 'Weather Analysis';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String get expectedRain => 'Expected Rain';

  @override
  String get whyGrow => 'Why grow';

  @override
  String get waterRequired => 'Water required';

  @override
  String get daysToHarvest => 'Days to harvest';

  @override
  String get growingPeriod => 'Growing period';

  @override
  String get expectedProfit => 'Expected profit';

  @override
  String get scanYourCrop => 'Scan your crop';

  @override
  String get scanCropHelpText =>
      'Take a photo of affected leaves. Our AI detects diseases and suggests organic & chemical cures with exact dosages.';

  @override
  String get analyzingCropImage => 'Analyzing crop image...';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get organicCureRecommended => 'Organic Cure (Recommended)';

  @override
  String get chemicalCure => 'Chemical Cure';

  @override
  String get recommendedProducts => 'Recommended Products';

  @override
  String get dosageLabel => 'Dosage';

  @override
  String confidenceLabel(String value) {
    return 'Confidence: $value';
  }

  @override
  String get crop => 'Crop';

  @override
  String get stateLabel => 'State';

  @override
  String get favorites => 'Favorites';

  @override
  String get recent => 'Recent';

  @override
  String get fetchTodaysPrices => 'Fetch Today\'s Prices';

  @override
  String get saveCropToFavorites => 'Save crop to favorites';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get noPriceData => 'No price data found for this crop and state.';

  @override
  String get todaysMarketRates => 'Today\'s Market Rates';

  @override
  String get marketLabel => 'Market';

  @override
  String get listItem => 'List Item';

  @override
  String get listItemTooltip => 'List item';

  @override
  String get noListingsYet => 'No listings yet';

  @override
  String get marketplaceEmptySubtitle =>
      'Be the first to list tractors, seeds, or livestock.';

  @override
  String get listAnItem => 'List an Item';

  @override
  String get rent => 'Rent';

  @override
  String get sell => 'Sell';

  @override
  String get itemName => 'Item Name';

  @override
  String get categoryHint => 'Category (Machinery, Livestock, Seeds...)';

  @override
  String get price => 'Price';

  @override
  String get unitHint => 'Unit (day, kg, piece)';

  @override
  String get contactPhone => 'Contact Phone';

  @override
  String get description => 'Description';

  @override
  String get enterNameAndPrice => 'Enter name and price';

  @override
  String get itemListedSuccess => 'Item listed successfully!';

  @override
  String get contactSeller => 'Contact Seller';

  @override
  String get noContactAvailable => 'No contact available';

  @override
  String get couldNotOpenDialer => 'Could not open phone dialer';

  @override
  String get history => 'History';

  @override
  String get export => 'Export';

  @override
  String get farmHistoryTitle => 'Your farm history';

  @override
  String get farmHistorySubtitle =>
      'Past crop scans, soil tests, and recommendations appear here.';

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String get noHistorySubtitle =>
      'Scan crops or get recommendations to build your history.';

  @override
  String get farmAnalytics => 'Farm Analytics';

  @override
  String get syncToCloud => 'Sync to cloud';

  @override
  String get farmDataSynced => 'Farm data synced';

  @override
  String get addCrop => 'Add Crop';

  @override
  String get digitalFarmNotebook => 'Your digital farm notebook';

  @override
  String get digitalFarmNotebookSubtitle =>
      'Track sowing, fertilizers, labour, spraying, and harvest costs.';

  @override
  String get digitalFarmNotebookSubtitleLong =>
      'Track sowing, fertilizers, labour, spraying, and harvest costs. Auto-calculate profit and margins per crop.';

  @override
  String get monthlyIncome => 'Monthly Income';

  @override
  String get monthlyIncomeSubtitle => 'This month from harvested crops';

  @override
  String get cropName => 'Crop Name';

  @override
  String get areaAcres => 'Area (acres)';

  @override
  String get sowingDate => 'Sowing Date (YYYY-MM-DD)';

  @override
  String get enterCropName => 'Enter crop name';

  @override
  String acresSown(String area, String date) {
    return '$area acres · Sown $date';
  }

  @override
  String profitLabel(String amount) {
    return 'Profit ₹$amount';
  }

  @override
  String get addExpense => 'Add Expense';

  @override
  String get expenseType => 'Type (Fertilizer, Labour, Spray, Cultivation)';

  @override
  String get amountLabel => 'Amount (₹)';

  @override
  String get dateLabel => 'Date';

  @override
  String get saveExpense => 'Save Expense';

  @override
  String get recordHarvestSale => 'Record Harvest & Sale';

  @override
  String get totalSellingValue => 'Total Selling Value (₹)';

  @override
  String get save => 'Save';

  @override
  String get totalExpenses => 'Total Expenses';

  @override
  String get sellingValue => 'Selling Value';

  @override
  String get profit => 'Profit';

  @override
  String get margin => 'Margin';

  @override
  String get expenseBreakdown => 'Expense Breakdown';

  @override
  String get expenses => 'Expenses';

  @override
  String get noExpensesYet =>
      'No expenses recorded yet. Tap Add Expense to log costs.';

  @override
  String get searchSchemes => 'Search schemes';

  @override
  String get all => 'All';

  @override
  String couldNotLoadSchemes(String error) {
    return 'Could not load schemes: $error';
  }

  @override
  String get noSchemesMatch => 'No schemes match your search';

  @override
  String applyForTitle(String title) {
    return 'Apply for $title';
  }

  @override
  String get teamFillForm => 'Our team will fill the form for you';

  @override
  String get villageName => 'Village Name';

  @override
  String get submitApplication => 'Submit Application';

  @override
  String get fillAllFields => 'Please fill all fields';

  @override
  String get applicationSubmitted =>
      'Application submitted! Our team will contact you.';

  @override
  String get details => 'Details';

  @override
  String get apply => 'Apply';

  @override
  String get schemeDetails => 'Scheme Details';

  @override
  String couldNotLoadScheme(String error) {
    return 'Could not load scheme: $error';
  }

  @override
  String get eligibility => 'Eligibility';

  @override
  String get benefits => 'Benefits';

  @override
  String get howToApply => 'How to Apply';

  @override
  String get applyNow => 'Apply Now';

  @override
  String get weatherForecast => 'Weather Forecast';

  @override
  String get updateLocationInProfile => 'Update Location in Profile';

  @override
  String get extendedForecast => '15-Day Extended Forecast';

  @override
  String get forecastLoadingHint =>
      'Forecast data is loading from your location. If this persists, ensure your profile has GPS coordinates set.';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get notificationsEmptySubtitle =>
      'Weather alerts, scheme updates, and community activity appear here.';

  @override
  String get allCaughtUp => 'All caught up';

  @override
  String get noNewNotifications => 'You have no new notifications.';

  @override
  String get nearbyFarmers => 'Nearby Farmers';

  @override
  String get nearbyUnavailable => 'Nearby farmers unavailable';

  @override
  String get noFarmersNearby => 'No farmers nearby';

  @override
  String get updateLocationNearby =>
      'Update your location in profile to find farmers around you.';

  @override
  String kmAway(String distance) {
    return '$distance km away';
  }

  @override
  String get harvestShort => 'Harvest';
}
