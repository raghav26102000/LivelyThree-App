import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'plant_details_bottom_sheet_widget.dart'
    show PlantDetailsBottomSheetWidget;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PlantDetailsBottomSheetModel
    extends FlutterFlowModel<PlantDetailsBottomSheetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for PortionSizeDropDown widget.
  double? portionSizeDropDownValue;
  FormFieldController<double>? portionSizeDropDownValueController;
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<WeeklyselectedplantRow>? portionSizeLockingOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
