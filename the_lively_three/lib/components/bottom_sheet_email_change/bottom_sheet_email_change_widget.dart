import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bottom_sheet_email_change_model.dart';
export 'bottom_sheet_email_change_model.dart';

class BottomSheetEmailChangeWidget extends StatefulWidget {
  const BottomSheetEmailChangeWidget({
    super.key,
    String? oldMail,
    String? newMail,
  })  : this.oldMail = oldMail ?? 'n/a',
        this.newMail = newMail ?? 'n/a';

  final String oldMail;
  final String newMail;

  @override
  State<BottomSheetEmailChangeWidget> createState() =>
      _BottomSheetEmailChangeWidgetState();
}

class _BottomSheetEmailChangeWidgetState
    extends State<BottomSheetEmailChangeWidget> {
  late BottomSheetEmailChangeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BottomSheetEmailChangeModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.7,
                height: MediaQuery.sizeOf(context).height * 0.24,
                decoration: BoxDecoration(),
                child: Text(
                  'Enter the pin to finish the email change. ',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: MediaQuery.sizeOf(context).height * 0.2,
              child: custom_widgets.EmailChangePinWidget(
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: MediaQuery.sizeOf(context).height * 0.2,
                newEmail: widget!.newMail,
                pinLength: 6,
                userId: currentUserUid,
                oldEmail: widget!.oldMail,
                onVerificationResult: (verificationResult) async {
                  _model.verificationStatus = verificationResult!;
                  safeSetState(() {});
                  if (verificationResult == 'verified') {
                    Navigator.pop(context, widget!.newMail);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
