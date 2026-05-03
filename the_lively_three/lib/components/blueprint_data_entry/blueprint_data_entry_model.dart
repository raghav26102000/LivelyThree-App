import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/nutrient_value/nutrient_value_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'blueprint_data_entry_widget.dart' show BlueprintDataEntryWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BlueprintDataEntryModel
    extends FlutterFlowModel<BlueprintDataEntryWidget> {
  ///  Local state fields for this component.

  BlueprintplantRow? blueprintPlantDocument;

  int? blueprintPlantIndex;

  int? counter;

  int? nutrientmax;

  ///  State fields for stateful widgets in this component.

  // State field(s) for plantname1 widget.
  FocusNode? plantname1FocusNode;
  TextEditingController? plantname1TextController;
  String? Function(BuildContext, String?)? plantname1TextControllerValidator;
  // State field(s) for species1 widget.
  FocusNode? species1FocusNode;
  TextEditingController? species1TextController;
  String? Function(BuildContext, String?)? species1TextControllerValidator;
  // State field(s) for category1 widget.
  String? category1Value;
  FormFieldController<String>? category1ValueController;
  // State field(s) for kCal1 widget.
  FocusNode? kCal1FocusNode;
  TextEditingController? kCal1TextController;
  String? Function(BuildContext, String?)? kCal1TextControllerValidator;
  // State field(s) for color1 widget.
  String? color1Value;
  FormFieldController<String>? color1ValueController;
  // State field(s) for plantname2 widget.
  FocusNode? plantname2FocusNode;
  TextEditingController? plantname2TextController;
  String? Function(BuildContext, String?)? plantname2TextControllerValidator;
  // State field(s) for speciesField2 widget.
  FocusNode? speciesField2FocusNode;
  TextEditingController? speciesField2TextController;
  String? Function(BuildContext, String?)? speciesField2TextControllerValidator;
  // State field(s) for category2 widget.
  String? category2Value;
  FormFieldController<String>? category2ValueController;
  // State field(s) for kCal2 widget.
  FocusNode? kCal2FocusNode;
  TextEditingController? kCal2TextController;
  String? Function(BuildContext, String?)? kCal2TextControllerValidator;
  // State field(s) for color2 widget.
  String? color2Value;
  FormFieldController<String>? color2ValueController;
  // Models for nutrientValue dynamic component.
  late FlutterFlowDynamicModels<NutrientValueModel> nutrientValueModels;

  @override
  void initState(BuildContext context) {
    nutrientValueModels = FlutterFlowDynamicModels(() => NutrientValueModel());
  }

  @override
  void dispose() {
    plantname1FocusNode?.dispose();
    plantname1TextController?.dispose();

    species1FocusNode?.dispose();
    species1TextController?.dispose();

    kCal1FocusNode?.dispose();
    kCal1TextController?.dispose();

    plantname2FocusNode?.dispose();
    plantname2TextController?.dispose();

    speciesField2FocusNode?.dispose();
    speciesField2TextController?.dispose();

    kCal2FocusNode?.dispose();
    kCal2TextController?.dispose();

    nutrientValueModels.dispose();
  }
}
