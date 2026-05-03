import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'password_reset_widget.dart' show PasswordResetWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PasswordResetModel extends FlutterFlowModel<PasswordResetWidget> {
  ///  Local state fields for this page.

  bool hasSuccess = false;

  String errorMessage = 'n/a';

  String? verificationStatus;

  ///  State fields for stateful widgets in this page.

  // State field(s) for passwordRecreate widget.
  FocusNode? passwordRecreateFocusNode;
  TextEditingController? passwordRecreateTextController;
  late bool passwordRecreateVisibility;
  String? Function(BuildContext, String?)?
      passwordRecreateTextControllerValidator;
  // State field(s) for passwordReconfirm widget.
  FocusNode? passwordReconfirmFocusNode;
  TextEditingController? passwordReconfirmTextController;
  late bool passwordReconfirmVisibility;
  String? Function(BuildContext, String?)?
      passwordReconfirmTextControllerValidator;
  // Stores action output result for [Custom Action - submitNewPassword] action in Button widget.
  dynamic? passwordRecreateOutput;

  @override
  void initState(BuildContext context) {
    passwordRecreateVisibility = false;
    passwordReconfirmVisibility = false;
  }

  @override
  void dispose() {
    passwordRecreateFocusNode?.dispose();
    passwordRecreateTextController?.dispose();

    passwordReconfirmFocusNode?.dispose();
    passwordReconfirmTextController?.dispose();
  }
}
