import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'consent_switch_widget.dart' show ConsentSwitchWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConsentSwitchModel extends FlutterFlowModel<ConsentSwitchWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Switch widget.
  bool? switchValue;
  // Stores action output result for [Custom Action - updateDataContractConsent] action in Switch widget.
  String? contractNameToggleOn;
  // Stores action output result for [Custom Action - updateDataContractConsent] action in Switch widget.
  String? contractNameToggleOff;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
