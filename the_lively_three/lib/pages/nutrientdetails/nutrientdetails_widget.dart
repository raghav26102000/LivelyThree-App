import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/nutrient_value/nutrient_value_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'nutrientdetails_model.dart';
export 'nutrientdetails_model.dart';

class NutrientdetailsWidget extends StatefulWidget {
  const NutrientdetailsWidget({
    super.key,
    required this.blueprintindex,
    required this.blueprintlabel,
  });

  final int? blueprintindex;
  final String? blueprintlabel;

  static String routeName = 'Nutrientdetails';
  static String routePath = '/nutrientdetails';

  @override
  State<NutrientdetailsWidget> createState() => _NutrientdetailsWidgetState();
}

class _NutrientdetailsWidgetState extends State<NutrientdetailsWidget> {
  late NutrientdetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NutrientdetailsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          _model.nutrientOutput = await NutrientTable().queryRows(
            queryFn: (q) => q
                .order('category', ascending: true)
                .order('name', ascending: true),
          );
          _model.nutrientmax = _model.nutrientOutput!.length;
          safeSetState(() {});
        }),
        Future(() async {
          _model.relBlueNutrientOutput =
              await ViewNutrientperplantTable().queryRows(
            queryFn: (q) => q.eqOrNull(
              'id_plant',
              widget!.blueprintindex,
            ),
          );
          _model.relmax = _model.relBlueNutrientOutput?.length;
          safeSetState(() {});
        }),
        Future(() async {
          _model.viewBlueNutrientOutput =
              await ViewNutrientperplantTable().queryRows(
            queryFn: (q) => q
                .eqOrNull(
                  'id_plant',
                  widget!.blueprintindex,
                )
                .order('nutrientname', ascending: true),
          );
        }),
      ]);
      if (_model.relmax! < 1) {
        _model.counter = 0;
        safeSetState(() {});
        while (_model.counter < _model.nutrientmax) {
          _model.insertOutput = await NutrientperplantTable().insert({
            'created_at': supaSerialize<DateTime>(getCurrentTimestamp),
            'id_nutrient':
                _model.nutrientOutput?.elementAtOrNull(_model.counter)?.id,
            'value': 0.0,
            'reference': 'n/a',
            'description': 'n/a',
            'id_plant': widget!.blueprintindex,
          });
          FFAppState().addToNutrientAppStateList(NutrientDataTypeStruct(
            id: _model.counter,
            nutrientLabel:
                _model.nutrientOutput?.elementAtOrNull(_model.counter)?.name,
            idNutrient:
                _model.nutrientOutput?.elementAtOrNull(_model.counter)?.id,
            idBlueprint: widget!.blueprintindex,
            nutrientValue: 0.00,
            nutrientDescription: 'n/a',
            nutrientReference: 'n/a',
          ));
          safeSetState(() {});
          _model.counter = _model.counter + 1;
          safeSetState(() {});
        }
      } else {
        if (_model.nutrientmax == _model.relmax) {
          _model.counter = 0;
          safeSetState(() {});
          while (_model.counter < _model.nutrientmax) {
            FFAppState().addToNutrientAppStateList(NutrientDataTypeStruct(
              id: _model.counter,
              nutrientLabel: _model.viewBlueNutrientOutput
                  ?.elementAtOrNull(_model.counter)
                  ?.nutrientname,
              idNutrient: _model.viewBlueNutrientOutput
                  ?.elementAtOrNull(_model.counter)
                  ?.idNutrient,
              idBlueprint: widget!.blueprintindex,
              nutrientValue: valueOrDefault<double>(
                _model.viewBlueNutrientOutput
                    ?.elementAtOrNull(_model.counter)
                    ?.nutrientvalue,
                0.00,
              ),
              nutrientDescription: valueOrDefault<String>(
                _model.viewBlueNutrientOutput
                    ?.elementAtOrNull(_model.counter)
                    ?.description,
                'n/a',
              ),
              nutrientReference: valueOrDefault<String>(
                _model.viewBlueNutrientOutput
                    ?.elementAtOrNull(_model.counter)
                    ?.referenceField,
                'n/a',
              ),
            ));
            safeSetState(() {});
            _model.counter = _model.counter + 1;
          }
        } else {
          _model.deltaIdList = await actions.deltaids(
            _model.nutrientOutput!.map((e) => e.id).toList().toList(),
            _model.relBlueNutrientOutput!
                .map((e) => e.idNutrient)
                .withoutNulls
                .toList()
                .toList(),
          );
          _model.counter = 0;
          _model.deltaIdmax = _model.deltaIdList?.length;
          safeSetState(() {});
          while (_model.counter < _model.deltaIdmax!) {
            _model.addToDeltaIndexList(DeltaIdDataTypeStruct(
              index: _model.relmax,
              idField: _model.deltaIdList?.elementAtOrNull(_model.counter),
            ));
            safeSetState(() {});
            _model.counter = _model.counter + 1;
            _model.relmax = _model.relmax! + 1;
          }
          _model.counter = 0;
          _model.relmax = (int relmax, int deltaIdMax) {
            return relmax = relmax - deltaIdMax;
          }(_model.relmax!, _model.deltaIdmax!);
          safeSetState(() {});
          while (_model.counter < _model.nutrientmax) {
            FFAppState().addToNutrientAppStateList(NutrientDataTypeStruct(
              id: _model.counter,
              nutrientLabel:
                  _model.nutrientOutput?.elementAtOrNull(_model.counter)?.name,
              idNutrient:
                  _model.nutrientOutput?.elementAtOrNull(_model.counter)?.id,
              idBlueprint: widget!.blueprintindex,
              nutrientValue: 0.0,
              nutrientDescription: 'n/a',
              nutrientReference: 'n/a',
            ));
            safeSetState(() {});
            _model.counter = _model.counter + 1;
            safeSetState(() {});
          }
          _model.counter = 0;
          safeSetState(() {});
          while (_model.counter < _model.deltaIdmax!) {
            await NutrientperplantTable().insert({
              'created_at': supaSerialize<DateTime>(getCurrentTimestamp),
              'id_nutrient':
                  _model.deltaIdList?.elementAtOrNull(_model.counter),
              'id_plant': widget!.blueprintindex,
              'value': 0.0,
              'reference': 'n/a',
              'description': 'n/a',
            });
            _model.counter = _model.counter + 1;
            safeSetState(() {});
          }
        }
      }
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
                              'Nutrient details',
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
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 21),
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
                          ],
                        ),
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
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, -1.0),
                                    child: Text(
                                      'Nutrients per plant',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 16),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 5.0, 0.0),
                                    child: Text(
                                      valueOrDefault<String>(
                                        widget!.blueprintlabel,
                                        'n/a',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 16),
                                            letterSpacing: 0.0,
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
                                  10.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Enter nutrient values (automatic update)',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize:
                                              FlutterFlowTheme.adjustScale(
                                                  size: 11),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            height: MediaQuery.sizeOf(context).height * 0.69,
                            decoration: BoxDecoration(),
                            child: Builder(
                              builder: (context) {
                                final nutrientAppStateDC = FFAppState()
                                    .nutrientAppStateList
                                    .sortedList(
                                        keyOf: (e) => e.nutrientLabel,
                                        desc: false)
                                    .toList();

                                return ListView.separated(
                                  padding: EdgeInsets.symmetric(vertical: 7.0),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: nutrientAppStateDC.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 7.0),
                                  itemBuilder:
                                      (context, nutrientAppStateDCIndex) {
                                    final nutrientAppStateDCItem =
                                        nutrientAppStateDC[
                                            nutrientAppStateDCIndex];
                                    return wrapWithModel(
                                      model:
                                          _model.nutrientValueModels.getModel(
                                        nutrientAppStateDCItem.id.toString(),
                                        nutrientAppStateDCIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: NutrientValueWidget(
                                        key: Key(
                                          'Key6ge_${nutrientAppStateDCItem.id.toString()}',
                                        ),
                                        nutrientName: FFAppState()
                                            .nutrientAppStateList
                                            .elementAtOrNull(
                                                nutrientAppStateDCItem.id)!
                                            .nutrientLabel,
                                        nutrientReference: FFAppState()
                                            .nutrientAppStateList
                                            .elementAtOrNull(
                                                nutrientAppStateDCItem.id)!
                                            .nutrientReference,
                                        nutrientValue: FFAppState()
                                            .nutrientAppStateList
                                            .elementAtOrNull(
                                                nutrientAppStateDCItem.id)!
                                            .nutrientValue,
                                        nutrientId: FFAppState()
                                            .nutrientAppStateList
                                            .elementAtOrNull(
                                                nutrientAppStateDCItem.id)!
                                            .idNutrient,
                                        blueprintId: FFAppState()
                                            .nutrientAppStateList
                                            .elementAtOrNull(
                                                nutrientAppStateDCItem.id)!
                                            .idBlueprint,
                                        updateActionNutrientValue:
                                            (callbackNutrientvalue) async {
                                          _model.nutrientValue =
                                              callbackNutrientvalue;
                                          safeSetState(() {});
                                          await NutrientperplantTable().update(
                                            data: {
                                              'value': _model.nutrientValue,
                                            },
                                            matchingRows: (rows) => rows
                                                .eqOrNull(
                                                  'id_nutrient',
                                                  nutrientAppStateDCItem
                                                      .idNutrient,
                                                )
                                                .eqOrNull(
                                                  'id_plant',
                                                  widget!.blueprintindex,
                                                ),
                                          );
                                          FFAppState()
                                              .updateNutrientAppStateListAtIndex(
                                            nutrientAppStateDCItem.id,
                                            (e) => e
                                              ..nutrientValue =
                                                  _model.nutrientValue,
                                          );
                                          safeSetState(() {});
                                        },
                                        updateActionNutrientReference:
                                            (callbackNutrientReference) async {
                                          _model.nutrientReference =
                                              callbackNutrientReference;
                                          safeSetState(() {});
                                          await NutrientperplantTable().update(
                                            data: {
                                              'reference':
                                                  callbackNutrientReference,
                                            },
                                            matchingRows: (rows) => rows
                                                .eqOrNull(
                                                  'id_nutrient',
                                                  nutrientAppStateDCItem
                                                      .idNutrient,
                                                )
                                                .eqOrNull(
                                                  'id_plant',
                                                  widget!.blueprintindex,
                                                ),
                                          );
                                          FFAppState()
                                              .updateNutrientAppStateListAtIndex(
                                            nutrientAppStateDCItem.id,
                                            (e) => e
                                              ..nutrientReference =
                                                  _model.nutrientReference,
                                          );
                                          safeSetState(() {});

                                          safeSetState(() {});
                                        },
                                        updateActionNutrientDescription:
                                            (callbackNutrientDescription) async {},
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
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
                          ClipRRect(
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
