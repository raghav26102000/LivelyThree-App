import 'package:flutter/services.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'login_model.dart';
export 'login_model.dart';
import '/l10n/app_localizations.dart';
import 'package:the_lively_three/utils/loader_util.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({
    super.key,
    int? preferredTabIndex,
  }) : this.preferredTabIndex = preferredTabIndex ?? 0;

  final int preferredTabIndex;

  static String routeName = 'Login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

bool _isLoading = false;

class OAuthResult {
  final bool success;
  final Object? error;
  OAuthResult({required this.success, this.error});
}

class _LoginWidgetState extends State<LoginWidget>
    with TickerProviderStateMixin {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // NEW: form keys
  final _signinFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  // NEW: strength state
  String _signinStrength = '';
  String _signupStrength = '';

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      GoRouter.of(context).prepareAuthEvent();
      await authManager.signOut();
      GoRouter.of(context).clearRedirectLocation();
      setState(() => _isLoading = false);
      await actions.detectScreenCategory(
        context,
      );
      safeSetState(() {
        _model.passwordTextController?.clear();
        _model.emailAddressTextController?.clear();
      });

      context.goNamedAuth(LoginWidget.routeName, context.mounted);
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: min(
          valueOrDefault<int>(
            widget.preferredTabIndex,
            0,
          ),
          1),
    )..addListener(() => safeSetState(() {}));

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    _model.emailAddressCreateTextController ??= TextEditingController();
    _model.emailAddressCreateFocusNode ??= FocusNode();

    _model.passwordCreateTextController ??= TextEditingController();
    _model.passwordCreateFocusNode ??= FocusNode();

    _model.passwordConfirmTextController ??= TextEditingController();
    _model.passwordConfirmFocusNode ??= FocusNode();

    // NEW: live strength listeners
    _model.passwordTextController?.addListener(() {
      final pwd = _model.passwordTextController?.text ?? '';
      setState(() => _signinStrength = _describeStrength(_scorePassword(pwd)));
    });
    _model.passwordCreateTextController?.addListener(() {
      final pwd = _model.passwordCreateTextController?.text ?? '';
      setState(() => _signupStrength = _describeStrength(_scorePassword(pwd)));
    });

    animationsMap.addAll({
      'columnOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 60.0),
            end: const Offset(0.0, 0.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(-0.349, 0),
            end: const Offset(0, 0),
          ),
        ],
      ),
      'columnOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 60.0),
            end: const Offset(0.0, 0.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(-0.349, 0),
            end: const Offset(0, 0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  int _scorePassword(String pwd) {
    if (pwd.isEmpty) return 0;
    int score = 0;

    final hasLower = RegExp(r'[a-z]').hasMatch(pwd);
    final hasUpper = RegExp(r'[A-Z]').hasMatch(pwd);
    final hasDigit = RegExp(r'\d').hasMatch(pwd);
    // NOTE: normal (non-raw) string so we can include both ' and "
    final hasSpecial =
        RegExp('[!@#\$%^&*()\\-_=+{}\\[\\]\\\\|;:\'",<.>/?`~]').hasMatch(pwd);
    final len = pwd.length;

    if (len >= 8) score++;
    if (len >= 10) score++;

    final varieties =
        <bool>[hasLower, hasUpper, hasDigit, hasSpecial].where((b) => b).length;
    if (varieties >= 2) score++;
    if (varieties >= 3) score++;

    if (len < 8 || varieties < 2) return 0; // Weak
    if (score >= 4) return 2; // Strong
    return 1; // Medium
  }

  String _describeStrength(int score) {
    switch (score) {
      case 2:
        return 'Strong';
      case 1:
        return 'Medium';
      default:
        return 'Weak';
    }
  }

  Color _strengthColor(BuildContext context, String label) {
    switch (label) {
      case 'Strong':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      default:
        return FlutterFlowTheme.of(context).error;
    }
  }

  String? _validatePasswordBasic(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Minimum 8 characters required';

    final categories = <bool>[
      RegExp(r'[a-z]').hasMatch(v),
      RegExp(r'[A-Z]').hasMatch(v),
      RegExp(r'\d').hasMatch(v),
      RegExp('[!@#\$%^&*()\\-_=+{}\\[\\]\\\\|;:\'",<.>/?`~]').hasMatch(v),
    ].where((b) => b).length;

    if (categories < 2) {
      return 'Use at least TWO of: lowercase, UPPERCASE, number, special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final v = (value ?? '').trim();
    final p = (_model.passwordCreateTextController?.text ?? '').trim();
    if (v.isEmpty) return 'Please confirm your password';
    if (v != p) return 'Passwords do not match';
    return null;
  }

  bool _isWeak(String pwd) => _scorePassword(pwd) == 0;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: FlutterFlowTheme.of(context)
          .secondaryBackground, // Set this to your app's background color
      statusBarIconBrightness: Brightness.dark, // For light icons in status bar
    ));
    var l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        extendBody: false,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: SizedBox(
              // ✅ Give the stack bounded height
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 20,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 40),
                              child: Column(
                                spacing: 8,
                                children: [
                                  Text(
                                    l10n.welcomeTo,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 18),
                                        color: FlutterFlowTheme.of(context)
                                            .blackText,
                                        fontFamily: 'KoHo',
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    l10n.appName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 28),
                                        color: FlutterFlowTheme.of(context)
                                            .blackText,
                                        fontFamily: 'KoHo',
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              )),
                          Text(
                            'Good to see you again! Continue your journey of health, sustainability, and digital trust.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 12),
                              height: 1.67, // makes line height ~20px
                              letterSpacing: 0.6, // spacing between letters
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(-1, -1),
                                      blurRadius: 4.0,
                                      color: Color(0x55999999))
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 16, 16, 16),
                              child: Form(
                                key: _signinFormKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 16.0),
                                      child: Row(
                                        spacing: 10.0,
                                        children: [
                                          Icon(
                                            Icons.account_circle_outlined,
                                            size: 14,
                                            color: FlutterFlowTheme.of(context)
                                                .blackText,
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .signIn,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.2,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .blackText,
                                                        fontSize:
                                                            FlutterFlowTheme
                                                                .adjustScale(
                                                                    size: 12))),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 10.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller:
                                              _model.emailAddressTextController,
                                          focusNode:
                                              _model.emailAddressFocusNode,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            '_model.emailAddressTextController',
                                            const Duration(milliseconds: 2000),
                                            () => safeSetState(() {}),
                                          ),
                                          autofocus: false,
                                          autofillHints: const [
                                            AutofillHints.email
                                          ],
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            labelText:
                                                AppLocalizations.of(context)!
                                                    .email,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    horizontal: 14),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Color(0xffd3d3d3),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Color(0xffd3d3d3),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Color(0xffe02020),
                                              ),
                                            ),
                                            focusColor:
                                                FlutterFlowTheme.of(context)
                                                    .blackText,
                                            labelStyle: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 12),
                                              height: 1.2,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .labelText,
                                            ),
                                            suffixIcon: _model
                                                    .emailAddressTextController!
                                                    .text
                                                    .isNotEmpty
                                                ? InkWell(
                                                    onTap: () async {
                                                      _model
                                                          .emailAddressTextController
                                                          ?.clear();
                                                      safeSetState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      color: const Color(
                                                          0xFF757575),
                                                      size: valueOrDefault<
                                                          double>(
                                                        () {
                                                          if (FFAppState()
                                                                  .screenCategory ==
                                                              'small') {
                                                            return 18.0;
                                                          } else if (FFAppState()
                                                                  .screenCategory ==
                                                              'medium') {
                                                            return 21.0;
                                                          } else {
                                                            return 24.0;
                                                          }
                                                        }(),
                                                        24.0,
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 16),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .emailAddressTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 6.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller:
                                              _model.passwordTextController,
                                          focusNode: _model.passwordFocusNode,
                                          autofocus: false,
                                          autofillHints: const [
                                            AutofillHints.password
                                          ],
                                          textInputAction: TextInputAction.done,
                                          obscureText:
                                              !_model.passwordVisibility,
                                          decoration: InputDecoration(
                                            labelText:
                                                AppLocalizations.of(context)!
                                                    .password,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    horizontal: 14),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Color(0xffd3d3d3),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Color(0xffd3d3d3),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Color(0xffe02020),
                                              ),
                                            ),
                                            focusColor:
                                                FlutterFlowTheme.of(context)
                                                    .blackText,
                                            labelStyle: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 12),
                                              height: 1.2,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .labelText,
                                            ),
                                            suffixIcon: InkWell(
                                              onTap: () => safeSetState(
                                                () => _model
                                                        .passwordVisibility =
                                                    !_model.passwordVisibility,
                                              ),
                                              focusNode: FocusNode(
                                                  skipTraversal: true),
                                              child: Icon(
                                                _model.passwordVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: valueOrDefault<double>(
                                                  () {
                                                    if (FFAppState()
                                                            .screenCategory ==
                                                        'small') {
                                                      return 18.0;
                                                    } else if (FFAppState()
                                                            .screenCategory ==
                                                        'medium') {
                                                      return 21.0;
                                                    } else {
                                                      return 24.0;
                                                    }
                                                  }(),
                                                  24.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 16),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          // NEW: validator override for sign-in
                                          validator: (v) =>
                                              _validatePasswordBasic(v),
                                        ),
                                      ),
                                    ),
                                    // NEW: strength label (Sign In)
                                    if ((_model.passwordTextController?.text ??
                                            '')
                                        .isNotEmpty)
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0, vertical: 4.0),
                                        ),
                                      ),

                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              21.0, 10.0, 21.0, 10.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          // NEW: validate form/local password rules before continuing
                                          final pwd = _model
                                                  .passwordTextController
                                                  ?.text ??
                                              '';
                                          if (!(_signinFormKey.currentState
                                                  ?.validate() ??
                                              false)) {
                                            return;
                                          }
                                          if (_isWeak(pwd)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  AppLocalizations.of(context)!
                                                      .weakPassword,
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          _model.signinOutput =
                                              await actions.customSignIn(
                                            (_model.emailAddressTextController
                                                    .text)
                                                .trim(),
                                            (_model.passwordTextController.text)
                                                .trim(),
                                          );
                                          _model.hasSuccess = getJsonField(
                                            _model.signinOutput,
                                            r'''$.success''',
                                          );
                                          _model.errorMessage = getJsonField(
                                            _model.signinOutput,
                                            r'''$.error''',
                                          ).toString();
                                          safeSetState(() {});
                                          if (_model.hasSuccess == true) {
                                            _model.checkOnboardingStatusOutput =
                                                await UsersTable().queryRows(
                                              queryFn: (q) => q.eqOrNull(
                                                'id',
                                                currentUserUid,
                                              ),
                                            );
                                            if (_model
                                                    .checkOnboardingStatusOutput
                                                    ?.elementAtOrNull(0)
                                                    ?.isOnboarded ==
                                                true) {
                                              context.pushNamed(
                                                HomepageWidget.routeName,
                                                extra: <String, dynamic>{
                                                  kTransitionInfoKey:
                                                      TransitionInfo(
                                                    hasTransition: true,
                                                    transitionType:
                                                        PageTransitionType.fade,
                                                  ),
                                                },
                                              );
                                            } else {
                                              if (!mounted) return;
                                              context.pushNamed(
                                                OnboardingWidget.routeName,
                                                extra: <String, dynamic>{
                                                  kTransitionInfoKey:
                                                      TransitionInfo(
                                                    hasTransition: true,
                                                    transitionType:
                                                        PageTransitionType.fade,
                                                  ),
                                                },
                                              );
                                            }
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: const Text('Error'),
                                                  content: Text(
                                                    valueOrDefault<String>(
                                                      _model.errorMessage,
                                                      'n/a',
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: const Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }

                                          safeSetState(() {});
                                        },
                                        text: AppLocalizations.of(context)!
                                            .signIn,
                                        options: FFButtonOptions(
                                          width:
                                              MediaQuery.sizeOf(context).width -
                                                  90,
                                          height: 50,
                                          padding: const EdgeInsets.all(18),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmallFamily,
                                                color: Colors.white,
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 14),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmallIsCustom,
                                              ),
                                          elevation: 3.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: _buildSignUpOption(
                                          context,
                                          iconWidget: Container(
                                            width: 32,
                                            height: 32,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            child: Image.asset(
                                              "assets/images/google.png",
                                              width: 16,
                                              height: 16,
                                            ),
                                          ),
                                          text: AppLocalizations.of(context)!
                                              .signInWithGoogle,
                                          onTap: _isLoading
                                              ? () => {}
                                              : () async {
                                                  setState(
                                                      () => _isLoading = true);
                                                  try {
                                                    LoaderUtils.showLoader(
                                                        context);
                                                    final res = await actions
                                                        .signInWithGoogle();
                                                    print(
                                                        "🟢 Google function returned: ${res.success}");

                                                    if (!res.success) {
                                                      print(
                                                          "❌ Google sign-in failed: ${res.error}");
                                                      if (mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(res
                                                                    .message ??
                                                                'Google sign-in failed'),
                                                            action: !res
                                                                    .userExists
                                                                ? SnackBarAction(
                                                                    label:
                                                                        'Sign Up',
                                                                    onPressed:
                                                                        () {
                                                                      // Navigate to sign up page
                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          '/signup');
                                                                    },
                                                                  )
                                                                : null,
                                                          ),
                                                        );
                                                      }
                                                      setState(() =>
                                                          _isLoading = false);
                                                      LoaderUtils.hideLoader(
                                                          context);
                                                      return;
                                                    }

                                                    LoaderUtils.hideLoader(
                                                        context);

                                                    // Success - navigate to home or dashboard
                                                    if (mounted) {
                                                      context.pushNamed(
                                                        HomepageWidget
                                                            .routeName,
                                                      );
                                                    }
                                                  } catch (e, st) {
                                                    print(
                                                        "❌ Sign-in flow failed: $e\n$st");
                                                    if (mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Error during sign-in: $e')),
                                                      );
                                                    }
                                                  } finally {
                                                    if (mounted)
                                                      setState(() =>
                                                          _isLoading = false);
                                                  }
                                                },
                                        )),
                                    FFButtonWidget(
                                      onPressed: () async {
                                        safeSetState(() {
                                          _model.passwordTextController
                                              ?.clear();
                                        });

                                        context.pushNamed(
                                          PasswordForgottenWidget.routeName,
                                          extra: <String, dynamic>{
                                            kTransitionInfoKey: TransitionInfo(
                                              hasTransition: true,
                                              transitionType:
                                                  PageTransitionType.fade,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                            ),
                                          },
                                        );
                                      },
                                      text: AppLocalizations.of(context)!
                                          .forgotPassword,
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        iconPadding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        color: Colors.white,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .labelText,
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 12.0),
                                              decoration:
                                                  TextDecoration.underline,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        elevation: 0.0,
                                        borderSide: const BorderSide(
                                            width: 0.0,
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ],
                                ).animateOnPageLoad(animationsMap[
                                    'columnOnPageLoadAnimation1']!),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Text('Create an Account:',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  )),
                              FilledButton(
                                onPressed: () {
                                  // Navigate to sign up page
                                  context.pushNamed(
                                    SignUpWidget.routeName,
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
                                child: Text(
                                  l10n.signUp,
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
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
      leading: iconWidget ??
          Icon(
            icon,
            size: 24,
            color: Colors.black87,
          ),
      title: Text(
        text,
        style: TextStyle(fontSize: FlutterFlowTheme.adjustScale(size: 16)),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
