import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'signup_check_widget.dart' show SignupCheckWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignupCheckModel extends FlutterFlowModel<SignupCheckWidget> {
  ///  Local state fields for this page.

  bool hasSuccess = false;

  String errorMessage = 'n/a';

  bool? verificationStatus;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - resendVerificationEmail] action in Text widget.
  dynamic? resendPinOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
