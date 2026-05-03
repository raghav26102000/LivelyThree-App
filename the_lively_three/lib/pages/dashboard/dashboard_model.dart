import '/auth/supabase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/indicator_chart_bottom_sheet/indicator_chart_bottom_sheet_widget.dart';
import '/components/indicator_combined_chart_bottom_sheet/indicator_combined_chart_bottom_sheet_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/dashboard.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  Local state fields for this page.

  double? weeklyhealthscore;

  double? cweeklyhealthscore;

  int? chealthscoreParticipantCount;

  double? weeklyhealthscorePriorWeek;

  double? cweeklyhealthscorePriorWeek;

  double? weeklycolorgapsPriorWeek;

  double? weeklyAveragePortions;

  double? weeklyAveragePortionsPriorWeek;

  double? weeklyAveragePlants;

  double? weeklyAveragePlantsPriorWeek;

  double? weeklyConsistencyScore;

  double? weeklyConsistencyProgress;

  double? weeklyConsistencyScorePriorWeek;

  double? weeklyHealthScoreProgress;

  double? cweeklyCommunityTrend;

  List<ColorgapsweeklyCDataytypeStruct> cweeklyColorGaps = [];
  void addToCweeklyColorGaps(ColorgapsweeklyCDataytypeStruct item) =>
      cweeklyColorGaps.add(item);
  void removeFromCweeklyColorGaps(ColorgapsweeklyCDataytypeStruct item) =>
      cweeklyColorGaps.remove(item);
  void removeAtIndexFromCweeklyColorGaps(int index) =>
      cweeklyColorGaps.removeAt(index);
  void insertAtIndexInCweeklyColorGaps(
          int index, ColorgapsweeklyCDataytypeStruct item) =>
      cweeklyColorGaps.insert(index, item);
  void updateCweeklyColorGapsAtIndex(
          int index, Function(ColorgapsweeklyCDataytypeStruct) updateFn) =>
      cweeklyColorGaps[index] = updateFn(cweeklyColorGaps[index]);

  int? cweeklyColorGapsParticipantCount;

  double? cweeklyAveragePortions;

  double? cweeklyAveragePlants;

  List<String> weeklyColorGapsColors = [];
  void addToWeeklyColorGapsColors(String item) =>
      weeklyColorGapsColors.add(item);
  void removeFromWeeklyColorGapsColors(String item) =>
      weeklyColorGapsColors.remove(item);
  void removeAtIndexFromWeeklyColorGapsColors(int index) =>
      weeklyColorGapsColors.removeAt(index);
  void insertAtIndexInWeeklyColorGapsColors(int index, String item) =>
      weeklyColorGapsColors.insert(index, item);
  void updateWeeklyColorGapsColorsAtIndex(
          int index, Function(String) updateFn) =>
      weeklyColorGapsColors[index] = updateFn(weeklyColorGapsColors[index]);

  List<FrequentRarePlantsCDatatypeStruct> cweeklyRareFinds = [];
  void addToCweeklyRareFinds(FrequentRarePlantsCDatatypeStruct item) =>
      cweeklyRareFinds.add(item);
  void removeFromCweeklyRareFinds(FrequentRarePlantsCDatatypeStruct item) =>
      cweeklyRareFinds.remove(item);
  void removeAtIndexFromCweeklyRareFinds(int index) =>
      cweeklyRareFinds.removeAt(index);
  void insertAtIndexInCweeklyRareFinds(
          int index, FrequentRarePlantsCDatatypeStruct item) =>
      cweeklyRareFinds.insert(index, item);
  void updateCweeklyRareFindsAtIndex(
          int index, Function(FrequentRarePlantsCDatatypeStruct) updateFn) =>
      cweeklyRareFinds[index] = updateFn(cweeklyRareFinds[index]);

  List<FrequentRarePlantsCDatatypeStruct> cweeklyFrequentFive = [];
  void addToCweeklyFrequentFive(FrequentRarePlantsCDatatypeStruct item) =>
      cweeklyFrequentFive.add(item);
  void removeFromCweeklyFrequentFive(FrequentRarePlantsCDatatypeStruct item) =>
      cweeklyFrequentFive.remove(item);
  void removeAtIndexFromCweeklyFrequentFive(int index) =>
      cweeklyFrequentFive.removeAt(index);
  void insertAtIndexInCweeklyFrequentFive(
          int index, FrequentRarePlantsCDatatypeStruct item) =>
      cweeklyFrequentFive.insert(index, item);
  void updateCweeklyFrequentFiveAtIndex(
          int index, Function(FrequentRarePlantsCDatatypeStruct) updateFn) =>
      cweeklyFrequentFive[index] = updateFn(cweeklyFrequentFive[index]);

  bool cWeeklyHealthscoreConsent = false;

  bool cWeeklyAveragePlantsConsent = false;

  bool cWeeklyAveragePortionsConsent = false;

  bool cColorGapsWeeklyConsent = false;

  bool cFrequentFiveConsent = false;

  bool cRareFindsConsent = false;

  bool cTrendWatchConsent = false;

  bool cWeekendDivergenceConsent = false;

  double? fiberTrackerIndividual;

  double? proteinTrackerIndividual;

  double? fiberTrackerCommunity;

  double? proteinTrackerCommunity;

  bool hasWeightValue = false;

  double? weightValue;

  double? proteinDailyRecommended;

  bool cFiberTrackerConsent = false;

  bool cProteinTrackerConsent = false;

  int? weeklyColorGaps;

  double? fiberDailyRecommended;

  bool isPageReady = false;

  ///  State fields for stateful widgets in this page.

  TutorialCoachMark? dashboardController;
  // Stores action output result for [Backend Call - Query Rows] action in Dashboard widget.
  List<ViewUserConsentedIndicatorsRow>? consentedIndicatorsOutput;
  // Stores action output result for [Custom Action - getNextIndicatorCalculationTime] action in Dashboard widget.
  dynamic? nextJobRuntimeOutput;
  // Stores action output result for [Backend Call - Query Rows] action in Dashboard widget.
  List<UserVitalsRow>? mostRecentWeightOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dashboardController?.finish();
  }
}
