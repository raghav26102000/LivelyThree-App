import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_check_model.dart';
export 'signup_check_model.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/l10n/app_localizations.dart';

class SignupCheckWidget extends StatefulWidget {
  const SignupCheckWidget({
    super.key,
    required this.emailaddress,
    required this.password,
  });

  final String? emailaddress;
  final String? password;

  static String routeName = 'SignupCheck';
  static String routePath = '/signupcheck';

  @override
  State<SignupCheckWidget> createState() => _SignupCheckWidgetState();
}

class _SignupCheckWidgetState extends State<SignupCheckWidget> {
  late SignupCheckModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignupCheckModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// ✅ resend pin function
  Future<void> _resendPin() async {
    setState(() {
      _isResending = true;
    });

    _model.resendPinOutput =
        await actions.resendVerificationEmail(widget.emailaddress!);

    _model.hasSuccess = getJsonField(
      _model.resendPinOutput,
      r'''$.success''',
    );
    safeSetState(() {});

    if (_model.hasSuccess == true) {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.confirmation),
            content: Text(
                AppLocalizations.of(context)!.verificationMailSent),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } else {
      _model.errorMessage = getJsonField(
        _model.resendPinOutput,
        r'''$.error''',
      ).toString();
      safeSetState(() {});
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: const Text('Note'),
            content: Text(_model.errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _isResending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            localization.confirmation,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close, size: 22, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 280,
                    child: Text(
                      "${localization.enterCode} ${widget.emailaddress}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ✅ OTP input box with custom widget
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      spacing: 30,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          localization.enterEmailCode,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.1,
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          child: custom_widgets.SignupPinVerificationWidget(
                            width: MediaQuery.sizeOf(context).width * 0.75,
                            height: MediaQuery.sizeOf(context).height * 0.1,
                            pinLength: 6,
                            email: widget.emailaddress!,
                            password: widget.password!,
                            onVerificationResult: (verificationStatus) async {
                              //_model.verificationStatus = verificationStatus;
                              safeSetState(() {});
                              print('call verification status = $verificationStatus');
                              if (verificationStatus) {
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      title: Text(localization.confirmation),
                                      content: Text(
                                          localization.verifiedProceedLogin),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(alertDialogContext),
                                          child: Text(localization.ok),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                context.pushNamed(
                                  LoginWidget.routeName,
                                  queryParameters: {
                                    'preferredTabIndex': serializeParam(
                                      0,
                                      ParamType.int,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: const Duration(milliseconds: 200),
                                    ),
                                  },
                                );
                                suppressAuthNavigation = false;
                              }
                            },
                          ),
                        ),
                        InkWell(
                          onTap: _isResending ? null : _resendPin,
                          child: Text(
                            _isResending
                                ? localization.resending
                                : localization.resendPin,
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
