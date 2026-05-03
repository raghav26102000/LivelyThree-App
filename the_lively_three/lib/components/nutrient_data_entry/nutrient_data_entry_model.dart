import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'nutrient_data_entry_widget.dart' show NutrientDataEntryWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NutrientDataEntryModel extends FlutterFlowModel<NutrientDataEntryWidget> {
  ///  Local state fields for this component.

  NutrientRow? nutrientDocument;

  ///  State fields for stateful widgets in this component.

  // State field(s) for nutrientName1 widget.
  FocusNode? nutrientName1FocusNode;
  TextEditingController? nutrientName1TextController;
  String? Function(BuildContext, String?)? nutrientName1TextControllerValidator;
  // State field(s) for nutrientDescription1 widget.
  FocusNode? nutrientDescription1FocusNode;
  TextEditingController? nutrientDescription1TextController;
  String? Function(BuildContext, String?)?
      nutrientDescription1TextControllerValidator;
  // State field(s) for nutrientCategory1 widget.
  String? nutrientCategory1Value;
  FormFieldController<String>? nutrientCategory1ValueController;
  // State field(s) for nutrientName2 widget.
  FocusNode? nutrientName2FocusNode;
  TextEditingController? nutrientName2TextController;
  String? Function(BuildContext, String?)? nutrientName2TextControllerValidator;
  // State field(s) for nutrientDescription2 widget.
  FocusNode? nutrientDescription2FocusNode;
  TextEditingController? nutrientDescription2TextController;
  String? Function(BuildContext, String?)?
      nutrientDescription2TextControllerValidator;
  // State field(s) for nutrientCategory2 widget.
  String? nutrientCategory2Value;
  FormFieldController<String>? nutrientCategory2ValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nutrientName1FocusNode?.dispose();
    nutrientName1TextController?.dispose();

    nutrientDescription1FocusNode?.dispose();
    nutrientDescription1TextController?.dispose();

    nutrientName2FocusNode?.dispose();
    nutrientName2TextController?.dispose();

    nutrientDescription2FocusNode?.dispose();
    nutrientDescription2TextController?.dispose();
  }
}
