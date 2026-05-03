import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'nutrient_value_model.dart';
export 'nutrient_value_model.dart';

class NutrientValueWidget extends StatefulWidget {
  const NutrientValueWidget({
    super.key,
    required this.nutrientName,
    required this.nutrientReference,
    required this.nutrientValue,
    required this.nutrientId,
    required this.blueprintId,
    required this.updateActionNutrientValue,
    required this.updateActionNutrientReference,
    this.updateActionNutrientDescription,
  });

  final String? nutrientName;
  final String? nutrientReference;
  final double? nutrientValue;
  final int? nutrientId;
  final int? blueprintId;
  final Future Function(double? callbackNutrientvalue)?
      updateActionNutrientValue;
  final Future Function(String? callbackNutrientReference)?
      updateActionNutrientReference;
  final Future Function(String callbackNutrientDescription)?
      updateActionNutrientDescription;

  @override
  State<NutrientValueWidget> createState() => _NutrientValueWidgetState();
}

class _NutrientValueWidgetState extends State<NutrientValueWidget> {
  late NutrientValueModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NutrientValueModel());

    _model.referenceTextFieldTextController ??= TextEditingController(
        text: valueOrDefault<String>(
      widget!.nutrientReference,
      'n/a',
    ));
    _model.referenceTextFieldFocusNode ??= FocusNode();

    _model.valueTextFieldTextController ??=
        TextEditingController(text: widget!.nutrientValue?.toString());
    _model.valueTextFieldFocusNode ??= FocusNode();

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

    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      height: MediaQuery.sizeOf(context).height * 0.08,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
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
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      valueOrDefault<String>(
                        widget!.nutrientName,
                        'n/a',
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            fontSize: valueOrDefault<double>(
                              () {
                                if (FFAppState().screenCategory == 'small') {
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
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    height: MediaQuery.sizeOf(context).height * 0.03,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.2,
                        child: TextFormField(
                          controller: _model.referenceTextFieldTextController,
                          focusNode: _model.referenceTextFieldFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.referenceTextFieldTextController',
                            Duration(milliseconds: 2000),
                            () async {
                              await widget.updateActionNutrientReference?.call(
                                _model.referenceTextFieldTextController.text,
                              );
                              _model.referencecolor = Color(0xFFDEECAA);
                              safeSetState(() {});
                            },
                          ),
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: false,
                            labelText: 'Reference',
                            labelStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 10.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                            alignLabelWithHint: true,
                            hintText: 'Reference',
                            hintStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 10.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: valueOrDefault<Color>(
                              _model.valuecolor,
                              FlutterFlowTheme.of(context).alternate,
                            ),
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 0.0, 0.0),
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                          textAlign: TextAlign.start,
                          minLines: 1,
                          validator: _model
                              .referenceTextFieldTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      children: [
                        Text(
                          valueOrDefault<String>(
                            widget!.nutrientId?.toString(),
                            '0',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 10.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.15,
                          height: MediaQuery.sizeOf(context).height * 0.06,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.2,
                            child: TextFormField(
                              controller: _model.valueTextFieldTextController,
                              focusNode: _model.valueTextFieldFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.valueTextFieldTextController',
                                Duration(milliseconds: 2000),
                                () async {
                                  await widget.updateActionNutrientValue?.call(
                                    double.tryParse(_model
                                        .valueTextFieldTextController.text),
                                  );
                                  _model.valuecolor = Color(0xFFDEECAA);
                                  safeSetState(() {});
                                },
                              ),
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: false,
                                labelText: 'Value',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 10.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                hintText: 'Value',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 10.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: valueOrDefault<Color>(
                                  _model.valuecolor,
                                  FlutterFlowTheme.of(context).alternate,
                                ),
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 0.0, 0.0),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                              textAlign: TextAlign.center,
                              minLines: 1,
                              validator: _model
                                  .valueTextFieldTextControllerValidator
                                  .asValidator(context),
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
    );
  }
}
