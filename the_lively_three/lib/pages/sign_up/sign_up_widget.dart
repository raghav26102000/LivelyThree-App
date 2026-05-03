import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:the_lively_three/components/bottom_navbar/bottom_navbar_widget.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/pages/consistency/consistency_widget.dart';
import 'package:the_lively_three/pages/sign_up/sign_up_model.dart';
import 'package:the_lively_three/pages/sign_up_otp/sign_up_otp_widget.dart';
import 'package:the_lively_three/pages/signup_check/signup_check_widget.dart'; // Add this import
import 'package:the_lively_three/flutter_flow/custom_functions.dart'
    as functions; // Add this for actions
import '/l10n/app_localizations.dart';
import '/custom_code/actions/index.dart' as actions;

import '/index.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});
  static String routeName = 'SignUp';
  static String routePath = '/signup';
  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  late SignUpModel _model;
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool _isSignUpFormVisible = false;

  bool _isLoading = false; // Add loading state
  int _passwordScore = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignUpModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  toggleSignUpForm() {
    setState(() {
      _isSignUpFormVisible = !_isSignUpFormVisible;
    });
  }

  // Function to handle signup process
  Future<void> _handleSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      // Get password from the text controller
      String email =
          (_model.emailAddressCreateTextController?.text ?? '').trim();
      String pwd = (_model.passwordCreateTextController?.text ?? '').trim();
      String pwdConfirm =
          (_model.passwordConfirmTextController?.text ?? '').trim();

      // Set the signup data in the model
      _model.signupEmail = email;
      _model.signupPassword = pwd;
      _model.signupPasswordConfirm = pwdConfirm;

      setState(() {});

      // Call the send verification email action
      _model.sendVerificationEmailOutput = await actions.sendVerificationEmail(
        email,
        pwd,
        pwdConfirm,
      );

      // Check if the operation was successful
      _model.hasSuccess = getJsonField(
        _model.sendVerificationEmailOutput,
        r'''$.success''',
      );

      setState(() {});

      if (_model.hasSuccess == true) {
        // Clear the form fields
        setState(() {
          _model.emailAddressCreateTextController?.clear();
          _model.passwordCreateTextController?.clear();
          _model.passwordConfirmTextController?.clear();
          _passwordScore = 0;
        });

        // Navigate to SignupCheckWidget with email and password parameters
        if (mounted) {
          context.pushNamed(
            SignupCheckWidget.routeName,
            queryParameters: {
              'emailaddress': serializeParam(
                _model.signupEmail,
                ParamType.String,
              ),
              'password': serializeParam(
                _model.signupPassword,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const SignUpOtpWidget(),
        //   ),
        // );
      } else {
        // Handle error case
        _model.errorMessage = getJsonField(
          _model.sendVerificationEmailOutput,
          r'''$.error''',
        ).toString();

        setState(() {});

        if (mounted) {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: const Text('Error'),
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
      }
    } catch (e) {
      // Handle any unexpected errors
      if (mounted) {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('An unexpected error occurred: $e'),
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: FlutterFlowTheme.of(context)
          .primaryBackground, // Set this to your app's background color
      statusBarIconBrightness: Brightness.dark, // For light icons in status bar
    ));
    var l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      resizeToAvoidBottomInset: true,
      extendBody: false,
      body: SafeArea(
          child: Container(
        margin: const EdgeInsets.only(top: 60),
        padding: const EdgeInsets.all(12),
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 60,
          children: [
            Column(
              spacing: 8,
              children: [
                Text(
                  l10n.welcomeTo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 18),
                      height: 1.2,
                      color: FlutterFlowTheme.of(context).blackText,
                      fontFamily: 'KoHo',
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  l10n.appName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 28),
                      fontFamily: 'KoHo',
                      color: FlutterFlowTheme.of(context).blackText,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Column(
              spacing: 20,
              children: [
                Text(
                  l10n.createAccountPurpose,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    color: FlutterFlowTheme.of(context).blackText,
                    height: 1.667,
                  ),
                ),
                if (!_isSignUpFormVisible)
                  Container(
                    decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(12)),
                    child: _buildSignUpOption(context,
                        iconWidget: Container(
                          width: 32,
                          height: 32,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Icon(
                            Icons.mail_outline,
                            size: 14,
                            color: FlutterFlowTheme.of(context).blackText,
                          ),
                        ),
                        text: l10n.continueWithEmail, onTap: () {
                      toggleSignUpForm();
                    }),
                  ),
                if (_isSignUpFormVisible)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      spacing: 12,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 8,
                              children: [
                                Icon(
                                  Icons.person_add,
                                  size: 14,
                                  color: FlutterFlowTheme.of(context).blackText,
                                ),
                                Text(
                                  l10n.signUpWithEmail,
                                  style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      height: 1.2,
                                      fontWeight: FontWeight.w500,
                                      color: FlutterFlowTheme.of(context)
                                          .blackText),
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                toggleSignUpForm();
                              },
                              child: Icon(
                                _isSignUpFormVisible
                                    ? Icons.keyboard_arrow_up
                                    : Icons.chevron_right,
                                size: 16,
                                weight: 700,
                              ),
                            ),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              /// EMAIL
                              TextFormField(
                                controller:
                                    _model.emailAddressCreateTextController,
                                enabled: !_isLoading, // Disable when loading
                                decoration: InputDecoration(
                                  labelText: l10n.email,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xffd3d3d3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xffd3d3d3),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xffe02020),
                                    ),
                                  ),
                                  focusColor:
                                      FlutterFlowTheme.of(context).blackText,
                                  labelStyle: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).labelText,
                                  ),
                                ),
                                validator: Validators.validateEmail,
                              ),
                              const SizedBox(height: 16),

                              /// PASSWORD
                              TextFormField(
                                controller: _model.passwordCreateTextController,
                                enabled: !_isLoading, // Disable when loading
                                obscureText: !_model.passwordVisibility,
                                decoration: InputDecoration(
                                  labelText: l10n.password,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xffd3d3d3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xffd3d3d3),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xffe02020),
                                    ),
                                  ),
                                  focusColor:
                                      FlutterFlowTheme.of(context).blackText,
                                  labelStyle: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).labelText,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () => setState(() {
                                      _model.passwordVisibility =
                                          !_model.passwordVisibility;
                                    }),
                                    child: Icon(
                                      _model.passwordVisibility
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _passwordScore =
                                        Validators.scorePassword(val);
                                  });
                                },
                                validator: Validators.validatePassword,
                              ),
                              const SizedBox(height: 8),

                              /// PASSWORD STRENGTH
                              if ((_model.passwordCreateTextController?.text ??
                                      '')
                                  .isNotEmpty)
                                Row(
                                  children: [
                                    Text(
                                      Validators.describeStrength(
                                          _passwordScore),
                                      style: TextStyle(
                                        color: Validators.strengthColor(
                                            context, _passwordScore),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16),

                              /// CONFIRM PASSWORD
                              TextFormField(
                                controller:
                                    _model.passwordConfirmTextController,
                                enabled: !_isLoading, // Disable when loading
                                obscureText: !_model.confirmPasswordVisibility,
                                decoration: InputDecoration(
                                  labelText: l10n.confirmPassword,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xffd3d3d3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xffd3d3d3),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xffe02020),
                                    ),
                                  ),
                                  focusColor:
                                      FlutterFlowTheme.of(context).blackText,
                                  labelStyle: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).labelText,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () => setState(() {
                                      _model.confirmPasswordVisibility =
                                          !_model.confirmPasswordVisibility;
                                    }),
                                    child: Icon(
                                      _model.confirmPasswordVisibility
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
                                validator: (v) =>
                                    Validators.validateConfirmPassword(
                                        v,
                                        _model.passwordCreateTextController
                                                ?.text ??
                                            ''),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _isChecked,
                              activeColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: l10n.tncCheckbox1,
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: l10n.tncCheckbox2,
                                      style: TextStyle(
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 12),
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(
                                      text: l10n.tncCheckbox3,
                                      style: TextStyle(
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 12),
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: l10n.tncCheckbox4,
                                      style: TextStyle(
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 12),
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        FilledButton(
                            onPressed: _isLoading || !_isChecked
                                ? null
                                : _handleSignUp, // Updated onPressed
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18), // left/right padding
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width - 80,
                                  50), // button height = 50
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    99), // optional rounded corners
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(l10n.createAccount,
                                    style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      color: Colors.white,
                                    )))
                      ],
                    ),
                  ),
                Container(
                    decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(12)),
                    child: _buildSignUpOption(
                      context,
                      iconWidget: Container(
                        width: 32,
                        height: 32,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Image.asset(
                          "assets/images/google.png", // <-- add Google logo asset
                          width: 16,
                          height: 16,
                        ),
                      ),
                      text: AppLocalizations.of(context)!.signUpWithGoogle,
                      onTap: _isLoading
                          ? () => {}
                          : () async {
                              setState(() => _isLoading = true);
                              print("🟢 Google button pressed");
                              try {
                                // 1) Start Google sign-in
                                final res = await actions.signUpWithGoogle();
                                print(
                                    "🟢 Google function returned: ${res.success}");

                                if (!res.success) {
                                  print(
                                      "❌ Google sign-in failed: ${res.error}");
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Google sign-in failed')),
                                    );
                                  }
                                  return;
                                }
                              } catch (e, st) {
                                print("❌ Sign-in flow failed: $e\n$st");
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Error during sign-in: $e')),
                                  );
                                }
                              } finally {
                                if (mounted) setState(() => _isLoading = false);
                              }
                            },
                    )),
                if (_isSignUpFormVisible)
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: l10n.tncCheckbox1,
                      style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 12),
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: l10n.tncCheckbox2,
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: l10n.tncCheckbox3,
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: l10n.tncCheckbox4,
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(l10n.alreadyHaveAccount,
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            color: FlutterFlowTheme.of(context).primaryText,
                          )),
                      FilledButton(
                          onPressed: () {
                            // Navigate to sign in page
                            context.pushNamed(
                              LoginWidget.routeName,
                              queryParameters: {
                                'preferredTabIndex': serializeParam(
                                  0,
                                  ParamType.int,
                                ),
                              }.withoutNulls,
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                FlutterFlowTheme.of(context).primaryText,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18), // left/right padding
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.5,
                                50), // button height = 50
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  99), // optional rounded corners
                            ),
                          ),
                          child: Text(l10n.signIn,
                              style: TextStyle(
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 12),
                                color: Colors.white,
                              ))),
                      SizedBox(
                        height: 40,
                      ),
                      Image.asset(
                        'assets/images/swiss_made_logo.png',
                        width: 100,
                        height: 113,
                      )
                    ])
              ],
            ),
          ],
        )),
      )),
    );
  }

  Widget _buildSignUpOption(
    BuildContext context, {
    IconData? icon,
    Widget? iconWidget,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      minVerticalPadding: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: iconWidget ??
          Icon(
            icon,
            size: 24,
            color: Colors.black87,
          ),
      title: Text(
        text,
        style: TextStyle(
            fontSize: FlutterFlowTheme.adjustScale(size: 12),
            height: 1.2,
            fontWeight: FontWeight.w500,
            color: FlutterFlowTheme.of(context).blackText),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 16,
        color: FlutterFlowTheme.of(context).blackText,
        weight: 700,
      ),
      onTap: onTap,
    );
  }
}
