import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'portionchange_widget.dart' show PortionchangeWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PortionchangeModel extends FlutterFlowModel<PortionchangeWidget> {
  ///  Local state fields for this page.

  double? mondayPortion;

  double? tuesdayPortion;

  double? wednesdayPortion;

  double? thursdayPortion;

  double? fridayPortion;

  double? saturdayPortion;

  double? sundayPortion;

  double? portionSize;

  bool isMonday = false;

  bool isTuesday = false;

  bool? isWednesday = false;

  bool isThursday = false;

  bool isFriday = false;

  bool isSaturday = false;

  bool isSunday = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in Portionchange widget.
  List<ViewWeeklyselectedplantRow>? weeklyPortions;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
