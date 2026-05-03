import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_checkbox_group.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'create_data_list_item_model.dart';
export 'create_data_list_item_model.dart';

class CreateDataListItemWidget extends StatefulWidget {
  const CreateDataListItemWidget({super.key});

  @override
  State<CreateDataListItemWidget> createState() =>
      _CreateDataListItemWidgetState();
}

class _CreateDataListItemWidgetState extends State<CreateDataListItemWidget> {
  late CreateDataListItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateDataListItemModel());

    _model.contractdescription1TextController ??= TextEditingController();
    _model.contractdescription1FocusNode ??= FocusNode();

    _model.contractname2TextController ??= TextEditingController();
    _model.contractname2FocusNode ??= FocusNode();

    _model.contractdescription2TextController ??= TextEditingController();
    _model.contractdescription2FocusNode ??= FocusNode();

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

    return FutureBuilder<List<DatacontractRow>>(
      future: DatacontractTable().queryRows(
        queryFn: (q) => q.order('contract_name', ascending: true),
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
        List<DatacontractRow> containerDatacontractRowList = snapshot.data!;

        return Container(
          width: MediaQuery.sizeOf(context).width * 0.9,
          height: MediaQuery.sizeOf(context).height * 0.7,
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                height: MediaQuery.sizeOf(context).height * 0.7,
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.9,
                          height: MediaQuery.sizeOf(context).height * 0.64,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                          ),
                          child: Builder(
                            builder: (context) {
                              final contractsDC =
                                  containerDatacontractRowList.toList();

                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemCount: contractsDC.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 15.0),
                                itemBuilder: (context, contractsDCIndex) {
                                  final contractsDCItem =
                                      contractsDC[contractsDCIndex];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        3.0, 3.0, 3.0, 3.0),
                                    child: FutureBuilder<
                                        List<ViewIndicatorsContractRow>>(
                                      future: ViewIndicatorsContractTable()
                                          .queryRows(
                                        queryFn: (q) => q.eqOrNull(
                                          'id_datacontract',
                                          contractsDCItem.id,
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
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xFF0F26C0),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<ViewIndicatorsContractRow>
                                            containerViewIndicatorsContractRowList =
                                            snapshot.data!;

                                        return Material(
                                          color: Colors.transparent,
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.9,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.36,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              border: Border.all(
                                                color: Color(0xFFC9D0D8),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
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
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    5.0,
                                                                    5.0,
                                                                    0.0),
                                                        child: Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.6,
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.055,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFE7F0F8),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xFFBBDBF4),
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      valueOrDefault<
                                                                          String>(
                                                                        contractsDCItem
                                                                            .contractName,
                                                                        'dummy',
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                valueOrDefault<double>(
                                                                              () {
                                                                                if (FFAppState().screenCategory == 'small') {
                                                                                  return 11;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 12;
                                                                                } else {
                                                                                  return 13;
                                                                                }
                                                                              }()
                                                                                  .toDouble(),
                                                                              13.0,
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
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          var confirmDialogResponse =
                                                              await showDialog<
                                                                      bool>(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (alertDialogContext) {
                                                                      return AlertDialog(
                                                                        title: Text(
                                                                            'Delete contract'),
                                                                        content:
                                                                            Text('Are you sure to delete \"${valueOrDefault<String>(
                                                                          contractsDCItem
                                                                              .contractName,
                                                                          '0',
                                                                        )}\" ?'),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(alertDialogContext, false),
                                                                            child:
                                                                                Text('Cancel'),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(alertDialogContext, true),
                                                                            child:
                                                                                Text('Confirm'),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  ) ??
                                                                  false;
                                                          if (confirmDialogResponse) {
                                                            _model.consentedContractOutput =
                                                                await ViewUserConsentedIndicatorsTable()
                                                                    .queryRows(
                                                              queryFn: (q) => q
                                                                  .eqOrNull(
                                                                    'userid',
                                                                    currentUserUid,
                                                                  )
                                                                  .eqOrNull(
                                                                    'datacontract_id',
                                                                    contractsDCItem
                                                                        .id,
                                                                  )
                                                                  .eqOrNull(
                                                                    'consent',
                                                                    true,
                                                                  ),
                                                            );
                                                            if ((_model.consentedContractOutput !=
                                                                        null &&
                                                                    (_model.consentedContractOutput)!
                                                                        .isNotEmpty) ==
                                                                true) {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (alertDialogContext) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Contract status'),
                                                                    content: Text(
                                                                        'The contract is still active and consented to by at least one user.'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                        child: Text(
                                                                            'Ok'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              await DatacontractTable()
                                                                  .delete(
                                                                matchingRows:
                                                                    (rows) => rows
                                                                        .eqOrNull(
                                                                  'id',
                                                                  contractsDCItem
                                                                      .id,
                                                                ),
                                                              );
                                                            }
                                                          }

                                                          safeSetState(() {});
                                                        },
                                                        text: 'Delete',
                                                        options:
                                                            FFButtonOptions(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.16,
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.035,
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          iconPadding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          textStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .titleSmallFamily,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .titleSmallIsCustom,
                                                                  ),
                                                          elevation: 3.0,
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 5.0,
                                                                0.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
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
                                                                      'Contract type',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
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
                                                                                FontWeight.w500,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                                children: [
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      contractsDCItem
                                                                          .contractType,
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
                                                                                return 8;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                return 9;
                                                                              } else {
                                                                                return 10;
                                                                              }
                                                                            }()
                                                                                .toDouble(),
                                                                            10.0,
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
                                                            ],
                                                          ),
                                                        ),
                                                        VerticalDivider(
                                                          thickness: 2.0,
                                                          indent: 5.0,
                                                          endIndent: 5.0,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
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
                                                                      'Validity type',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
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
                                                                                FontWeight.w500,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                                children: [
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      contractsDCItem
                                                                          .validityType,
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
                                                                                return 8;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                return 9;
                                                                              } else {
                                                                                return 10;
                                                                              }
                                                                            }()
                                                                                .toDouble(),
                                                                            10.0,
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
                                                            ],
                                                          ),
                                                        ),
                                                        VerticalDivider(
                                                          thickness: 2.0,
                                                          indent: 5.0,
                                                          endIndent: 5.0,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
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
                                                                        FFAppState().isVisible1 =
                                                                            true;
                                                                        _model.updatePage(
                                                                            () {});
                                                                        _model.datacontractDocument =
                                                                            contractsDCItem;
                                                                        safeSetState(
                                                                            () {});
                                                                        await Future
                                                                            .wait([
                                                                          Future(
                                                                              () async {}),
                                                                          Future(
                                                                              () async {
                                                                            safeSetState(() {
                                                                              _model.contractdescription1TextController?.text = contractsDCItem.description!;
                                                                            });
                                                                          }),
                                                                          Future(
                                                                              () async {
                                                                            _model.tempContractStatus =
                                                                                valueOrDefault<String>(
                                                                              _model.datacontractDocument?.status,
                                                                              'n/a',
                                                                            );
                                                                            safeSetState(() {});
                                                                          }),
                                                                        ]);
                                                                        await Future
                                                                            .delayed(
                                                                          Duration(
                                                                            milliseconds:
                                                                                200,
                                                                          ),
                                                                        );
                                                                      },
                                                                      text:
                                                                          'Status',
                                                                      options:
                                                                          FFButtonOptions(
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.2,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.02,
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
                                                                        color: Color(
                                                                            0xFFC0DFFB),
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              fontSize: valueOrDefault<double>(
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
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        elevation:
                                                                            1.0,
                                                                        borderRadius:
                                                                            BorderRadius.circular(0.0),
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
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.2,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.02,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          () {
                                                                        if (contractsDCItem.status ==
                                                                            'active') {
                                                                          return Color(
                                                                              0xFFCADD8C);
                                                                        } else if (contractsDCItem.status ==
                                                                            'preview') {
                                                                          return Color(
                                                                              0xFFE5DBA2);
                                                                        } else {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .tertiaryText;
                                                                        }
                                                                      }(),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              14.0),
                                                                    ),
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            0.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      valueOrDefault<
                                                                          String>(
                                                                        contractsDCItem
                                                                            .status,
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
                                                                                  return 8;
                                                                                } else if (FFAppState().screenCategory == 'medium') {
                                                                                  return 9;
                                                                                } else {
                                                                                  return 10;
                                                                                }
                                                                              }()
                                                                                  .toDouble(),
                                                                              10.0,
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
                                                Divider(
                                                  thickness: 2.0,
                                                  indent: 10.0,
                                                  endIndent: 10.0,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    2.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          3.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Description',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
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
                                                                              FontWeight.w500,
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
                                                                          15.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.8,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.07,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4.0),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          5.0,
                                                                          5.0,
                                                                          5.0,
                                                                          5.0),
                                                                      child:
                                                                          Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          contractsDCItem
                                                                              .description,
                                                                          'n/a',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              fontSize: valueOrDefault<double>(
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
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 5.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          3.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Indicators shared',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
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
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.4,
                                                              height: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .height *
                                                                  0.09,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                                border:
                                                                    Border.all(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            5.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Builder(
                                                                  builder:
                                                                      (context) {
                                                                    final indindicatorsPerContractDC = containerViewIndicatorsContractRowList
                                                                        .where((e) =>
                                                                            e.isCommunity ==
                                                                            false)
                                                                        .toList();

                                                                    return ListView
                                                                        .builder(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      shrinkWrap:
                                                                          true,
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      itemCount:
                                                                          indindicatorsPerContractDC
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              indindicatorsPerContractDCIndex) {
                                                                        final indindicatorsPerContractDCItem =
                                                                            indindicatorsPerContractDC[indindicatorsPerContractDCIndex];
                                                                        return Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            indindicatorsPerContractDCItem.indicatorDisplayname,
                                                                            'n/a',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                fontSize: valueOrDefault<double>(
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
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FontStyle.italic,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          3.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Indicators received',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
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
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.4,
                                                              height: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .height *
                                                                  0.09,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                                border:
                                                                    Border.all(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            5.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Builder(
                                                                  builder:
                                                                      (context) {
                                                                    final sharedindicatorsPerContractDC = containerViewIndicatorsContractRowList
                                                                        .where((e) =>
                                                                            e.isCommunity ==
                                                                            true)
                                                                        .toList();

                                                                    return ListView
                                                                        .builder(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      shrinkWrap:
                                                                          true,
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      itemCount:
                                                                          sharedindicatorsPerContractDC
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              sharedindicatorsPerContractDCIndex) {
                                                                        final sharedindicatorsPerContractDCItem =
                                                                            sharedindicatorsPerContractDC[sharedindicatorsPerContractDCIndex];
                                                                        return Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            sharedindicatorsPerContractDCItem.indicatorDisplayname,
                                                                            'n/a',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                fontSize: valueOrDefault<double>(
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
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FontStyle.italic,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FFButtonWidget(
                                onPressed: () async {
                                  FFAppState().isVisible2 = true;
                                  safeSetState(() {});
                                },
                                text: 'Create',
                                options: FFButtonOptions(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.25,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.04,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
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
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (FFAppState().isVisible1 == true)
                      FutureBuilder<List<UserindicatorsRow>>(
                        future: UserindicatorsTable().queryRows(
                          queryFn: (q) => q
                              .order('name', ascending: true)
                              .order('frequency', ascending: true),
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
                          List<UserindicatorsRow>
                              contractupdateFC1UserindicatorsRowList =
                              snapshot.data!;

                          return Container(
                            width: MediaQuery.sizeOf(context).width * 0.85,
                            height: MediaQuery.sizeOf(context).height * 0.25,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent4,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x33000000),
                                  offset: Offset(
                                    0.0,
                                    2.0,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.85,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      child: ListView(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 10.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  5.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.85,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.05,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                        child: Row(
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
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .tertiaryText,
                                                                size: 20.0,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  FlutterFlowDropDown<
                                                                      String>(
                                                                controller: _model
                                                                        .status1ValueController ??=
                                                                    FormFieldController<
                                                                        String>(
                                                                  _model.status1Value ??= _model
                                                                      .datacontractDocument
                                                                      ?.status,
                                                                ),
                                                                options: [
                                                                  'active',
                                                                  'archived',
                                                                  'preview'
                                                                ],
                                                                onChanged: (val) =>
                                                                    safeSetState(() =>
                                                                        _model.status1Value =
                                                                            val),
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.25,
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.05,
                                                                textStyle: FlutterFlowTheme.of(
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
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                                hintText:
                                                                    'Select...',
                                                                elevation: 1.0,
                                                                borderColor: Colors
                                                                    .transparent,
                                                                borderWidth:
                                                                    0.0,
                                                                borderRadius:
                                                                    14.0,
                                                                margin: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10.0,
                                                                        0.0,
                                                                        0.0,
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
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  47.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.08,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.015,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Status',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        8.0,
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
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 10.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    controller: _model
                                                        .contractdescription1TextController,
                                                    focusNode: _model
                                                        .contractdescription1FocusNode,
                                                    autofocus: true,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Description',
                                                      labelStyle:
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
                                                                  11.0,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                      alignLabelWithHint: false,
                                                      hintText: 'Description',
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      filled: true,
                                                      fillColor: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      prefixIcon: Icon(
                                                        Icons.edit,
                                                        size: 20.0,
                                                      ),
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
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                    textAlign: TextAlign.start,
                                                    maxLines: 5,
                                                    minLines: 3,
                                                    validator: _model
                                                        .contractdescription1TextControllerValidator
                                                        .asValidator(context),
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
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 5.0, 5.0, 5.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          if ((_model.tempContractStatus ==
                                                  'active') &&
                                              (_model.status1Value !=
                                                  'active')) {
                                            _model.usercontractConsentCheckOutput =
                                                await UsercontractsTable()
                                                    .queryRows(
                                              queryFn: (q) => q
                                                  .eqOrNull(
                                                    'id_datacontract',
                                                    _model.datacontractDocument
                                                        ?.id,
                                                  )
                                                  .eqOrNull(
                                                    'current_consent',
                                                    true,
                                                  ),
                                            );
                                            if ((_model.usercontractConsentCheckOutput !=
                                                        null &&
                                                    (_model.usercontractConsentCheckOutput)!
                                                        .isNotEmpty) ==
                                                true) {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Status Change'),
                                                    content: Text(
                                                        'Status cannot be changed from \"${_model.tempContractStatus}\" to \"${_model.status1Value}\". There are still users that consented to the contract.'),
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
                                            } else {
                                              await DatacontractTable().update(
                                                data: {
                                                  'description': _model
                                                      .contractdescription1TextController
                                                      .text,
                                                  'status': _model.status1Value,
                                                },
                                                matchingRows: (rows) =>
                                                    rows.eqOrNull(
                                                  'id',
                                                  _model
                                                      .datacontractDocument?.id,
                                                ),
                                              );
                                              await Future.wait([
                                                Future(() async {
                                                  safeSetState(() {
                                                    _model
                                                        .contractdescription1TextController
                                                        ?.clear();
                                                  });
                                                }),
                                                Future(() async {
                                                  safeSetState(() {
                                                    _model
                                                        .status1ValueController
                                                        ?.reset();
                                                  });
                                                }),
                                              ]);
                                              FFAppState().isVisible1 = false;
                                              safeSetState(() {});
                                            }
                                          } else {
                                            await DatacontractTable().update(
                                              data: {
                                                'description': _model
                                                    .contractdescription1TextController
                                                    .text,
                                                'status': _model.status1Value,
                                              },
                                              matchingRows: (rows) =>
                                                  rows.eqOrNull(
                                                'id',
                                                _model.datacontractDocument?.id,
                                              ),
                                            );
                                            await Future.wait([
                                              Future(() async {
                                                safeSetState(() {
                                                  _model
                                                      .contractdescription1TextController
                                                      ?.clear();
                                                });
                                              }),
                                              Future(() async {
                                                safeSetState(() {
                                                  _model.status1ValueController
                                                      ?.reset();
                                                });
                                              }),
                                            ]);
                                            FFAppState().isVisible1 = false;
                                            safeSetState(() {});
                                          }

                                          safeSetState(() {});
                                        },
                                        text: 'Save',
                                        options: FFButtonOptions(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.25,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.03,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
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
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmallIsCustom,
                                              ),
                                          elevation: 3.0,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 5.0, 0.0, 5.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          await Future.wait([
                                            Future(() async {
                                              safeSetState(() {
                                                _model.status1ValueController
                                                    ?.reset();
                                              });
                                            }),
                                            Future(() async {
                                              safeSetState(() {
                                                _model
                                                    .contractdescription1TextController
                                                    ?.clear();
                                              });
                                            }),
                                          ]);
                                          FFAppState().isVisible1 = false;
                                          safeSetState(() {});
                                        },
                                        text: 'Cancel',
                                        options: FFButtonOptions(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.25,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.03,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
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
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmallIsCustom,
                                              ),
                                          elevation: 3.0,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    if (FFAppState().isVisible2 == true)
                      FutureBuilder<List<UserindicatorsRow>>(
                        future: UserindicatorsTable().queryRows(
                          queryFn: (q) => q
                              .order('name', ascending: true)
                              .order('frequency', ascending: true),
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
                          List<UserindicatorsRow>
                              contractnewFC2UserindicatorsRowList =
                              snapshot.data!;

                          return Container(
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            height: MediaQuery.sizeOf(context).height * 0.7,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x33000000),
                                  offset: Offset(
                                    0.0,
                                    2.0,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.9,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.7,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 10.0),
                                          child: ListView(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 0.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'New contract',
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
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 10.0, 10.0, 10.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        controller: _model
                                                            .contractname2TextController,
                                                        focusNode: _model
                                                            .contractname2FocusNode,
                                                        autofocus: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          labelText:
                                                              'Contract name',
                                                          labelStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodySmallFamily,
                                                                    fontSize:
                                                                        11.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodySmallIsCustom,
                                                                  ),
                                                          hintText:
                                                              'Contract name',
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          filled: true,
                                                          fillColor: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          prefixIcon: Icon(
                                                            Icons.edit,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmallFamily,
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
                                                                    15.0,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmallIsCustom,
                                                                ),
                                                        textAlign:
                                                            TextAlign.start,
                                                        maxLines: null,
                                                        validator: _model
                                                            .contractname2TextControllerValidator
                                                            .asValidator(
                                                                context),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 10.0, 10.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        controller: _model
                                                            .contractdescription2TextController,
                                                        focusNode: _model
                                                            .contractdescription2FocusNode,
                                                        autofocus: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          labelText:
                                                              'Description',
                                                          labelStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodySmallFamily,
                                                                    fontSize:
                                                                        11.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodySmallIsCustom,
                                                                  ),
                                                          alignLabelWithHint:
                                                              false,
                                                          hintText:
                                                              'Description',
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          filled: true,
                                                          fillColor: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          prefixIcon: Icon(
                                                            Icons.edit,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmallFamily,
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
                                                                    15.0,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmallIsCustom,
                                                                ),
                                                        textAlign:
                                                            TextAlign.start,
                                                        maxLines: 5,
                                                        minLines: 3,
                                                        validator: _model
                                                            .contractdescription2TextControllerValidator
                                                            .asValidator(
                                                                context),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 10.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      5.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.9,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.05,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: Icon(
                                                                    Icons.edit,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .tertiaryText,
                                                                    size: 20.0,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      FlutterFlowDropDown<
                                                                          String>(
                                                                    controller: _model
                                                                        .contracttype2ValueController ??= FormFieldController<
                                                                            String>(
                                                                        null),
                                                                    options: [
                                                                      'internal',
                                                                      'academic research',
                                                                      'impactindustry',
                                                                      'classical industry'
                                                                    ],
                                                                    onChanged: (val) =>
                                                                        safeSetState(() =>
                                                                            _model.contracttype2Value =
                                                                                val),
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.25,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.05,
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
                                                                                return 10.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                return 11.0;
                                                                              } else {
                                                                                return 12.0;
                                                                              }
                                                                            }(),
                                                                            15.0,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                    hintText:
                                                                        'Select...',
                                                                    elevation:
                                                                        1.0,
                                                                    borderColor:
                                                                        Colors
                                                                            .transparent,
                                                                    borderWidth:
                                                                        0.0,
                                                                    borderRadius:
                                                                        14.0,
                                                                    margin: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            0.0,
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
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      47.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.15,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.015,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Contract type',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontSize:
                                                                            8.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 10.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      5.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.9,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.05,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: Icon(
                                                                    Icons.edit,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .tertiaryText,
                                                                    size: 20.0,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      FlutterFlowDropDown<
                                                                          String>(
                                                                    controller: _model
                                                                            .validitytype2ValueController ??=
                                                                        FormFieldController<
                                                                            String>(
                                                                      _model.validitytype2Value ??=
                                                                          'until opt-out',
                                                                    ),
                                                                    options: [
                                                                      'until opt-out',
                                                                      'fixed period (future)',
                                                                      'until canceld by provider (future)',
                                                                      'valid until date (future)',
                                                                      'limited slots (future)',
                                                                      'conditional participation (future)',
                                                                      'one-time participation (future)',
                                                                      'rolling period (future)'
                                                                    ],
                                                                    onChanged: (val) =>
                                                                        safeSetState(() =>
                                                                            _model.validitytype2Value =
                                                                                val),
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.25,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.05,
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodySmallFamily,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
                                                                            () {
                                                                              if (FFAppState().screenCategory == 'small') {
                                                                                return 10.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                return 11.0;
                                                                              } else {
                                                                                return 12.0;
                                                                              }
                                                                            }(),
                                                                            15.0,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                        ),
                                                                    hintText:
                                                                        'Select...',
                                                                    elevation:
                                                                        1.0,
                                                                    borderColor:
                                                                        Colors
                                                                            .transparent,
                                                                    borderWidth:
                                                                        0.0,
                                                                    borderRadius:
                                                                        14.0,
                                                                    margin: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    hidesUnderline:
                                                                        true,
                                                                    isOverButton:
                                                                        false,
                                                                    isSearchable:
                                                                        false,
                                                                    isMultiSelect:
                                                                        false,
                                                                    labelText:
                                                                        '',
                                                                    labelTextStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelSmallFamily,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).labelSmallIsCustom,
                                                                        ),
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
                                                                      47.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.13,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.015,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Validity type',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontSize:
                                                                            8.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 10.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      5.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.9,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.05,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: Icon(
                                                                    Icons.edit,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .tertiaryText,
                                                                    size: 20.0,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      FlutterFlowDropDown<
                                                                          String>(
                                                                    controller: _model
                                                                        .status2ValueController ??= FormFieldController<
                                                                            String>(
                                                                        null),
                                                                    options: [
                                                                      'active',
                                                                      'archived',
                                                                      'preview'
                                                                    ],
                                                                    onChanged: (val) =>
                                                                        safeSetState(() =>
                                                                            _model.status2Value =
                                                                                val),
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.25,
                                                                    height: MediaQuery.sizeOf(context)
                                                                            .height *
                                                                        0.05,
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
                                                                                return 10.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
                                                                                return 11.0;
                                                                              } else {
                                                                                return 12.0;
                                                                              }
                                                                            }(),
                                                                            15.0,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                    hintText:
                                                                        'Select...',
                                                                    elevation:
                                                                        1.0,
                                                                    borderColor:
                                                                        Colors
                                                                            .transparent,
                                                                    borderWidth:
                                                                        0.0,
                                                                    borderRadius:
                                                                        14.0,
                                                                    margin: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            0.0,
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
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      47.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.08,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.015,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Status',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontSize:
                                                                            8.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                              Divider(
                                                thickness: 2.0,
                                                indent: 10.0,
                                                endIndent: 10.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                                      10.0,
                                                                      0.0,
                                                                      0.0,
                                                                      5.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Text(
                                                                'Given indicators',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
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
                                                                  0.85,
                                                              height: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .height *
                                                                  0.15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xFFF6F6F6),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                border:
                                                                    Border.all(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                              child: ListView(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                  0,
                                                                  2.0,
                                                                  0,
                                                                  2.0,
                                                                ),
                                                                primary: false,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                children: [
                                                                  FlutterFlowCheckboxGroup(
                                                                    options: contractnewFC2UserindicatorsRowList
                                                                        .where((e) =>
                                                                            e.isCommunity ==
                                                                            false)
                                                                        .toList()
                                                                        .map((e) =>
                                                                            e.displayname)
                                                                        .withoutNulls
                                                                        .toList(),
                                                                    onChanged:
                                                                        (val) async {
                                                                      safeSetState(() =>
                                                                          _model.checkboxgroupIndInd1Values =
                                                                              val);
                                                                      _model.listIndividualUserIndicators = _model
                                                                          .checkboxgroupIndInd1Values!
                                                                          .toList()
                                                                          .cast<
                                                                              String>();
                                                                      _model.updatePage(
                                                                          () {});
                                                                      _model.indIndicatorsActionOutput =
                                                                          await UserindicatorsTable()
                                                                              .queryRows(
                                                                        queryFn:
                                                                            (q) =>
                                                                                q.inFilterOrNull(
                                                                          'displayname',
                                                                          _model
                                                                              .listIndividualUserIndicators,
                                                                        ),
                                                                      );
                                                                      _model.indIndicatorIndexList = _model
                                                                          .indIndicatorsActionOutput!
                                                                          .map((e) => e
                                                                              .id)
                                                                          .toList()
                                                                          .cast<
                                                                              int>();
                                                                      safeSetState(
                                                                          () {});

                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                    controller: _model
                                                                            .checkboxgroupIndInd1ValueController ??=
                                                                        FormFieldController<
                                                                            List<String>>(
                                                                      [],
                                                                    ),
                                                                    activeColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                    checkColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .info,
                                                                    checkboxBorderColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondaryText,
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
                                                                                return 10.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
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
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                    unselectedTextStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
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
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                    itemPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    checkboxBorderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                    initialized:
                                                                        _model.checkboxgroupIndInd1Values !=
                                                                            null,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      5.0,
                                                                      0.0,
                                                                      5.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Text(
                                                                'Received indicators',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
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
                                                                  0.85,
                                                              height: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .height *
                                                                  0.15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xFFF6F6F6),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                border:
                                                                    Border.all(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                              child: ListView(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                  0,
                                                                  2.0,
                                                                  0,
                                                                  2.0,
                                                                ),
                                                                primary: false,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                children: [
                                                                  FlutterFlowCheckboxGroup(
                                                                    options: contractnewFC2UserindicatorsRowList
                                                                        .where((e) =>
                                                                            e.isCommunity ==
                                                                            true)
                                                                        .toList()
                                                                        .map((e) =>
                                                                            e.displayname)
                                                                        .withoutNulls
                                                                        .toList(),
                                                                    onChanged:
                                                                        (val) async {
                                                                      safeSetState(() =>
                                                                          _model.checkboxgroupSharedInd1Values =
                                                                              val);
                                                                      _model.listSharedUserIndicators = _model
                                                                          .checkboxgroupSharedInd1Values!
                                                                          .toList()
                                                                          .cast<
                                                                              String>();
                                                                      _model.updatePage(
                                                                          () {});
                                                                      _model.sharedIndicatorsActionOutput =
                                                                          await UserindicatorsTable()
                                                                              .queryRows(
                                                                        queryFn:
                                                                            (q) =>
                                                                                q.inFilterOrNull(
                                                                          'displayname',
                                                                          _model
                                                                              .listSharedUserIndicators,
                                                                        ),
                                                                      );
                                                                      _model.sharedIndicatorIndexList = _model
                                                                          .sharedIndicatorsActionOutput!
                                                                          .map((e) => e
                                                                              .id)
                                                                          .toList()
                                                                          .cast<
                                                                              int>();
                                                                      safeSetState(
                                                                          () {});

                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                    controller: _model
                                                                            .checkboxgroupSharedInd1ValueController ??=
                                                                        FormFieldController<
                                                                            List<String>>(
                                                                      [],
                                                                    ),
                                                                    activeColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                    checkColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .info,
                                                                    checkboxBorderColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondaryText,
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
                                                                                return 10.0;
                                                                              } else if (FFAppState().screenCategory == 'medium') {
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
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                    unselectedTextStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          fontSize:
                                                                              valueOrDefault<double>(
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
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                    itemPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    checkboxBorderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                    initialized:
                                                                        _model.checkboxgroupSharedInd1Values !=
                                                                            null,
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
                                            ],
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
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 5.0, 5.0, 5.0),
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            _model.contractnameactionoutput2 =
                                                await actions
                                                    .insertdatacontracts(
                                              _model.indIndicatorIndexList
                                                  .toList(),
                                              _model.sharedIndicatorIndexList
                                                  .toList(),
                                              _model.contractname2TextController
                                                  .text,
                                              _model
                                                  .contractdescription2TextController
                                                  .text,
                                              _model.validitytype2Value!,
                                              _model.status2Value!,
                                              _model.contracttype2Value!,
                                              null,
                                            );
                                            if (_model
                                                    .contractnameactionoutput2 ==
                                                'null') {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        'Contract already exists'),
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
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        'Data contract \"${_model.contractnameactionoutput2}\" created.'),
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

                                            await Future.wait([
                                              Future(() async {
                                                safeSetState(() {
                                                  _model
                                                      .contractname2TextController
                                                      ?.clear();
                                                  _model
                                                      .contractdescription2TextController
                                                      ?.clear();
                                                });
                                              }),
                                              Future(() async {
                                                safeSetState(() {
                                                  _model
                                                      .validitytype2ValueController
                                                      ?.reset();
                                                  _model.status2ValueController
                                                      ?.reset();
                                                  _model
                                                      .contracttype2ValueController
                                                      ?.reset();
                                                });
                                              }),
                                              Future(() async {
                                                safeSetState(() {
                                                  _model
                                                      .checkboxgroupIndInd1ValueController
                                                      ?.reset();
                                                  _model
                                                      .checkboxgroupSharedInd1ValueController
                                                      ?.reset();
                                                });
                                              }),
                                            ]);
                                            await Future.wait([
                                              Future(() async {
                                                _model.listIndividualUserIndicators =
                                                    [];
                                                safeSetState(() {});
                                              }),
                                              Future(() async {
                                                _model.indIndicatorIndexList =
                                                    [];
                                                safeSetState(() {});
                                              }),
                                              Future(() async {
                                                _model.contractindicatorlistupdate =
                                                    [];
                                                safeSetState(() {});
                                              }),
                                            ]);
                                            FFAppState().isVisible2 = false;
                                            safeSetState(() {});

                                            safeSetState(() {});
                                          },
                                          text: 'Save',
                                          options: FFButtonOptions(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.25,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.03,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24.0, 0.0, 24.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
                                                      color: Colors.white,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                            elevation: 3.0,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5.0, 5.0, 0.0, 5.0),
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            await Future.wait([
                                              Future(() async {
                                                safeSetState(() {
                                                  _model
                                                      .checkboxgroupIndInd1ValueController
                                                      ?.reset();
                                                });
                                              }),
                                              Future(() async {
                                                safeSetState(() {
                                                  _model
                                                      .contractname2TextController
                                                      ?.clear();
                                                  _model
                                                      .contractdescription2TextController
                                                      ?.clear();
                                                });
                                              }),
                                              Future(() async {
                                                safeSetState(() {
                                                  _model
                                                      .validitytype2ValueController
                                                      ?.reset();
                                                  _model
                                                      .contracttype2ValueController
                                                      ?.reset();
                                                  _model.status2ValueController
                                                      ?.reset();
                                                });
                                              }),
                                            ]);
                                            await Future.wait([
                                              Future(() async {
                                                _model.listIndividualUserIndicators =
                                                    [];
                                                safeSetState(() {});
                                              }),
                                              Future(() async {
                                                _model.indIndicatorIndexList =
                                                    [];
                                                safeSetState(() {});
                                              }),
                                              Future(() async {
                                                _model.contractindicatorlistupdate =
                                                    [];
                                                safeSetState(() {});
                                              }),
                                            ]);
                                            FFAppState().isVisible2 = false;
                                            safeSetState(() {});
                                          },
                                          text: 'Cancel',
                                          options: FFButtonOptions(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.25,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.03,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24.0, 0.0, 24.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
                                                      color: Colors.white,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                            elevation: 3.0,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
