// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'CropDoc';

  @override
  String get appTagline => 'तुमचा विश्वासनीय कृषि साथी';

  @override
  String get onboardingPage1Title => 'प्रत्येक हंगाम आव्हान आणत';

  @override
  String get onboardingPage1Subtitle =>
      'अनिश्चित हवामान, पिकांचे रोग आणि वाढत खर्च शेतकरी दरर वर अवघ्न करत आहे.';

  @override
  String get onboardingPage2Title => 'तंत्रज्ञान मदत करू शकत';

  @override
  String get onboardingPage2Subtitle =>
      'स्मार्ट अंतर्दृष्टी आणि रिअल-टाइम डेटा अनिश्चिततेला योग्य निर्णयांमध्य बनवू शकत.';

  @override
  String get onboardingPage3Title => 'AI तुमचा साथी बनत';

  @override
  String get onboardingPage3Subtitle =>
      'लवकरीपूर्व रोग ओळखा, पिकांची निगरानी करा आणि वैयक्तिकृत सल्ला मिळवा.';

  @override
  String get onboardingPage4Title => 'CropDoc मध्ये स्वागत';

  @override
  String get onboardingPage4Subtitle =>
      'तुमचा शेत, समजला आहे. आपण एकत्र वाढूया.';

  @override
  String get getStarted => 'सुरू करा';

  @override
  String get skip => 'वगळा';

  @override
  String get next => 'पुढे';

  @override
  String get login => 'लॉगिन';

  @override
  String get register => 'खाते तयार करा';

  @override
  String get welcomeBack => 'परत स्वागत';

  @override
  String get loginSubtitle => 'तुमची शेतकरी प्रवास सुरू ठेवा';

  @override
  String get mobileNumber => 'मोबाईल नंबर';

  @override
  String get password => 'पासवर्ड';

  @override
  String get fullName => 'पूर्ण नाव';

  @override
  String get email => 'ईमेल';

  @override
  String get confirmPassword => 'पासवर्ड पुष्टी करा';

  @override
  String get forgotPassword => 'पासवर्ड विसरला?';

  @override
  String get dontHaveAccount => 'खाते नाही?';

  @override
  String get alreadyHaveAccount => 'आधीच खाते आहे?';

  @override
  String get alreadyHaveAccountLogin => 'आधीच खाते आहे? लॉगिन करा';

  @override
  String get createAccountTitle => 'आपण आपल्याबद्दल ओळखू';

  @override
  String get createAccountSubtitle =>
      'तुमचा अनुभव वैयक्तिकृत करण्यासाठी आपल्याबद्दल थोडे सांगा सांगा';

  @override
  String get locationPermissionTitle => 'आमच्या शेताचा समजून मदत करा';

  @override
  String get locationPermissionSubtitle =>
      'तुमचे स्थान अचूक हवामान, पिकां सल्ला आणि स्थानिक माहिती देण्यासाठी मदत करत.';

  @override
  String get locationPermissionSubtitleExtended =>
      'तुमचे स्थान अचूक हवामान, पिकां सल्ला आणि तुमच्या प्रदेशासाठी अनुकूलित स्थानिक माहिती देत.';

  @override
  String get locationPermissionAllow => 'स्थानाची परवाना द्या';

  @override
  String get locationPermissionSkip => 'आता वगळा';

  @override
  String get locationLoading => 'तुमच्या आसपास बघत आहे...';

  @override
  String get locationFound => 'आम्हाला तुमचे स्थान सापडले';

  @override
  String get locationDetected => 'स्थान ओळखले';

  @override
  String get almostReady => 'लगभग तयार';

  @override
  String get almostReadySubtitle =>
      'आम्ही तुमची वैयक्तिकृत शेतकरी डॅशबोर्ड सेट करत आहे';

  @override
  String get accountCreated => 'तुमचे शेत आता जोडले आहे';

  @override
  String get accountCreatedSubtitle =>
      'कृषिदnya मध्ये स्वागत. आपण आपल्या प्रवास सुरू करूया.';

  @override
  String get enterDashboard => 'डॅशबोर्ड मध्ये जा';

  @override
  String get continueLabel => 'सुरू ठेवा';

  @override
  String dashboardGreeting(String timeOfDay, String name) {
    return 'शुभ $timeOfDay, $name';
  }

  @override
  String get morning => 'सकाळ';

  @override
  String get afternoon => 'दुपार';

  @override
  String get evening => 'संध्याकाळ';

  @override
  String get todaysWeather => 'आजचे हवामान';

  @override
  String get farmStatus => 'शेताची स्थिती';

  @override
  String get cropStage => 'पिकांची अवस्था';

  @override
  String get recommendations => 'शिफारिशा';

  @override
  String get preparingInsights => 'आजची शेतकरी माहिती तयार होत आहे...';

  @override
  String get checkingSky => 'आजच्या आकाशाकडे पाहत आहे...';

  @override
  String get checkingCropHealth => 'तुमच्या पिकांची आरोग्या तपासत आहे...';

  @override
  String get loadingRecommendations => 'शिफारिशा लोड होत आहे...';

  @override
  String cropsTracked(int count) {
    return '$count पिकां ट्रॅक केले';
  }

  @override
  String get noCropsTracked => 'अजून कोणतीही पिकां ट्रॅक केलेली नाही';

  @override
  String get addCropsHint => 'शेत ट्रॅक करण्यासाठी Analytics मध्ये पिकां जोडा';

  @override
  String get defaultFarmerName => 'शेतकर';

  @override
  String get errorGeneric => 'काहीतर चूक झाल. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get errorNetwork => 'इंटरनेट कनेक्शन नाही. कृपया नेटवर्क तपासा.';

  @override
  String get retry => 'पुन्हा प्रयत्न करा';

  @override
  String get home => 'होम';

  @override
  String get farm => 'शेत';

  @override
  String get scan => 'स्कॅन';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get chat => 'चॅट';

  @override
  String get community => 'समुदाय';

  @override
  String get quickActions => 'त्वरित कृती';

  @override
  String get governmentSchemes => 'सरकारी योजना';

  @override
  String get schemesSubtitle => 'तुमच्यासारखा शेतकरांसाठी फायदे';

  @override
  String get tapToViewForecast => 'पूर्वानुमान पाहण्यासाठी टॅप करा';

  @override
  String get cropRecommendation => 'पिकां शिफारिश';

  @override
  String get cropRecommendationSubtitle => 'AI से पिकां निवडण';

  @override
  String get scanCrop => 'पिकां स्कॅन';

  @override
  String get scanCropSubtitle => 'रोग लवकरपणे ओळखा';

  @override
  String get marketplace => 'बाजार';

  @override
  String get marketplaceSubtitle => 'खरेदा, विक्री आणि भाडेवर घेणे';

  @override
  String get viewHistory => 'इतिहास पहा';

  @override
  String get viewHistorySubtitle => 'पिकां आणि माती रेकॉर्ड';

  @override
  String get mandiPrices => 'मंडी भाव';

  @override
  String get mandiPricesSubtitle => 'दैनिक बाजार दर';

  @override
  String get analyticsSubtitle => 'शेत खर्च ट्रॅकर';

  @override
  String get nameRequired => 'नाव आवश्यक आहे';

  @override
  String get validEmail => 'कृपया वैध ईमेल प्रविष्ट करा';

  @override
  String get validMobile => 'वैध 10 अंकांचा नंबर प्रविष्ट करा';

  @override
  String get validMobileLogin =>
      'कृपया वैध 10 अंकांचा मोबाईल नंबर प्रविष्ट करा';

  @override
  String get passwordMinLength => 'पासवर्ड कमीत कमी 6 अक्षरांचा असावा';

  @override
  String get passwordsNoMatch => 'पासवर्ड जुळत नाही';

  @override
  String get enterPassword => 'कृपया आपला पासवर्ड प्रविष्ट करा';

  @override
  String get fullNameHint => 'उदा. तेजस बरगुजे';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get mobileHint => '10 अंकांचा मोबाईल नंबर';

  @override
  String get mobileHintLogin => 'आपला मोबाईल नंबर प्रविष्ट करा';

  @override
  String get passwordHint => 'आपला पासवर्ड प्रविष्ट करा';

  @override
  String get loginWithOtpInstead => 'OTP से लॉगिन करा';

  @override
  String get loginWithPasswordInstead => 'पासवर्ड से लॉगिन करा';

  @override
  String get otpLoginTitle => 'OTP से लॉगिन';

  @override
  String get otpLoginSubtitle =>
      'OTP मिळवण्यासाठी आपला मोबाईल नंबर प्रविष्ट करा.';

  @override
  String get otpLabel => 'OTP';

  @override
  String get sendOtp => 'OTP पाठवा';

  @override
  String get verifyAndLogin => 'सत्यापित करा आणि लॉगिन करा';

  @override
  String get otpSent => 'OTP तुमच्या मोबाईलवर पाठवला';

  @override
  String get enterOtp => 'OTP प्रविष्ट करा';

  @override
  String get enterValidMobile => 'वैध मोबाईल नंबर प्रविष्ट करा';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get language => 'भाषा';

  @override
  String get appLanguage => 'अॅप भाषा';

  @override
  String get account => 'खाते';

  @override
  String get logOut => 'लॉग आउट';

  @override
  String get deleteAccount => 'खाते हटवा';

  @override
  String get legal => 'कायदेश';

  @override
  String get termsAndConditions => 'नियम आणि अट';

  @override
  String get privacyPolicy => 'गोपनीयता धोरण';

  @override
  String get about => 'बद्दल';

  @override
  String get appVersion => 'कृषिदnya v1.0.0';

  @override
  String get logOutConfirmTitle => 'लॉग आउट';

  @override
  String get logOutConfirmMessage => 'तुम्हाला नक्की लॉग आउट करू इच्छित?';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get tellUsAboutFarm => 'आमच्या शेताबद्दल सांगा';

  @override
  String get soilType => 'मातीचा प्रकार';

  @override
  String get season => 'हंगाम';

  @override
  String get farmAreaAcres => 'शेत क्षेत्र (एकर)';

  @override
  String get wateringMethod => 'सिंचाई पद्धत';

  @override
  String get getTop4Crops => 'शीर्ष 4 पिकां मिळवा';

  @override
  String get topCropPicks => 'शीर्ष पिकां निवडण';

  @override
  String get weatherAnalysis => 'हवामान विश्लेषण';

  @override
  String get temperature => 'तापमान';

  @override
  String get humidity => 'आर्द्रता';

  @override
  String get expectedRain => 'अपेक्षित पाऊस';

  @override
  String get whyGrow => 'का वाढवे';

  @override
  String get waterRequired => 'पाणी आवश्यक';

  @override
  String get daysToHarvest => 'कापण्यापर्यंत दिवस';

  @override
  String get growingPeriod => 'वाढण कालावधी';

  @override
  String get expectedProfit => 'अपेक्षित नफा';

  @override
  String get scanYourCrop => 'तुमचे पिकां स्कॅन करा';

  @override
  String get scanCropHelpText =>
      'प्रभावित पानांचे फोटो काढा. आमचा AI रोग ओळखा आणि अचूक डोसेज आणि रासायनिक उपचार सुचवा.';

  @override
  String get analyzingCropImage => 'पिकां प्रतिमा विश्लेषण...';

  @override
  String get takePhoto => 'फोटो काढा';

  @override
  String get camera => 'कॅमेरा';

  @override
  String get gallery => 'गॅलरी';

  @override
  String get organicCureRecommended => 'अर्गॅनिक उपचार (शिफारिशीत)';

  @override
  String get chemicalCure => 'रासायनिक उपचार';

  @override
  String get recommendedProducts => 'शिफारिशीत उत्पादने';

  @override
  String get dosageLabel => 'डोस';

  @override
  String confidenceLabel(String value) {
    return 'विश्वार्य: $value';
  }

  @override
  String get crop => 'पिकां';

  @override
  String get stateLabel => 'राज्य';

  @override
  String get favorites => 'आवडत';

  @override
  String get recent => 'अलीक';

  @override
  String get fetchTodaysPrices => 'आजचे भाव आणा';

  @override
  String get saveCropToFavorites => 'पिकां आवडत मध्ये जता';

  @override
  String get addedToFavorites => 'आवडत मध्ये जोडले';

  @override
  String get noPriceData =>
      'या पिकां आणि राज्यासाठी कोणतीही किंमत डेटा सापडले नाही.';

  @override
  String get todaysMarketRates => 'आजचे बाजार दर';

  @override
  String get marketLabel => 'बाजार';

  @override
  String get listItem => 'वस्तू जोडा';

  @override
  String get listItemTooltip => 'वस्तू जोडा';

  @override
  String get noListingsYet => 'अजून कोणतीही वस्तू नाही';

  @override
  String get marketplaceEmptySubtitle =>
      'ट्रॅ्टर, बीज, किंवा जोडण्यासाठी पहिले वस्तू जोडा.';

  @override
  String get listAnItem => 'वस्तू जोडा';

  @override
  String get rent => 'भाडेवर';

  @override
  String get sell => 'विक्री';

  @override
  String get itemName => 'वस्तूचे नाव';

  @override
  String get categoryHint => 'श्रेण (मशीनेरी, पशुपालन, बीज...)';

  @override
  String get price => 'किंमत';

  @override
  String get unitHint => 'युनिट (दिवस, किलो, तुकडा)';

  @override
  String get contactPhone => 'संपर्क फोन';

  @override
  String get description => 'वर्णन';

  @override
  String get enterNameAndPrice => 'नाव आणि किंमत प्रविष्ट करा';

  @override
  String get itemListedSuccess => 'वस्तू यशस्यरितपणे जोडले!';

  @override
  String get contactSeller => 'विक्रेता संपर्क करा';

  @override
  String get noContactAvailable => 'संपर्क उपलब्ध नाही';

  @override
  String get couldNotOpenDialer => 'फोन डायलर उघडू शकले नाही';

  @override
  String get history => 'इतिहास';

  @override
  String get export => 'निर्यात';

  @override
  String get farmHistoryTitle => 'तुमचा शेत इतिहास';

  @override
  String get farmHistorySubtitle =>
      'आदल्या पिकां स्कॅन, माती चाचणे आणि शिफारिशा येथे दिसत.';

  @override
  String get noHistoryYet => 'अजून इतिहास नाही';

  @override
  String get noHistorySubtitle =>
      'इतिहास तयार करण्यासाठी पिकां स्कॅन करा किंवा शिफारिशा मिळवा.';

  @override
  String get farmAnalytics => 'शेत विश्लेषण';

  @override
  String get syncToCloud => 'क्लाउड सिंक करा';

  @override
  String get farmDataSynced => 'शेत डेटा सिंक झाले';

  @override
  String get addCrop => 'पिकां जोडा';

  @override
  String get digitalFarmNotebook => 'तुमचा डिजिटल शेट नोटबुक';

  @override
  String get digitalFarmNotebookSubtitle =>
      'लागवडणी, खत, मजुरी, छिडकाव आणि कापण खर्च ट्रॅक करा.';

  @override
  String get digitalFarmNotebookSubtitleLong =>
      'लागवडणी, खत, मजुरी, छिडकाव आणि कापण खर्च ट्रॅक करा. प्रति पिकां नफा आणि मार्जिन स्वयंचालित करा.';

  @override
  String get monthlyIncome => 'मासिक उत्पन्न';

  @override
  String get monthlyIncomeSubtitle => 'या महिन्याती कापलेल्या पिकांपासून';

  @override
  String get cropName => 'पिकांचे नाव';

  @override
  String get areaAcres => 'क्षेत्र (एकर)';

  @override
  String get sowingDate => 'लागवडण तारीख (YYYY-MM-DD)';

  @override
  String get enterCropName => 'पिकांचे नाव प्रविष्ट करा';

  @override
  String acresSown(String area, String date) {
    return '$area एकर · लागवडल $date';
  }

  @override
  String profitLabel(String amount) {
    return 'नफा ₹$amount';
  }

  @override
  String get addExpense => 'खर्च जोडा';

  @override
  String get expenseType => 'प्रकार (खत, मजुरी, छिडकाव, जुताई)';

  @override
  String get amountLabel => 'रक्कम (₹)';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get saveExpense => 'खर्च सहेजा';

  @override
  String get recordHarvestSale => 'कापण आणि विक्री दर्ज करा';

  @override
  String get totalSellingValue => 'एकूण विक्री मूल्य (₹)';

  @override
  String get save => 'सहेजा';

  @override
  String get totalExpenses => 'एकूण खर्च';

  @override
  String get sellingValue => 'बिक्री मूल्य';

  @override
  String get profit => 'नफा';

  @override
  String get margin => 'मार्जिन';

  @override
  String get expenseBreakdown => 'खर्च विवरण';

  @override
  String get expenses => 'खर्च';

  @override
  String get noExpensesYet =>
      'No expenses recorded yet. Tap Add Expense to log costs.';

  @override
  String get searchSchemes => 'योजना शोधा';

  @override
  String get all => 'सर्व';

  @override
  String couldNotLoadSchemes(String error) {
    return 'योजना लोड करू शकले नाही: $error';
  }

  @override
  String get noSchemesMatch => 'तुमच्या शोधी कोणतीही योजना जुळत नाही';

  @override
  String applyForTitle(String title) {
    return '$title साठी अर्ज करा';
  }

  @override
  String get teamFillForm => 'आमची टीम तुमच्यासाठी फॉर्म भरेल';

  @override
  String get villageName => 'गावाचे नाव';

  @override
  String get submitApplication => 'अर्ज जमा करा';

  @override
  String get fillAllFields => 'कृपया सर्व फील्ड भरा';

  @override
  String get applicationSubmitted =>
      'अर्ज जमा झाले! आमची टीम तुमच्याशी संपर्क करेल.';

  @override
  String get details => 'तपशील';

  @override
  String get apply => 'अर्ज करा';

  @override
  String get schemeDetails => 'योजना तपशील';

  @override
  String couldNotLoadScheme(String error) {
    return 'योजना लोड करू शकले नाही: $error';
  }

  @override
  String get eligibility => 'पात्रता';

  @override
  String get benefits => 'फायदे';

  @override
  String get howToApply => 'कसे अर्ज करावे';

  @override
  String get applyNow => 'आता अर्ज करा';

  @override
  String get weatherForecast => 'हवामान पूर्वानुमान';

  @override
  String get updateLocationInProfile => 'प्रोफाइल मध्ये स्थान अपडेट करा';

  @override
  String get extendedForecast => '15-दिवसाचा विस्तृत पूर्वानुमान';

  @override
  String get forecastLoadingHint =>
      'तुमच्या स्थानापासून पूर्वानुमान डेटा लोड होत आहे. जर हे सुरू राहिले, तर प्रोफाइलमध्ये GPS निर्देशांक सेट केले आहेत ते सुनिश्चित करा.';

  @override
  String get notifications => 'सूचना';

  @override
  String get markAllRead => 'सर्व वाचले म्हणू';

  @override
  String get noNotifications => 'कोणतीही सूचना नाही';

  @override
  String get notificationsEmptySubtitle =>
      'हवामान अलर्ट, योजना अपडेट आणि समुदाय गतिविधी येथे दिसत.';

  @override
  String get allCaughtUp => 'सगळे पाहिले';

  @override
  String get noNewNotifications => 'तुमच्यासाठी कोणतीही नवीन सूचना नाही.';

  @override
  String get nearbyFarmers => 'जवळ शेतकर';

  @override
  String get nearbyUnavailable => 'जवळ शेतकर उपलब्ध नाही';

  @override
  String get noFarmersNearby => 'जवळ कोणतीही शेतकर नाही';

  @override
  String get updateLocationNearby =>
      'जवळ शेतकर शोधण्यासाठी प्रोफाइलमध्ये स्थान अपडेट करा.';

  @override
  String kmAway(String distance) {
    return '$distance किमी दूर';
  }

  @override
  String get harvestShort => 'कापण';

  @override
  String get clearChat => 'चॅट साफ करा';

  @override
  String get howCanHelpFarmToday => 'आज मी तुमच्या शेताची मदत कशी करू शकतो?';

  @override
  String get askAboutCropsWeatherDiseases =>
      'पिकां, हवामान, रोग किंवा सरकारी योजनांबद्दल विचारा.';

  @override
  String get listening => 'ऐकत आहे...';

  @override
  String get typeYourQuestion => 'तुमचा प्रश्न टाइप करा...';

  @override
  String get communityTitle => 'समुदाय';

  @override
  String get farmerCommunity => 'शेतकर समुदाय';

  @override
  String get farmerCommunitySubtitle =>
      'पिकां अपडेट सामाया करा, सुझाव द्या, आणि जवळ शेतकरांसोबत जुळा.';

  @override
  String get noPostsYet => 'अजून कोणतीही पोस्ट नाही';

  @override
  String get noPostsYetSubtitle =>
      'समुदायासोबत तुमचा पहिले शेत अपडेट सामाया करा.';

  @override
  String get shareUpdate => 'अपडेट सामाया करा';

  @override
  String get titleOptional => 'शीर्षक (वैकल्पिक)';

  @override
  String get category => 'श्रेण';

  @override
  String get whatsHappeningOnFarm => 'तुमच्या शेतावर काय होत आहे?';

  @override
  String get addPhoto => 'फोटो जोडा';

  @override
  String get photoSelected => 'फोटो निवडले';

  @override
  String get post => 'पोस्ट करा';

  @override
  String get writeSomethingToShare => 'सामाया करण्यासाठी काहीतर लिहा';

  @override
  String get commentsTitle => 'टिप्पण्या';

  @override
  String get noCommentsYet => 'अजून कोणतीही टिप्पणी नाही. पहिले बना!';

  @override
  String get addAComment => 'टिप्पणी जोडा';

  @override
  String get postComment => 'टिप्पणी पोस्ट करा';

  @override
  String get profileTitle => 'प्रोफाइल';

  @override
  String get krishidnyaAI => 'CropDoc AI';

  @override
  String get askAnythingAboutFarming => 'शेतीबद्दल काहीही प्रश्न विचारा';
}
