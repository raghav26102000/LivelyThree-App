import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'password_pin_check_model.dart';
export 'password_pin_check_model.dart';

class PasswordPinCheckWidget extends StatefulWidget {
  const PasswordPinCheckWidget({
    super.key,
    required this.emailaddress,
  });

  final String? emailaddress;

  static String routeName = 'PasswordPinCheck';
  static String routePath = '/passwordpincheck';

  @override
  State<PasswordPinCheckWidget> createState() => _PasswordPinCheckWidgetState();
}

class _PasswordPinCheckWidgetState extends State<PasswordPinCheckWidget> {
  late PasswordPinCheckModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PasswordPinCheckModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/images/Rainbow_Icon.jpg',
                          width: 180.0,
                          height: 180.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: MediaQuery.sizeOf(context).height * 0.65,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0x58FFFFFF),
                            Color(0x2DF83B46),
                            Color(0x3DFF8700),
                            Color(0x43FBE403),
                            Color(0x2400E4FF),
                            Color(0x226D00FF),
                            Color(0x2AF500FF),
                            Color(0x31FFFFFF),
                            Color(0x27F0F5F9)
                          ],
                          stops: [
                            0.2,
                            0.32,
                            0.37,
                            0.42,
                            0.49,
                            0.56,
                            0.61,
                            0.75,
                            1.0
                          ],
                          begin: AlignmentDirectional(0.34, -1.0),
                          end: AlignmentDirectional(-0.34, 1.0),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.password,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 150.0,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                decoration: BoxDecoration(),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'Please check your inbox and enter the 6-digit pin into the form below.',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 20.0),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.7,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.1,
                                      child: custom_widgets
                                          .PasswordPinVerificationWidget(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.7,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.1,
                                        email: widget!.emailaddress!,
                                        pinLength: 6,
                                        onVerificationResult:
                                            (verificationStatus) async {
                                          _model.verificationStatus =
                                              verificationStatus;
                                          safeSetState(() {});
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Confirmation'),
                                                content: Text(
                                                    'The pin has been verified. Click ok to reset your password.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          context.pushNamed(
                                            PasswordResetWidget.routeName,
                                            queryParameters: {
                                              'emailaddress': serializeParam(
                                                widget!.emailaddress,
                                                ParamType.String,
                                              ),
                                            }.withoutNulls,
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey:
                                                  TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType.fade,
                                                duration:
                                                    Duration(milliseconds: 200),
                                              ),
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FFButtonWidget(
                                    onPressed: () async {
                                      _model.resentPassworResetOutput =
                                          await actions.resendPasswordResetPin(
                                        widget!.emailaddress!,
                                      );
                                      _model.hasSuccess = getJsonField(
                                        _model.resentPassworResetOutput,
                                        r'''$.success''',
                                      );
                                      safeSetState(() {});
                                      if (_model.hasSuccess == true) {
                                        await showDialog(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              title: Text('Confirmation'),
                                              content: Text(
                                                  'A new reset pin has been sent to your email account.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          alertDialogContext),
                                                  child: Text('Ok'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        _model.errorMessage = getJsonField(
                                          _model.resentPassworResetOutput,
                                          r'''$.error''',
                                        ).toString();
                                        safeSetState(() {});
                                        await showDialog(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              title: Text('Note'),
                                              content:
                                                  Text(_model.errorMessage),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          alertDialogContext),
                                                  child: Text('Ok'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }

                                      safeSetState(() {});
                                    },
                                    text: 'Resend Pin',
                                    options: FFButtonOptions(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.45,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.04,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmallFamily,
                                            color: Colors.white,
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 20.0),
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleSmallIsCustom,
                                          ),
                                      elevation: 2.0,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
