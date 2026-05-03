import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/call_to_action.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'meter_widget.dart' show MeterWidget;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class MeterModel extends FlutterFlowModel<MeterWidget> {
  ///  Local state fields for this page.

  double? userCount;

  double? communityCount;

  double? userRatio;

  double? communityRatio;

  ///  State fields for stateful widgets in this page.

  TutorialCoachMark? callToActionController;
  // Stores action output result for [Custom Action - countUserInteractions] action in Meter widget.
  List<int>? userInteractionOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    callToActionController?.finish();
  }
}
