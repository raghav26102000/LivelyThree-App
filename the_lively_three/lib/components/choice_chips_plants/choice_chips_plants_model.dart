import '/auth/supabase_auth/auth_util.dart';
import '/components/plant_details_bottom_sheet/plant_details_bottom_sheet_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'choice_chips_plants_widget.dart' show ChoiceChipsPlantsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChoiceChipsPlantsModel extends FlutterFlowModel<ChoiceChipsPlantsWidget> {
  ///  Local state fields for this component.

  double? fiberLower;

  double? fiberActual;

  double? fiberUpper;

  double? proteinLower;

  double? proteinActual;

  double? proteinUpper;

  double? fatLower;

  double? fatActual;

  double? fatUpper;

  double? carbsLower;

  double? carbsActual;

  double? carbsUpper;

  String? fiberUpperPlant;

  String? fiberLowerPlant;

  String? proteinUpperPlant;

  String? proteinLowerPlant;

  String? fatUpperPlant;

  String? fatLowerPlant;

  String? carbsUpperPlant;

  String? carbsLowerPlant;

  int? fiberRating;

  int? proteinRating;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
