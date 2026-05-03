import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/bottom_sheet_email_change/bottom_sheet_email_change_widget.dart';
import '/components/data_contract_entry/data_contract_entry_widget.dart';
import '/components/infobox_generaloptin/infobox_generaloptin_widget.dart';
import '/components/settings_choice_chip/settings_choice_chip_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/walkthroughs/settings_plants.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_model.dart';
export 'settings_model.dart';
import '/main.dart';


class SettingsWidget extends StatefulWidget {
  const SettingsWidget({
    super.key,
    int? settingsTabObjective,
  }) : this.settingsTabObjective = settingsTabObjective ?? 2;

  final int settingsTabObjective;

  static String routeName = 'Settings';
  static String routePath = '/settings';

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget>
    with TickerProviderStateMixin {
  late SettingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          if ((FFAppState().countryList.isNotEmpty) != true) {
            _model.actionoutputCountrylist = await UserregionTable().queryRows(
              queryFn: (q) => q.order('country', ascending: true),
            );
            await Future.wait([
              Future(() async {
                FFAppState().idx = 0;
              }),
              Future(() async {
                _model.countryMax = _model.actionoutputCountrylist?.length;
                safeSetState(() {});
              }),
            ]);
            while (FFAppState().idx < _model.countryMax!) {
              FFAppState().addToCountryList(CountryListDataTypeStruct(
                id: FFAppState().idx,
                label: _model.actionoutputCountrylist
                    ?.elementAtOrNull(FFAppState().idx)
                    ?.country,
              ));
              safeSetState(() {});
              FFAppState().idx = FFAppState().idx + 1;
              safeSetState(() {});
            }
          }
        }),
        Future(() async {
          // Needed for calculating how many plants are selected per color and in total to show it in the UI
          _model.weeklySelectedPlantsOutput =
              await WeeklyselectedplantTable().queryRows(
            queryFn: (q) => q
                .eqOrNull(
                  'week',
                  FFAppState().calendarWeek,
                )
                .eqOrNull(
                  'id_user',
                  currentUserUid,
                )
                .eqOrNull(
                  'year',
                  FFAppState().calendarYear,
                ),
          );
          FFAppState().brownWeeklySelectedPlants = valueOrDefault<int>(
            _model.weeklySelectedPlantsOutput
                ?.where((e) => e.color == 'Brown')
                .toList()
                ?.length,
            0,
          );
          FFAppState().redWeeklySelectedPlants = valueOrDefault<int>(
            _model.weeklySelectedPlantsOutput
                ?.where((e) => e.color == 'Red')
                .toList()
                ?.length,
            0,
          );
          FFAppState().orangeWeeklySelectedPlants = valueOrDefault<int>(
            _model.weeklySelectedPlantsOutput
                ?.where((e) => e.color == 'Orange')
                .toList()
                ?.length,
            0,
          );
          FFAppState().yellowWeeklySelectedPlants = valueOrDefault<int>(
            _model.weeklySelectedPlantsOutput
                ?.where((e) => e.color == 'Yellow')
                .toList()
                ?.length,
            0,
          );
          FFAppState().greenWeeklySelectedPlants = valueOrDefault<int>(
            _model.weeklySelectedPlantsOutput
                ?.where((e) => e.color == 'Green')
                .toList()
                ?.length,
            0,
          );
          FFAppState().purpleWeeklySelectedPlants = valueOrDefault<int>(
            _model.weeklySelectedPlantsOutput
                ?.where((e) => e.color == 'Purple')
                .toList()
                ?.length,
            0,
          );
          FFAppState().whiteWeeklySelectedPlants = valueOrDefault<int>(
            _model.weeklySelectedPlantsOutput
                ?.where((e) => e.color == 'White')
                .toList()
                ?.length,
            0,
          );
          FFAppState().totalWeeklySelectedPlants = valueOrDefault<int>(
            _model.weeklySelectedPlantsOutput?.length,
            0,
          );
          safeSetState(() {});
        }),
        Future(() async {
          await actions.fetchPlantDetailsWithSelection(
            FFAppState().calendarWeek,
            currentUserUid,
            FFAppState().calendarYear,
            valueOrDefault<String>(
              FFAppState().onboardPreset,
              'three_ncnfnp_long',
            ),
          );
        }),
      ]);
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 6,
      initialIndex: min(
          valueOrDefault<int>(
            widget!.settingsTabObjective,
            0,
          ),
          5),
    )..addListener(() => safeSetState(() {}));

    _model.emailTextController ??=
        TextEditingController(text: currentUserEmail);
    _model.emailFocusNode ??= FocusNode();

    _model.firstnameFocusNode ??= FocusNode();

    _model.lastnameFocusNode ??= FocusNode();

    _model.heightFocusNode ??= FocusNode();

    _model.regionFocusNode ??= FocusNode();

    _model.phoneFocusNode ??= FocusNode();

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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
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
                              3.0,
                            ),
                            spreadRadius: 1.0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
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
                                color:
                                    FlutterFlowTheme.of(context).tertiaryText,
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
                              'Settings',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    font: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .tertiaryText,
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
                            ),
                          ],
                        ).addWalkthrough(
                          rowN3x8ph1o,
                          _model.settingsPlantsController,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      decoration: BoxDecoration(),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment(0.0, 0),
                            child: TabBar(
                              labelColor:
                                  FlutterFlowTheme.of(context).secondary2,
                              unselectedLabelColor:
                                  FlutterFlowTheme.of(context).tertiaryText,
                              labelPadding: EdgeInsets.all(2.0),
                              labelStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleMediumFamily,
                                    fontSize: valueOrDefault<double>(
                                      () {
                                        if (FFAppState().screenCategory ==
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
                                      11.0,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleMediumIsCustom,
                                  ),
                              unselectedLabelStyle: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelSmallFamily,
                                    fontSize: valueOrDefault<double>(
                                      () {
                                        if (FFAppState().screenCategory ==
                                            'small') {
                                          return 11.0;
                                        } else if (FFAppState()
                                                .screenCategory ==
                                            'medium') {
                                          return 13.0;
                                        } else {
                                          return 15.0;
                                        }
                                      }(),
                                      15.0,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelSmallIsCustom,
                                  ),
                              indicatorColor:
                                  FlutterFlowTheme.of(context).secondary2,
                              indicatorWeight: 4.0,
                              padding: EdgeInsets.all(2.0),
                              tabs: [
                                Tab(
                                  text: 'General',
                                ),
                                Tab(
                                  text: 'Profile',
                                ),
                                Tab(
                                  text: 'Plants',
                                ),
                                Tab(
                                  text: 'Privacy',
                                ),
                                Tab(
                                  text: 'Data',
                                ),
                                Tab(
                                  text: 'Sub',
                                ),
                              ],
                              controller: _model.tabBarController,
                              onTap: (i) async {
                                [
                                  () async {},
                                  () async {},
                                  () async {},
                                  () async {},
                                  () async {
                                    _model.outputUser =
                                        await UsersTable().queryRows(
                                      queryFn: (q) => q.eqOrNull(
                                        'id',
                                        currentUserUid,
                                      ),
                                    );
                                    FFAppState().hasSubscription = _model
                                        .outputUser!
                                        .elementAtOrNull(0)!
                                        .hasSubscription!;
                                    safeSetState(() {});

                                    safeSetState(() {});
                                  },
                                  () async {}
                                ][i]();
                              },
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _model.tabBarController,
                              children: [
                                KeepAliveWidgetWrapper(
                                  builder: (context) => SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child:
                                                  FutureBuilder<List<UsersRow>>(
                                                future:
                                                    UsersTable().querySingleRow(
                                                  queryFn: (q) => q.eqOrNull(
                                                    'id',
                                                    currentUserUid,
                                                  ),
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 25.0,
                                                        height: 25.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            Color(0xFF0F26C0),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<UsersRow>
                                                      containerUsersRowList =
                                                      snapshot.data!;

                                                  final containerUsersRow =
                                                      containerUsersRowList
                                                              .isNotEmpty
                                                          ? containerUsersRowList
                                                              .first
                                                          : null;

                                                  return Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  30.0,
                                                                  0.0,
                                                                  30.0,
                                                                  0.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        10.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Needed for verification and password recovery',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
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
                                                                              return 9.0;
                                                                            } else if (FFAppState().screenCategory ==
                                                                                'medium') {
                                                                              return 11.0;
                                                                            } else {
                                                                              return 13.0;
                                                                            }
                                                                          }(),
                                                                          13.0,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.9,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          _model
                                                                              .emailTextController,
                                                                      focusNode:
                                                                          _model
                                                                              .emailFocusNode,
                                                                      autofocus:
                                                                          true,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        isDense:
                                                                            true,
                                                                        labelText:
                                                                            'Email',
                                                                        labelStyle: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                              fontSize: valueOrDefault<double>(
                                                                                () {
                                                                                  if (FFAppState().screenCategory == 'small') {
                                                                                    return 9.0;
                                                                                  } else if (FFAppState().screenCategory == 'medium') {
                                                                                    return 11.0;
                                                                                  } else {
                                                                                    return 13.0;
                                                                                  }
                                                                                }(),
                                                                                13.0,
                                                                              ),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                            ),
                                                                        hintText:
                                                                            'Email',
                                                                        hintStyle: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                              fontSize: valueOrDefault<double>(
                                                                                () {
                                                                                  if (FFAppState().screenCategory == 'small') {
                                                                                    return 9.0;
                                                                                  } else if (FFAppState().screenCategory == 'medium') {
                                                                                    return 11.0;
                                                                                  } else {
                                                                                    return 13.0;
                                                                                  }
                                                                                }(),
                                                                                13.0,
                                                                              ),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                            ),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).alternate,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        errorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            FlutterFlowTheme.of(context).secondaryBackground,
                                                                        prefixIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .edit,
                                                                          size:
                                                                              20.0,
                                                                        ),
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodySmallFamily,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 13.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 14.0;
                                                                                } else {
                                                                                  return 15.0;
                                                                                }
                                                                              }(),
                                                                              15.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                          ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      maxLines:
                                                                          null,
                                                                      validator: _model
                                                                          .emailTextControllerValidator
                                                                          .asValidator(
                                                                              context),
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
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    _model.requestEmailChangeOutput =
                                                                        await actions
                                                                            .requestEmailChange(
                                                                      currentUserUid,
                                                                      containerUsersRow!
                                                                          .email!,
                                                                      _model
                                                                          .emailTextController
                                                                          .text,
                                                                    );
                                                                    _model.hasSuccess =
                                                                        getJsonField(
                                                                      _model
                                                                          .requestEmailChangeOutput,
                                                                      r'''$.success''',
                                                                    );
                                                                    safeSetState(
                                                                        () {});
                                                                    if (_model
                                                                            .hasSuccess ==
                                                                        true) {
                                                                      await showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (alertDialogContext) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text('Confirmation'),
                                                                            content:
                                                                                Text('Please check your inbox for change pin.'),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () => Navigator.pop(alertDialogContext),
                                                                                child: Text('Ok'),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
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
                                                                            onTap:
                                                                                () {
                                                                              FocusScope.of(context).unfocus();
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: Container(
                                                                                height: MediaQuery.sizeOf(context).height * 0.6,
                                                                                child: BottomSheetEmailChangeWidget(
                                                                                  oldMail: currentUserEmail,
                                                                                  newMail: _model.emailTextController.text,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(() =>
                                                                              _model.newEmailFromBottomSheet = value));
                                                                    } else {
                                                                      _model.errorMessage =
                                                                          getJsonField(
                                                                        _model
                                                                            .requestEmailChangeOutput,
                                                                        r'''$.error''',
                                                                      ).toString();
                                                                      safeSetState(
                                                                          () {});
                                                                      await showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (alertDialogContext) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text('Note'),
                                                                            content:
                                                                                Text(_model.errorMessage!),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () => Navigator.pop(alertDialogContext),
                                                                                child: Text('Ok'),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    }

                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  text:
                                                                      'Update',
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.4,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.05,
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            24.0,
                                                                            0.0,
                                                                            24.0,
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondary,
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).titleSmallFamily,
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
                                                                            () {
                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                return 14.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                return 16.0;
                                                                              } else {
                                                                                return 18.0;
                                                                              }
                                                                            }(),
                                                                            18.0,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            14.0),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(
                                                            thickness: 2.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        7.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Optional',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
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
                                                                              return 11.0;
                                                                            } else if (FFAppState().screenCategory ==
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
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        10.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.9,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          _model.firstnameTextController ??=
                                                                              TextEditingController(
                                                                        text: containerUsersRow
                                                                            ?.firstname,
                                                                      ),
                                                                      focusNode:
                                                                          _model
                                                                              .firstnameFocusNode,
                                                                      autofocus:
                                                                          true,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        isDense:
                                                                            true,
                                                                        labelText:
                                                                            'First name',
                                                                        labelStyle: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                              fontSize: valueOrDefault<double>(
                                                                                () {
                                                                                  if (FFAppState().screenCategory == 'small') {
                                                                                    return 9.0;
                                                                                  } else if (FFAppState().screenCategory == 'medium') {
                                                                                    return 11.0;
                                                                                  } else {
                                                                                    return 13.0;
                                                                                  }
                                                                                }(),
                                                                                13.0,
                                                                              ),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                            ),
                                                                        hintText:
                                                                            'First name',
                                                                        hintStyle: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                              fontSize: valueOrDefault<double>(
                                                                                () {
                                                                                  if (FFAppState().screenCategory == 'small') {
                                                                                    return 9.0;
                                                                                  } else if (FFAppState().screenCategory == 'medium') {
                                                                                    return 11.0;
                                                                                  } else {
                                                                                    return 13.0;
                                                                                  }
                                                                                }(),
                                                                                13.0,
                                                                              ),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                            ),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).alternate,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        errorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            FlutterFlowTheme.of(context).secondaryBackground,
                                                                        prefixIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .edit,
                                                                          size:
                                                                              20.0,
                                                                        ),
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodySmallFamily,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 13.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 14.0;
                                                                                } else {
                                                                                  return 15.0;
                                                                                }
                                                                              }(),
                                                                              15.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                          ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      maxLines:
                                                                          null,
                                                                      validator: _model
                                                                          .firstnameTextControllerValidator
                                                                          .asValidator(
                                                                              context),
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
                                                                        0.0,
                                                                        10.0,
                                                                        0.0,
                                                                        10.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.9,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          _model.lastnameTextController ??=
                                                                              TextEditingController(
                                                                        text: containerUsersRow
                                                                            ?.lastname,
                                                                      ),
                                                                      focusNode:
                                                                          _model
                                                                              .lastnameFocusNode,
                                                                      autofocus:
                                                                          true,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        isDense:
                                                                            true,
                                                                        labelText:
                                                                            'Second name',
                                                                        labelStyle: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                              fontSize: valueOrDefault<double>(
                                                                                () {
                                                                                  if (FFAppState().screenCategory == 'small') {
                                                                                    return 9.0;
                                                                                  } else if (FFAppState().screenCategory == 'medium') {
                                                                                    return 11.0;
                                                                                  } else {
                                                                                    return 13.0;
                                                                                  }
                                                                                }(),
                                                                                13.0,
                                                                              ),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                            ),
                                                                        hintText:
                                                                            'Last name',
                                                                        hintStyle: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                              fontSize: valueOrDefault<double>(
                                                                                () {
                                                                                  if (FFAppState().screenCategory == 'small') {
                                                                                    return 9.0;
                                                                                  } else if (FFAppState().screenCategory == 'medium') {
                                                                                    return 11.0;
                                                                                  } else {
                                                                                    return 13.0;
                                                                                  }
                                                                                }(),
                                                                                13.0,
                                                                              ),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                            ),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).alternate,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        errorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            FlutterFlowTheme.of(context).secondaryBackground,
                                                                        prefixIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .edit,
                                                                          size:
                                                                              20.0,
                                                                        ),
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodySmallFamily,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 13.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 14.0;
                                                                                } else {
                                                                                  return 15.0;
                                                                                }
                                                                              }(),
                                                                              15.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                          ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      maxLines:
                                                                          null,
                                                                      validator: _model
                                                                          .lastnameTextControllerValidator
                                                                          .asValidator(
                                                                              context),
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
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    'Your fiber rate',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
                                                                            () {
                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                return 11.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
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
                                                                              FontWeight.w600,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
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
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.7,
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.05,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14.0),
                                                                ),
                                                                child:
                                                                    FlutterFlowDropDown<
                                                                        double>(
                                                                  controller: _model
                                                                          .fiberdropdownValueController ??=
                                                                      FormFieldController<
                                                                          double>(
                                                                    _model.fiberdropdownValue ??=
                                                                        valueOrDefault<
                                                                            double>(
                                                                      containerUsersRow
                                                                          ?.currentFiberValue,
                                                                      0.0,
                                                                    ),
                                                                  ),
                                                                  options: List<
                                                                      double>.from([
                                                                    30.0,
                                                                    40.0
                                                                  ]),
                                                                  optionLabels: [
                                                                    '30 g / day (General Health)',
                                                                    '40 g / day (Gut and Longevity)'
                                                                  ],
                                                                  onChanged: (val) =>
                                                                      safeSetState(() =>
                                                                          _model.fiberdropdownValue =
                                                                              val),
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.9,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.04,
                                                                  textStyle: FlutterFlowTheme.of(
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
                                                                              return 13.0;
                                                                            } else if (FFAppState().screenCategory ==
                                                                                'medium') {
                                                                              return 14.0;
                                                                            } else {
                                                                              return 15.0;
                                                                            }
                                                                          }(),
                                                                          15.0,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  hintText:
                                                                      'Fiber / d',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down_rounded,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    size: 24.0,
                                                                  ),
                                                                  fillColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  elevation:
                                                                      2.0,
                                                                  borderColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                  borderWidth:
                                                                      2.0,
                                                                  borderRadius:
                                                                      14.0,
                                                                  margin: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          12.0,
                                                                          0.0),
                                                                  hidesUnderline:
                                                                      true,
                                                                  isOverButton:
                                                                      false,
                                                                  isSearchable:
                                                                      false,
                                                                  isMultiSelect:
                                                                      false,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        10.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    'Your protein rate (per kg body weight)',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
                                                                            () {
                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                return 11.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
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
                                                                              FontWeight.w600,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.7,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.05,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            14.0),
                                                                  ),
                                                                  child:
                                                                      FlutterFlowDropDown<
                                                                          double>(
                                                                    controller: _model
                                                                            .proteindropdownValueController ??=
                                                                        FormFieldController<
                                                                            double>(
                                                                      _model.proteindropdownValue ??=
                                                                          valueOrDefault<
                                                                              double>(
                                                                        containerUsersRow
                                                                            ?.currentProteinValue,
                                                                        0.0,
                                                                      ),
                                                                    ),
                                                                    options: List<
                                                                        double>.from([
                                                                      0.8,
                                                                      1.1,
                                                                      1.6
                                                                    ]),
                                                                    optionLabels: [
                                                                      '0.8 g / day (General Health)',
                                                                      '1.1 g / day (Age 65+)',
                                                                      '1.6 g / day (Highly Active)'
                                                                    ],
                                                                    onChanged: (val) =>
                                                                        safeSetState(() =>
                                                                            _model.proteindropdownValue =
                                                                                val),
                                                                    width:
                                                                        252.2,
                                                                    height:
                                                                        40.0,
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
                                                                            () {
                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                return 13.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                return 14.0;
                                                                              } else {
                                                                                return 15.0;
                                                                              }
                                                                            }(),
                                                                            15.0,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                    hintText:
                                                                        'Protein needs',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .keyboard_arrow_down_rounded,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    elevation:
                                                                        2.0,
                                                                    borderColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                    borderWidth:
                                                                        2.0,
                                                                    borderRadius:
                                                                        14.0,
                                                                    margin: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    hidesUnderline:
                                                                        true,
                                                                    isOverButton:
                                                                        false,
                                                                    isSearchable:
                                                                        false,
                                                                    isMultiSelect:
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
                                                                        0.0,
                                                                        10.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    'Language',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
                                                                            () {
                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                return 11.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
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
                                                                              FontWeight.w600,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.7,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.05,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            14.0),
                                                                  ),
                                                                  child:
                                                                      FlutterFlowDropDown<String>(
                                                                          controller: _model.languageDropdownController ??=
                                                                              FormFieldController<String>(
                                                                            _model.languageDropdownValue ??= FFAppState().selectedLanguage ?? 'en',
                                                                          ),
                                                                          options: const [
                                                                            'en', // English
                                                                            'nl', // Dutch
                                                                            'fr', // French
                                                                            'de', // German
                                                                          ],
                                                                          optionLabels: const [
                                                                            'English',
                                                                            'Dutch',
                                                                            'French',
                                                                            'German',
                                                                          ],
                                                                          onChanged: (val) {
                                                                            safeSetState(() => _model.languageDropdownValue = val);

                                                                            // 🔥 Save in app state (so it persists across screens)
                                                                            FFAppState().selectedLanguage = val;

                                                                            // 🔥 Change locale
                                                                            MyApp.of(context).setLocale(Locale(val ?? 'en'));
                                                                          },
                                                                          hintText: 'Your preferred language',
                                                                          width: 252.0,
                                                                          height: 40.0,
                                                                          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w600,
                                                                                useGoogleFonts:
                                                                                    !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                          borderColor: FlutterFlowTheme.of(context).alternate,
                                                                          borderWidth: 2.0,
                                                                          borderRadius: 14.0,
                                                                          hidesUnderline: true,
                                                                          isSearchable: false,
                                                                          isMultiSelect: false,

                                                                          elevation: 2,
                                                                          margin: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                                                        ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        10.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Builder(
                                                                  builder:
                                                                      (context) =>
                                                                          FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await UsersTable()
                                                                          .update(
                                                                        data: {
                                                                          'created_at':
                                                                              supaSerialize<DateTime>(getCurrentTimestamp),
                                                                          'firstname': _model
                                                                              .firstnameTextController
                                                                              .text,
                                                                          'lastname': _model
                                                                              .lastnameTextController
                                                                              .text,
                                                                          'current_protein_value':
                                                                              _model.proteindropdownValue,
                                                                          'current_fiber_value':
                                                                              _model.fiberdropdownValue,
                                                                        },
                                                                        matchingRows:
                                                                            (rows) =>
                                                                                rows.eqOrNull(
                                                                          'id',
                                                                          currentUserUid,
                                                                        ),
                                                                      );
                                                                      FFAppState()
                                                                              .userFiberValue =
                                                                          _model
                                                                              .fiberdropdownValue!;
                                                                      FFAppState()
                                                                              .userProteinValue =
                                                                          _model
                                                                              .proteindropdownValue!;
                                                                      safeSetState(
                                                                          () {});
                                                                      showAlignedDialog(
                                                                        barrierColor:
                                                                            Color(0x23A1C38F),
                                                                        context:
                                                                            context,
                                                                        isGlobal:
                                                                            false,
                                                                        avoidOverflow:
                                                                            false,
                                                                        targetAnchor:
                                                                            AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                        followerAnchor:
                                                                            AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                        builder:
                                                                            (dialogContext) {
                                                                          return Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(dialogContext).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: InfoboxGeneraloptinWidget(),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );

                                                                      await Future
                                                                          .delayed(
                                                                        Duration(
                                                                          milliseconds:
                                                                              2000,
                                                                        ),
                                                                      );
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    text:
                                                                        'Update',
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.4,
                                                                      height: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.05,
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondary,
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).titleSmallFamily,
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 14.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 16.0;
                                                                                } else {
                                                                                  return 18.0;
                                                                                }
                                                                              }(),
                                                                              18.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              14.0),
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
                                                                        0.0,
                                                                        10.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                if ((currentUserUid == 'd455d1f8-1985-41b3-9883-ccca5bcd3051') ||
                                                                    (currentUserUid ==
                                                                        'a843c355-631e-4a3f-ba34-6955e628d51e') ||
                                                                    (currentUserUid ==
                                                                        'c92a0367-3a83-4f38-b6df-7e1c20e74d03'))
                                                                  FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      context
                                                                          .pushNamed(
                                                                        AdministrationWidget
                                                                            .routeName,
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
                                                                    text:
                                                                        'Admin',
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.4,
                                                                      height: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.05,
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          24.0,
                                                                          0.0,
                                                                          24.0,
                                                                          0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: Color(
                                                                          0xFF205BC4),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).titleSmallFamily,
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 14.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 16.0;
                                                                                } else {
                                                                                  return 18.0;
                                                                                }
                                                                              }(),
                                                                              18.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              14.0),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                KeepAliveWidgetWrapper(
                                  builder: (context) => SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child:
                                                  FutureBuilder<List<UsersRow>>(
                                                future:
                                                    UsersTable().querySingleRow(
                                                  queryFn: (q) => q.eqOrNull(
                                                    'id',
                                                    currentUserUid,
                                                  ),
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 25.0,
                                                        height: 25.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            Color(0xFF0F26C0),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<UsersRow>
                                                      containerUsersRowList =
                                                      snapshot.data!;

                                                  final containerUsersRow =
                                                      containerUsersRowList
                                                              .isNotEmpty
                                                          ? containerUsersRowList
                                                              .first
                                                          : null;

                                                  return Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        0.7,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  30.0,
                                                                  0.0,
                                                                  30.0,
                                                                  0.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        10.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Text(
                                                                          'Birthday',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                fontSize: valueOrDefault<double>(
                                                                                  () {
                                                                                    if (FFAppState().screenCategory == 'small') {
                                                                                      return 11.0;
                                                                                    } else if (FFAppState().screenCategory == 'medium') {
                                                                                      return 12.0;
                                                                                    } else {
                                                                                      return 13.0;
                                                                                    }
                                                                                  }(),
                                                                                  13.0,
                                                                                ),
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        10.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    dateTimeFormat(
                                                                        "d/M/y",
                                                                        FFAppState()
                                                                            .birthday),
                                                                    '01/01/1900',
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
                                                                              return 16.0;
                                                                            } else {
                                                                              return 18.0;
                                                                            }
                                                                          }(),
                                                                          18.0,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        10.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    final _datePickedDate =
                                                                        await showDatePicker(
                                                                      context:
                                                                          context,
                                                                      initialDate: (FFAppState()
                                                                              .birthday ??
                                                                          DateTime
                                                                              .now()),
                                                                      firstDate:
                                                                          DateTime(
                                                                              1900),
                                                                      lastDate: (FFAppState()
                                                                              .birthday ??
                                                                          DateTime
                                                                              .now()),
                                                                      builder:
                                                                          (context,
                                                                              child) {
                                                                        return wrapInMaterialDatePickerTheme(
                                                                          context,
                                                                          child!,
                                                                          headerBackgroundColor:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          headerForegroundColor:
                                                                              FlutterFlowTheme.of(context).info,
                                                                          headerTextStyle: FlutterFlowTheme.of(context)
                                                                              .headlineLarge
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).headlineLargeFamily,
                                                                                fontSize: 32.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineLargeIsCustom,
                                                                              ),
                                                                          pickerBackgroundColor:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          pickerForegroundColor:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          selectedDateTimeBackgroundColor:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          selectedDateTimeForegroundColor:
                                                                              FlutterFlowTheme.of(context).info,
                                                                          actionButtonForegroundColor:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          iconSize:
                                                                              24.0,
                                                                        );
                                                                      },
                                                                    );

                                                                    if (_datePickedDate !=
                                                                        null) {
                                                                      safeSetState(
                                                                          () {
                                                                        _model.datePicked =
                                                                            DateTime(
                                                                          _datePickedDate
                                                                              .year,
                                                                          _datePickedDate
                                                                              .month,
                                                                          _datePickedDate
                                                                              .day,
                                                                        );
                                                                      });
                                                                    } else if (_model
                                                                            .datePicked !=
                                                                        null) {
                                                                      safeSetState(
                                                                          () {
                                                                        _model.datePicked =
                                                                            FFAppState().birthday;
                                                                      });
                                                                    }
                                                                    FFAppState()
                                                                            .birthday =
                                                                        _model
                                                                            .datePicked;
                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  text:
                                                                      'Change',
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.4,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.04,
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            16.0,
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).titleSmallFamily,
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
                                                                            () {
                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                return 14.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                return 16.0;
                                                                              } else {
                                                                                return 18.0;
                                                                              }
                                                                            }(),
                                                                            18.0,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(
                                                            thickness: 2.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .accent4,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        15.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _model.heightTextController ??=
                                                                            TextEditingController(
                                                                      text: containerUsersRow
                                                                          ?.height
                                                                          ?.toString(),
                                                                    ),
                                                                    focusNode:
                                                                        _model
                                                                            .heightFocusNode,
                                                                    autofocus:
                                                                        true,
                                                                    obscureText:
                                                                        false,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      labelText:
                                                                          'Height (in cm)',
                                                                      labelStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodySmallFamily,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 11.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
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
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                          ),
                                                                      hintText:
                                                                          'Height (in cm)',
                                                                      hintStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelSmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelSmallFamily,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 11.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
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
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).labelSmallIsCustom,
                                                                          ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      errorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      focusedErrorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondaryBackground,
                                                                      prefixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .edit,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .tertiaryText,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodySmallFamily,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
                                                                            () {
                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                return 13.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                return 14.0;
                                                                              } else {
                                                                                return 15.0;
                                                                              }
                                                                            }(),
                                                                            15.0,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                        ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    maxLines:
                                                                        null,
                                                                    validator: _model
                                                                        .heightTextControllerValidator
                                                                        .asValidator(
                                                                            context),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          5.0,
                                                                          0.0,
                                                                          5.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              8.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                45.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              borderRadius: BorderRadius.circular(14.0),
                                                                              border: Border.all(
                                                                                color: FlutterFlowTheme.of(context).alternate,
                                                                                width: 2.0,
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                  child: Icon(
                                                                                    Icons.edit,
                                                                                    color: FlutterFlowTheme.of(context).tertiaryText,
                                                                                    size: 20.0,
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: FlutterFlowDropDown<String>(
                                                                                    controller: _model.genderValueController ??= FormFieldController<String>(
                                                                                      _model.genderValue ??= containerUsersRow?.gender,
                                                                                    ),
                                                                                    options: [
                                                                                      'undefined',
                                                                                      'female',
                                                                                      'male'
                                                                                    ],
                                                                                    onChanged: (val) => safeSetState(() => _model.genderValue = val),
                                                                                    width: double.infinity,
                                                                                    height: MediaQuery.sizeOf(context).height * 0.45,
                                                                                    textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                          fontSize: valueOrDefault<double>(
                                                                                            () {
                                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                                return 11.0;
                                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                                return 12.0;
                                                                                              } else {
                                                                                                return 13.0;
                                                                                              }
                                                                                            }(),
                                                                                            13.0,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                        ),
                                                                                    hintText: 'Gender',
                                                                                    elevation: 1.0,
                                                                                    borderColor: Colors.transparent,
                                                                                    borderWidth: 0.0,
                                                                                    borderRadius: 14.0,
                                                                                    margin: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                    hidesUnderline: true,
                                                                                    isOverButton: false,
                                                                                    isSearchable: false,
                                                                                    isMultiSelect: false,
                                                                                    labelText: '',
                                                                                    labelTextStyle: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).labelSmallFamily,
                                                                                          fontSize: 12.0,
                                                                                          letterSpacing: 0.0,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).labelSmallIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              35.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                45.0,
                                                                            height:
                                                                                17.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  'Gender',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        fontSize: 10.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                          ),
                                                          Divider(
                                                            thickness: 2.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .accent4,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _model.regionTextController ??=
                                                                            TextEditingController(
                                                                      text: containerUsersRow
                                                                          ?.region,
                                                                    ),
                                                                    focusNode:
                                                                        _model
                                                                            .regionFocusNode,
                                                                    autofocus:
                                                                        true,
                                                                    obscureText:
                                                                        false,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      labelText:
                                                                          'Region',
                                                                      labelStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodySmallFamily,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 11.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
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
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                          ),
                                                                      hintText:
                                                                          'Region',
                                                                      hintStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelSmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelSmallFamily,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 11.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
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
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).labelSmallIsCustom,
                                                                          ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      errorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      focusedErrorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondaryBackground,
                                                                      prefixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .edit,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .tertiaryText,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodySmallFamily,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
                                                                            () {
                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                return 13.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                return 14.0;
                                                                              } else {
                                                                                return 15.0;
                                                                              }
                                                                            }(),
                                                                            15.0,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                        ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    maxLines:
                                                                        null,
                                                                    validator: _model
                                                                        .regionTextControllerValidator
                                                                        .asValidator(
                                                                            context),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _model.phoneTextController ??=
                                                                            TextEditingController(
                                                                      text: containerUsersRow
                                                                          ?.phone,
                                                                    ),
                                                                    focusNode:
                                                                        _model
                                                                            .phoneFocusNode,
                                                                    autofocus:
                                                                        true,
                                                                    obscureText:
                                                                        false,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      labelText:
                                                                          'Phone',
                                                                      labelStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodySmallFamily,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 11.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
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
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                          ),
                                                                      hintText:
                                                                          'Phone',
                                                                      hintStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelSmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelSmallFamily,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 11.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
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
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).labelSmallIsCustom,
                                                                          ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      errorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      focusedErrorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(14.0),
                                                                      ),
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondaryBackground,
                                                                      prefixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .edit,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .tertiaryText,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodySmallFamily,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
                                                                            () {
                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                return 13.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                return 14.0;
                                                                              } else {
                                                                                return 15.0;
                                                                              }
                                                                            }(),
                                                                            15.0,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                        ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    maxLines:
                                                                        null,
                                                                    validator: _model
                                                                        .phoneTextControllerValidator
                                                                        .asValidator(
                                                                            context),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Builder(
                                                                  builder:
                                                                      (context) =>
                                                                          FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await UsersTable()
                                                                          .update(
                                                                        data: {
                                                                          'created_at':
                                                                              supaSerialize<DateTime>(getCurrentTimestamp),
                                                                          'height': int.tryParse(_model
                                                                              .heightTextController
                                                                              .text),
                                                                          'region': _model
                                                                              .regionTextController
                                                                              .text,
                                                                          'gender':
                                                                              _model.genderValue,
                                                                          'phone': _model
                                                                              .phoneTextController
                                                                              .text,
                                                                          'birthdate':
                                                                              supaSerialize<DateTime>(_model.datePicked),
                                                                        },
                                                                        matchingRows:
                                                                            (rows) =>
                                                                                rows.eqOrNull(
                                                                          'id',
                                                                          currentUserUid,
                                                                        ),
                                                                      );
                                                                      showAlignedDialog(
                                                                        context:
                                                                            context,
                                                                        isGlobal:
                                                                            false,
                                                                        avoidOverflow:
                                                                            false,
                                                                        targetAnchor:
                                                                            AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                        followerAnchor:
                                                                            AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                        builder:
                                                                            (dialogContext) {
                                                                          return Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(dialogContext).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: InfoboxGeneraloptinWidget(),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );

                                                                      await Future
                                                                          .delayed(
                                                                        Duration(
                                                                          milliseconds:
                                                                              2000,
                                                                        ),
                                                                      );
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    text:
                                                                        'Update all',
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.4,
                                                                      height: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.05,
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          24.0,
                                                                          0.0,
                                                                          24.0,
                                                                          0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondary,
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).titleSmallFamily,
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 14.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 16.0;
                                                                                } else {
                                                                                  return 18.0;
                                                                                }
                                                                              }(),
                                                                              18.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(
                                                            thickness: 2.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .accent4,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        15.0,
                                                                        0.0,
                                                                        5.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    var confirmDialogResponse =
                                                                        await showDialog<bool>(
                                                                              context: context,
                                                                              builder: (alertDialogContext) {
                                                                                return AlertDialog(
                                                                                  title: Text('Account deletion'),
                                                                                  content: Text('This action deletes your account. Please confirm to proceed. '),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                      child: Text('Cancel'),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                      child: Text('Confirm'),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ) ??
                                                                            false;
                                                                    if (confirmDialogResponse) {
                                                                      confirmDialogResponse = await showDialog<
                                                                              bool>(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (alertDialogContext) {
                                                                              return AlertDialog(
                                                                                title: Text('Overview'),
                                                                                content: Text('Deleted will be any personally identifiable information. '),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                    child: Text('Cancel'),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                    child: Text('Consent'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ) ??
                                                                          false;
                                                                      if (confirmDialogResponse) {
                                                                        confirmDialogResponse = await showDialog<bool>(
                                                                              context: context,
                                                                              builder: (alertDialogContext) {
                                                                                return AlertDialog(
                                                                                  title: Text('Final iteration'),
                                                                                  content: Text('Yes, delete my account forever. '),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                      child: Text('Cancel'),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                      child: Text('Confirm'),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ) ??
                                                                            false;
                                                                        if (confirmDialogResponse) {
                                                                          await actions
                                                                              .deleteAndAnonymizeAccount();

                                                                          context
                                                                              .goNamed(
                                                                            LoginWidget.routeName,
                                                                            queryParameters:
                                                                                {
                                                                              'preferredTabIndex': serializeParam(
                                                                                0,
                                                                                ParamType.int,
                                                                              ),
                                                                            }.withoutNulls,
                                                                            extra: <String,
                                                                                dynamic>{
                                                                              kTransitionInfoKey: TransitionInfo(
                                                                                hasTransition: true,
                                                                                transitionType: PageTransitionType.fade,
                                                                              ),
                                                                            },
                                                                          );
                                                                        }
                                                                      }
                                                                    }
                                                                  },
                                                                  text:
                                                                      'Delete account',
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.4,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.05,
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            24.0,
                                                                            0.0,
                                                                            24.0,
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .warning,
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).titleSmallFamily,
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
                                                                            () {
                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                return 14.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                return 16.0;
                                                                              } else {
                                                                                return 18.0;
                                                                              }
                                                                            }(),
                                                                            18.0,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                        ),
                                                                    elevation:
                                                                        3.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                KeepAliveWidgetWrapper(
                                  builder: (context) => Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 5.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, -1.0),
                                                        child: Text(
                                                          'General plant selection',
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
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Choose all plants for your weekly selection.',
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
                                                ),
                                                Divider(
                                                  thickness: 2.0,
                                                  indent: 10.0,
                                                  endIndent: 10.0,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent4,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  1.0,
                                              decoration: BoxDecoration(),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 5.0, 0.0),
                                                child: ListView(
                                                  padding: EdgeInsets.fromLTRB(
                                                    0,
                                                    5.0,
                                                    0,
                                                    5.0,
                                                  ),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  40.0,
                                                                  0.0,
                                                                  40.0,
                                                                  0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.22,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFF9F3F3),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              offset: Offset(
                                                                0.0,
                                                                0.0,
                                                              ),
                                                              spreadRadius: 2.0,
                                                            )
                                                          ],
                                                        ),
                                                        child: ListView(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Builder(
                                                                builder:
                                                                    (context) {
                                                                  final redSelectedChoiceChipsDC = FFAppState()
                                                                      .locplantselectionlist
                                                                      .where((e) =>
                                                                          e.color ==
                                                                          'Red')
                                                                      .toList()
                                                                      .sortedList(
                                                                          keyOf: (e) => e
                                                                              .plantname,
                                                                          desc:
                                                                              false)
                                                                      .toList();

                                                                  return Wrap(
                                                                    spacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 6.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 7.0;
                                                                        } else {
                                                                          return 8.0;
                                                                        }
                                                                      }(),
                                                                      8.0,
                                                                    ),
                                                                    runSpacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 8.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 10.0;
                                                                        } else {
                                                                          return 12.0;
                                                                        }
                                                                      }(),
                                                                      12.0,
                                                                    ),
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .start,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    runAlignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    verticalDirection:
                                                                        VerticalDirection
                                                                            .down,
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: List.generate(
                                                                        redSelectedChoiceChipsDC
                                                                            .length,
                                                                        (redSelectedChoiceChipsDCIndex) {
                                                                      final redSelectedChoiceChipsDCItem =
                                                                          redSelectedChoiceChipsDC[
                                                                              redSelectedChoiceChipsDCIndex];
                                                                      return wrapWithModel(
                                                                        model: _model
                                                                            .settingsChoiceChipModels1
                                                                            .getModel(
                                                                          redSelectedChoiceChipsDCItem
                                                                              .idLoc
                                                                              .toString(),
                                                                          redSelectedChoiceChipsDCIndex,
                                                                        ),
                                                                        updateCallback:
                                                                            () =>
                                                                                safeSetState(() {}),
                                                                        child:
                                                                            SettingsChoiceChipWidget(
                                                                          key:
                                                                              Key(
                                                                            'Keye1l_${redSelectedChoiceChipsDCItem.idLoc.toString()}',
                                                                          ),
                                                                          plantname:
                                                                              valueOrDefault<String>(
                                                                            redSelectedChoiceChipsDCItem.plantname,
                                                                            'n/a',
                                                                          ),
                                                                          color:
                                                                              valueOrDefault<String>(
                                                                            redSelectedChoiceChipsDCItem.color,
                                                                            'Red',
                                                                          ),
                                                                          borderColorTapped:
                                                                              Color(0xFFBC6C6C),
                                                                          borderColorUntapped:
                                                                              Color(0xFFCEACAC),
                                                                          colorTextUntapped:
                                                                              Color(0xFFA63F3F),
                                                                          colorTextTapped:
                                                                              Color(0xFF690D0D),
                                                                          colorContainerTapped:
                                                                              Color(0xFFE7AFAF),
                                                                          colorContainerUntapped:
                                                                              Color(0xFFF5C8C8),
                                                                          shadowColorUntapped:
                                                                              Color(0xFFCEACAC),
                                                                          shadowColorTapped:
                                                                              Color(0xFF853939),
                                                                          locId:
                                                                              valueOrDefault<int>(
                                                                            redSelectedChoiceChipsDCItem.idLoc,
                                                                            0,
                                                                          ),
                                                                          isSelected:
                                                                              redSelectedChoiceChipsDCItem.selected,
                                                                          listAreaTapped:
                                                                              Color(0xFFF4D1D1),
                                                                          listAreaUntapped:
                                                                              Color(0xFFF8E8E8),
                                                                          portionSum:
                                                                              valueOrDefault<double>(
                                                                            redSelectedChoiceChipsDCItem.portionsum,
                                                                            0.0,
                                                                          ),
                                                                          isPreset:
                                                                              redSelectedChoiceChipsDCItem.presetBool,
                                                                          portionSize:
                                                                              valueOrDefault<double>(
                                                                            redSelectedChoiceChipsDCItem.portionsize,
                                                                            1.0,
                                                                          ),
                                                                          plantCount:
                                                                              (plantCounter) async {
                                                                            FFAppState().redWeeklySelectedPlants =
                                                                                plantCounter!;
                                                                            FFAppState().totalWeeklySelectedPlants = FFAppState().redWeeklySelectedPlants +
                                                                                FFAppState().orangeWeeklySelectedPlants +
                                                                                FFAppState().yellowWeeklySelectedPlants +
                                                                                FFAppState().greenWeeklySelectedPlants +
                                                                                FFAppState().purpleWeeklySelectedPlants +
                                                                                FFAppState().brownWeeklySelectedPlants +
                                                                                FFAppState().whiteWeeklySelectedPlants;
                                                                            safeSetState(() {});
                                                                          },
                                                                        ),
                                                                      );
                                                                    }),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  40.0,
                                                                  0.0,
                                                                  40.0,
                                                                  0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.22,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFF9F5F0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .warning,
                                                              offset: Offset(
                                                                0.0,
                                                                0.0,
                                                              ),
                                                              spreadRadius: 2.0,
                                                            )
                                                          ],
                                                        ),
                                                        child: ListView(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Builder(
                                                                builder:
                                                                    (context) {
                                                                  final orangeSelectedChoiceChipsDC = FFAppState()
                                                                      .locplantselectionlist
                                                                      .where((e) =>
                                                                          e.color ==
                                                                          'Orange')
                                                                      .toList()
                                                                      .sortedList(
                                                                          keyOf: (e) => e
                                                                              .plantname,
                                                                          desc:
                                                                              false)
                                                                      .toList();

                                                                  return Wrap(
                                                                    spacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 6.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 7.0;
                                                                        } else {
                                                                          return 8.0;
                                                                        }
                                                                      }(),
                                                                      8.0,
                                                                    ),
                                                                    runSpacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 8.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 10.0;
                                                                        } else {
                                                                          return 12.0;
                                                                        }
                                                                      }(),
                                                                      12.0,
                                                                    ),
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .start,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    runAlignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    verticalDirection:
                                                                        VerticalDirection
                                                                            .down,
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: List.generate(
                                                                        orangeSelectedChoiceChipsDC
                                                                            .length,
                                                                        (orangeSelectedChoiceChipsDCIndex) {
                                                                      final orangeSelectedChoiceChipsDCItem =
                                                                          orangeSelectedChoiceChipsDC[
                                                                              orangeSelectedChoiceChipsDCIndex];
                                                                      return wrapWithModel(
                                                                        model: _model
                                                                            .settingsChoiceChipModels2
                                                                            .getModel(
                                                                          orangeSelectedChoiceChipsDCItem
                                                                              .idLoc
                                                                              .toString(),
                                                                          orangeSelectedChoiceChipsDCIndex,
                                                                        ),
                                                                        updateCallback:
                                                                            () =>
                                                                                safeSetState(() {}),
                                                                        child:
                                                                            SettingsChoiceChipWidget(
                                                                          key:
                                                                              Key(
                                                                            'Keygus_${orangeSelectedChoiceChipsDCItem.idLoc.toString()}',
                                                                          ),
                                                                          plantname:
                                                                              orangeSelectedChoiceChipsDCItem.plantname,
                                                                          color:
                                                                              orangeSelectedChoiceChipsDCItem.color,
                                                                          borderColorTapped:
                                                                              Color(0xFF9E7224),
                                                                          borderColorUntapped:
                                                                              Color(0xFFAD9873),
                                                                          colorTextUntapped:
                                                                              Color(0xFF9E5D1A),
                                                                          colorTextTapped:
                                                                              Color(0xFF5C360B),
                                                                          colorContainerTapped:
                                                                              Color(0xFFF9BB74),
                                                                          colorContainerUntapped:
                                                                              Color(0xFFFBDAAC),
                                                                          shadowColorUntapped:
                                                                              Color(0xFFDDC29D),
                                                                          shadowColorTapped:
                                                                              Color(0xFF966E36),
                                                                          locId:
                                                                              orangeSelectedChoiceChipsDCItem.idLoc,
                                                                          isSelected:
                                                                              orangeSelectedChoiceChipsDCItem.selected,
                                                                          listAreaTapped:
                                                                              Color(0xFFF8D499),
                                                                          listAreaUntapped:
                                                                              Color(0xFFF8EEDE),
                                                                          portionSum:
                                                                              orangeSelectedChoiceChipsDCItem.portionsum,
                                                                          isPreset:
                                                                              orangeSelectedChoiceChipsDCItem.presetBool,
                                                                          portionSize:
                                                                              orangeSelectedChoiceChipsDCItem.portionsize,
                                                                          plantCount:
                                                                              (plantCounter) async {
                                                                            FFAppState().orangeWeeklySelectedPlants =
                                                                                plantCounter!;
                                                                            FFAppState().totalWeeklySelectedPlants = FFAppState().redWeeklySelectedPlants +
                                                                                FFAppState().orangeWeeklySelectedPlants +
                                                                                FFAppState().yellowWeeklySelectedPlants +
                                                                                FFAppState().greenWeeklySelectedPlants +
                                                                                FFAppState().purpleWeeklySelectedPlants +
                                                                                FFAppState().brownWeeklySelectedPlants +
                                                                                FFAppState().whiteWeeklySelectedPlants;
                                                                            safeSetState(() {});
                                                                          },
                                                                        ),
                                                                      );
                                                                    }),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  40.0,
                                                                  0.0,
                                                                  40.0,
                                                                  0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.22,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFF9F5F0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: Color(
                                                                  0xFFFCE34D),
                                                              offset: Offset(
                                                                0.0,
                                                                0.0,
                                                              ),
                                                              spreadRadius: 2.0,
                                                            )
                                                          ],
                                                        ),
                                                        child: ListView(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Builder(
                                                                builder:
                                                                    (context) {
                                                                  final yellowSelectedChoiceChipsDC = FFAppState()
                                                                      .locplantselectionlist
                                                                      .where((e) =>
                                                                          e.color ==
                                                                          'Yellow')
                                                                      .toList()
                                                                      .sortedList(
                                                                          keyOf: (e) => e
                                                                              .plantname,
                                                                          desc:
                                                                              false)
                                                                      .toList();

                                                                  return Wrap(
                                                                    spacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 6.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 7.0;
                                                                        } else {
                                                                          return 8.0;
                                                                        }
                                                                      }(),
                                                                      8.0,
                                                                    ),
                                                                    runSpacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 8.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 10.0;
                                                                        } else {
                                                                          return 12.0;
                                                                        }
                                                                      }(),
                                                                      12.0,
                                                                    ),
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .start,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    runAlignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    verticalDirection:
                                                                        VerticalDirection
                                                                            .down,
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: List.generate(
                                                                        yellowSelectedChoiceChipsDC
                                                                            .length,
                                                                        (yellowSelectedChoiceChipsDCIndex) {
                                                                      final yellowSelectedChoiceChipsDCItem =
                                                                          yellowSelectedChoiceChipsDC[
                                                                              yellowSelectedChoiceChipsDCIndex];
                                                                      return wrapWithModel(
                                                                        model: _model
                                                                            .settingsChoiceChipModels3
                                                                            .getModel(
                                                                          yellowSelectedChoiceChipsDCItem
                                                                              .idLoc
                                                                              .toString(),
                                                                          yellowSelectedChoiceChipsDCIndex,
                                                                        ),
                                                                        updateCallback:
                                                                            () =>
                                                                                safeSetState(() {}),
                                                                        child:
                                                                            SettingsChoiceChipWidget(
                                                                          key:
                                                                              Key(
                                                                            'Keykkf_${yellowSelectedChoiceChipsDCItem.idLoc.toString()}',
                                                                          ),
                                                                          plantname:
                                                                              yellowSelectedChoiceChipsDCItem.plantname,
                                                                          color:
                                                                              yellowSelectedChoiceChipsDCItem.color,
                                                                          borderColorTapped:
                                                                              Color(0xFF8D8707),
                                                                          borderColorUntapped:
                                                                              Color(0xFF8F8F4A),
                                                                          colorTextUntapped:
                                                                              Color(0xFF6F6306),
                                                                          colorTextTapped:
                                                                              Color(0xFF453E07),
                                                                          colorContainerTapped:
                                                                              Color(0xFFF2ED3F),
                                                                          colorContainerUntapped:
                                                                              Color(0xFFF6F29D),
                                                                          shadowColorUntapped:
                                                                              Color(0xFFD8D59A),
                                                                          shadowColorTapped:
                                                                              Color(0xFF6F6812),
                                                                          locId:
                                                                              yellowSelectedChoiceChipsDCItem.idLoc,
                                                                          isSelected:
                                                                              yellowSelectedChoiceChipsDCItem.selected,
                                                                          listAreaTapped:
                                                                              Color(0xFFF9F8B3),
                                                                          listAreaUntapped:
                                                                              Color(0xFFFBFADF),
                                                                          portionSum:
                                                                              yellowSelectedChoiceChipsDCItem.portionsum,
                                                                          isPreset:
                                                                              yellowSelectedChoiceChipsDCItem.presetBool,
                                                                          portionSize:
                                                                              yellowSelectedChoiceChipsDCItem.portionsize,
                                                                          plantCount:
                                                                              (plantCounter) async {
                                                                            FFAppState().yellowWeeklySelectedPlants =
                                                                                plantCounter!;
                                                                            FFAppState().totalWeeklySelectedPlants = FFAppState().redWeeklySelectedPlants +
                                                                                FFAppState().orangeWeeklySelectedPlants +
                                                                                FFAppState().yellowWeeklySelectedPlants +
                                                                                FFAppState().greenWeeklySelectedPlants +
                                                                                FFAppState().purpleWeeklySelectedPlants +
                                                                                FFAppState().brownWeeklySelectedPlants +
                                                                                FFAppState().whiteWeeklySelectedPlants;
                                                                            safeSetState(() {});
                                                                          },
                                                                        ),
                                                                      );
                                                                    }),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  40.0,
                                                                  0.0,
                                                                  40.0,
                                                                  0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.22,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFF1F9F0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: Color(
                                                                  0xFF56FC4D),
                                                              offset: Offset(
                                                                0.0,
                                                                0.0,
                                                              ),
                                                              spreadRadius: 2.0,
                                                            )
                                                          ],
                                                        ),
                                                        child: ListView(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Builder(
                                                                builder:
                                                                    (context) {
                                                                  final greenSelectedChoiceChipsDC = FFAppState()
                                                                      .locplantselectionlist
                                                                      .where((e) =>
                                                                          e.color ==
                                                                          'Green')
                                                                      .toList()
                                                                      .sortedList(
                                                                          keyOf: (e) => e
                                                                              .plantname,
                                                                          desc:
                                                                              false)
                                                                      .toList();

                                                                  return Wrap(
                                                                    spacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 6.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 7.0;
                                                                        } else {
                                                                          return 8.0;
                                                                        }
                                                                      }(),
                                                                      8.0,
                                                                    ),
                                                                    runSpacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 8.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 10.0;
                                                                        } else {
                                                                          return 12.0;
                                                                        }
                                                                      }(),
                                                                      12.0,
                                                                    ),
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .start,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    runAlignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    verticalDirection:
                                                                        VerticalDirection
                                                                            .down,
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: List.generate(
                                                                        greenSelectedChoiceChipsDC
                                                                            .length,
                                                                        (greenSelectedChoiceChipsDCIndex) {
                                                                      final greenSelectedChoiceChipsDCItem =
                                                                          greenSelectedChoiceChipsDC[
                                                                              greenSelectedChoiceChipsDCIndex];
                                                                      return wrapWithModel(
                                                                        model: _model
                                                                            .settingsChoiceChipModels4
                                                                            .getModel(
                                                                          greenSelectedChoiceChipsDCItem
                                                                              .idLoc
                                                                              .toString(),
                                                                          greenSelectedChoiceChipsDCIndex,
                                                                        ),
                                                                        updateCallback:
                                                                            () =>
                                                                                safeSetState(() {}),
                                                                        child:
                                                                            SettingsChoiceChipWidget(
                                                                          key:
                                                                              Key(
                                                                            'Key74x_${greenSelectedChoiceChipsDCItem.idLoc.toString()}',
                                                                          ),
                                                                          plantname:
                                                                              greenSelectedChoiceChipsDCItem.plantname,
                                                                          color:
                                                                              greenSelectedChoiceChipsDCItem.color,
                                                                          borderColorTapped:
                                                                              Color(0xFF46A519),
                                                                          borderColorUntapped:
                                                                              Color(0xFF729C5F),
                                                                          colorTextUntapped:
                                                                              Color(0xFF0B870F),
                                                                          colorTextTapped:
                                                                              Color(0xFF0A4507),
                                                                          colorContainerTapped:
                                                                              Color(0xFF55F655),
                                                                          colorContainerUntapped:
                                                                              Color(0xFFAAF69D),
                                                                          shadowColorUntapped:
                                                                              Color(0xFFCECACA),
                                                                          shadowColorTapped:
                                                                              Color(0xFF148913),
                                                                          locId:
                                                                              greenSelectedChoiceChipsDCItem.idLoc,
                                                                          isSelected:
                                                                              greenSelectedChoiceChipsDCItem.selected,
                                                                          listAreaTapped:
                                                                              Color(0xFFABFDAB),
                                                                          listAreaUntapped:
                                                                              Color(0xFFDBF9D5),
                                                                          portionSum:
                                                                              greenSelectedChoiceChipsDCItem.portionsum,
                                                                          isPreset:
                                                                              greenSelectedChoiceChipsDCItem.presetBool,
                                                                          portionSize:
                                                                              greenSelectedChoiceChipsDCItem.portionsize,
                                                                          plantCount:
                                                                              (plantCounter) async {
                                                                            FFAppState().greenWeeklySelectedPlants =
                                                                                plantCounter!;
                                                                            FFAppState().totalWeeklySelectedPlants = FFAppState().redWeeklySelectedPlants +
                                                                                FFAppState().orangeWeeklySelectedPlants +
                                                                                FFAppState().yellowWeeklySelectedPlants +
                                                                                FFAppState().greenWeeklySelectedPlants +
                                                                                FFAppState().purpleWeeklySelectedPlants +
                                                                                FFAppState().brownWeeklySelectedPlants +
                                                                                FFAppState().whiteWeeklySelectedPlants;
                                                                            safeSetState(() {});
                                                                          },
                                                                        ),
                                                                      );
                                                                    }),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  40.0,
                                                                  0.0,
                                                                  40.0,
                                                                  0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.22,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFF8EFF9),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: Color(
                                                                  0xFFC94DFC),
                                                              offset: Offset(
                                                                0.0,
                                                                0.0,
                                                              ),
                                                              spreadRadius: 2.0,
                                                            )
                                                          ],
                                                        ),
                                                        child: ListView(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Builder(
                                                                builder:
                                                                    (context) {
                                                                  final purpleSelectedChoiceChipsDC = FFAppState()
                                                                      .locplantselectionlist
                                                                      .where((e) =>
                                                                          e.color ==
                                                                          'Purple')
                                                                      .toList()
                                                                      .sortedList(
                                                                          keyOf: (e) => e
                                                                              .plantname,
                                                                          desc:
                                                                              false)
                                                                      .toList();

                                                                  return Wrap(
                                                                    spacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 6.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 7.0;
                                                                        } else {
                                                                          return 8.0;
                                                                        }
                                                                      }(),
                                                                      8.0,
                                                                    ),
                                                                    runSpacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 8.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 10.0;
                                                                        } else {
                                                                          return 12.0;
                                                                        }
                                                                      }(),
                                                                      12.0,
                                                                    ),
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .start,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    runAlignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    verticalDirection:
                                                                        VerticalDirection
                                                                            .down,
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: List.generate(
                                                                        purpleSelectedChoiceChipsDC
                                                                            .length,
                                                                        (purpleSelectedChoiceChipsDCIndex) {
                                                                      final purpleSelectedChoiceChipsDCItem =
                                                                          purpleSelectedChoiceChipsDC[
                                                                              purpleSelectedChoiceChipsDCIndex];
                                                                      return wrapWithModel(
                                                                        model: _model
                                                                            .settingsChoiceChipModels5
                                                                            .getModel(
                                                                          purpleSelectedChoiceChipsDCItem
                                                                              .idLoc
                                                                              .toString(),
                                                                          purpleSelectedChoiceChipsDCIndex,
                                                                        ),
                                                                        updateCallback:
                                                                            () =>
                                                                                safeSetState(() {}),
                                                                        child:
                                                                            SettingsChoiceChipWidget(
                                                                          key:
                                                                              Key(
                                                                            'Keyjj2_${purpleSelectedChoiceChipsDCItem.idLoc.toString()}',
                                                                          ),
                                                                          plantname:
                                                                              purpleSelectedChoiceChipsDCItem.plantname,
                                                                          color:
                                                                              purpleSelectedChoiceChipsDCItem.color,
                                                                          borderColorTapped:
                                                                              Color(0xFF8926B2),
                                                                          borderColorUntapped:
                                                                              Color(0xFFBE77DB),
                                                                          colorTextUntapped:
                                                                              Color(0xFF762DAB),
                                                                          colorTextTapped:
                                                                              Color(0xFF290745),
                                                                          colorContainerTapped:
                                                                              Color(0xFFD48BF9),
                                                                          colorContainerUntapped:
                                                                              Color(0xFFE6CCF4),
                                                                          shadowColorUntapped:
                                                                              Color(0xFFCECACA),
                                                                          shadowColorTapped:
                                                                              Color(0xFF5C1389),
                                                                          locId:
                                                                              purpleSelectedChoiceChipsDCItem.idLoc,
                                                                          isSelected:
                                                                              purpleSelectedChoiceChipsDCItem.selected,
                                                                          listAreaTapped:
                                                                              Color(0xFFE2B3F9),
                                                                          listAreaUntapped:
                                                                              Color(0xFFF2E5F9),
                                                                          portionSum:
                                                                              purpleSelectedChoiceChipsDCItem.portionsum,
                                                                          isPreset:
                                                                              purpleSelectedChoiceChipsDCItem.presetBool,
                                                                          portionSize:
                                                                              purpleSelectedChoiceChipsDCItem.portionsize,
                                                                          plantCount:
                                                                              (plantCounter) async {
                                                                            FFAppState().purpleWeeklySelectedPlants =
                                                                                plantCounter!;
                                                                            FFAppState().totalWeeklySelectedPlants = FFAppState().redWeeklySelectedPlants +
                                                                                FFAppState().orangeWeeklySelectedPlants +
                                                                                FFAppState().yellowWeeklySelectedPlants +
                                                                                FFAppState().greenWeeklySelectedPlants +
                                                                                FFAppState().purpleWeeklySelectedPlants +
                                                                                FFAppState().brownWeeklySelectedPlants +
                                                                                FFAppState().whiteWeeklySelectedPlants;
                                                                            safeSetState(() {});
                                                                          },
                                                                        ),
                                                                      );
                                                                    }),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  40.0,
                                                                  0.0,
                                                                  40.0,
                                                                  0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.22,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFF1EAE1),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: Color(
                                                                  0xFF854E12),
                                                              offset: Offset(
                                                                0.0,
                                                                0.0,
                                                              ),
                                                              spreadRadius: 2.0,
                                                            )
                                                          ],
                                                        ),
                                                        child: ListView(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Builder(
                                                                builder:
                                                                    (context) {
                                                                  final brownSelectedChoiceChipsDC = FFAppState()
                                                                      .locplantselectionlist
                                                                      .where((e) =>
                                                                          e.color ==
                                                                          'Brown')
                                                                      .toList()
                                                                      .sortedList(
                                                                          keyOf: (e) => e
                                                                              .plantname,
                                                                          desc:
                                                                              false)
                                                                      .toList();

                                                                  return Wrap(
                                                                    spacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 6.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 7.0;
                                                                        } else {
                                                                          return 8.0;
                                                                        }
                                                                      }(),
                                                                      8.0,
                                                                    ),
                                                                    runSpacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 8.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 10.0;
                                                                        } else {
                                                                          return 12.0;
                                                                        }
                                                                      }(),
                                                                      12.0,
                                                                    ),
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .start,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    runAlignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    verticalDirection:
                                                                        VerticalDirection
                                                                            .down,
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: List.generate(
                                                                        brownSelectedChoiceChipsDC
                                                                            .length,
                                                                        (brownSelectedChoiceChipsDCIndex) {
                                                                      final brownSelectedChoiceChipsDCItem =
                                                                          brownSelectedChoiceChipsDC[
                                                                              brownSelectedChoiceChipsDCIndex];
                                                                      return wrapWithModel(
                                                                        model: _model
                                                                            .settingsChoiceChipModels6
                                                                            .getModel(
                                                                          brownSelectedChoiceChipsDCItem
                                                                              .idLoc
                                                                              .toString(),
                                                                          brownSelectedChoiceChipsDCIndex,
                                                                        ),
                                                                        updateCallback:
                                                                            () =>
                                                                                safeSetState(() {}),
                                                                        child:
                                                                            SettingsChoiceChipWidget(
                                                                          key:
                                                                              Key(
                                                                            'Key5d2_${brownSelectedChoiceChipsDCItem.idLoc.toString()}',
                                                                          ),
                                                                          plantname:
                                                                              brownSelectedChoiceChipsDCItem.plantname,
                                                                          color:
                                                                              brownSelectedChoiceChipsDCItem.color,
                                                                          borderColorTapped:
                                                                              Color(0xFF8B6737),
                                                                          borderColorUntapped:
                                                                              Color(0xFFBC9768),
                                                                          colorTextUntapped:
                                                                              Color(0xFF74542E),
                                                                          colorTextTapped:
                                                                              Color(0xFF543412),
                                                                          colorContainerTapped:
                                                                              Color(0xFFCBB6A3),
                                                                          colorContainerUntapped:
                                                                              Color(0xFFE8DCCF),
                                                                          shadowColorUntapped:
                                                                              Color(0xFFD4BEA7),
                                                                          shadowColorTapped:
                                                                              Color(0xFF634415),
                                                                          locId:
                                                                              brownSelectedChoiceChipsDCItem.idLoc,
                                                                          isSelected:
                                                                              brownSelectedChoiceChipsDCItem.selected,
                                                                          listAreaTapped:
                                                                              Color(0xFFE7D0C1),
                                                                          listAreaUntapped:
                                                                              Color(0xFFF0E5DE),
                                                                          portionSum:
                                                                              brownSelectedChoiceChipsDCItem.portionsum,
                                                                          isPreset:
                                                                              brownSelectedChoiceChipsDCItem.presetBool,
                                                                          portionSize:
                                                                              brownSelectedChoiceChipsDCItem.portionsize,
                                                                          plantCount:
                                                                              (plantCounter) async {
                                                                            FFAppState().brownWeeklySelectedPlants =
                                                                                plantCounter!;
                                                                            FFAppState().totalWeeklySelectedPlants = FFAppState().redWeeklySelectedPlants +
                                                                                FFAppState().orangeWeeklySelectedPlants +
                                                                                FFAppState().yellowWeeklySelectedPlants +
                                                                                FFAppState().greenWeeklySelectedPlants +
                                                                                FFAppState().purpleWeeklySelectedPlants +
                                                                                FFAppState().brownWeeklySelectedPlants +
                                                                                FFAppState().whiteWeeklySelectedPlants;
                                                                            safeSetState(() {});
                                                                          },
                                                                        ),
                                                                      );
                                                                    }),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  40.0,
                                                                  0.0,
                                                                  40.0,
                                                                  10.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.22,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFF4F4F4),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: Color(
                                                                  0xFFACADAC),
                                                              offset: Offset(
                                                                0.0,
                                                                0.0,
                                                              ),
                                                              spreadRadius: 2.0,
                                                            )
                                                          ],
                                                        ),
                                                        child: ListView(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Builder(
                                                                builder:
                                                                    (context) {
                                                                  final whiteSelectedChoiceChipsDC = FFAppState()
                                                                      .locplantselectionlist
                                                                      .where((e) =>
                                                                          e.color ==
                                                                          'White')
                                                                      .toList()
                                                                      .sortedList(
                                                                          keyOf: (e) => e
                                                                              .plantname,
                                                                          desc:
                                                                              false)
                                                                      .toList();

                                                                  return Wrap(
                                                                    spacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 6.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 7.0;
                                                                        } else {
                                                                          return 8.0;
                                                                        }
                                                                      }(),
                                                                      8.0,
                                                                    ),
                                                                    runSpacing:
                                                                        valueOrDefault<
                                                                            double>(
                                                                      () {
                                                                        if (FFAppState().screenCategory ==
                                                                            'small') {
                                                                          return 8.0;
                                                                        } else if (FFAppState().screenCategory ==
                                                                            'medium') {
                                                                          return 10.0;
                                                                        } else {
                                                                          return 12.0;
                                                                        }
                                                                      }(),
                                                                      12.0,
                                                                    ),
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .start,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    runAlignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    verticalDirection:
                                                                        VerticalDirection
                                                                            .down,
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: List.generate(
                                                                        whiteSelectedChoiceChipsDC
                                                                            .length,
                                                                        (whiteSelectedChoiceChipsDCIndex) {
                                                                      final whiteSelectedChoiceChipsDCItem =
                                                                          whiteSelectedChoiceChipsDC[
                                                                              whiteSelectedChoiceChipsDCIndex];
                                                                      return wrapWithModel(
                                                                        model: _model
                                                                            .settingsChoiceChipModels7
                                                                            .getModel(
                                                                          whiteSelectedChoiceChipsDCItem
                                                                              .idLoc
                                                                              .toString(),
                                                                          whiteSelectedChoiceChipsDCIndex,
                                                                        ),
                                                                        updateCallback:
                                                                            () =>
                                                                                safeSetState(() {}),
                                                                        child:
                                                                            SettingsChoiceChipWidget(
                                                                          key:
                                                                              Key(
                                                                            'Keysrs_${whiteSelectedChoiceChipsDCItem.idLoc.toString()}',
                                                                          ),
                                                                          plantname:
                                                                              whiteSelectedChoiceChipsDCItem.plantname,
                                                                          color:
                                                                              whiteSelectedChoiceChipsDCItem.color,
                                                                          borderColorTapped:
                                                                              Color(0xFF707070),
                                                                          borderColorUntapped:
                                                                              Color(0xFFA9A7A7),
                                                                          colorTextUntapped:
                                                                              Color(0xFF585858),
                                                                          colorTextTapped:
                                                                              Color(0xFF363636),
                                                                          colorContainerTapped:
                                                                              Color(0xFFC1C0C0),
                                                                          colorContainerUntapped:
                                                                              Color(0xFFE3E2E2),
                                                                          shadowColorUntapped:
                                                                              Color(0xFFBAB8B8),
                                                                          shadowColorTapped:
                                                                              Color(0xFF515151),
                                                                          locId:
                                                                              whiteSelectedChoiceChipsDCItem.idLoc,
                                                                          isSelected:
                                                                              whiteSelectedChoiceChipsDCItem.selected,
                                                                          listAreaTapped:
                                                                              Color(0xFFE1E1E1),
                                                                          listAreaUntapped:
                                                                              Color(0xFFF2F2F2),
                                                                          portionSum:
                                                                              whiteSelectedChoiceChipsDCItem.portionsum,
                                                                          isPreset:
                                                                              whiteSelectedChoiceChipsDCItem.presetBool,
                                                                          portionSize:
                                                                              whiteSelectedChoiceChipsDCItem.portionsize,
                                                                          plantCount:
                                                                              (plantCounter) async {
                                                                            FFAppState().whiteWeeklySelectedPlants =
                                                                                plantCounter!;
                                                                            FFAppState().totalWeeklySelectedPlants = FFAppState().redWeeklySelectedPlants +
                                                                                FFAppState().orangeWeeklySelectedPlants +
                                                                                FFAppState().yellowWeeklySelectedPlants +
                                                                                FFAppState().greenWeeklySelectedPlants +
                                                                                FFAppState().purpleWeeklySelectedPlants +
                                                                                FFAppState().brownWeeklySelectedPlants +
                                                                                FFAppState().whiteWeeklySelectedPlants;
                                                                            safeSetState(() {});
                                                                          },
                                                                        ),
                                                                      );
                                                                    }),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 15.0)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 5.0, 0.0, 10.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Material(
                                              color: Colors.transparent,
                                              elevation: 1.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.95,
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.06,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: Color(
                                                                  0x33000000),
                                                              offset: Offset(
                                                                2.0,
                                                                2.0,
                                                              ),
                                                              spreadRadius: 0.0,
                                                            )
                                                          ],
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Color(0x7FFFFFFF),
                                                              Color(0x53F83B46),
                                                              Color(0x57FF8700),
                                                              Color(0x63FBE403),
                                                              Color(0x4500E4FF),
                                                              Color(0x3A6D00FF),
                                                              Color(0x4AF500FF),
                                                              Color(0x68FF00CE)
                                                            ],
                                                            stops: [
                                                              0.0,
                                                              0.15,
                                                              0.29,
                                                              0.4,
                                                              0.5,
                                                              0.61,
                                                              0.73,
                                                              0.87
                                                            ],
                                                            begin:
                                                                AlignmentDirectional(
                                                                    0.34, -1.0),
                                                            end:
                                                                AlignmentDirectional(
                                                                    -0.34, 1.0),
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Text(
                                                            valueOrDefault<
                                                                String>(
                                                              FFAppState()
                                                                  .totalWeeklySelectedPlants
                                                                  .toString(),
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
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0x7DF80606),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: Color(
                                                                  0x33000000),
                                                              offset: Offset(
                                                                2.0,
                                                                2.0,
                                                              ),
                                                              spreadRadius: 0.0,
                                                            )
                                                          ],
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            FFAppState()
                                                                .redWeeklySelectedPlants
                                                                .toString(),
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
                                                                      return 13.0;
                                                                    } else {
                                                                      return 14.0;
                                                                    }
                                                                  }(),
                                                                  14.0,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0x83F46805),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: Color(
                                                                  0x33000000),
                                                              offset: Offset(
                                                                2.0,
                                                                2.0,
                                                              ),
                                                              spreadRadius: 0.0,
                                                            )
                                                          ],
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            FFAppState()
                                                                .orangeWeeklySelectedPlants
                                                                .toString(),
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
                                                                      return 13.0;
                                                                    } else {
                                                                      return 14.0;
                                                                    }
                                                                  }(),
                                                                  14.0,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          0.08,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0x8BFFED00),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 2.0,
                                                            color: Color(
                                                                0x33000000),
                                                            offset: Offset(
                                                              2.0,
                                                              2.0,
                                                            ),
                                                            spreadRadius: 0.0,
                                                          )
                                                        ],
                                                        shape: BoxShape.circle,
                                                      ),
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Text(
                                                        valueOrDefault<String>(
                                                          FFAppState()
                                                              .yellowWeeklySelectedPlants
                                                              .toString(),
                                                          '0',
                                                        ),
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0x863CFF00),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: Color(
                                                                  0x33000000),
                                                              offset: Offset(
                                                                2.0,
                                                                2.0,
                                                              ),
                                                              spreadRadius: 0.0,
                                                            )
                                                          ],
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            FFAppState()
                                                                .greenWeeklySelectedPlants
                                                                .toString(),
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
                                                                      return 13.0;
                                                                    } else {
                                                                      return 14.0;
                                                                    }
                                                                  }(),
                                                                  14.0,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0x8BAF01FF),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: Color(
                                                                  0x33000000),
                                                              offset: Offset(
                                                                2.0,
                                                                2.0,
                                                              ),
                                                              spreadRadius: 0.0,
                                                            )
                                                          ],
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            FFAppState()
                                                                .purpleWeeklySelectedPlants
                                                                .toString(),
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
                                                                      return 13.0;
                                                                    } else {
                                                                      return 14.0;
                                                                    }
                                                                  }(),
                                                                  14.0,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0x816E3105),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: Color(
                                                                  0x33000000),
                                                              offset: Offset(
                                                                2.0,
                                                                2.0,
                                                              ),
                                                              spreadRadius: 0.0,
                                                            )
                                                          ],
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            FFAppState()
                                                                .brownWeeklySelectedPlants
                                                                .toString(),
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
                                                                      return 13.0;
                                                                    } else {
                                                                      return 14.0;
                                                                    }
                                                                  }(),
                                                                  14.0,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2.0,
                                                              color: Color(
                                                                  0x33000000),
                                                              offset: Offset(
                                                                2.0,
                                                                2.0,
                                                              ),
                                                              spreadRadius: 0.0,
                                                            )
                                                          ],
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            FFAppState()
                                                                .whiteWeeklySelectedPlants
                                                                .toString(),
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
                                                                      return 13.0;
                                                                    } else {
                                                                      return 14.0;
                                                                    }
                                                                  }(),
                                                                  14.0,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
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
                                    ],
                                  ),
                                ),
                                KeepAliveWidgetWrapper(
                                  builder: (context) => Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [],
                                  ),
                                ),
                                KeepAliveWidgetWrapper(
                                  builder: (context) => Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 5.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, -1.0),
                                                        child: Text(
                                                          'Data request control',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                fontSize: 16.0,
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
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Manage all data requests at a glance',
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
                                                ),
                                                Divider(
                                                  thickness: 2.0,
                                                  indent: 10.0,
                                                  endIndent: 10.0,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent4,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 10.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              FutureBuilder<
                                                  List<DatacontractRow>>(
                                                future: DatacontractTable()
                                                    .queryRows(
                                                  queryFn: (q) => q,
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 25.0,
                                                        height: 25.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            Color(0xFF0F26C0),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<DatacontractRow>
                                                      containerDatacontractRowList =
                                                      snapshot.data!;

                                                  return Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          1.0,
                                                      child: Stack(
                                                        children: [
                                                          if (FFAppState()
                                                                  .hasSubscription ==
                                                              false)
                                                            SingleChildScrollView(
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
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.8,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.2,
                                                                        decoration:
                                                                            BoxDecoration(),
                                                                        alignment: AlignmentDirectional(
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          'Give and take. \nPlease subscribe so you can access community insights and anonymously share your data with the community.',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                fontSize: valueOrDefault<double>(
                                                                                  () {
                                                                                    if (FFAppState().screenCategory == 'small') {
                                                                                      return 16.0;
                                                                                    } else if (FFAppState().screenCategory == 'medium') {
                                                                                      return 18.0;
                                                                                    } else {
                                                                                      return 20.0;
                                                                                    }
                                                                                  }(),
                                                                                  20.0,
                                                                                ),
                                                                                letterSpacing: 0.0,
                                                                                fontStyle: FontStyle.italic,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
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
                                                                          context
                                                                              .pushNamed(
                                                                            SettingsWidget.routeName,
                                                                            queryParameters:
                                                                                {
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
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 0.4,
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.2,
                                                                            fit:
                                                                                BoxFit.fitHeight,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          if (FFAppState()
                                                                  .hasSubscription ==
                                                              true)
                                                            Builder(
                                                              builder:
                                                                  (context) {
                                                                final datacontractDC =
                                                                    containerDatacontractRowList
                                                                        .toList();

                                                                return ListView
                                                                    .separated(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .fromLTRB(
                                                                    0,
                                                                    5.0,
                                                                    0,
                                                                    5.0,
                                                                  ),
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  itemCount:
                                                                      datacontractDC
                                                                          .length,
                                                                  separatorBuilder: (_,
                                                                          __) =>
                                                                      SizedBox(
                                                                          height:
                                                                              15.0),
                                                                  itemBuilder:
                                                                      (context,
                                                                          datacontractDCIndex) {
                                                                    final datacontractDCItem =
                                                                        datacontractDC[
                                                                            datacontractDCIndex];
                                                                    return wrapWithModel(
                                                                      model: _model
                                                                          .dataContractEntryModels
                                                                          .getModel(
                                                                        datacontractDCItem
                                                                            .id
                                                                            .toString(),
                                                                        datacontractDCIndex,
                                                                      ),
                                                                      updateCallback:
                                                                          () =>
                                                                              safeSetState(() {}),
                                                                      child:
                                                                          DataContractEntryWidget(
                                                                        key:
                                                                            Key(
                                                                          'Keyyzj_${datacontractDCItem.id.toString()}',
                                                                        ),
                                                                        contractName:
                                                                            valueOrDefault<String>(
                                                                          datacontractDCItem
                                                                              .contractName,
                                                                          'dummy',
                                                                        ),
                                                                        validityType:
                                                                            valueOrDefault<String>(
                                                                          datacontractDCItem
                                                                              .validityType,
                                                                          'n/a',
                                                                        ),
                                                                        contractId:
                                                                            datacontractDCItem.id,
                                                                        description:
                                                                            valueOrDefault<String>(
                                                                          datacontractDCItem
                                                                              .description,
                                                                          'dummy',
                                                                        ),
                                                                        status:
                                                                            datacontractDCItem.status!,
                                                                        contractType:
                                                                            datacontractDCItem.contractType!,
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                        ],
                                                      ),
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
                                KeepAliveWidgetWrapper(
                                  builder: (context) => SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  1.0,
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.69,
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            'Subscription page \n(in construction)',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  fontSize:
                                                                      32.0,
                                                                  letterSpacing:
                                                                      0.0,
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
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            10.0),
                                                                    child: Text(
                                                                      'Simulate subscription',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            fontSize:
                                                                                20.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            10.0),
                                                                    child: Text(
                                                                      '(toggle for testing)',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontStyle:
                                                                                FontStyle.italic,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                                            0.0,
                                                                            10.0,
                                                                            0.0,
                                                                            10.0),
                                                                    child:
                                                                        FlutterFlowDropDown<
                                                                            bool>(
                                                                      controller: _model
                                                                              .subDropdownValueController ??=
                                                                          FormFieldController<
                                                                              bool>(
                                                                        _model.subDropdownValue ??=
                                                                            FFAppState().hasSubscription,
                                                                      ),
                                                                      options: List<
                                                                          bool>.from([
                                                                        true,
                                                                        false
                                                                      ]),
                                                                      optionLabels: [
                                                                        'YES',
                                                                        'NO'
                                                                      ],
                                                                      onChanged:
                                                                          (val) =>
                                                                              safeSetState(() => _model.subDropdownValue = val),
                                                                      width:
                                                                          200.0,
                                                                      height:
                                                                          40.0,
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                      hintText:
                                                                          'Select...',
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .keyboard_arrow_down_rounded,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                      fillColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondaryBackground,
                                                                      elevation:
                                                                          2.0,
                                                                      borderColor:
                                                                          Colors
                                                                              .transparent,
                                                                      borderWidth:
                                                                          0.0,
                                                                      borderRadius:
                                                                          8.0,
                                                                      margin: EdgeInsetsDirectional.fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          12.0,
                                                                          0.0),
                                                                      hidesUnderline:
                                                                          true,
                                                                      isOverButton:
                                                                          false,
                                                                      isSearchable:
                                                                          false,
                                                                      isMultiSelect:
                                                                          false,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await UsersTable()
                                                                          .update(
                                                                        data: {
                                                                          'has_subscription':
                                                                              _model.subDropdownValue,
                                                                        },
                                                                        matchingRows:
                                                                            (rows) =>
                                                                                rows.eqOrNull(
                                                                          'id',
                                                                          currentUserUid,
                                                                        ),
                                                                      );
                                                                      FFAppState()
                                                                              .hasSubscription =
                                                                          _model
                                                                              .subDropdownValue!;
                                                                      safeSetState(
                                                                          () {});
                                                                      if (FFAppState()
                                                                              .hasSubscription ==
                                                                          false) {
                                                                        await showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (alertDialogContext) {
                                                                            return AlertDialog(
                                                                              title: Text('Subscription Status'),
                                                                              content: Text('You are now unsubscribed (simulation). '),
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.pop(alertDialogContext),
                                                                                  child: Text('Ok'),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      } else {
                                                                        await showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (alertDialogContext) {
                                                                            return AlertDialog(
                                                                              title: Text('Subscription Status'),
                                                                              content: Text('You are now subscribed (simulation). '),
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.pop(alertDialogContext),
                                                                                  child: Text('Ok'),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      }

                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                    text:
                                                                        'Update',
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width *
                                                                          0.3,
                                                                      height: MediaQuery.sizeOf(context)
                                                                              .height *
                                                                          0.05,
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).titleSmallFamily,
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 14.0;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 16.0;
                                                                                } else {
                                                                                  return 18.0;
                                                                                }
                                                                              }(),
                                                                              18.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                          ),
                                                                      elevation:
                                                                          5.0,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
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
                                                ],
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          safeSetState(() => _model.settingsPlantsController = null);
        },
        onSkip: () {
          return true;
        },
      );
}
