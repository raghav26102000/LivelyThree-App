import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'data_contract_entry_model.dart';
export 'data_contract_entry_model.dart';

class DataContractEntryWidget extends StatefulWidget {
  const DataContractEntryWidget({
    super.key,
    this.contractName,
    this.validityType,
    this.contractId,
    this.description,
    required this.status,
    required this.contractType,
  });

  final String? contractName;
  final String? validityType;
  final int? contractId;
  final String? description;
  final String? status;
  final String? contractType;

  @override
  State<DataContractEntryWidget> createState() =>
      _DataContractEntryWidgetState();
}

class _DataContractEntryWidgetState extends State<DataContractEntryWidget> {
  late DataContractEntryModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DataContractEntryModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          if (widget!.status == 'active') {
            await Future.wait([
              Future(() async {
                _model.consentOutput =
                    await actions.initializeUserContractandLog(
                  currentUserUid,
                  widget!.contractId!,
                );
                _model.consentValue = _model.consentOutput!;
                safeSetState(() {});
                safeSetState(() {
                  _model.switchValue1 = _model.consentOutput!;
                });
              }),
              Future(() async {
                _model.effectiveConsentWithdrawalOutput =
                    await UsercontractsTable().queryRows(
                  queryFn: (q) => q
                      .eqOrNull(
                        'id_user',
                        currentUserUid,
                      )
                      .eqOrNull(
                        'id_datacontract',
                        widget!.contractId,
                      ),
                );
                if (_model.effectiveConsentWithdrawalOutput
                        ?.elementAtOrNull(0)
                        ?.withdrawalEffectiveDate !=
                    null) {
                  _model.effectiveConsentDate = _model
                      .effectiveConsentWithdrawalOutput
                      ?.elementAtOrNull(0)
                      ?.withdrawalEffectiveDate;
                  _model.hasEffectiveConsentDate = true;
                  safeSetState(() {});
                } else {
                  _model.hasEffectiveConsentDate = false;
                  safeSetState(() {});
                }
              }),
            ]);
          }
        }),
        Future(() async {
          _model.isWithinTimeOutput = await actions.isWithinTimeWindow();
          if (_model.isWithinTimeOutput == true) {
            _model.isToggleDisabled = true;
            safeSetState(() {});
          } else {
            _model.isToggleDisabled = false;
            safeSetState(() {});
          }
        }),
      ]);
    });

    _model.expandableExpandableController =
        ExpandableController(initialExpanded: false);
    _model.switchValue1 = true;
    _model.switchValue2 = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: AlignmentDirectional(0.0, -1.0),
      child: FutureBuilder<List<ViewIndicatorsContractRow>>(
        future: ViewIndicatorsContractTable().queryRows(
          queryFn: (q) => q.eqOrNull(
            'id_datacontract',
            widget!.contractId,
          ),
        ),
        builder: (context, snapshot) {
          // Customize what your widget looks like when it's loading.
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 25.0,
                height: 25.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF0F26C0),
                  ),
                ),
              ),
            );
          }
          List<ViewIndicatorsContractRow>
              containerViewIndicatorsContractRowList = snapshot.data!;

          return Container(
            width: MediaQuery.sizeOf(context).width * 0.95,
            height: MediaQuery.sizeOf(context).height * 0.31,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).secondaryText,
                width: 2.0,
              ),
            ),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: MediaQuery.sizeOf(context).height * 0.28,
              color: Color(0x00000000),
              child: ExpandableNotifier(
                controller: _model.expandableExpandableController,
                child: ExpandablePanel(
                  header: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                5.0, 5.0, 0.0, 2.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.7,
                              height: MediaQuery.sizeOf(context).height * 0.04,
                              decoration: BoxDecoration(
                                color: valueOrDefault<Color>(
                                  _model.switchValue1 == true
                                      ? Color(0xFFDDE7BE)
                                      : FlutterFlowTheme.of(context).alternate,
                                  Color(0xFFCADD8C),
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  color: valueOrDefault<Color>(
                                    _model.switchValue1 == true
                                        ? Color(0xFF85925B)
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    Color(0xFF85925B),
                                  ),
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          widget!.contractName!,
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize:
                                                    valueOrDefault<double>(
                                                  () {
                                                    if (FFAppState()
                                                            .screenCategory ==
                                                        'small') {
                                                      return 13;
                                                    } else if (FFAppState()
                                                            .screenCategory ==
                                                        'medium') {
                                                      return 15;
                                                    } else {
                                                      return 17;
                                                    }
                                                  }()
                                                      .toDouble(),
                                                  16.0,
                                                ),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleMediumIsCustom,
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
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.75,
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Who asks',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            fontSize:
                                                                valueOrDefault<
                                                                    double>(
                                                              () {
                                                                if (FFAppState()
                                                                        .screenCategory ==
                                                                    'small') {
                                                                  return 12;
                                                                } else if (FFAppState()
                                                                        .screenCategory ==
                                                                    'medium') {
                                                                  return 13;
                                                                } else {
                                                                  return 14;
                                                                }
                                                              }()
                                                                  .toDouble(),
                                                              14.0,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
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
                                              SafeArea(
                                                child: Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.15,
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  decoration: BoxDecoration(),
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    valueOrDefault<String>(
                                                      widget!.contractType,
                                                      'n/a',
                                                    ),
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
                                                                return 10;
                                                              } else if (FFAppState()
                                                                      .screenCategory ==
                                                                  'medium') {
                                                                return 11;
                                                              } else {
                                                                return 12;
                                                              }
                                                            }()
                                                                .toDouble(),
                                                            12.0,
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
                                            return 40;
                                          } else if (FFAppState()
                                                  .screenCategory ==
                                              'medium') {
                                            return 45;
                                          } else {
                                            return 50;
                                          }
                                        }()
                                            .toDouble(),
                                        40.0,
                                      ),
                                      child: VerticalDivider(
                                        thickness: 2.0,
                                        indent: 5.0,
                                        endIndent: 5.0,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'How long',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            fontSize:
                                                                valueOrDefault<
                                                                    double>(
                                                              () {
                                                                if (FFAppState()
                                                                        .screenCategory ==
                                                                    'small') {
                                                                  return 12;
                                                                } else if (FFAppState()
                                                                        .screenCategory ==
                                                                    'medium') {
                                                                  return 13;
                                                                } else {
                                                                  return 14;
                                                                }
                                                              }()
                                                                  .toDouble(),
                                                              14.0,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
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
                                              SafeArea(
                                                child: Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.2,
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        valueOrDefault<Color>(
                                                      () {
                                                        if (_model
                                                                .switchValue1 ==
                                                            true) {
                                                          return Color(
                                                              0xFFD5E5A2);
                                                        } else if ((_model
                                                                    .switchValue1 ==
                                                                false) &&
                                                            (_model.hasEffectiveConsentDate ==
                                                                true)) {
                                                          return Color(
                                                              0xFFF4E583);
                                                        } else {
                                                          return Color(
                                                              0xFFEEB1B1);
                                                        }
                                                      }(),
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Builder(
                                                        builder: (context) {
                                                          if ((_model.hasEffectiveConsentDate ==
                                                                  true) &&
                                                              (_model.switchValue1 ==
                                                                  false)) {
                                                            return Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
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
                                                                        _model.switchValue1 ==
                                                                                true
                                                                            ? widget!.validityType
                                                                            : 'no consent',
                                                                        'n/a',
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
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 10;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 11;
                                                                                } else {
                                                                                  return 12;
                                                                                }
                                                                              }()
                                                                                  .toDouble(),
                                                                              12.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontStyle:
                                                                                FontStyle.italic,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                                    Text(
                                                                      valueOrDefault<
                                                                          String>(
                                                                        dateTimeFormat(
                                                                            "MMMEd",
                                                                            _model.effectiveConsentDate),
                                                                        'n/a',
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
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 7;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 8;
                                                                                } else {
                                                                                  return 9;
                                                                                }
                                                                              }()
                                                                                  .toDouble(),
                                                                              9.0,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                          } else {
                                                            return Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          _model.switchValue1 == true
                                                                              ? widget!.validityType
                                                                              : 'no consent',
                                                                          'n/a',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              fontSize: valueOrDefault<double>(
                                                                                () {
                                                                                  if (FFAppState().screenCategory == 'small') {
                                                                                    return 9;
                                                                                  } else if (FFAppState().screenCategory == 'medium') {
                                                                                    return 10;
                                                                                  } else {
                                                                                    return 11;
                                                                                  }
                                                                                }()
                                                                                    .toDouble(),
                                                                                11.0,
                                                                              ),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FontStyle.italic,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                    ],
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
                                    SizedBox(
                                      height: valueOrDefault<double>(
                                        () {
                                          if (FFAppState().screenCategory ==
                                              'small') {
                                            return 40;
                                          } else if (FFAppState()
                                                  .screenCategory ==
                                              'medium') {
                                            return 45;
                                          } else {
                                            return 50;
                                          }
                                        }()
                                            .toDouble(),
                                        40.0,
                                      ),
                                      child: VerticalDivider(
                                        thickness: 2.0,
                                        indent: 5.0,
                                        endIndent: 5.0,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Status',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            fontSize:
                                                                valueOrDefault<
                                                                    double>(
                                                              () {
                                                                if (FFAppState()
                                                                        .screenCategory ==
                                                                    'small') {
                                                                  return 12;
                                                                } else if (FFAppState()
                                                                        .screenCategory ==
                                                                    'medium') {
                                                                  return 13;
                                                                } else {
                                                                  return 14;
                                                                }
                                                              }()
                                                                  .toDouble(),
                                                              14.0,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
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
                                              SafeArea(
                                                child: Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.15,
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  decoration: BoxDecoration(
                                                    color: () {
                                                      if (widget!.status ==
                                                          'active') {
                                                        return Color(
                                                            0xFF8AC5FD);
                                                      } else if (widget!
                                                              .status ==
                                                          'preview') {
                                                        return Color(
                                                            0xFFE7D468);
                                                      } else {
                                                        return FlutterFlowTheme
                                                                .of(context)
                                                            .tertiaryText;
                                                      }
                                                    }(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    valueOrDefault<String>(
                                                      widget!.status,
                                                      'n/a',
                                                    ),
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
                                                                return 10;
                                                              } else if (FFAppState()
                                                                      .screenCategory ==
                                                                  'medium') {
                                                                return 11;
                                                              } else {
                                                                return 12;
                                                              }
                                                            }()
                                                                .toDouble(),
                                                            12.0,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  collapsed: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Divider(
                        thickness: 2.0,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 2.0),
                                child: Text(
                                  'What you share',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: valueOrDefault<double>(
                                          () {
                                            if (FFAppState().screenCategory ==
                                                'small') {
                                              return 12;
                                            } else if (FFAppState()
                                                    .screenCategory ==
                                                'medium') {
                                              return 13;
                                            } else {
                                              return 14;
                                            }
                                          }()
                                              .toDouble(),
                                          14.0,
                                        ),
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.35,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.12,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      3.0, 3.0, 3.0, 3.0),
                                  child: Builder(
                                    builder: (context) {
                                      final indindicatorsDC =
                                          containerViewIndicatorsContractRowList
                                              .where(
                                                  (e) => e.isCommunity == false)
                                              .toList();

                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: indindicatorsDC.length,
                                        itemBuilder:
                                            (context, indindicatorsDCIndex) {
                                          final indindicatorsDCItem =
                                              indindicatorsDC[
                                                  indindicatorsDCIndex];
                                          return Text(
                                            valueOrDefault<String>(
                                              indindicatorsDCItem
                                                  .indicatorDisplayname,
                                              'n/a',
                                            ),
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
                                                        return 10;
                                                      } else if (FFAppState()
                                                              .screenCategory ==
                                                          'medium') {
                                                        return 11;
                                                      } else {
                                                        return 12;
                                                      }
                                                    }()
                                                        .toDouble(),
                                                    12.0,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.italic,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
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
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 2.0),
                                child: Text(
                                  'What you receive',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: valueOrDefault<double>(
                                          () {
                                            if (FFAppState().screenCategory ==
                                                'small') {
                                              return 12;
                                            } else if (FFAppState()
                                                    .screenCategory ==
                                                'medium') {
                                              return 13;
                                            } else {
                                              return 14;
                                            }
                                          }()
                                              .toDouble(),
                                          14.0,
                                        ),
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.35,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.12,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      3.0, 3.0, 3.0, 3.0),
                                  child: Builder(
                                    builder: (context) {
                                      final sharedindDC =
                                          containerViewIndicatorsContractRowList
                                              .where(
                                                  (e) => e.isCommunity == true)
                                              .toList();

                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: sharedindDC.length,
                                        itemBuilder:
                                            (context, sharedindDCIndex) {
                                          final sharedindDCItem =
                                              sharedindDC[sharedindDCIndex];
                                          return Text(
                                            valueOrDefault<String>(
                                              sharedindDCItem
                                                  .indicatorDisplayname,
                                              'n/a',
                                            ),
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
                                                        return 10;
                                                      } else if (FFAppState()
                                                              .screenCategory ==
                                                          'medium') {
                                                        return 11;
                                                      } else {
                                                        return 12;
                                                      }
                                                    }()
                                                        .toDouble(),
                                                    12.0,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.italic,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
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
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Consent',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      fontSize: valueOrDefault<double>(
                                        () {
                                          if (FFAppState().screenCategory ==
                                              'small') {
                                            return 12;
                                          } else if (FFAppState()
                                                  .screenCategory ==
                                              'medium') {
                                            return 13;
                                          } else {
                                            return 14;
                                          }
                                        }()
                                            .toDouble(),
                                        14.0,
                                      ),
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                              ),
                              Container(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.12,
                                decoration: BoxDecoration(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          _model.switchValue1 == false
                                              ? 'opt-in'
                                              : 'opt-out',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmallFamily,
                                                fontSize:
                                                    valueOrDefault<double>(
                                                  () {
                                                    if (FFAppState()
                                                            .screenCategory ==
                                                        'small') {
                                                      return 10;
                                                    } else if (FFAppState()
                                                            .screenCategory ==
                                                        'medium') {
                                                      return 11;
                                                    } else {
                                                      return 12;
                                                    }
                                                  }()
                                                      .toDouble(),
                                                  12.0,
                                                ),
                                                letterSpacing: 0.0,
                                                fontStyle: FontStyle.italic,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmallIsCustom,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            if (widget!.status == 'active') {
                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Switch.adaptive(
                                                    value: _model.switchValue1!,
                                                    onChanged: functions
                                                            .isToggleDisabled()
                                                        ? null
                                                        : (newValue) async {
                                                            safeSetState(() =>
                                                                _model.switchValue1 =
                                                                    newValue!);
                                                            if (newValue!) {
                                                              _model.consentUpateToggledOnOutput =
                                                                  await actions
                                                                      .updateDataContractConsent(
                                                                currentUserUid,
                                                                widget!
                                                                    .contractId!,
                                                                _model
                                                                    .switchValue1!,
                                                              );
                                                              _model.effectiveConsentDate =
                                                                  null;
                                                              _model.hasEffectiveConsentDate =
                                                                  false;
                                                              safeSetState(
                                                                  () {});

                                                              safeSetState(
                                                                  () {});
                                                            } else {
                                                              _model.updateConsentToggledOffOutput =
                                                                  await actions
                                                                      .updateDataContractConsent(
                                                                currentUserUid,
                                                                widget!
                                                                    .contractId!,
                                                                _model
                                                                    .switchValue1!,
                                                              );
                                                              _model.effectiveConsentDateOutput =
                                                                  await UsercontractsTable()
                                                                      .queryRows(
                                                                queryFn: (q) => q
                                                                    .eqOrNull(
                                                                      'id_user',
                                                                      currentUserUid,
                                                                    )
                                                                    .eqOrNull(
                                                                      'id_datacontract',
                                                                      widget!
                                                                          .contractId,
                                                                    ),
                                                              );
                                                              _model.effectiveConsentDate = _model
                                                                  .effectiveConsentDateOutput
                                                                  ?.elementAtOrNull(
                                                                      0)
                                                                  ?.withdrawalEffectiveDate;
                                                              _model.hasEffectiveConsentDate =
                                                                  true;
                                                              safeSetState(
                                                                  () {});

                                                              safeSetState(
                                                                  () {});
                                                            }
                                                          },
                                                    activeColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondary,
                                                    activeTrackColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    inactiveTrackColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .alternate,
                                                    inactiveThumbColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryBackground,
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Switch.adaptive(
                                                value: _model.switchValue2!,
                                                onChanged:
                                                    (widget!.contractType !=
                                                            'active')
                                                        ? null
                                                        : (newValue) async {
                                                            safeSetState(() =>
                                                                _model.switchValue2 =
                                                                    newValue!);
                                                          },
                                                activeColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                activeTrackColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                inactiveTrackColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                inactiveThumbColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              );
                                            }
                                          },
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
                    ],
                  ),
                  expanded: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Divider(
                        thickness: 2.0,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 5.0),
                            child: Text(
                              'Description',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelMediumFamily,
                                    fontSize: valueOrDefault<double>(
                                      () {
                                        if (FFAppState().screenCategory ==
                                            'small') {
                                          return 10;
                                        } else if (FFAppState()
                                                .screenCategory ==
                                            'medium') {
                                          return 11;
                                        } else {
                                          return 12;
                                        }
                                      }()
                                          .toDouble(),
                                      12.0,
                                    ),
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelMediumIsCustom,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            height: MediaQuery.sizeOf(context).height * 0.13,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 5.0, 0.0, 0.0),
                              child: Text(
                                valueOrDefault<String>(
                                  widget!.description,
                                  'n/a',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: valueOrDefault<double>(
                                        () {
                                          if (FFAppState().screenCategory ==
                                              'small') {
                                            return 12;
                                          } else if (FFAppState()
                                                  .screenCategory ==
                                              'medium') {
                                            return 13;
                                          } else {
                                            return 14;
                                          }
                                        }()
                                            .toDouble(),
                                        14.0,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  theme: ExpandableThemeData(
                    tapHeaderToExpand: true,
                    tapBodyToExpand: false,
                    tapBodyToCollapse: false,
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    hasIcon: true,
                    expandIcon: Icons.arrow_circle_down,
                    collapseIcon: Icons.arrow_circle_up,
                    iconSize: 30.0,
                    iconPadding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 20.0),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
