import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'password_pin_check_widget.dart' show PasswordPinCheckWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PasswordPinCheckModel extends FlutterFlowModel<PasswordPinCheckWidget> {
  ///  Local state fields for this page.

  bool hasSuccess = false;

  String errorMessage = 'n/a';

  String? verificationStatus;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - resendPasswordResetPin] action in Button widget.
  dynamic? resentPassworResetOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
