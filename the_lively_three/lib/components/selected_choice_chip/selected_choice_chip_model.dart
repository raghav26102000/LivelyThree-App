import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'selected_choice_chip_widget.dart' show SelectedChoiceChipWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SelectedChoiceChipModel
    extends FlutterFlowModel<SelectedChoiceChipWidget> {
  ///  Local state fields for this component.

  bool selected = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in selectedChoiceChip widget.
  List<WeeklyselectedplantRow>? selectedPlantOutput;
  // Stores action output result for [Backend Call - Query Rows] action in Container widget.
  List<WeeklyselectedplantRow>? selectedPlantPortionOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
