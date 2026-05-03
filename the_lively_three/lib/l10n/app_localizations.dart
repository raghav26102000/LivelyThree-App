import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_nl.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('nl')
  ];

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @signUpWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Email'**
  String get signUpWithEmail;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get signUpWithGoogle;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get continueWithEmail;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Your password is too weak. Use 8+ chars with a mix of cases, numbers, or symbols.'**
  String get weakPassword;

  /// No description provided for @botanically.
  ///
  /// In en, this message translates to:
  /// **'Botanically:'**
  String get botanically;

  /// No description provided for @fruit.
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get fruit;

  /// No description provided for @alsoKnownAs.
  ///
  /// In en, this message translates to:
  /// **'Also Known as:'**
  String get alsoKnownAs;

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'NA'**
  String get na;

  /// No description provided for @macroNutrients.
  ///
  /// In en, this message translates to:
  /// **'Macro Nutrients'**
  String get macroNutrients;

  /// No description provided for @gramsPer100g.
  ///
  /// In en, this message translates to:
  /// **'g /100g'**
  String get gramsPer100g;

  /// No description provided for @highestFirst.
  ///
  /// In en, this message translates to:
  /// **'Highest (1st)'**
  String get highestFirst;

  /// No description provided for @highestSecond.
  ///
  /// In en, this message translates to:
  /// **'Highest (2nd)'**
  String get highestSecond;

  /// No description provided for @microNutrients.
  ///
  /// In en, this message translates to:
  /// **'Micro Nutrients'**
  String get microNutrients;

  /// No description provided for @environmentalFootprint.
  ///
  /// In en, this message translates to:
  /// **'Environmental Footprint'**
  String get environmentalFootprint;

  /// No description provided for @carbon.
  ///
  /// In en, this message translates to:
  /// **'CARBON'**
  String get carbon;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @landUse.
  ///
  /// In en, this message translates to:
  /// **'LAND USE'**
  String get landUse;

  /// Shows the daily recommended value for a nutrient
  ///
  /// In en, this message translates to:
  /// **'Daily Recommended: {value}'**
  String dailyRecommended(String value);

  /// No description provided for @goodFor.
  ///
  /// In en, this message translates to:
  /// **'Good For: '**
  String get goodFor;

  /// No description provided for @mitigatesRisk.
  ///
  /// In en, this message translates to:
  /// **'Mitigates Risk: '**
  String get mitigatesRisk;

  /// No description provided for @totalPortions.
  ///
  /// In en, this message translates to:
  /// **'Total portions'**
  String get totalPortions;

  /// No description provided for @plantsForYou.
  ///
  /// In en, this message translates to:
  /// **'Plants for You'**
  String get plantsForYou;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @alphabetic.
  ///
  /// In en, this message translates to:
  /// **'Alphabetic'**
  String get alphabetic;

  /// No description provided for @highFiber.
  ///
  /// In en, this message translates to:
  /// **'High Fiber'**
  String get highFiber;

  /// No description provided for @highProtein.
  ///
  /// In en, this message translates to:
  /// **'High Protein'**
  String get highProtein;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noPlantsFound.
  ///
  /// In en, this message translates to:
  /// **'No plants found.'**
  String get noPlantsFound;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @cannotSelectFutureDate.
  ///
  /// In en, this message translates to:
  /// **'You cannot select a future date.'**
  String get cannotSelectFutureDate;

  /// No description provided for @weeklyTotal.
  ///
  /// In en, this message translates to:
  /// **'Weekly Total:'**
  String get weeklyTotal;

  /// No description provided for @portionSize.
  ///
  /// In en, this message translates to:
  /// **'Portion Size:'**
  String get portionSize;

  /// No description provided for @trackTodaysNutrients.
  ///
  /// In en, this message translates to:
  /// **'Track Today\'s Nutrients'**
  String get trackTodaysNutrients;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'THE LIVELY THREE'**
  String get appName;

  /// No description provided for @noPlantFound.
  ///
  /// In en, this message translates to:
  /// **'No plants found for this week.'**
  String get noPlantFound;

  /// No description provided for @fiberChallenge.
  ///
  /// In en, this message translates to:
  /// **'Fiber Challenge'**
  String get fiberChallenge;

  /// No description provided for @weeklyHealthScore.
  ///
  /// In en, this message translates to:
  /// **'Weekly Health Score'**
  String get weeklyHealthScore;

  /// No description provided for @yourScore.
  ///
  /// In en, this message translates to:
  /// **'Your Score'**
  String get yourScore;

  /// No description provided for @unlockCommunityScore.
  ///
  /// In en, this message translates to:
  /// **'Unlock Community Score'**
  String get unlockCommunityScore;

  /// No description provided for @communityLabel.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communityLabel;

  /// No description provided for @proteinChallenge.
  ///
  /// In en, this message translates to:
  /// **'Protein Challenge'**
  String get proteinChallenge;

  /// No description provided for @portionDaily.
  ///
  /// In en, this message translates to:
  /// **'5 Portions Daily'**
  String get portionDaily;

  /// No description provided for @portionDailyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Health points are earned for each day you eat at least 500g.\nAim for more!'**
  String get portionDailyTooltip;

  /// No description provided for @just.
  ///
  /// In en, this message translates to:
  /// **'Just'**
  String get just;

  /// No description provided for @portionLeftTooltip.
  ///
  /// In en, this message translates to:
  /// **'left to reach today\'s goal! One more little piece and you\'re there.'**
  String get portionLeftTooltip;

  /// No description provided for @plantDiversity.
  ///
  /// In en, this message translates to:
  /// **'Plant Diversity'**
  String get plantDiversity;

  /// No description provided for @plantDiversityTooltip.
  ///
  /// In en, this message translates to:
  /// **'Points are based on the 30 plants you eat each week. Additional plants support health, but their added impact is not measurable.\n'**
  String get plantDiversityTooltip;

  /// No description provided for @almostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost there!'**
  String get almostThere;

  /// No description provided for @plantLeftTooltip.
  ///
  /// In en, this message translates to:
  /// **'more plants and your gut will thank you.'**
  String get plantLeftTooltip;

  /// No description provided for @perColor.
  ///
  /// In en, this message translates to:
  /// **'3 Per Color'**
  String get perColor;

  /// No description provided for @perColorTooltip.
  ///
  /// In en, this message translates to:
  /// **'Get the full benefits: 3 plants per color means full points and diverse micronutrients.\n'**
  String get perColorTooltip;

  /// No description provided for @weeklyRainbow.
  ///
  /// In en, this message translates to:
  /// **'Your Rainbow Record'**
  String get weeklyRainbow;

  /// No description provided for @weeklyRainbowTooltip.
  ///
  /// In en, this message translates to:
  /// **'Week 33\nMinimum 3 plants per color means\nfull points and diverse micronutrients.'**
  String get weeklyRainbowTooltip;

  /// No description provided for @smartSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Smart Suggestions'**
  String get smartSuggestion;

  /// No description provided for @yourConsumption.
  ///
  /// In en, this message translates to:
  /// **'Your Consumptions'**
  String get yourConsumption;

  /// No description provided for @youAte.
  ///
  /// In en, this message translates to:
  /// **'You ate'**
  String get youAte;

  /// No description provided for @colorsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'colors this week,'**
  String get colorsThisWeek;

  /// No description provided for @addThemToYourList.
  ///
  /// In en, this message translates to:
  /// **'Add them to your list.'**
  String get addThemToYourList;

  /// No description provided for @plants.
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get plants;

  /// No description provided for @animalProducts.
  ///
  /// In en, this message translates to:
  /// **'Animal Products:'**
  String get animalProducts;

  /// No description provided for @upf.
  ///
  /// In en, this message translates to:
  /// **'Ultra-processed Food:'**
  String get upf;

  /// No description provided for @togo.
  ///
  /// In en, this message translates to:
  /// **'to go'**
  String get togo;

  /// No description provided for @trackNutrients.
  ///
  /// In en, this message translates to:
  /// **'Track Today\'s Nutrients'**
  String get trackNutrients;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @trackByColor.
  ///
  /// In en, this message translates to:
  /// **'Track by color,\nthrive with every portion'**
  String get trackByColor;

  /// No description provided for @discoverFoodImpact.
  ///
  /// In en, this message translates to:
  /// **'Discover how the food you eat supports your health from gut balance to energy levels. With simple tracking, colorful insights, and personalized goals, you\'ll build healthier habits one plant at a time.'**
  String get discoverFoodImpact;

  /// No description provided for @fiberUp.
  ///
  /// In en, this message translates to:
  /// **'Fiber up, feel good.'**
  String get fiberUp;

  /// No description provided for @dailyPortionSupport.
  ///
  /// In en, this message translates to:
  /// **'By keeping track of your daily portions, you ensure your body gets the consistent support it needs—helping you feel lighter, more energized, and healthier in the long run.'**
  String get dailyPortionSupport;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Started!'**
  String get letsGetStarted;

  /// No description provided for @ultraProcessed.
  ///
  /// In en, this message translates to:
  /// **'Ultra-processed'**
  String get ultraProcessed;

  /// No description provided for @foods.
  ///
  /// In en, this message translates to:
  /// **'Foods'**
  String get foods;

  /// No description provided for @animal.
  ///
  /// In en, this message translates to:
  /// **'Animal'**
  String get animal;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @moods.
  ///
  /// In en, this message translates to:
  /// **'Moods'**
  String get moods;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @personalizedPlantList.
  ///
  /// In en, this message translates to:
  /// **'Smart Suggested Plants'**
  String get personalizedPlantList;

  /// No description provided for @personalizedPlantListDesc.
  ///
  /// In en, this message translates to:
  /// **'This list is created just for you, based on your diet and goals. Discover tailored plant suggestions to boost your health and keep meals delicious.'**
  String get personalizedPlantListDesc;

  /// No description provided for @healthScorePortions.
  ///
  /// In en, this message translates to:
  /// **'Health Score Portions'**
  String get healthScorePortions;

  /// No description provided for @totalAnimalProducts.
  ///
  /// In en, this message translates to:
  /// **'Total Animal Products'**
  String get totalAnimalProducts;

  /// No description provided for @waterConsumption.
  ///
  /// In en, this message translates to:
  /// **'Water Consumption'**
  String get waterConsumption;

  /// No description provided for @ultraProcessedFoods.
  ///
  /// In en, this message translates to:
  /// **'Ultra-Processed Foods'**
  String get ultraProcessedFoods;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @fiber.
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get fiber;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbohydrate.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrate'**
  String get carbohydrate;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome To'**
  String get welcomeTo;

  /// No description provided for @createAccountPurpose.
  ///
  /// In en, this message translates to:
  /// **'Create an account to improve your personal health, support environmental care, and build digital trust.'**
  String get createAccountPurpose;

  /// No description provided for @tncCheckbox1.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to The Lively Three’s '**
  String get tncCheckbox1;

  /// No description provided for @tncCheckbox2.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get tncCheckbox2;

  /// No description provided for @tncCheckbox3.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get tncCheckbox3;

  /// No description provided for @tncCheckbox4.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy.'**
  String get tncCheckbox4;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @micronutrients.
  ///
  /// In en, this message translates to:
  /// **'Micronutrients'**
  String get micronutrients;

  /// No description provided for @sustainability.
  ///
  /// In en, this message translates to:
  /// **'Sustainability'**
  String get sustainability;

  /// No description provided for @verificationMailSent.
  ///
  /// In en, this message translates to:
  /// **'A new verification mail has been sent to your email account.'**
  String get verificationMailSent;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the code we have send to'**
  String get enterCode;

  /// No description provided for @enterEmailCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the email code'**
  String get enterEmailCode;

  /// No description provided for @verifiedProceedLogin.
  ///
  /// In en, this message translates to:
  /// **'The email has been verified. Proceed to login.'**
  String get verifiedProceedLogin;

  /// No description provided for @resendPin.
  ///
  /// In en, this message translates to:
  /// **'Resend pin (every 5 minutes)'**
  String get resendPin;

  /// No description provided for @resending.
  ///
  /// In en, this message translates to:
  /// **'Resending...'**
  String get resending;

  /// No description provided for @skipRemainingQuestions.
  ///
  /// In en, this message translates to:
  /// **'Do you want to skip all the remaining questions?'**
  String get skipRemainingQuestions;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get tellUsAboutYourself;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterUsername;

  /// No description provided for @micronutrientNote.
  ///
  /// In en, this message translates to:
  /// **'Micronutrient intake based on cultural cuisines vary regardless of location/country.'**
  String get micronutrientNote;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get selectCountry;

  /// No description provided for @moreAccurateExperience.
  ///
  /// In en, this message translates to:
  /// **'Do you want to have a more accurate and personal app experience?'**
  String get moreAccurateExperience;

  /// No description provided for @defaultProfileSet.
  ///
  /// In en, this message translates to:
  /// **'Your protein and fiber goals are being set to our default. Your profile will be set to the following:\n35 year-old, female, at 170cm,'**
  String get defaultProfileSet;

  /// No description provided for @defaultProfileNote.
  ///
  /// In en, this message translates to:
  /// **'and 65kg. These values are not reflective of your personal nutritional needs.'**
  String get defaultProfileNote;

  /// No description provided for @questionnaireUsage.
  ///
  /// In en, this message translates to:
  /// **'The answers to your questionnaire are used only for internal purposes to set your targets, showcase your progress, and share your community analytics. No personally identifiable information is shared.'**
  String get questionnaireUsage;

  /// No description provided for @fiberNeeds.
  ///
  /// In en, this message translates to:
  /// **'Fiber needs are tied to your lifestyle and goals.'**
  String get fiberNeeds;

  /// No description provided for @proteinNeeds.
  ///
  /// In en, this message translates to:
  /// **'Protein needs are tied to your weight, lifestyle, goals, and age.'**
  String get proteinNeeds;

  /// No description provided for @micronutrientNeeds.
  ///
  /// In en, this message translates to:
  /// **'Micronutrient requirements differ between sex, lifestyle, goals, and age.'**
  String get micronutrientNeeds;

  /// No description provided for @communityAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Our community analytics require your ethnicity and location to generate more accurate, inclusive, and personalisable recommendations and insights.'**
  String get communityAnalytics;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @whereDoYouLive.
  ///
  /// In en, this message translates to:
  /// **'Where do you live?'**
  String get whereDoYouLive;

  /// No description provided for @question_country.
  ///
  /// In en, this message translates to:
  /// **'Which country are you from?'**
  String get question_country;

  /// No description provided for @question_usage.
  ///
  /// In en, this message translates to:
  /// **'Needed for: timely nudges and suggestions, environmental scoring, and community building'**
  String get question_usage;

  /// No description provided for @question_username.
  ///
  /// In en, this message translates to:
  /// **'Please provide a user name.'**
  String get question_username;

  /// No description provided for @personalized_experience.
  ///
  /// In en, this message translates to:
  /// **'Do you want an app experience, tailored for you?'**
  String get personalized_experience;

  /// No description provided for @weekTotal.
  ///
  /// In en, this message translates to:
  /// **'Week Total'**
  String get weekTotal;

  /// No description provided for @onBoardingStaticPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Fiber up, feel good.'**
  String get onBoardingStaticPage1Title;

  /// No description provided for @onBoardingStaticPage1Desc.
  ///
  /// In en, this message translates to:
  /// **'Three simple rules towards balance, diversity, and a happy gut. Start with fi ber, optimize your nutrients, and improve your protein.'**
  String get onBoardingStaticPage1Desc;

  /// No description provided for @onBoardingStaticPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Eating, your biggest climate choice'**
  String get onBoardingStaticPage2Title;

  /// No description provided for @onBoardingStaticPage2Desc1.
  ///
  /// In en, this message translates to:
  /// **'Your meals shape more than your health, they shape the planet. We make the impact visible and guide you, step by step, to more sustainable eating.'**
  String get onBoardingStaticPage2Desc1;

  /// No description provided for @onBoardingStaticPage2Desc2.
  ///
  /// In en, this message translates to:
  /// **'The single most effective way you can reduce your footprint.'**
  String get onBoardingStaticPage2Desc2;

  /// No description provided for @onBoardingStaticPage3Title.
  ///
  /// In en, this message translates to:
  /// **'Your body, your data, your rules'**
  String get onBoardingStaticPage3Title;

  /// No description provided for @onBoardingStaticPage3Desc.
  ///
  /// In en, this message translates to:
  /// **'Ownership and sovereignty are built in. Your data stays yours, and you decide when to share and when not. By contributing, you help strengthen insights - keeping innovation open and value growing for everyone, with every bi/yte.'**
  String get onBoardingStaticPage3Desc;

  /// No description provided for @subscriptionDescText.
  ///
  /// In en, this message translates to:
  /// **'Track your health score, measure sustainability, and access expert insights on nutrients.'**
  String get subscriptionDescText;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get off;

  /// No description provided for @yearlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Yearly Plan:'**
  String get yearlyPlan;

  /// No description provided for @monthlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Monthly:'**
  String get monthlyPlan;

  /// No description provided for @alreadySubscribed.
  ///
  /// In en, this message translates to:
  /// **'Already subscribed'**
  String get alreadySubscribed;

  /// No description provided for @planNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Plan not available yet.'**
  String get planNotAvailable;

  /// No description provided for @personalized_experienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you want an app experience, tailored for you ?'**
  String get personalized_experienceTitle;

  /// No description provided for @personalized_experience1.
  ///
  /// In en, this message translates to:
  /// **'If yes, in the following onboarding, we will ask for specific details, which reflect your needs for fiber, micronutrients, and protein.'**
  String get personalized_experience1;

  /// No description provided for @personalized_experience2.
  ///
  /// In en, this message translates to:
  /// **'We use this to calculate targets, create personalized suggestions, or compile anonymous community analytics (if you opt in).'**
  String get personalized_experience2;

  /// No description provided for @personalized_experience3.
  ///
  /// In en, this message translates to:
  /// **'If not, here are the default values, which you still can change later.'**
  String get personalized_experience3;

  /// No description provided for @personalized_experience4.
  ///
  /// In en, this message translates to:
  /// **'Age: 35 years'**
  String get personalized_experience4;

  /// No description provided for @personalized_experience5.
  ///
  /// In en, this message translates to:
  /// **'Gender: female'**
  String get personalized_experience5;

  /// No description provided for @personalized_experience6.
  ///
  /// In en, this message translates to:
  /// **'Ethnicity: Caucasian'**
  String get personalized_experience6;

  /// No description provided for @personalized_experience7.
  ///
  /// In en, this message translates to:
  /// **'Weight: 65 kg'**
  String get personalized_experience7;

  /// No description provided for @personalized_experience8.
  ///
  /// In en, this message translates to:
  /// **'Height: 170 cm'**
  String get personalized_experience8;

  /// No description provided for @personalized_experience9.
  ///
  /// In en, this message translates to:
  /// **'Primary goal: General Health'**
  String get personalized_experience9;

  /// No description provided for @personalized_experience10.
  ///
  /// In en, this message translates to:
  /// **'Secondary goal: Longevity'**
  String get personalized_experience10;

  /// No description provided for @personalized_experience11.
  ///
  /// In en, this message translates to:
  /// **'All data stays under your control at all times.Nothing is shared without your informed consent.'**
  String get personalized_experience11;

  /// Subscription price label with period and trial text (always uses '-day trial' format)
  ///
  /// In en, this message translates to:
  /// **'{price} / {period} after {days}-day trial'**
  String pricing_billed_with_trial(String price, String period, int days);

  /// No description provided for @period_year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get period_year;

  /// No description provided for @period_month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get period_month;

  /// Shown under plan card when user has an active subscription
  ///
  /// In en, this message translates to:
  /// **'Next Billing Date {date}'**
  String subscription_line_with_date(String date);

  /// Summary line when no expiry/expired date is available.
  ///
  /// In en, this message translates to:
  /// **'You have subscribed to {plan}'**
  String subscription_line_no_date(String plan);

  /// No description provided for @unit_month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get unit_month;

  /// No description provided for @waterLabel.
  ///
  /// In en, this message translates to:
  /// **'* each full glass represents'**
  String get waterLabel;

  /// No description provided for @upfLabel.
  ///
  /// In en, this message translates to:
  /// **'* each full UPF represents'**
  String get upfLabel;

  /// No description provided for @consumptions.
  ///
  /// In en, this message translates to:
  /// **'Consumptions'**
  String get consumptions;

  /// No description provided for @addPlant.
  ///
  /// In en, this message translates to:
  /// **'Add Your Plants'**
  String get addPlant;

  /// No description provided for @plantmsg.
  ///
  /// In en, this message translates to:
  /// **'No Plants Found'**
  String get plantmsg;

  /// No description provided for @productmsg.
  ///
  /// In en, this message translates to:
  /// **'No Products Found'**
  String get productmsg;

  /// No description provided for @addAnimalProducts.
  ///
  /// In en, this message translates to:
  /// **'Add Animal Products'**
  String get addAnimalProducts;

  /// No description provided for @addUpf.
  ///
  /// In en, this message translates to:
  /// **'Add UPF'**
  String get addUpf;

  /// No description provided for @addWater.
  ///
  /// In en, this message translates to:
  /// **'Add Water'**
  String get addWater;

  /// No description provided for @upfTitle.
  ///
  /// In en, this message translates to:
  /// **'Ultra-Processed Foods'**
  String get upfTitle;

  /// No description provided for @animalProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Animal Products'**
  String get animalProductsTitle;

  /// No description provided for @defaultMsg.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get defaultMsg;

  /// No description provided for @addText.
  ///
  /// In en, this message translates to:
  /// **'Add Items'**
  String get addText;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @yourWeeklyConsistency.
  ///
  /// In en, this message translates to:
  /// **'Your Weekly Consistency'**
  String get yourWeeklyConsistency;

  /// No description provided for @evenlyEatPlants.
  ///
  /// In en, this message translates to:
  /// **'Shows how evenly you eat plants each week.'**
  String get evenlyEatPlants;

  /// No description provided for @moreBalanceScore.
  ///
  /// In en, this message translates to:
  /// **'More balance means a higher score.'**
  String get moreBalanceScore;

  /// No description provided for @yourMissingColors.
  ///
  /// In en, this message translates to:
  /// **'Your Missing Colors'**
  String get yourMissingColors;

  /// No description provided for @colorsYouCanAdd.
  ///
  /// In en, this message translates to:
  /// **'Colors (plants) you can still add this week and missed in past weeks.'**
  String get colorsYouCanAdd;

  /// No description provided for @colors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colors;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed!'**
  String get completed;

  /// No description provided for @communityWeeklyLeastEatenColors.
  ///
  /// In en, this message translates to:
  /// **'Community\'s Weekly Least Eaten Colors'**
  String get communityWeeklyLeastEatenColors;

  /// No description provided for @leastConsumedColors.
  ///
  /// In en, this message translates to:
  /// **'Least consumed 3 colors: % of all users & avg. portions per consumer.'**
  String get leastConsumedColors;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @topPlants.
  ///
  /// In en, this message translates to:
  /// **'Top Plants'**
  String get topPlants;

  /// No description provided for @topPlantsDesc.
  ///
  /// In en, this message translates to:
  /// **'Shows the community\'s top consumed plants.'**
  String get topPlantsDesc;

  /// No description provided for @lowPlants.
  ///
  /// In en, this message translates to:
  /// **'Low Plants'**
  String get lowPlants;

  /// No description provided for @lowPlantsDesc.
  ///
  /// In en, this message translates to:
  /// **'Shows the community\'s least consumed plants.'**
  String get lowPlantsDesc;

  /// No description provided for @weeklyPlantDiversityAverage.
  ///
  /// In en, this message translates to:
  /// **'Weekly Plant Diversity Average'**
  String get weeklyPlantDiversityAverage;

  /// No description provided for @youAndCommunityPlantAvg.
  ///
  /// In en, this message translates to:
  /// **'You and the community\'s plant variety average.'**
  String get youAndCommunityPlantAvg;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You:'**
  String get you;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Comm:'**
  String get community;

  /// No description provided for @weeklyAveragePortion.
  ///
  /// In en, this message translates to:
  /// **'Weekly Average Portion'**
  String get weeklyAveragePortion;

  /// No description provided for @portionAverageDesc.
  ///
  /// In en, this message translates to:
  /// **'Your and the community’s portion average.'**
  String get portionAverageDesc;

  /// No description provided for @seeYourHabits.
  ///
  /// In en, this message translates to:
  /// **'See Your Habits'**
  String get seeYourHabits;

  /// No description provided for @communityScore.
  ///
  /// In en, this message translates to:
  /// **'Community Score'**
  String get communityScore;

  /// No description provided for @highestScore.
  ///
  /// In en, this message translates to:
  /// **'Highest Score'**
  String get highestScore;

  /// No description provided for @yourTotalWeeklyWater.
  ///
  /// In en, this message translates to:
  /// **'Your total weekly water intake is {x} litres.'**
  String yourTotalWeeklyWater(double x);

  /// No description provided for @yourWaterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You’re aiming for 2 liters a day! Check this chart to see how close you are to hitting your hydration goal.'**
  String get yourWaterSubtitle;

  /// Shown when promo applies to a different plan
  ///
  /// In en, this message translates to:
  /// **'Promo code is valid for the {planName}'**
  String promo_product_mismatch_for_plan(String planName);

  /// No description provided for @promo_not_applicable_to_plan.
  ///
  /// In en, this message translates to:
  /// **'Promo code does not apply to this subscription plan'**
  String get promo_not_applicable_to_plan;

  /// No description provided for @promo_invalid.
  ///
  /// In en, this message translates to:
  /// **'Promo code is invalid'**
  String get promo_invalid;

  /// No description provided for @promo_already_used.
  ///
  /// In en, this message translates to:
  /// **'Promo code has already been used'**
  String get promo_already_used;

  /// No description provided for @promo_not_started.
  ///
  /// In en, this message translates to:
  /// **'Promo code is not yet active'**
  String get promo_not_started;

  /// No description provided for @promo_expired.
  ///
  /// In en, this message translates to:
  /// **'Promo code has expired'**
  String get promo_expired;

  /// No description provided for @promo_usage_limit_reached.
  ///
  /// In en, this message translates to:
  /// **'Promo code has reached its usage limit'**
  String get promo_usage_limit_reached;

  /// No description provided for @promo_invalid_or_expired.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired promo code'**
  String get promo_invalid_or_expired;

  /// No description provided for @keep_my_annual_plan.
  ///
  /// In en, this message translates to:
  /// **'Keep My Annual Plan'**
  String get keep_my_annual_plan;

  /// No description provided for @keep_my_monthly_plan.
  ///
  /// In en, this message translates to:
  /// **'Keep My Monthly Plan'**
  String get keep_my_monthly_plan;

  /// No description provided for @switch_to_annual_plan.
  ///
  /// In en, this message translates to:
  /// **'Switch To Annual Plan'**
  String get switch_to_annual_plan;

  /// No description provided for @cancel_subscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancel_subscription;

  /// No description provided for @plan_annual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get plan_annual;

  /// No description provided for @plan_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get plan_monthly;

  /// No description provided for @downgrade_warning.
  ///
  /// In en, this message translates to:
  /// **'You\'re already on the Annual plan. Downgrades to Monthly can only start next billing cycle.'**
  String get downgrade_warning;

  /// No description provided for @enter_coupon_code.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get enter_coupon_code;

  /// No description provided for @promo_enter_code.
  ///
  /// In en, this message translates to:
  /// **'Please enter a code'**
  String get promo_enter_code;

  /// No description provided for @promo_applied.
  ///
  /// In en, this message translates to:
  /// **'Promo code applied'**
  String get promo_applied;

  /// No description provided for @intro_title.
  ///
  /// In en, this message translates to:
  /// **'Know Your Impact. Improve Your Choices.'**
  String get intro_title;

  /// No description provided for @intro_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Real-time suggestions help you eat healthier and greener—powered by data you always control.'**
  String get intro_subtitle;

  /// No description provided for @manage_subscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manage_subscription;

  /// No description provided for @cancel_title.
  ///
  /// In en, this message translates to:
  /// **'Why are you canceling?'**
  String get cancel_title;

  /// No description provided for @cancel_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end your subscription?'**
  String get cancel_confirm_title;

  /// No description provided for @cancel_confirm_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your subscription will remain active until the end of the current billing period.'**
  String get cancel_confirm_subtitle;

  /// No description provided for @keep_subscription.
  ///
  /// In en, this message translates to:
  /// **'Keep Subscription'**
  String get keep_subscription;

  /// No description provided for @no_cancel_reasons.
  ///
  /// In en, this message translates to:
  /// **'No cancel reasons found.'**
  String get no_cancel_reasons;

  /// No description provided for @must_select_reason.
  ///
  /// In en, this message translates to:
  /// **'Please select a cancellation reason'**
  String get must_select_reason;

  /// No description provided for @cancel_failed_with_error.
  ///
  /// In en, this message translates to:
  /// **'Cancel failed: {error}'**
  String cancel_failed_with_error(String error);

  /// No description provided for @subscription_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled'**
  String get subscription_cancelled;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @applied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get applied;

  /// No description provided for @save_percent.
  ///
  /// In en, this message translates to:
  /// **'Save {percent}%'**
  String save_percent(int percent);

  /// No description provided for @best_deal.
  ///
  /// In en, this message translates to:
  /// **'Best Deal'**
  String get best_deal;

  /// No description provided for @checkingSubscription.
  ///
  /// In en, this message translates to:
  /// **'Checking Subscription...'**
  String get checkingSubscription;

  /// No description provided for @loadinghealthData.
  ///
  /// In en, this message translates to:
  /// **'Loading your health data...'**
  String get loadinghealthData;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available yet'**
  String get noDataAvailable;

  /// No description provided for @loadData.
  ///
  /// In en, this message translates to:
  /// **'Load Data'**
  String get loadData;

  /// No description provided for @week0.
  ///
  /// In en, this message translates to:
  /// **'Week 00'**
  String get week0;

  /// No description provided for @highestHealthScore.
  ///
  /// In en, this message translates to:
  /// **'Highest Health Score'**
  String get highestHealthScore;

  /// No description provided for @healthSoreStreak.
  ///
  /// In en, this message translates to:
  /// **'HEALTH SCORE STREAK'**
  String get healthSoreStreak;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// No description provided for @highestStreak.
  ///
  /// In en, this message translates to:
  /// **'Highest Streak'**
  String get highestStreak;

  /// No description provided for @plantDiversityStreak.
  ///
  /// In en, this message translates to:
  /// **'PLANT DIVERSITY STREAK'**
  String get plantDiversityStreak;

  /// No description provided for @colorStreak.
  ///
  /// In en, this message translates to:
  /// **'COLOR STREAK'**
  String get colorStreak;

  /// No description provided for @portionStreak.
  ///
  /// In en, this message translates to:
  /// **'PORTION STREAK'**
  String get portionStreak;

  /// No description provided for @grams.
  ///
  /// In en, this message translates to:
  /// **'Grams'**
  String get grams;

  /// No description provided for @healthScore.
  ///
  /// In en, this message translates to:
  /// **'Health Score'**
  String get healthScore;

  /// No description provided for @popupTitleExplore.
  ///
  /// In en, this message translates to:
  /// **'Know Your Impact. Improve Your Choices.'**
  String get popupTitleExplore;

  /// No description provided for @popupSubTitleExplore.
  ///
  /// In en, this message translates to:
  /// **'To explore the weekly health score, please subscribe and give permission to data access.'**
  String get popupSubTitleExplore;

  /// No description provided for @popupTitleSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Know Your Impact. Improve Your Choices.'**
  String get popupTitleSuggestion;

  /// No description provided for @popupSubTitleSuggestion.
  ///
  /// In en, this message translates to:
  /// **'To receive personalized suggestions, please subscribe and give permission to data access.'**
  String get popupSubTitleSuggestion;

  /// No description provided for @communitySubscribeMsg.
  ///
  /// In en, this message translates to:
  /// **'Please subscribe to use the community filters.'**
  String get communitySubscribeMsg;

  /// No description provided for @communityScoreFilter.
  ///
  /// In en, this message translates to:
  /// **'Community Score Filter'**
  String get communityScoreFilter;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @applyAllCommunity.
  ///
  /// In en, this message translates to:
  /// **'Apply filters to all community charts.'**
  String get applyAllCommunity;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @filterRequired.
  ///
  /// In en, this message translates to:
  /// **'Filter Required'**
  String get filterRequired;

  /// No description provided for @selectFilterText.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one filter before applying.'**
  String get selectFilterText;

  /// No description provided for @noStreakAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Streaks Available'**
  String get noStreakAvailable;

  /// No description provided for @popupTitleFilter.
  ///
  /// In en, this message translates to:
  /// **'Know Your Impact. Improve Your Choices.'**
  String get popupTitleFilter;

  /// No description provided for @popupSubTitleFilter.
  ///
  /// In en, this message translates to:
  /// **'Community filters are available for subscribed users, please subscribe and give permission to data access.'**
  String get popupSubTitleFilter;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @dayGoal.
  ///
  /// In en, this message translates to:
  /// **'day goal'**
  String get dayGoal;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for'**
  String get waiting;

  /// No description provided for @communityData.
  ///
  /// In en, this message translates to:
  /// **'community data'**
  String get communityData;
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
      <String>['de', 'en', 'fr', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
