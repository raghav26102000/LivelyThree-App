import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/addons.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'addons_widget.dart' show AddonsWidget;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddonsModel extends FlutterFlowModel<AddonsWidget> {
  ///  Local state fields for this page.

  int? monUpfCounter;

  int? tueUpfCounter;

  int? wedUpfCounter;

  int? thuUpfCounter;

  int? friUpfCounter;

  int? satUpfCounter;

  int? sunUpfCounter;

  int? todayUpfCounter;

  List<int> upfCounterList = [];
  void addToUpfCounterList(int item) => upfCounterList.add(item);
  void removeFromUpfCounterList(int item) => upfCounterList.remove(item);
  void removeAtIndexFromUpfCounterList(int index) =>
      upfCounterList.removeAt(index);
  void insertAtIndexInUpfCounterList(int index, int item) =>
      upfCounterList.insert(index, item);
  void updateUpfCounterListAtIndex(int index, Function(int) updateFn) =>
      upfCounterList[index] = updateFn(upfCounterList[index]);

  int? monWaterCounter;

  int? tueWaterCounter;

  int? wedWaterCounter;

  int? thuWaterCounter;

  int? friWaterCounter;

  int? satWaterCounter;

  int? sunWaterCounter;

  int? todayWaterCounter;

  List<int> waterCounterList = [];
  void addToWaterCounterList(int item) => waterCounterList.add(item);
  void removeFromWaterCounterList(int item) => waterCounterList.remove(item);
  void removeAtIndexFromWaterCounterList(int index) =>
      waterCounterList.removeAt(index);
  void insertAtIndexInWaterCounterList(int index, int item) =>
      waterCounterList.insert(index, item);
  void updateWaterCounterListAtIndex(int index, Function(int) updateFn) =>
      waterCounterList[index] = updateFn(waterCounterList[index]);

  int? idxUpf;

  int? idxWater;

  double? weightValueDB;

  String? weightUnitValueDB;

  DateTime? dateWeightValue;

  ///  State fields for stateful widgets in this page.

  TutorialCoachMark? addonsController;
  // Stores action output result for [Backend Call - Query Rows] action in Addons widget.
  List<WeeklyselectedUpfRow>? upfOutput;
  // Stores action output result for [Backend Call - Query Rows] action in Addons widget.
  List<UserVitalsRow>? weightListOutput;
  // Stores action output result for [Backend Call - Query Rows] action in Addons widget.
  List<WeeklyselectedWaterRow>? waterOutput;
  // Stores action output result for [Custom Action - upsertWeeklySelectedUPF] action in TapRippleButton widget.
  int? newDayUpfPortionOutput;
  // Stores action output result for [Custom Action - decrementWeeklySelectedUPF] action in ListView widget.
  int? decrementUpfPortionOutput;
  // Stores action output result for [Custom Action - upsertWeeklySelectedWater] action in TapRippleButton widget.
  int? newDayWaterPortionOutput;
  // Stores action output result for [Custom Action - decrementWeeklySelectedWater] action in ListView widget.
  int? decrementWaterPortionOutput;
  // Stores action output result for [Backend Call - Query Rows] action in WeightPicker widget.
  List<UserVitalsRow>? weightListOutput2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    addonsController?.finish();
  }
}
