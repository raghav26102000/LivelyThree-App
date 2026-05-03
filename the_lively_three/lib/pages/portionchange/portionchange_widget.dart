import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'portionchange_model.dart';
export 'portionchange_model.dart';

class PortionchangeWidget extends StatefulWidget {
  const PortionchangeWidget({
    super.key,
    required this.idLoc,
    required this.plantname,
    required this.color,
  });

  final int? idLoc;
  final String? plantname;
  final String? color;

  static String routeName = 'Portionchange';
  static String routePath = '/portionchange';

  @override
  State<PortionchangeWidget> createState() => _PortionchangeWidgetState();
}

class _PortionchangeWidgetState extends State<PortionchangeWidget> {
  late PortionchangeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PortionchangeModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          if (FFAppState().currentDay == 'Monday') {
            _model.isMonday = true;
            safeSetState(() {});
          }
        }),
        Future(() async {
          if (FFAppState().currentDay == 'Tuesday') {
            _model.isMonday = true;
            _model.isTuesday = true;
            safeSetState(() {});
          }
        }),
        Future(() async {
          if (FFAppState().currentDay == 'Wednesday') {
            _model.isMonday = true;
            _model.isTuesday = true;
            _model.isWednesday = true;
            safeSetState(() {});
          }
        }),
        Future(() async {
          if (FFAppState().currentDay == 'Thursday') {
            _model.isMonday = true;
            _model.isTuesday = true;
            _model.isWednesday = true;
            _model.isThursday = true;
            safeSetState(() {});
          }
        }),
        Future(() async {
          if (FFAppState().currentDay == 'Friday') {
            _model.isMonday = true;
            _model.isTuesday = true;
            _model.isWednesday = true;
            _model.isThursday = true;
            _model.isFriday = true;
            safeSetState(() {});
          }
        }),
        Future(() async {
          if (FFAppState().currentDay == 'Saturday') {
            _model.isMonday = true;
            _model.isTuesday = true;
            _model.isWednesday = true;
            _model.isThursday = true;
            _model.isFriday = true;
            _model.isSaturday = true;
            safeSetState(() {});
          }
        }),
        Future(() async {
          if (FFAppState().currentDay == 'Sunday') {
            _model.isMonday = true;
            _model.isTuesday = true;
            _model.isWednesday = true;
            _model.isThursday = true;
            _model.isFriday = true;
            _model.isSaturday = true;
            _model.isSunday = true;
            safeSetState(() {});
          }
        }),
      ]);
      _model.weeklyPortions = await ViewWeeklyselectedplantTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'id_loc',
              widget!.idLoc,
            )
            .eqOrNull(
              'calendaryear',
              FFAppState().calendarYear,
            )
            .eqOrNull(
              'calendarweek',
              FFAppState().calendarWeek,
            )
            .eqOrNull(
              'id_user',
              currentUserUid,
            ),
      );
      await Future.wait([
        Future(() async {
          _model.mondayPortion = valueOrDefault<double>(
            _model.weeklyPortions?.firstOrNull?.monportion,
            0.0,
          );
          safeSetState(() {});
        }),
        Future(() async {
          _model.tuesdayPortion = valueOrDefault<double>(
            _model.weeklyPortions?.firstOrNull?.tueportion,
            0.0,
          );
          safeSetState(() {});
        }),
        Future(() async {
          _model.wednesdayPortion = valueOrDefault<double>(
            _model.weeklyPortions?.firstOrNull?.wedportion,
            0.0,
          );
          safeSetState(() {});
        }),
        Future(() async {
          _model.thursdayPortion = valueOrDefault<double>(
            _model.weeklyPortions?.firstOrNull?.thuportion,
            0.0,
          );
          safeSetState(() {});
        }),
        Future(() async {
          _model.fridayPortion = valueOrDefault<double>(
            _model.weeklyPortions?.firstOrNull?.friportion,
            0.0,
          );
          safeSetState(() {});
        }),
        Future(() async {
          _model.saturdayPortion = valueOrDefault<double>(
            _model.weeklyPortions?.firstOrNull?.satportion,
            0.0,
          );
          safeSetState(() {});
        }),
        Future(() async {
          _model.sundayPortion = valueOrDefault<double>(
            _model.weeklyPortions?.firstOrNull?.sunportion,
            0.0,
          );
          safeSetState(() {});
        }),
        Future(() async {
          _model.portionSize = valueOrDefault<double>(
            _model.weeklyPortions?.elementAtOrNull(0)?.portionsize,
            0.0,
          );
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
                              context.pushNamed(
                                PlantselectionWidget.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType:
                                        PageTransitionType.leftToRight,
                                  ),
                                },
                              );
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
                            'Weekly plants',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  font: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600,
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
                                  fontWeight: FontWeight.w600,
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
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        AnimatedDefaultTextStyle(
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: () {
                                                  if (widget!.color == 'Red') {
                                                    return Color(0xFFE53A3A);
                                                  } else if (widget!.color ==
                                                      'Orange') {
                                                    return Color(0xFFA3650C);
                                                  } else if (widget!.color ==
                                                      'Yellow') {
                                                    return Color(0xFF9A8B0F);
                                                  } else if (widget!.color ==
                                                      'Green') {
                                                    return Color(0xFF45EA2B);
                                                  } else if (widget!.color ==
                                                      'Purple') {
                                                    return Color(0xFF5A117A);
                                                  } else if (widget!.color ==
                                                      'Brown') {
                                                    return Color(0xFF60370E);
                                                  } else {
                                                    return Color(0xFF72777C);
                                                  }
                                                }(),
                                                fontSize:
                                                    valueOrDefault<double>(
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
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          duration: Duration(milliseconds: 600),
                                          curve: Curves.easeIn,
                                          child: Text(
                                            valueOrDefault<String>(
                                              widget!.plantname,
                                              'n/a',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  3.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            '(${valueOrDefault<String>(
                                              formatNumber(
                                                valueOrDefault<double>(
                                                      _model.portionSize,
                                                      0.0,
                                                    ) *
                                                    100,
                                                formatType: FormatType.custom,
                                                format: '#',
                                                locale: '',
                                              ),
                                              '0',
                                            )}g / portion)',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  fontSize:
                                                      valueOrDefault<double>(
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
                                                  letterSpacing: 0.0,
                                                  fontStyle: FontStyle.italic,
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
                                    'Change portions for the week. ',
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
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.8,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.08,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5.0,
                                        color: () {
                                          if (widget!.color == 'Red') {
                                            return Color(0xFFFB7878);
                                          } else if (widget!.color ==
                                              'Orange') {
                                            return Color(0xFFFBCD66);
                                          } else if (widget!.color ==
                                              'Yellow') {
                                            return Color(0xFFF8F26E);
                                          } else if (widget!.color == 'Green') {
                                            return Color(0xFF96FB80);
                                          } else if (widget!.color ==
                                              'Purple') {
                                            return Color(0xFFD680FF);
                                          } else if (widget!.color == 'Brown') {
                                            return Color(0xFFB08F58);
                                          } else {
                                            return Color(0xFFA1A1A1);
                                          }
                                        }(),
                                        offset: Offset(
                                          1.0,
                                          1.0,
                                        ),
                                        spreadRadius: 5.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Monday: ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                fontSize:
                                                    valueOrDefault<double>(
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
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.35,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(0.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              topLeft: Radius.circular(0.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              FlutterFlowIconButton(
                                                borderRadius: 20.0,
                                                borderWidth: 1.0,
                                                buttonSize: 40.0,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                icon: Icon(
                                                  Icons.arrow_drop_down,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 25.0,
                                                ),
                                                onPressed: () async {
                                                  if (_model.mondayPortion! >=
                                                      1.0) {
                                                    _model.mondayPortion =
                                                        _model.mondayPortion! +
                                                            -1.0;
                                                    safeSetState(() {});
                                                    await WeeklyselectedplantTable()
                                                        .update(
                                                      data: {
                                                        'monportion': _model
                                                            .mondayPortion,
                                                        'portionsum': (_model
                                                                .mondayPortion!) +
                                                            (_model
                                                                .tuesdayPortion!) +
                                                            (_model
                                                                .wednesdayPortion!) +
                                                            (_model
                                                                .thursdayPortion!) +
                                                            (_model
                                                                .fridayPortion!) +
                                                            (_model
                                                                .saturdayPortion!) +
                                                            (_model
                                                                .sundayPortion!),
                                                      },
                                                      matchingRows: (rows) =>
                                                          rows
                                                              .eqOrNull(
                                                                'id_loc',
                                                                widget!.idLoc,
                                                              )
                                                              .eqOrNull(
                                                                'id_user',
                                                                currentUserUid,
                                                              ),
                                                    );
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Number of portions'),
                                                          content: Text(
                                                              'Portion number cannot be less than 0. '),
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
                                                },
                                              ),
                                              Text(
                                                valueOrDefault<String>(
                                                  formatNumber(
                                                    _model.mondayPortion,
                                                    formatType:
                                                        FormatType.custom,
                                                    format: '#',
                                                    locale: '',
                                                  ),
                                                  '0',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      fontSize: valueOrDefault<
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
                                                              .bodyMediumIsCustom,
                                                    ),
                                              ),
                                              FlutterFlowIconButton(
                                                borderRadius: 20.0,
                                                borderWidth: 1.0,
                                                buttonSize: 40.0,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                icon: Icon(
                                                  Icons.arrow_drop_up,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 25.0,
                                                ),
                                                onPressed: () async {
                                                  _model.mondayPortion =
                                                      _model.mondayPortion! +
                                                          1.0;
                                                  safeSetState(() {});
                                                  await WeeklyselectedplantTable()
                                                      .update(
                                                    data: {
                                                      'monportion':
                                                          _model.mondayPortion,
                                                      'portionsum': (_model
                                                              .mondayPortion!) +
                                                          (_model
                                                              .tuesdayPortion!) +
                                                          (_model
                                                              .wednesdayPortion!) +
                                                          (_model
                                                              .thursdayPortion!) +
                                                          (_model
                                                              .fridayPortion!) +
                                                          (_model
                                                              .saturdayPortion!) +
                                                          (_model
                                                              .sundayPortion!),
                                                    },
                                                    matchingRows: (rows) => rows
                                                        .eqOrNull(
                                                          'id_loc',
                                                          widget!.idLoc,
                                                        )
                                                        .eqOrNull(
                                                          'id_user',
                                                          currentUserUid,
                                                        ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_model.isMonday == false)
                                  Opacity(
                                    opacity: 0.5,
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.8,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.08,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.08,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5.0,
                                          color: () {
                                            if (widget!.color == 'Red') {
                                              return Color(0xFFFB7878);
                                            } else if (widget!.color ==
                                                'Orange') {
                                              return Color(0xFFFBCD66);
                                            } else if (widget!.color ==
                                                'Yellow') {
                                              return Color(0xFFF8F26E);
                                            } else if (widget!.color ==
                                                'Green') {
                                              return Color(0xFF96FB80);
                                            } else if (widget!.color ==
                                                'Purple') {
                                              return Color(0xFFD680FF);
                                            } else if (widget!.color ==
                                                'Brown') {
                                              return Color(0xFFB08F58);
                                            } else {
                                              return Color(0xFFA1A1A1);
                                            }
                                          }(),
                                          offset: Offset(
                                            1.0,
                                            1.0,
                                          ),
                                          spreadRadius: 5.0,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Tuesday: ',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  fontSize:
                                                      valueOrDefault<double>(
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
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.35,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topLeft: Radius.circular(0.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25.0,
                                                  ),
                                                  onPressed: () async {
                                                    if (_model
                                                            .tuesdayPortion! >=
                                                        1.0) {
                                                      _model.tuesdayPortion =
                                                          _model.tuesdayPortion! +
                                                              -1.0;
                                                      safeSetState(() {});
                                                      await WeeklyselectedplantTable()
                                                          .update(
                                                        data: {
                                                          'portionsum': (_model
                                                                  .mondayPortion!) +
                                                              (_model
                                                                  .tuesdayPortion!) +
                                                              (_model
                                                                  .wednesdayPortion!) +
                                                              (_model
                                                                  .thursdayPortion!) +
                                                              (_model
                                                                  .fridayPortion!) +
                                                              (_model
                                                                  .saturdayPortion!) +
                                                              (_model
                                                                  .sundayPortion!),
                                                          'tueportion': _model
                                                              .tuesdayPortion,
                                                        },
                                                        matchingRows: (rows) =>
                                                            rows
                                                                .eqOrNull(
                                                                  'id_loc',
                                                                  widget!.idLoc,
                                                                )
                                                                .eqOrNull(
                                                                  'id_user',
                                                                  currentUserUid,
                                                                ),
                                                      );
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Number of portions'),
                                                            content: Text(
                                                                'Portion number cannot be less than 0. '),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    formatNumber(
                                                      _model.tuesdayPortion,
                                                      formatType:
                                                          FormatType.custom,
                                                      format: '#',
                                                      locale: '',
                                                    ),
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
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  icon: Icon(
                                                    Icons.arrow_drop_up,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25.0,
                                                  ),
                                                  onPressed: () async {
                                                    _model.tuesdayPortion =
                                                        _model.tuesdayPortion! +
                                                            1.0;
                                                    safeSetState(() {});
                                                    await WeeklyselectedplantTable()
                                                        .update(
                                                      data: {
                                                        'portionsum': (_model
                                                                .mondayPortion!) +
                                                            (_model
                                                                .tuesdayPortion!) +
                                                            (_model
                                                                .wednesdayPortion!) +
                                                            (_model
                                                                .thursdayPortion!) +
                                                            (_model
                                                                .fridayPortion!) +
                                                            (_model
                                                                .saturdayPortion!) +
                                                            (_model
                                                                .sundayPortion!),
                                                        'tueportion': _model
                                                            .tuesdayPortion,
                                                      },
                                                      matchingRows: (rows) =>
                                                          rows
                                                              .eqOrNull(
                                                                'id_loc',
                                                                widget!.idLoc,
                                                              )
                                                              .eqOrNull(
                                                                'id_user',
                                                                currentUserUid,
                                                              ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_model.isTuesday == false)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 2.0,
                                        sigmaY: 2.0,
                                      ),
                                      child: Visibility(
                                        visible: _model.isTuesday == false,
                                        child: Opacity(
                                          opacity: 0.5,
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.8,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.08,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.08,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5.0,
                                          color: () {
                                            if (widget!.color == 'Red') {
                                              return Color(0xFFFB7878);
                                            } else if (widget!.color ==
                                                'Orange') {
                                              return Color(0xFFFBCD66);
                                            } else if (widget!.color ==
                                                'Yellow') {
                                              return Color(0xFFF8F26E);
                                            } else if (widget!.color ==
                                                'Green') {
                                              return Color(0xFF96FB80);
                                            } else if (widget!.color ==
                                                'Purple') {
                                              return Color(0xFFD680FF);
                                            } else if (widget!.color ==
                                                'Brown') {
                                              return Color(0xFFB08F58);
                                            } else {
                                              return Color(0xFFA1A1A1);
                                            }
                                          }(),
                                          offset: Offset(
                                            1.0,
                                            1.0,
                                          ),
                                          spreadRadius: 5.0,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Wednesday: ',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  fontSize:
                                                      valueOrDefault<double>(
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
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.35,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topLeft: Radius.circular(0.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25.0,
                                                  ),
                                                  onPressed: () async {
                                                    if (_model
                                                            .wednesdayPortion! >=
                                                        1.0) {
                                                      _model.wednesdayPortion =
                                                          _model.wednesdayPortion! +
                                                              -1.0;
                                                      safeSetState(() {});
                                                      await WeeklyselectedplantTable()
                                                          .update(
                                                        data: {
                                                          'wedportion': _model
                                                              .wednesdayPortion,
                                                          'portionsum': (_model
                                                                  .mondayPortion!) +
                                                              (_model
                                                                  .tuesdayPortion!) +
                                                              (_model
                                                                  .wednesdayPortion!) +
                                                              (_model
                                                                  .thursdayPortion!) +
                                                              (_model
                                                                  .fridayPortion!) +
                                                              (_model
                                                                  .saturdayPortion!) +
                                                              (_model
                                                                  .sundayPortion!),
                                                        },
                                                        matchingRows: (rows) =>
                                                            rows
                                                                .eqOrNull(
                                                                  'id_loc',
                                                                  widget!.idLoc,
                                                                )
                                                                .eqOrNull(
                                                                  'id_user',
                                                                  currentUserUid,
                                                                ),
                                                      );
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Number of portions'),
                                                            content: Text(
                                                                'Portion number cannot be less than 0. '),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    formatNumber(
                                                      _model.wednesdayPortion,
                                                      formatType:
                                                          FormatType.custom,
                                                      format: '#',
                                                      locale: '',
                                                    ),
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
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  icon: Icon(
                                                    Icons.arrow_drop_up,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25.0,
                                                  ),
                                                  onPressed: () async {
                                                    _model.wednesdayPortion =
                                                        _model.wednesdayPortion! +
                                                            1.0;
                                                    safeSetState(() {});
                                                    await WeeklyselectedplantTable()
                                                        .update(
                                                      data: {
                                                        'wedportion': _model
                                                            .wednesdayPortion,
                                                        'portionsum': (_model
                                                                .mondayPortion!) +
                                                            (_model
                                                                .tuesdayPortion!) +
                                                            (_model
                                                                .wednesdayPortion!) +
                                                            (_model
                                                                .thursdayPortion!) +
                                                            (_model
                                                                .fridayPortion!) +
                                                            (_model
                                                                .saturdayPortion!) +
                                                            (_model
                                                                .sundayPortion!),
                                                      },
                                                      matchingRows: (rows) =>
                                                          rows
                                                              .eqOrNull(
                                                                'id_loc',
                                                                widget!.idLoc,
                                                              )
                                                              .eqOrNull(
                                                                'id_user',
                                                                currentUserUid,
                                                              ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_model.isWednesday == false)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 2.0,
                                        sigmaY: 2.0,
                                      ),
                                      child: Visibility(
                                        visible: _model.isWednesday == false,
                                        child: Opacity(
                                          opacity: 0.5,
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.8,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.08,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.08,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5.0,
                                          color: () {
                                            if (widget!.color == 'Red') {
                                              return Color(0xFFFB7878);
                                            } else if (widget!.color ==
                                                'Orange') {
                                              return Color(0xFFFBCD66);
                                            } else if (widget!.color ==
                                                'Yellow') {
                                              return Color(0xFFF8F26E);
                                            } else if (widget!.color ==
                                                'Green') {
                                              return Color(0xFF96FB80);
                                            } else if (widget!.color ==
                                                'Purple') {
                                              return Color(0xFFD680FF);
                                            } else if (widget!.color ==
                                                'Brown') {
                                              return Color(0xFFB08F58);
                                            } else {
                                              return Color(0xFFA1A1A1);
                                            }
                                          }(),
                                          offset: Offset(
                                            1.0,
                                            1.0,
                                          ),
                                          spreadRadius: 5.0,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Thursday: ',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  fontSize:
                                                      valueOrDefault<double>(
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
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.35,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topLeft: Radius.circular(0.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25.0,
                                                  ),
                                                  onPressed: () async {
                                                    if (_model
                                                            .thursdayPortion! >=
                                                        1.0) {
                                                      _model.thursdayPortion =
                                                          _model.thursdayPortion! +
                                                              -1.0;
                                                      safeSetState(() {});
                                                      await WeeklyselectedplantTable()
                                                          .update(
                                                        data: {
                                                          'thuportion': _model
                                                              .thursdayPortion,
                                                          'portionsum': (_model
                                                                  .mondayPortion!) +
                                                              (_model
                                                                  .tuesdayPortion!) +
                                                              (_model
                                                                  .wednesdayPortion!) +
                                                              (_model
                                                                  .thursdayPortion!) +
                                                              (_model
                                                                  .fridayPortion!) +
                                                              (_model
                                                                  .saturdayPortion!) +
                                                              (_model
                                                                  .sundayPortion!),
                                                        },
                                                        matchingRows: (rows) =>
                                                            rows
                                                                .eqOrNull(
                                                                  'id_loc',
                                                                  widget!.idLoc,
                                                                )
                                                                .eqOrNull(
                                                                  'id_user',
                                                                  currentUserUid,
                                                                ),
                                                      );
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Number of portions'),
                                                            content: Text(
                                                                'Portion number cannot be less than 0. '),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    formatNumber(
                                                      _model.thursdayPortion,
                                                      formatType:
                                                          FormatType.custom,
                                                      format: '#',
                                                      locale: '',
                                                    ),
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
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  icon: Icon(
                                                    Icons.arrow_drop_up,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25.0,
                                                  ),
                                                  onPressed: () async {
                                                    _model.thursdayPortion =
                                                        _model.thursdayPortion! +
                                                            1.0;
                                                    safeSetState(() {});
                                                    await WeeklyselectedplantTable()
                                                        .update(
                                                      data: {
                                                        'thuportion': _model
                                                            .thursdayPortion,
                                                        'portionsum': (_model
                                                                .mondayPortion!) +
                                                            (_model
                                                                .tuesdayPortion!) +
                                                            (_model
                                                                .wednesdayPortion!) +
                                                            (_model
                                                                .thursdayPortion!) +
                                                            (_model
                                                                .fridayPortion!) +
                                                            (_model
                                                                .saturdayPortion!) +
                                                            (_model
                                                                .sundayPortion!),
                                                      },
                                                      matchingRows: (rows) =>
                                                          rows
                                                              .eqOrNull(
                                                                'id_loc',
                                                                widget!.idLoc,
                                                              )
                                                              .eqOrNull(
                                                                'id_user',
                                                                currentUserUid,
                                                              ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_model.isThursday == false)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 2.0,
                                        sigmaY: 2.0,
                                      ),
                                      child: Visibility(
                                        visible: _model.isThursday == false,
                                        child: Opacity(
                                          opacity: 0.5,
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.8,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.08,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.08,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5.0,
                                          color: () {
                                            if (widget!.color == 'Red') {
                                              return Color(0xFFFB7878);
                                            } else if (widget!.color ==
                                                'Orange') {
                                              return Color(0xFFFBCD66);
                                            } else if (widget!.color ==
                                                'Yellow') {
                                              return Color(0xFFF8F26E);
                                            } else if (widget!.color ==
                                                'Green') {
                                              return Color(0xFF96FB80);
                                            } else if (widget!.color ==
                                                'Purple') {
                                              return Color(0xFFD680FF);
                                            } else if (widget!.color ==
                                                'Brown') {
                                              return Color(0xFFB08F58);
                                            } else {
                                              return Color(0xFFA1A1A1);
                                            }
                                          }(),
                                          offset: Offset(
                                            1.0,
                                            1.0,
                                          ),
                                          spreadRadius: 5.0,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Friday: ',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  fontSize:
                                                      valueOrDefault<double>(
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
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.35,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topLeft: Radius.circular(0.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25.0,
                                                  ),
                                                  onPressed: () async {
                                                    if (_model.fridayPortion! >=
                                                        1.0) {
                                                      _model.fridayPortion =
                                                          _model.fridayPortion! +
                                                              -1.0;
                                                      safeSetState(() {});
                                                      await WeeklyselectedplantTable()
                                                          .update(
                                                        data: {
                                                          'friportion': _model
                                                              .fridayPortion,
                                                          'portionsum': (_model
                                                                  .mondayPortion!) +
                                                              (_model
                                                                  .tuesdayPortion!) +
                                                              (_model
                                                                  .wednesdayPortion!) +
                                                              (_model
                                                                  .thursdayPortion!) +
                                                              (_model
                                                                  .fridayPortion!) +
                                                              (_model
                                                                  .saturdayPortion!) +
                                                              (_model
                                                                  .sundayPortion!),
                                                        },
                                                        matchingRows: (rows) =>
                                                            rows
                                                                .eqOrNull(
                                                                  'id_loc',
                                                                  widget!.idLoc,
                                                                )
                                                                .eqOrNull(
                                                                  'id_user',
                                                                  currentUserUid,
                                                                ),
                                                      );
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Number of portions'),
                                                            content: Text(
                                                                'Portion number cannot be less than 0. '),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    formatNumber(
                                                      _model.fridayPortion,
                                                      formatType:
                                                          FormatType.custom,
                                                      format: '#',
                                                      locale: '',
                                                    ),
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
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  icon: Icon(
                                                    Icons.arrow_drop_up,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25.0,
                                                  ),
                                                  onPressed: () async {
                                                    _model.fridayPortion =
                                                        _model.fridayPortion! +
                                                            1.0;
                                                    safeSetState(() {});
                                                    await WeeklyselectedplantTable()
                                                        .update(
                                                      data: {
                                                        'friportion': _model
                                                            .fridayPortion,
                                                        'portionsum': (_model
                                                                .mondayPortion!) +
                                                            (_model
                                                                .tuesdayPortion!) +
                                                            (_model
                                                                .wednesdayPortion!) +
                                                            (_model
                                                                .thursdayPortion!) +
                                                            (_model
                                                                .fridayPortion!) +
                                                            (_model
                                                                .saturdayPortion!) +
                                                            (_model
                                                                .sundayPortion!),
                                                      },
                                                      matchingRows: (rows) =>
                                                          rows
                                                              .eqOrNull(
                                                                'id_loc',
                                                                widget!.idLoc,
                                                              )
                                                              .eqOrNull(
                                                                'id_user',
                                                                currentUserUid,
                                                              ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_model.isFriday == false)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 2.0,
                                        sigmaY: 2.0,
                                      ),
                                      child: Visibility(
                                        visible: _model.isFriday == false,
                                        child: Opacity(
                                          opacity: 0.5,
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.8,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.08,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.08,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5.0,
                                          color: () {
                                            if (widget!.color == 'Red') {
                                              return Color(0xFFFB7878);
                                            } else if (widget!.color ==
                                                'Orange') {
                                              return Color(0xFFFBCD66);
                                            } else if (widget!.color ==
                                                'Yellow') {
                                              return Color(0xFFF8F26E);
                                            } else if (widget!.color ==
                                                'Green') {
                                              return Color(0xFF96FB80);
                                            } else if (widget!.color ==
                                                'Purple') {
                                              return Color(0xFFD680FF);
                                            } else if (widget!.color ==
                                                'Brown') {
                                              return Color(0xFFB08F58);
                                            } else {
                                              return Color(0xFFA1A1A1);
                                            }
                                          }(),
                                          offset: Offset(
                                            1.0,
                                            1.0,
                                          ),
                                          spreadRadius: 5.0,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Saturday: ',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  fontSize:
                                                      valueOrDefault<double>(
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
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.35,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topLeft: Radius.circular(0.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25.0,
                                                  ),
                                                  onPressed: () async {
                                                    if (_model
                                                            .saturdayPortion! >=
                                                        1.0) {
                                                      _model.saturdayPortion =
                                                          _model.saturdayPortion! +
                                                              -1.0;
                                                      safeSetState(() {});
                                                      await WeeklyselectedplantTable()
                                                          .update(
                                                        data: {
                                                          'satportion': _model
                                                              .saturdayPortion,
                                                          'portionsum': (_model
                                                                  .mondayPortion!) +
                                                              (_model
                                                                  .tuesdayPortion!) +
                                                              (_model
                                                                  .wednesdayPortion!) +
                                                              (_model
                                                                  .thursdayPortion!) +
                                                              (_model
                                                                  .fridayPortion!) +
                                                              (_model
                                                                  .saturdayPortion!) +
                                                              (_model
                                                                  .sundayPortion!),
                                                        },
                                                        matchingRows: (rows) =>
                                                            rows
                                                                .eqOrNull(
                                                                  'id_loc',
                                                                  widget!.idLoc,
                                                                )
                                                                .eqOrNull(
                                                                  'id_user',
                                                                  currentUserUid,
                                                                ),
                                                      );
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Number of portions'),
                                                            content: Text(
                                                                'Portion number cannot be less than 0. '),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    formatNumber(
                                                      _model.saturdayPortion,
                                                      formatType:
                                                          FormatType.custom,
                                                      format: '#',
                                                      locale: '',
                                                    ),
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
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  icon: Icon(
                                                    Icons.arrow_drop_up,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25.0,
                                                  ),
                                                  onPressed: () async {
                                                    _model.saturdayPortion =
                                                        _model.saturdayPortion! +
                                                            1.0;
                                                    safeSetState(() {});
                                                    await WeeklyselectedplantTable()
                                                        .update(
                                                      data: {
                                                        'satportion': _model
                                                            .saturdayPortion,
                                                        'portionsum': (_model
                                                                .mondayPortion!) +
                                                            (_model
                                                                .tuesdayPortion!) +
                                                            (_model
                                                                .wednesdayPortion!) +
                                                            (_model
                                                                .thursdayPortion!) +
                                                            (_model
                                                                .fridayPortion!) +
                                                            (_model
                                                                .saturdayPortion!) +
                                                            (_model
                                                                .sundayPortion!),
                                                      },
                                                      matchingRows: (rows) =>
                                                          rows
                                                              .eqOrNull(
                                                                'id_loc',
                                                                widget!.idLoc,
                                                              )
                                                              .eqOrNull(
                                                                'id_user',
                                                                currentUserUid,
                                                              ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_model.isSaturday == false)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 2.0,
                                        sigmaY: 2.0,
                                      ),
                                      child: Visibility(
                                        visible: _model.isSaturday == false,
                                        child: Opacity(
                                          opacity: 0.5,
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.8,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.08,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.08,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5.0,
                                          color: () {
                                            if (widget!.color == 'Red') {
                                              return Color(0xFFFB7878);
                                            } else if (widget!.color ==
                                                'Orange') {
                                              return Color(0xFFFBCD66);
                                            } else if (widget!.color ==
                                                'Yellow') {
                                              return Color(0xFFF8F26E);
                                            } else if (widget!.color ==
                                                'Green') {
                                              return Color(0xFF96FB80);
                                            } else if (widget!.color ==
                                                'Purple') {
                                              return Color(0xFFD680FF);
                                            } else if (widget!.color ==
                                                'Brown') {
                                              return Color(0xFFB08F58);
                                            } else {
                                              return Color(0xFFA1A1A1);
                                            }
                                          }(),
                                          offset: Offset(
                                            1.0,
                                            1.0,
                                          ),
                                          spreadRadius: 5.0,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Sunday: ',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  fontSize:
                                                      valueOrDefault<double>(
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
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.35,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topLeft: Radius.circular(0.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25.0,
                                                  ),
                                                  onPressed: () async {
                                                    if (_model.sundayPortion! >=
                                                        1.0) {
                                                      _model.sundayPortion =
                                                          _model.sundayPortion! +
                                                              -1.0;
                                                      safeSetState(() {});
                                                      await WeeklyselectedplantTable()
                                                          .update(
                                                        data: {
                                                          'sunportion': _model
                                                              .sundayPortion,
                                                          'portionsum': (_model
                                                                  .mondayPortion!) +
                                                              (_model
                                                                  .tuesdayPortion!) +
                                                              (_model
                                                                  .wednesdayPortion!) +
                                                              (_model
                                                                  .thursdayPortion!) +
                                                              (_model
                                                                  .fridayPortion!) +
                                                              (_model
                                                                  .saturdayPortion!) +
                                                              (_model
                                                                  .sundayPortion!),
                                                        },
                                                        matchingRows: (rows) =>
                                                            rows
                                                                .eqOrNull(
                                                                  'id_loc',
                                                                  widget!.idLoc,
                                                                )
                                                                .eqOrNull(
                                                                  'id_user',
                                                                  currentUserUid,
                                                                ),
                                                      );
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Number of portions'),
                                                            content: Text(
                                                                'Portion number cannot be less than 0. '),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    formatNumber(
                                                      _model.sundayPortion,
                                                      formatType:
                                                          FormatType.custom,
                                                      format: '#',
                                                      locale: '',
                                                    ),
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
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                                FlutterFlowIconButton(
                                                  borderRadius: 20.0,
                                                  borderWidth: 1.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  icon: Icon(
                                                    Icons.arrow_drop_up,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 25.0,
                                                  ),
                                                  onPressed: () async {
                                                    _model.sundayPortion =
                                                        _model.sundayPortion! +
                                                            1.0;
                                                    safeSetState(() {});
                                                    await WeeklyselectedplantTable()
                                                        .update(
                                                      data: {
                                                        'sunportion': _model
                                                            .sundayPortion,
                                                        'portionsum': (_model
                                                                .mondayPortion!) +
                                                            (_model
                                                                .tuesdayPortion!) +
                                                            (_model
                                                                .wednesdayPortion!) +
                                                            (_model
                                                                .thursdayPortion!) +
                                                            (_model
                                                                .fridayPortion!) +
                                                            (_model
                                                                .saturdayPortion!) +
                                                            (_model
                                                                .sundayPortion!),
                                                      },
                                                      matchingRows: (rows) =>
                                                          rows
                                                              .eqOrNull(
                                                                'id_loc',
                                                                widget!.idLoc,
                                                              )
                                                              .eqOrNull(
                                                                'id_user',
                                                                currentUserUid,
                                                              ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_model.isSunday == false)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 2.0,
                                        sigmaY: 2.0,
                                      ),
                                      child: Visibility(
                                        visible: _model.isSunday == false,
                                        child: Opacity(
                                          opacity: 0.5,
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.8,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.08,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
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
                                'assets/images/Plant_Blue.png',
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
}
