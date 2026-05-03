import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'data_contract_entry_widget.dart' show DataContractEntryWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DataContractEntryModel extends FlutterFlowModel<DataContractEntryWidget> {
  ///  Local state fields for this component.

  bool consentValue = true;

  bool isToggleDisabled = false;

  DateTime? effectiveConsentDate;

  bool hasEffectiveConsentDate = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - initializeUserContractandLog] action in dataContractEntry widget.
  bool? consentOutput;
  // Stores action output result for [Backend Call - Query Rows] action in dataContractEntry widget.
  List<UsercontractsRow>? effectiveConsentWithdrawalOutput;
  // Stores action output result for [Custom Action - isWithinTimeWindow] action in dataContractEntry widget.
  bool? isWithinTimeOutput;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController;

  // State field(s) for Switch widget.
  bool? switchValue1;
  // Stores action output result for [Custom Action - updateDataContractConsent] action in Switch widget.
  String? consentUpateToggledOnOutput;
  // Stores action output result for [Custom Action - updateDataContractConsent] action in Switch widget.
  String? updateConsentToggledOffOutput;
  // Stores action output result for [Backend Call - Query Rows] action in Switch widget.
  List<UsercontractsRow>? effectiveConsentDateOutput;
  // State field(s) for Switch widget.
  bool? switchValue2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    expandableExpandableController.dispose();
  }
}
