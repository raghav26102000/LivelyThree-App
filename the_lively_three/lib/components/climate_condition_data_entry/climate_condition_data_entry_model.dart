import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'climate_condition_data_entry_widget.dart'
    show ClimateConditionDataEntryWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ClimateConditionDataEntryModel
    extends FlutterFlowModel<ClimateConditionDataEntryWidget> {
  ///  Local state fields for this component.

  ClimateconditionRow? climateDocument;

  ///  State fields for stateful widgets in this component.

  // State field(s) for climateName1 widget.
  FocusNode? climateName1FocusNode;
  TextEditingController? climateName1TextController;
  String? Function(BuildContext, String?)? climateName1TextControllerValidator;
  // State field(s) for climateDescription1 widget.
  FocusNode? climateDescription1FocusNode;
  TextEditingController? climateDescription1TextController;
  String? Function(BuildContext, String?)?
      climateDescription1TextControllerValidator;
  // State field(s) for climateRegion1 widget.
  FocusNode? climateRegion1FocusNode;
  TextEditingController? climateRegion1TextController;
  String? Function(BuildContext, String?)?
      climateRegion1TextControllerValidator;
  // State field(s) for climateName2 widget.
  FocusNode? climateName2FocusNode;
  TextEditingController? climateName2TextController;
  String? Function(BuildContext, String?)? climateName2TextControllerValidator;
  // State field(s) for climateDescription2 widget.
  FocusNode? climateDescription2FocusNode;
  TextEditingController? climateDescription2TextController;
  String? Function(BuildContext, String?)?
      climateDescription2TextControllerValidator;
  // State field(s) for climateRegion2 widget.
  FocusNode? climateRegion2FocusNode;
  TextEditingController? climateRegion2TextController;
  String? Function(BuildContext, String?)?
      climateRegion2TextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    climateName1FocusNode?.dispose();
    climateName1TextController?.dispose();

    climateDescription1FocusNode?.dispose();
    climateDescription1TextController?.dispose();

    climateRegion1FocusNode?.dispose();
    climateRegion1TextController?.dispose();

    climateName2FocusNode?.dispose();
    climateName2TextController?.dispose();

    climateDescription2FocusNode?.dispose();
    climateDescription2TextController?.dispose();

    climateRegion2FocusNode?.dispose();
    climateRegion2TextController?.dispose();
  }
}
