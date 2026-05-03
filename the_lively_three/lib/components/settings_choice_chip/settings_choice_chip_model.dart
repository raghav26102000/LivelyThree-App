import '/auth/supabase_auth/auth_util.dart';
import '/components/plant_details_bottom_sheet/plant_details_bottom_sheet_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'settings_choice_chip_widget.dart' show SettingsChoiceChipWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsChoiceChipModel
    extends FlutterFlowModel<SettingsChoiceChipWidget> {
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

  String? fiberLowerPlant;

  String? fiberUpperPlant;

  String? proteinLowerPlant;

  String? proteinUpperPlant;

  String? fatLowerPlant;

  String? fatUpperPlant;

  String? carbsLowerPlant;

  String? carbsUpperPlant;

  int? fiberRating;

  int? proteinRating;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
