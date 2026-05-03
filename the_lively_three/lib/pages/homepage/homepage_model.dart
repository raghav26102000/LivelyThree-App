// ignore_for_file: depend_on_referenced_packages
import 'package:the_lively_three/components/bottom_navbar/bottom_navbar_model.dart';

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
import 'homepage_widget.dart' show HomepageWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePageModel extends FlutterFlowModel<HomepageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  // State field(s) for RatingBar widget.
  double? ratingBarValue1;
  // State field(s) for RatingBar widget.
  double? ratingBarValue2;
  // State field(s) for RatingBar widget.
  double? ratingBarValue3;
  // State field(s) for RatingBar widget.
  double? ratingBarValue4;
  // State field(s) for RatingBar widget.
  double? ratingBarValue5;
  // State field(s) for RatingBar widget.
  double? ratingBarValue6;
  // State field(s) for RatingBar widget.
  double? ratingBarValue7;
  // Model for bottomNavbar component.
  late BottomNavbarModel bottomNavbarModel;

  bool isMonday = true;

  bool isTuesday = false;

  bool isWednesday = false;

  bool isThursday = false;

  bool isFriday = false;

  bool isSaturday = false;

  bool isSunday = false;

  double? weeklyHealthScore;

  double? cweeklyHealthScore;
  int? cweeklyProteinScoreId;
  int? cweeklyHealthScoreId;
  int? cweeklyFiberScoreId;


  double? progressBarValue;

  int dayPageViewIndex = 0;

  Color? progressColorValue;

  bool cweeklyhealthscoreConsent = false;

  bool isPageReady = false;

  int? plantsLeft;

  int? colorsLeft;

  double? portionsLeft;
  
  double fiberChallengeMilestone = 0.0;

  double cweeklyProteinScore = 0.0;
  
  double cweeklyFiberScore = 0.0;

  bool cweeklyFiberScoreConsent = false;

  bool cweeklyProteinScoreConsent = false;
  
  bool hasWeightValue = false;

  double? weightValue;

  double? proteinDailyRecommended;

  double? fiberDailyRecommended;
  String mileStoneLabel = '';
  // Stores action output result for [Backend Call - Query Rows] action in Homepage widget.
  List<UsersRow>? userDataOutput;
  // Stores action output result for [Backend Call - Query Rows] action in Homepage widget.
  List<WeeklyselectedplantRow>? weekCheck;
  // Stores action output result for [Backend Call - Query Rows] action in Homepage widget.
  List<ViewIndividualIndicatorsValuesRow>? healthscoreoutput;
  // Stores action output result for [Backend Call - Query Rows] action in Homepage widget.
  List<ViewCommunityIndicatorsRow>? cHealthscoreoutput;
  // Stores action output result for [Custom Action - extractDayOfTheWeek] action in Homepage widget.
  String? currentDay;
  // Stores action output result for [Custom Action - getWeekRange] action in Homepage widget.
  String? dateRangeOutput;
  // Stores action output result for [Backend Call - Query Rows] action in Homepage widget.
  List<ViewUserConsentedIndicatorsRow>? consentedIndicatorsOutput;
  // State field(s) for DayPageView widget.
  PageController? dayPageViewController;
  List<UserVitalsRow>? mostRecentWeightOutput;

  @override
  void initState(BuildContext context) {
    bottomNavbarModel = createModel(context, () => BottomNavbarModel());
  }

  @override
  void dispose() {
    bottomNavbarModel.dispose();
  }

  // Ordinal helper (1st, 2nd, 3rd, 4th ...)
String _ordinal(int n) {
  final mod100 = n % 100;
  if (mod100 >= 11 && mod100 <= 13) return '${n}th';
  switch (n % 10) {
    case 1: return '${n}st';
    case 2: return '${n}nd';
    case 3: return '${n}rd';
    default: return '${n}th';
  }
}

/// Call this *after* currentDayNumber and userFiberValue are set.
void updateFiberMilestoneFromAppState() {
  // Guard against 0 and null; clamp to [1..7]
  final day = (FFAppState().currentDayNumber ?? 1).clamp(1, 7);
  final daily = FFAppState().userFiberValue ?? 0.0;

  fiberChallengeMilestone = (daily * day).toDouble();
  mileStoneLabel = '${_ordinal(day)}';
}
  static String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMM - EEE');
    return formatter.format(now);
  }

  /// Action blocks.
  Future isDay(BuildContext context) async {
    await Future.wait([
      Future(() async {
        if (FFAppState().currentDay == 'Monday') {
          isMonday = true;
          FFAppState().currentDayNumber = 1;
        }
      }),
      Future(() async {
        if (FFAppState().currentDay == 'Tuesday') {
          isMonday = true;
          isTuesday = true;
          FFAppState().currentDayNumber = 2;
        }
      }),
      Future(() async {
        if (FFAppState().currentDay == 'Wednesday') {
          isMonday = true;
          isTuesday = true;
          isWednesday = true;
          FFAppState().currentDayNumber = 3;
        }
      }),
      Future(() async {
        if (FFAppState().currentDay == 'Thursday') {
          isMonday = true;
          isTuesday = true;
          isWednesday = true;
          isThursday = true;
          FFAppState().currentDayNumber = 4;
        }
      }),
      Future(() async {
        if (FFAppState().currentDay == 'Friday') {
          isMonday = true;
          isTuesday = true;
          isWednesday = true;
          isThursday = true;
          isFriday = true;
          FFAppState().currentDayNumber = 5;
        }
      }),
      Future(() async {
        if (FFAppState().currentDay == 'Saturday') {
          isMonday = true;
          isTuesday = true;
          isWednesday = true;
          isThursday = true;
          isFriday = true;
          isSaturday = true;
          FFAppState().currentDayNumber = 6;
        }
      }),
      Future(() async {
        if (FFAppState().currentDay == 'Sunday') {
          isMonday = true;
          isTuesday = true;
          isWednesday = true;
          isThursday = true;
          isFriday = true;
          isSaturday = true;
          isSunday = true;
          FFAppState().currentDayNumber = 7;
        }
      }),
    ]);
  }
}
