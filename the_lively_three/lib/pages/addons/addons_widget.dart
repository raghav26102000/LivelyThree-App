import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/addons.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'addons_model.dart';
export 'addons_model.dart';

class AddonsWidget extends StatefulWidget {
  const AddonsWidget({super.key});

  static String routeName = 'Addons';
  static String routePath = '/addons';

  @override
  State<AddonsWidget> createState() => _AddonsWidgetState();
}

class _AddonsWidgetState extends State<AddonsWidget>
    with TickerProviderStateMixin {
  late AddonsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddonsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          _model.upfOutput = await WeeklyselectedUpfTable().queryRows(
            queryFn: (q) => q
                .eqOrNull(
                  'id_user',
                  currentUserUid,
                )
                .eqOrNull(
                  'calendarweek',
                  FFAppState().calendarWeek,
                )
                .eqOrNull(
                  'calendaryear',
                  FFAppState().calendarYear,
                )
                .order('calendaryear')
                .order('calendarweek'),
          );
          if ((_model.upfOutput != null && (_model.upfOutput)!.isNotEmpty) ==
              true) {
            _model.monUpfCounter = valueOrDefault<int>(
              _model.upfOutput?.elementAtOrNull(0)?.monportion,
              0,
            );
            _model.tueUpfCounter = valueOrDefault<int>(
              _model.upfOutput?.elementAtOrNull(0)?.tueportion,
              0,
            );
            _model.wedUpfCounter = valueOrDefault<int>(
              _model.upfOutput?.elementAtOrNull(0)?.wedportion,
              0,
            );
            _model.thuUpfCounter = valueOrDefault<int>(
              _model.upfOutput?.elementAtOrNull(0)?.thuportion,
              0,
            );
            _model.friUpfCounter = valueOrDefault<int>(
              _model.upfOutput?.elementAtOrNull(0)?.friportion,
              0,
            );
            _model.satUpfCounter = valueOrDefault<int>(
              _model.upfOutput?.elementAtOrNull(0)?.satportion,
              0,
            );
            _model.sunUpfCounter = valueOrDefault<int>(
              _model.upfOutput?.elementAtOrNull(0)?.sunportion,
              0,
            );
            safeSetState(() {});
            await Future.wait([
              Future(() async {
                if (FFAppState().currentDay == 'Monday') {
                  _model.todayUpfCounter = valueOrDefault<int>(
                    _model.monUpfCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
              Future(() async {
                if (FFAppState().currentDay == 'Tuesday') {
                  _model.todayUpfCounter = valueOrDefault<int>(
                    _model.tueUpfCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
              Future(() async {
                if (FFAppState().currentDay == 'Wednesday') {
                  _model.todayUpfCounter = valueOrDefault<int>(
                    _model.wedUpfCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
              Future(() async {
                if (FFAppState().currentDay == 'Thursday') {
                  _model.todayUpfCounter = valueOrDefault<int>(
                    _model.thuUpfCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
              Future(() async {
                if (FFAppState().currentDay == 'Friday') {
                  _model.todayUpfCounter = valueOrDefault<int>(
                    _model.friUpfCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
              Future(() async {
                if (FFAppState().currentDay == 'Saturday') {
                  _model.todayUpfCounter = valueOrDefault<int>(
                    _model.satUpfCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
              Future(() async {
                if (FFAppState().currentDay == 'Sunday') {
                  _model.todayUpfCounter = valueOrDefault<int>(
                    _model.sunUpfCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
            ]);
            _model.idxUpf = 0;
            safeSetState(() {});
            while (_model.idxUpf! < _model.todayUpfCounter!) {
              _model.addToUpfCounterList(valueOrDefault<int>(
                (_model.idxUpf!) + 1,
                0,
              ));
              safeSetState(() {});
              _model.idxUpf = _model.idxUpf! + 1;
              safeSetState(() {});
            }
          } else {
            _model.monUpfCounter = 0;
            _model.tueUpfCounter = 0;
            _model.wedUpfCounter = 0;
            _model.thuUpfCounter = 0;
            _model.friUpfCounter = 0;
            _model.satUpfCounter = 0;
            _model.sunUpfCounter = 0;
            safeSetState(() {});
          }
        }),
        Future(() async {
          _model.weightListOutput = await UserVitalsTable().queryRows(
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
          _model.weightValueDB = valueOrDefault<double>(
            _model.weightListOutput?.elementAtOrNull(0)?.value,
            0.0,
          );
          _model.weightUnitValueDB = valueOrDefault<String>(
            _model.weightListOutput?.elementAtOrNull(0)?.unit,
            'n/a',
          );
          _model.dateWeightValue =
              _model.weightListOutput?.elementAtOrNull(0)?.updatedAt;
          safeSetState(() {});
        }),
        Future(() async {
          _model.waterOutput = await WeeklyselectedWaterTable().queryRows(
            queryFn: (q) => q
                .eqOrNull(
                  'id_user',
                  currentUserUid,
                )
                .eqOrNull(
                  'calendarweek',
                  FFAppState().calendarWeek,
                )
                .eqOrNull(
                  'calendaryear',
                  FFAppState().calendarYear,
                )
                .order('calendaryear')
                .order('calendarweek'),
          );
          if ((_model.waterOutput != null &&
                  (_model.waterOutput)!.isNotEmpty) ==
              true) {
            _model.monWaterCounter = valueOrDefault<int>(
              _model.waterOutput?.elementAtOrNull(0)?.monportion,
              0,
            );
            _model.tueWaterCounter = valueOrDefault<int>(
              _model.waterOutput?.elementAtOrNull(0)?.tueportion,
              0,
            );
            _model.wedWaterCounter = valueOrDefault<int>(
              _model.waterOutput?.elementAtOrNull(0)?.wedportion,
              0,
            );
            _model.thuWaterCounter = valueOrDefault<int>(
              _model.waterOutput?.elementAtOrNull(0)?.thuportion,
              0,
            );
            _model.friWaterCounter = valueOrDefault<int>(
              _model.waterOutput?.elementAtOrNull(0)?.friportion,
              0,
            );
            _model.satWaterCounter = valueOrDefault<int>(
              _model.waterOutput?.elementAtOrNull(0)?.satportion,
              0,
            );
            _model.sunWaterCounter = valueOrDefault<int>(
              _model.waterOutput?.elementAtOrNull(0)?.sunportion,
              0,
            );
            safeSetState(() {});
            await Future.wait([
              Future(() async {
                if (FFAppState().currentDay == 'Monday') {
                  _model.todayWaterCounter = valueOrDefault<int>(
                    _model.monWaterCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
              Future(() async {
                if (FFAppState().currentDay == 'Tuesday') {
                  _model.todayWaterCounter = valueOrDefault<int>(
                    _model.tueWaterCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
              Future(() async {
                if (FFAppState().currentDay == 'Wednesday') {
                  _model.todayWaterCounter = valueOrDefault<int>(
                    _model.wedWaterCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
              Future(() async {
                if (FFAppState().currentDay == 'Thursday') {
                  _model.todayWaterCounter = valueOrDefault<int>(
                    _model.thuWaterCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
              Future(() async {
                if (FFAppState().currentDay == 'Friday') {
                  _model.todayWaterCounter = valueOrDefault<int>(
                    _model.friWaterCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
              Future(() async {
                if (FFAppState().currentDay == 'Saturday') {
                  _model.todayWaterCounter = valueOrDefault<int>(
                    _model.satWaterCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
              Future(() async {
                if (FFAppState().currentDay == 'Sunday') {
                  _model.todayWaterCounter = valueOrDefault<int>(
                    _model.sunWaterCounter,
                    0,
                  );
                  safeSetState(() {});
                }
              }),
            ]);
            _model.idxWater = 0;
            safeSetState(() {});
            while (_model.idxWater! <
                valueOrDefault<int>(
                  _model.todayWaterCounter,
                  0,
                )) {
              _model.addToWaterCounterList(valueOrDefault<int>(
                valueOrDefault<int>(
                      _model.idxWater,
                      0,
                    ) +
                    1,
                0,
              ));
              safeSetState(() {});
              _model.idxWater = _model.idxWater! + 1;
              safeSetState(() {});
            }
          } else {
            _model.monWaterCounter = 0;
            _model.tueWaterCounter = 0;
            _model.wedWaterCounter = 0;
            _model.thuWaterCounter = 0;
            _model.friWaterCounter = 0;
            _model.satWaterCounter = 0;
            _model.sunWaterCounter = 0;
            safeSetState(() {});
          }
        }),
      ]);
    });

    animationsMap.addAll({
      'listViewOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          TintEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 740.0.ms,
            color: Color(0xFFEAE8E8),
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'listViewOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          TintEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 740.0.ms,
            color: Color(0xFFEAE8E8),
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

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
                            'Add-ons',
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                children: [
                                  Expanded(
                                    child: Text(
                                      'UPFs, Water, and Weight',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            fontSize: valueOrDefault<double>(
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
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
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
                                          fontSize: () {
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
                                    'Voluntary data to personalize food impact',
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
                                          fontSize: () {
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
                              endIndent: 10.0,
                              color: FlutterFlowTheme.of(context).accent4,
                            ),
                          ],
                        ).addWalkthrough(
                          column1yu2v9ey,
                          _model.addonsController,
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
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.8,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.06,
                                  decoration: BoxDecoration(),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    'Tap for every consumed portion (~100g) of ultraprocessed food during today.',
                                    textAlign: TextAlign.center,
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
                                                return 15.0;
                                              } else {
                                                return 16.0;
                                              }
                                            }(),
                                            16.0,
                                          ),
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
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.2,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.1,
                                  child: custom_widgets.TapRippleButton(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.1,
                                    imageUrl: 'assets/images/upf.png',
                                    inDurationMs: 100,
                                    outDurationMs: 1500,
                                    fadeFactor: 1.0,
                                    auraBaseColor: Color(0xFFBC9A3F),
                                    onIncrement: (counter) async {
                                      _model.newDayUpfPortionOutput =
                                          await actions.upsertWeeklySelectedUPF(
                                        currentUserUid,
                                        FFAppState().calendarWeek,
                                        FFAppState().calendarYear,
                                        valueOrDefault<int>(
                                          counter,
                                          0,
                                        ),
                                      );
                                      _model.todayUpfCounter =
                                          valueOrDefault<int>(
                                        _model.newDayUpfPortionOutput,
                                        0,
                                      );
                                      safeSetState(() {});
                                      _model.addToUpfCounterList(
                                          _model.todayUpfCounter!);
                                      safeSetState(() {});

                                      safeSetState(() {});
                                    },
                                  ),
                                ).addWalkthrough(
                                  containerBic7dote,
                                  _model.addonsController,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.8,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.05,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Builder(
                                              builder: (context) {
                                                if ((_model.todayUpfCounter ==
                                                        0) ||
                                                    (_model.todayUpfCounter ==
                                                        null)) {
                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.8,
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
                                                              'no consumption today',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.7,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.05,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    12.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    0.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    12.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    0.0),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      0.0,
                                                                      5.0,
                                                                      0.0),
                                                          child: Builder(
                                                            builder: (context) {
                                                              final upfCounterListDC =
                                                                  _model
                                                                      .upfCounterList
                                                                      .toList();

                                                              return InkWell(
                                                                splashColor: Colors
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
                                                                  _model.decrementUpfPortionOutput =
                                                                      await actions
                                                                          .decrementWeeklySelectedUPF(
                                                                    currentUserUid,
                                                                    FFAppState()
                                                                        .calendarWeek,
                                                                    FFAppState()
                                                                        .calendarYear,
                                                                  );
                                                                  _model.removeFromUpfCounterList(
                                                                      _model
                                                                          .todayUpfCounter!);
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.todayUpfCounter =
                                                                      _model
                                                                          .decrementUpfPortionOutput;
                                                                  safeSetState(
                                                                      () {});

                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                                child: ListView
                                                                    .builder(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .fromLTRB(
                                                                    2.0,
                                                                    0,
                                                                    2.0,
                                                                    0,
                                                                  ),
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  itemCount:
                                                                      upfCounterListDC
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          upfCounterListDCIndex) {
                                                                    final upfCounterListDCItem =
                                                                        upfCounterListDC[
                                                                            upfCounterListDCIndex];
                                                                    return Container(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.1,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/upf.png',
                                                                          width:
                                                                              200.0,
                                                                          height:
                                                                              200.0,
                                                                          fit: BoxFit
                                                                              .fitWidth,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ).animateOnActionTrigger(
                                                                animationsMap[
                                                                    'listViewOnActionTriggerAnimation1']!,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 200),
                                                        curve: Curves.easeIn,
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.1,
                                                        height: 100.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    0.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    12.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    0.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    12.0),
                                                          ),
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            _model
                                                                .todayUpfCounter
                                                                ?.toString(),
                                                            '0',
                                                          ),
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
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              },
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
                          Divider(
                            thickness: 2.0,
                            indent: 20.0,
                            endIndent: 20.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.8,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.06,
                                  decoration: BoxDecoration(),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    'Tap for every consumed portion (~200ml) of water during the day. ',
                                    textAlign: TextAlign.center,
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
                                                return 15.0;
                                              } else {
                                                return 16.0;
                                              }
                                            }(),
                                            16.0,
                                          ),
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
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.2,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.1,
                                  child: custom_widgets.TapRippleButton(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.1,
                                    imageUrl: 'assets/images/waterbottle.png',
                                    inDurationMs: 100,
                                    outDurationMs: 1500,
                                    fadeFactor: 1.0,
                                    auraBaseColor: Color(0xFF97D3E1),
                                    onIncrement: (counter) async {
                                      _model.newDayWaterPortionOutput =
                                          await actions
                                              .upsertWeeklySelectedWater(
                                        currentUserUid,
                                        FFAppState().calendarWeek,
                                        FFAppState().calendarYear,
                                        counter!,
                                      );
                                      _model.todayWaterCounter =
                                          _model.newDayWaterPortionOutput;
                                      safeSetState(() {});
                                      _model.addToWaterCounterList(
                                          valueOrDefault<int>(
                                        _model.todayWaterCounter,
                                        0,
                                      ));
                                      safeSetState(() {});

                                      safeSetState(() {});
                                    },
                                  ),
                                ).addWalkthrough(
                                  container0kutp96y,
                                  _model.addonsController,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.8,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.05,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Builder(
                                              builder: (context) {
                                                if ((_model.todayWaterCounter ==
                                                        0) ||
                                                    (_model.todayWaterCounter ==
                                                        null)) {
                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.8,
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
                                                              'no consumption today',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.7,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.05,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    12.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    0.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    12.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    0.0),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      0.0,
                                                                      5.0,
                                                                      0.0),
                                                          child: Builder(
                                                            builder: (context) {
                                                              final waterCounterListDC =
                                                                  _model
                                                                      .waterCounterList
                                                                      .toList();

                                                              return InkWell(
                                                                splashColor: Colors
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
                                                                  _model.decrementWaterPortionOutput =
                                                                      await actions
                                                                          .decrementWeeklySelectedWater(
                                                                    currentUserUid,
                                                                    FFAppState()
                                                                        .calendarWeek,
                                                                    FFAppState()
                                                                        .calendarYear,
                                                                  );
                                                                  _model.removeFromWaterCounterList(
                                                                      _model
                                                                          .todayWaterCounter!);
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.todayWaterCounter =
                                                                      _model
                                                                          .decrementWaterPortionOutput;
                                                                  safeSetState(
                                                                      () {});

                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                                child: ListView
                                                                    .builder(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .fromLTRB(
                                                                    2.0,
                                                                    0,
                                                                    2.0,
                                                                    0,
                                                                  ),
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  itemCount:
                                                                      waterCounterListDC
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          waterCounterListDCIndex) {
                                                                    final waterCounterListDCItem =
                                                                        waterCounterListDC[
                                                                            waterCounterListDCIndex];
                                                                    return Container(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.06,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/waterbottle.png',
                                                                          width:
                                                                              200.0,
                                                                          height:
                                                                              200.0,
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ).animateOnActionTrigger(
                                                                animationsMap[
                                                                    'listViewOnActionTriggerAnimation2']!,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 200),
                                                        curve: Curves.easeIn,
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.1,
                                                        height: 100.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    0.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    12.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    0.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    12.0),
                                                          ),
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            _model
                                                                .todayWaterCounter
                                                                ?.toString(),
                                                            '0',
                                                          ),
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
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              },
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
                          Divider(
                            thickness: 2.0,
                            indent: 20.0,
                            endIndent: 20.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.8,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.03,
                                  decoration: BoxDecoration(),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    'What is your weight today ?',
                                    textAlign: TextAlign.center,
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
                                                return 15.0;
                                              } else {
                                                return 16.0;
                                              }
                                            }(),
                                            16.0,
                                          ),
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
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 15.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  elevation: 1.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.7,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.12,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF4F4F4),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5.0, 5.0, 5.0, 10.0),
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.48,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.1,
                                            child: custom_widgets.WeightPicker(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.48,
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.1,
                                              initialValue:
                                                  valueOrDefault<double>(
                                                _model.weightValueDB,
                                                0.0,
                                              ),
                                              initialUnit:
                                                  valueOrDefault<String>(
                                                _model.weightUnitValueDB,
                                                'kg',
                                              ),
                                              userId: currentUserUid,
                                              calendarWeek:
                                                  FFAppState().calendarWeek,
                                              calendarYear:
                                                  FFAppState().calendarYear,
                                              currentDay:
                                                  FFAppState().currentDay,
                                              onValueChange: (unit, value,
                                                  timestamp) async {
                                                _model.weightListOutput2 =
                                                    await UserVitalsTable()
                                                        .queryRows(
                                                  queryFn: (q) => q
                                                      .eqOrNull(
                                                        'user_id',
                                                        currentUserUid,
                                                      )
                                                      .eqOrNull(
                                                        'vital_type',
                                                        'Weight',
                                                      )
                                                      .eqOrNull(
                                                        'calendaryear',
                                                        FFAppState()
                                                            .calendarYear,
                                                      )
                                                      .order('updated_at'),
                                                );
                                                _model.weightValueDB = value;
                                                _model.weightUnitValueDB = unit;
                                                _model.dateWeightValue =
                                                    timestamp;
                                                safeSetState(() {});

                                                safeSetState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Last measured:',
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
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  valueOrDefault<String>(
                                                    dateTimeFormat("MMMEd",
                                                        _model.dateWeightValue),
                                                    'n/a',
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
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                      ],
                                    ).addWalkthrough(
                                      rowJdufi4nk,
                                      _model.addonsController,
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
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: Container(
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
                              -5.0,
                            ),
                            spreadRadius: 2.0,
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
                                height: 30.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.playlist_add_rounded,
                            color: FlutterFlowTheme.of(context).secondary2,
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
          safeSetState(() => _model.addonsController = null);
        },
        onSkip: () {
          return true;
        },
      );
}
