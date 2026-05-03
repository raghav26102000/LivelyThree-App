import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/moodpanel.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'mood_widget.dart' show MoodWidget;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MoodModel extends FlutterFlowModel<MoodWidget> {
  ///  Local state fields for this page.

  Color? period1MoodColor;

  Color? period2MoodColor;

  Color? period6MoodColor;

  Color? period7MoodColor;

  Color? period8MoodColor;

  Color? period9MoodColor;

  Color? period10MoodColor;

  Color? period3MoodColor;

  Color? period4MoodColor;

  Color? period5MoodColor;

  Color? period11MoodColor;

  Color? period12MoodColor;

  ///  State fields for stateful widgets in this page.

  TutorialCoachMark? moodpanelController;
  // Stores action output result for [Custom Action - getMoodPanelData] action in Mood widget.
  dynamic? moodPanelInitlalOutput;
  // Stores action output result for [Custom Action - insertUpdateMoodPanelCoordinatesAndColors] action in Button widget.
  dynamic? moodPanelUpdatedOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    moodpanelController?.finish();
  }
}
