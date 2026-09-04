// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appName => 'CropDoc';

  @override
  String get appTagline => 'તમારો વિશ્વાસનીય ખેતી સાથી';

  @override
  String get onboardingPage1Title => 'દરેક ઋતુ પડકાર લાવે છે';

  @override
  String get onboardingPage1Subtitle =>
      'અનિશ્ચિત હવામાન, પાકના રોગ અને વધતા ખર્ચ ખેડૂઓ માટે દર દિવસ મુશ્કેલ બનાવે છે.';

  @override
  String get onboardingPage2Title => 'ટેકનોલોજી મદદ કરી શકે છે';

  @override
  String get onboardingPage2Subtitle =>
      'સ્માર્ટ ઇન્સાઇટ્સ અને રિઅલ-ટાઇમ ડેટા અનિશ્ચિતતાને યોગ્ય નિર્ણયોમાં બદલી શકે છે.';

  @override
  String get onboardingPage3Title => 'AI તમારો ભાગીદાર બને છે';

  @override
  String get onboardingPage3Subtitle =>
      'રોગ પહેલાં શોધો, તમારા પાકનું ટ્રેકિંગ કરો, અને વ્યક્તિગત ભલામણ મેળવો.';

  @override
  String get onboardingPage4Title => 'CropDoc માં સ્વાગત છે';

  @override
  String get onboardingPage4Subtitle =>
      'તમારો ખેત, સમજાયો છે. ચાલો એકસાથે વધીએ.';

  @override
  String get getStarted => 'શરૂ કરો';

  @override
  String get skip => 'છોડો';

  @override
  String get next => 'આગળ';

  @override
  String get login => 'લોગિન';

  @override
  String get register => 'ખાતું બનાવો';

  @override
  String get welcomeBack => 'પુનઃ સ્વાગત';

  @override
  String get loginSubtitle => 'તમારી ખેતી યાત્રા ચાલુ રાખવા માટે સાઇન ઇન કરો';

  @override
  String get mobileNumber => 'મોબાઇલ નંબર';

  @override
  String get password => 'પાસવર્ડ';

  @override
  String get fullName => 'પૂરું નામ';

  @override
  String get email => 'ઈમેલ';

  @override
  String get confirmPassword => 'પાસવર્ડ પુષ્ટિ કરો';

  @override
  String get forgotPassword => 'પાસવર્ડ ભૂલી ગયા?';

  @override
  String get dontHaveAccount => 'ખાતું નથી?';

  @override
  String get alreadyHaveAccount => 'પહેલેથી જ ખાતું છે?';

  @override
  String get alreadyHaveAccountLogin => 'પહેલેથી જ ખાતું છે? લોગિન કરો';

  @override
  String get createAccountTitle => 'આપણે તમને ઓળખીએ';

  @override
  String get createAccountSubtitle =>
      'તમારો અનુભવ વ્યક્તિગત બનાવવા માટે તમારા વિશે થોડું કહો';

  @override
  String get locationPermissionTitle => 'અમારા ખેતને સમજવામાં મદદ કરો';

  @override
  String get locationPermissionSubtitle =>
      'તમારું સ્થાન ચોક્કસ હવામાન, પાક સલાહ અને સ્થાનિક માહિતી પ્રદાન કરવામાં મદદ કરે છે.';

  @override
  String get locationPermissionSubtitleExtended =>
      'તમારું સ્થાન ચોક્કસ હવામાન, પાક સલાહ અને તમારા પ્રદેશ માટે અનુકૂલિત સ્થાનિક માહિતી પ્રદાન કરે છે.';

  @override
  String get locationPermissionAllow => 'સ્થાનની પરવાનગી આપો';

  @override
  String get locationPermissionSkip => 'હમણા છોડો';

  @override
  String get locationLoading => 'તમારી આસપાસ જોઈ રહ્યા છીએ...';

  @override
  String get locationFound => 'અમને તમારું સ્થાન મળ્યું';

  @override
  String get locationDetected => 'સ્થાન શોધાયું';

  @override
  String get almostReady => 'લગભગ તૈયાર';

  @override
  String get almostReadySubtitle =>
      'અમે તમારી વ્યક્તિગત ખેતી ડેશબોર્ડ સેટ કરી રહ્યા છીએ';

  @override
  String get accountCreated => 'તમારો ખેત હવે જોડાયેલ છે';

  @override
  String get accountCreatedSubtitle =>
      'કૃષિદnya માં સ્વાગત છે. ચાલો તમારી યાત્રા શરૂ કરીએ.';

  @override
  String get enterDashboard => 'ડેશબોર્ડમાં જાઓ';

  @override
  String get continueLabel => 'ચાલુ રાખો';

  @override
  String dashboardGreeting(String timeOfDay, String name) {
    return 'શુભ $timeOfDay, $name';
  }

  @override
  String get morning => 'સવાર';

  @override
  String get afternoon => 'બપોર';

  @override
  String get evening => 'સાંજ';

  @override
  String get todaysWeather => 'આજનું હવામાન';

  @override
  String get farmStatus => 'ખેતની સ્થિતિ';

  @override
  String get cropStage => 'પાકની સ્થિતિ';

  @override
  String get recommendations => 'ભલામણ';

  @override
  String get preparingInsights => 'આજની ખેતી માહિતી તૈયાર થઈ રહી છે...';

  @override
  String get checkingSky => 'આજના આકાશને જોઈ રહ્યા છીએ...';

  @override
  String get checkingCropHealth =>
      'તમારા પાકના સ્વાસ્થ્યની તપાસ કરી રહ્યા છીએ...';

  @override
  String get loadingRecommendations => 'ભલામણ લોડ થઈ રહી છે...';

  @override
  String cropsTracked(int count) {
    return '$count પાક ટ્રેક કર્યા';
  }

  @override
  String get noCropsTracked => 'હજી કોઈ પાક ટ્રેક કરેલ નથી';

  @override
  String get addCropsHint => 'ખેત ટ્રેક કરવા માટે Analytics માં પાક ઉમેરો';

  @override
  String get defaultFarmerName => 'ખેડૂ';

  @override
  String get errorGeneric => 'કંઈક ખોટું થયું. કૃપા કરીને ફરી પ્રયત્ન કરો.';

  @override
  String get errorNetwork => 'ઇન્ટરનેટ કનેક્શન નથી. કૃપા કરીને નેટવર્ક તપાસો.';

  @override
  String get retry => 'ફરી પ્રયત્ન કરો';

  @override
  String get home => 'હોમ';

  @override
  String get farm => 'ખેત';

  @override
  String get scan => 'સ્કેન';

  @override
  String get analytics => 'વિશ્લેષણ';

  @override
  String get profile => 'પ્રોફાઇલ';

  @override
  String get chat => 'ચેટ';

  @override
  String get community => 'સમુદાય';

  @override
  String get quickActions => 'ઝડપી ક્રિયાઓ';

  @override
  String get governmentSchemes => 'સરકારી યોજનાઓ';

  @override
  String get schemesSubtitle => 'તમારી જેવા ખેડૂઓ માટે લાભો';

  @override
  String get tapToViewForecast => 'આગાહી જોવા માટે ટેપ કરો';

  @override
  String get cropRecommendation => 'પાક ભલામણ';

  @override
  String get cropRecommendationSubtitle => 'AI દ્વારા પાક પસંદગી';

  @override
  String get scanCrop => 'પાક સ્કેન';

  @override
  String get scanCropSubtitle => 'રોગ ઝડપથી શોધો';

  @override
  String get marketplace => 'બજાર';

  @override
  String get marketplaceSubtitle => 'ખરીદી, વેચાણ અને ભાડે';

  @override
  String get viewHistory => 'ઇતિહાસ જુઓ';

  @override
  String get viewHistorySubtitle => 'પાક અને માટી રેકોર્ડ';

  @override
  String get mandiPrices => 'મંડી ભાવ';

  @override
  String get mandiPricesSubtitle => 'દૈનિક બજાર દર';

  @override
  String get analyticsSubtitle => 'ખેત ખર્ચ ટ્રેકર';

  @override
  String get nameRequired => 'નામ આવશ્યક છે';

  @override
  String get validEmail => 'કૃપા કરીને માન્ય ઈમેલ દાખલ કરો';

  @override
  String get validMobile => 'માન્ય 10 અંકનો નંબર દાખલ કરો';

  @override
  String get validMobileLogin =>
      'કૃપા કરીને માન્ય 10 અંકનો મોબાઇલ નંબર દાખલ કરો';

  @override
  String get passwordMinLength => 'પાસવર્ડ ઓછામાં ઓછા 6 અક્ષરોનો હોવો જોઈએ';

  @override
  String get passwordsNoMatch => 'પાસવર્ડ બંધબેસતા નથી';

  @override
  String get enterPassword => 'કૃપા કરીને તમારો પાસવર્ડ દાખલ કરો';

  @override
  String get fullNameHint => 'ઉદા. તેજસ બરગુજે';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get mobileHint => '10 અંકનો મોબાઇલ નંબર';

  @override
  String get mobileHintLogin => 'તમારો મોબાઇલ નંબર દાખલ કરો';

  @override
  String get passwordHint => 'તમારો પાસવર્ડ દાખલ કરો';

  @override
  String get loginWithOtpInstead => 'OTP સાથે લોગિન કરો';

  @override
  String get loginWithPasswordInstead => 'પાસવર્ડ સાથે લોગિન કરો';

  @override
  String get otpLoginTitle => 'OTP સાથે લોગિન';

  @override
  String get otpLoginSubtitle => 'OTP મેળવવા માટે તમારો મોબાઇલ નંબર દાખલ કરો.';

  @override
  String get otpLabel => 'OTP';

  @override
  String get sendOtp => 'OTP મોકલો';

  @override
  String get verifyAndLogin => 'ચકાસણી કરો અને લોગિન કરો';

  @override
  String get otpSent => 'OTP તમારા મોબાઇલ પર મોકલાયો';

  @override
  String get enterOtp => 'OTP દાખલ કરો';

  @override
  String get enterValidMobile => 'માન્ય મોબાઇલ નંબર દાખલ કરો';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get language => 'ભાષા';

  @override
  String get appLanguage => 'એપ ભાષા';

  @override
  String get account => 'ખાતું';

  @override
  String get logOut => 'લોગ આઉટ';

  @override
  String get deleteAccount => 'ખાતું કાઢી નાખો';

  @override
  String get legal => 'કાયદેસર';

  @override
  String get termsAndConditions => 'નિયમો અને શરતો';

  @override
  String get privacyPolicy => 'ગોપનીયતા નીતિ';

  @override
  String get about => 'વિશે';

  @override
  String get appVersion => 'કૃષિદnya v1.0.0';

  @override
  String get logOutConfirmTitle => 'લોગ આઉટ';

  @override
  String get logOutConfirmMessage => 'શું તમે ચોક્કસ લોગ આઉટ કરવા માંગો છો?';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get tellUsAboutFarm => 'અમારા ખેત વિશે કહો';

  @override
  String get soilType => 'માટીનો પ્રકાર';

  @override
  String get season => 'ઋતુ';

  @override
  String get farmAreaAcres => 'ખેત વિસ્તાર (એકર)';

  @override
  String get wateringMethod => 'સિંચાઈ પદ્ધતિ';

  @override
  String get getTop4Crops => 'ટોચના 4 પાક મેળવો';

  @override
  String get topCropPicks => 'ટોચના પાક પસંદગી';

  @override
  String get weatherAnalysis => 'હવામાન વિશ્લેષણ';

  @override
  String get temperature => 'તાપમાન';

  @override
  String get humidity => 'ભેજ';

  @override
  String get expectedRain => 'અપેક્ષિત વરસાદ';

  @override
  String get whyGrow => 'શા માટે ઉગાડવું';

  @override
  String get waterRequired => 'પાણી આવશ્યક';

  @override
  String get daysToHarvest => 'કાપણી સુધી દિવસો';

  @override
  String get growingPeriod => 'વધવાની સમયગાળો';

  @override
  String get expectedProfit => 'અપેક્ષિત નફો';

  @override
  String get scanYourCrop => 'તમારા પાકને સ્કેન કરો';

  @override
  String get scanCropHelpText =>
      'અસરગ્રસ્ત પાનાંના ફોટો લો. અમારો AI રોગ શોધે છે અને ચોક્કસ ડોઝેજ સાથે જૈવિક અને રાસાયણિક ઉપચાર સૂચવે છે.';

  @override
  String get analyzingCropImage => 'પાક છબી વિશ્લેષણ...';

  @override
  String get takePhoto => 'ફોટો લો';

  @override
  String get camera => 'કેમેરા';

  @override
  String get gallery => 'ગેલેરી';

  @override
  String get organicCureRecommended => 'જૈવિક ઉપચાર (ભલામણીય)';

  @override
  String get chemicalCure => 'રાસાયણિક ઉપચાર';

  @override
  String get recommendedProducts => 'ભલામણીય ઉત્પાદનો';

  @override
  String get dosageLabel => 'ડોઝ';

  @override
  String confidenceLabel(String value) {
    return 'વિશ્વાસ: $value';
  }

  @override
  String get crop => 'પાક';

  @override
  String get stateLabel => 'રાજ્ય';

  @override
  String get favorites => 'મનપસંદ';

  @override
  String get recent => 'તાજેતરના';

  @override
  String get fetchTodaysPrices => 'આજના ભાવ લાવો';

  @override
  String get saveCropToFavorites => 'પાકને મનપસંદમાં સાચવો';

  @override
  String get addedToFavorites => 'મનપસંદમાં ઉમેરાયા';

  @override
  String get noPriceData => 'આ પાક અને રાજ્ય માટે કોઈ કિંમત ડેટા મળ્યો નથી.';

  @override
  String get todaysMarketRates => 'આજના બજાર દર';

  @override
  String get marketLabel => 'બજાર';

  @override
  String get listItem => 'વસ્તુ ઉમેરો';

  @override
  String get listItemTooltip => 'વસ્તુ ઉમેરો';

  @override
  String get noListingsYet => 'હજુ કોઈ વસ્તુ નથી';

  @override
  String get marketplaceEmptySubtitle =>
      'ટ્રેક્ટર, બીજ, અથવા પશુપાલન સૂચવવા માટે પહેલી વસ્તુ ઉમેરો.';

  @override
  String get listAnItem => 'વસ્તુ ઉમેરો';

  @override
  String get rent => 'ભાડે';

  @override
  String get sell => 'વેચાણ';

  @override
  String get itemName => 'વસ્તુનું નામ';

  @override
  String get categoryHint => 'શ્રેણી (મશીનરી, પશુપાલન, બીજ...)';

  @override
  String get price => 'કિંમત';

  @override
  String get unitHint => 'યુનિટ (દિવસ, કિલો, ટુકડો)';

  @override
  String get contactPhone => 'સંપર્ક ફોન';

  @override
  String get description => 'વર્ણન';

  @override
  String get enterNameAndPrice => 'નામ અને કિંમત દાખલ કરો';

  @override
  String get itemListedSuccess => 'વસ્તુ સફળતાપૂર્વક ઉમેરાઈ!';

  @override
  String get contactSeller => 'વેચનાર સંપર્ક કરો';

  @override
  String get noContactAvailable => 'સંપર્ક ઉપલબ્ધ નથી';

  @override
  String get couldNotOpenDialer => 'ફોન ડાયલર ખોલી શકાયું નથી';

  @override
  String get history => 'ઇતિહાસ';

  @override
  String get export => 'નિકાસ';

  @override
  String get farmHistoryTitle => 'તમારો ખેત ઇતિહાસ';

  @override
  String get farmHistorySubtitle =>
      'ભૂતકાળના પાક સ્કેન, માટી ચકાસણી, અને ભલામણ અહીં દેખાય છે.';

  @override
  String get noHistoryYet => 'હજુ ઇતિહાસ નથી';

  @override
  String get noHistorySubtitle =>
      'ઇતિહાસ બનાવવા માટે પાક સ્કેન કરો અથવા ભલામણ મેળવો.';

  @override
  String get farmAnalytics => 'ખેત વિશ્લેષણ';

  @override
  String get syncToCloud => 'ક્લાઉડ સિંક કરો';

  @override
  String get farmDataSynced => 'ખેત ડેટા સિંક થયો';

  @override
  String get addCrop => 'પાક ઉમેરો';

  @override
  String get digitalFarmNotebook => 'તમારું ડિજિટલ ખેત નોટબુક';

  @override
  String get digitalFarmNotebookSubtitle =>
      'વાવણી, ખાત, મજૂરી, સ્પ્રે અને કાપણી ખર્ચ ટ્રેક કરો.';

  @override
  String get digitalFarmNotebookSubtitleLong =>
      'વાવણી, ખાત, મજૂરી, સ્પ્રે અને કાપણી ખર્ચ ટ્રેક કરો. પ્રતિ પાક નફો અને માર્જિન સ્વચાલિત રીતે ગણો.';

  @override
  String get monthlyIncome => 'માસિક આવક';

  @override
  String get monthlyIncomeSubtitle => 'આ મહિનામાં કાપણી કરેલા પાકમાંથી';

  @override
  String get cropName => 'પાકનું નામ';

  @override
  String get areaAcres => 'વિસ્તાર (એકર)';

  @override
  String get sowingDate => 'વાવણી તારીખ (YYYY-MM-DD)';

  @override
  String get enterCropName => 'પાકનું નામ દાખલ કરો';

  @override
  String acresSown(String area, String date) {
    return '$area એકર · વાવણી $date';
  }

  @override
  String profitLabel(String amount) {
    return 'નફો ₹$amount';
  }

  @override
  String get addExpense => 'ખર્ચ ઉમેરો';

  @override
  String get expenseType => 'પ્રકાર (ખાત, મજૂરી, સ્પ્રે, હળ)';

  @override
  String get amountLabel => 'રકમ (₹)';

  @override
  String get dateLabel => 'તારીખ';

  @override
  String get saveExpense => 'ખર્ચ સાચવો';

  @override
  String get recordHarvestSale => 'કાપણી અને વેચાણ રેકોર્ડ કરો';

  @override
  String get totalSellingValue => 'કુલ વેચાણ મૂલ્ય (₹)';

  @override
  String get save => 'સાચવો';

  @override
  String get totalExpenses => 'કુલ ખર્ચ';

  @override
  String get sellingValue => 'વેચાણ મૂલ્ય';

  @override
  String get profit => 'નફો';

  @override
  String get margin => 'માર્જિન';

  @override
  String get expenseBreakdown => 'ખર્ચ વિગત';

  @override
  String get expenses => 'ખર્ચ';

  @override
  String get noExpensesYet =>
      'No expenses recorded yet. Tap Add Expense to log costs.';

  @override
  String get searchSchemes => 'યોજનાઓ શોધો';

  @override
  String get all => 'બધા';

  @override
  String couldNotLoadSchemes(String error) {
    return 'યોજનાઓ લોડ કરી શકાઈ નહીં: $error';
  }

  @override
  String get noSchemesMatch => 'તમારી શોધ સાથે કોઈ યોજના બંધબેસતી નથી';

  @override
  String applyForTitle(String title) {
    return '$title માટે અરજ કરો';
  }

  @override
  String get teamFillForm => 'અમારી ટીમ તમારા માટે ફોર્મ ભરશે';

  @override
  String get villageName => 'ગામનું નામ';

  @override
  String get submitApplication => 'અરજ જમા કરો';

  @override
  String get fillAllFields => 'કૃપા કરીને બધા ફીલ્ડ ભરો';

  @override
  String get applicationSubmitted =>
      'અરજ જમા થયો! અમારી ટીમ તમારો સંપર્ક કરશે.';

  @override
  String get details => 'વિગત';

  @override
  String get apply => 'અરજ કરો';

  @override
  String get schemeDetails => 'યોજના વિગત';

  @override
  String couldNotLoadScheme(String error) {
    return 'યોજના લોડ કરી શકાઈ નહીં: $error';
  }

  @override
  String get eligibility => 'લાયકાત';

  @override
  String get benefits => 'લાભો';

  @override
  String get howToApply => 'કેવી રીતે અરજ કરવો';

  @override
  String get applyNow => 'હવે અરજ કરો';

  @override
  String get weatherForecast => 'હવામાન આગાહી';

  @override
  String get updateLocationInProfile => 'પ્રોફાઇલમાં સ્થાન અપડેટ કરો';

  @override
  String get extendedForecast => '15-દિવસની વિસ્તૃત આગાહી';

  @override
  String get forecastLoadingHint =>
      'તમારા સ્થાનથી આગાહી ડેટા લોડ થઈ રહ્યો છે. જો આ ચાલુ રહે, તો પ્રોફાઇલમાં GPS નિર્દેશાંક સેટ છે તે સુનિશ્ચિત કરો.';

  @override
  String get notifications => 'સૂચનાઓ';

  @override
  String get markAllRead => 'બધા વાંચેલા માનો';

  @override
  String get noNotifications => 'કોઈ સૂચના નથી';

  @override
  String get notificationsEmptySubtitle =>
      'હવામાન ચેતવણી, યોજના અપડેટ અને સમુદાય પ્રવૃત્તિઓ અહીં દેખાય છે.';

  @override
  String get allCaughtUp => 'બધું જોયું';

  @override
  String get noNewNotifications => 'તમારા માટે કોઈ નવી સૂચના નથી.';

  @override
  String get nearbyFarmers => 'નજીકના ખેડૂઓ';

  @override
  String get nearbyUnavailable => 'નજીકના ખેડૂઓ ઉપલબ્ધ નથી';

  @override
  String get noFarmersNearby => 'નજીક કોઈ ખેડૂઓ નથી';

  @override
  String get updateLocationNearby =>
      'નજીકના ખેડૂઓ શોધવા માટે પ્રોફાઇલમાં સ્થાન અપડેટ કરો.';

  @override
  String kmAway(String distance) {
    return '$distance કિમી દૂર';
  }

  @override
  String get harvestShort => 'કાપણી';

  @override
  String get clearChat => 'ચેટ સાફ કરો';

  @override
  String get howCanHelpFarmToday =>
      'આજ હું તમારા ખેતની મદદ કેવી રીતે કરી શકું?';

  @override
  String get askAboutCropsWeatherDiseases =>
      'પાક, હવામાન, રોગ અથવા સરકારી યોજનાઓ વિશે પૂછો.';

  @override
  String get listening => 'સાંભળી રહ્યા છીએ...';

  @override
  String get typeYourQuestion => 'તમારો પ્રશ્ન ટાઇપ કરો...';

  @override
  String get communityTitle => 'સમુદાય';

  @override
  String get farmerCommunity => 'ખેડૂ સમુદાય';

  @override
  String get farmerCommunitySubtitle =>
      'પાક અપડેટ શેર કરો, સૂચના આપો, અને નજીકના ખેડૂઓ સાથે જોડાઓ.';

  @override
  String get noPostsYet => 'હજુ કોઈ પોસ્ટ નથી';

  @override
  String get noPostsYetSubtitle => 'સમુદાય સાથે તમારો પહેલો ખેત અપડેટ શેર કરો.';

  @override
  String get shareUpdate => 'અપડેટ શેર કરો';

  @override
  String get titleOptional => 'શીર્ષક (વૈકલ્પિક)';

  @override
  String get category => 'શ્રેણી';

  @override
  String get whatsHappeningOnFarm => 'તમારા ખેત પર શું થઈ રહ્યું છે?';

  @override
  String get addPhoto => 'ફોટો ઉમેરો';

  @override
  String get photoSelected => 'ફોટો પસંદ કર્યો';

  @override
  String get post => 'પોસ્ટ કરો';

  @override
  String get writeSomethingToShare => 'શેર કરવા માટે કંઈક લખો';

  @override
  String get commentsTitle => 'ટિપ્પણીઓ';

  @override
  String get noCommentsYet => 'હજુ કોઈ ટિપ્પણી નથી. પહેલી બનો!';

  @override
  String get addAComment => 'ટિપ્પણી ઉમેરો';

  @override
  String get postComment => 'ટિપ્પણી પોસ્ટ કરો';

  @override
  String get profileTitle => 'પ્રોફાઇલ';

  @override
  String get krishidnyaAI => 'CropDoc AI';

  @override
  String get askAnythingAboutFarming => 'ખેતી વિશે કોઈપણ પ્રશ્ન પૂછો';
}
