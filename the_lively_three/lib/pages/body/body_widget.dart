import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/bodypanel.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'body_model.dart';
export 'body_model.dart';

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  static String routeName = 'Body';
  static String routePath = '/body';

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  late BodyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BodyModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.physicalPanelInitialOutput = await actions.getPhysicalPanelData(
        FFAppState().calendarYear,
        FFAppState().calendarWeek,
        FFAppState().currentDayNumber,
        currentUserUid,
      );
      _model.period1PhysicalColor = functions.hexToColor(getJsonField(
        _model.physicalPanelInitialOutput,
        r'''$.period_1''',
      ).toString());
      _model.period2PhysicalColor = functions.hexToColor(getJsonField(
        _model.physicalPanelInitialOutput,
        r'''$.period_2''',
      ).toString());
      _model.period3PhysicalColor = functions.hexToColor(getJsonField(
        _model.physicalPanelInitialOutput,
        r'''$.period_3''',
      ).toString());
      _model.period4PhysicalColor = functions.hexToColor(getJsonField(
        _model.physicalPanelInitialOutput,
        r'''$.period_4''',
      ).toString());
      _model.period5PhysicalColor = functions.hexToColor(getJsonField(
        _model.physicalPanelInitialOutput,
        r'''$.period_5''',
      ).toString());
      _model.period6PhysicalColor = functions.hexToColor(getJsonField(
        _model.physicalPanelInitialOutput,
        r'''$.period_6''',
      ).toString());
      _model.period7PhysicalColor = functions.hexToColor(getJsonField(
        _model.physicalPanelInitialOutput,
        r'''$.period_7''',
      ).toString());
      _model.period8PhysicalColor = functions.hexToColor(getJsonField(
        _model.physicalPanelInitialOutput,
        r'''$.period_8''',
      ).toString());
      _model.period9PhysicalColor = functions.hexToColor(getJsonField(
        _model.physicalPanelInitialOutput,
        r'''$.period_9''',
      ).toString());
      _model.period11PhysicalColor = functions.hexToColor(getJsonField(
        _model.physicalPanelInitialOutput,
        r'''$.period_11''',
      ).toString());
      _model.period12PhysicalColor = functions.hexToColor(getJsonField(
        _model.physicalPanelInitialOutput,
        r'''$.period_12''',
      ).toString());
      _model.period10PhysicalColor = functions.hexToColor(getJsonField(
        _model.physicalPanelInitialOutput,
        r'''$.period_10''',
      ).toString());
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 0.06,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2.0,
                          color: Color(0x65CBC4C4),
                          offset: Offset(
                            0.0,
                            3.0,
                          ),
                          spreadRadius: 1.0,
                        )
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.safePop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_sharp,
                              color: FlutterFlowTheme.of(context).tertiaryText,
                              size: () {
                                if (FFAppState().screenCategory == 'small') {
                                  return 26.0;
                                } else if (FFAppState().screenCategory ==
                                    'medium') {
                                  return 28.0;
                                } else {
                                  return 30.0;
                                }
                              }(),
                            ),
                          ),
                          Text(
                            'Your Body',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  font: GoogleFonts.openSans(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).tertiaryText,
                                  fontSize: () {
                                    if (FFAppState().screenCategory ==
                                        'small') {
                                      return 18.0;
                                    } else if (FFAppState().screenCategory ==
                                        'medium') {
                                      return 21.0;
                                    } else {
                                      return 24.0;
                                    }
                                  }(),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .fontStyle,
                                ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                SettingsWidget.routeName,
                                queryParameters: {
                                  'settingsTabObjective': serializeParam(
                                    0,
                                    ParamType.int,
                                  ),
                                }.withoutNulls,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                  ),
                                },
                              );
                            },
                            child: Icon(
                              Icons.settings_outlined,
                              color: FlutterFlowTheme.of(context).tertiaryText,
                              size: () {
                                if (FFAppState().screenCategory == 'small') {
                                  return 26.0;
                                } else if (FFAppState().screenCategory ==
                                    'medium') {
                                  return 28.0;
                                } else {
                                  return 30.0;
                                }
                              }(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Body Panel',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: valueOrDefault<double>(
                                            () {
                                              if (FFAppState().screenCategory ==
                                                  'small') {
                                                return 12.0;
                                              } else if (FFAppState()
                                                      .screenCategory ==
                                                  'medium') {
                                                return 14.0;
                                              } else {
                                                return 16.0;
                                              }
                                            }(),
                                            16.0,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Text(
                                    'Week: ${FFAppState().calendarWeek.toString()}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: valueOrDefault<double>(
                                            () {
                                              if (FFAppState().screenCategory ==
                                                  'small') {
                                                return 14.0;
                                              } else if (FFAppState()
                                                      .screenCategory ==
                                                  'medium') {
                                                return 16.0;
                                              } else {
                                                return 18.0;
                                              }
                                            }(),
                                            18.0,
                                          ),
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'How do you feel?',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: valueOrDefault<double>(
                                            () {
                                              if (FFAppState().screenCategory ==
                                                  'small') {
                                                return 10.0;
                                              } else if (FFAppState()
                                                      .screenCategory ==
                                                  'medium') {
                                                return 11.0;
                                              } else {
                                                return 12.0;
                                              }
                                            }(),
                                            12.0,
                                          ),
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Text(
                                    dateTimeFormat(
                                        "MMMEd", getCurrentTimestamp),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: valueOrDefault<double>(
                                            () {
                                              if (FFAppState().screenCategory ==
                                                  'small') {
                                                return 10.0;
                                              } else if (FFAppState()
                                                      .screenCategory ==
                                                  'medium') {
                                                return 11.0;
                                              } else {
                                                return 12.0;
                                              }
                                            }(),
                                            12.0,
                                          ),
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 2.0,
                              indent: 10.0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Material(
                                color: Colors.transparent,
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.17,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.17,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '0:00 - 05:59',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize:
                                                        valueOrDefault<double>(
                                                      () {
                                                        if (FFAppState()
                                                                .screenCategory ==
                                                            'small') {
                                                          return 8.0;
                                                        } else if (FFAppState()
                                                                .screenCategory ==
                                                            'medium') {
                                                          return 9.0;
                                                        } else {
                                                          return 10.0;
                                                        }
                                                      }(),
                                                      10.0,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              if (_model.period1PhysicalColor !=
                                                      null
                                                  ? false
                                                  : true)
                                                Opacity(
                                                  opacity:
                                                      functions.isCurrentPeriod(
                                                                  0,
                                                                  0,
                                                                  1,
                                                                  59) ==
                                                              true
                                                          ? 1.0
                                                          : 0.15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/neutral_mood.png',
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.04,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              if (_model.period1PhysicalColor !=
                                                      null
                                                  ? true
                                                  : false)
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .solidCheckCircle,
                                                    color: _model
                                                        .period1PhysicalColor,
                                                    size: 27.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              if (_model.period2PhysicalColor !=
                                                      null
                                                  ? false
                                                  : true)
                                                Opacity(
                                                  opacity:
                                                      functions.isCurrentPeriod(
                                                                  2,
                                                                  0,
                                                                  3,
                                                                  59) ==
                                                              true
                                                          ? 1.0
                                                          : 0.15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/neutral_mood.png',
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.04,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              if (_model.period2PhysicalColor !=
                                                      null
                                                  ? true
                                                  : false)
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .solidCheckCircle,
                                                    color: _model
                                                        .period2PhysicalColor,
                                                    size: 27.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              if (_model.period3PhysicalColor !=
                                                      null
                                                  ? false
                                                  : true)
                                                Opacity(
                                                  opacity:
                                                      functions.isCurrentPeriod(
                                                                  4,
                                                                  0,
                                                                  5,
                                                                  59) ==
                                                              true
                                                          ? 1.0
                                                          : 0.15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/neutral_mood.png',
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.04,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              if (_model.period3PhysicalColor !=
                                                      null
                                                  ? true
                                                  : false)
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .solidCheckCircle,
                                                    color: _model
                                                        .period3PhysicalColor,
                                                    size: 27.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.17,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.17,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '06:00 - 11:59',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize:
                                                        valueOrDefault<double>(
                                                      () {
                                                        if (FFAppState()
                                                                .screenCategory ==
                                                            'small') {
                                                          return 8.0;
                                                        } else if (FFAppState()
                                                                .screenCategory ==
                                                            'medium') {
                                                          return 9.0;
                                                        } else {
                                                          return 10.0;
                                                        }
                                                      }(),
                                                      10.0,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              if (_model.period4PhysicalColor !=
                                                      null
                                                  ? false
                                                  : true)
                                                Opacity(
                                                  opacity:
                                                      functions.isCurrentPeriod(
                                                                  6,
                                                                  0,
                                                                  7,
                                                                  59) ==
                                                              true
                                                          ? 1.0
                                                          : 0.15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/neutral_mood.png',
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.04,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              if (_model.period4PhysicalColor !=
                                                      null
                                                  ? true
                                                  : false)
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .solidCheckCircle,
                                                    color: _model
                                                        .period4PhysicalColor,
                                                    size: 27.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              if (_model.period5PhysicalColor !=
                                                      null
                                                  ? false
                                                  : true)
                                                Opacity(
                                                  opacity:
                                                      functions.isCurrentPeriod(
                                                                  8,
                                                                  0,
                                                                  9,
                                                                  59) ==
                                                              true
                                                          ? 1.0
                                                          : 0.15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/neutral_mood.png',
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.04,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              if (_model.period5PhysicalColor !=
                                                      null
                                                  ? true
                                                  : false)
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .solidCheckCircle,
                                                    color: _model
                                                        .period5PhysicalColor,
                                                    size: 27.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              if (_model.period6PhysicalColor !=
                                                      null
                                                  ? false
                                                  : true)
                                                Opacity(
                                                  opacity:
                                                      functions.isCurrentPeriod(
                                                                  10,
                                                                  0,
                                                                  11,
                                                                  59) ==
                                                              true
                                                          ? 1.0
                                                          : 0.15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/neutral_mood.png',
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.04,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              if (_model.period6PhysicalColor !=
                                                      null
                                                  ? true
                                                  : false)
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .solidCheckCircle,
                                                    color: _model
                                                        .period6PhysicalColor,
                                                    size: 27.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.17,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.17,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '12:00 - 17:59',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize:
                                                        valueOrDefault<double>(
                                                      () {
                                                        if (FFAppState()
                                                                .screenCategory ==
                                                            'small') {
                                                          return 8.0;
                                                        } else if (FFAppState()
                                                                .screenCategory ==
                                                            'medium') {
                                                          return 9.0;
                                                        } else {
                                                          return 10.0;
                                                        }
                                                      }(),
                                                      10.0,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              if (_model.period7PhysicalColor !=
                                                      null
                                                  ? false
                                                  : true)
                                                Opacity(
                                                  opacity:
                                                      functions.isCurrentPeriod(
                                                                  12,
                                                                  0,
                                                                  13,
                                                                  59) ==
                                                              true
                                                          ? 1.0
                                                          : 0.15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/neutral_mood.png',
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.04,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              if (_model.period7PhysicalColor !=
                                                      null
                                                  ? true
                                                  : false)
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .solidCheckCircle,
                                                    color: _model
                                                        .period7PhysicalColor,
                                                    size: 27.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              if (_model.period8PhysicalColor !=
                                                      null
                                                  ? false
                                                  : true)
                                                Opacity(
                                                  opacity:
                                                      functions.isCurrentPeriod(
                                                                  14,
                                                                  0,
                                                                  15,
                                                                  59) ==
                                                              true
                                                          ? 1.0
                                                          : 0.15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/neutral_mood.png',
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.04,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              if (_model.period8PhysicalColor !=
                                                      null
                                                  ? true
                                                  : false)
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .solidCheckCircle,
                                                    color: _model
                                                        .period8PhysicalColor,
                                                    size: 27.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              if (_model.period9PhysicalColor ==
                                                  null) {
                                                return Visibility(
                                                  visible:
                                                      _model.period9PhysicalColor !=
                                                              null
                                                          ? false
                                                          : true,
                                                  child: Opacity(
                                                    opacity: functions
                                                                .isCurrentPeriod(
                                                                    16,
                                                                    0,
                                                                    17,
                                                                    59) ==
                                                            true
                                                        ? 1.0
                                                        : 0.2,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.asset(
                                                        'assets/images/neutral_mood.png',
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.04,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Visibility(
                                                  visible:
                                                      _model.period9PhysicalColor !=
                                                              null
                                                          ? true
                                                          : false,
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .solidCheckCircle,
                                                      color: _model
                                                          .period9PhysicalColor,
                                                      size: 27.0,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.17,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.17,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '18:00 - 23:59',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize:
                                                        valueOrDefault<double>(
                                                      () {
                                                        if (FFAppState()
                                                                .screenCategory ==
                                                            'small') {
                                                          return 8.0;
                                                        } else if (FFAppState()
                                                                .screenCategory ==
                                                            'medium') {
                                                          return 9.0;
                                                        } else {
                                                          return 10.0;
                                                        }
                                                      }(),
                                                      10.0,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              if (_model.period10PhysicalColor !=
                                                      null
                                                  ? false
                                                  : true)
                                                Opacity(
                                                  opacity:
                                                      functions.isCurrentPeriod(
                                                                  18,
                                                                  0,
                                                                  19,
                                                                  59) ==
                                                              true
                                                          ? 1.0
                                                          : 0.15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/neutral_mood.png',
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.04,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              if (_model.period10PhysicalColor !=
                                                      null
                                                  ? true
                                                  : false)
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .solidCheckCircle,
                                                    color: _model
                                                        .period10PhysicalColor,
                                                    size: 27.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              if (_model.period11PhysicalColor !=
                                                      null
                                                  ? false
                                                  : true)
                                                Opacity(
                                                  opacity:
                                                      functions.isCurrentPeriod(
                                                                  20,
                                                                  0,
                                                                  21,
                                                                  59) ==
                                                              true
                                                          ? 1.0
                                                          : 0.15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/neutral_mood.png',
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.04,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              if (_model.period11PhysicalColor !=
                                                      null
                                                  ? true
                                                  : false)
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .solidCheckCircle,
                                                    color: _model
                                                        .period11PhysicalColor,
                                                    size: 27.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              if (_model.period12PhysicalColor !=
                                                      null
                                                  ? false
                                                  : true)
                                                Opacity(
                                                  opacity:
                                                      functions.isCurrentPeriod(
                                                                  22,
                                                                  0,
                                                                  23,
                                                                  59) ==
                                                              true
                                                          ? 1.0
                                                          : 0.15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/neutral_mood.png',
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.04,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              if (_model.period12PhysicalColor !=
                                                      null
                                                  ? true
                                                  : false)
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .solidCheckCircle,
                                                    color: _model
                                                        .period12PhysicalColor,
                                                    size: 27.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 6.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 2.0),
                                      child: Text(
                                        '+',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Color(0xFF989898),
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                      child: Divider(
                                        thickness: 1.0,
                                        color: Color(0xFF989898),
                                      ),
                                    ),
                                    Text(
                                      '-',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xFF989898),
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 20.0, 0.0, 3.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '-',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: Color(0xFF989898),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                          child: VerticalDivider(
                                            thickness: 1.0,
                                            color: Color(0xFF989898),
                                          ),
                                        ),
                                        Text(
                                          '+',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: Color(0xFF989898),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.66,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.33,
                                        child: custom_widgets
                                            .RectangularMoodWidget(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.66,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.33,
                                          clampToRect: true,
                                          innerRectColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          transitionStartRatio: 0.3,
                                          transitionEasePower: 4.0,
                                          topLeftColor: Color(0xFFFDB4B4),
                                          topRightColor: Color(0xFFCBFBC0),
                                          bottomLeftColor: Color(0xFFBBF1FB),
                                          bottomRightColor: Color(0xFFFBF49C),
                                          pointerRimColorTopLeft:
                                              Color(0xFFFF0000),
                                          pointerRimColorTopRight:
                                              Color(0xFF37FF01),
                                          pointerRimColorBottomLeft:
                                              Color(0xFF00E4FF),
                                          pointerRimColorBottomRight:
                                              Color(0xFFFFF801),
                                          showAxes: true,
                                          axesColor: Color(0xFF989898),
                                          pointerCenterColor:
                                              FlutterFlowTheme.of(context)
                                                  .alternate,
                                          pointerSize: 8.0,
                                          auraIntensity: 1.0,
                                          auraScale: 5.0,
                                          auraExpandDuration: 300,
                                          auraShrinkDuration: 800,
                                          showShadow: true,
                                          shadowColor: Color(0xFFB4B4B4),
                                          shadowOffsetX: 0.0,
                                          shadowOffsetY: 0.0,
                                          shadowBlur: 6.0,
                                          showCoordinates: false,
                                          minValue: -100.0,
                                          maxValue: 100.0,
                                          throttleDuration: 50,
                                          callOnMove: true,
                                          iconScaleFactor: 0.22,
                                          topLeftEmojiPath:
                                              'assets/images/red_phy.png',
                                          topRightEmojiPath:
                                              'assets/images/green_phy.png',
                                          bottomLeftEmojiPath:
                                              'assets/images/blue_phy.png',
                                          bottomRightEmojiPath:
                                              'assets/images/yellow_phy.png',
                                          xAxisLabel: 'Physical Intensity',
                                          yAxisLabel: 'Energy Level',
                                          onMoodChange: (xCoordinate,
                                              yCoodinate, dateTime) async {
                                            FFAppState()
                                                .updateBodyCoordinatesStruct(
                                              (e) => e
                                                ..coordinateX = xCoordinate
                                                ..coordinateY = yCoodinate
                                                ..dateTime = dateTime,
                                            );
                                            safeSetState(() {});
                                          },
                                        ),
                                      ).addWalkthrough(
                                        container30w0sz9t,
                                        _model.bodypanelController,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 3.0, 0.0, 10.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '-',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: Color(0xFF989898),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                          child: VerticalDivider(
                                            thickness: 1.0,
                                            color: Color(0xFFACAEB0),
                                          ),
                                        ),
                                        Text(
                                          '+',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: Color(0xFF989898),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    6.0, 0.0, 0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 2.0),
                                      child: Text(
                                        '+',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Color(0xFF989898),
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                      child: Divider(
                                        thickness: 1.0,
                                        color: Color(0xFF989898),
                                      ),
                                    ),
                                    Text(
                                      '-',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xFF989898),
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FFButtonWidget(
                                onPressed: () async {
                                  _model.physicalPanelUpdatedOutput = await actions
                                      .insertUpdatePhysicalPanelCoordinatesAndColors(
                                    FFAppState().bodyCoordinates.coordinateX,
                                    FFAppState().bodyCoordinates.coordinateY,
                                    currentUserUid,
                                  );
                                  _model.period1PhysicalColor =
                                      functions.hexToColor(getJsonField(
                                    _model.physicalPanelUpdatedOutput,
                                    r'''$.period_1''',
                                  ).toString());
                                  _model.period2PhysicalColor =
                                      functions.hexToColor(getJsonField(
                                    _model.physicalPanelUpdatedOutput,
                                    r'''$.period_2''',
                                  ).toString());
                                  _model.period3PhysicalColor =
                                      functions.hexToColor(getJsonField(
                                    _model.physicalPanelUpdatedOutput,
                                    r'''$.period_3''',
                                  ).toString());
                                  _model.period4PhysicalColor =
                                      functions.hexToColor(getJsonField(
                                    _model.physicalPanelUpdatedOutput,
                                    r'''$.period_4''',
                                  ).toString());
                                  _model.period5PhysicalColor =
                                      functions.hexToColor(getJsonField(
                                    _model.physicalPanelUpdatedOutput,
                                    r'''$.period_5''',
                                  ).toString());
                                  _model.period6PhysicalColor =
                                      functions.hexToColor(getJsonField(
                                    _model.physicalPanelUpdatedOutput,
                                    r'''$.period_6''',
                                  ).toString());
                                  _model.period7PhysicalColor =
                                      functions.hexToColor(getJsonField(
                                    _model.physicalPanelUpdatedOutput,
                                    r'''$.period_7''',
                                  ).toString());
                                  _model.period8PhysicalColor =
                                      functions.hexToColor(getJsonField(
                                    _model.physicalPanelUpdatedOutput,
                                    r'''$.period_8''',
                                  ).toString());
                                  _model.period9PhysicalColor =
                                      functions.hexToColor(getJsonField(
                                    _model.physicalPanelUpdatedOutput,
                                    r'''$.period_9''',
                                  ).toString());
                                  _model.period10PhysicalColor =
                                      functions.hexToColor(getJsonField(
                                    _model.physicalPanelUpdatedOutput,
                                    r'''$.period_10''',
                                  ).toString());
                                  _model.period11PhysicalColor =
                                      functions.hexToColor(getJsonField(
                                    _model.physicalPanelUpdatedOutput,
                                    r'''$.period_11''',
                                  ).toString());
                                  _model.period12PhysicalColor =
                                      functions.hexToColor(getJsonField(
                                    _model.physicalPanelUpdatedOutput,
                                    r'''$.period_12''',
                                  ).toString());
                                  safeSetState(() {});

                                  safeSetState(() {});
                                },
                                text: 'Submit',
                                options: FFButtonOptions(
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleSmallIsCustom,
                                      ),
                                  elevation: 4.0,
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 2.0,
                            indent: 20.0,
                            endIndent: 20.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Panel accepts a choice every 2 hours. ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: valueOrDefault<double>(
                                            () {
                                              if (FFAppState().screenCategory ==
                                                  'small') {
                                                return 10.0;
                                              } else if (FFAppState()
                                                      .screenCategory ==
                                                  'medium') {
                                                return 11.0;
                                              } else {
                                                return 12.0;
                                              }
                                            }(),
                                            12.0,
                                          ),
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Text(
                                    'Whenever you feel like it.',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: valueOrDefault<double>(
                                            () {
                                              if (FFAppState().screenCategory ==
                                                  'small') {
                                                return 10.0;
                                              } else if (FFAppState()
                                                      .screenCategory ==
                                                  'medium') {
                                                return 11.0;
                                              } else {
                                                return 12.0;
                                              }
                                            }(),
                                            12.0,
                                          ),
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
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
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 0.06,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2.0,
                          color: Color(0x65CBC4C4),
                          offset: Offset(
                            0.0,
                            -3.0,
                          ),
                          spreadRadius: 1.0,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              HomepageWidget.routeName,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType: PageTransitionType.fade,
                                ),
                              },
                            );
                          },
                          child: Icon(
                            Icons.home_rounded,
                            color: FlutterFlowTheme.of(context).tertiaryText,
                            size: () {
                              if (FFAppState().screenCategory == 'small') {
                                return 26.0;
                              } else if (FFAppState().screenCategory ==
                                  'medium') {
                                return 28.0;
                              } else {
                                return 30.0;
                              }
                            }(),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              PlantselectionWidget.routeName,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType: PageTransitionType.fade,
                                ),
                              },
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/Plant.png',
                              width: () {
                                if (FFAppState().screenCategory == 'small') {
                                  return 26.0;
                                } else if (FFAppState().screenCategory ==
                                    'medium') {
                                  return 28.0;
                                } else {
                                  return 30.0;
                                }
                              }(),
                              height: () {
                                if (FFAppState().screenCategory == 'small') {
                                  return 26.0;
                                } else if (FFAppState().screenCategory ==
                                    'medium') {
                                  return 28.0;
                                } else {
                                  return 30.0;
                                }
                              }(),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              AddonsWidget.routeName,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType: PageTransitionType.fade,
                                ),
                              },
                            );
                          },
                          child: Icon(
                            Icons.playlist_add_rounded,
                            color: FlutterFlowTheme.of(context).tertiaryText,
                            size: valueOrDefault<double>(
                              () {
                                if (FFAppState().screenCategory == 'small') {
                                  return 30.0;
                                } else if (FFAppState().screenCategory ==
                                    'medium') {
                                  return 32.0;
                                } else {
                                  return 34.0;
                                }
                              }(),
                              34.0,
                            ),
                          ),
                        ),
                        FaIcon(
                          FontAwesomeIcons.streetView,
                          color: FlutterFlowTheme.of(context).secondary2,
                          size: () {
                            if (FFAppState().screenCategory == 'small') {
                              return 26.0;
                            } else if (FFAppState().screenCategory ==
                                'medium') {
                              return 28.0;
                            } else {
                              return 30.0;
                            }
                          }(),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              MoodWidget.routeName,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType: PageTransitionType.fade,
                                ),
                              },
                            );
                          },
                          child: Icon(
                            Icons.mood_outlined,
                            color: FlutterFlowTheme.of(context).tertiaryText,
                            size: () {
                              if (FFAppState().screenCategory == 'small') {
                                return 26.0;
                              } else if (FFAppState().screenCategory ==
                                  'medium') {
                                return 28.0;
                              } else {
                                return 30.0;
                              }
                            }(),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              DashboardWidget.routeName,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType: PageTransitionType.fade,
                                ),
                              },
                            );
                          },
                          child: Icon(
                            Icons.bar_chart,
                            color: FlutterFlowTheme.of(context).tertiaryText,
                            size: () {
                              if (FFAppState().screenCategory == 'small') {
                                return 26.0;
                              } else if (FFAppState().screenCategory ==
                                  'medium') {
                                return 28.0;
                              } else {
                                return 30.0;
                              }
                            }(),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(MeterWidget.routeName);
                          },
                          child: FaIcon(
                            FontAwesomeIcons.thermometerHalf,
                            color: FlutterFlowTheme.of(context).tertiaryText,
                            size: () {
                              if (FFAppState().screenCategory == 'small') {
                                return 26.0;
                              } else if (FFAppState().screenCategory ==
                                  'medium') {
                                return 28.0;
                              } else {
                                return 30.0;
                              }
                            }(),
                          ),
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
    );
  }

  TutorialCoachMark createPageWalkthrough(BuildContext context) =>
      TutorialCoachMark(
        targets: createWalkthroughTargets(context),
        onFinish: () async {
          safeSetState(() => _model.bodypanelController = null);
        },
        onSkip: () {
          return true;
        },
      );
}
