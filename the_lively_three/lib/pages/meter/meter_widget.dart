import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/call_to_action.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'meter_model.dart';
export 'meter_model.dart';

class MeterWidget extends StatefulWidget {
  const MeterWidget({super.key});

  static String routeName = 'Meter';
  static String routePath = '/meter';

  @override
  State<MeterWidget> createState() => _MeterWidgetState();
}

class _MeterWidgetState extends State<MeterWidget> {
  late MeterModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeterModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.userInteractionOutput = await actions.countUserInteractions(
        currentUserUid,
      );
      _model.userCount = valueOrDefault<double>(
        (_model.userInteractionOutput?.elementAtOrNull(0))?.toDouble(),
        0.0,
      );
      _model.communityCount = valueOrDefault<double>(
        (_model.userInteractionOutput?.elementAtOrNull(1))?.toDouble(),
        0.0,
      );
      safeSetState(() {});
      _model.userRatio = valueOrDefault<double>(
        valueOrDefault<double>(
              _model.userCount,
              0.0,
            ) /
            300,
        0.0,
      );
      _model.communityRatio = valueOrDefault<double>(
        (valueOrDefault<double>(
              _model.communityCount,
              0.0,
            ) /
            30000),
        0.0,
      );
      safeSetState(() {});
      await Future.wait([
        Future(() async {
          if (_model.userRatio! >= 1.0) {
            _model.userRatio = 1.0;
            safeSetState(() {});
          }
        }),
        Future(() async {
          if (_model.communityRatio! >= 1.0) {
            _model.communityRatio = 1.0;
            safeSetState(() {});
          }
        }),
      ]);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
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
                            'Road to Personalization',
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
                                  fontSize: valueOrDefault<double>(
                                    () {
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
                                    18.0,
                                  ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 5.0, 10.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Data Contribution',
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
                                    valueOrDefault<String>(
                                      'Week: ${valueOrDefault<String>(
                                        FFAppState().calendarWeek.toString(),
                                        '0',
                                      )}',
                                      '0',
                                    ),
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
                                  10.0, 0.0, 10.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'When food and wellbeing can be connected',
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
                              color: FlutterFlowTheme.of(context).accent4,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 470),
                        curve: Curves.easeIn,
                        width: MediaQuery.sizeOf(context).width * 0.95,
                        height: MediaQuery.sizeOf(context).height * 0.7,
                        decoration: BoxDecoration(),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.8,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.2,
                                            decoration: BoxDecoration(),
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Help us to personalize! ',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            fontSize:
                                                                valueOrDefault<
                                                                    double>(
                                                              () {
                                                                if (FFAppState()
                                                                        .screenCategory ==
                                                                    'small') {
                                                                  return 16.0;
                                                                } else if (FFAppState()
                                                                        .screenCategory ==
                                                                    'medium') {
                                                                  return 18.0;
                                                                } else {
                                                                  return 20.0;
                                                                }
                                                              }(),
                                                              20.0,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                                Text(
                                                  'With sufficient input from you and the community, the power of analytics can begin',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        fontSize:
                                                            valueOrDefault<
                                                                double>(
                                                          () {
                                                            if (FFAppState()
                                                                    .screenCategory ==
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
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                ),
                                                Text(
                                                  'First goal with your help: what combination of plants improves your physical and mental wellbeing. ',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        fontSize:
                                                            valueOrDefault<
                                                                double>(
                                                          () {
                                                            if (FFAppState()
                                                                    .screenCategory ==
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ).addWalkthrough(
                                      column70avwpte,
                                      _model.callToActionController,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      0.0,
                                                                      0.0,
                                                                      5.0),
                                                          child: Text(
                                                            'Your input:',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .roboto(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      5.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            'The target:',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .roboto(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      5.0),
                                                          child: Text(
                                                            valueOrDefault<
                                                                String>(
                                                              formatNumber(
                                                                _model
                                                                    .userCount,
                                                                formatType:
                                                                    FormatType
                                                                        .custom,
                                                                format: '###',
                                                                locale: '',
                                                              ),
                                                              '0',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .roboto(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      5.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            '300 entries',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .roboto(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  LinearPercentIndicator(
                                                    percent:
                                                        valueOrDefault<double>(
                                                      _model.userRatio,
                                                      0.5,
                                                    ),
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.8,
                                                    lineHeight: 50.0,
                                                    animation: true,
                                                    animateFromLastPercent:
                                                        true,
                                                    progressColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .alternate,
                                                    center: Text(
                                                      valueOrDefault<String>(
                                                        formatNumber(
                                                          _model.userRatio,
                                                          formatType: FormatType
                                                              .percent,
                                                        ),
                                                        '0',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineSmall
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmallFamily,
                                                            fontSize:
                                                                valueOrDefault<
                                                                    double>(
                                                              () {
                                                                if (FFAppState()
                                                                        .screenCategory ==
                                                                    'small') {
                                                                  return 20.0;
                                                                } else if (FFAppState()
                                                                        .screenCategory ==
                                                                    'medium') {
                                                                  return 22.0;
                                                                } else {
                                                                  return 24.0;
                                                                }
                                                              }(),
                                                              24.0,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmallIsCustom,
                                                          ),
                                                    ),
                                                    barRadius:
                                                        Radius.circular(10.0),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      0.0,
                                                                      0.0,
                                                                      5.0),
                                                          child: Text(
                                                            'Community input:',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .roboto(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      5.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            'The target:',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .roboto(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      5.0),
                                                          child: Text(
                                                            valueOrDefault<
                                                                String>(
                                                              _model
                                                                  .communityCount
                                                                  ?.toString(),
                                                              '0',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .roboto(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      5.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            '30\'000 entries',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .roboto(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  LinearPercentIndicator(
                                                    percent:
                                                        valueOrDefault<double>(
                                                      _model.communityRatio,
                                                      0.5,
                                                    ),
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.8,
                                                    lineHeight: 50.0,
                                                    animation: true,
                                                    animateFromLastPercent:
                                                        true,
                                                    progressColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .alternate,
                                                    center: Text(
                                                      valueOrDefault<String>(
                                                        formatNumber(
                                                          _model.communityRatio,
                                                          formatType: FormatType
                                                              .percent,
                                                        ),
                                                        '0',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineSmall
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmallFamily,
                                                            fontSize:
                                                                valueOrDefault<
                                                                    double>(
                                                              () {
                                                                if (FFAppState()
                                                                        .screenCategory ==
                                                                    'small') {
                                                                  return 20.0;
                                                                } else if (FFAppState()
                                                                        .screenCategory ==
                                                                    'medium') {
                                                                  return 22.0;
                                                                } else {
                                                                  return 24.0;
                                                                }
                                                              }(),
                                                              24.0,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmallIsCustom,
                                                          ),
                                                    ),
                                                    barRadius:
                                                        Radius.circular(10.0),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      width: 100.0,
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
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                BodyWidget.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                  ),
                                },
                              );
                            },
                            child: FaIcon(
                              FontAwesomeIcons.streetView,
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
                              context.pushNamed(DashboardWidget.routeName);
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
                          FaIcon(
                            FontAwesomeIcons.thermometerHalf,
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
                        ],
                      ),
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
          safeSetState(() => _model.callToActionController = null);
        },
        onSkip: () {
          return true;
        },
      );
}
