import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'agrimethod_data_entry_widget.dart' show AgrimethodDataEntryWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AgrimethodDataEntryModel
    extends FlutterFlowModel<AgrimethodDataEntryWidget> {
  ///  Local state fields for this component.

  AgrimethodRow? agriMethodDocument;

  ///  State fields for stateful widgets in this component.

  // State field(s) for agriMethodName1 widget.
  FocusNode? agriMethodName1FocusNode;
  TextEditingController? agriMethodName1TextController;
  String? Function(BuildContext, String?)?
      agriMethodName1TextControllerValidator;
  // State field(s) for agriMethodDescription1 widget.
  FocusNode? agriMethodDescription1FocusNode;
  TextEditingController? agriMethodDescription1TextController;
  String? Function(BuildContext, String?)?
      agriMethodDescription1TextControllerValidator;
  // State field(s) for agriMethodName widget.
  FocusNode? agriMethodNameFocusNode;
  TextEditingController? agriMethodNameTextController;
  String? Function(BuildContext, String?)?
      agriMethodNameTextControllerValidator;
  // State field(s) for agriMethodDescription widget.
  FocusNode? agriMethodDescriptionFocusNode;
  TextEditingController? agriMethodDescriptionTextController;
  String? Function(BuildContext, String?)?
      agriMethodDescriptionTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    agriMethodName1FocusNode?.dispose();
    agriMethodName1TextController?.dispose();

    agriMethodDescription1FocusNode?.dispose();
    agriMethodDescription1TextController?.dispose();

    agriMethodNameFocusNode?.dispose();
    agriMethodNameTextController?.dispose();

    agriMethodDescriptionFocusNode?.dispose();
    agriMethodDescriptionTextController?.dispose();
  }
}
