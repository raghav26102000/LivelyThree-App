import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/bodypanel.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'body_widget.dart' show BodyWidget;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BodyModel extends FlutterFlowModel<BodyWidget> {
  ///  Local state fields for this page.

  Color? period1PhysicalColor;

  Color? period2PhysicalColor;

  Color? period3PhysicalColor;

  Color? period4PhysicalColor;

  Color? period5PhysicalColor;

  Color? period6PhysicalColor;

  Color? period7PhysicalColor;

  Color? period8PhysicalColor;

  Color? period9PhysicalColor;

  Color? period10PhysicalColor;

  Color? period11PhysicalColor;

  Color? period12PhysicalColor;

  ///  State fields for stateful widgets in this page.

  TutorialCoachMark? bodypanelController;
  // Stores action output result for [Custom Action - getPhysicalPanelData] action in Body widget.
  dynamic? physicalPanelInitialOutput;
  // Stores action output result for [Custom Action - insertUpdatePhysicalPanelCoordinatesAndColors] action in Button widget.
  dynamic? physicalPanelUpdatedOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    bodypanelController?.finish();
  }
}
