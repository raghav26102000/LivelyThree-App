// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:the_lively_three/components/bottom_navbar/bottom_navbar_widget.dart';
import 'package:the_lively_three/components/filter_bottom_sheet/filter_bottom_sheet_widget.dart';
import 'package:the_lively_three/components/personalized_plant_list/personalized_plant_list_widget.dart';
import 'package:the_lively_three/components/progress_scaler/progress_scaler_widget.dart';
import 'package:the_lively_three/components/spider_chart/spider_chart_widget.dart';
import 'package:the_lively_three/components/your_consumption/your_consumption_widget.dart';
import 'package:the_lively_three/custom_code/widgets/gradient_button.dart';
import 'package:the_lively_three/custom_code/widgets/silver_button_widget.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_icon_button.dart';
import 'package:the_lively_three/models/plant_consumption_row.dart';
import 'package:the_lively_three/pages/low_micronutrients/low_micronutrients_widget.dart';
import 'package:the_lively_three/utils/create_community.dart';
import 'package:the_lively_three/utils/filters_preferences_service.dart';
import 'package:the_lively_three/utils/user_action_audit_service.dart';

import '../../backend/schema/structs/plants_summary_schema_struct.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/homepage.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'homepage_model.dart';
export 'homepage_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/components/bottom_navbar/bottom_navbar_widget.dart';
import '/l10n/app_localizations.dart';
import '/custom_code/actions/saveFcmTokenToSupabase.dart' as saveFcm;
import '/custom_code/actions/user_timezone_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomepageWidget extends StatefulWidget {
  const HomepageWidget({super.key});

  static String routeName = 'Homepage';
  static String routePath = '/homepage';

  @override
  State<HomepageWidget> createState() => _HomepageWidgetState();
}

class _HomepageWidgetState extends State<HomepageWidget> {
  late HomePageModel _model;
  final supabase = Supabase.instance.client;

  // Add these variables to your state class
  int _currentTabIndex = 0;
  final ScrollController _tabScrollController = ScrollController();

  Future<List<WeeklyselectedplantRow>>? _rainbowFuture;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final consumptionToday = FFAppState().weeklyConsumptionList.where((e) =>
      (e.day ?? '').toLowerCase() == FFAppState().currentDay.toLowerCase());
  final order = [
    'Red',
    'Orange',
    'Yellow',
    'Green',
    'Purple',
    'Brown',
    'White',
    'Grey'
  ];
  late List<PlantConsumptionRow> consumptionTodaySorted = [];
  late List<PlantConsumptionRow> consumptionSourceAnimal = [];
  late List<PlantConsumptionRow> consumptionSourceWater = [];
  late List<PlantConsumptionRow> consumptionSourceUPF = [];
  late List<PlantConsumptionRow> weekConsumption = [];

  /// Extract first 5 display names and percentage values
  List<String> features = [];
  List<double> data1 = [];
  bool _isNutrientDataLoading = true;
  bool _communityScoresLoaded = false;

  // Dataset A (e.g., User)
  final userData = [4.0, 3.5, 4.5, 2.0, 3.0];

  // Dataset B (e.g., Community)
  final communityData = [3.0, 4.0, 3.0, 4.0, 4.5];

  bool _loading = false;
  String? _error;
  bool _checkingSubscription = true;
  bool _hasValidSubscription = false;
  Map<int, double>? _communityScoreMap;
  bool _hasFilterPreferences = false;
  Map<String, dynamic>? _userFilterPreferences;
  bool _hasAgreementConsent = false;
  bool _checkingConsent = true;

  // Full week data from the view
  List<PlantConsumptionRow> _weekRows = [];
  Color colorFromTag(String? tag) {
    switch ((tag ?? '').toLowerCase()) {
      case 'red':
        return const Color(0xFFE53935);
      case 'orange':
        return const Color(0xFFF57C00);
      case 'yellow':
        return const Color(0xFFFBC02D);
      case 'green':
        return const Color(0xFF43A047);
      case 'purple':
        return const Color(0xFF8E24AA);
      case 'brown':
        return const Color(0xFF795548);
      case 'white':
        return const Color(0xFFBDBDBD);
      case 'grey':
      case 'gray':
        return const Color(0xFF9E9E9E);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  double portionsForDay(s, String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return s.totalPortionsMonday ?? 0;
      case 'tuesday':
        return s.totalPortionsTuesday ?? 0;
      case 'wednesday':
        return s.totalPortionsWednesday ?? 0;
      case 'thursday':
        return s.totalPortionsThursday ?? 0;
      case 'friday':
        return s.totalPortionsFriday ?? 0;
      case 'saturday':
        return s.totalPortionsSaturday ?? 0;
      case 'sunday':
        return s.totalPortionsSunday ?? 0;
      default:
        return 0;
    }
  }

  DateTime _selectedDate = DateTime.now();
  late DateTime _today;
  Map<int, int> colorConsumption = {};
  var screenName = 'HOME PAGE';
  final filterPreferencesService = FilterPreferencesService();
  final createCommunity = CreateCommunityService();
  bool _indicatorIdsLoaded = false;
  int getWeekOfYear(DateTime date) {
    // ISO 8601 week number calculation
    // Week 1 is the week with the first Thursday of the year

    // Find Thursday of this week
    final thursday =
        date.subtract(Duration(days: date.weekday - DateTime.thursday));

    // Find the first Thursday of the year
    final jan1 = DateTime(thursday.year, 1, 1);
    final firstThursday = jan1.weekday <= DateTime.thursday
        ? jan1.add(Duration(days: DateTime.thursday - jan1.weekday))
        : jan1.add(Duration(
            days: DateTime.daysPerWeek - jan1.weekday + DateTime.thursday));

    // Calculate week number
    final weekNumber =
        1 + ((thursday.difference(firstThursday).inDays / 7).floor());

    return weekNumber;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // Initialize with 0 instead of null
    _model.cweeklyHealthScore = 0.0;

    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _selectedDate = DateTime(now.year, now.month, now.day);

    int yearNumber = now.year;

    setState(() {
      FFAppState().calendarWeek = getWeekOfYear(_today);
      FFAppState().calendarYear = yearNumber;
      FFAppState().currentDay = DateFormat('yyyy-MM-dd').format(_selectedDate);
      FFAppState().currentDayNumber = _selectedDate.weekday;
    });

    // ✅ This is the main initialization - keep this
    _initializeHomePage();

    // REMOVE THESE LINES - they're duplicating work:
    // _checkUserSubscription();  // ❌ Remove - already in _initializeHomePage
    // _loadSavedPreferences();   // ❌ Remove - already in _initializeHomePage
    // fetchGlobalCommunityIndicators(); // ❌ Remove - already in _initializeHomePage

    // Keep these - they're not related to community scores
    _fetchWeeklyConsumption();
    print('fcm process starts');
    loadNutrientData();
    saveFcm.saveFcmTokenToSupabaseOnce();
    saveUserLocalTime(currentUserUid);

    _model.fiberChallengeMilestone =
        (FFAppState().userFiberValue) * (FFAppState().currentDayNumber);
    _model.updateFiberMilestoneFromAppState();

    safeSetState(() {});
    _fetchColorMappings();
    _fetchColorConsumption(
        currentUserUid, FFAppState().calendarWeek, FFAppState().calendarYear);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 1000,
        ),
      );
      _model.isPageReady = false;
      safeSetState(() {});

