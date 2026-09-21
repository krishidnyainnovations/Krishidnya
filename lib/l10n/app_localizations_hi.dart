// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'कृषिदnya';

  @override
  String get appTagline => 'आपका विश्वसनीय कृषि साथी';

  @override
  String get onboardingPage1Title => 'हर मौसम चुनौतियाँ लाता है';

  @override
  String get onboardingPage1Subtitle =>
      'अनिश्चित मौसम, फसल रोग और बढ़ती लागत से खेती हर दिन कठिन होती जा रही है।';

  @override
  String get onboardingPage2Title => 'तकनीक मदद कर सकती है';

  @override
  String get onboardingPage2Subtitle =>
      'स्मार्ट जानकारी और रियल-टाइम डेटा अनिश्चितता को सही निर्णयों में बदल सकता है।';

  @override
  String get onboardingPage3Title => 'AI आपका साथी बनता है';

  @override
  String get onboardingPage3Subtitle =>
      'रोग जल्दी पहचानें, फसलों की निगरानी करें और व्यक्तिगत सलाह पाएं।';

  @override
  String get onboardingPage4Title => 'कृषिज्ञ में आपका स्वागत है';

  @override
  String get onboardingPage4Subtitle =>
      'आपका खेत, समझा गया। आइए साथ मिलकर बढ़ें।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get next => 'आगे';

  @override
  String get login => 'लॉगिन';

  @override
  String get register => 'खाता बनाएं';

  @override
  String get welcomeBack => 'वापसी पर स्वागत है';

  @override
  String get loginSubtitle => 'अपनी कृषि यात्रा जारी रखने के लिए साइन इन करें';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get password => 'पासवर्ड';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get email => 'ईमेल';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get dontHaveAccount => 'खाता नहीं है?';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है?';

  @override
  String get alreadyHaveAccountLogin => 'पहले से खाता है? लॉगिन करें';

  @override
  String get createAccountTitle => 'आइए आपको जानें';

  @override
  String get createAccountSubtitle =>
      'अनुभव को व्यक्तिगत बनाने के लिए अपने बारे में थोड़ा बताएं';

  @override
  String get locationPermissionTitle => 'अपने खेत को समझने में मदद करें';

  @override
  String get locationPermissionSubtitle =>
      'आपका स्थान सटीक मौसम, फसल सलाह और स्थानीय जानकारी देने में मदद करता है।';

  @override
  String get locationPermissionSubtitleExtended =>
      'आपका स्थान सटीक मौसम, फसल सलाह और आपके क्षेत्र के अनुसार स्थानीय जानकारी देता है।';

  @override
  String get locationPermissionAllow => 'स्थान की अनुमति दें';

  @override
  String get locationPermissionSkip => 'अभी छोड़ें';

  @override
  String get locationLoading => 'आपके आस-पास देख रहे हैं...';

  @override
  String get locationFound => 'हमें आपका स्थान मिल गया';

  @override
  String get locationDetected => 'स्थान पहचाना गया';

  @override
  String get almostReady => 'लगभग तैयार';

  @override
  String get almostReadySubtitle =>
      'हम आपका व्यक्तिगत कृषि डैशबोर्ड सेट कर रहे हैं';

  @override
  String get accountCreated => 'आपका खेत अब जुड़ गया है';

  @override
  String get accountCreatedSubtitle =>
      'कृषिदnya में स्वागत है। आइए अपनी यात्रा शुरू करें।';

  @override
  String get enterDashboard => 'डैशबोर्ड में जाएं';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String dashboardGreeting(String timeOfDay, String name) {
    return 'शुभ $timeOfDay, $name';
  }

  @override
  String get morning => 'प्रभात';

  @override
  String get afternoon => 'दोपहर';

  @override
  String get evening => 'संध्या';

  @override
  String get todaysWeather => 'आज का मौसम';

  @override
  String get farmStatus => 'खेत की स्थिति';

  @override
  String get cropStage => 'फसल चरण';

  @override
  String get recommendations => 'सिफारिशें';

  @override
  String get preparingInsights => 'आज की कृषि जानकारी तैयार हो रही है...';

  @override
  String get checkingSky => 'आज के आकाश को देख रहे हैं...';

  @override
  String get checkingCropHealth => 'आपकी फसल की सेहत जाँच रहे हैं...';

  @override
  String get loadingRecommendations => 'सिफारिशें लोड हो रही हैं...';

  @override
  String cropsTracked(int count) {
    return '$count फसलें ट्रैक हो रही हैं';
  }

  @override
  String get noCropsTracked => 'अभी कोई फसल ट्रैक नहीं';

  @override
  String get addCropsHint => 'खेत ट्रैक करने के लिए Analytics में फसल जोड़ें';

  @override
  String get defaultFarmerName => 'किसान';

  @override
  String get errorGeneric => 'कुछ गलत हो गया। कृपया पुनः प्रयास करें।';

  @override
  String get errorNetwork => 'इंटरनेट कनेक्शन नहीं है। कृपया नेटवर्क जाँचें।';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get home => 'होम';

  @override
  String get farm => 'खेत';

  @override
  String get scan => 'स्कैन';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get chat => 'चैट';

  @override
  String get community => 'समुदाय';

  @override
  String get quickActions => 'त्वरित कार्य';

  @override
  String get governmentSchemes => 'सरकारी योजनाएं';

  @override
  String get schemesSubtitle => 'आप जैसे किसानों के लिए लाभ';

  @override
  String get tapToViewForecast => 'पूर्वानुमान देखने के लिए टैप करें';

  @override
  String get cropRecommendation => 'फसल सिफारिश';

  @override
  String get cropRecommendationSubtitle => 'AI से फसल चयन';

  @override
  String get scanCrop => 'फसल स्कैन';

  @override
  String get scanCropSubtitle => 'रोग जल्दी पहचानें';

  @override
  String get marketplace => 'बाज़ार';

  @override
  String get marketplaceSubtitle => 'खरीदें, बेचें और किराए पर लें';

  @override
  String get viewHistory => 'इतिहास देखें';

  @override
  String get viewHistorySubtitle => 'फसल और मिट्टी रिकॉर्ड';

  @override
  String get mandiPrices => 'मंडी भाव';

  @override
  String get mandiPricesSubtitle => 'दैनिक बाज़ार दरें';

  @override
  String get analyticsSubtitle => 'खेत खर्च ट्रैकर';

  @override
  String get nameRequired => 'नाम आवश्यक है';

  @override
  String get validEmail => 'कृपया वैध ईमेल दर्ज करें';

  @override
  String get validMobile => 'वैध 10 अंकों का नंबर दर्ज करें';

  @override
  String get validMobileLogin => 'कृपया वैध 10 अंकों का मोबाइल नंबर दर्ज करें';

  @override
  String get passwordMinLength => 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए';

  @override
  String get passwordsNoMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get confirmPasswordRequired => 'कृपया अपना पासवर्ड की पुष्टि करें';

  @override
  String get enterPassword => 'कृपया अपना पासवर्ड दर्ज करें';

  @override
  String get fullNameHint => 'जैसे तेजस बरगुजे';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get mobileHint => '10 अंकों का मोबाइल नंबर';

  @override
  String get mobileHintLogin => 'अपना मोबाइल नंबर दर्ज करें';

  @override
  String get passwordHint => 'अपना पासवर्ड दर्ज करें';

  @override
  String get loginWithOtpInstead => 'OTP से लॉगिन करें';

  @override
  String get loginWithPasswordInstead => 'पासवर्ड से लॉगिन करें';

  @override
  String get otpLoginTitle => 'OTP से लॉगिन';

  @override
  String get otpLoginSubtitle =>
      'OTP प्राप्त करने के लिए अपना मोबाइल नंबर दर्ज करें।';

  @override
  String get otpLabel => 'OTP';

  @override
  String get sendOtp => 'OTP भेजें';

  @override
  String get verifyAndLogin => 'सत्यापित करें और लॉगिन करें';

  @override
  String get otpSent => 'OTP आपके मोबाइल पर भेजा गया';

  @override
  String get enterOtp => 'OTP दर्ज करें';

  @override
  String get enterValidMobile => 'वैध मोबाइल नंबर दर्ज करें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get appLanguage => 'ऐप भाषा';

  @override
  String get account => 'खाता';

  @override
  String get logOut => 'लॉग आउट';

  @override
  String get deleteAccount => 'खाता हटाएं';

  @override
  String get legal => 'कानूनी';

  @override
  String get termsAndConditions => 'नियम और शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get about => 'के बारे में';

  @override
  String get appVersion => 'कृषिदnya v1.0.0';

  @override
  String get logOutConfirmTitle => 'लॉग आउट';

  @override
  String get logOutConfirmMessage => 'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get tellUsAboutFarm => 'अपने खेत के बारे में बताएं';

  @override
  String get soilType => 'मिट्टी का प्रकार';

  @override
  String get season => 'मौसम';

  @override
  String get farmAreaAcres => 'खेत का क्षेत्र (एकड़)';

  @override
  String get wateringMethod => 'सिंचाई विधि';

  @override
  String get getTop4Crops => 'शीर्ष 4 फसलें पाएं';

  @override
  String get topCropPicks => 'शीर्ष फसल चयन';

  @override
  String get weatherAnalysis => 'मौसम विश्लेषण';

  @override
  String get temperature => 'तापमान';

  @override
  String get humidity => 'आर्द्रता';

  @override
  String get expectedRain => 'अनुमानित वर्षा';

  @override
  String get whyGrow => 'क्यों उगाएं';

  @override
  String get waterRequired => 'पानी की आवश्यकता';

  @override
  String get daysToHarvest => 'कटाई तक दिन';

  @override
  String get growingPeriod => 'बढ़ने की अवधि';

  @override
  String get expectedProfit => 'अनुमानित लाभ';

  @override
  String get scanYourCrop => 'अपनी फसल स्कैन करें';

  @override
  String get scanCropHelpText =>
      'प्रभावित पत्तों की फोटो लें। हमारा AI रोग पहचानता है और जैविक व रासायनिक उपचार सुझाता है।';

  @override
  String get analyzingCropImage => 'फसल की छवि का विश्लेषण...';

  @override
  String get takePhoto => 'फोटो लें';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get organicCureRecommended => 'जैविक उपचार की सिफारिश';

  @override
  String get chemicalCure => 'रासायनिक उपचार';

  @override
  String get recommendedProducts => 'सिफारिशी उत्पाद';

  @override
  String get dosageLabel => 'खुराक';

  @override
  String confidenceLabel(String value) {
    return 'विश्वास: $value%';
  }

  @override
  String get crop => 'फसल';

  @override
  String get stateLabel => 'राज्य';

  @override
  String get favorites => 'पसंदीदा';

  @override
  String get recent => 'हाल के';

  @override
  String get fetchTodaysPrices => 'आज के भाव लाएं';

  @override
  String get saveCropToFavorites => 'फसल को पसंदीदा में सहेजें';

  @override
  String get addedToFavorites => 'पसंदीदा में जोड़ा गया';

  @override
  String get noPriceData => 'इस फसल और राज्य के लिए कोई भाव नहीं मिला।';

  @override
  String get todaysMarketRates => 'आज के बाज़ार भाव';

  @override
  String get marketLabel => 'मंडी';

  @override
  String get listItem => 'वस्तु सूचीबद्ध करें';

  @override
  String get listItemTooltip => 'वस्तु जोड़ें';

  @override
  String get noListingsYet => 'अभी कोई सूची नहीं';

  @override
  String get marketplaceEmptySubtitle =>
      'ट्रैक्टर, बीज या पशु सूचीबद्ध करने वाले पहले व्यक्ति बनें।';

  @override
  String get listAnItem => 'वस्तु सूचीबद्ध करें';

  @override
  String get rent => 'किराए पर';

  @override
  String get sell => 'बेचें';

  @override
  String get itemName => 'वस्तु का नाम';

  @override
  String get categoryHint => 'श्रेणी (मशीनरी, पशु, बीज...)';

  @override
  String get price => 'कीमत';

  @override
  String get unitHint => 'इकाई (दिन, kg, टुकड़ा)';

  @override
  String get contactPhone => 'संपर्क फोन';

  @override
  String get description => 'विवरण';

  @override
  String get enterNameAndPrice => 'नाम और कीमत दर्ज करें';

  @override
  String get itemListedSuccess => 'वस्तु सफलतापूर्वक सूचीबद्ध!';

  @override
  String get contactSeller => 'विक्रेता से संपर्क करें';

  @override
  String get noContactAvailable => 'कोई संपर्क उपलब्ध नहीं';

  @override
  String get couldNotOpenDialer => 'फोन डायलर नहीं खुल सका';

  @override
  String get history => 'इतिहास';

  @override
  String get export => 'निर्यात';

  @override
  String get farmHistoryTitle => 'आपका खेत इतिहास';

  @override
  String get farmHistorySubtitle =>
      'पिछले स्कैन, मिट्टी परीक्षण और सिफारिशें यहाँ दिखती हैं।';

  @override
  String get noHistoryYet => 'अभी कोई इतिहास नहीं';

  @override
  String get noHistorySubtitle =>
      'इतिहास बनाने के लिए फसल स्कैन करें या सिफारिशें पाएं।';

  @override
  String get farmAnalytics => 'खेत विश्लेषण';

  @override
  String get syncToCloud => 'क्लाउड पर सिंक करें';

  @override
  String get farmDataSynced => 'खेत डेटा सिंक हो गया';

  @override
  String get addCrop => 'फसल जोड़ें';

  @override
  String get digitalFarmNotebook => 'आपकी डिजिटल खेत नोटबुक';

  @override
  String get digitalFarmNotebookSubtitle =>
      'बुवाई, उर्वरक, मजदूरी, छिड़काव और कटाई खर्च ट्रैक करें।';

  @override
  String get digitalFarmNotebookSubtitleLong =>
      'बुवाई, उर्वरक, मजदूरी, छिड़काव और कटाई खर्च ट्रैक करें। प्रति फसल लाभ और मार्जिन स्वतः गणना।';

  @override
  String get monthlyIncome => 'मासिक आय';

  @override
  String get monthlyIncomeSubtitle => 'इस महीने कटाई की फसलों से';

  @override
  String get cropName => 'फसल का नाम';

  @override
  String get areaAcres => 'क्षेत्र (एकड़)';

  @override
  String get sowingDate => 'बुवाई तिथि (YYYY-MM-DD)';

  @override
  String get enterCropName => 'फसल का नाम दर्ज करें';

  @override
  String acresSown(String area, String date) {
    return '$area एकड़ · बुवाई $date';
  }

  @override
  String profitLabel(String amount) {
    return 'लाभ ₹$amount';
  }

  @override
  String get addExpense => 'खर्च जोड़ें';

  @override
  String get expenseType => 'प्रकार (उर्वरक, मजदूरी, छिड़काव, जुताई)';

  @override
  String get amountLabel => 'राशि (₹)';

  @override
  String get dateLabel => 'तिथि';

  @override
  String get saveExpense => 'खर्च सहेजें';

  @override
  String get recordHarvestSale => 'कटाई और बिक्री दर्ज करें';

  @override
  String get totalSellingValue => 'कुल बिक्री मूल्य (₹)';

  @override
  String get save => 'सहेजें';

  @override
  String get totalExpenses => 'कुल खर्च';

  @override
  String get sellingValue => 'बिक्री मूल्य';

  @override
  String get profit => 'लाभ';

  @override
  String get margin => 'मार्जिन';

  @override
  String get expenseBreakdown => 'खर्च विवरण';

  @override
  String get expenses => 'खर्च';

  @override
  String get noExpensesYet =>
      'अभी कोई खर्च दर्ज नहीं। खर्च दर्ज करने के लिए Add Expense टैप करें।';

  @override
  String get searchSchemes => 'योजनाएं खोजें';

  @override
  String get all => 'सभी';

  @override
  String couldNotLoadSchemes(String error) {
    return 'योजनाएं लोड नहीं हो सकीं: $error';
  }

  @override
  String get noSchemesMatch => 'आपकी खोज से कोई योजना मेल नहीं खाती';

  @override
  String applyForTitle(String title) {
    return '$title के लिए आवेदन';
  }

  @override
  String get teamFillForm => 'हमारी टीम आपके लिए फॉर्म भरेगी';

  @override
  String get villageName => 'गाँव का नाम';

  @override
  String get submitApplication => 'आवेदन जमा करें';

  @override
  String get fillAllFields => 'कृपया सभी फ़ील्ड भरें';

  @override
  String get applicationSubmitted =>
      'आवेदन जमा हो गया! हमारी टीम आपसे संपर्क करेगी।';

  @override
  String get details => 'विवरण';

  @override
  String get apply => 'आवेदन';

  @override
  String get schemeDetails => 'योजना विवरण';

  @override
  String couldNotLoadScheme(String error) {
    return 'योजना लोड नहीं हो सकी: $error';
  }

  @override
  String get eligibility => 'पात्रता';

  @override
  String get benefits => 'लाभ';

  @override
  String get howToApply => 'आवेदन कैसे करें';

  @override
  String get applyNow => 'अभी आवेदन करें';

  @override
  String get weatherForecast => 'मौसम पूर्वानुमान';

  @override
  String get updateLocationInProfile => 'प्रोफ़ाइल में स्थान अपडेट करें';

  @override
  String get extendedForecast => '15-दिन का विस्तृत पूर्वानुमान';

  @override
  String get forecastLoadingHint =>
      'आपके स्थान से पूर्वानुमान डेटा लोड हो रहा है। यदि समस्या बनी रहे, तो प्रोफ़ाइल में GPS निर्देशांक सेट करें।';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get markAllRead => 'सभी पढ़ा हुआ';

  @override
  String get noNotifications => 'कोई सूचना नहीं';

  @override
  String get notificationsEmptySubtitle =>
      'मौसम अलर्ट, योजना अपडेट और समुदाय गतिविधि यहाँ दिखती है।';

  @override
  String get allCaughtUp => 'सब देख लिया';

  @override
  String get noNewNotifications => 'आपके पास कोई नई सूचना नहीं है।';

  @override
  String get nearbyFarmers => 'पास के किसान';

  @override
  String get nearbyUnavailable => 'पास के किसान उपलब्ध नहीं';

  @override
  String get noFarmersNearby => 'पास में कोई किसान नहीं';

  @override
  String get updateLocationNearby =>
      'आस-पास के किसान खोजने के लिए प्रोफ़ाइल में स्थान अपडेट करें।';

  @override
  String kmAway(String distance) {
    return '$distance km दूर';
  }

  @override
  String get harvestShort => 'कटाई';

  @override
  String get clearChat => 'चैट साफ़ करें';

  @override
  String get howCanHelpFarmToday => 'आज मैं आपके खेत की मदद कैसे कर सकता हूँ?';

  @override
  String get askAboutCropsWeatherDiseases =>
      'फसल, मौसम, बीमारी या सरकारी योजनाओं के बारे में पूछें।';

  @override
  String get listening => 'सुन रहा हूँ...';

  @override
  String get typeYourQuestion => 'अपना प्रश्न टाइप करें...';

  @override
  String get communityTitle => 'समुदाय';

  @override
  String get farmerCommunity => 'किसान समुदाय';

  @override
  String get farmerCommunitySubtitle =>
      'फसल अपडेट साझा करें, सलाह दें, और पास के किसानों से जुड़ें।';

  @override
  String get noPostsYet => 'अभी कोई पोस्ट नहीं';

  @override
  String get noPostsYetSubtitle =>
      'समुदाय के साथ अपना पहला खेत अपडेट साझा करें।';

  @override
  String get shareUpdate => 'अपडेट साझा करें';

  @override
  String get titleOptional => 'शीर्षक (वैकल्पिक)';

  @override
  String get category => 'श्रेणी';

  @override
  String get whatsHappeningOnFarm => 'आपके खेत में क्या हो रहा है?';

  @override
  String get addPhoto => 'फोटो जोड़ें';

  @override
  String get photoSelected => 'फोटो चुना गया';

  @override
  String get post => 'पोस्ट करें';

  @override
  String get writeSomethingToShare => 'साझा करने के लिए कुछ लिखें';

  @override
  String get commentsTitle => 'टिप्पणियाँ';

  @override
  String get noCommentsYet => 'अभी कोई टिप्पणी नहीं। पहले बनें!';

  @override
  String get addAComment => 'टिप्पणी जोड़ें';

  @override
  String get postComment => 'टिप्पणी पोस्ट करें';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get krishidnyaAI => 'CropDoc AI';

  @override
  String get askAnythingAboutFarming => 'खेती के बारे में कुछ भी पूछें';

  @override
  String get profileUpdated => 'प्रोफ़ाइल अपडेट हो गया';

  @override
  String get locationPermissionDenied => 'स्थान की अनुमति मना कर दी गई';

  @override
  String get locationUpdatedFromGps => 'GPS से स्थान अपडेट हो गया';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get location => 'स्थान';

  @override
  String get city => 'शहर';

  @override
  String get updateFromGps => 'GPS से अपडेट करें';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';
}
