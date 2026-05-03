import '/backend/supabase/supabase.dart';
import '/components/agrimethod_data_entry/agrimethod_data_entry_widget.dart';
import '/components/blueprint_data_entry/blueprint_data_entry_widget.dart';
import '/components/climate_condition_data_entry/climate_condition_data_entry_widget.dart';
import '/components/create_data_list_item/create_data_list_item_widget.dart';
import '/components/localize_data_entry/localize_data_entry_widget.dart';
import '/components/nutrient_data_entry/nutrient_data_entry_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'administration_model.dart';
export 'administration_model.dart';

class AdministrationWidget extends StatefulWidget {
  const AdministrationWidget({super.key});

  static String routeName = 'Administration';
  static String routePath = '/administration';

  @override
  State<AdministrationWidget> createState() => _AdministrationWidgetState();
}

class _AdministrationWidgetState extends State<AdministrationWidget>
    with TickerProviderStateMixin {
  late AdministrationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdministrationModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 6,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

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

    return FutureBuilder<List<BlueprintplantRow>>(
      future: BlueprintplantTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'priority',
              'A',
            )
            .order('name', ascending: true),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: SizedBox(
                width: 25.0,
                height: 25.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF0F26C0),
                  ),
                ),
              ),
            ),
          );
        }
        List<BlueprintplantRow> administrationBlueprintplantRowList =
            snapshot.data!;

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
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
                                    if (FFAppState().screenCategory ==
                                        'small') {
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
                                'Administration',
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
                                      color: FlutterFlowTheme.of(context)
                                          .tertiaryText,
                                      fontSize: () {
                                        if (FFAppState().screenCategory ==
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
                                  );
                                },
                                child: Icon(
                                  Icons.settings_outlined,
                                  color:
                                      FlutterFlowTheme.of(context).tertiaryText,
                                  size: () {
                                    if (FFAppState().screenCategory ==
                                        'small') {
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
                  Flexible(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment(0.0, 0),
                          child: TabBar(
                            labelColor: FlutterFlowTheme.of(context).secondary2,
                            unselectedLabelColor:
                                FlutterFlowTheme.of(context).tertiaryText,
                            labelPadding: EdgeInsets.all(2.0),
                            labelStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleLargeFamily,
                                  fontSize: valueOrDefault<double>(
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
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .titleLargeIsCustom,
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
                                      } else if (FFAppState().screenCategory ==
                                          'medium') {
                                        return 12.0;
                                      } else {
                                        return 13.0;
                                      }
                                    }(),
                                    13.0,
                                  ),
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelSmallIsCustom,
                                ),
                            indicatorColor:
                                FlutterFlowTheme.of(context).secondary2,
                            indicatorWeight: 4.0,
                            padding: EdgeInsets.all(6.0),
                            tabs: [
                              Tab(
                                text: 'Blueprint',
                                iconMargin: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 5.0, 0.0),
                              ),
                              Tab(
                                text: 'Nutrient',
                              ),
                              Tab(
                                text: 'Climate ',
                              ),
                              Tab(
                                text: 'Agro',
                              ),
                              Tab(
                                text: 'Localize',
                              ),
                              Tab(
                                text: 'Contracts',
                              ),
                            ],
                            controller: _model.tabBarController,
                            onTap: (i) async {
                              [
                                () async {},
                                () async {},
                                () async {},
                                () async {},
                                () async {},
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
                                builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 5.0, 10.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, -1.0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            'Blueprint plants',
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
                                                      ),
                                                    ),
                                                    Text(
                                                      administrationBlueprintplantRowList
                                                          .length
                                                          .toString(),
                                                      style: FlutterFlowTheme
                                                              .of(context)
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
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Create, Read, Update, Delete (CRUD)',
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
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
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
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        wrapWithModel(
                                          model: _model.blueprintDataEntryModel,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: BlueprintDataEntryWidget(),
                                        ),
                                      ],
                                    ),
                                  ],
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
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 5.0, 10.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1.0, -1.0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    10.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          'Micro and macro nutrients',
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
                                                                  10.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Enter nutrients name and description.',
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
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
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
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        wrapWithModel(
                                          model: _model.nutrientDataEntryModel,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: NutrientDataEntryWidget(),
                                        ),
                                      ],
                                    ),
                                  ],
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
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 5.0, 10.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Climate conditions',
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
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Climate conditions of plant growth region',
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
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
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
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        wrapWithModel(
                                          model: _model
                                              .climateConditionDataEntryModel,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child:
                                              ClimateConditionDataEntryWidget(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              KeepAliveWidgetWrapper(
                                builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 5.0, 10.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Agriculture',
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
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Manage agricultural methods',
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
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
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
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        wrapWithModel(
                                          model:
                                              _model.agrimethodDataEntryModel,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: AgrimethodDataEntryWidget(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              KeepAliveWidgetWrapper(
                                builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 5.0, 10.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Plant localization',
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
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Create localized plant list for user presentation',
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
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
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
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        wrapWithModel(
                                          model: _model.localizeDataEntryModel,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: LocalizeDataEntryWidget(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              KeepAliveWidgetWrapper(
                                builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 5.0, 10.0, 0.0),
                                            child: SingleChildScrollView(
                                              primary: false,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, -1.0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            'Data contract creation',
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
                                                                    10.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          'Select indicators for data sharing contracts',
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
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
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
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        wrapWithModel(
                                          model: _model.createDataListItemModel,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: CreateDataListItemWidget(),
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          height: MediaQuery.sizeOf(context).height * 0.06,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
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
                                  color:
                                      FlutterFlowTheme.of(context).secondary2,
                                  size: () {
                                    if (FFAppState().screenCategory ==
                                        'small') {
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
                                      if (FFAppState().screenCategory ==
                                          'small') {
                                        return 26.0;
                                      } else if (FFAppState().screenCategory ==
                                          'medium') {
                                        return 28.0;
                                      } else {
                                        return 30.0;
                                      }
                                    }(),
                                    height: () {
                                      if (FFAppState().screenCategory ==
                                          'small') {
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
                                  color:
                                      FlutterFlowTheme.of(context).tertiaryText,
                                  size: valueOrDefault<double>(
                                    () {
                                      if (FFAppState().screenCategory ==
                                          'small') {
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
                                  color:
                                      FlutterFlowTheme.of(context).tertiaryText,
                                  size: () {
                                    if (FFAppState().screenCategory ==
                                        'small') {
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
                                  color:
                                      FlutterFlowTheme.of(context).tertiaryText,
                                  size: () {
                                    if (FFAppState().screenCategory ==
                                        'small') {
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
                                  color:
                                      FlutterFlowTheme.of(context).tertiaryText,
                                  size: () {
                                    if (FFAppState().screenCategory ==
                                        'small') {
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
                                  color:
                                      FlutterFlowTheme.of(context).tertiaryText,
                                  size: () {
                                    if (FFAppState().screenCategory ==
                                        'small') {
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
      },
    );
  }
}
