import '/auth/supabase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/indicator_chart_bottom_sheet/indicator_chart_bottom_sheet_widget.dart';
import '/components/indicator_combined_chart_bottom_sheet/indicator_combined_chart_bottom_sheet_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/dashboard.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dashboard_model.dart';
export 'dashboard_model.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  static String routeName = 'Dashboard';
  static String routePath = '/dashboard';

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  late DashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isPageReady = false;
      safeSetState(() {});
      await Future.wait([
        Future(() async {
          _model.consentedIndicatorsOutput =
              await ViewUserConsentedIndicatorsTable().queryRows(
            queryFn: (q) => q.eqOrNull(
              'userid',
              currentUserUid,
            ),
          );
          _model.cWeeklyHealthscoreConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'healthscoreweekly_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );
          _model.cWeeklyAveragePlantsConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'averageplantsweekly_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );
          _model.cWeeklyAveragePortionsConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'averageportionsweekly_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );
          _model.cColorGapsWeeklyConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'colorgapsweekly_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );
          _model.cFrequentFiveConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'frequentfive_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );
          _model.cRareFindsConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'rarefinds_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );
          _model.cTrendWatchConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'trendwatch_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );
          _model.cWeekendDivergenceConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'weekenddivergence_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );
          _model.cFiberTrackerConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'fibertrackerweekly_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );
          _model.cProteinTrackerConsent = valueOrDefault<bool>(
            _model.consentedIndicatorsOutput
                ?.where((e) => valueOrDefault<bool>(
                      e.indicatorName == 'proteintrackerweekly_c',
                      false,
                    ))
                .toList()
                ?.elementAtOrNull(0)
                ?.consent,
            false,
          );
          safeSetState(() {});
          await Future.wait([
            Future(() async {
              await actions.getWeeklyIndividualIndicatorsFlat(
                currentUserUid,
              );
            }),
            Future(() async {
              await actions.getWeeklyCommunityIndicatorsFlat();
            }),
          ]);
          _model.nextJobRuntimeOutput =
              await actions.getNextIndicatorCalculationTime();
          FFAppState().nextUpdateJob = valueOrDefault<String>(
            getJsonField(
              _model.nextJobRuntimeOutput,
              r'''$.next_run_label''',
            )?.toString(),
            'n/a',
          );
          safeSetState(() {});
          _model.isPageReady = true;
          safeSetState(() {});
        }),
        Future(() async {
          _model.mostRecentWeightOutput = await UserVitalsTable().queryRows(
            queryFn: (q) => q
                .eqOrNull(
                  'user_id',
                  currentUserUid,
                )
                .eqOrNull(
                  'vital_type',
                  'Weight',
                )
                .order('updated_at'),
          );
          _model.hasWeightValue = true;
          _model.weightValue = valueOrDefault<double>(
            _model.mostRecentWeightOutput?.firstOrNull?.value,
            0.0,
          );
          _model.proteinDailyRecommended = valueOrDefault<double>(
            valueOrDefault<double>(
                  FFAppState().currentDayNumber.toDouble(),
                  0.0,
                ) *
                valueOrDefault<double>(
                  _model.weightValue,
                  0.0,
                ) *
                FFAppState().userProteinValue,
            0.0,
          );
          safeSetState(() {});
          _model.isPageReady = true;
          safeSetState(() {});
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
                            'Dashboard',
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
                                    'Indicators',
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
                                  10.0, 0.0, 10.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Individual and Community',
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
                        ).addWalkthrough(
                          columnXa67ey42,
                          _model.dashboardController,
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
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                      child: SafeArea(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 470),
                          curve: Curves.easeIn,
                          width: MediaQuery.sizeOf(context).width * 0.95,
                          decoration: BoxDecoration(),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                              0,
                              0,
                              0,
                              20.0,
                            ),
                            scrollDirection: Axis.vertical,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 5.0, 0.0, 5.0),
                                    child: Text(
                                      'Weekly Healthscores',
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            font: GoogleFonts.roboto(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            fontSize: valueOrDefault<double>(
                                              () {
                                                if (FFAppState()
                                                        .screenCategory ==
                                                    'small') {
                                                  return 11.0;
                                                } else if (FFAppState()
                                                        .screenCategory ==
                                                    'medium') {
                                                  return 12.0;
                                                } else {
                                                  return 13.0;
                                                }
                                              }(),
                                              13.0,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle: FontStyle.italic,
                                          ),
                                    ),
                                  ),
                                  AlignedTooltip(
                                    content: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(
                                        'Shows  how well you and the community does with the three rules combined into the healthscore.',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLargeFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              fontSize: valueOrDefault<double>(
                                                () {
                                                  if (FFAppState()
                                                          .screenCategory ==
                                                      'small') {
                                                    return 13.0;
                                                  } else if (FFAppState()
                                                          .screenCategory ==
                                                      'medium') {
                                                    return 15.0;
                                                  } else {
                                                    return 17.0;
                                                  }
                                                }(),
                                                17.0,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyLargeIsCustom,
                                            ),
                                      ),
                                    ),
                                    offset: 4.0,
                                    preferredDirection: AxisDirection.down,
                                    borderRadius: BorderRadius.circular(8.0),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    elevation: 4.0,
                                    tailBaseWidth: 24.0,
                                    tailLength: 12.0,
                                    waitDuration: Duration(milliseconds: 100),
                                    showDuration: Duration(milliseconds: 1500),
                                    triggerMode: TooltipTriggerMode.tap,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 10.0, 0.0),
                                      child: Icon(
                                        Icons.info_outline,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 22.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Color(0xD3B8F9FD),
                                        barrierColor: Color(0xB1B8F9FD),
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: Container(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.8,
                                                child:
                                                    IndicatorChartBottomSheetWidget(
                                                  indicatorName:
                                                      'healthscoreweekly_i',
                                                  userId: currentUserUid,
                                                  isCommunity: false,
                                                  hasSubscription: FFAppState()
                                                      .hasSubscription,
                                                  isPercentageScale: true,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.42,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.13,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.42,
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.09,
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 3.0),
                                                    child: Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.15,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.075,
                                                      child: custom_widgets
                                                          .CircularProgressBar(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.15,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.075,
                                                        progress:
                                                            valueOrDefault<
                                                                double>(
                                                          FFAppState()
                                                              .individualIndicators
                                                              .cwHealthScoreValue,
                                                          0.0,
                                                        ),
                                                        barThickness: 8.0,
                                                        lowColor:
                                                            Color(0xFFFF0000),
                                                        mediumLowColor:
                                                            Color(0xFFFF9200),
                                                        mediumHighColor:
                                                            Color(0xFFFFEC00),
                                                        highColor:
                                                            Color(0xFF05CE00),
                                                        centerBackgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryBackground,
                                                        numberFontSize:
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
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 3.0),
                                                    child: Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.04,
                                                      child: custom_widgets
                                                          .CircularProgressBar(
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
                                                        progress:
                                                            valueOrDefault<
                                                                double>(
                                                          FFAppState()
                                                              .individualIndicators
                                                              .pwHealthScoreValue,
                                                          0.0,
                                                        ),
                                                        barThickness: 5.0,
                                                        lowColor:
                                                            Color(0xFFFF0000),
                                                        mediumLowColor:
                                                            Color(0xFFFF9200),
                                                        mediumHighColor:
                                                            Color(0xFFFFEC00),
                                                        highColor:
                                                            Color(0xFF05CE00),
                                                        centerBackgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryBackground,
                                                        numberFontSize:
                                                            valueOrDefault<
                                                                double>(
                                                          () {
                                                            if (FFAppState()
                                                                    .screenCategory ==
                                                                'small') {
                                                              return 7.0;
                                                            } else if (FFAppState()
                                                                    .screenCategory ==
                                                                'medium') {
                                                              return 8.0;
                                                            } else {
                                                              return 9.0;
                                                            }
                                                          }(),
                                                          9.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.09,
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        0.045,
                                                    child: custom_widgets
                                                        .TendencyIndicator(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.09,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.045,
                                                      progress: valueOrDefault<
                                                          double>(
                                                        FFAppState()
                                                            .individualIndicators
                                                            .cwProgressHealthScoreValue,
                                                        0.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            'You',
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
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            '(realtime)',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .roboto(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
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
                                                                        return 7.0;
                                                                      } else if (FFAppState()
                                                                              .screenCategory ==
                                                                          'medium') {
                                                                        return 8.0;
                                                                      } else {
                                                                        return 9.0;
                                                                      }
                                                                    }(),
                                                                    9.0,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
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
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  5.0,
                                                                  0.0),
                                                      child: Icon(
                                                        Icons.area_chart,
                                                        color:
                                                            Color(0xFFD2D4D8),
                                                        size: valueOrDefault<
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
                                                      ).addWalkthrough(
                                                        iconBxwdxv3c,
                                                        _model
                                                            .dashboardController,
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
                                  ),
                                  SizedBox(
                                    height: valueOrDefault<double>(
                                      () {
                                        if (FFAppState().screenCategory ==
                                            'small') {
                                          return 80.0;
                                        } else if (FFAppState()
                                                .screenCategory ==
                                            'medium') {
                                          return 90.0;
                                        } else {
                                          return 100.0;
                                        }
                                      }(),
                                      199.0,
                                    ),
                                    child: VerticalDivider(
                                      thickness: 2.0,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Color(0xD3B8F9FD),
                                        barrierColor: Color(0xB1B8F9FD),
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: Container(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.8,
                                                child:
                                                    IndicatorChartBottomSheetWidget(
                                                  indicatorName:
                                                      'healthscoreweekly_c',
                                                  userId: currentUserUid,
                                                  isCommunity: true,
                                                  hasSubscription: FFAppState()
                                                      .hasSubscription,
                                                  isPercentageScale: true,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.42,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.13,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.42,
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.09,
                                                  child: Stack(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    children: [
                                                      if (_model.isPageReady &&
                                                          FFAppState()
                                                              .hasSubscription &&
                                                          _model
                                                              .cWeeklyHealthscoreConsent)
                                                        Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.42,
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.09,
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.15,
                                                                      height: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.075,
                                                                      child: custom_widgets
                                                                          .CircularProgressBar(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.15,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.075,
                                                                        progress:
                                                                            valueOrDefault<double>(
                                                                          FFAppState()
                                                                              .communityIndicators
                                                                              .currentWeek
                                                                              .healthScoreValue,
                                                                          0.0,
                                                                        ),
                                                                        barThickness:
                                                                            8.0,
                                                                        lowColor:
                                                                            Color(0xFFFF0000),
                                                                        mediumLowColor:
                                                                            Color(0xFFFF9200),
                                                                        mediumHighColor:
                                                                            Color(0xFFFFEC00),
                                                                        highColor:
                                                                            Color(0xFF05CE00),
                                                                        centerBackgroundColor:
                                                                            FlutterFlowTheme.of(context).secondaryBackground,
                                                                        numberFontSize:
                                                                            valueOrDefault<double>(
                                                                          () {
                                                                            if (FFAppState().screenCategory ==
                                                                                'small') {
                                                                              return 12.0;
                                                                            } else if (FFAppState().screenCategory ==
                                                                                'medium') {
                                                                              return 14.0;
                                                                            } else {
                                                                              return 16.0;
                                                                            }
                                                                          }(),
                                                                          16.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          5.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Text(
                                                                                    '#',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          fontSize: valueOrDefault<double>(
                                                                                            () {
                                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                                return 10.0;
                                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                                return 11.0;
                                                                                              } else {
                                                                                                return 12.0;
                                                                                              }
                                                                                            }(),
                                                                                            12.0,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                  Icon(
                                                                                    Icons.people_rounded,
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                    size: valueOrDefault<double>(
                                                                                      () {
                                                                                        if (FFAppState().screenCategory == 'small') {
                                                                                          return 12.0;
                                                                                        } else if (FFAppState().screenCategory == 'medium') {
                                                                                          return 13.0;
                                                                                        } else {
                                                                                          return 14.0;
                                                                                        }
                                                                                      }(),
                                                                                      14.0,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    valueOrDefault<String>(
                                                                                      FFAppState().communityIndicators.currentWeek.healthScoreCount.toString(),
                                                                                      '0',
                                                                                    ),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          fontSize: valueOrDefault<double>(
                                                                                            () {
                                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                                return 10.0;
                                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                                return 11.0;
                                                                                              } else {
                                                                                                return 12.0;
                                                                                              }
                                                                                            }(),
                                                                                            12.0,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.sizeOf(context).width * 0.08,
                                                                          height:
                                                                              MediaQuery.sizeOf(context).height * 0.04,
                                                                          child:
                                                                              custom_widgets.CircularProgressBar(
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 0.08,
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.04,
                                                                            progress:
                                                                                valueOrDefault<double>(
                                                                              FFAppState().communityIndicators.previousWeek.healthScoreValue,
                                                                              0.0,
                                                                            ),
                                                                            barThickness:
                                                                                5.0,
                                                                            lowColor:
                                                                                Color(0xFFFF0000),
                                                                            mediumLowColor:
                                                                                Color(0xFFFF9200),
                                                                            mediumHighColor:
                                                                                Color(0xFFFFEC00),
                                                                            highColor:
                                                                                Color(0xFF05CE00),
                                                                            centerBackgroundColor:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            numberFontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 7.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 8.0;
                                                                                } else {
                                                                                  return 9.0;
                                                                                }
                                                                              }(),
                                                                              9.0,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              3.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 0.08,
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.04,
                                                                            child:
                                                                                custom_widgets.TendencyIndicator(
                                                                              width: MediaQuery.sizeOf(context).width * 0.08,
                                                                              height: MediaQuery.sizeOf(context).height * 0.04,
                                                                              progress: valueOrDefault<double>(
                                                                                FFAppState().communityIndicators.currentWeek.trendwatch.trendRatio,
                                                                                0.0,
                                                                              ),
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
                                                      if (!_model.isPageReady)
                                                        Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.42,
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.09,
                                                          decoration:
                                                              BoxDecoration(),
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              custom_widgets
                                                                  .SpinnerWidget(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.16,
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.06,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      if (_model.isPageReady &&
                                                          FFAppState()
                                                              .hasSubscription &&
                                                          !_model
                                                              .cWeeklyHealthscoreConsent)
                                                        Material(
                                                          color: Colors
                                                              .transparent,
                                                          elevation: 1.0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      0.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          0.0),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      6.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      6.0),
                                                            ),
                                                          ),
                                                          child: Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.42,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.09,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFF9F8D1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        0.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        0.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        6.0),
                                                              ),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    context
                                                                        .pushNamed(
                                                                      SettingsWidget
                                                                          .routeName,
                                                                      queryParameters:
                                                                          {
                                                                        'settingsTabObjective':
                                                                            serializeParam(
                                                                          4,
                                                                          ParamType
                                                                              .int,
                                                                        ),
                                                                      }.withoutNulls,
                                                                      extra: <String,
                                                                          dynamic>{
                                                                        kTransitionInfoKey:
                                                                            TransitionInfo(
                                                                          hasTransition:
                                                                              true,
                                                                          transitionType:
                                                                              PageTransitionType.fade,
                                                                        ),
                                                                      },
                                                                    );
                                                                  },
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              0.0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              0.0),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              6.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              6.0),
                                                                    ),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/consent_required_processed.png',
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.35,
                                                                      height: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.075,
                                                                      fit: BoxFit
                                                                          .fitHeight,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      if (_model.isPageReady &&
                                                          !FFAppState()
                                                              .hasSubscription)
                                                        Material(
                                                          color: Colors
                                                              .transparent,
                                                          elevation: 1.0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      0.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          0.0),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      6.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      6.0),
                                                            ),
                                                          ),
                                                          child: Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.42,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.09,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFF9E2E2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        0.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        0.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        6.0),
                                                              ),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    context
                                                                        .pushNamed(
                                                                      SettingsWidget
                                                                          .routeName,
                                                                      queryParameters:
                                                                          {
                                                                        'settingsTabObjective':
                                                                            serializeParam(
                                                                          5,
                                                                          ParamType
                                                                              .int,
                                                                        ),
                                                                      }.withoutNulls,
                                                                    );
                                                                  },
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              0.0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              0.0),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              6.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              6.0),
                                                                    ),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/Subscription.png',
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.35,
                                                                      height: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.07,
                                                                      fit: BoxFit
                                                                          .fitHeight,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.42,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.03,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        6.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        0.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        0.0),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              5.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            'Community',
                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                  font: GoogleFonts.roboto(
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                    fontStyle: FontStyle.italic,
                                                                                  ),
                                                                                  fontSize: valueOrDefault<double>(
                                                                                    () {
                                                                                      if (FFAppState().screenCategory == 'small') {
                                                                                        return 8.0;
                                                                                      } else if (FFAppState().screenCategory == 'medium') {
                                                                                        return 9.0;
                                                                                      } else {
                                                                                        return 10.0;
                                                                                      }
                                                                                    }(),
                                                                                    10.0,
                                                                                  ),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                  fontStyle: FontStyle.italic,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              5.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            FFAppState().nextUpdateJob,
                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                  font: GoogleFonts.roboto(
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FontStyle.italic,
                                                                                  ),
                                                                                  fontSize: valueOrDefault<double>(
                                                                                    () {
                                                                                      if (FFAppState().screenCategory == 'small') {
                                                                                        return 7.0;
                                                                                      } else if (FFAppState().screenCategory == 'medium') {
                                                                                        return 8.0;
                                                                                      } else {
                                                                                        return 9.0;
                                                                                      }
                                                                                    }(),
                                                                                    9.0,
                                                                                  ),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FontStyle.italic,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          5.0,
                                                                          0.0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .area_chart,
                                                                        color: Color(
                                                                            0xFFD2D4D8),
                                                                        size: valueOrDefault<
                                                                            double>(
                                                                          () {
                                                                            if (FFAppState().screenCategory ==
                                                                                'small') {
                                                                              return 16.0;
                                                                            } else if (FFAppState().screenCategory ==
                                                                                'medium') {
                                                                              return 18.0;
                                                                            } else {
                                                                              return 20.0;
                                                                            }
                                                                          }(),
                                                                          20.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          if (_model
                                                                  .cWeeklyHealthscoreConsent ==
                                                              false)
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  SettingsWidget
                                                                      .routeName,
                                                                  queryParameters:
                                                                      {
                                                                    'settingsTabObjective':
                                                                        serializeParam(
                                                                      4,
                                                                      ParamType
                                                                          .int,
                                                                    ),
                                                                  }.withoutNulls,
                                                                  extra: <String,
                                                                      dynamic>{
                                                                    kTransitionInfoKey:
                                                                        TransitionInfo(
                                                                      hasTransition:
                                                                          true,
                                                                      transitionType:
                                                                          PageTransitionType
                                                                              .fade,
                                                                    ),
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.42,
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.025,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            6.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            6.0),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            0.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            0.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      if (FFAppState()
                                                              .hasSubscription ==
                                                          false)
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            context.pushNamed(
                                                              SettingsWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'settingsTabObjective':
                                                                    serializeParam(
                                                                  5,
                                                                  ParamType.int,
                                                                ),
                                                              }.withoutNulls,
                                                              extra: <String,
                                                                  dynamic>{
                                                                kTransitionInfoKey:
                                                                    TransitionInfo(
                                                                  hasTransition:
                                                                      true,
                                                                  transitionType:
                                                                      PageTransitionType
                                                                          .fade,
                                                                ),
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.42,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.025,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        6.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        0.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        0.0),
                                                              ),
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
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 15.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 5.0, 0.0, 5.0),
                                      child: Text(
                                        'Weekly Fiber Challenge (in g)',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.roboto(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              fontSize: valueOrDefault<double>(
                                                () {
                                                  if (FFAppState()
                                                          .screenCategory ==
                                                      'small') {
                                                    return 11.0;
                                                  } else if (FFAppState()
                                                          .screenCategory ==
                                                      'medium') {
                                                    return 12.0;
                                                  } else {
                                                    return 13.0;
                                                  }
                                                }(),
                                                13.0,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle: FontStyle.italic,
                                            ),
                                      ),
                                    ),
                                    AlignedTooltip(
                                      content: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                          'Shows how well you (blue) do on fiber intake per day. It is related to the fiber rate, found in Settings. ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                fontSize:
                                                    valueOrDefault<double>(
                                                  () {
                                                    if (FFAppState()
                                                            .screenCategory ==
                                                        'small') {
                                                      return 13.0;
                                                    } else if (FFAppState()
                                                            .screenCategory ==
                                                        'medium') {
                                                      return 15.0;
                                                    } else {
                                                      return 17.0;
                                                    }
                                                  }(),
                                                  17.0,
                                                ),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLargeIsCustom,
                                              ),
                                        ),
                                      ),
                                      offset: 4.0,
                                      preferredDirection: AxisDirection.down,
                                      borderRadius: BorderRadius.circular(8.0),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      elevation: 4.0,
                                      tailBaseWidth: 24.0,
                                      tailLength: 12.0,
                                      waitDuration: Duration(milliseconds: 100),
                                      showDuration:
                                          Duration(milliseconds: 1500),
                                      triggerMode: TooltipTriggerMode.tap,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 10.0, 0.0),
                                        child: Icon(
                                          Icons.info_outline,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          size: 22.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Color(0xD3B8F9FD),
                                        barrierColor: Color(0xB1B8F9FD),
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: Container(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.8,
                                                child:
                                                    IndicatorChartBottomSheetWidget(
                                                  indicatorName:
                                                      'fibertrackerweekly_i',
                                                  userId: currentUserUid,
                                                  isCommunity: false,
                                                  hasSubscription: FFAppState()
                                                      .hasSubscription,
                                                  isPercentageScale: false,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.91,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.12,
                                        constraints: BoxConstraints(
                                          minWidth:
                                              MediaQuery.sizeOf(context).width *
                                                  0.91,
                                          minHeight: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.12,
                                          maxWidth:
                                              MediaQuery.sizeOf(context).width *
                                                  0.91,
                                          maxHeight: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.91,
                                                      child: Stack(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        children: [
                                                          if (!_model
                                                              .isPageReady)
                                                            Container(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.85,
                                                              height: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .height *
                                                                  0.024,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                              ),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  custom_widgets
                                                                      .SpinnerWidget(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.048,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.024,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.8,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.07,
                                                            child: custom_widgets
                                                                .HorizontalNutrientBar(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.8,
                                                              height: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .height *
                                                                  0.07,
                                                              userValue:
                                                                  valueOrDefault<
                                                                      double>(
                                                                FFAppState()
                                                                    .individualIndicators
                                                                    .cwFiberTrackerValue,
                                                                0.0,
                                                              ),
                                                              communityValue:
                                                                  valueOrDefault<
                                                                      double>(
                                                                (_model.cFiberTrackerConsent ==
                                                                            false) ||
                                                                        (FFAppState().hasSubscription ==
                                                                            false)
                                                                    ? 0.0
                                                                    : valueOrDefault<
                                                                        double>(
                                                                        FFAppState()
                                                                            .communityIndicators
                                                                            .currentWeek
                                                                            .fiberTrackerValue,
                                                                        0.0,
                                                                      ),
                                                                0.0,
                                                              ),
                                                              recommendedValue:
                                                                  valueOrDefault<
                                                                      double>(
                                                                valueOrDefault<
                                                                        double>(
                                                                      FFAppState()
                                                                          .userFiberValue,
                                                                      0.0,
                                                                    ) *
                                                                    valueOrDefault<
                                                                        int>(
                                                                      FFAppState()
                                                                          .currentDayNumber,
                                                                      0,
                                                                    ),
                                                                0.0,
                                                              ),
                                                            ),
                                                          ),
                                                          if (valueOrDefault<
                                                              bool>(
                                                            _model.isPageReady &&
                                                                !FFAppState()
                                                                    .hasSubscription,
                                                            false,
                                                          ))
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  SettingsWidget
                                                                      .routeName,
                                                                  queryParameters:
                                                                      {
                                                                    'settingsTabObjective':
                                                                        serializeParam(
                                                                      5,
                                                                      ParamType
                                                                          .int,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Material(
                                                                color: Colors
                                                                    .transparent,
                                                                elevation: 1.0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4.0),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.85,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.024,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFFF9E2E2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                5.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'Community Value',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    fontSize: valueOrDefault<double>(
                                                                                      () {
                                                                                        if (FFAppState().screenCategory == 'small') {
                                                                                          return 10.0;
                                                                                        } else if (FFAppState().screenCategory == 'medium') {
                                                                                          return 11.0;
                                                                                        } else {
                                                                                          return 12.0;
                                                                                        }
                                                                                      }(),
                                                                                      12.0,
                                                                                    ),
                                                                                    letterSpacing: 1.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            splashColor:
                                                                                Colors.transparent,
                                                                            focusColor:
                                                                                Colors.transparent,
                                                                            hoverColor:
                                                                                Colors.transparent,
                                                                            highlightColor:
                                                                                Colors.transparent,
                                                                            onTap:
                                                                                () async {
                                                                              context.pushNamed(
                                                                                SettingsWidget.routeName,
                                                                                queryParameters: {
                                                                                  'settingsTabObjective': serializeParam(
                                                                                    5,
                                                                                    ParamType.int,
                                                                                  ),
                                                                                }.withoutNulls,
                                                                              );
                                                                            },
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child: Image.asset(
                                                                                'assets/images/Subscription.png',
                                                                                width: MediaQuery.sizeOf(context).width * 0.05,
                                                                                height: MediaQuery.sizeOf(context).height * 0.024,
                                                                                fit: BoxFit.fitHeight,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                5.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'Subscription Required',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    fontSize: valueOrDefault<double>(
                                                                                      () {
                                                                                        if (FFAppState().screenCategory == 'small') {
                                                                                          return 10.0;
                                                                                        } else if (FFAppState().screenCategory == 'medium') {
                                                                                          return 11.0;
                                                                                        } else {
                                                                                          return 12.0;
                                                                                        }
                                                                                      }(),
                                                                                      12.0,
                                                                                    ),
                                                                                    letterSpacing: 1.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          if (valueOrDefault<
                                                              bool>(
                                                            _model.isPageReady &&
                                                                FFAppState()
                                                                    .hasSubscription &&
                                                                !_model
                                                                    .cFiberTrackerConsent,
                                                            false,
                                                          ))
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  SettingsWidget
                                                                      .routeName,
                                                                  queryParameters:
                                                                      {
                                                                    'settingsTabObjective':
                                                                        serializeParam(
                                                                      4,
                                                                      ParamType
                                                                          .int,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Material(
                                                                color: Colors
                                                                    .transparent,
                                                                elevation: 1.0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4.0),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.85,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.024,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFFF9F8D1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                5.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'Community Value',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    fontSize: valueOrDefault<double>(
                                                                                      () {
                                                                                        if (FFAppState().screenCategory == 'small') {
                                                                                          return 10.0;
                                                                                        } else if (FFAppState().screenCategory == 'medium') {
                                                                                          return 11.0;
                                                                                        } else {
                                                                                          return 12.0;
                                                                                        }
                                                                                      }(),
                                                                                      12.0,
                                                                                    ),
                                                                                    letterSpacing: 1.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(4.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/consent_required_processed.png',
                                                                              width: MediaQuery.sizeOf(context).width * 0.05,
                                                                              height: MediaQuery.sizeOf(context).height * 0.024,
                                                                              fit: BoxFit.fitHeight,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                5.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'Consent Required',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    fontSize: valueOrDefault<double>(
                                                                                      () {
                                                                                        if (FFAppState().screenCategory == 'small') {
                                                                                          return 10.0;
                                                                                        } else if (FFAppState().screenCategory == 'medium') {
                                                                                          return 11.0;
                                                                                        } else {
                                                                                          return 12.0;
                                                                                        }
                                                                                      }(),
                                                                                      12.0,
                                                                                    ),
                                                                                    letterSpacing: 1.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 3.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                        0.0),
                                                            child: Text(
                                                              'You',
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
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 8.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 9.0;
                                                                        } else {
                                                                          return 10.0;
                                                                        }
                                                                      }(),
                                                                      10.0,
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
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              FFAppState()
                                                                  .nextUpdateJob,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodySmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .roboto(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                    ),
                                                                    fontSize:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 7.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 8.0;
                                                                        } else {
                                                                          return 9.0;
                                                                        }
                                                                      }(),
                                                                      9.0,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
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
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                5.0, 0.0),
                                                    child: Icon(
                                                      Icons.area_chart,
                                                      color: Color(0xFFD2D4D8),
                                                      size: valueOrDefault<
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
                                ],
                              ).addWalkthrough(
                                row7tqkpjrw,
                                _model.dashboardController,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 15.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 5.0, 0.0, 5.0),
                                      child: Text(
                                        'Weekly Protein Challenge (plant-based, in g)',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.roboto(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              fontSize: valueOrDefault<double>(
                                                () {
                                                  if (FFAppState()
                                                          .screenCategory ==
                                                      'small') {
                                                    return 11.0;
                                                  } else if (FFAppState()
                                                          .screenCategory ==
                                                      'medium') {
                                                    return 12.0;
                                                  } else {
                                                    return 13.0;
                                                  }
                                                }(),
                                                13.0,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle: FontStyle.italic,
                                            ),
                                      ),
                                    ),
                                    AlignedTooltip(
                                      content: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                          'Shows how well you (blue) do on protein intake per day. It is related to the protein rate, found in Settings. ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                fontSize:
                                                    valueOrDefault<double>(
                                                  () {
                                                    if (FFAppState()
                                                            .screenCategory ==
                                                        'small') {
                                                      return 13.0;
                                                    } else if (FFAppState()
                                                            .screenCategory ==
                                                        'medium') {
                                                      return 15.0;
                                                    } else {
                                                      return 17.0;
                                                    }
                                                  }(),
                                                  17.0,
                                                ),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLargeIsCustom,
                                              ),
                                        ),
                                      ),
                                      offset: 4.0,
                                      preferredDirection: AxisDirection.down,
                                      borderRadius: BorderRadius.circular(8.0),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      elevation: 4.0,
                                      tailBaseWidth: 24.0,
                                      tailLength: 12.0,
                                      waitDuration: Duration(milliseconds: 100),
                                      showDuration:
                                          Duration(milliseconds: 1500),
                                      triggerMode: TooltipTriggerMode.tap,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 10.0, 0.0),
                                        child: Icon(
                                          Icons.info_outline,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          size: 22.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Color(0xD3B8F9FD),
                                        barrierColor: Color(0xB1B8F9FD),
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: Container(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.8,
                                                child:
                                                    IndicatorChartBottomSheetWidget(
                                                  indicatorName:
                                                      'proteintrackerweekly_i',
                                                  userId: currentUserUid,
                                                  isCommunity: false,
                                                  hasSubscription: FFAppState()
                                                      .hasSubscription,
                                                  isPercentageScale: false,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.91,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.12,
                                        constraints: BoxConstraints(
                                          minWidth:
                                              MediaQuery.sizeOf(context).width *
                                                  0.91,
                                          minHeight: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.12,
                                          maxWidth:
                                              MediaQuery.sizeOf(context).width *
                                                  0.91,
                                          maxHeight: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.91,
                                                    child: Stack(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      children: [
                                                        if (!_model.isPageReady)
                                                          Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.85,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.024,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                custom_widgets
                                                                    .SpinnerWidget(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.048,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.024,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.8,
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.07,
                                                          child: custom_widgets
                                                              .HorizontalNutrientBar(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.8,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.07,
                                                            userValue:
                                                                valueOrDefault<
                                                                    double>(
                                                              FFAppState()
                                                                  .individualIndicators
                                                                  .cwProteinTrackerValue,
                                                              0.0,
                                                            ),
                                                            communityValue:
                                                                valueOrDefault<
                                                                    double>(
                                                              (_model.cProteinTrackerConsent ==
                                                                          false) ||
                                                                      (FFAppState()
                                                                              .hasSubscription ==
                                                                          false)
                                                                  ? 0.0
                                                                  : valueOrDefault<
                                                                      double>(
                                                                      FFAppState()
                                                                          .communityIndicators
                                                                          .currentWeek
                                                                          .proteinTrackerValue,
                                                                      0.0,
                                                                    ),
                                                              0.0,
                                                            ),
                                                            recommendedValue:
                                                                valueOrDefault<
                                                                    double>(
                                                              _model
                                                                  .proteinDailyRecommended,
                                                              0.0,
                                                            ),
                                                          ),
                                                        ),
                                                        if (valueOrDefault<
                                                            bool>(
                                                          _model.isPageReady &&
                                                              !FFAppState()
                                                                  .hasSubscription,
                                                          false,
                                                        ))
                                                          InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            focusColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () async {
                                                              context.pushNamed(
                                                                SettingsWidget
                                                                    .routeName,
                                                                queryParameters:
                                                                    {
                                                                  'settingsTabObjective':
                                                                      serializeParam(
                                                                    5,
                                                                    ParamType
                                                                        .int,
                                                                  ),
                                                                }.withoutNulls,
                                                              );
                                                            },
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              elevation: 1.0,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                              ),
                                                              child: Container(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.85,
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.024,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFFF9E2E2),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4.0),
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              5.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            'Community Value',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  fontSize: valueOrDefault<double>(
                                                                                    () {
                                                                                      if (FFAppState().screenCategory == 'small') {
                                                                                        return 10.0;
                                                                                      } else if (FFAppState().screenCategory == 'medium') {
                                                                                        return 11.0;
                                                                                      } else {
                                                                                        return 12.0;
                                                                                      }
                                                                                    }(),
                                                                                    12.0,
                                                                                  ),
                                                                                  letterSpacing: 1.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/Subscription.png',
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 0.05,
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.024,
                                                                            fit:
                                                                                BoxFit.fitHeight,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              5.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            'Subscription Required',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  fontSize: valueOrDefault<double>(
                                                                                    () {
                                                                                      if (FFAppState().screenCategory == 'small') {
                                                                                        return 10.0;
                                                                                      } else if (FFAppState().screenCategory == 'medium') {
                                                                                        return 11.0;
                                                                                      } else {
                                                                                        return 12.0;
                                                                                      }
                                                                                    }(),
                                                                                    12.0,
                                                                                  ),
                                                                                  letterSpacing: 1.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        if (valueOrDefault<
                                                            bool>(
                                                          _model.isPageReady &&
                                                              FFAppState()
                                                                  .hasSubscription &&
                                                              !_model
                                                                  .cProteinTrackerConsent,
                                                          false,
                                                        ))
                                                          InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            focusColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () async {
                                                              context.pushNamed(
                                                                SettingsWidget
                                                                    .routeName,
                                                                queryParameters:
                                                                    {
                                                                  'settingsTabObjective':
                                                                      serializeParam(
                                                                    4,
                                                                    ParamType
                                                                        .int,
                                                                  ),
                                                                }.withoutNulls,
                                                              );
                                                            },
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              elevation: 1.0,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                              ),
                                                              child: Container(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.85,
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.024,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFFF9F8D1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4.0),
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              5.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            'Community Value',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  fontSize: valueOrDefault<double>(
                                                                                    () {
                                                                                      if (FFAppState().screenCategory == 'small') {
                                                                                        return 10.0;
                                                                                      } else if (FFAppState().screenCategory == 'medium') {
                                                                                        return 11.0;
                                                                                      } else {
                                                                                        return 12.0;
                                                                                      }
                                                                                    }(),
                                                                                    12.0,
                                                                                  ),
                                                                                  letterSpacing: 1.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/consent_required_processed.png',
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 0.05,
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.024,
                                                                            fit:
                                                                                BoxFit.fitHeight,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              5.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            'Consent Required',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  fontSize: valueOrDefault<double>(
                                                                                    () {
                                                                                      if (FFAppState().screenCategory == 'small') {
                                                                                        return 10.0;
                                                                                      } else if (FFAppState().screenCategory == 'medium') {
                                                                                        return 11.0;
                                                                                      } else {
                                                                                        return 12.0;
                                                                                      }
                                                                                    }(),
                                                                                    12.0,
                                                                                  ),
                                                                                  letterSpacing: 1.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 3.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                        0.0),
                                                            child: Text(
                                                              'You',
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
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 8.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 9.0;
                                                                        } else {
                                                                          return 10.0;
                                                                        }
                                                                      }(),
                                                                      10.0,
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
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              FFAppState()
                                                                  .nextUpdateJob,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodySmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .roboto(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                    ),
                                                                    fontSize:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 7.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 8.0;
                                                                        } else {
                                                                          return 9.0;
                                                                        }
                                                                      }(),
                                                                      9.0,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
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
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                5.0, 0.0),
                                                    child: Icon(
                                                      Icons.area_chart,
                                                      color: Color(0xFFD2D4D8),
                                                      size: valueOrDefault<
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
                                ],
                              ).addWalkthrough(
                                row49gz4fek,
                                _model.dashboardController,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 15.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5.0, 5.0, 0.0, 5.0),
                                            child: Text(
                                              'Weekly Missing Colors',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    font: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                    fontSize:
                                                        valueOrDefault<double>(
                                                      () {
                                                        if (FFAppState()
                                                                .screenCategory ==
                                                            'small') {
                                                          return 11.0;
                                                        } else if (FFAppState()
                                                                .screenCategory ==
                                                            'medium') {
                                                          return 12.0;
                                                        } else {
                                                          return 13.0;
                                                        }
                                                      }(),
                                                      13.0,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                            ),
                                          ),
                                          AlignedTooltip(
                                            content: Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Text(
                                                'Shows those colors (plants) that could still be on your plate this week.',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLargeFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      fontSize: valueOrDefault<
                                                          double>(
                                                        () {
                                                          if (FFAppState()
                                                                  .screenCategory ==
                                                              'small') {
                                                            return 13.0;
                                                          } else if (FFAppState()
                                                                  .screenCategory ==
                                                              'medium') {
                                                            return 15.0;
                                                          } else {
                                                            return 17.0;
                                                          }
                                                        }(),
                                                        17.0,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLargeIsCustom,
                                                    ),
                                              ),
                                            ),
                                            offset: 4.0,
                                            preferredDirection:
                                                AxisDirection.down,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            elevation: 4.0,
                                            tailBaseWidth: 24.0,
                                            tailLength: 12.0,
                                            waitDuration:
                                                Duration(milliseconds: 100),
                                            showDuration:
                                                Duration(milliseconds: 1500),
                                            triggerMode: TooltipTriggerMode.tap,
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 0.0, 10.0, 0.0),
                                              child: Icon(
                                                Icons.info_outline,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                size: 22.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5.0, 5.0, 0.0, 5.0),
                                            child: Text(
                                              'Weekly Least Colors ',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    font: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                    fontSize:
                                                        valueOrDefault<double>(
                                                      () {
                                                        if (FFAppState()
                                                                .screenCategory ==
                                                            'small') {
                                                          return 11.0;
                                                        } else if (FFAppState()
                                                                .screenCategory ==
                                                            'medium') {
                                                          return 12.0;
                                                        } else {
                                                          return 13.0;
                                                        }
                                                      }(),
                                                      13.0,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                            ),
                                          ),
                                          AlignedTooltip(
                                            content: Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Text(
                                                'The three colors least consumed by the community: percentage of all users & average portions per consumer of the color.  ',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLargeFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      fontSize: valueOrDefault<
                                                          double>(
                                                        () {
                                                          if (FFAppState()
                                                                  .screenCategory ==
                                                              'small') {
                                                            return 13.0;
                                                          } else if (FFAppState()
                                                                  .screenCategory ==
                                                              'medium') {
                                                            return 15.0;
                                                          } else {
                                                            return 17.0;
                                                          }
                                                        }(),
                                                        17.0,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLargeIsCustom,
                                                    ),
                                              ),
                                            ),
                                            offset: 4.0,
                                            preferredDirection:
                                                AxisDirection.down,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            elevation: 4.0,
                                            tailBaseWidth: 24.0,
                                            tailLength: 12.0,
                                            waitDuration:
                                                Duration(milliseconds: 100),
                                            showDuration:
                                                Duration(milliseconds: 1500),
                                            triggerMode: TooltipTriggerMode.tap,
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 0.0, 10.0, 0.0),
                                              child: Icon(
                                                Icons.info_outline,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                size: 22.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Color(0xD3B8F9FD),
                                        barrierColor: Color(0xB1B8F9FD),
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: Container(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.8,
                                                child:
                                                    IndicatorCombinedChartBottomSheetWidget(
                                                  indicatorName:
                                                      'colorgapsweekly_i',
                                                  userId: currentUserUid,
                                                  isCommunity: false,
                                                  hasSubscription: FFAppState()
                                                      .hasSubscription,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.42,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.15,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  valueOrDefault<String>(
                                                    FFAppState()
                                                        .individualIndicators
                                                        .cwColorGapsMissingCount
                                                        .toString(),
                                                    '0',
                                                  ),
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
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
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
                                                Builder(
                                                  builder: (context) {
                                                    if (valueOrDefault<int>(
                                                          FFAppState()
                                                              .individualIndicators
                                                              .cwColorGapsMissingColors
                                                              .length,
                                                          0,
                                                        ) >
                                                        0) {
                                                      return Container(
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.04,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Builder(
                                                              builder:
                                                                  (context) {
                                                                final colorgapsDC = FFAppState()
                                                                    .individualIndicators
                                                                    .cwColorGapsMissingColors
                                                                    .map((e) =>
                                                                        e)
                                                                    .toList();

                                                                return ListView
                                                                    .separated(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  itemCount:
                                                                      colorgapsDC
                                                                          .length,
                                                                  separatorBuilder: (_,
                                                                          __) =>
                                                                      SizedBox(
                                                                          width:
                                                                              5.0),
                                                                  itemBuilder:
                                                                      (context,
                                                                          colorgapsDCIndex) {
                                                                    final colorgapsDCItem =
                                                                        colorgapsDC[
                                                                            colorgapsDCIndex];
                                                                    return Material(
                                                                      color: Colors
                                                                          .transparent,
                                                                      elevation:
                                                                          1.0,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6.0),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.04,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.04,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              valueOrDefault<Color>(
                                                                            () {
                                                                              if (colorgapsDCItem == 'Red') {
                                                                                return Color(0xFFFF4D4D);
                                                                              } else if (colorgapsDCItem == 'Orange') {
                                                                                return Color(0xFFFFB449);
                                                                              } else if (colorgapsDCItem == 'Yellow') {
                                                                                return Color(0xFFF8F146);
                                                                              } else if (colorgapsDCItem == 'Green') {
                                                                                return Color(0xFF79FF65);
                                                                              } else if (colorgapsDCItem == 'Purple') {
                                                                                return Color(0xFFCF6EFF);
                                                                              } else if (colorgapsDCItem == 'Brown') {
                                                                                return Color(0xFFAD844F);
                                                                              } else {
                                                                                return FlutterFlowTheme.of(context).secondaryBackground;
                                                                              }
                                                                            }(),
                                                                            FlutterFlowTheme.of(context).primary,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(6.0),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Color(0xFF4B4A4A),
                                                                            width:
                                                                                1.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      return Container(
                                                        width: 100.0,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.04,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Icon(
                                                          Icons
                                                              .thumb_up_outlined,
                                                          color:
                                                              Color(0xFF43AE39),
                                                          size: valueOrDefault<
                                                              double>(
                                                            () {
                                                              if (FFAppState()
                                                                      .screenCategory ==
                                                                  'small') {
                                                                return 24.0;
                                                              } else if (FFAppState()
                                                                      .screenCategory ==
                                                                  'medium') {
                                                                return 28.0;
                                                              } else {
                                                                return 32.0;
                                                              }
                                                            }(),
                                                            32.0,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                                      0.0),
                                                          child: Text(
                                                            'You',
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
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            '(realtime)',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .roboto(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
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
                                                                        return 7.0;
                                                                      } else if (FFAppState()
                                                                              .screenCategory ==
                                                                          'medium') {
                                                                        return 8.0;
                                                                      } else {
                                                                        return 9.0;
                                                                      }
                                                                    }(),
                                                                    9.0,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
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
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 5.0, 0.0),
                                                  child: Icon(
                                                    Icons.area_chart,
                                                    color: Color(0xFFD2D4D8),
                                                    size:
                                                        valueOrDefault<double>(
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
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: valueOrDefault<double>(
                                      () {
                                        if (FFAppState().screenCategory ==
                                            'small') {
                                          return 80.0;
                                        } else if (FFAppState()
                                                .screenCategory ==
                                            'medium') {
                                          return 90.0;
                                        } else {
                                          return 100.0;
                                        }
                                      }(),
                                      199.0,
                                    ),
                                    child: VerticalDivider(
                                      thickness: 2.0,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.42,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.15,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF4F4F4),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  3.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Color',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
                                                                          'small') {
                                                                        return 9.0;
                                                                      } else if (FFAppState()
                                                                              .screenCategory ==
                                                                          'medium') {
                                                                        return 10.0;
                                                                      } else {
                                                                        return 11.0;
                                                                      }
                                                                    }(),
                                                                    10.0,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          '% of all',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                fontSize:
                                                                    valueOrDefault<
                                                                        double>(
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
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'Users ',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                fontSize:
                                                                    valueOrDefault<
                                                                        double>(
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
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 5.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'Avg Portions',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                fontSize:
                                                                    valueOrDefault<
                                                                        double>(
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
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'per Consumer',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                fontSize:
                                                                    valueOrDefault<
                                                                        double>(
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
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  if (valueOrDefault<bool>(
                                                    _model.isPageReady &&
                                                        FFAppState()
                                                            .hasSubscription &&
                                                        _model
                                                            .cColorGapsWeeklyConsent,
                                                    false,
                                                  ))
                                                    Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.42,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.06,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.38,
                                                                      height: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.015,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            elevation:
                                                                                1.0,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              width: MediaQuery.sizeOf(context).width * 0.08,
                                                                              height: MediaQuery.sizeOf(context).height * 0.015,
                                                                              decoration: BoxDecoration(
                                                                                color: valueOrDefault<Color>(
                                                                                  () {
                                                                                    if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.color == 'Red') {
                                                                                      return Color(0xFFE93434);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.color == 'Orange') {
                                                                                      return Color(0xFFF6BD34);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.color == 'Yellow') {
                                                                                      return Color(0xFFF6FB58);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.color == 'Green') {
                                                                                      return Color(0xFF6EFB4F);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.color == 'Purple') {
                                                                                      return Color(0xFFBC3EF9);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.color == 'Brown') {
                                                                                      return Color(0xFFAD844F);
                                                                                    } else {
                                                                                      return FlutterFlowTheme.of(context).secondaryBackground;
                                                                                    }
                                                                                  }(),
                                                                                  Color(0xFFDADADA),
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                border: Border.all(
                                                                                  color: valueOrDefault<Color>(
                                                                                    () {
                                                                                      if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.color == 'Red') {
                                                                                        return FlutterFlowTheme.of(context).redBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.color == 'Orange') {
                                                                                        return FlutterFlowTheme.of(context).orangeBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.color == 'Yellow') {
                                                                                        return FlutterFlowTheme.of(context).yellowBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.color == 'Green') {
                                                                                        return FlutterFlowTheme.of(context).greenBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.color == 'Purple') {
                                                                                        return FlutterFlowTheme.of(context).purpleBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.color == 'Brown') {
                                                                                        return FlutterFlowTheme.of(context).brownBorder;
                                                                                      } else {
                                                                                        return FlutterFlowTheme.of(context).whiteBorder;
                                                                                      }
                                                                                    }(),
                                                                                    Color(0xFFDADADA),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  formatNumber(
                                                                                    FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.pctConsumers,
                                                                                    formatType: FormatType.percent,
                                                                                  ),
                                                                                  '0',
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      fontSize: valueOrDefault<double>(
                                                                                        () {
                                                                                          if (FFAppState().screenCategory == 'small') {
                                                                                            return 10.0;
                                                                                          } else if (FFAppState().screenCategory == 'medium') {
                                                                                            return 11.0;
                                                                                          } else {
                                                                                            return 12.0;
                                                                                          }
                                                                                        }(),
                                                                                        12.0,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontStyle: FontStyle.italic,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  formatNumber(
                                                                                    FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(0)?.avgPortionsPerConsumer,
                                                                                    formatType: FormatType.custom,
                                                                                    format: '##.##',
                                                                                    locale: '',
                                                                                  ),
                                                                                  '0',
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      fontSize: valueOrDefault<double>(
                                                                                        () {
                                                                                          if (FFAppState().screenCategory == 'small') {
                                                                                            return 10.0;
                                                                                          } else if (FFAppState().screenCategory == 'medium') {
                                                                                            return 11.0;
                                                                                          } else {
                                                                                            return 12.0;
                                                                                          }
                                                                                        }(),
                                                                                        12.0,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontStyle: FontStyle.italic,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.38,
                                                                      height: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.015,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            elevation:
                                                                                1.0,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              width: MediaQuery.sizeOf(context).width * 0.08,
                                                                              height: MediaQuery.sizeOf(context).height * 0.015,
                                                                              decoration: BoxDecoration(
                                                                                color: valueOrDefault<Color>(
                                                                                  () {
                                                                                    if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.color == 'Red') {
                                                                                      return Color(0xFFE93434);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.color == 'Orange') {
                                                                                      return Color(0xFFF6BD34);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.color == 'Yellow') {
                                                                                      return Color(0xFFF6FB58);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.color == 'Green') {
                                                                                      return Color(0xFF6EFB4F);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.color == 'Purple') {
                                                                                      return Color(0xFFBC3EF9);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.color == 'Brown') {
                                                                                      return Color(0xFFAD844F);
                                                                                    } else {
                                                                                      return FlutterFlowTheme.of(context).secondaryBackground;
                                                                                    }
                                                                                  }(),
                                                                                  Color(0xFFDADADA),
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                border: Border.all(
                                                                                  color: valueOrDefault<Color>(
                                                                                    () {
                                                                                      if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.color == 'Red') {
                                                                                        return FlutterFlowTheme.of(context).redBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.color == 'Orange') {
                                                                                        return FlutterFlowTheme.of(context).orangeBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.color == 'Yellow') {
                                                                                        return FlutterFlowTheme.of(context).yellowBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.color == 'Green') {
                                                                                        return FlutterFlowTheme.of(context).greenBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.color == 'Purple') {
                                                                                        return FlutterFlowTheme.of(context).purpleBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.color == 'Brown') {
                                                                                        return FlutterFlowTheme.of(context).brownBorder;
                                                                                      } else {
                                                                                        return FlutterFlowTheme.of(context).whiteBorder;
                                                                                      }
                                                                                    }(),
                                                                                    Color(0xFFDADADA),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  formatNumber(
                                                                                    FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.pctConsumers,
                                                                                    formatType: FormatType.percent,
                                                                                  ),
                                                                                  '0',
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      fontSize: valueOrDefault<double>(
                                                                                        () {
                                                                                          if (FFAppState().screenCategory == 'small') {
                                                                                            return 10.0;
                                                                                          } else if (FFAppState().screenCategory == 'medium') {
                                                                                            return 11.0;
                                                                                          } else {
                                                                                            return 12.0;
                                                                                          }
                                                                                        }(),
                                                                                        12.0,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontStyle: FontStyle.italic,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  formatNumber(
                                                                                    FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(1)?.avgPortionsPerConsumer,
                                                                                    formatType: FormatType.custom,
                                                                                    format: '##.##',
                                                                                    locale: '',
                                                                                  ),
                                                                                  '0',
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      fontSize: valueOrDefault<double>(
                                                                                        () {
                                                                                          if (FFAppState().screenCategory == 'small') {
                                                                                            return 10.0;
                                                                                          } else if (FFAppState().screenCategory == 'medium') {
                                                                                            return 11.0;
                                                                                          } else {
                                                                                            return 12.0;
                                                                                          }
                                                                                        }(),
                                                                                        12.0,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontStyle: FontStyle.italic,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.38,
                                                                      height: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.015,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            elevation:
                                                                                1.0,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              width: MediaQuery.sizeOf(context).width * 0.08,
                                                                              height: MediaQuery.sizeOf(context).height * 0.015,
                                                                              decoration: BoxDecoration(
                                                                                color: valueOrDefault<Color>(
                                                                                  () {
                                                                                    if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.color == 'Red') {
                                                                                      return Color(0xFFE93434);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.color == 'Orange') {
                                                                                      return Color(0xFFF6BD34);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.color == 'Yellow') {
                                                                                      return Color(0xFFF6FB58);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.color == 'Green') {
                                                                                      return Color(0xFF6EFB4F);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.color == 'Purple') {
                                                                                      return Color(0xFFBC3EF9);
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.color == 'Brown') {
                                                                                      return Color(0xFFAD844F);
                                                                                    } else {
                                                                                      return FlutterFlowTheme.of(context).secondaryBackground;
                                                                                    }
                                                                                  }(),
                                                                                  Color(0xFFDADADA),
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                border: Border.all(
                                                                                  color: valueOrDefault<Color>(
                                                                                    () {
                                                                                      if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.color == 'Red') {
                                                                                        return FlutterFlowTheme.of(context).redBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.color == 'Orange') {
                                                                                        return FlutterFlowTheme.of(context).orangeBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.color == 'Yellow') {
                                                                                        return FlutterFlowTheme.of(context).yellowBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.color == 'Green') {
                                                                                        return FlutterFlowTheme.of(context).greenBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.color == 'Purple') {
                                                                                        return FlutterFlowTheme.of(context).purpleBorder;
                                                                                      } else if (FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.color == 'Brown') {
                                                                                        return FlutterFlowTheme.of(context).brownBorder;
                                                                                      } else {
                                                                                        return FlutterFlowTheme.of(context).whiteBorder;
                                                                                      }
                                                                                    }(),
                                                                                    Color(0xFFDADADA),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  formatNumber(
                                                                                    FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.pctConsumers,
                                                                                    formatType: FormatType.percent,
                                                                                  ),
                                                                                  '0',
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      fontSize: valueOrDefault<double>(
                                                                                        () {
                                                                                          if (FFAppState().screenCategory == 'small') {
                                                                                            return 10.0;
                                                                                          } else if (FFAppState().screenCategory == 'medium') {
                                                                                            return 11.0;
                                                                                          } else {
                                                                                            return 12.0;
                                                                                          }
                                                                                        }(),
                                                                                        12.0,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontStyle: FontStyle.italic,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  formatNumber(
                                                                                    FFAppState().communityIndicators.currentWeek.colorGaps.elementAtOrNull(2)?.avgPortionsPerConsumer,
                                                                                    formatType: FormatType.custom,
                                                                                    format: '##.##',
                                                                                    locale: '',
                                                                                  ),
                                                                                  '0',
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      fontSize: valueOrDefault<double>(
                                                                                        () {
                                                                                          if (FFAppState().screenCategory == 'small') {
                                                                                            return 10.0;
                                                                                          } else if (FFAppState().screenCategory == 'medium') {
                                                                                            return 11.0;
                                                                                          } else {
                                                                                            return 12.0;
                                                                                          }
                                                                                        }(),
                                                                                        12.0,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontStyle: FontStyle.italic,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
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
                                                        ],
                                                      ),
                                                    ),
                                                  if (!_model.isPageReady)
                                                    Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.42,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.06,
                                                      decoration:
                                                          BoxDecoration(),
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          custom_widgets
                                                              .SpinnerWidget(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.16,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.055,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  if (valueOrDefault<bool>(
                                                    _model.isPageReady &&
                                                        !FFAppState()
                                                            .hasSubscription,
                                                    false,
                                                  ))
                                                    Material(
                                                      color: Colors.transparent,
                                                      elevation: 1.0,
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.42,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.06,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFF9E2E2),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  SettingsWidget
                                                                      .routeName,
                                                                  queryParameters:
                                                                      {
                                                                    'settingsTabObjective':
                                                                        serializeParam(
                                                                      5,
                                                                      ParamType
                                                                          .int,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          0.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          0.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6.0),
                                                                ),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/Subscription.png',
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.35,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.05,
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  if (valueOrDefault<bool>(
                                                    _model.isPageReady &&
                                                        FFAppState()
                                                            .hasSubscription &&
                                                        !_model
                                                            .cColorGapsWeeklyConsent,
                                                    false,
                                                  ))
                                                    Material(
                                                      color: Colors.transparent,
                                                      elevation: 1.0,
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.42,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.06,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFF9F8D1),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  SettingsWidget
                                                                      .routeName,
                                                                  queryParameters:
                                                                      {
                                                                    'settingsTabObjective':
                                                                        serializeParam(
                                                                      4,
                                                                      ParamType
                                                                          .int,
                                                                    ),
                                                                  }.withoutNulls,
                                                                  extra: <String,
                                                                      dynamic>{
                                                                    kTransitionInfoKey:
                                                                        TransitionInfo(
                                                                      hasTransition:
                                                                          true,
                                                                      transitionType:
                                                                          PageTransitionType
                                                                              .fade,
                                                                    ),
                                                                  },
                                                                );
                                                              },
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          0.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          0.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6.0),
                                                                ),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/consent_required_processed.png',
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.35,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.05,
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                                    0.0),
                                                        child: Text(
                                                          'Community',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
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
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            FFAppState()
                                                                .nextUpdateJob,
                                                            'n/a',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .roboto(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
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
                                                                      return 7.0;
                                                                    } else if (FFAppState()
                                                                            .screenCategory ==
                                                                        'medium') {
                                                                      return 8.0;
                                                                    } else {
                                                                      return 9.0;
                                                                    }
                                                                  }(),
                                                                  9.0,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 15.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 5.0, 0.0, 5.0),
                                      child: Text(
                                        'Weekly Consumption Averages',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.roboto(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              fontSize: valueOrDefault<double>(
                                                () {
                                                  if (FFAppState()
                                                          .screenCategory ==
                                                      'small') {
                                                    return 11.0;
                                                  } else if (FFAppState()
                                                          .screenCategory ==
                                                      'medium') {
                                                    return 12.0;
                                                  } else {
                                                    return 13.0;
                                                  }
                                                }(),
                                                13.0,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle: FontStyle.italic,
                                            ),
                                      ),
                                    ),
                                    AlignedTooltip(
                                      content: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                          'Shows your\'s and the community\'s average consumptions per day (different plants and overall servings). ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                fontSize:
                                                    valueOrDefault<double>(
                                                  () {
                                                    if (FFAppState()
                                                            .screenCategory ==
                                                        'small') {
                                                      return 13.0;
                                                    } else if (FFAppState()
                                                            .screenCategory ==
                                                        'medium') {
                                                      return 15.0;
                                                    } else {
                                                      return 17.0;
                                                    }
                                                  }(),
                                                  17.0,
                                                ),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLargeIsCustom,
                                              ),
                                        ),
                                      ),
                                      offset: 4.0,
                                      preferredDirection: AxisDirection.down,
                                      borderRadius: BorderRadius.circular(8.0),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      elevation: 4.0,
                                      tailBaseWidth: 24.0,
                                      tailLength: 12.0,
                                      waitDuration: Duration(milliseconds: 100),
                                      showDuration:
                                          Duration(milliseconds: 1500),
                                      triggerMode: TooltipTriggerMode.tap,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 10.0, 0.0),
                                        child: Icon(
                                          Icons.info_outline,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          size: 22.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.42,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Color(0xD3B8F9FD),
                                                  barrierColor:
                                                      Color(0xB1B8F9FD),
                                                  useSafeArea: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      },
                                                      child: Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child: Container(
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.8,
                                                          child:
                                                              IndicatorChartBottomSheetWidget(
                                                            indicatorName:
                                                                'averageplantsweekly_i',
                                                            userId:
                                                                currentUserUid,
                                                            isCommunity: false,
                                                            hasSubscription:
                                                                FFAppState()
                                                                    .hasSubscription,
                                                            isPercentageScale:
                                                                false,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              },
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 1.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                                child: Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.42,
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.11,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF4F4F4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Plants/d',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.05,
                                                            child: Stack(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              children: [
                                                                Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  elevation:
                                                                      1.0,
                                                                  shape:
                                                                      const CircleBorder(),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.11,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.11,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFAE7EDFD),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    formatNumber(
                                                                      FFAppState()
                                                                          .individualIndicators
                                                                          .cwAveragePlantsValue,
                                                                      formatType:
                                                                          FormatType
                                                                              .custom,
                                                                      format:
                                                                          '###.##',
                                                                      locale:
                                                                          '',
                                                                    ),
                                                                    '0',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontSize:
                                                                            valueOrDefault<double>(
                                                                          () {
                                                                            if (FFAppState().screenCategory ==
                                                                                'small') {
                                                                              return 14.0;
                                                                            } else if (FFAppState().screenCategory ==
                                                                                'medium') {
                                                                              return 15.0;
                                                                            } else {
                                                                              return 16.0;
                                                                            }
                                                                          }(),
                                                                          16.0,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      'You',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.roboto(
                                                                              fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 8.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 9.0;
                                                                                } else {
                                                                                  return 10.0;
                                                                                }
                                                                              }(),
                                                                              10.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                            fontStyle:
                                                                                FontStyle.italic,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      valueOrDefault<
                                                                          String>(
                                                                        FFAppState()
                                                                            .nextUpdateJob,
                                                                        'n/a',
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.roboto(
                                                                              fontWeight: FontWeight.normal,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 7.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 8.0;
                                                                                } else {
                                                                                  return 9.0;
                                                                                }
                                                                              }(),
                                                                              9.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            fontStyle:
                                                                                FontStyle.italic,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        3.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons.area_chart,
                                                              color: Color(
                                                                  0xFFD2D4D8),
                                                              size:
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
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Color(0xD3B8F9FD),
                                                  barrierColor:
                                                      Color(0xB1B8F9FD),
                                                  useSafeArea: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      },
                                                      child: Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child: Container(
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.8,
                                                          child:
                                                              IndicatorChartBottomSheetWidget(
                                                            indicatorName:
                                                                'averageportionsweekly_i',
                                                            userId:
                                                                currentUserUid,
                                                            isCommunity: false,
                                                            hasSubscription:
                                                                FFAppState()
                                                                    .hasSubscription,
                                                            isPercentageScale:
                                                                false,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              },
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 1.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                                child: Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.42,
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.11,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF4F4F4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Portions/d',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.05,
                                                            child: Stack(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              children: [
                                                                Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  elevation:
                                                                      1.0,
                                                                  shape:
                                                                      const CircleBorder(),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.11,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.11,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFAE7EDFD),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    formatNumber(
                                                                      FFAppState()
                                                                          .individualIndicators
                                                                          .cwAveragePortionsValue,
                                                                      formatType:
                                                                          FormatType
                                                                              .custom,
                                                                      format:
                                                                          '###.##',
                                                                      locale:
                                                                          '',
                                                                    ),
                                                                    '0',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontSize:
                                                                            valueOrDefault<double>(
                                                                          () {
                                                                            if (FFAppState().screenCategory ==
                                                                                'small') {
                                                                              return 14.0;
                                                                            } else if (FFAppState().screenCategory ==
                                                                                'medium') {
                                                                              return 15.0;
                                                                            } else {
                                                                              return 16.0;
                                                                            }
                                                                          }(),
                                                                          16.0,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      'You',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.roboto(
                                                                              fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 8.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 9.0;
                                                                                } else {
                                                                                  return 10.0;
                                                                                }
                                                                              }(),
                                                                              10.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                            fontStyle:
                                                                                FontStyle.italic,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      '(realtime)',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.roboto(
                                                                              fontWeight: FontWeight.normal,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 7.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 8.0;
                                                                                } else {
                                                                                  return 9.0;
                                                                                }
                                                                              }(),
                                                                              9.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            fontStyle:
                                                                                FontStyle.italic,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        3.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons.area_chart,
                                                              color: Color(
                                                                  0xFFD2D4D8),
                                                              size:
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
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: valueOrDefault<double>(
                                      () {
                                        if (FFAppState().screenCategory ==
                                            'small') {
                                          return 140.0;
                                        } else if (FFAppState()
                                                .screenCategory ==
                                            'medium') {
                                          return 160.0;
                                        } else {
                                          return 180.0;
                                        }
                                      }(),
                                      180.0,
                                    ),
                                    child: VerticalDivider(
                                      thickness: 2.0,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.42,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Material(
                                                  color: Colors.transparent,
                                                  elevation: 1.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.42,
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        0.11,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF4F4F4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Plants/d',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 10.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 11.0;
                                                                        } else {
                                                                          return 12.0;
                                                                        }
                                                                      }(),
                                                                      12.0,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.42,
                                                              height: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .height *
                                                                  0.05,
                                                              child: Stack(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                children: [
                                                                  if (valueOrDefault<
                                                                      bool>(
                                                                    _model.isPageReady &&
                                                                        FFAppState()
                                                                            .hasSubscription &&
                                                                        _model
                                                                            .cWeeklyAveragePlantsConsent,
                                                                    false,
                                                                  ))
                                                                    InkWell(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      focusColor:
                                                                          Colors
                                                                              .transparent,
                                                                      hoverColor:
                                                                          Colors
                                                                              .transparent,
                                                                      highlightColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onTap:
                                                                          () async {
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Color(0xD3B8F9FD),
                                                                          barrierColor:
                                                                              Color(0xB1B8F9FD),
                                                                          useSafeArea:
                                                                              true,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(context).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: Padding(
                                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                                child: Container(
                                                                                  height: MediaQuery.sizeOf(context).height * 0.8,
                                                                                  child: IndicatorChartBottomSheetWidget(
                                                                                    indicatorName: 'averageplantsweekly_c',
                                                                                    userId: currentUserUid,
                                                                                    isCommunity: true,
                                                                                    hasSubscription: FFAppState().hasSubscription,
                                                                                    isPercentageScale: false,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.42,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.05,
                                                                        decoration:
                                                                            BoxDecoration(),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              height: MediaQuery.sizeOf(context).height * 0.05,
                                                                              child: Stack(
                                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                                children: [
                                                                                  Material(
                                                                                    color: Colors.transparent,
                                                                                    elevation: 1.0,
                                                                                    shape: const CircleBorder(),
                                                                                    child: Container(
                                                                                      width: MediaQuery.sizeOf(context).width * 0.11,
                                                                                      height: MediaQuery.sizeOf(context).width * 0.11,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Color(0xFAE7EDFD),
                                                                                        shape: BoxShape.circle,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    valueOrDefault<String>(
                                                                                      formatNumber(
                                                                                        FFAppState().communityIndicators.currentWeek.averagePlantsValue,
                                                                                        formatType: FormatType.custom,
                                                                                        format: '###.##',
                                                                                        locale: '',
                                                                                      ),
                                                                                      '0',
                                                                                    ),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          fontSize: valueOrDefault<double>(
                                                                                            () {
                                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                                return 14.0;
                                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                                return 15.0;
                                                                                              } else {
                                                                                                return 16.0;
                                                                                              }
                                                                                            }(),
                                                                                            16.0,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (valueOrDefault<
                                                                      bool>(
                                                                    _model.isPageReady &&
                                                                        !FFAppState()
                                                                            .hasSubscription,
                                                                    false,
                                                                  ))
                                                                    Material(
                                                                      color: Colors
                                                                          .transparent,
                                                                      elevation:
                                                                          1.0,
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.42,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.05,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0xFFF9E2E2),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
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
                                                                                      5,
                                                                                      ParamType.int,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              },
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.only(
                                                                                  bottomLeft: Radius.circular(0.0),
                                                                                  bottomRight: Radius.circular(0.0),
                                                                                  topLeft: Radius.circular(0.0),
                                                                                  topRight: Radius.circular(0.0),
                                                                                ),
                                                                                child: Image.asset(
                                                                                  'assets/images/Subscription.png',
                                                                                  width: MediaQuery.sizeOf(context).width * 0.2,
                                                                                  height: MediaQuery.sizeOf(context).height * 0.05,
                                                                                  fit: BoxFit.fitHeight,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (valueOrDefault<
                                                                      bool>(
                                                                    _model.isPageReady &&
                                                                        FFAppState()
                                                                            .hasSubscription &&
                                                                        !_model
                                                                            .cWeeklyAveragePlantsConsent,
                                                                    false,
                                                                  ))
                                                                    Material(
                                                                      color: Colors
                                                                          .transparent,
                                                                      elevation:
                                                                          1.0,
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.42,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.05,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0xFFF9F8D1),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
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
                                                                                      4,
                                                                                      ParamType.int,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              },
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.only(
                                                                                  bottomLeft: Radius.circular(0.0),
                                                                                  bottomRight: Radius.circular(0.0),
                                                                                  topLeft: Radius.circular(0.0),
                                                                                  topRight: Radius.circular(0.0),
                                                                                ),
                                                                                child: Image.asset(
                                                                                  'assets/images/consent_required_processed.png',
                                                                                  width: MediaQuery.sizeOf(context).width * 0.2,
                                                                                  height: MediaQuery.sizeOf(context).height * 0.05,
                                                                                  fit: BoxFit.fitHeight,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (!_model
                                                                      .isPageReady)
                                                                    Container(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.42,
                                                                      height: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.05,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          custom_widgets
                                                                              .SpinnerWidget(
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 0.1,
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.05,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Text(
                                                                        'Community',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              font: GoogleFonts.roboto(
                                                                                fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                fontStyle: FontStyle.italic,
                                                                              ),
                                                                              fontSize: valueOrDefault<double>(
                                                                                () {
                                                                                  if (FFAppState().screenCategory == 'small') {
                                                                                    return 8.0;
                                                                                  } else if (FFAppState().screenCategory == 'medium') {
                                                                                    return 9.0;
                                                                                  } else {
                                                                                    return 10.0;
                                                                                  }
                                                                                }(),
                                                                                10.0,
                                                                              ),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          FFAppState()
                                                                              .nextUpdateJob,
                                                                          'n/a',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              font: GoogleFonts.roboto(
                                                                                fontWeight: FontWeight.normal,
                                                                                fontStyle: FontStyle.italic,
                                                                              ),
                                                                              fontSize: valueOrDefault<double>(
                                                                                () {
                                                                                  if (FFAppState().screenCategory == 'small') {
                                                                                    return 7.0;
                                                                                  } else if (FFAppState().screenCategory == 'medium') {
                                                                                    return 8.0;
                                                                                  } else {
                                                                                    return 9.0;
                                                                                  }
                                                                                }(),
                                                                                9.0,
                                                                              ),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          3.0,
                                                                          0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .area_chart,
                                                                color: Color(
                                                                    0xFFD2D4D8),
                                                                size:
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
                                                              ),
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
                                              children: [
                                                Material(
                                                  color: Colors.transparent,
                                                  elevation: 1.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.42,
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        0.11,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF4F4F4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Portions/d',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 10.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 11.0;
                                                                        } else {
                                                                          return 12.0;
                                                                        }
                                                                      }(),
                                                                      12.0,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.42,
                                                              child: Stack(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                children: [
                                                                  if (valueOrDefault<
                                                                      bool>(
                                                                    _model.isPageReady &&
                                                                        FFAppState()
                                                                            .hasSubscription &&
                                                                        _model
                                                                            .cWeeklyAveragePortionsConsent,
                                                                    false,
                                                                  ))
                                                                    InkWell(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      focusColor:
                                                                          Colors
                                                                              .transparent,
                                                                      hoverColor:
                                                                          Colors
                                                                              .transparent,
                                                                      highlightColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onTap:
                                                                          () async {
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Color(0xD3B8F9FD),
                                                                          barrierColor:
                                                                              Color(0xB1B8F9FD),
                                                                          useSafeArea:
                                                                              true,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(context).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: Padding(
                                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                                child: Container(
                                                                                  height: MediaQuery.sizeOf(context).height * 0.8,
                                                                                  child: IndicatorChartBottomSheetWidget(
                                                                                    indicatorName: 'averageportionsweekly_c',
                                                                                    userId: currentUserUid,
                                                                                    isCommunity: true,
                                                                                    hasSubscription: FFAppState().hasSubscription,
                                                                                    isPercentageScale: false,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.42,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.05,
                                                                        decoration:
                                                                            BoxDecoration(),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              height: MediaQuery.sizeOf(context).height * 0.05,
                                                                              child: Stack(
                                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                                children: [
                                                                                  Material(
                                                                                    color: Colors.transparent,
                                                                                    elevation: 1.0,
                                                                                    shape: const CircleBorder(),
                                                                                    child: Container(
                                                                                      width: MediaQuery.sizeOf(context).width * 0.11,
                                                                                      height: MediaQuery.sizeOf(context).width * 0.11,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Color(0xFAE7EDFD),
                                                                                        shape: BoxShape.circle,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    valueOrDefault<String>(
                                                                                      formatNumber(
                                                                                        FFAppState().communityIndicators.currentWeek.averagePortionsValue,
                                                                                        formatType: FormatType.custom,
                                                                                        format: '###.##',
                                                                                        locale: '',
                                                                                      ),
                                                                                      '0',
                                                                                    ),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          fontSize: valueOrDefault<double>(
                                                                                            () {
                                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                                return 14.0;
                                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                                return 15.0;
                                                                                              } else {
                                                                                                return 16.0;
                                                                                              }
                                                                                            }(),
                                                                                            16.0,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (valueOrDefault<
                                                                      bool>(
                                                                    _model.isPageReady &&
                                                                        !FFAppState()
                                                                            .hasSubscription,
                                                                    false,
                                                                  ))
                                                                    Material(
                                                                      color: Colors
                                                                          .transparent,
                                                                      elevation:
                                                                          1.0,
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.42,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.05,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0xFFF9E2E2),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
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
                                                                                      5,
                                                                                      ParamType.int,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              },
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.only(
                                                                                  bottomLeft: Radius.circular(0.0),
                                                                                  bottomRight: Radius.circular(0.0),
                                                                                  topLeft: Radius.circular(0.0),
                                                                                  topRight: Radius.circular(0.0),
                                                                                ),
                                                                                child: Image.asset(
                                                                                  'assets/images/Subscription.png',
                                                                                  width: MediaQuery.sizeOf(context).width * 0.2,
                                                                                  height: MediaQuery.sizeOf(context).height * 0.05,
                                                                                  fit: BoxFit.fitHeight,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (valueOrDefault<
                                                                      bool>(
                                                                    _model.isPageReady &&
                                                                        FFAppState()
                                                                            .hasSubscription &&
                                                                        !_model
                                                                            .cWeeklyAveragePortionsConsent,
                                                                    false,
                                                                  ))
                                                                    Material(
                                                                      color: Colors
                                                                          .transparent,
                                                                      elevation:
                                                                          1.0,
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.42,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.05,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0xFFF9F8D1),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
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
                                                                                      4,
                                                                                      ParamType.int,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              },
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.only(
                                                                                  bottomLeft: Radius.circular(0.0),
                                                                                  bottomRight: Radius.circular(0.0),
                                                                                  topLeft: Radius.circular(0.0),
                                                                                  topRight: Radius.circular(0.0),
                                                                                ),
                                                                                child: Image.asset(
                                                                                  'assets/images/consent_required_processed.png',
                                                                                  width: MediaQuery.sizeOf(context).width * 0.2,
                                                                                  height: MediaQuery.sizeOf(context).height * 0.05,
                                                                                  fit: BoxFit.fitHeight,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (!_model
                                                                      .isPageReady)
                                                                    Material(
                                                                      color: Colors
                                                                          .transparent,
                                                                      elevation:
                                                                          1.0,
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.42,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.05,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0xFFF9E2E2),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            custom_widgets.SpinnerWidget(
                                                                              width: MediaQuery.sizeOf(context).width * 0.1,
                                                                              height: MediaQuery.sizeOf(context).height * 0.05,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Text(
                                                                        'Community',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              font: GoogleFonts.roboto(
                                                                                fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                fontStyle: FontStyle.italic,
                                                                              ),
                                                                              fontSize: valueOrDefault<double>(
                                                                                () {
                                                                                  if (FFAppState().screenCategory == 'small') {
                                                                                    return 8.0;
                                                                                  } else if (FFAppState().screenCategory == 'medium') {
                                                                                    return 9.0;
                                                                                  } else {
                                                                                    return 10.0;
                                                                                  }
                                                                                }(),
                                                                                10.0,
                                                                              ),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          FFAppState()
                                                                              .nextUpdateJob,
                                                                          'n/a',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              font: GoogleFonts.roboto(
                                                                                fontWeight: FontWeight.normal,
                                                                                fontStyle: FontStyle.italic,
                                                                              ),
                                                                              fontSize: valueOrDefault<double>(
                                                                                () {
                                                                                  if (FFAppState().screenCategory == 'small') {
                                                                                    return 7.0;
                                                                                  } else if (FFAppState().screenCategory == 'medium') {
                                                                                    return 8.0;
                                                                                  } else {
                                                                                    return 9.0;
                                                                                  }
                                                                                }(),
                                                                                9.0,
                                                                              ),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          3.0,
                                                                          0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .area_chart,
                                                                color: Color(
                                                                    0xFFD2D4D8),
                                                                size:
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
                                                              ),
                                                            ),
                                                          ],
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
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 15.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 5.0, 0.0, 5.0),
                                      child: Text(
                                        'Weekly Consistency',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.roboto(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              fontSize: valueOrDefault<double>(
                                                () {
                                                  if (FFAppState()
                                                          .screenCategory ==
                                                      'small') {
                                                    return 11.0;
                                                  } else if (FFAppState()
                                                          .screenCategory ==
                                                      'medium') {
                                                    return 12.0;
                                                  } else {
                                                    return 13.0;
                                                  }
                                                }(),
                                                13.0,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle: FontStyle.italic,
                                            ),
                                      ),
                                    ),
                                    AlignedTooltip(
                                      content: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                          'Shows how balanced you eat plants during the week. The more equally distributed the eating, the higher the score. ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                fontSize:
                                                    valueOrDefault<double>(
                                                  () {
                                                    if (FFAppState()
                                                            .screenCategory ==
                                                        'small') {
                                                      return 13.0;
                                                    } else if (FFAppState()
                                                            .screenCategory ==
                                                        'medium') {
                                                      return 15.0;
                                                    } else {
                                                      return 17.0;
                                                    }
                                                  }(),
                                                  17.0,
                                                ),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLargeIsCustom,
                                              ),
                                        ),
                                      ),
                                      offset: 4.0,
                                      preferredDirection: AxisDirection.down,
                                      borderRadius: BorderRadius.circular(8.0),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      elevation: 4.0,
                                      tailBaseWidth: 24.0,
                                      tailLength: 12.0,
                                      waitDuration: Duration(milliseconds: 100),
                                      showDuration:
                                          Duration(milliseconds: 1500),
                                      triggerMode: TooltipTriggerMode.tap,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 10.0, 0.0),
                                        child: Icon(
                                          Icons.info_outline,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          size: 22.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Color(0xD3B8F9FD),
                                        barrierColor: Color(0xB1B8F9FD),
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: Container(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.8,
                                                child:
                                                    IndicatorChartBottomSheetWidget(
                                                  indicatorName:
                                                      'consistencyscoreweekly_i',
                                                  userId: currentUserUid,
                                                  isCommunity: false,
                                                  hasSubscription: FFAppState()
                                                      .hasSubscription,
                                                  isPercentageScale: true,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.91,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.15,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'This week:',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      fontSize:
                                                                          valueOrDefault<
                                                                              double>(
                                                                        () {
                                                                          if (FFAppState().screenCategory ==
                                                                              'small') {
                                                                            return 12.0;
                                                                          } else if (FFAppState().screenCategory ==
                                                                              'medium') {
                                                                            return 13.0;
                                                                          } else {
                                                                            return 14.0;
                                                                          }
                                                                        }(),
                                                                        14.0,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.55,
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.05,
                                                                child: custom_widgets
                                                                    .HorizontalConsistencyScoreBar(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.55,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.05,
                                                                  score:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    FFAppState()
                                                                        .individualIndicators
                                                                        .cwConsistencyScoreValue,
                                                                    0.0,
                                                                  ),
                                                                  barHeight:
                                                                      30.0,
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                  useMonochrome:
                                                                      false,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Last week:',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      fontSize:
                                                                          valueOrDefault<
                                                                              double>(
                                                                        () {
                                                                          if (FFAppState().screenCategory ==
                                                                              'small') {
                                                                            return 12.0;
                                                                          } else if (FFAppState().screenCategory ==
                                                                              'medium') {
                                                                            return 13.0;
                                                                          } else {
                                                                            return 14.0;
                                                                          }
                                                                        }(),
                                                                        14.0,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.55,
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.05,
                                                                child: custom_widgets
                                                                    .HorizontalConsistencyScoreBar(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.55,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.05,
                                                                  score:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    FFAppState()
                                                                        .individualIndicators
                                                                        .pwConsistencyScoreValue,
                                                                    0.0,
                                                                  ),
                                                                  barHeight:
                                                                      20.0,
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                  useMonochrome:
                                                                      true,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(10.0, 0.0,
                                                                10.0, 0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.08,
                                                              height: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .height *
                                                                  0.04,
                                                              child: custom_widgets
                                                                  .TendencyIndicator(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.08,
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.04,
                                                                progress:
                                                                    valueOrDefault<
                                                                        double>(
                                                                  FFAppState()
                                                                      .individualIndicators
                                                                      .cwProgressConsistencyValue,
                                                                  0.0,
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
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 3.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                        0.0),
                                                            child: Text(
                                                              'You',
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
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 8.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 9.0;
                                                                        } else {
                                                                          return 10.0;
                                                                        }
                                                                      }(),
                                                                      10.0,
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
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              '(realtime)',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodySmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .roboto(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                    ),
                                                                    fontSize:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 7.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 8.0;
                                                                        } else {
                                                                          return 9.0;
                                                                        }
                                                                      }(),
                                                                      9.0,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
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
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                5.0, 0.0),
                                                    child: Icon(
                                                      Icons.area_chart,
                                                      color: Color(0xFFD2D4D8),
                                                      size: valueOrDefault<
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
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 15.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 5.0, 0.0, 5.0),
                                      child: Text(
                                        'Weekly Top and Low Plants',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.roboto(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              fontSize: valueOrDefault<double>(
                                                () {
                                                  if (FFAppState()
                                                          .screenCategory ==
                                                      'small') {
                                                    return 11.0;
                                                  } else if (FFAppState()
                                                          .screenCategory ==
                                                      'medium') {
                                                    return 12.0;
                                                  } else {
                                                    return 13.0;
                                                  }
                                                }(),
                                                13.0,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle: FontStyle.italic,
                                            ),
                                      ),
                                    ),
                                    AlignedTooltip(
                                      content: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                          'Shows the community\'s top and least consumed plants and how many people did eat those plants. ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                fontSize:
                                                    valueOrDefault<double>(
                                                  () {
                                                    if (FFAppState()
                                                            .screenCategory ==
                                                        'small') {
                                                      return 13.0;
                                                    } else if (FFAppState()
                                                            .screenCategory ==
                                                        'medium') {
                                                      return 15.0;
                                                    } else {
                                                      return 17.0;
                                                    }
                                                  }(),
                                                  17.0,
                                                ),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLargeIsCustom,
                                              ),
                                        ),
                                      ),
                                      offset: 4.0,
                                      preferredDirection: AxisDirection.down,
                                      borderRadius: BorderRadius.circular(8.0),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      elevation: 4.0,
                                      tailBaseWidth: 24.0,
                                      tailLength: 12.0,
                                      waitDuration: Duration(milliseconds: 100),
                                      showDuration:
                                          Duration(milliseconds: 1500),
                                      triggerMode: TooltipTriggerMode.tap,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 10.0, 0.0),
                                        child: Icon(
                                          Icons.info_outline,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          size: 22.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.92,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.23,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF4F4F4),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 2.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
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
                                                                    0.0),
                                                        child: Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.22,
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Text(
                                                            'Top',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
                                                                          'small') {
                                                                        return 11.0;
                                                                      } else if (FFAppState()
                                                                              .screenCategory ==
                                                                          'medium') {
                                                                        return 12.0;
                                                                      } else {
                                                                        return 13.0;
                                                                      }
                                                                    }(),
                                                                    13.0,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.07,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              '#',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 9.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 10.0;
                                                                        } else {
                                                                          return 11.0;
                                                                        }
                                                                      }(),
                                                                      11.0,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .people_rounded,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size:
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
                                                                    return 13.0;
                                                                  } else {
                                                                    return 14.0;
                                                                  }
                                                                }(),
                                                                14.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          '#Portions',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                fontSize:
                                                                    valueOrDefault<
                                                                        double>(
                                                                  () {
                                                                    if (FFAppState()
                                                                            .screenCategory ==
                                                                        'small') {
                                                                      return 9.0;
                                                                    } else if (FFAppState()
                                                                            .screenCategory ==
                                                                        'medium') {
                                                                      return 10.0;
                                                                    } else {
                                                                      return 11.0;
                                                                    }
                                                                  }(),
                                                                  11.0,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
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
                                                                    0.0),
                                                        child: Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.21,
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Text(
                                                            'Low',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  fontSize:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    () {
                                                                      if (FFAppState()
                                                                              .screenCategory ==
                                                                          'small') {
                                                                        return 11.0;
                                                                      } else if (FFAppState()
                                                                              .screenCategory ==
                                                                          'medium') {
                                                                        return 12.0;
                                                                      } else {
                                                                        return 13.0;
                                                                      }
                                                                    }(),
                                                                    13.0,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.07,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              '#',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 9.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 10.0;
                                                                        } else {
                                                                          return 11.0;
                                                                        }
                                                                      }(),
                                                                      11.0,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          4.0,
                                                                          0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .people_rounded,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size:
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
                                                                      return 13.0;
                                                                    } else {
                                                                      return 14.0;
                                                                    }
                                                                  }(),
                                                                  14.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          '#Portions',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                fontSize:
                                                                    valueOrDefault<
                                                                        double>(
                                                                  () {
                                                                    if (FFAppState()
                                                                            .screenCategory ==
                                                                        'small') {
                                                                      return 9.0;
                                                                    } else if (FFAppState()
                                                                            .screenCategory ==
                                                                        'medium') {
                                                                      return 10.0;
                                                                    } else {
                                                                      return 11.0;
                                                                    }
                                                                  }(),
                                                                  11.0,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
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
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.92,
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        0.16,
                                                    decoration: BoxDecoration(),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.43,
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.16,
                                                          child: Stack(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            children: [
                                                              if (valueOrDefault<
                                                                  bool>(
                                                                _model.isPageReady &&
                                                                    FFAppState()
                                                                        .hasSubscription &&
                                                                    _model
                                                                        .cFrequentFiveConsent,
                                                                false,
                                                              ))
                                                                Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.43,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.16,
                                                                  decoration:
                                                                      BoxDecoration(),
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            5.0),
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          elevation:
                                                                              1.0,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 0.42,
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.04,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: valueOrDefault<Color>(
                                                                                () {
                                                                                  if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.color == 'Red') {
                                                                                    return FlutterFlowTheme.of(context).redFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.color == 'Orange') {
                                                                                    return FlutterFlowTheme.of(context).orangeFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.color == 'Yellow') {
                                                                                    return FlutterFlowTheme.of(context).yellowFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.color == 'Green') {
                                                                                    return FlutterFlowTheme.of(context).greenFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.color == 'Purple') {
                                                                                    return FlutterFlowTheme.of(context).purpleFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.color == 'Brown') {
                                                                                    return FlutterFlowTheme.of(context).brownFill;
                                                                                  } else {
                                                                                    return FlutterFlowTheme.of(context).whiteFill;
                                                                                  }
                                                                                }(),
                                                                                Color(0xFFDADADA),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                              border: Border.all(
                                                                                color: valueOrDefault<Color>(
                                                                                  () {
                                                                                    if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.color == 'Red') {
                                                                                      return FlutterFlowTheme.of(context).redBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.color == 'Orange') {
                                                                                      return FlutterFlowTheme.of(context).orangeBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.color == 'Yellow') {
                                                                                      return FlutterFlowTheme.of(context).yellowBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.color == 'Green') {
                                                                                      return FlutterFlowTheme.of(context).greenBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.color == 'Purple') {
                                                                                      return FlutterFlowTheme.of(context).purpleBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.color == 'Brown') {
                                                                                      return FlutterFlowTheme.of(context).brownBorder;
                                                                                    } else {
                                                                                      return FlutterFlowTheme.of(context).whiteBorder;
                                                                                    }
                                                                                  }(),
                                                                                  Color(0xFFDADADA),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Container(
                                                                                  width: MediaQuery.sizeOf(context).width * 0.24,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                    child: Text(
                                                                                      valueOrDefault<String>(
                                                                                        FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.plantType,
                                                                                        'n/a',
                                                                                      ),
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            fontSize: valueOrDefault<double>(
                                                                                              () {
                                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                                  return 10.0;
                                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                                  return 12.0;
                                                                                                } else {
                                                                                                  return 14.0;
                                                                                                }
                                                                                              }(),
                                                                                              14.0,
                                                                                            ),
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  valueOrDefault<String>(
                                                                                    FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.distinctPlantCount?.toString(),
                                                                                    '0',
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        fontSize: valueOrDefault<double>(
                                                                                          () {
                                                                                            if (FFAppState().screenCategory == 'small') {
                                                                                              return 10.0;
                                                                                            } else if (FFAppState().screenCategory == 'medium') {
                                                                                              return 11.0;
                                                                                            } else {
                                                                                              return 12.0;
                                                                                            }
                                                                                          }(),
                                                                                          12.0,
                                                                                        ),
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                    child: Text(
                                                                                      valueOrDefault<String>(
                                                                                        FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(0)?.totalPortions?.toString(),
                                                                                        '0',
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            fontSize: valueOrDefault<double>(
                                                                                              () {
                                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                                  return 12.0;
                                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                                  return 13.0;
                                                                                                } else {
                                                                                                  return 14.0;
                                                                                                }
                                                                                              }(),
                                                                                              14.0,
                                                                                            ),
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            5.0),
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          elevation:
                                                                              1.0,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 0.42,
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.04,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: valueOrDefault<Color>(
                                                                                () {
                                                                                  if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.color == 'Red') {
                                                                                    return FlutterFlowTheme.of(context).redFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.color == 'Orange') {
                                                                                    return FlutterFlowTheme.of(context).orangeFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.color == 'Yellow') {
                                                                                    return FlutterFlowTheme.of(context).yellowFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.color == 'Green') {
                                                                                    return FlutterFlowTheme.of(context).greenFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.color == 'Purple') {
                                                                                    return FlutterFlowTheme.of(context).purpleFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.color == 'Brown') {
                                                                                    return FlutterFlowTheme.of(context).brownFill;
                                                                                  } else {
                                                                                    return FlutterFlowTheme.of(context).whiteFill;
                                                                                  }
                                                                                }(),
                                                                                Color(0xFFDADADA),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                              border: Border.all(
                                                                                color: valueOrDefault<Color>(
                                                                                  () {
                                                                                    if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.color == 'Red') {
                                                                                      return FlutterFlowTheme.of(context).redBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.color == 'Orange') {
                                                                                      return FlutterFlowTheme.of(context).orangeBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.color == 'Yellow') {
                                                                                      return FlutterFlowTheme.of(context).yellowBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.color == 'Green') {
                                                                                      return FlutterFlowTheme.of(context).greenBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.color == 'Purple') {
                                                                                      return FlutterFlowTheme.of(context).purpleBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.color == 'Brown') {
                                                                                      return FlutterFlowTheme.of(context).brownBorder;
                                                                                    } else {
                                                                                      return FlutterFlowTheme.of(context).whiteBorder;
                                                                                    }
                                                                                  }(),
                                                                                  Color(0xFFDADADA),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Container(
                                                                                  width: MediaQuery.sizeOf(context).width * 0.24,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                    child: Text(
                                                                                      valueOrDefault<String>(
                                                                                        FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.plantType,
                                                                                        'n/a',
                                                                                      ),
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            fontSize: valueOrDefault<double>(
                                                                                              () {
                                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                                  return 10.0;
                                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                                  return 12.0;
                                                                                                } else {
                                                                                                  return 14.0;
                                                                                                }
                                                                                              }(),
                                                                                              14.0,
                                                                                            ),
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  valueOrDefault<String>(
                                                                                    FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.distinctPlantCount?.toString(),
                                                                                    '0',
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        fontSize: valueOrDefault<double>(
                                                                                          () {
                                                                                            if (FFAppState().screenCategory == 'small') {
                                                                                              return 10.0;
                                                                                            } else if (FFAppState().screenCategory == 'medium') {
                                                                                              return 11.0;
                                                                                            } else {
                                                                                              return 12.0;
                                                                                            }
                                                                                          }(),
                                                                                          12.0,
                                                                                        ),
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                    child: Text(
                                                                                      valueOrDefault<String>(
                                                                                        FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(1)?.totalPortions?.toString(),
                                                                                        '0',
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            fontSize: valueOrDefault<double>(
                                                                                              () {
                                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                                  return 12.0;
                                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                                  return 13.0;
                                                                                                } else {
                                                                                                  return 14.0;
                                                                                                }
                                                                                              }(),
                                                                                              14.0,
                                                                                            ),
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        elevation:
                                                                            1.0,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(24.0),
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              MediaQuery.sizeOf(context).width * 0.42,
                                                                          height:
                                                                              MediaQuery.sizeOf(context).height * 0.04,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                valueOrDefault<Color>(
                                                                              () {
                                                                                if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.color == 'Red') {
                                                                                  return FlutterFlowTheme.of(context).redFill;
                                                                                } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.color == 'Orange') {
                                                                                  return FlutterFlowTheme.of(context).orangeFill;
                                                                                } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.color == 'Yellow') {
                                                                                  return FlutterFlowTheme.of(context).yellowFill;
                                                                                } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.color == 'Green') {
                                                                                  return FlutterFlowTheme.of(context).greenFill;
                                                                                } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.color == 'Purple') {
                                                                                  return FlutterFlowTheme.of(context).purpleFill;
                                                                                } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.color == 'Brown') {
                                                                                  return FlutterFlowTheme.of(context).brownFill;
                                                                                } else {
                                                                                  return FlutterFlowTheme.of(context).whiteFill;
                                                                                }
                                                                              }(),
                                                                              Color(0xFFDADADA),
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                            border:
                                                                                Border.all(
                                                                              color: valueOrDefault<Color>(
                                                                                () {
                                                                                  if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.color == 'Red') {
                                                                                    return FlutterFlowTheme.of(context).redBorder;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.color == 'Orange') {
                                                                                    return FlutterFlowTheme.of(context).orangeBorder;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.color == 'Yellow') {
                                                                                    return FlutterFlowTheme.of(context).yellowBorder;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.color == 'Green') {
                                                                                    return FlutterFlowTheme.of(context).greenBorder;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.color == 'Purple') {
                                                                                    return FlutterFlowTheme.of(context).purpleBorder;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.color == 'Brown') {
                                                                                    return FlutterFlowTheme.of(context).brownBorder;
                                                                                  } else {
                                                                                    return FlutterFlowTheme.of(context).whiteBorder;
                                                                                  }
                                                                                }(),
                                                                                Color(0xFFDADADA),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Container(
                                                                                width: MediaQuery.sizeOf(context).width * 0.24,
                                                                                decoration: BoxDecoration(),
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                  child: Text(
                                                                                    valueOrDefault<String>(
                                                                                      FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.plantType,
                                                                                      'n/a',
                                                                                    ),
                                                                                    textAlign: TextAlign.start,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          fontSize: valueOrDefault<double>(
                                                                                            () {
                                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                                return 10.0;
                                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                                return 12.0;
                                                                                              } else {
                                                                                                return 14.0;
                                                                                              }
                                                                                            }(),
                                                                                            14.0,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                valueOrDefault<String>(
                                                                                  FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.distinctPlantCount?.toString(),
                                                                                  '0',
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      fontSize: valueOrDefault<double>(
                                                                                        () {
                                                                                          if (FFAppState().screenCategory == 'small') {
                                                                                            return 10.0;
                                                                                          } else if (FFAppState().screenCategory == 'medium') {
                                                                                            return 11.0;
                                                                                          } else {
                                                                                            return 12.0;
                                                                                          }
                                                                                        }(),
                                                                                        12.0,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                  child: Text(
                                                                                    valueOrDefault<String>(
                                                                                      FFAppState().communityIndicators.currentWeek.frequentFive.elementAtOrNull(2)?.totalPortions?.toString(),
                                                                                      '0',
                                                                                    ),
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          fontSize: valueOrDefault<double>(
                                                                                            () {
                                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                                return 12.0;
                                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                                return 13.0;
                                                                                              } else {
                                                                                                return 14.0;
                                                                                              }
                                                                                            }(),
                                                                                            14.0,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              if (!_model
                                                                  .isPageReady)
                                                                Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.43,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.15,
                                                                  decoration:
                                                                      BoxDecoration(),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      custom_widgets
                                                                          .SpinnerWidget(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.24,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.12,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              if (valueOrDefault<
                                                                  bool>(
                                                                _model.isPageReady &&
                                                                    !FFAppState()
                                                                        .hasSubscription,
                                                                false,
                                                              ))
                                                                Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  elevation:
                                                                      1.0,
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.43,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.15,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFF9E2E2),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            context.pushNamed(
                                                                              SettingsWidget.routeName,
                                                                              queryParameters: {
                                                                                'settingsTabObjective': serializeParam(
                                                                                  5,
                                                                                  ParamType.int,
                                                                                ),
                                                                              }.withoutNulls,
                                                                            );
                                                                          },
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Subscription.png',
                                                                              width: MediaQuery.sizeOf(context).width * 0.43,
                                                                              height: MediaQuery.sizeOf(context).height * 0.12,
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              if (valueOrDefault<
                                                                  bool>(
                                                                _model.isPageReady &&
                                                                    FFAppState()
                                                                        .hasSubscription &&
                                                                    !_model
                                                                        .cFrequentFiveConsent,
                                                                false,
                                                              ))
                                                                Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  elevation:
                                                                      1.0,
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.43,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.15,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFF9F8D1),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            context.pushNamed(
                                                                              SettingsWidget.routeName,
                                                                              queryParameters: {
                                                                                'settingsTabObjective': serializeParam(
                                                                                  4,
                                                                                  ParamType.int,
                                                                                ),
                                                                              }.withoutNulls,
                                                                            );
                                                                          },
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/consent_required_processed.png',
                                                                              width: MediaQuery.sizeOf(context).width * 0.43,
                                                                              height: MediaQuery.sizeOf(context).height * 0.12,
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              valueOrDefault<
                                                                  double>(
                                                            () {
                                                              if (FFAppState()
                                                                      .screenCategory ==
                                                                  'small') {
                                                                return 110.0;
                                                              } else if (FFAppState()
                                                                      .screenCategory ==
                                                                  'medium') {
                                                                return 120.0;
                                                              } else {
                                                                return 130.0;
                                                              }
                                                            }(),
                                                            130.0,
                                                          ),
                                                          child:
                                                              VerticalDivider(
                                                            thickness: 2.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.43,
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.16,
                                                          child: Stack(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            children: [
                                                              if (valueOrDefault<
                                                                  bool>(
                                                                _model.isPageReady &&
                                                                    FFAppState()
                                                                        .hasSubscription &&
                                                                    _model
                                                                        .cRareFindsConsent,
                                                                false,
                                                              ))
                                                                Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.43,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.16,
                                                                  decoration:
                                                                      BoxDecoration(),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            5.0),
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          elevation:
                                                                              1.0,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 0.42,
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.04,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: valueOrDefault<Color>(
                                                                                () {
                                                                                  if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.color == 'Red') {
                                                                                    return FlutterFlowTheme.of(context).redFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.color == 'Orange') {
                                                                                    return FlutterFlowTheme.of(context).orangeFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.color == 'Yellow') {
                                                                                    return FlutterFlowTheme.of(context).yellowFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.color == 'Green') {
                                                                                    return FlutterFlowTheme.of(context).greenFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.color == 'Purple') {
                                                                                    return FlutterFlowTheme.of(context).purpleFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.color == 'Brown') {
                                                                                    return FlutterFlowTheme.of(context).brownFill;
                                                                                  } else {
                                                                                    return FlutterFlowTheme.of(context).whiteFill;
                                                                                  }
                                                                                }(),
                                                                                Color(0xFFDADADA),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                              border: Border.all(
                                                                                color: valueOrDefault<Color>(
                                                                                  () {
                                                                                    if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.color == 'Red') {
                                                                                      return FlutterFlowTheme.of(context).redBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.color == 'Orange') {
                                                                                      return FlutterFlowTheme.of(context).orangeBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.color == 'Yellow') {
                                                                                      return FlutterFlowTheme.of(context).yellowBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.color == 'Green') {
                                                                                      return FlutterFlowTheme.of(context).greenBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.color == 'Purple') {
                                                                                      return FlutterFlowTheme.of(context).purpleBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.color == 'Brown') {
                                                                                      return FlutterFlowTheme.of(context).brownBorder;
                                                                                    } else {
                                                                                      return FlutterFlowTheme.of(context).whiteBorder;
                                                                                    }
                                                                                  }(),
                                                                                  Color(0xFFDADADA),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Container(
                                                                                  width: MediaQuery.sizeOf(context).width * 0.24,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                    child: Text(
                                                                                      valueOrDefault<String>(
                                                                                        FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.plantType,
                                                                                        'n/a',
                                                                                      ),
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            fontSize: valueOrDefault<double>(
                                                                                              () {
                                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                                  return 10.0;
                                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                                  return 12.0;
                                                                                                } else {
                                                                                                  return 14.0;
                                                                                                }
                                                                                              }(),
                                                                                              14.0,
                                                                                            ),
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  valueOrDefault<String>(
                                                                                    FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.distinctPlantCount?.toString(),
                                                                                    '0',
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        fontSize: valueOrDefault<double>(
                                                                                          () {
                                                                                            if (FFAppState().screenCategory == 'small') {
                                                                                              return 10.0;
                                                                                            } else if (FFAppState().screenCategory == 'medium') {
                                                                                              return 11.0;
                                                                                            } else {
                                                                                              return 12.0;
                                                                                            }
                                                                                          }(),
                                                                                          12.0,
                                                                                        ),
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                    child: Text(
                                                                                      valueOrDefault<String>(
                                                                                        FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(0)?.totalPortions?.toString(),
                                                                                        '0',
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            fontSize: valueOrDefault<double>(
                                                                                              () {
                                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                                  return 12.0;
                                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                                  return 13.0;
                                                                                                } else {
                                                                                                  return 14.0;
                                                                                                }
                                                                                              }(),
                                                                                              14.0,
                                                                                            ),
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            5.0),
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          elevation:
                                                                              1.0,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 0.42,
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.04,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: valueOrDefault<Color>(
                                                                                () {
                                                                                  if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.color == 'Red') {
                                                                                    return FlutterFlowTheme.of(context).redFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.color == 'Orange') {
                                                                                    return FlutterFlowTheme.of(context).orangeFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.color == 'Yellow') {
                                                                                    return FlutterFlowTheme.of(context).yellowFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.color == 'Green') {
                                                                                    return FlutterFlowTheme.of(context).greenFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.color == 'Purple') {
                                                                                    return FlutterFlowTheme.of(context).purpleFill;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.color == 'Brown') {
                                                                                    return FlutterFlowTheme.of(context).brownFill;
                                                                                  } else {
                                                                                    return FlutterFlowTheme.of(context).whiteFill;
                                                                                  }
                                                                                }(),
                                                                                Color(0xFFDADADA),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                              border: Border.all(
                                                                                color: valueOrDefault<Color>(
                                                                                  () {
                                                                                    if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.color == 'Red') {
                                                                                      return FlutterFlowTheme.of(context).redBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.color == 'Orange') {
                                                                                      return FlutterFlowTheme.of(context).orangeBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.color == 'Yellow') {
                                                                                      return FlutterFlowTheme.of(context).yellowBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.color == 'Green') {
                                                                                      return FlutterFlowTheme.of(context).greenBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.color == 'Purple') {
                                                                                      return FlutterFlowTheme.of(context).purpleBorder;
                                                                                    } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.color == 'Brown') {
                                                                                      return FlutterFlowTheme.of(context).brownBorder;
                                                                                    } else {
                                                                                      return FlutterFlowTheme.of(context).whiteBorder;
                                                                                    }
                                                                                  }(),
                                                                                  Color(0xFFDADADA),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Container(
                                                                                  width: MediaQuery.sizeOf(context).width * 0.24,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                    child: Text(
                                                                                      valueOrDefault<String>(
                                                                                        FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.plantType,
                                                                                        'n/a',
                                                                                      ),
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            fontSize: valueOrDefault<double>(
                                                                                              () {
                                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                                  return 10.0;
                                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                                  return 12.0;
                                                                                                } else {
                                                                                                  return 14.0;
                                                                                                }
                                                                                              }(),
                                                                                              14.0,
                                                                                            ),
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  valueOrDefault<String>(
                                                                                    FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.distinctPlantCount?.toString(),
                                                                                    '0',
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        fontSize: valueOrDefault<double>(
                                                                                          () {
                                                                                            if (FFAppState().screenCategory == 'small') {
                                                                                              return 10.0;
                                                                                            } else if (FFAppState().screenCategory == 'medium') {
                                                                                              return 11.0;
                                                                                            } else {
                                                                                              return 12.0;
                                                                                            }
                                                                                          }(),
                                                                                          12.0,
                                                                                        ),
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                    child: Text(
                                                                                      valueOrDefault<String>(
                                                                                        FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(1)?.totalPortions?.toString(),
                                                                                        '0',
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            fontSize: valueOrDefault<double>(
                                                                                              () {
                                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                                  return 12.0;
                                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                                  return 13.0;
                                                                                                } else {
                                                                                                  return 14.0;
                                                                                                }
                                                                                              }(),
                                                                                              14.0,
                                                                                            ),
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        elevation:
                                                                            1.0,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(24.0),
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              MediaQuery.sizeOf(context).width * 0.42,
                                                                          height:
                                                                              MediaQuery.sizeOf(context).height * 0.04,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                valueOrDefault<Color>(
                                                                              () {
                                                                                if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.color == 'Red') {
                                                                                  return FlutterFlowTheme.of(context).redFill;
                                                                                } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.color == 'Orange') {
                                                                                  return FlutterFlowTheme.of(context).orangeFill;
                                                                                } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.color == 'Yellow') {
                                                                                  return FlutterFlowTheme.of(context).yellowFill;
                                                                                } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.color == 'Green') {
                                                                                  return FlutterFlowTheme.of(context).greenFill;
                                                                                } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.color == 'Purple') {
                                                                                  return FlutterFlowTheme.of(context).purpleFill;
                                                                                } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.color == 'Brown') {
                                                                                  return FlutterFlowTheme.of(context).brownFill;
                                                                                } else {
                                                                                  return FlutterFlowTheme.of(context).whiteFill;
                                                                                }
                                                                              }(),
                                                                              Color(0xFFDADADA),
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0),
                                                                            border:
                                                                                Border.all(
                                                                              color: valueOrDefault<Color>(
                                                                                () {
                                                                                  if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.color == 'Red') {
                                                                                    return FlutterFlowTheme.of(context).redBorder;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.color == 'Orange') {
                                                                                    return FlutterFlowTheme.of(context).orangeBorder;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.color == 'Yellow') {
                                                                                    return FlutterFlowTheme.of(context).yellowBorder;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.color == 'Green') {
                                                                                    return FlutterFlowTheme.of(context).greenBorder;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.color == 'Purple') {
                                                                                    return FlutterFlowTheme.of(context).purpleBorder;
                                                                                  } else if (FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.color == 'Brown') {
                                                                                    return FlutterFlowTheme.of(context).brownBorder;
                                                                                  } else {
                                                                                    return FlutterFlowTheme.of(context).whiteBorder;
                                                                                  }
                                                                                }(),
                                                                                Color(0xFFDADADA),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Container(
                                                                                width: MediaQuery.sizeOf(context).width * 0.24,
                                                                                decoration: BoxDecoration(),
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                  child: Text(
                                                                                    valueOrDefault<String>(
                                                                                      FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.plantType,
                                                                                      'n/a',
                                                                                    ),
                                                                                    textAlign: TextAlign.start,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          fontSize: valueOrDefault<double>(
                                                                                            () {
                                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                                return 10.0;
                                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                                return 12.0;
                                                                                              } else {
                                                                                                return 14.0;
                                                                                              }
                                                                                            }(),
                                                                                            14.0,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                valueOrDefault<String>(
                                                                                  FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.distinctPlantCount?.toString(),
                                                                                  '0',
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      fontSize: valueOrDefault<double>(
                                                                                        () {
                                                                                          if (FFAppState().screenCategory == 'small') {
                                                                                            return 10.0;
                                                                                          } else if (FFAppState().screenCategory == 'medium') {
                                                                                            return 11.0;
                                                                                          } else {
                                                                                            return 12.0;
                                                                                          }
                                                                                        }(),
                                                                                        12.0,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                  child: Text(
                                                                                    valueOrDefault<String>(
                                                                                      FFAppState().communityIndicators.currentWeek.rareFinds.elementAtOrNull(2)?.totalPortions?.toString(),
                                                                                      '0',
                                                                                    ),
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          fontSize: valueOrDefault<double>(
                                                                                            () {
                                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                                return 12.0;
                                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                                return 13.0;
                                                                                              } else {
                                                                                                return 14.0;
                                                                                              }
                                                                                            }(),
                                                                                            14.0,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              if (!_model
                                                                  .isPageReady)
                                                                Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.43,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.15,
                                                                  decoration:
                                                                      BoxDecoration(),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      custom_widgets
                                                                          .SpinnerWidget(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.24,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.12,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              if (valueOrDefault<
                                                                  bool>(
                                                                _model.isPageReady &&
                                                                    !FFAppState()
                                                                        .hasSubscription,
                                                                false,
                                                              ))
                                                                Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  elevation:
                                                                      1.0,
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.43,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.15,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFF9E2E2),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            context.pushNamed(
                                                                              SettingsWidget.routeName,
                                                                              queryParameters: {
                                                                                'settingsTabObjective': serializeParam(
                                                                                  5,
                                                                                  ParamType.int,
                                                                                ),
                                                                              }.withoutNulls,
                                                                            );
                                                                          },
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Subscription.png',
                                                                              width: MediaQuery.sizeOf(context).width * 0.43,
                                                                              height: MediaQuery.sizeOf(context).height * 0.12,
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              if (valueOrDefault<
                                                                  bool>(
                                                                _model.isPageReady &&
                                                                    FFAppState()
                                                                        .hasSubscription &&
                                                                    !_model
                                                                        .cRareFindsConsent,
                                                                false,
                                                              ))
                                                                Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  elevation:
                                                                      1.0,
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.43,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.15,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFF9F8D1),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            context.pushNamed(
                                                                              SettingsWidget.routeName,
                                                                              queryParameters: {
                                                                                'settingsTabObjective': serializeParam(
                                                                                  4,
                                                                                  ParamType.int,
                                                                                ),
                                                                              }.withoutNulls,
                                                                            );
                                                                          },
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/consent_required_processed.png',
                                                                              width: MediaQuery.sizeOf(context).width * 0.43,
                                                                              height: MediaQuery.sizeOf(context).height * 0.12,
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
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
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                                    0.0),
                                                        child: Text(
                                                          'Community',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
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
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            FFAppState()
                                                                .nextUpdateJob,
                                                            'n/a',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .roboto(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
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
                                                                      return 7.0;
                                                                    } else if (FFAppState()
                                                                            .screenCategory ==
                                                                        'medium') {
                                                                      return 8.0;
                                                                    } else {
                                                                      return 9.0;
                                                                    }
                                                                  }(),
                                                                  9.0,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ].divide(SizedBox(height: 5.0)),
                          ),
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
                          Icon(
                            Icons.bar_chart,
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
                                MeterWidget.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                  ),
                                },
                              );
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
          safeSetState(() => _model.dashboardController = null);
        },
        onSkip: () {
          return true;
        },
      );
}