      _model.userDataOutput = await UsersTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'id',
          currentUserUid,
        ),
      );

      FFAppState().hasSubscription = valueOrDefault<bool>(
        _model.userDataOutput?.elementAtOrNull(0)?.hasSubscription,
        false,
      );

      FFAppState().birthday =
          _model.userDataOutput?.elementAtOrNull(0)?.birthdate;

      FFAppState().userProteinValue = valueOrDefault<double>(
        _model.userDataOutput?.elementAtOrNull(0)?.currentProteinValue,
        0.0,
      );
      FFAppState().userFiberValue = valueOrDefault<double>(
        _model.userDataOutput?.elementAtOrNull(0)?.currentFiberValue,
        0.0,
      );
      safeSetState(() {});

      await Future.wait([
        Future(() async {
          FFAppState().countrySelected = valueOrDefault<String>(
            _model.userDataOutput?.elementAtOrNull(0)?.country,
            'Undefined',
          );
          if (mounted) {
            setState(() {});
          }
        }),
        Future(() async {
          // Sets calendar week and calendar year immediately into FFAppstate variables.
          await actions.calculateWeekAndYear(
            getCurrentTimestamp,
          );

          _rainbowFuture = WeeklyselectedplantTable().queryRows(
            queryFn: (q) => q
                .eqOrNull('week', FFAppState().calendarWeek)
                .eqOrNull('id_user', currentUserUid)
                .eqOrNull('year', FFAppState().calendarYear),
          );
          // Extract the highest week number for subsequent comparaison with "currentWeek" and 1) initialize missing weeks in weeklyselectedplant if the highest week number is smaller than current week (returning user) or 2) a new user onboards and no week can be found. In that case "newUser" is set to true. This flag is used to guide user to "Settings / Plants"
          _model.weekCheck = await WeeklyselectedplantTable().queryRows(
            queryFn: (q) => q
                .eqOrNull(
                  'id_user',
                  currentUserUid,
                )
                .eqOrNull(
                  'week',
                  FFAppState().calendarWeek,
                )
                .eqOrNull(
                  'year',
                  FFAppState().calendarYear,
                )
                .order('year')
                .order('week'),
          );
          if (!(_model.weekCheck != null && (_model.weekCheck)!.isNotEmpty)) {
            // Initialize weeklyselectedplant entries for this user
            await actions.initializeWeeklySelectedPlants(
              currentUserUid,
              FFAppState().calendarWeek,
              FFAppState().calendarYear,
            );
          }
          // Indicator value check for the current week. Therefore, this action needs to follow the extraction of "calendarweek". Two indicators will be extracted, healthscoreweekly and communityhealthscoreweekly. Added after calendarweek extraction.
          await Future.wait([
            Future(() async {
              await actions.getWeeklyIndividualIndicatorsFlat(
                currentUserUid,
              );
            }),
            Future(() async {
              // extraction of healthscoreweekly indicator
              _model.healthscoreoutput =
                  await ViewIndividualIndicatorsValuesTable().queryRows(
                queryFn: (q) => q
                    .eqOrNull(
                      'id_user',
                      currentUserUid,
                    )
                    .eqOrNull(
                      'calendarweek',
                      FFAppState().calendarWeek,
                    )
                    .eqOrNull(
                      'indicatorname',
                      'healthscoreweekly_i',
                    )
                    .eqOrNull(
                      'calendaryear',
                      FFAppState().calendarYear,
                    ),
              );
              if ((_model.healthscoreoutput != null &&
                      (_model.healthscoreoutput)!.isNotEmpty) ==
                  false) {
                _model.weeklyHealthScore = 0.0;
                safeSetState(() {});
              } else {
                _model.weeklyHealthScore =
                    _model.healthscoreoutput?.firstOrNull?.value;
                safeSetState(() {});
                _model.progressColorValue = valueOrDefault<Color>(
                  () {
                    if (_model.weeklyHealthScore! < 25.0) {
                      return FlutterFlowTheme.of(context).redFill;
                    } else if (_model.weeklyHealthScore! < 50.0) {
                      return FlutterFlowTheme.of(context).orangeFill;
                    } else if (_model.weeklyHealthScore! < 75.0) {
                      return FlutterFlowTheme.of(context).yellowFill;
                    } else {
                      return FlutterFlowTheme.of(context).greenFill;
                    }
                  }(),
                  Color(0xFF1735D4),
                );
                safeSetState(() {});
              }
            }),
            // Future(() async {
            //   // extraction of healthscoreweekly indicator
            //   _model.cHealthscoreoutput =
            //       await ViewCommunityIndicatorsTable().queryRows(
            //           queryFn: (q) => q
            //               .eqOrNull(
            //                 'calendarweek',
            //                 FFAppState().calendarWeek,
            //               )
            //               .eqOrNull(
            //                 'calendaryear',
            //                 FFAppState().calendarYear,
            //               ));
            //   if ((_model.cHealthscoreoutput != null &&
            //           (_model.cHealthscoreoutput)!.isNotEmpty) ==
            //       false) {
            //     _model.cweeklyHealthScore = 0.0;
            //     safeSetState(() {});
            //   } else {
            //     _model.cweeklyHealthScore =
            //         _model.cHealthscoreoutput?.firstOrNull?.value;
            //     safeSetState(() {});
            //   }
            // }),
          ]);
        }),
        Future(() async {
          await actions.detectScreenCategory(
            context,
          );
        }),
        Future(() async {
          _model.currentDay = await actions.extractDayOfTheWeek();
          FFAppState().currentDay = _model.currentDay!;
          safeSetState(() {});
          await _model.isDay(context);
          _model.dayPageViewIndex = () {
            if (FFAppState().currentDay == 'Monday') {
              return 0;
            } else if (FFAppState().currentDay == 'Tuesday') {
              return 1;
            } else if (FFAppState().currentDay == 'Wednesday') {
              return 2;
            } else if (FFAppState().currentDay == 'Thursday') {
              return 3;
            } else if (FFAppState().currentDay == 'Friday') {
              return 4;
            } else if (FFAppState().currentDay == 'Saturday') {
              return 5;
            } else {
              return 6;
            }
          }();
          safeSetState(() {});
        }),
        Future(() async {
          _model.dateRangeOutput = await actions.getWeekRange();
        }),
        Future(() async {
          await actions.getPlantSummaryUpdate(
            FFAppState().calendarWeek,
            FFAppState().calendarYear,
            currentUserUid,
          );
        }),
        Future(() async {
          // Creation of the app state "weeklyPlantList" custom data type variable to populate "Homepage"
          await actions.getConsumptionDetailUpdate(
            FFAppState().calendarWeek,
            currentUserUid,
            FFAppState().calendarYear,
          );
        }),
        Future(() async {
          await _model.dayPageViewController?.animateToPage(
            () {
              if (FFAppState().currentDay == 'Monday') {
                return 0;
              } else if (FFAppState().currentDay == 'Tuesday') {
                return 1;
              } else if (FFAppState().currentDay == 'Wednesday') {
                return 2;
              } else if (FFAppState().currentDay == 'Thursday') {
                return 3;
              } else if (FFAppState().currentDay == 'Friday') {
                return 4;
              } else if (FFAppState().currentDay == 'Saturday') {
                return 5;
              } else {
                return 6;
              }
            }(),
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }),
        Future(() async {
          _model.consentedIndicatorsOutput =
              await ViewUserConsentedIndicatorsTable().queryRows(
            queryFn: (q) => q.eqOrNull(
              'userid',
              currentUserUid,
            ),
          );
          _model.cweeklyhealthscoreConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'healthscoreweekly_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );
          _model.cweeklyFiberScoreConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'fibertrackerweekly_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );

          _model.cweeklyProteinScoreConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'proteintrackerweekly_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );

          safeSetState(() {});
        }),
        Future(() async {
          _model.mostRecentWeightOutput = await UserVitalsTable().queryRows(
            queryFn: (q) => q
                .eqOrNull(
                  'user_id',
                  currentUserUid,
                )
                .eqOrNull(
                  'vital_type',
                  'Weight',
                )
                .order('updated_at'),
          );
          _model.hasWeightValue = true;
          _model.weightValue = valueOrDefault<double>(
            _model.mostRecentWeightOutput?.firstOrNull?.value,
            0.0,
          );
          _model.proteinDailyRecommended = valueOrDefault<double>(
            valueOrDefault<double>(
                  FFAppState().currentDayNumber.toDouble(),
                  0.0,
                ) *
                valueOrDefault<double>(
                  _model.weightValue,
                  0.0,
                ) *
                FFAppState().userProteinValue,
            0.0,
          );
          _model.fiberDailyRecommended = valueOrDefault<double>(
            valueOrDefault<double>(
                  FFAppState().currentDayNumber.toDouble(),
                  0.0,
                ) *
                FFAppState().userFiberValue,
            0.0,
          );
          safeSetState(() {});
          _model.isPageReady = true;
          safeSetState(() {});
        }),
        // Future(() async {
        //   final prefs = await SharedPreferences.getInstance();
        //   await prefs.setBool('onboarding0_seen', true);
        // }),
      ]);

      // Future.microtask(() async {
      //   final prefs = await SharedPreferences.getInstance();
      //   final hasSeen = prefs.getBool('onboarding0_seen') ?? false;

      //   if (!hasSeen) {
      //     await prefs.setBool('onboarding0_seen', true);
      //     print("🎉 onboarding0_seen set TRUE (first home load)");
      //   }
      // });

      try {
        // Fetch user's birthdate first
        final userRecord = await UsersTable().queryRows(
          queryFn: (rows) => rows.eqOrNull('id', currentUserUid),
        );

        if (userRecord.isNotEmpty) {
          final user = userRecord.first;
          final birthdateString =
              user.birthdate; // Assuming it's stored as ISO string or DateTime
          if (birthdateString != null &&
              birthdateString.toString().isNotEmpty) {
            final birthdate = DateTime.parse(birthdateString.toString());

            // Calculate age
            final now = DateTime.now();
            int age = now.year - birthdate.year;
            if (now.month < birthdate.month ||
                (now.month == birthdate.month && now.day < birthdate.day)) {
              age--;
            }

            // Update user record with age + onboarding info
            await UsersTable().update(
              data: {'age': age},
              matchingRows: (rows) => rows.eqOrNull('id', currentUserUid),
            );

            print('✅ User age ($age) calculated');
          } else {
            print('⚠️ Birthdate is missing for user $currentUserUid');
          }
        } else {
          print('⚠️ No user found with id $currentUserUid');
        }
      } catch (e) {
        print('❌ Error updating user age and onboarding: $e');
      }

      FutureBuilder<List<WeeklyselectedplantRow>>(
        future: _rainbowFuture,
        builder: (context, snapshot) {
          var l10n = AppLocalizations.of(context)!;
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data to load, you can show a loading indicator
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there was an error while fetching data, you can show an error message
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If no data is available, show a message
            return Text(l10n.noPlantFound);
          } else {
            // If data is available, build the dots using the data
            List<WeeklyselectedplantRow> plants = snapshot.data!;

            // Use the plants data to build color dots (assuming you need to get the color of plants from this data)
            return _buildProgressDots(
              color:
                  Colors.green, // Example: you can use the plant's color here
              totalDots: 20, // plants.length,
              filledCount: plants.where((p) => p.portionsum! > 0).length,
              // halfCompletedCount: plants
              //     .where((p) => p.portionsum! > 0 && p.portionsum! <= 0.5)
              //     .length,
            );
          }
        },
      );

      _model.isPageReady = true;
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _initializeHomePage() async {
    try {
      debugPrint('🚀 Starting home page initialization (OPTIMIZED)...');

      // 🔥 SET LOADING STATE
      setState(() {
        _communityScoresLoaded = false;
      });

      // Run independent operations in parallel
      final results = await Future.wait([
        _checkUserSubscription(),
        checkAgreementConsent(currentUserUid),
        fetchGlobalCommunityIndicators(),
      ]);

      final hasAgreementConsent = results[1] as bool;
      _hasAgreementConsent = hasAgreementConsent;

      debugPrint('✅ Parallel operations complete');

      // Verify indicator IDs are valid
      if (!_indicatorIdsLoaded) {
        debugPrint('⚠️ Indicator IDs not loaded, waiting...');
        await Future.delayed(Duration(milliseconds: 100));
      }

      // 🔥 MODIFIED: Always load global scores first, but don't show them yet
      if (_model.cweeklyHealthScoreId != null) {
        if (_hasAgreementConsent) {
          // If user has consent, wait for filtered scores
          await _loadSavedPreferences();

          if (_hasFilterPreferences && _userFilterPreferences != null) {
            debugPrint('📊 Fetching filtered community data...');
            await _fetchCommunityDataWithPreferences();
          } else {
            // No preferences, use global scores
            await _fetchGlobalCommunityScores();
          }
        } else {
          // No consent, load global scores (will be hidden in UI)
          await _fetchGlobalCommunityScores();
        }

        // 🔥 MARK COMMUNITY SCORES AS LOADED
        if (mounted) {
          setState(() {
            _communityScoresLoaded = true;
          });
        }
      }

      debugPrint('✅ Home page initialization complete');
    } catch (e, stackTrace) {
      debugPrint('❌ Error initializing home page: $e');

      // 🔥 EVEN ON ERROR, MARK AS LOADED TO SHOW UI
      if (mounted) {
        setState(() {
          _communityScoresLoaded = true;
        });
      }
    }
  }

  // 🔥 NEW: Load filtered community scores in background without blocking UI
  // Future<void> _loadFilteredCommunityScoresInBackground() async {
  //   try {
  //     debugPrint('🔄 Loading filtered community scores in background...');

  //     await _loadSavedPreferences();
  //     debugPrint('✅ Filter preferences loaded');

  //     if (_hasFilterPreferences && _userFilterPreferences != null) {
  //       debugPrint('📊 Fetching filtered community data...');
  //       await _fetchCommunityDataWithPreferences();
  //       debugPrint('✅ Filtered community data loaded (background)');
  //     } else {
  //       debugPrint('ℹ️ No filter preferences, keeping global scores');
  //     }
  //   } catch (e) {
  //     debugPrint('❌ Error loading filtered scores in background: $e');
  //     // Silently fail - global scores are already loaded
  //   }
  // }

  Future<void> _fetchGlobalCommunityScores() async {
    try {
      debugPrint('🌍 Fetching global community scores');

      if (_model.cweeklyHealthScoreId == null) {
        debugPrint('❌ Indicator IDs not loaded');
        return;
      }

      final Map<String, dynamic> response =
          await createCommunity.createCommunityWithUsers(
        age: -1,
        gender: -1,
        location: -1,
        ethnicity: -1,
      );

      final String? communityId = response["communityId"];
      globalCommunityId = communityId;
      final Map<int, double> globalValues =
          (response["indicators"] ?? {}) as Map<int, double>;

      debugPrint('📊 Received global community values: $globalValues');

      if (globalValues.isEmpty) {
        debugPrint('⚠️ No global community values found');
        return;
      }

      // 🔥 ONLY UPDATE STATE, DON'T MARK AS LOADED HERE
      if (mounted) {
        setState(() {
          _communityScoreMap = globalValues;
          _model.cweeklyHealthScore =
              globalValues[_model.cweeklyHealthScoreId] ?? 0.0;
          _model.cweeklyFiberScore =
              globalValues[_model.cweeklyFiberScoreId] ?? 0.0;
          _model.cweeklyProteinScore =
              globalValues[_model.cweeklyProteinScoreId] ?? 0.0;
        });

        debugPrint('✅ Global community scores loaded');
      }
    } catch (e) {
      debugPrint('❌ Error fetching global community scores: $e');
    }
  }

  Future<bool> checkAgreementConsent(String userId) async {
    try {
      // 1. Get party_id for this user
      final partyRes = await supabase
          .from('party')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      if (partyRes == null) {
        debugPrint('❌ No party found for this user.');
        return false;
      }

      final partyId = partyRes['id'];
      debugPrint('✅ Party ID: $partyId');

      // 2. Get the agreement record
      final agreementRes = await supabase
          .from('agreement')
          .select('id, name, status, effective_from, effective_to')
          .eq('code', 'WCI')
          .maybeSingle();

      if (agreementRes == null) {
        debugPrint('❌ Agreement "Weekly Community Indicators" not found.');
        return false;
      }

      final agreementId = agreementRes['id'];
      debugPrint('✅ Agreement ID: $agreementId');

      // 3. Check latest agreement_approval
      final approvalRes = await supabase
          .from('agreement_approval')
          .select('is_active, deactivated_at, occurred_at')
          .eq('agreement_id', agreementId)
          .eq('party_id', partyId)
          .order('occurred_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (approvalRes == null) {
        debugPrint('ℹ️ No approval record found - user has not consented yet');
        return false;
      }

      final bool isActive = approvalRes['is_active'] ?? false;
      final String? deactivatedAt = approvalRes['deactivated_at'];

      debugPrint('📋 Consent check:');
      debugPrint('   - is_active: $isActive');
      debugPrint('   - deactivated_at: $deactivatedAt');

      // === SIMPLIFIED LOGIC ===

      // 1. If is_active is TRUE → User has consented ✅
      if (isActive) {
        debugPrint('✅ CONSENTED: is_active = true');
        return true;
      }

      // 2. If is_active is FALSE, check deactivated_at
      if (!isActive) {
        // If deactivated_at is null, user has not consented
        if (deactivatedAt == null) {
          debugPrint(
              '❌ NOT CONSENTED: is_active = false, deactivated_at = null');
          return false;
        }

        // If deactivated_at exists, check if it's after current time
        try {
          final deactivatedDate = DateTime.parse(deactivatedAt);
          final now = DateTime.now();

          if (deactivatedDate.isAfter(now)) {
            debugPrint(
                '✅ CONSENTED: deactivated_at is in the future ($deactivatedAt)');
            return true;
          } else {
            debugPrint(
                '❌ NOT CONSENTED: deactivated_at is in the past ($deactivatedAt)');
            return false;
          }
        } catch (e) {
          debugPrint('⚠️ Error parsing deactivated_at: $e');
          return false;
        }
      }

      // Fallback
      debugPrint('⚠️ Unexpected state - defaulting to NOT consented');
      return false;
    } catch (e) {
      debugPrint('❌ Error checking agreement consent: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getAgreementConsentStatus(String userId) async {
    // 1. Get party_id for this user
    final partyRes = await supabase
        .from('party')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();

    if (partyRes == null) {
      print('No party found for this user.');
      return null;
    }

    final partyId = partyRes['id'];
    print('partid: $partyId');

    // 2. Get the agreement record with given name
    final agreementRes = await supabase
        .from('agreement')
        .select('id, name, status, effective_from, effective_to')
        .eq('name', 'Weekly Community Indicators')
        .maybeSingle();

    if (agreementRes == null) {
      print('Agreement not found.');
      return null;
    }

    final agreementId = agreementRes['id'];
    print('agreemantres: $agreementRes');

    // 3. Check latest agreement_approval for this user-party pair
    final approvalRes = await supabase
        .from('agreement_approval')
        .select('status, is_active, deactivated_at, occurred_at')
        .eq('agreement_id', agreementId)
        .eq('party_id', partyId)
        .order('occurred_at', ascending: false)
        .limit(1)
        .maybeSingle();

    print('approval res: $approvalRes');

    return {
      'agreement': agreementRes,
      'approval': approvalRes, // may be null if user never approved/rejected
    };
  }

  _getprogressColorValue(double progressValue) {
    if (progressValue! < 25.0) {
      return Color(0xffF28B82);
    } else if (progressValue! < 50.0) {
      return Color(0xffF99964);
    } else if (progressValue! < 75.0) {
      return Color(0xffFDDC6C);
    } else {
      return Color(0xFF7de8aa);
    }
  }

  Future<void> _checkUserSubscription() async {
    setState(() {
      _checkingSubscription = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('has_subscription, subscription_expires_at')
          .eq('id', currentUserUid)
          .single();

      final bool hasSubscription = response['has_subscription'] ?? false;
      final String? expiresAtStr = response['subscription_expires_at'];

      bool isValid = false;

      if (hasSubscription && expiresAtStr != null) {
        final expiresAt = DateTime.parse(expiresAtStr);
        final now = DateTime.now();
        isValid = expiresAt.isAfter(now);
      }

      debugPrint('🔐 Subscription status: $isValid');

      setState(() {
        _hasValidSubscription = isValid;
        FFAppState().hasSubscription = isValid;
        _checkingSubscription = false;
      });
    } catch (e) {
      debugPrint('❌ Error checking subscription: $e');
      setState(() {
        _checkingSubscription = false;
        _hasValidSubscription = false;
      });
    }
  }

  Future<void> _loadSavedPreferences() async {
    // Only load preferences if user has active consent
    if (!_hasAgreementConsent) {
      debugPrint('⚠️ No active consent - skipping preference loading');
      setState(() {
        _hasFilterPreferences = false;
        _userFilterPreferences = null;
      });
      return;
    }

    try {
      final preferences =
          await filterPreferencesService.loadFilterPreferences(currentUserUid);

      if (preferences != null) {
        debugPrint(
            '✅ Preferences are valid and apply_to_all_community is TRUE');

        setState(() {
          _hasFilterPreferences = true;
          _userFilterPreferences = preferences;
        });
      } else {
        debugPrint(
            '❌ Preferences invalid or apply_to_all_community is not TRUE');
        setState(() {
          _hasFilterPreferences = false;
          _userFilterPreferences = null;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading filter preferences: $e');
      setState(() {
        _hasFilterPreferences = false;
        _userFilterPreferences = null;
      });
    }
  }

// ============================================================
// UPDATE: _fetchCommunityDataWithPreferences with better error handling
// ============================================================

  Future<void> _fetchCommunityDataWithPreferences() async {
    if (_userFilterPreferences == null) {
      return;
    }

    try {
      final ageCode = _userFilterPreferences!['age_code'] ?? -1;
      final genderCode = _userFilterPreferences!['gender_code'] ?? -1;
      final locationCode = _userFilterPreferences!['location_code'] ?? -1;
      final ethnicityCode = _userFilterPreferences!['ethnicity_code'] ?? -1;

      debugPrint('🔍 Fetching community data with filters:');
      debugPrint('   Age: $ageCode, Gender: $genderCode');
      debugPrint('   Location: $locationCode, Ethnicity: $ethnicityCode');

      // Verify indicator IDs are available
      if (_model.cweeklyHealthScoreId == null) {
        debugPrint(
            '❌ Indicator IDs not loaded, cannot fetch filtered community scores');
        return;
      }

      debugPrint('   Indicator IDs available:');
      debugPrint('   - Health Score ID: ${_model.cweeklyHealthScoreId}');
      debugPrint('   - Fiber Score ID: ${_model.cweeklyFiberScoreId}');
      debugPrint('   - Protein Score ID: ${_model.cweeklyProteinScoreId}');

      // Call createCommunityWithUsers to get the community indicator values
      final Map<String, dynamic> communityValues =
          await createCommunity.createCommunityWithUsers(
        age: ageCode,
        gender: genderCode,
        location: locationCode,
        ethnicity: ethnicityCode,
      );

      debugPrint('📊 Received community values: $communityValues');

      if (communityValues.isEmpty) {
        debugPrint('⚠️ No community values found, keeping global scores');
        return;
      }

      // Update the state with the fetched community values
      if (mounted) {
        setState(() {
          _communityScoreMap = communityValues['indicators'];
          globalCommunityId = communityValues['communityId'];

          // ✅ CORRECT: Read from the 'indicators' map
          _model.cweeklyHealthScore =
              _communityScoreMap?[_model.cweeklyHealthScoreId] ?? 0.0;
          _model.cweeklyFiberScore =
              _communityScoreMap?[_model.cweeklyFiberScoreId] ?? 0.0;
          _model.cweeklyProteinScore =
              _communityScoreMap?[_model.cweeklyProteinScoreId] ?? 0.0;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error fetching community data with preferences: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      debugPrint('🔍 === _fetchCommunityDataWithPreferences END (error) ===');
    }
  }

  Future<void> fetchGlobalCommunityIndicators() async {
    final supabase = Supabase.instance.client;

    try {
      debugPrint('🔍 Fetching global community indicators...');

      // Step 1: Get the GLOBAL community ID
      final communityResponse = await supabase
          .from('community')
          .select('id, code, name')
          .eq('code', 'GLOBAL')
          .eq('status', 1)
          .maybeSingle();

      if (communityResponse == null) {
        debugPrint('⚠️ GLOBAL community not found');
        if (mounted) {
          setState(() {
            _model.cweeklyHealthScore = 0.0;
            _indicatorIdsLoaded = false;
          });
        }
        return;
      }

      final String communityId = communityResponse['id'];
      debugPrint('✅ Found GLOBAL community: $communityId');

      // Step 2: Fetch community indicator values to get indicator IDs
      final response = await supabase
          .from('community_indicator_values')
          .select('''
          id_indicator,
          value, 
          calendarweek, 
          calendaryear, 
          userindicators(name)
        ''')
          .eq('community_id', communityId)
          .eq('calendarweek', FFAppState().calendarWeek)
          .eq('calendaryear', FFAppState().calendarYear);

      if (response is! List) {
        debugPrint('❌ Unexpected response format: $response');
        return;
      }

      final List<Map<String, dynamic>> data =
          (response as List).cast<Map<String, dynamic>>();

      if (data.isEmpty) {
        debugPrint(
            '⚠️ No community indicator data found for week ${FFAppState().calendarWeek}, year ${FFAppState().calendarYear}');
        return;
      }

      // Map to store indicators by name
      final Map<String, dynamic> currentWeekIndicators = {};

      debugPrint('\n📊 ====== STORING INDICATOR IDs ======');
      for (final item in data) {
        final indicatorName =
            item['userindicators']?['name'] ?? 'unknown_indicator';
        final idIndicator = item['id_indicator'];
        final calendarWeek = item['calendarweek'];
        final calendarYear = item['calendaryear'];

        currentWeekIndicators[indicatorName] = {
          'week': calendarWeek,
          'year': calendarYear,
          'indicatorId': idIndicator,
        };

        debugPrint('  - $indicatorName: ID = $idIndicator');
      }

      // ✅ Assign indicator IDs - FIX: Store as int, not double
      if (mounted) {
        setState(() {
          // Convert to int explicitly
          _model.cweeklyHealthScoreId =
              currentWeekIndicators['healthscoreweekly_c']?['indicatorId']
                  as int?;
          _model.cweeklyFiberScoreId =
              currentWeekIndicators['fibertrackerweekly_c']?['indicatorId']
                  as int?;
          _model.cweeklyProteinScoreId =
              currentWeekIndicators['proteintrackerweekly_c']?['indicatorId']
                  as int?;

          _indicatorIdsLoaded = true; // Set flag
        });

        debugPrint('✅ Indicator IDs stored in state:');
        debugPrint('   Health Score ID: ${_model.cweeklyHealthScoreId}');
        debugPrint('   Fiber Score ID: ${_model.cweeklyFiberScoreId}');
        debugPrint('   Protein Score ID: ${_model.cweeklyProteinScoreId}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching global community indicators: $e');
      setState(() {
        _indicatorIdsLoaded = false;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

// 1. Add debug prints to _fetchColorConsumption
  _fetchColorConsumption(String userId, int week, int year) async {
    try {
      final client = Supabase.instance.client;
      final data = await client
          .from('dailyuserconsumption')
          .select('quantity, color')
          .eq('user_id', userId)
          .eq('calender_week', week)
          .eq('calender_year', year)
          .eq('dietary_source', 1)
          .order('color');

      print("🎨 Raw color consumption data: $data"); // DEBUG

      Map<int, int> totalColorConsumption = {};

      for (var item in data) {
        final int? color = item['color'] as int?;
        final int? quantity = item['quantity'] as int?;

        if (color != null && quantity != null) {
          totalColorConsumption[color] =
              (totalColorConsumption[color] ?? 0) + quantity;
        }
      }

      print("🎨 Processed colorConsumption: $totalColorConsumption"); // DEBUG

      if (mounted) {
        setState(() {
          colorConsumption = totalColorConsumption;
          _loading = false;
        });
      }
    } catch (e) {
      print('❌ Error fetching color consumption: $e');
    }
  }

// 2. Add debug prints to getFilledCountByColor
  int getFilledCountByColor(String colorName) {
    print("🔍 Looking for color: $colorName"); // DEBUG
    print("🔍 colorIdToName mappings: $colorIdToName"); // DEBUG
    print("🔍 colorConsumption data: $colorConsumption"); // DEBUG

    int? colorId = colorIdToName.entries
        .firstWhere((entry) => entry.value == colorName,
            orElse: () => MapEntry(0, ''))
        .key;

    print("🔍 Found colorId: $colorId for $colorName"); // DEBUG

    if (colorId == 0) {
      print("⚠️ Color ID not found for: $colorName"); // DEBUG
      return 0;
    }

    final count = colorConsumption[colorId] ?? 0;
    print(
        "🔍 Consumption count for $colorName (id: $colorId): $count"); // DEBUG
    return count;
  }

// 3. Ensure _fetchColorMappings completes and add debug
  Future<void> _fetchColorMappings() async {
    try {
      final client = Supabase.instance.client;

      final result = await client
          .from('codelkup')
          .select('keycode, key1, description')
          .eq('lkcode', 'rainbow_color')
          .eq('status', 1)
          .order('keycode');

      print("🗺️ Raw color mappings from DB: $result"); // DEBUG

      Map<int, String> mappings = {};
      for (var item in result) {
        final int keycode = item['keycode'] as int;
        final String colorName =
            item['key1'] as String? ?? item['description'] as String? ?? '';
        if (colorName.isNotEmpty) {
          mappings[keycode] = colorName;
        }
      }

      print("🗺️ Processed colorIdToName: $mappings"); // DEBUG

      setState(() {
        colorIdToName = mappings;
        _colorMappingLoaded = true;
      });
    } catch (e) {
      print('❌ Error fetching color mappings: $e');
      setState(() {
        colorIdToName = {
          1: 'Red',
          2: 'Orange',
          3: 'Yellow',
          4: 'Green',
          5: 'Purple',
          6: 'Brown',
          7: 'White',
        };
        _colorMappingLoaded = true;
      });
    }
  }

  Future<void> _fetchWeeklyConsumption() async {
    // optional: keep spinner
    // setState(() { _loading = true; _error = null; });

    try {
      final client = Supabase.instance.client;
      print('function called');

      // Use your real week/year or FFAppState
      final int calendarWeek = FFAppState().calendarWeek;
      final int calendarYear = FFAppState().calendarYear;

      final result = await client
          .from('vw_daily_plant_summary')
          .select('user_id, '
              'week, '
              'calendaryear, '
              'plantname, '
              'color, '
              'daynumber, '
              'portionsum, '
              'dateday, '
              'datemonth, '
              'uom, '
              'dietary_source,'
              'portionstaken')
          .eq('calendaryear', calendarYear)
          .eq('week', calendarWeek)
          .eq('user_id', currentUserUid);

      print('596: result length = ${result.length}');
      print(
          'raw rows: ${FFAppState().currentDayNumber}'); // prove the data is there

      final rows = result.map((e) => PlantConsumptionRow.fromMap(e)).toList();
      print('mapped rows: ${rows.map((r) => r.toJson()).toList()}');

      final consumptionToday = rows
          .where((e) => (e.dayNumber) == FFAppState().currentDayNumber)
          .toList();
      print("list length: ${consumptionToday.length}");
      final colorOrdered = order
          .expand((c) => consumptionToday.where((e) => (e.color ?? '') == c))
          .toList();

      // final consumptionSourcePlant = consumptionToday.where((e) => e.dietary_source == 1).toList();
      final consumptionSource2 =
          consumptionToday.where((e) => e.dietary_source == 2).toList();
      final consumptionSource3 =
          consumptionToday.where((e) => e.dietary_source == 3).toList();
      final consumptionSource4 =
          consumptionToday.where((e) => e.dietary_source == 4).toList();

      setState(() {
        _weekRows = rows;
        weekConsumption = rows;
        // If you previously had a getter, back it with a field instead:
        consumptionTodaySorted = colorOrdered;
        consumptionSourceAnimal = consumptionSource2;
        consumptionSourceWater = consumptionSource4;
        consumptionSourceUPF = consumptionSource3;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      print('fetch error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  double calculateTotalPortions(
    List<PlantConsumptionRow> data, {
    int? dietarySource,
  }) {
    if (data.isEmpty) return 0.0;

    double total = 0.0;
    for (final row in data) {
      if (dietarySource == null || row.dietary_source == dietarySource) {
        final portion = row.portionPlant ?? 0.0;
        if (portion.isNaN || portion.isInfinite) {
          print('Invalid portion value: $portion, skipping');
          continue;
        }
        total += portion;
      }
    }

    if (total.isNaN || total.isInfinite) {
      print('Total calculation resulted in NaN/Infinite, returning 0');
      return 0.0;
    }

    return total;
  }

  String _getDateDisplayText() {
    DateTime today = DateTime.now();
    DateTime todayDateOnly = DateTime(today.year, today.month, today.day);
    DateTime selectedDateOnly =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    if (selectedDateOnly.isAtSameMomentAs(todayDateOnly)) {
      return 'Today';
    } else {
      return DateFormat('dd MMM - EEE').format(_selectedDate);
    }
  }

  Map<int, String> colorIdToName = {};
  bool _colorMappingLoaded = false;

  void loadNutrientData() async {
    setState(() {
      _isNutrientDataLoading = true;
    });

    try {
      final result = await fetchWeeklyNutrientIntake(
        userId: currentUserUid,
        year: FFAppState().calendarYear,
        week: FFAppState().calendarWeek,
        locale: "en",
        dayNo: 1, //FFAppState().currentDayNumber
      );

      setState(() {
        features = List<String>.from(result['features']);
        data1 = List<double>.from(result['data1']);
        _isNutrientDataLoading = false;
      });

      print('Features: $features');
      print('Data1: $data1');
    } catch (e) {
      print("Error loading nutrient data: $e");
      setState(() {
        // Set default values on error
        features = ['N/A', 'N/A', 'N/A', 'N/A', 'N/A'];
        data1 = [0, 0, 0, 0, 0];
        _isNutrientDataLoading = false;
      });
    }
  }

// Update fetchWeeklyNutrientIntake to clear lists first:
  Future<Map<String, dynamic>> fetchWeeklyNutrientIntake({
    required String userId,
    required int year,
    required int week,
    required String locale,
    required int dayNo,
  }) async {
    final supabase = Supabase.instance.client;

    final response = await supabase.rpc(
      'get_weekly_nutrient_intake',
      params: {
        'p_user_id': userId,
        'p_year': year,
        'p_week': week,
        'p_locale': locale,
        'v_day_no': dayNo,
      },
    );

    if (response == null) {
      throw Exception('Supabase RPC returned null');
    }

    final data = response as List<dynamic>;

    // Create new lists instead of modifying existing ones
    List<String> newFeatures = [];
    List<double> newData1 = [];

    for (var item in data.take(5)) {
      newFeatures.add(item['displayname'] ?? 'N/A');
      newData1.add((item['percentage_consumption'] ?? 0).toDouble());
    }

    // Ensure we always have exactly 5 items
    while (newFeatures.length < 5) {
      newFeatures.add("N/A");
      newData1.add(0);
    }

    return {
      'features': newFeatures,
      'data1': newData1,
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: FlutterFlowTheme.of(context)
          .primaryBackground, // Set this to your app's background color
      statusBarIconBrightness: Brightness.dark, // For light icons in status bar
    ));
    var l10n = AppLocalizations.of(context);
    print('🎯 BUILD METHOD DEBUG:');
    print('   _model.cweeklyHealthScore = ${_model.cweeklyHealthScore}');
    print('   _hasValidSubscription = $_hasValidSubscription');
    print('   _checkingSubscription = $_checkingSubscription');
    print(
        '   communityScore (clamped) = ${((_model.cweeklyHealthScore ?? 0.0).clamp(0.0, 100.0)).round()}');
    final limitedLabels =
        features.length > 5 ? features.sublist(0, 5) : features;
    final limitedValues = data1.length > 5 ? data1.sublist(0, 5) : data1;

    context.watch<FFAppState>();
    // Safe local values for UI
    final double weeklyScore =
        ((_model.weeklyHealthScore ?? 0.0).clamp(0.0, 100.0)).toDouble();
    final double communityScore =
        ((_model.cweeklyHealthScore ?? 0.0).clamp(0.0, 100.0)).toDouble();

    print('   weeklyScore = $weeklyScore');
    print('   communityScore = $communityScore');

    final canShowCommunity = _hasValidSubscription;
    final portions = ((5 -
                (portionsForDay(
                    FFAppState().plantSummary, FFAppState().currentDay))) *
            100)
        .round();
    _model.plantsLeft =
        (30 - FFAppState().plantSummary.totalDistinctPlantsConsumed);
    _model.colorsLeft = (7 - FFAppState().plantSummary.colorsConsumed);

    // === Weekly Fiber Challenge values (dashboard parity) ===
    final double _userFiberSoFar = valueOrDefault<double>(
      FFAppState().individualIndicators.cwFiberTrackerValue,
      0.0,
    );

    final double _recommendedFiberSoFar = valueOrDefault<double>(
      valueOrDefault<double>(FFAppState().userFiberValue, 0.0) *
          valueOrDefault<int>(FFAppState().currentDayNumber, 0),
      0.0,
    );

    if (_model.isPageReady != true || !_communityScoresLoaded) {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    DateTime now = DateTime.now();

// Get Monday as start of the week (adjust if your start is Sunday)
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

// Format both dates
    String startFormatted = DateFormat('dd MMM').format(startOfWeek);
    String todayFormatted = DateFormat('dd MMM').format(now);

// Final string like "15 Sep - Today"
    String displayText = "$startFormatted - Today";
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        resizeToAvoidBottomInset: true,
        extendBody: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleSpacing: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  l10n.appName,
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'KoHo'),
                ),
              ),
              if (!_hasValidSubscription) ...[
                InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpgradeSubscriptionPage(
                            onSuccess: 'Home',
                            onFailure: 'Home',
                            openFullPage: true,
                          ),
                        ),
                      );
                    },
                    child: GradientButton(
                      text: 'Upgrade',
                      showIcon: false,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 10),
                      gradientEnd: Alignment.topLeft,
                      gradientBegin: Alignment.bottomRight,
                      borderRadius: 8,
                      margin: const EdgeInsets.only(
                          bottom: 12, right: 12, left: 12, top: 12),
                    )),
              ],
              // Positioned(
              //   right: 0,
              //   child: IconButton(
              //     icon: const Icon(Icons.account_circle_outlined,
              //         size: 20, color: Colors.black),
              //     onPressed: () async {
              //       await Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const SettingsNewPage(),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
          backgroundColor: const Color(0xffffffff),
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.09),
          toolbarHeight: 40,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            alignment: AlignmentDirectional(0.0, -1.0),
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 102),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        constraints: BoxConstraints(
                          maxHeight: FlutterFlowTheme.adjustScale(
                              size: 309, largeScreenMargin: 5),
                        ),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Stack(
                          alignment: AlignmentDirectional.topStart,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Column(
                                spacing: 12,
                                children: [
                                  // Tab buttons row
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8.0),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: SingleChildScrollView(
                                      controller: _tabScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SilverButton(
                                            buttonTitle: l10n.weeklyHealthScore,
                                            buttonFunction: () {
                                              setState(() {
                                                _currentTabIndex = 0;
                                              });
                                            },
                                            paddingVertical: 7,
                                            paddingHorizontal: 10,
                                            bgTransparent:
                                                _currentTabIndex != 0,
                                          ),
                                          SizedBox(width: 8.0),
                                          SilverButton(
                                            buttonTitle: l10n.fiberChallenge,
                                            buttonFunction: () {
                                              setState(() {
                                                _currentTabIndex = 1;
                                              });
                                            },
                                            paddingVertical: 7,
                                            paddingHorizontal: 10,
                                            bgTransparent:
                                                _currentTabIndex != 1,
                                          ),
                                          SizedBox(width: 8.0),
                                          SilverButton(
                                            buttonTitle: l10n.proteinChallenge,
                                            buttonFunction: () {
                                              setState(() {
                                                _currentTabIndex = 2;
                                              });
                                            },
                                            paddingVertical: 7,
                                            paddingHorizontal: 10,
                                            bgTransparent:
                                                _currentTabIndex != 2,
                                          ),
                                          SizedBox(width: 8.0),
                                          SilverButton(
                                            buttonTitle: 'Micronutrient',
                                            buttonFunction: () {
                                              setState(() {
                                                _currentTabIndex = 3;
                                              });
                                            },
                                            paddingVertical: 7,
                                            paddingHorizontal: 10,
                                            bgTransparent:
                                                _currentTabIndex != 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Stack(
                                    children: [
                                      // Tab content
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 0),
                                        child: IndexedStack(
                                          index: _currentTabIndex,
                                          children: [
                                            // Tab 0: Fiber Challenge
                                            _buildWeeklyHealthScoreTab(context,
                                                communityScore, weeklyScore),

                                            // Tab 1: Weekly Health Score
                                            _buildFiberChallengeTab(
                                                context,
                                                _userFiberSoFar,
                                                _model.cweeklyFiberScore),

                                            // Tab 2: Protein Challenge
                                            _buildProteinChallengeTab(context),

                                            // Tab 3: Micronutrient
                                            _buildMicronutrientTab(context),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 22,
                                        child: Column(
                                          spacing: 4,
                                          children: [
                                            SilverButton(
                                              circularShape: true,
                                              buttonFunction: () async {
                                                // 🔥 SHOW LOADING STATE DURING FILTER UPDATE
                                                setState(() {
                                                  _communityScoresLoaded =
                                                      false;
                                                });

                                                final result =
                                                    await showModalBottomSheet<
                                                        Map<String, dynamic>>(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder: (context) =>
                                                      FilterBottomSheetWidget(),
                                                );

                                                if (result != null && mounted) {
                                                  if (result[
                                                          'communityValue'] !=
                                                      null) {
                                                    setState(() {
                                                      _communityScoreMap =
                                                          result[
                                                              'communityValue'];
                                                      _model.cweeklyHealthScore =
                                                          _communityScoreMap?[_model
                                                                  .cweeklyHealthScoreId] ??
                                                              0.0;
                                                      _model.cweeklyFiberScore =
                                                          _communityScoreMap?[_model
                                                                  .cweeklyFiberScoreId] ??
                                                              0.0;
                                                      _model.cweeklyProteinScore =
                                                          _communityScoreMap?[_model
                                                                  .cweeklyProteinScoreId] ??
                                                              0.0;

                                                      // 🔥 MARK AS LOADED AFTER UPDATE
                                                      _communityScoresLoaded =
                                                          true;
                                                    });
                                                    print(
                                                        "Updated homepage with community score: $_communityScoreMap");
                                                  }
                                                } else {
                                                  // 🔥 USER CANCELLED - RESTORE LOADED STATE
                                                  setState(() {
                                                    _communityScoresLoaded =
                                                        true;
                                                  });
                                                }
                                              },
                                              hasIcon: true,
                                              iconWidget: Image.asset(
                                                'assets/icons/filter_icon.png',
                                                width: 16,
                                                height: 16,
                                              ),
                                              paddingHorizontal: 4,
                                              paddingVertical: 4,
                                            ),
                                            Text(
                                              'Count: ',
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              //                              CarouselSlider(
                              //                               items: [
                              //                                 Column(
                              //                                   mainAxisSize: MainAxisSize.max,
                              //                                   children: [
                              //                                     Text(
                              //                                       l10n.fiberChallenge,
                              //                                       style: FlutterFlowTheme.of(context)
                              //                                           .bodyMedium
                              //                                           .override(
                              //                                             font: GoogleFonts.montserrat(
                              //                                               fontWeight: FontWeight.bold,
                              //                                               fontStyle:
                              //                                                   FlutterFlowTheme.of(context)
                              //                                                       .bodyMedium
                              //                                                       .fontStyle,
                              //                                             ),
                              //                                             color:
                              //                                                 FlutterFlowTheme.of(context)
                              //                                                     .primary,
                              //                                             fontSize: 16.0,
                              //                                             letterSpacing: 0.0,
                              //                                             fontWeight: FontWeight.bold,
                              //                                             fontStyle:
                              //                                                 FlutterFlowTheme.of(context)
                              //                                                     .bodyMedium
                              //                                                     .fontStyle,
                              //                                           ),
                              //                                     ),
                              //                                     ScoreRulerWidget(
                              //                                         userScore: _userFiberSoFar,
                              //                                         communityScore: _communityFiberSoFar,
                              //                                         milestone: valueOrDefault<double>(
                              //                                           _model.fiberDailyRecommended,
                              //                                           0.0,
                              //                                         ).round(),
                              //                                         milestoneLabel: _model.mileStoneLabel,
                              //                                         hasConsent: (((FFAppState()
                              //                                                         .hasSubscription ==
                              //                                                     false) ||
                              //                                                 (_model.cweeklyFiberScoreConsent ==
                              //                                                     false))
                              //                                             ? false
                              //                                             : true),
                              //                                         currentColor: Color(0xffb8e07a)),
                              //                                     SilverButton(
                              //                                         buttonTitle: l10n.explore,
                              //                                         buttonFunction: () async {
                              //                                           final auditService =
                              //                                               UserActionAuditService(
                              //                                                   supabase);
                              //                                           await auditService.logUserAction(
                              //                                             userId: currentUserUid,
                              //                                             action: 'Explore Fiber score',
                              //                                             screenName: screenName,
                              //                                             userData: {
                              //                                               'week':
                              //                                                   FFAppState().calendarWeek,
                              //                                               'year':
                              //                                                   FFAppState().calendarYear,
                              //                                             },
                              //                                           );
                              //                                           context.pushNamed(
                              //                                             FiberExplorePage.routeName,
                              //                                             queryParameters: {
                              //                                               'exploreType': 'Fiber Challenge'
                              //                                             },
                              //                                             extra: <String, dynamic>{
                              //                                               kTransitionInfoKey:
                              //                                                   const TransitionInfo(
                              //                                                 hasTransition: true,
                              //                                                 transitionType:
                              //                                                     PageTransitionType.fade,
                              //                                               ),
                              //                                             },
                              //                                           );
                              //                                         })
                              //                                   ].divide(SizedBox(height: 10.0)),
                              //                                 ),
                              //                                 Column(
                              //                                   mainAxisSize: MainAxisSize.max,
                              //                                   children: [
                              //                                     Text(
                              //                                       l10n.weeklyHealthScore,
                              //                                       style: FlutterFlowTheme.of(context)
                              //                                           .bodyMedium
                              //                                           .override(
                              //                                             font: GoogleFonts.montserrat(
                              //                                               fontWeight: FontWeight.bold,
                              //                                               fontStyle:
                              //                                                   FlutterFlowTheme.of(context)
                              //                                                       .bodyMedium
                              //                                                       .fontStyle,
                              //                                             ),
                              //                                             color:
                              //                                                 FlutterFlowTheme.of(context)
                              //                                                     .primary,
                              //                                             fontSize: 16.0,
                              //                                             letterSpacing: 0.0,
                              //                                             fontWeight: FontWeight.bold,
                              //                                             fontStyle:
                              //                                                 FlutterFlowTheme.of(context)
                              //                                                     .bodyMedium
                              //                                                     .fontStyle,
                              //                                           ),
                              //                                     ),
                              //                                     Row(
                              //                                         crossAxisAlignment:
                              //                                             CrossAxisAlignment.center,
                              //                                         mainAxisAlignment:
                              //                                             MainAxisAlignment.center,
                              //                                         children: [
                              //                                           Stack(
                              //                                             clipBehavior: Clip.none,
                              //                                             alignment: AlignmentDirectional(
                              //                                                 0.0, 0.0),
                              //                                             children: [
                              //                                               Padding(
                              //                                                 padding: EdgeInsets.all(6.0),
                              //                                                 child:
                              //                                                     CircularPercentIndicator(
                              //                                                   percent:
                              //                                                       weeklyScore / 100.0,
                              //                                                   radius: 52.5,
                              //                                                   lineWidth: 12.0,
                              //                                                   animation: true,
                              //                                                   animateFromLastPercent:
                              //                                                       true,
                              //                                                   progressColor:
                              //                                                       _getprogressColorValue(
                              //                                                           weeklyScore),
                              //                                                   backgroundColor:
                              //                                                       Color(0xFFE5E5E5),
                              //                                                   circularStrokeCap:  CircularStrokeCap.round,
                              //                                                 ),
                              //                                               ),
                              //                                               Padding(
                              //                                                 padding: EdgeInsets.all(0.0),
                              //                                                 child:
                              //                                                     CircularPercentIndicator(
                              //                                                   percent:  (communityScore /
                              //                                                           100.0),
                              //                                                   // canShowCommunity
                              //                                                   //     ? (communityScore /
                              //                                                   //         100.0)
                              //                                                   //     : 0.0,
                              //                                                   radius: 66.0,
                              //                                                   lineWidth: 12.0,
                              //                                                   animation: true,
                              //                                                   animateFromLastPercent:
                              //                                                       true,
                              //                                                   progressColor:
                              //                                                       _getprogressColorValue(
                              //                                                           communityScore),
                              //                                                   backgroundColor:
                              //                                                       Color(0xFFE5E5E5),
                              //                                                       circularStrokeCap:  CircularStrokeCap.round,
                              //                                                 ),
                              //                                               ),
                              //                                               Align(
                              //                                                 alignment:
                              //                                                     AlignmentDirectional(
                              //                                                         0.0, 0.0),
                              //                                                 child: SingleChildScrollView(
                              //                                                   child: Column(
                              //                                                     mainAxisSize:
                              //                                                         MainAxisSize.max,
                              //                                                     children: [
                              //                                                       Text(
                              //                                                         l10n.yourScore,
                              //                                                         style: FlutterFlowTheme
                              //                                                                 .of(context)
                              //                                                             .bodyMedium
                              //                                                             .override(
                              //                                                               font: GoogleFonts
                              //                                                                   .montserrat(
                              //                                                                 fontWeight: FlutterFlowTheme.of(
                              //                                                                         context)
                              //                                                                     .bodyMedium
                              //                                                                     .fontWeight,
                              //                                                                 fontStyle: FlutterFlowTheme.of(
                              //                                                                         context)
                              //                                                                     .bodyMedium
                              //                                                                     .fontStyle,
                              //                                                               ),
                              //                                                               color: FlutterFlowTheme.of(
                              //                                                                       context)
                              //                                                                   .secondaryText,
                              //                                                               fontSize: 9,
                              //                                                               letterSpacing:
                              //                                                                   0.0,
                              //                                                               fontWeight: FlutterFlowTheme.of(
                              //                                                                       context)
                              //                                                                   .bodyMedium
                              //                                                                   .fontWeight,
                              //                                                               fontStyle: FlutterFlowTheme.of(
                              //                                                                       context)
                              //                                                                   .bodyMedium
                              //                                                                   .fontStyle,
                              //                                                             ),
                              //                                                       ),
                              //                                                       Row(
                              //                                                         mainAxisSize:
                              //                                                             MainAxisSize.max,
                              //                                                         mainAxisAlignment:
                              //                                                             MainAxisAlignment
                              //                                                                 .center,
                              //                                                         children: [
                              //                                                           Text(
                              //                                                             (_model.weeklyHealthScore
                              //                                                                     ?.floor())
                              //                                                                 .toString(),
                              //                                                             style: FlutterFlowTheme
                              //                                                                     .of(context)
                              //                                                                 .bodyMedium
                              //                                                                 .override(
                              //                                                                   font: GoogleFonts
                              //                                                                       .montserrat(
                              //                                                                     fontWeight:
                              //                                                                         FontWeight
                              //                                                                             .w600,
                              //                                                                     fontStyle: FlutterFlowTheme.of(
                              //                                                                             context)
                              //                                                                         .bodyMedium
                              //                                                                         .fontStyle,
                              //                                                                   ),
                              //                                                                   color: FlutterFlowTheme.of(
                              //                                                                           context)
                              //                                                                       .secondaryText,
                              //                                                                   fontSize:
                              //                                                                       20.0,
                              //                                                                   letterSpacing:
                              //                                                                       0.0,
                              //                                                                   fontWeight:
                              //                                                                       FontWeight
                              //                                                                           .w600,
                              //                                                                   fontStyle: FlutterFlowTheme.of(
                              //                                                                           context)
                              //                                                                       .bodyMedium
                              //                                                                       .fontStyle,
                              //                                                                 ),
                              //                                                           ),
                              //                                                           Text(
                              //                                                             '%',
                              //                                                             style: FlutterFlowTheme
                              //                                                                     .of(context)
                              //                                                                 .bodyMedium
                              //                                                                 .override(
                              //                                                                   font: GoogleFonts
                              //                                                                       .montserrat(
                              //                                                                     fontWeight: FlutterFlowTheme.of(
                              //                                                                             context)
                              //                                                                         .bodyMedium
                              //                                                                         .fontWeight,
                              //                                                                     fontStyle: FlutterFlowTheme.of(
                              //                                                                             context)
                              //                                                                         .bodyMedium
                              //                                                                         .fontStyle,
                              //                                                                   ),
                              //                                                                   color: FlutterFlowTheme.of(
                              //                                                                           context)
                              //                                                                       .secondaryText,
                              //                                                                   fontSize:
                              //                                                                       13.0,
                              //                                                                   letterSpacing:
                              //                                                                       0.0,
                              //                                                                   fontWeight: FlutterFlowTheme.of(
                              //                                                                           context)
                              //                                                                       .bodyMedium
                              //                                                                       .fontWeight,
                              //                                                                   fontStyle: FlutterFlowTheme.of(
                              //                                                                           context)
                              //                                                                       .bodyMedium
                              //                                                                       .fontStyle,
                              //                                                                 ),
                              //                                                           ),
                              //                                                         ],
                              //                                                       ),
                              //                                                     ],
                              //                                                   ),
                              //                                                 ),
                              //                                               ),
                              //                                               Positioned(
                              //                                                 top: -10,
                              //                                                 right: -10,
                              //                                                 child: SilverButton(
                              //                                                     circularShape: true,
                              //                                                    buttonFunction: () async {
                              //                 final result =
                              //                     await showModalBottomSheet<Map<String, dynamic>>(
                              //                   context: context,
                              //                   isScrollControlled: true,
                              //                   backgroundColor: Colors.transparent,
                              //                   builder: (context) => FilterBottomSheetWidget(),
                              //                 );
                              //                 if (result != null && result.containsKey('communityValue')) {
                              //                   setState(() {
                              //                     _model.cweeklyHealthScore = result[
                              //                         'communityValue']; // update your circular indicator
                              //                   });

                              //                   print('🎯 Updated community score: $communityScore');
                              //                 }
                              //               },
                              //                                                     hasIcon: true,
                              //                                                     iconWidget: Image.asset(
                              //                                                       'assets/icons/filter_icon.png',
                              //                                                       width: 16,
                              //                                                       height: 16,
                              //                                                     ),
                              //                                                     paddingHorizontal: 4,
                              //                                                     paddingVertical: 4),
                              //                                               )
                              //                                             ],
                              //                                           ),
                              //                                         ]),
                              //                                     Column(spacing: 8, children: [
                              //                                        Row(
                              //   mainAxisSize: MainAxisSize.max,
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   crossAxisAlignment: CrossAxisAlignment.end,
                              //   children: [
                              //     Text(
                              //       '${l10n.communityScore}: ',
                              //       style: FlutterFlowTheme.of(context)
                              //           .bodyMedium
                              //           .override(
                              //             font: GoogleFonts.montserrat(
                              //               fontWeight: FlutterFlowTheme.of(context)
                              //                   .bodyMedium
                              //                   .fontWeight,
                              //               fontStyle: FlutterFlowTheme.of(context)
                              //                   .bodyMedium
                              //                   .fontStyle,
                              //             ),
                              //             color: FlutterFlowTheme.of(context).primary,
                              //             fontSize: 10.0,
                              //             letterSpacing: 0.0,
                              //           ),
                              //     ),
                              //     Text(
                              //       '${(_model.cweeklyHealthScore ?? 0).floor()}%',
                              //       style: FlutterFlowTheme.of(context)
                              //           .bodyMedium
                              //           .override(
                              //             font: GoogleFonts.montserrat(
                              //               fontWeight: FontWeight.bold,
                              //               fontStyle: FlutterFlowTheme.of(context)
                              //                   .bodyMedium
                              //                   .fontStyle,
                              //             ),
                              //             color: FlutterFlowTheme.of(context).primary,
                              //             letterSpacing: 0.0,
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //     ),
                              //     // Show lock icon only for non-subscribers
                              //     // if (!_hasValidSubscription)
                              //     //   Padding(
                              //     //     padding: EdgeInsets.only(left: 4),
                              //     //     child: Icon(
                              //     //       Icons.lock_outline,
                              //     //       size: 12,
                              //     //       color: FlutterFlowTheme.of(context).secondaryText,
                              //     //     ),
                              //     //   ),
                              //   ],
                              // ),
                              //                                       // Builder(
                              //                                       //   builder: (context) {
                              //                                       //     return Visibility(
                              //                                       //       visible: canShowCommunity,
                              //                                       //       // If NOT visible, show the locked/blocked message:
                              //                                       //       replacement: Container(
                              //                                       //         width: 144,
                              //                                       //         padding:
                              //                                       //             const EdgeInsets.symmetric(
                              //                                       //                 horizontal: 8,
                              //                                       //                 vertical: 4),
                              //                                       //         decoration: BoxDecoration(
                              //                                       //           color: Colors.white,
                              //                                       //           borderRadius:
                              //                                       //               BorderRadius.circular(8),
                              //                                       //           border: Border.all(
                              //                                       //               color: Color(0xffb8b8b8),
                              //                                       //               width: 1,
                              //                                       //               style: BorderStyle.solid),
                              //                                       //         ),
                              //                                       //         child: Row(
                              //                                       //           mainAxisAlignment:
                              //                                       //               MainAxisAlignment.center,
                              //                                       //           crossAxisAlignment:
                              //                                       //               CrossAxisAlignment.center,
                              //                                       //           spacing: 8,
                              //                                       //           children: [
                              //                                       //             Icon(
                              //                                       //               Icons.block,
                              //                                       //               size: 14,
                              //                                       //             ),
                              //                                       //             Text(
                              //                                       //               l10n.unlockCommunityScore,
                              //                                       //               style: TextStyle(
                              //                                       //                   fontSize: 8,
                              //                                       //                   fontWeight:
                              //                                       //                       FontWeight.w500),
                              //                                       //             )
                              //                                       //           ],
                              //                                       //         ),
                              //                                       //       ),
                              //                                       //       // If visible, show your original row:
                              //                                       //       child: Row(
                              //                                       //         mainAxisSize: MainAxisSize.max,
                              //                                       //         mainAxisAlignment:
                              //                                       //             MainAxisAlignment.center,
                              //                                       //         crossAxisAlignment:
                              //                                       //             CrossAxisAlignment.end,
                              //                                       //         // spacing: 6,
                              //                                       //         children: [
                              //                                       //           Text(
                              //                                       //             '${l10n.communityScore}: ',
                              //                                       //             style: FlutterFlowTheme.of(
                              //                                       //                     context)
                              //                                       //                 .bodyMedium
                              //                                       //                 .override(
                              //                                       //                   font: GoogleFonts
                              //                                       //                       .montserrat(
                              //                                       //                     fontWeight:
                              //                                       //                         FlutterFlowTheme.of(
                              //                                       //                                 context)
                              //                                       //                             .bodyMedium
                              //                                       //                             .fontWeight,
                              //                                       //                     fontStyle:
                              //                                       //                         FlutterFlowTheme.of(
                              //                                       //                                 context)
                              //                                       //                             .bodyMedium
                              //                                       //                             .fontStyle,
                              //                                       //                   ),
                              //                                       //                   color: FlutterFlowTheme
                              //                                       //                           .of(context)
                              //                                       //                       .primary,
                              //                                       //                   fontSize: 10.0,
                              //                                       //                   letterSpacing: 0.0,
                              //                                       //                   fontWeight:
                              //                                       //                       FlutterFlowTheme.of(
                              //                                       //                               context)
                              //                                       //                           .bodyMedium
                              //                                       //                           .fontWeight,
                              //                                       //                   fontStyle:
                              //                                       //                       FlutterFlowTheme.of(
                              //                                       //                               context)
                              //                                       //                           .bodyMedium
                              //                                       //                           .fontStyle,
                              //                                       //                 ),
                              //                                       //           ),
                              //                                       //           Text(
                              //                                       //             '${(_model.cweeklyHealthScore ?? 0)
                              //                                       //                     .floor()}%',
                              //                                       //             style: FlutterFlowTheme.of(
                              //                                       //                     context)
                              //                                       //                 .bodyMedium
                              //                                       //                 .override(
                              //                                       //                   font: GoogleFonts
                              //                                       //                       .montserrat(
                              //                                       //                     fontWeight:
                              //                                       //                         FontWeight.bold,
                              //                                       //                     fontStyle:
                              //                                       //                         FlutterFlowTheme.of(
                              //                                       //                                 context)
                              //                                       //                             .bodyMedium
                              //                                       //                             .fontStyle,
                              //                                       //                   ),
                              //                                       //                   color: FlutterFlowTheme
                              //                                       //                           .of(context)
                              //                                       //                       .primary,
                              //                                       //                   letterSpacing: 0.0,
                              //                                       //                   fontWeight:
                              //                                       //                       FontWeight.bold,
                              //                                       //                   fontStyle:
                              //                                       //                       FlutterFlowTheme.of(
                              //                                       //                               context)
                              //                                       //                           .bodyMedium
                              //                                       //                           .fontStyle,
                              //                                       //                 ),
                              //                                       //           ),
                              //                                       //         ],
                              //                                       //       ),
                              //                                       //     );
                              //                                       //   },
                              //                                       // ),

                              //                                       SilverButton(
                              //                                           buttonTitle: l10n.explore,
                              //                                           buttonFunction: () async {
                              //                                             final auditService =
                              //                                                 UserActionAuditService(
                              //                                                     supabase);
                              //                                             await auditService.logUserAction(
                              //                                               userId: currentUserUid,
                              //                                               action: 'Explore health score',
                              //                                               screenName: screenName,
                              //                                               userData: {
                              //                                                 'week':
                              //                                                     FFAppState().calendarWeek,
                              //                                                 'year':
                              //                                                     FFAppState().calendarYear,
                              //                                               },
                              //                                             );
                              //                                             context.pushNamed(
                              //                                               ExplorePage.routeName,
                              //                                               extra: <String, dynamic>{
                              //                                                 kTransitionInfoKey:
                              //                                                     const TransitionInfo(
                              //                                                   hasTransition: true,
                              //                                                   transitionType:
                              //                                                       PageTransitionType.fade,
                              //                                                 ),
                              //                                               },
                              //                                             );
                              //                                           })
                              //                                     ])
                              //                                   ].divide(SizedBox(height: 10.0)),
                              //                                 ),
                              //                                 Column(
                              //                                   mainAxisSize: MainAxisSize.max,
                              //                                   children: [
                              //                                     Text(
                              //                                       l10n.proteinChallenge,
                              //                                       style: FlutterFlowTheme.of(context)
                              //                                           .bodyMedium
                              //                                           .override(
                              //                                             font: GoogleFonts.montserrat(
                              //                                               fontWeight: FontWeight.bold,
                              //                                               fontStyle:
                              //                                                   FlutterFlowTheme.of(context)
                              //                                                       .bodyMedium
                              //                                                       .fontStyle,
                              //                                             ),
                              //                                             color:
                              //                                                 FlutterFlowTheme.of(context)
                              //                                                     .primary,
                              //                                             fontSize: 16.0,
                              //                                             letterSpacing: 0.0,
                              //                                             fontWeight: FontWeight.bold,
                              //                                             fontStyle:
                              //                                                 FlutterFlowTheme.of(context)
                              //                                                     .bodyMedium
                              //                                                     .fontStyle,
                              //                                           ),
                              //                                     ),
                              //                                     ScoreRulerWidget(
                              //                                         userScore: valueOrDefault<double>(
                              //                                           FFAppState()
                              //                                               .individualIndicators
                              //                                               .cwProteinTrackerValue,
                              //                                           0.0,
                              //                                         ),
                              //                                         communityScore:
                              //                                             _model.cweeklyProteinScore,
                              //                                         milestone: valueOrDefault<double>(
                              //                                           _model.proteinDailyRecommended,
                              //                                           0.0,
                              //                                         ).round(),
                              //                                         milestoneLabel: _model.mileStoneLabel,
                              //                                         hasConsent: (((FFAppState()
                              //                                                         .hasSubscription ==
                              //                                                     false) ||
                              //                                                 (_model.cweeklyProteinScoreConsent ==
                              //                                                     false))
                              //                                             ? false
                              //                                             : true),
                              //                                         currentColor: Color(0xffff9a62)),
                              //                                     SilverButton(
                              //                                         buttonTitle: l10n.explore,
                              //                                         buttonFunction: () async {
                              //                                           final auditService =
                              //                                               UserActionAuditService(
                              //                                                   supabase);
                              //                                           await auditService.logUserAction(
                              //                                             userId: currentUserUid,
                              //                                             action: 'Explore protein score',
                              //                                             screenName: screenName,
                              //                                             userData: {
                              //                                               'week':
                              //                                                   FFAppState().calendarWeek,
                              //                                               'year':
                              //                                                   FFAppState().calendarYear,
                              //                                             },
                              //                                           );
                              //                                           context.pushNamed(
                              //                                             FiberExplorePage.routeName,
                              //                                             queryParameters: {
                              //                                               'exploreType':
                              //                                                   'Protein Challenge'
                              //                                             },
                              //                                             extra: <String, dynamic>{
                              //                                               kTransitionInfoKey:
                              //                                                   const TransitionInfo(
                              //                                                 hasTransition: true,
                              //                                                 transitionType:
                              //                                                     PageTransitionType.fade,
                              //                                               ),
                              //                                             },
                              //                                           );
                              //                                         })
                              //                                   ].divide(SizedBox(height: 10.0)),
                              //                                 ),
                              //                                 // Replace this section in your carousel:
                              //                                 Column(
                              //                                   mainAxisSize: MainAxisSize.max,
                              //                                   children: [
                              //                                     Text(
                              //                                       'Micronutrient',
                              //                                       style: FlutterFlowTheme.of(context)
                              //                                           .bodyMedium
                              //                                           .override(
                              //                                             font: GoogleFonts.montserrat(
                              //                                               fontWeight: FontWeight.bold,
                              //                                               fontStyle:
                              //                                                   FlutterFlowTheme.of(context)
                              //                                                       .bodyMedium
                              //                                                       .fontStyle,
                              //                                             ),
                              //                                             color:
                              //                                                 FlutterFlowTheme.of(context)
                              //                                                     .primary,
                              //                                             fontSize: 16.0,
                              //                                             letterSpacing: 0.0,
                              //                                             fontWeight: FontWeight.bold,
                              //                                             fontStyle:
                              //                                                 FlutterFlowTheme.of(context)
                              //                                                     .bodyMedium
                              //                                                     .fontStyle,
                              //                                           ),
                              //                                     ),
                              //                                     Container(
                              //                                       height: 148,
                              //                                       margin: const EdgeInsets.only(
                              //                                           top: 10, left: 50, right: 50),
                              //                                       child: _isNutrientDataLoading
                              //                                           ? Center(
                              //                                               child:
                              //                                                   CircularProgressIndicator())
                              //                                           : (features.isEmpty ||
                              //                                                   data1.isEmpty)
                              //                                               ? Center(
                              //                                                   child: Text(
                              //                                                       'No nutrient data available'))
                              //                                               : SpiderChart(
                              //                                                   data1: [
                              //                                                     40,
                              //                                                     50,
                              //                                                     60,
                              //                                                     65,
                              //                                                     80
                              //                                                   ], // data1 is for community
                              //                                                   data2:
                              //                                                       data1, // Individual values
                              //                                                   labels: features,
                              //                                                   color1: const [
                              //                                                     Color(0xFFC40CD3),
                              //                                                     Color(0xFF2883DE),
                              //                                                   ],
                              //                                                   color2: const [
                              //                                                     Color(0xFF00ECFF),
                              //                                                     Color(0xFF3968E6),
                              //                                                   ],
                              //                                                   backgroundColors: const [
                              //                                                     Color(0xffbababa),
                              //                                                     Color(0xffcecece),
                              //                                                     Color(0xffe1e1e1),
                              //                                                     Color(0xffececec),
                              //                                                     Color(0xfff9f9f9),
                              //                                                     Color(0xfff9f9f9),
                              //                                                     Color(0xffececec),
                              //                                                     Color(0xffe1e1e1),
                              //                                                     Color(0xffcecece),
                              //                                                     Color(0xffbababa),
                              //                                                     Color(0xffbababa),
                              //                                                   ],
                              //                                                   layerCount: 11,
                              //                                                 ),
                              //                                     ),
                              //                                     SilverButton(
                              //                                         buttonTitle: l10n.explore,
                              //                                         buttonFunction: () async {
                              //                                           context.pushNamed(
                              //                                             LowMicronutrientsPage.routeName,
                              //                                             queryParameters: {
                              //                                               'exploreType':
                              //                                                   'Low Mircronutrients Intake'
                              //                                             },
                              //                                             extra: <String, dynamic>{
                              //                                               kTransitionInfoKey:
                              //                                                   const TransitionInfo(
                              //                                                 hasTransition: true,
                              //                                                 transitionType:
                              //                                                     PageTransitionType.fade,
                              //                                               ),
                              //                                             },
                              //                                           );
                              //                                         })
                              //                                   ].divide(SizedBox(height: 10.0)),
                              //                                 ),
                              //                               ],
                              //                               carouselController:
                              //                                   _model.carouselController ??=
                              //                                       CarouselSliderController(),
                              //                               options: CarouselOptions(
                              //                                 height: 240,
                              //                                 initialPage: 1,
                              //                                 viewportFraction: 1,
                              //                                 disableCenter: true,
                              //                                 enlargeCenterPage: true,
                              //                                 enlargeFactor: 0.15,
                              //                                 enableInfiniteScroll: true,
                              //                                 scrollDirection: Axis.horizontal,
                              //                                 autoPlay: false,
                              //                                 onPageChanged: (index, _) =>
                              //                                     _model.carouselCurrentIndex = index,
                              //                               ),
                              //                             ),
                            ),
                            // Align(
                            //   alignment: AlignmentDirectional(-1.0, -1.01),
                            //   child: Padding(
                            //     padding: EdgeInsetsDirectional.fromSTEB(
                            //         8.0, 0.0, 0.0, 0.0),
                            //     child: InkWell(
                            //       child: Icon(
                            //         Icons.chevron_left,
                            //         color: FlutterFlowTheme.of(context)
                            //             .secondaryText,
                            //         size: 24.0,
                            //       ),
                            //       onTap: () async {
                            //         await _model.carouselController
                            //             ?.previousPage(
                            //           duration: Duration(milliseconds: 300),
                            //           curve: Curves.ease,
                            //         );
                            //       },
                            //     ),
                            //   ),
                            // ),
                            // Align(
                            //   alignment: AlignmentDirectional(1.0, -1.01),
                            //   child: Padding(
                            //     padding: EdgeInsetsDirectional.fromSTEB(
                            //         0.0, 0.0, 8.0, 0.0),
                            //     child: InkWell(
                            //       child: Icon(
                            //         Icons.chevron_right_sharp,
                            //         color: FlutterFlowTheme.of(context)
                            //             .secondaryText,
                            //         size: 24.0,
                            //       ),
                            //       onTap: () async {
                            //         await _model.carouselController?.nextPage(
                            //           duration: Duration(milliseconds: 300),
                            //           curve: Curves.ease,
                            //         );
                            //       },
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: ((FFAppState().plantSummary.colorsConsumed ??
                                            0) >=
                                        5) &&
                                    ((FFAppState()
                                                .plantSummary
                                                .colorsConsumed ??
                                            0) <
                                        7) ||
                                ((FFAppState()
                                                .plantSummary
                                                .totalDistinctPlantsConsumed ??
                                            0) >=
                                        25) &&
                                    ((FFAppState()
                                                .plantSummary
                                                .totalDistinctPlantsConsumed ??
                                            0) <
                                        30) ||
                                ((portions ?? 0) <= 100) &&
                                    ((portions ?? 0) > 0)
                            ? EdgeInsets.fromLTRB(12, 20, 12, 0)
                            : EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 6,
                          children: [
//                             Container(
//   width: MediaQuery.sizeOf(context).width * 0.3,
//   decoration: BoxDecoration(
//     gradient: (FFAppState().plantSummary.plantsperdayCounter ==
//             FFAppState().currentDayNumber)
//         ? LinearGradient(
//             colors: [
//               Color(0xFFA8E6CF),
//               Color(0xFFD3F4E9),
//               Color(0xFFA8E6CF)
//             ],
//             stops: [0.0, 0.5, 1.0],
//             begin: AlignmentDirectional(0.0, -1.0),
//             end: AlignmentDirectional(0, 1.0),
//           )
//         : null,
//     color: (FFAppState().plantSummary.plantsperdayCounter ==
//             FFAppState().currentDayNumber)
//         ? null
//         : FlutterFlowTheme.of(context).secondaryBackground,
//     borderRadius: BorderRadius.circular(10.0),
//   ),
//   child: Align(
//     alignment: AlignmentDirectional(0.0, 0.0),
//     child: Stack(
//       children: [
//         // The main content of the container
//         Padding(
//           padding: EdgeInsetsDirectional.fromSTEB(11.0, 20.0, 11.0, 20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 '5 Portions Daily',
//                 style: FlutterFlowTheme.of(context)
//                     .bodyMedium
//                     .override(
//                       font: GoogleFonts.montserrat(
//                         fontWeight:
//                             FlutterFlowTheme.of(context).bodyMedium.fontWeight,
//                         fontStyle:
//                             FlutterFlowTheme.of(context).bodyMedium.fontStyle,
//                       ),
//                       color: FlutterFlowTheme.of(context).primaryText,
//                       fontSize: 12.0,
//                       letterSpacing: 0.0,
//                     ),
//               ),
//               LinearPercentIndicator(
//                 percent: FFAppState().currentDayNumber == 0
//                     ? 0.0
//                     : (FFAppState().plantSummary.plantsperdayCounter ?? 0) /
//                         (FFAppState().currentDayNumber ?? 1),
//                 width: MediaQuery.sizeOf(context).width * 0.23,
//                 lineHeight: 4.0,
//                 animation: true,
//                 animateFromLastPercent: true,
//                 progressColor: FlutterFlowTheme.of(context).primary,
//                 backgroundColor: FlutterFlowTheme.of(context).accent4,
//                 barRadius: Radius.circular(10.0),
//                 padding: EdgeInsets.zero,
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     '${FFAppState().plantSummary.plantsperdayCounter.toString()} / ${FFAppState().currentDayNumber.toString()}',
//                     style: FlutterFlowTheme.of(context)
//                         .bodyMedium
//                         .override(
//                           font: GoogleFonts.montserrat(
//                             fontWeight: FontWeight.bold,
//                             fontStyle:
//                                 FlutterFlowTheme.of(context).bodyMedium.fontStyle,
//                           ),
//                           fontSize: 18.0,
//                           letterSpacing: 0.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ],
//               ),
//             ].divide(SizedBox(height: 12.0)),
//           ),
//         ),

//         // Bell icon above the 5 Portions Daily label, on the border of the container
//        Positioned(
//           top: -12.0, // Adjusts the position of the bell icon to be above the container
//           left: 0,
//           right: 0,
//           child: Align(
//             alignment: Alignment.center, // Ensures the bell icon is centered horizontally
//             child: Tooltip(
//               message: "Just ${portionsLeft} g left to reach today's goal! One more little piece and you're there.",
//               child: Padding(
//                 padding: EdgeInsets.all(6.0),
//                 child: FaIcon(
//                   FontAwesomeIcons.bell,
//                   color: FlutterFlowTheme.of(context).primaryText,
//                   size: 18.0,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// ),

                            Container(
                              width:
                                  MediaQuery.sizeOf(context).width * 0.33 - 12,
                              decoration: BoxDecoration(
                                gradient: (FFAppState()
                                            .plantSummary
                                            .plantsperdayCounter ==
                                        FFAppState().currentDayNumber)
                                    ? LinearGradient(
                                        colors: [
                                          Color(0xFFA8E6CF),
                                          Color(0xFFD3F4E9),
                                          Color(0xFFA8E6CF)
                                        ],
                                        stops: [0.0, 0.5, 1.0],
                                        begin: AlignmentDirectional(0.0, -1.0),
                                        end: AlignmentDirectional(0, 1.0),
                                      )
                                    : LinearGradient(
                                        colors: [
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground
                                        ],
                                        stops: [0.0, 0.5, 1.0],
                                        begin: AlignmentDirectional(0.0, -1.0),
                                        end: AlignmentDirectional(0, 1.0),
                                      ),
                                boxShadow: [
                                  BoxShadow(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    offset: Offset(0, 0),
                                    blurRadius: 0,
                                    spreadRadius:
                                        1, // equivalent to the 1px "border-like" shadow
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.12),
                                    offset: Offset(0, 0),
                                    blurRadius: 6,
                                    spreadRadius: 0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Stack(
                                  alignment: AlignmentDirectional(-1.0, 1.0),
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          11.0, 18.0, 11.0, 9.0),
                                      height: FlutterFlowTheme.adjustScale(
                                          size: 88,
                                          largeScreenMargin: 5,
                                          smallScreenMargin: 4),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            l10n.portionDaily,
                                            maxLines: 1, // 🔹 only 1 line
                                            overflow: TextOverflow
                                                .ellipsis, // 🔹 show "..." when overflow
                                            softWrap: false,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.montserrat(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .textGrey,
                                                  fontSize: FlutterFlowTheme
                                                      .adjustScale(size: 12.0),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          LinearPercentIndicator(
                                            percent: FFAppState()
                                                        .currentDayNumber ==
                                                    0
                                                ? 0.0
                                                : (FFAppState()
                                                            .plantSummary
                                                            .plantsperdayCounter ??
                                                        0) /
                                                    (FFAppState()
                                                            .currentDayNumber ??
                                                        1),
                                            lineHeight: 6.0,
                                            animation: true,
                                            animateFromLastPercent: true,
                                            progressColor:
                                                FlutterFlowTheme.of(context)
                                                    .textGrey,
                                            backgroundColor: Colors.white,
                                            barRadius: Radius.circular(10.0),
                                            padding: EdgeInsets.zero,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${FFAppState().plantSummary.plantsperdayCounter.toString()}',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts
                                                          .montserrat(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 18.0),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textGrey,
                                                    ),
                                              ),
                                              Text(
                                                '/${FFAppState().currentDayNumber.toString()}',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts
                                                          .montserrat(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 18.0),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textGrey,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: AlignedTooltip(
                                        content: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 4.0, 8.0, 4.0),
                                          child: Text(
                                            l10n.portionDailyTooltip,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  font: GoogleFonts.montserrat(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLarge
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLarge
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .textGrey,
                                                  fontSize: FlutterFlowTheme
                                                      .adjustScale(size: 12.0),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        offset: 4.0,
                                        preferredDirection: AxisDirection.down,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                        elevation: 4.0,
                                        tailBaseWidth: 24.0,
                                        tailLength: 12.0,
                                        waitDuration:
                                            Duration(milliseconds: 100),
                                        showDuration:
                                            Duration(milliseconds: 1500),
                                        triggerMode: TooltipTriggerMode.tap,
                                        child: Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: FaIcon(
                                            FontAwesomeIcons.infoCircle,
                                            color: FlutterFlowTheme.of(context)
                                                .textGrey
                                                .withOpacity(0.26),
                                            size: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -16,
                                      left: 0,
                                      right: 0,
                                      child: Visibility(
                                        // 👇 change `portionsLeft` to your actual variable name if it’s `portions`
                                        visible: ((portions ?? 0) <= 100) &&
                                            ((portions ?? 0) > 0),
                                        replacement: SizedBox.shrink(),
                                        // replacement: SizedBox.shrink(),
                                        child: Center(
                                          child: AlignedTooltip(
                                            content: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 4.0, 8.0, 4.0),
                                              child: Text(
                                                "${l10n.just} ${portions}g ${l10n.portionLeftTooltip}",
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      font: GoogleFonts
                                                          .montserrat(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textGrey,
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 12.0),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                            offset: 4.0,
                                            preferredDirection:
                                                AxisDirection.up,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            elevation: 4.0,
                                            tailBaseWidth: 24.0,
                                            tailLength: 12.0,
                                            waitDuration:
                                                Duration(milliseconds: 100),
                                            showDuration:
                                                Duration(milliseconds: 1500),
                                            triggerMode: TooltipTriggerMode.tap,
                                            child: Container(
                                              padding: EdgeInsets.all(6.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 255, 147, 21),
                                                  width: 1.0,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                              child: Image.asset(
                                                "assets/images/bell_yellow.png",
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  MediaQuery.sizeOf(context).width * 0.33 - 12,
                              decoration: BoxDecoration(
                                gradient: (FFAppState()
                                            .plantSummary
                                            .totalDistinctPlantsConsumed >=
                                        30)
                                    ? LinearGradient(
                                        colors: [
                                          Color(0xFFA8E6CF),
                                          Color(0xFFD3F4E9),
                                          Color(0xFFA8E6CF)
                                        ],
                                        stops: [0.0, 0.5, 1.0],
                                        begin: AlignmentDirectional(0.0, -1.0),
                                        end: AlignmentDirectional(0, 1.0),
                                      )
                                    : LinearGradient(
                                        colors: [
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground
                                        ],
                                        stops: [0.0, 0.5, 1.0],
                                        begin: AlignmentDirectional(0.0, -1.0),
                                        end: AlignmentDirectional(0, 1.0),
                                      ),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    offset: Offset(0, 0),
                                    blurRadius: 0,
                                    spreadRadius:
                                        1, // equivalent to the 1px "border-like" shadow
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.12),
                                    offset: Offset(0, 0),
                                    blurRadius: 6,
                                    spreadRadius: 0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Stack(
                                  alignment: AlignmentDirectional(-1.0, 1.0),
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          11.0, 18.0, 11.0, 9.0),
                                      height: FlutterFlowTheme.adjustScale(
                                          size: 88,
                                          largeScreenMargin: 5,
                                          smallScreenMargin: 4),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            l10n.plantDiversity,
                                            maxLines: 1, // 🔹 only 1 line
                                            overflow: TextOverflow
                                                .ellipsis, // 🔹 show "..." when overflow
                                            softWrap: false,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.montserrat(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .textGrey,
                                                  fontSize: FlutterFlowTheme
                                                      .adjustScale(size: 12.0),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          LinearPercentIndicator(
                                            percent: ((FFAppState()
                                                            .plantSummary
                                                            .totalDistinctPlantsConsumed ??
                                                        0) /
                                                    30.0)
                                                .clamp(0.0, 1.0),
                                            lineHeight: 6.0,
                                            animation: true,
                                            animateFromLastPercent: true,
                                            progressColor:
                                                FlutterFlowTheme.of(context)
                                                    .textGrey,
                                            backgroundColor: Colors.white,
                                            barRadius: Radius.circular(10.0),
                                            padding: EdgeInsets.zero,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                (FFAppState()
                                                        .plantSummary
                                                        .totalDistinctPlantsConsumed)
                                                    .toString(),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts
                                                          .montserrat(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 18.0),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textGrey,
                                                    ),
                                              ),
                                              Text(
                                                '/30',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts
                                                          .montserrat(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 18.0),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textGrey,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: AlignedTooltip(
                                        content: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 4.0, 8.0, 4.0),
                                          child: Text(
                                            l10n.plantDiversityTooltip,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  font: GoogleFonts.montserrat(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLarge
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLarge
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .textGrey,
                                                  fontSize: FlutterFlowTheme
                                                      .adjustScale(size: 12.0),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        offset: 4.0,
                                        preferredDirection: AxisDirection.down,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                        elevation: 4.0,
                                        tailBaseWidth: 24.0,
                                        tailLength: 12.0,
                                        waitDuration:
                                            Duration(milliseconds: 100),
                                        showDuration:
                                            Duration(milliseconds: 1500),
                                        triggerMode: TooltipTriggerMode.tap,
                                        child: Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: FaIcon(
                                            FontAwesomeIcons.infoCircle,
                                            color: FlutterFlowTheme.of(context)
                                                .textGrey
                                                .withOpacity(0.26),
                                            size: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -16,
                                      left: 0,
                                      right: 0,
                                      child: Visibility(
                                          // 👇 change `portionsLeft` to your actual variable name if it’s `portions`
                                          visible: ((FFAppState()
                                                          .plantSummary
                                                          .totalDistinctPlantsConsumed ??
                                                      0) >=
                                                  25) &&
                                              ((FFAppState()
                                                          .plantSummary
                                                          .totalDistinctPlantsConsumed ??
                                                      0) <
                                                  30),
                                          replacement: SizedBox.shrink(),
                                          child: Center(
                                            child: AlignedTooltip(
                                              content: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 4.0, 8.0, 4.0),
                                                child: Text(
                                                  "${l10n.almostThere} ${_model.plantsLeft} ${l10n.plantLeftTooltip}",
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        font: GoogleFonts
                                                            .montserrat(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .textGrey,
                                                        fontSize:
                                                            FlutterFlowTheme
                                                                .adjustScale(
                                                                    size: 12.0),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              offset: 4.0,
                                              preferredDirection:
                                                  AxisDirection.up,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              elevation: 4.0,
                                              tailBaseWidth: 24.0,
                                              tailLength: 12.0,
                                              waitDuration:
                                                  Duration(milliseconds: 100),
                                              showDuration:
                                                  Duration(milliseconds: 1500),
                                              triggerMode:
                                                  TooltipTriggerMode.tap,
                                              child: Container(
                                                padding: EdgeInsets.all(6.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Color.fromARGB(
                                                            255, 172, 89, 236),
                                                        width: 1.0,
                                                        style:
                                                            BorderStyle.solid)),
                                                child: Image.asset(
                                                  "assets/images/bell_purple.png", // <-- add Google logo asset
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  MediaQuery.sizeOf(context).width * 0.33 - 12,
                              decoration: BoxDecoration(
                                gradient: (FFAppState()
                                            .plantSummary
                                            .colorsConsumed ==
                                        7)
                                    ? LinearGradient(
                                        colors: [
                                          Color(0xFFA8E6CF),
                                          Color(0xFFD3F4E9),
                                          Color(0xFFA8E6CF)
                                        ],
                                        stops: [0.0, 0.5, 1.0],
                                        begin: AlignmentDirectional(0.0, -1.0),
                                        end: AlignmentDirectional(0, 1.0),
                                      )
                                    : LinearGradient(
                                        colors: [
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground
                                        ],
                                        stops: [0.0, 0.5, 1.0],
                                        begin: AlignmentDirectional(0.0, -1.0),
                                        end: AlignmentDirectional(0, 1.0),
                                      ),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    offset: Offset(0, 0),
                                    blurRadius: 0,
                                    spreadRadius:
                                        1, // equivalent to the 1px "border-like" shadow
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.12),
                                    offset: Offset(0, 0),
                                    blurRadius: 6,
                                    spreadRadius: 0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Stack(
                                  alignment: AlignmentDirectional(-1.0, 1.0),
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          11.0, 18.0, 11.0, 9.0),
                                      height: FlutterFlowTheme.adjustScale(
                                          size: 88,
                                          largeScreenMargin: 5,
                                          smallScreenMargin: 4),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            l10n.perColor,
                                            maxLines: 1, // 🔹 only 1 line
                                            overflow: TextOverflow
                                                .ellipsis, // 🔹 show "..." when overflow
                                            softWrap: false,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.montserrat(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .textGrey,
                                                  fontSize: FlutterFlowTheme
                                                      .adjustScale(size: 12.0),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          LinearPercentIndicator(
                                            percent: (FFAppState()
                                                        .plantSummary
                                                        .colorsConsumed ??
                                                    0) /
                                                7,
                                            lineHeight: 6.0,
                                            animation: true,
                                            animateFromLastPercent: true,
                                            progressColor:
                                                FlutterFlowTheme.of(context)
                                                    .textGrey,
                                            backgroundColor: Colors.white,
                                            barRadius: Radius.circular(10.0),
                                            padding: EdgeInsets.zero,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                (FFAppState()
                                                        .plantSummary
                                                        .colorsConsumed)
                                                    .toString(),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts
                                                          .montserrat(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 18.0),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textGrey,
                                                    ),
                                              ),
                                              Text(
                                                '/7',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts
                                                          .montserrat(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 18.0),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textGrey,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: AlignedTooltip(
                                        content: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 4.0, 8.0, 4.0),
                                          child: Text(
                                            l10n.perColorTooltip,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  font: GoogleFonts.montserrat(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLarge
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLarge
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .textGrey,
                                                  fontSize: FlutterFlowTheme
                                                      .adjustScale(size: 12.0),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        offset: 4.0,
                                        preferredDirection: AxisDirection.down,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                        elevation: 4.0,
                                        tailBaseWidth: 24.0,
                                        tailLength: 12.0,
                                        waitDuration:
                                            Duration(milliseconds: 100),
                                        showDuration:
                                            Duration(milliseconds: 1500),
                                        triggerMode: TooltipTriggerMode.tap,
                                        child: Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: FaIcon(
                                            FontAwesomeIcons.infoCircle,
                                            color: FlutterFlowTheme.of(context)
                                                .textGrey
                                                .withOpacity(0.26),
                                            size: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -16,
                                      left: 0,
                                      right: 0,
                                      child: Visibility(
                                          // 👇 change `portionsLeft` to your actual variable name if it’s `portions`
                                          visible: ((FFAppState()
                                                          .plantSummary
                                                          .colorsConsumed ??
                                                      0) >=
                                                  5) &&
                                              ((FFAppState()
                                                          .plantSummary
                                                          .colorsConsumed ??
                                                      0) <
                                                  7),
                                          replacement: SizedBox.shrink(),
                                          child: Center(
                                            child: AlignedTooltip(
                                              content: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 4.0, 8.0, 4.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                          text:
                                                              "${l10n.youAte} ${FFAppState().plantSummary.colorsConsumed} ${l10n.colorsThisWeek} ",
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .montserrat(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .textGrey,
                                                                fontSize: FlutterFlowTheme
                                                                    .adjustScale(
                                                                        size:
                                                                            12.0),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    "${_model.colorsLeft} ${l10n.togo}.",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700))
                                                          ]),
                                                    ),
                                                    // const Row(
                                                    //     crossAxisAlignment:
                                                    //         CrossAxisAlignment
                                                    //             .center,
                                                    //     mainAxisAlignment:
                                                    //         MainAxisAlignment
                                                    //             .center,
                                                    //     children: [
                                                    //       Padding(
                                                    //         padding: EdgeInsets
                                                    //             .symmetric(
                                                    //                 horizontal:
                                                    //                     2.0),
                                                    //         child: CircleAvatar(
                                                    //           radius: 4,
                                                    //           backgroundColor:
                                                    //               Color(
                                                    //                   0xfff77f00),
                                                    //         ),
                                                    //       ),
                                                    //       Padding(
                                                    //         padding: EdgeInsets
                                                    //             .symmetric(
                                                    //                 horizontal:
                                                    //                     2.0),
                                                    //         child: CircleAvatar(
                                                    //           radius: 4,
                                                    //           backgroundColor:
                                                    //               Color(
                                                    //                   0xff6a0572),
                                                    //         ),
                                                    //       ),
                                                    //       Padding(
                                                    //         padding: EdgeInsets
                                                    //             .symmetric(
                                                    //                 horizontal:
                                                    //                     2.0),
                                                    //         child: CircleAvatar(
                                                    //           radius: 4,
                                                    //           backgroundColor:
                                                    //               Color(
                                                    //                   0xff8d6e63),
                                                    //         ),
                                                    //       ),
                                                    //       Padding(
                                                    //         padding: EdgeInsets
                                                    //             .symmetric(
                                                    //                 horizontal:
                                                    //                     2.0),
                                                    //         child: CircleAvatar(
                                                    //           radius: 4,
                                                    //           backgroundColor:
                                                    //               Color(
                                                    //                   0xffc0bdbb),
                                                    //         ),
                                                    //       ),
                                                    //     ]),

                                                    RichText(
                                                      text: TextSpan(
                                                        text: l10n
                                                            .addThemToYourList,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .montserrat(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textGrey,
                                                                  fontSize: FlutterFlowTheme
                                                                      .adjustScale(
                                                                          size:
                                                                              12.0),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              offset: 4.0,
                                              preferredDirection:
                                                  AxisDirection.up,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              elevation: 4.0,
                                              tailBaseWidth: 24.0,
                                              tailLength: 12.0,
                                              waitDuration:
                                                  Duration(milliseconds: 100),
                                              showDuration:
                                                  Duration(milliseconds: 1500),
                                              triggerMode:
                                                  TooltipTriggerMode.tap,
                                              child: Container(
                                                padding: EdgeInsets.all(6.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Color.fromARGB(
                                                            255, 162, 188, 51),
                                                        width: 1.0,
                                                        style:
                                                            BorderStyle.solid)),
                                                child: Image.asset(
                                                  "assets/images/bell_green.png", // <-- add Google logo asset
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.weeklyRainbow,
                                  maxLines: 1, // 🔹 only 1 line
                                  overflow: TextOverflow
                                      .ellipsis, // 🔹 show "..." when overflow
                                  softWrap: false,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                          font: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          fontSize:
                                              FlutterFlowTheme.adjustScale(
                                                  size: 16.0),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                          color: Color(0xff818181)),
                                ),
                                AlignedTooltip(
                                  content: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 2.0, 8.0, 2.0),
                                    child: Text(
                                      l10n.weeklyRainbowTooltip,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            font: GoogleFonts.montserrat(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .textGrey,
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 12.0),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                  offset: 4.0,
                                  preferredDirection: AxisDirection.down,
                                  borderRadius: BorderRadius.circular(8.0),
                                  backgroundColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  elevation: 4.0,
                                  tailBaseWidth: 24.0,
                                  tailLength: 12.0,
                                  waitDuration: Duration(milliseconds: 100),
                                  showDuration: Duration(milliseconds: 1500),
                                  triggerMode: TooltipTriggerMode.tap,
                                  child: FaIcon(
                                    FontAwesomeIcons.infoCircle,
                                    color: Color(0xff818181),
                                    size: 16.0,
                                  ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(8, 0, 12, 0),
                                margin:
                                    const EdgeInsets.only(bottom: 12, top: 12),
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  clipBehavior: Clip.hardEdge,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(4, 8, 0, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      spacing: 20,
                                      children: !_colorMappingLoaded
                                          ? [
                                              Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            ]
                                          : [
                                              _buildProgressDots(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .redFill,
                                                totalDots: 20,
                                                filledCount: FFAppState()
                                                    .plantSummary
                                                    .totalPlantsSelectedRedConsumed,
                                                gradientColor:
                                                    Color(0xffFF9DA4),
                                              ),
                                              _buildProgressDots(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .orangeFill,
                                                totalDots: 20,
                                                filledCount: FFAppState()
                                                    .plantSummary
                                                    .totalPlantsSelectedOrangeConsumed,
                                                gradientColor:
                                                    Color(0xffFFBA71),
                                              ),
                                              _buildProgressDots(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .yellowFill,
                                                totalDots: 20,
                                                filledCount: FFAppState()
                                                    .plantSummary
                                                    .totalPlantsSelectedYellowConsumed,
                                                gradientColor:
                                                    Color(0xffFFE586),
                                              ),
                                              _buildProgressDots(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .greenFill,
                                                totalDots: 20,
                                                filledCount: FFAppState()
                                                    .plantSummary
                                                    .totalPlantsSelectedGreenConsumed,
                                                gradientColor:
                                                    Color(0xff90E894),
                                              ),
                                              _buildProgressDots(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .purpleFill,
                                                totalDots: 20,
                                                filledCount: FFAppState()
                                                    .plantSummary
                                                    .totalPlantsSelectedPurpleConsumed,
                                                gradientColor:
                                                    Color(0xffF576FF),
                                              ),
                                              _buildProgressDots(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .brownFill,
                                                totalDots: 20,
                                                filledCount: FFAppState()
                                                    .plantSummary
                                                    .totalPlantsSelectedBrownConsumed,
                                                gradientColor:
                                                    Color(0xffE3BEB1),
                                              ),
                                              _buildProgressDots(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .greyFill,
                                                totalDots: 20,
                                                filledCount: FFAppState()
                                                    .plantSummary
                                                    .totalPlantsSelectedWhiteConsumed,
                                                gradientColor:
                                                    Color(0xffFAFAFA),
                                              ),
                                            ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Builder(
                            builder: (context) => InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final auditService =
                                    UserActionAuditService(supabase);
                                await auditService.logUserAction(
                                  userId: currentUserUid,
                                  action: 'Checked Smart plant suggeestions',
                                  screenName: screenName,
                                  userData: {},
                                );
                                await context.pushNamed(
                                    PersonalizedPlantListWidget.routeName);
                                // await Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         const PersonalizedPlantListWidget(),
                                //   ),
                                // );
                              },
                              child: GradientButton(
                                text: l10n.smartSuggestion,
                                iconPath: "assets/images/heart_plus_black.png",
                              ),
                            ),
                          )
                        ],
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Align(
                            alignment: Alignment
                                .topCenter, //AlignmentDirectional(0.0, 1.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12, 12.0, 12, 18.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 24,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    width: 1.0,
                                  ),
                                  boxShadow: const [
                                    // White outline-like shadow (no blur)
                                    BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 0, // No blur radius
                                      spreadRadius:
                                          1, // Slight spread to create the outline effect
                                      offset: Offset(0, 0), // No offset
                                    ),
                                    // Subtle black shadow
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0,
                                          0.1), // Black shadow with opacity
                                      blurRadius:
                                          6, // The blur radius to mimic the shadow's spread
                                      spreadRadius: 0, // No spread
                                      offset: Offset(0, 0), // No offset
                                    ),
                                  ],
                                ),
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 30.0, 16, 27.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 6,
                                        children: [
                                          Image.asset(
                                            "assets/images/plant_product.png", // <-- add Google logo asset
                                            width: 26,
                                            height: 27,
                                          ),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                // text:
                                                //     "${l10n.plants}:\n",
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 12.0),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${calculateTotalPortions(consumptionTodaySorted, dietarySource: 1)} g',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          fontSize:
                                                              FlutterFlowTheme
                                                                  .adjustScale(
                                                                      size:
                                                                          12.0),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                ]),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: Color(0xffe7e7e7),
                                      width: 1,
                                      height: 50,
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 6,
                                        children: [
                                          Image.asset(
                                            "assets/images/animal_product.png", // <-- add Google logo asset
                                            width: 28,
                                            height: 28,
                                          ),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                // text: l10n
                                                //     .animalProducts,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 12.0),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${calculateTotalPortions(consumptionSourceAnimal, dietarySource: 2)} g',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          fontSize:
                                                              FlutterFlowTheme
                                                                  .adjustScale(
                                                                      size:
                                                                          12.0),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                ]),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: Color(0xffe7e7e7),
                                      width: 1,
                                      height: 50,
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 6,
                                        children: [
                                          Image.asset(
                                            "assets/images/ultra_processed_food.png", // <-- add Google logo asset
                                            width: 26,
                                            height: 26,
                                          ),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                // text:
                                                //     l10n.upf,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 12.0),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${calculateTotalPortions(consumptionSourceUPF, dietarySource: 3)} g',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          fontSize:
                                                              FlutterFlowTheme
                                                                  .adjustScale(
                                                                      size:
                                                                          12.0),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                ]),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: Color(0xffe7e7e7),
                                      width: 1,
                                      height: 50,
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 6,
                                        children: [
                                          Image.asset(
                                            "assets/images/water.png", // <-- add Google logo asset
                                            width: 26,
                                            height: 26,
                                          ),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                // text:
                                                //     "${l10n.water}:\n",
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 12.0),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${calculateTotalPortions(consumptionSourceWater, dietarySource: 4)} ml',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          fontSize:
                                                              FlutterFlowTheme
                                                                  .adjustScale(
                                                                      size:
                                                                          12.0),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                ]),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

// Updated date navigation section
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Container(
                              width: 180,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(99.0),
                              ),
                              alignment: AlignmentDirectional(0.0, -1.0),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Icon(
                                        Icons.chevron_left,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24.0,
                                      ),
                                      onTap: () async {
                                        final auditService =
                                            UserActionAuditService(supabase);

                                        // 🔥 FIX: Convert DateTime to String before logging
                                        await auditService.logUserAction(
                                          userId: currentUserUid,
                                          action: 'Click Previous Date',
                                          screenName: screenName,
                                          userData: {
                                            'date': DateFormat('yyyy-MM-dd').format(
                                                _selectedDate), // ✅ Convert to String
                                            'week': FFAppState().calendarWeek,
                                            'year': FFAppState().calendarYear,
                                          },
                                        );

                                        DateTime currentDate;
                                        try {
                                          currentDate = DateTime.parse(
                                              FFAppState().currentDay);
                                        } catch (e) {
                                          currentDate = DateTime.now();
                                          FFAppState().currentDay =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(currentDate);
                                        }

                                        DateTime previousDate = currentDate
                                            .subtract(const Duration(days: 1));
                                        int previousWeek =
                                            getWeekOfYear(previousDate);
                                        int currentWeek =
                                            getWeekOfYear(currentDate);

                                        if (previousWeek != currentWeek) {
                                          if (_hasValidSubscription) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Go to dashboard to see the historic data')),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Please subscribe to see data for previous week.')),
                                            );
                                          }
                                        } else {
                                          int dayOfWeek = previousDate.weekday;
                                          FFAppState().currentDayNumber =
                                              dayOfWeek;
                                          FFAppState().currentDay =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(previousDate);

                                          setState(() {
                                            _selectedDate = previousDate;
                                          });
                                          _fetchWeeklyConsumption();
                                        }
                                      },
                                    ),
                                    Text(
                                      _getDateDisplayText(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 15.0),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    InkWell(
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24.0,
                                      ),
                                      onTap: () async {
                                        final auditService =
                                            UserActionAuditService(supabase);

                                        // 🔥 FIX: Convert DateTime to String before logging
                                        await auditService.logUserAction(
                                          userId: currentUserUid,
                                          action: 'Click Next Date',
                                          screenName: screenName,
                                          userData: {
                                            'date': DateFormat('yyyy-MM-dd').format(
                                                _selectedDate), // ✅ Convert to String
                                            'week': FFAppState().calendarWeek,
                                            'year': FFAppState().calendarYear,
                                          },
                                        );

                                        try {
                                          DateTime currentDate;
                                          try {
                                            final currentDayString =
                                                FFAppState().currentDay ?? '';
                                            if (currentDayString.isEmpty) {
                                              currentDate = DateTime.now();
                                            } else {
                                              currentDate = DateTime.parse(
                                                  currentDayString);
                                            }
                                          } catch (e) {
                                            print(
                                                'Error parsing currentDay: $e');
                                            currentDate = DateTime.now();
                                            FFAppState().currentDay =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(currentDate);
                                          }

                                          DateTime nextDate = currentDate
                                              .add(Duration(days: 1));
                                          DateTime today = DateTime.now();
                                          DateTime todayDateOnly = DateTime(
                                              today.year,
                                              today.month,
                                              today.day);
                                          DateTime nextDateOnly = DateTime(
                                              nextDate.year,
                                              nextDate.month,
                                              nextDate.day);

                                          if (nextDateOnly
                                              .isAfter(todayDateOnly)) {
                                            print(
                                                'Future day cannot be selected.');
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Future day cannot be selected.'),
                                                duration: Duration(seconds: 2),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          } else {
                                            int dayOfWeek = nextDate.weekday;
                                            if (dayOfWeek < 1 ||
                                                dayOfWeek > 7) {
                                              print(
                                                  'Invalid day of week: $dayOfWeek, defaulting to 1');
                                              dayOfWeek = 1;
                                            }

                                            FFAppState().currentDayNumber =
                                                dayOfWeek;
                                            FFAppState().currentDay =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(nextDate);

                                            setState(() {
                                              _selectedDate = nextDate;
                                            });

                                            print(
                                                'Next date selected: ${FFAppState().currentDay}');
                                            _fetchWeeklyConsumption();
                                          }
                                        } catch (e) {
                                          print(
                                              'Error in next date navigation: $e');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Error navigating to next date')),
                                          );
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 180,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(99.0),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Builder(
                                    builder: (context) => InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          final auditService =
                                              UserActionAuditService(supabase);
                                          await auditService.logUserAction(
                                            userId: currentUserUid,
                                            action: 'Check Week Consumption',
                                            screenName: screenName,
                                            userData: {
                                              'week': FFAppState().calendarWeek,
                                              'year': FFAppState().calendarYear,
                                            },
                                          );
                                          await showDialog(
                                            context: context,
                                            builder: (dialogContext) {
                                              return Dialog(
                                                elevation: 0,
                                                insetPadding: EdgeInsets.zero,
                                                backgroundColor:
                                                    Colors.transparent,
                                                alignment:
                                                    AlignmentDirectional(0, 0)
                                                        .resolve(
                                                            Directionality.of(
                                                                context)),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // UserActionAuditService.logUserAction(userId: currentUserUid, action:'Check all Consumptions', screenName: screenName, userData: {});
                                                    FocusScope.of(dialogContext)
                                                        .unfocus();
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  child: const SizedBox(
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    child:
                                                        YourConsumptionWidget(),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(99.0),
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 1.0,
                                                  color: Color.fromRGBO(
                                                      199, 199, 199, 1),
                                                  offset: Offset(
                                                    0.0,
                                                    0.0,
                                                  ),
                                                )
                                              ],
                                              border: Border.all(
                                                  color: Color(0xffc3c3c3),
                                                  width: 1),
                                              gradient: LinearGradient(
                                                colors: const [
                                                  Color(0xffffffff),
                                                  Color(0xffe0e0e0)
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              )),
                                          alignment:
                                              AlignmentDirectional(0.0, -1.0),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6, horizontal: 12),
                                          child: Text(
                                            l10n.yourConsumption,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  fontSize: FlutterFlowTheme
                                                      .adjustScale(size: 12.0),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ))),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //   Container(
                      //     margin: const EdgeInsets.only(top: 16),
                      //     child: Stack(
                      //       clipBehavior: Clip.none,
                      //       children: [
                      //         Align(
                      //           alignment: Alignment
                      //               .topCenter, //AlignmentDirectional(0.0, 1.0),
                      //           child: Padding(
                      //             padding: EdgeInsetsDirectional.fromSTEB(
                      //                 12, 12, 12, 18.0),
                      //             child: Container(
                      //               width:
                      //                   MediaQuery.of(context).size.width * 0.98,
                      //               decoration: BoxDecoration(
                      //                 color: FlutterFlowTheme.of(context)
                      //                     .secondaryBackground,
                      //                 borderRadius: BorderRadius.circular(8.0),
                      //                 border: Border.all(
                      //                   color: Colors.transparent,
                      //                   width: 0.0,
                      //                 ),
                      //               ),
                      //               padding: EdgeInsetsDirectional.fromSTEB(
                      //                   16, 24.0, 16, 27.0),
                      //               child: Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.spaceAround,
                      //                 children: [
                      //                   SizedBox(
                      //                     width: 60,
                      //                     child: Column(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.center,
                      //                       spacing: 6,
                      //                       children: [
                      //                         Image.asset(
                      //                           "assets/images/plant_product.png", // <-- add Google logo asset
                      //                           width: 26,
                      //                           height: 27,
                      //                         ),
                      //                         RichText(
                      //                           textAlign: TextAlign.center,
                      //                           text: TextSpan(
                      //                               // text:
                      //                               //     "${l10n.plants}:\n",
                      //                               style: FlutterFlowTheme.of(
                      //                                       context)
                      //                                   .bodyLarge
                      //                                   .override(
                      //                                     color:
                      //                                         FlutterFlowTheme.of(
                      //                                                 context)
                      //                                             .primary,
                      //                                     fontSize: 12.0,
                      //                                     fontWeight:
                      //                                         FontWeight.w400,
                      //                                   ),
                      //                               children: [
                      //                                 TextSpan(
                      //                                   text:
                      //                                       '${calculateTotalPortions(weekConsumption, dietarySource: 1)} g',
                      //                                   style:
                      //                                       FlutterFlowTheme.of(
                      //                                               context)
                      //                                           .bodyLarge
                      //                                           .override(
                      //                                             color: FlutterFlowTheme.of(
                      //                                                     context)
                      //                                                 .primary,
                      //                                             fontSize: 12.0,
                      //                                             fontWeight:
                      //                                                 FontWeight
                      //                                                     .w700,
                      //                                           ),
                      //                                 ),
                      //                               ]),
                      //                         )
                      //                       ],
                      //                     ),
                      //                   ),
                      //                   Container(
                      //                     color: Color(0xffe7e7e7),
                      //                     width: 1,
                      //                     height: 50,
                      //                   ),
                      //                   SizedBox(
                      //                     width: 60,
                      //                     child: Column(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.center,
                      //                       spacing: 6,
                      //                       children: [
                      //                         Image.asset(
                      //                           "assets/images/animal_product.png", // <-- add Google logo asset
                      //                           width: 28,
                      //                           height: 28,
                      //                         ),
                      //                         RichText(
                      //                           textAlign: TextAlign.center,
                      //                           text: TextSpan(
                      //                               // text: l10n
                      //                               //     .animalProducts,
                      //                               style: FlutterFlowTheme.of(
                      //                                       context)
                      //                                   .bodyLarge
                      //                                   .override(
                      //                                     color:
                      //                                         FlutterFlowTheme.of(
                      //                                                 context)
                      //                                             .primary,
                      //                                     fontSize: 12.0,
                      //                                     fontWeight:
                      //                                         FontWeight.w400,
                      //                                   ),
                      //                               children: [
                      //                                 TextSpan(
                      //                                   text:
                      //                                       '${calculateTotalPortions(weekConsumption, dietarySource: 2)} g',
                      //                                   style:
                      //                                       FlutterFlowTheme.of(
                      //                                               context)
                      //                                           .bodyLarge
                      //                                           .override(
                      //                                             color: FlutterFlowTheme.of(
                      //                                                     context)
                      //                                                 .primary,
                      //                                             fontSize: 12.0,
                      //                                             fontWeight:
                      //                                                 FontWeight
                      //                                                     .w700,
                      //                                           ),
                      //                                 ),
                      //                               ]),
                      //                         )
                      //                       ],
                      //                     ),
                      //                   ),
                      //                   Container(
                      //                     color: Color(0xffe7e7e7),
                      //                     width: 1,
                      //                     height: 50,
                      //                   ),
                      //                   SizedBox(
                      //                     width: 60,
                      //                     child: Column(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.center,
                      //                       spacing: 6,
                      //                       children: [
                      //                         Image.asset(
                      //                           "assets/images/ultra_processed_food.png", // <-- add Google logo asset
                      //                           width: 26,
                      //                           height: 26,
                      //                         ),
                      //                         RichText(
                      //                           textAlign: TextAlign.center,
                      //                           text: TextSpan(
                      //                               // text:
                      //                               //     l10n.upf,
                      //                               style: FlutterFlowTheme.of(
                      //                                       context)
                      //                                   .bodyLarge
                      //                                   .override(
                      //                                     color:
                      //                                         FlutterFlowTheme.of(
                      //                                                 context)
                      //                                             .primary,
                      //                                     fontSize: 12.0,
                      //                                     fontWeight:
                      //                                         FontWeight.w400,
                      //                                   ),
                      //                               children: [
                      //                                 TextSpan(
                      //                                   text:
                      //                                       '${calculateTotalPortions(weekConsumption, dietarySource: 3)} g',
                      //                                   style:
                      //                                       FlutterFlowTheme.of(
                      //                                               context)
                      //                                           .bodyLarge
                      //                                           .override(
                      //                                             color: FlutterFlowTheme.of(
                      //                                                     context)
                      //                                                 .primary,
                      //                                             fontSize: 12.0,
                      //                                             fontWeight:
                      //                                                 FontWeight
                      //                                                     .w700,
                      //                                           ),
                      //                                 ),
                      //                               ]),
                      //                         )
                      //                       ],
                      //                     ),
                      //                   ),
                      //                   Container(
                      //                     color: Color(0xffe7e7e7),
                      //                     width: 1,
                      //                     height: 50,
                      //                   ),
                      //                   SizedBox(
                      //                     width: 60,
                      //                     child: Column(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.center,
                      //                       spacing: 6,
                      //                       children: [
                      //                         Image.asset(
                      //                           "assets/images/water.png", // <-- add Google logo asset
                      //                           width: 26,
                      //                           height: 26,
                      //                         ),
                      //                         RichText(
                      //                           textAlign: TextAlign.center,
                      //                           text: TextSpan(
                      //                               // text:
                      //                               //     "${l10n.water}:\n",
                      //                               style: FlutterFlowTheme.of(
                      //                                       context)
                      //                                   .bodyLarge
                      //                                   .override(
                      //                                     color:
                      //                                         FlutterFlowTheme.of(
                      //                                                 context)
                      //                                             .primary,
                      //                                     fontSize: 12.0,
                      //                                     fontWeight:
                      //                                         FontWeight.w400,
                      //                                   ),
                      //                               children: [
                      //                                 TextSpan(
                      //                                   text:
                      //                                       '${calculateTotalPortions(weekConsumption, dietarySource: 4)} ml',
                      //                                   style:
                      //                                       FlutterFlowTheme.of(
                      //                                               context)
                      //                                           .bodyLarge
                      //                                           .override(
                      //                                             color: FlutterFlowTheme.of(
                      //                                                     context)
                      //                                                 .primary,
                      //                                             fontSize: 12.0,
                      //                                             fontWeight:
                      //                                                 FontWeight
                      //                                                     .w700,
                      //                                           ),
                      //                                 ),
                      //                               ]),
                      //                         )
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),

                      //         // week cosumption mon - today
                      //         Align(
                      //           alignment: AlignmentDirectional(0.0, 0.0),
                      //           child: Container(
                      //             width: 180,
                      //             decoration: BoxDecoration(
                      //               color: FlutterFlowTheme.of(context)
                      //                   .primaryBackground,
                      //               borderRadius: BorderRadius.circular(99.0),
                      //             ),
                      //             alignment: AlignmentDirectional(0.0, -1.0),
                      //             child: Padding(
                      //               padding: EdgeInsets.all(4.0),
                      //               child: Row(
                      //                 mainAxisSize: MainAxisSize.max,
                      //                 mainAxisAlignment: MainAxisAlignment.center,
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.center,
                      //                 children: [
                      //                   // Inside your build method where you have the Text widget:
                      //                   Text(
                      //                     displayText,
                      //                     style: FlutterFlowTheme.of(context)
                      //                         .bodyMedium
                      //                         .override(
                      //                           font: GoogleFonts.montserrat(
                      //                             fontWeight: FontWeight.w500,
                      //                             fontStyle:
                      //                                 FlutterFlowTheme.of(context)
                      //                                     .bodyMedium
                      //                                     .fontStyle,
                      //                           ),
                      //                           color:
                      //                               FlutterFlowTheme.of(context)
                      //                                   .primary,
                      //                           fontSize: 15.0,
                      //                           letterSpacing: 0.0,
                      //                           fontWeight: FontWeight.w500,
                      //                           fontStyle:
                      //                               FlutterFlowTheme.of(context)
                      //                                   .bodyMedium
                      //                                   .fontStyle,
                      //                         ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  color: Colors.transparent,
                  height: 88.0,
                  child: Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: wrapWithModel(
                      model: _model.bottomNavbarModel,
                      updateCallback: () => safeSetState(() {}),
                      child: BottomNavbarWidget(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Helper methods for tab content
  Widget _buildFiberChallengeTab(
    BuildContext context,
    _userFiberSoFar,
    _communityFiberSoFar,
  ) {
    var l10n = AppLocalizations.of(context);
    var mileStoneLabel = '${_model.mileStoneLabel} ${l10n.dayGoal}';
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 14,
      children: [
        // Text(
        //   l10n.fiberChallenge,
        //   style: FlutterFlowTheme.of(context).bodyMedium.override(
        //         font: GoogleFonts.montserrat(
        //           fontWeight: FontWeight.bold,
        //           fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
        //         ),
        //         color: FlutterFlowTheme.of(context).primary,
        //         fontSize: 16.0,
        //         letterSpacing: 0.0,
        //         fontWeight: FontWeight.bold,
        //         fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
        //       ),
        // ),
        ScoreRulerWidget(
          userScore: _userFiberSoFar.roundToDouble(),
          communityScore: ((_model.cweeklyFiberScore ?? 0.0).clamp(0.0, 100.0))
              .roundToDouble(),
          height: 181,
          milestone: valueOrDefault<double>(
            _model.fiberDailyRecommended,
            0.0,
          ).round(),
          milestoneLabel: mileStoneLabel,
          hasConsent: _hasAgreementConsent ?? false,
          // (((FFAppState().hasSubscription == false) ||
          //         (_model.cweeklyFiberScoreConsent == false))
          //     ? false
          //     : true),
          currentColor: Color(0xffb8e07a),
          communityColor: FlutterFlowTheme.of(context).commFiber,
          userColor: FlutterFlowTheme.of(context).userFiber,
        ),
        SilverButton(
          buttonTitle: l10n.explore,
          buttonFunction: () async {
            final auditService = UserActionAuditService(supabase);
            await auditService.logUserAction(
              userId: currentUserUid,
              action: 'Explore Fiber score',
              screenName: screenName,
              userData: {
                'week': FFAppState().calendarWeek,
                'year': FFAppState().calendarYear,
              },
            );
            context.pushNamed(
              FiberExplorePage.routeName,
              queryParameters: {'exploreType': 'Fiber Challenge'},
              extra: <String, dynamic>{
                kTransitionInfoKey: const TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                ),
              },
            );
          },
        )
      ],
    );
  }

  Widget _buildWeeklyHealthScoreTab(
      BuildContext context, communityScore, weeklyScore) {
    var l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Text(
        //   l10n.weeklyHealthScore,
        //   style: FlutterFlowTheme.of(context).bodyMedium.override(
        //         font: GoogleFonts.montserrat(
        //           fontWeight: FontWeight.bold,
        //           fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
        //         ),
        //         color: FlutterFlowTheme.of(context).primary,
        //         fontSize: 16.0,
        //         letterSpacing: 0.0,
        //         fontWeight: FontWeight.bold,
        //         fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
        //       ),
        // ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional(0.0, 0.0),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularPercentIndicator(
                    percent: weeklyScore / 100.0,
                    radius: 62,
                    lineWidth: 12.0,
                    backgroundWidth: 16,
                    animation: true,
                    animateFromLastPercent: true,
                    progressColor: _getprogressColorValue(weeklyScore),
                    backgroundColor: Color(0xFFececec),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: CircularPercentIndicator(
                    percent:
                        _hasAgreementConsent ? (communityScore / 100.0) : 0,
                    radius: 81,
                    lineWidth: 12.0,
                    backgroundWidth: 16,
                    animation: true,
                    animateFromLastPercent: true,
                    progressColor: _getprogressColorValue(communityScore),
                    backgroundColor: Color(0xFFececec),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      spacing: 8,
                      children: [
                        Text(
                          l10n.yourScore,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .circularTextColor,
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                    letterSpacing: 0.0,
                                    lineHeight: 1.2,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (_model.weeklyHealthScore?.floor()).toString(),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .circularTextColor,
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 24),
                                    letterSpacing: 0.0,
                                    lineHeight: 0.618,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            Text(
                              '%',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .circularTextColor,
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 16),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w700,
                                    lineHeight: 0.927,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: _hasAgreementConsent ? 10 : 5),
        Column(
          spacing: _hasAgreementConsent ? 20 : 15,
          children: [
            if (!_hasAgreementConsent)
              Container(
                width: 144,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Color(0xffb8b8b8),
                      width: 1,
                      style: BorderStyle.solid),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.block,
                      size: 14,
                    ),
                    Text(
                      l10n.unlockCommunityScore,
                      style:
                          TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            if (_hasAgreementConsent)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${l10n.communityLabel}: ',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          fontSize: FlutterFlowTheme.adjustScale(size: 12),
                          lineHeight: 1.5,
                          letterSpacing: 0.0,
                        ),
                  ),
                  Text(
                    '${(_model.cweeklyHealthScore ?? 0).round()}',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          lineHeight: 0.8,
                          fontSize: FlutterFlowTheme.adjustScale(size: 24),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    '%',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          fontSize: FlutterFlowTheme.adjustScale(size: 16),
                          letterSpacing: 0.0,
                          lineHeight: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            SilverButton(
              buttonTitle: l10n.explore,
              buttonFunction: () async {
                final auditService = UserActionAuditService(supabase);
                await auditService.logUserAction(
                  userId: currentUserUid,
                  action: 'Explore health score',
                  screenName: screenName,
                  userData: {
                    'week': FFAppState().calendarWeek,
                    'year': FFAppState().calendarYear,
                  },
                );
                context.pushNamed(
                  ExplorePage.routeName,
                  extra: <String, dynamic>{
                    kTransitionInfoKey: const TransitionInfo(
                      hasTransition: true,
                      transitionType: PageTransitionType.fade,
                    ),
                  },
                );
              },
            )
          ],
        )
      ],
    );
  }

  Widget _buildProteinChallengeTab(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    var mileStoneLabel = '${_model.mileStoneLabel} ${l10n.dayGoal}';
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 14,
      children: [
        // Text(
        //   l10n.proteinChallenge,
        //   style: FlutterFlowTheme.of(context).bodyMedium.override(
        //         font: GoogleFonts.montserrat(
        //           fontWeight: FontWeight.bold,
        //           fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
        //         ),
        //         color: FlutterFlowTheme.of(context).primary,
        //         fontSize: 16.0,
        //         letterSpacing: 0.0,
        //         fontWeight: FontWeight.bold,
        //         fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
        //       ),
        // ),
        ScoreRulerWidget(
          userScore: valueOrDefault<double>(
            FFAppState().individualIndicators.cwProteinTrackerValue,
            0.0,
          ).roundToDouble(),
          communityScore:
              ((_model.cweeklyProteinScore ?? 0.0).clamp(0.0, 100.0))
                  .roundToDouble(),
          milestone: valueOrDefault<double>(
            _model.proteinDailyRecommended,
            0.0,
          ).round(),
          milestoneLabel: mileStoneLabel,
          height: 181,
          hasConsent: _hasAgreementConsent ?? false,
          // (((FFAppState().hasSubscription == false) ||
          //         (_model.cweeklyProteinScoreConsent == false))
          //     ? false
          //     : true),
          currentColor: Color(0xffff9a62),
          userColor: FlutterFlowTheme.of(context).userPlantProtein,
          communityColor: FlutterFlowTheme.of(context).commPlantProtein,
        ),
        SilverButton(
          buttonTitle: l10n.explore,
          buttonFunction: () async {
            final auditService = UserActionAuditService(supabase);
            await auditService.logUserAction(
              userId: currentUserUid,
              action: 'Explore protein score',
              screenName: screenName,
              userData: {
                'week': FFAppState().calendarWeek,
                'year': FFAppState().calendarYear,
              },
            );
            context.pushNamed(
              FiberExplorePage.routeName,
              queryParameters: {'exploreType': 'Protein Challenge'},
              extra: <String, dynamic>{
                kTransitionInfoKey: const TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                ),
              },
            );
          },
        )
      ],
    );
  }

  Widget _buildMicronutrientTab(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      spacing: 16,
      children: [
        // Text(
        //   'Micronutrient',
        //   style: FlutterFlowTheme.of(context).bodyMedium.override(
        //         font: GoogleFonts.montserrat(
        //           fontWeight: FontWeight.bold,
        //           fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
        //         ),
        //         color: FlutterFlowTheme.of(context).primary,
        //         fontSize: 16.0,
        //         letterSpacing: 0.0,
        //         fontWeight: FontWeight.bold,
        //         fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
        //       ),
        // ),
        Container(
          height: 203,
          margin: const EdgeInsets.only(left: 50, right: 50),
          child: _isNutrientDataLoading
              ? Center(child: CircularProgressIndicator())
              : (features.isEmpty || data1.isEmpty)
                  ? Center(child: Text('No nutrient data available'))
                  : SpiderChart(
                      data1: [40, 50, 60, 65, 80],
                      data2: data1,
                      labels: features,
                      color1: const [
                        Color(0xFFC40CD3),
                        Color(0xFF2883DE),
                      ],
                      color2: const [
                        Color(0xFF00ECFF),
                        Color(0xFF3968E6),
                      ],
                      backgroundColors: const [
                        Color(0xffbababa),
                        Color(0xffcecece),
                        Color(0xffe1e1e1),
                        Color(0xffececec),
                        Color(0xfff9f9f9),
                        Color(0xfff9f9f9),
                        Color(0xffececec),
                        Color(0xffe1e1e1),
                        Color(0xffcecece),
                        Color(0xffbababa),
                        Color(0xffbababa),
                      ],
                      layerCount: 11,
                    ),
        ),
        SilverButton(
          buttonTitle: l10n.explore,
          buttonFunction: () async {
            context.pushNamed(
              LowMicronutrientsPage.routeName,
              queryParameters: {'exploreType': 'Low Mircronutrients Intake'},
              extra: <String, dynamic>{
                kTransitionInfoKey: const TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                ),
              },
            );
          },
        )
      ],
    );
  }

  Widget _buildProgressDots({
    required Color color,
    Color gradientColor = const Color(0xfffafafa),
    required int totalDots,
    required int filledCount,
  }) {
    const double dotSize = 18;
    const double spacing = 16; // padding.left + right (6 + 6)

    return Stack(
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.none,
      children: [
        // Row of dots
        Row(
          spacing: spacing,
          children: List.generate(20, (index) {
            bool isFilled = index < filledCount;
            bool isHalf = index < 3 && !isFilled;

            return Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: !isFilled && !isHalf
                    ? [
                        BoxShadow(
                          color: const Color.fromRGBO(76, 76, 76, 0.15),
                          spreadRadius: 0.5,
                          blurRadius: 0,
                          offset: Offset(0, 0),
                        ),
                      ]
                    : (isFilled
                        ? [
                            BoxShadow(
                              color: const Color.fromRGBO(76, 76, 76, 0.15),
                              spreadRadius: 0.1,
                              blurRadius: 0,
                              offset: Offset(0, 0),
                            ),
                            BoxShadow(
                              color: color.withOpacity(0.6),
                              blurRadius: dotSize * 0.15,
                              spreadRadius: dotSize * 0.05,
                              offset: Offset(1, 1),
                            ),
                          ]
                        : []),
                gradient: isFilled
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          gradientColor, // light top
                          color, // strong orange bottom
                        ],
                      )
                    : (isHalf
                        ? RadialGradient(
                            center: Alignment.center,
                            radius: 0.9,
                            colors: [
                              color.withOpacity(0.2),
                              color.withOpacity(0.6),
                              const Color.fromARGB(37, 0, 0, 0)
                            ],
                            stops: const [0.3, 0.85, 1.0],
                          )
                        : const RadialGradient(
                            center: Alignment.center,
                            radius: 0.9,
                            colors: [
                              Color(0xFFffffff),
                              Color.fromARGB(133, 212, 212, 212),
                            ],
                            stops: [0.2, 1.0],
                          )),
              ),
            );
          }),
        ),

        // Overlay strip when 3 or more are filled
        if (filledCount >= 3 && filledCount < 5)
          Positioned(
            left: 0,
            child: Container(
              height: dotSize + 4, // slightly taller than dots
              width: ((dotSize + spacing) * 3) - spacing,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(99),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.7),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                "Well Done!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (filledCount >= 5 && filledCount < 7)
          Positioned(
            left: 0,
            child: Container(
              height: dotSize + 4, // slightly taller than dots
              width: ((dotSize + spacing) * 5) - spacing,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(99),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.7),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                "Awesome!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (filledCount >= 7 && filledCount < 9)
          Positioned(
            left: 0,
            child: Container(
              height: dotSize + 4, // slightly taller than dots
              width: ((dotSize + spacing) * 7) - spacing,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(99),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.7),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                "Keep Going!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (filledCount >= 9)
          Positioned(
            left: 0,
            child: Container(
              height: dotSize + 4, // slightly taller than dots
              width: ((dotSize + spacing) * 9) - spacing,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(99),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.7),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                "You're crushing it!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _silverButton(
      {double paddingHorizontal = 12.0,
      double paddingVertical = 8.0,
      double marginBottom = 0,
      required String buttonTitle,
      required VoidCallback buttonFunction}) {
    return GestureDetector(
        onTap: buttonFunction,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: paddingVertical, horizontal: paddingHorizontal),
          margin: EdgeInsets.only(bottom: marginBottom),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  width: 1, color: Color(0xffC7c7c7), style: BorderStyle.solid),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 1.0,
                  color: Color.fromRGBO(199, 199, 199, 1),
                  offset: Offset(
                    0.0,
                    0.0,
                  ),
                )
              ],
              gradient: LinearGradient(
                colors: const [Color(0xffffffff), Color(0xffe0e0e0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
          child: Text(
            buttonTitle,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: const Color(0xff6b6b6b),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  fontSize: FlutterFlowTheme.adjustScale(size: 12),
                ),
          ),
        ));
  }
}
