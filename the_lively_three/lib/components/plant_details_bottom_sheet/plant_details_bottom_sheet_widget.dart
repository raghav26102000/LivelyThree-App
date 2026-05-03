import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'plant_details_bottom_sheet_model.dart';
export 'plant_details_bottom_sheet_model.dart';

class PlantDetailsBottomSheetWidget extends StatefulWidget {
  const PlantDetailsBottomSheetWidget({
    super.key,
    required this.plantname,
    required this.color,
    required this.locPlantId,
    required this.fiberUpper,
    required this.fiberActual,
    required this.fiberLower,
    required this.proteinUpper,
    required this.proteinActual,
    required this.proteinLower,
    required this.fatUpper,
    required this.fatActual,
    required this.fatLower,
    required this.carbsUpper,
    required this.carbsActual,
    required this.carbsLower,
    required this.fiberUpperPlant,
    required this.fiberLowerPlant,
    required this.proteinUpperPlant,
    required this.proteinLowerPlant,
    required this.fatUpperPlant,
    required this.fatLowerPlant,
    required this.carbsUpperPlant,
    required this.carbsLowerPlant,
    required this.fiberRating,
    required this.proteinRating,
    bool? inThirdRule,
    required this.fiberValueReference,
    required this.carbsValueReference,
    required this.proteinValueReference,
    required this.fatValueReference,
    required this.portionSize,
    bool? portionSizeLocked,
    bool? showPortionSizeMenu,
  })  : this.inThirdRule = inThirdRule ?? false,
        this.portionSizeLocked = portionSizeLocked ?? false,
        this.showPortionSizeMenu = showPortionSizeMenu ?? false;

  final String? plantname;
  final String? color;
  final int? locPlantId;
  final double? fiberUpper;
  final double? fiberActual;
  final double? fiberLower;
  final double? proteinUpper;
  final double? proteinActual;
  final double? proteinLower;
  final double? fatUpper;
  final double? fatActual;
  final double? fatLower;
  final double? carbsUpper;
  final double? carbsActual;
  final double? carbsLower;
  final String? fiberUpperPlant;
  final String? fiberLowerPlant;
  final String? proteinUpperPlant;
  final String? proteinLowerPlant;
  final String? fatUpperPlant;
  final String? fatLowerPlant;
  final String? carbsUpperPlant;
  final String? carbsLowerPlant;
  final int? fiberRating;
  final int? proteinRating;
  final bool inThirdRule;
  final String? fiberValueReference;
  final String? carbsValueReference;
  final String? proteinValueReference;
  final String? fatValueReference;
  final double? portionSize;
  final bool portionSizeLocked;
  final bool showPortionSizeMenu;

  @override
  State<PlantDetailsBottomSheetWidget> createState() =>
      _PlantDetailsBottomSheetWidgetState();
}

class _PlantDetailsBottomSheetWidgetState
    extends State<PlantDetailsBottomSheetWidget> {
  late PlantDetailsBottomSheetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlantDetailsBottomSheetModel());

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
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: MediaQuery.sizeOf(context).height * 0.8,
      decoration: BoxDecoration(
        color: valueOrDefault<Color>(
          () {
            if (widget!.color == 'White') {
              return FlutterFlowTheme.of(context).alternate;
            } else if (widget!.color == 'Red') {
              return Color(0xFFFBDDDD);
            } else if (widget!.color == 'Orange') {
              return Color(0xFFF9E6CB);
            } else if (widget!.color == 'Yellow') {
              return Color(0xFFF9F4C1);
            } else if (widget!.color == 'Green') {
              return Color(0xFFE1FDDE);
            } else if (widget!.color == 'Purple') {
              return Color(0xFFF2D7F9);
            } else {
              return Color(0xFFD6CFC5);
            }
          }(),
          FlutterFlowTheme.of(context).alternate,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.1,
                height: MediaQuery.sizeOf(context).height * 0.007,
                decoration: BoxDecoration(
                  color: valueOrDefault<Color>(
                    () {
                      if (widget!.color == 'White') {
                        return FlutterFlowTheme.of(context).whiteBorder;
                      } else if (widget!.color == 'Red') {
                        return FlutterFlowTheme.of(context).redBorder;
                      } else if (widget!.color == 'Orange') {
                        return FlutterFlowTheme.of(context).orangeBorder;
                      } else if (widget!.color == 'Yellow') {
                        return FlutterFlowTheme.of(context).yellowBorder;
                      } else if (widget!.color == 'Green') {
                        return FlutterFlowTheme.of(context).greenBorder;
                      } else if (widget!.color == 'Purple') {
                        return FlutterFlowTheme.of(context).purpleBorder;
                      } else {
                        return FlutterFlowTheme.of(context).brownBorder;
                      }
                    }(),
                    FlutterFlowTheme.of(context).alternate,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            widget!.plantname,
                            'n/a',
                          ),
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .displaySmall
                              .override(
                                font: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .displaySmall
                                      .fontStyle,
                                ),
                                color: valueOrDefault<Color>(
                                  () {
                                    if (widget!.color == 'White') {
                                      return FlutterFlowTheme.of(context)
                                          .whiteBorder;
                                    } else if (widget!.color == 'Red') {
                                      return FlutterFlowTheme.of(context)
                                          .redBorder;
                                    } else if (widget!.color == 'Orange') {
                                      return FlutterFlowTheme.of(context)
                                          .orangeBorder;
                                    } else if (widget!.color == 'Yellow') {
                                      return FlutterFlowTheme.of(context)
                                          .yellowBorder;
                                    } else if (widget!.color == 'Green') {
                                      return FlutterFlowTheme.of(context)
                                          .greenBorder;
                                    } else if (widget!.color == 'Purple') {
                                      return FlutterFlowTheme.of(context)
                                          .purpleBorder;
                                    } else {
                                      return FlutterFlowTheme.of(context)
                                          .brownBorder;
                                    }
                                  }(),
                                  FlutterFlowTheme.of(context).alternate,
                                ),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 21),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .fontStyle,
                              ),
                        ),
                        if (widget!.inThirdRule == false)
                          Text(
                            '*',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: valueOrDefault<Color>(
                                    () {
                                      if (widget!.color == 'White') {
                                        return FlutterFlowTheme.of(context)
                                            .whiteBorder;
                                      } else if (widget!.color == 'Red') {
                                        return FlutterFlowTheme.of(context)
                                            .redBorder;
                                      } else if (widget!.color == 'Orange') {
                                        return FlutterFlowTheme.of(context)
                                            .orangeBorder;
                                      } else if (widget!.color == 'Yellow') {
                                        return FlutterFlowTheme.of(context)
                                            .yellowBorder;
                                      } else if (widget!.color == 'Green') {
                                        return FlutterFlowTheme.of(context)
                                            .greenBorder;
                                      } else if (widget!.color == 'Purple') {
                                        return FlutterFlowTheme.of(context)
                                            .purpleBorder;
                                      } else {
                                        return FlutterFlowTheme.of(context)
                                            .brownBorder;
                                      }
                                    }(),
                                    FlutterFlowTheme.of(context).alternate,
                                  ),
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 21),
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget!.inThirdRule == false)
                          Text(
                            '(* not part of rule 3: portions / day)',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 9),
                                  letterSpacing: 0.0,
                                  fontStyle: FontStyle.italic,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                      ],
                    ),
                    if (widget!.showPortionSizeMenu)
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 5.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Portion size: ',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize:
                                              FlutterFlowTheme.adjustScale(
                                                  size: 12),
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Text(
                                    '(update once per week)',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize:
                                              FlutterFlowTheme.adjustScale(
                                                  size: 8),
                                          letterSpacing: 0.0,
                                          fontStyle: FontStyle.italic,
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
                                  0.0, 0.0, 5.0, 0.0),
                              child: FlutterFlowDropDown<double>(
                                controller: _model
                                        .portionSizeDropDownValueController ??=
                                    FormFieldController<double>(
                                  _model.portionSizeDropDownValue ??=
                                      widget!.portionSize,
                                ),
                                options: List<double>.from([
                                  0.1,
                                  0.2,
                                  0.3,
                                  0.4,
                                  0.5,
                                  0.6,
                                  0.7,
                                  0.8,
                                  0.9,
                                  1.0
                                ]),
                                optionLabels: [
                                  '10 g',
                                  '20 g',
                                  '30 g',
                                  '40 g',
                                  '50 g',
                                  '60 g',
                                  '70 g',
                                  '80 g',
                                  '90 g',
                                  '100 g'
                                ],
                                onChanged: (val) => safeSetState(() =>
                                    _model.portionSizeDropDownValue = val),
                                width: MediaQuery.sizeOf(context).width * 0.25,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.032,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                hintText: 'Select...',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: valueOrDefault<double>(
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
                                fillColor: widget!.portionSizeLocked == false
                                    ? FlutterFlowTheme.of(context)
                                        .secondaryBackground
                                    : Color(0x00000000),
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                borderWidth: 1.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 12.0, 0.0),
                                hidesUnderline: true,
                                disabled: widget!.portionSizeLocked == true,
                                isOverButton: false,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                            if (widget!.portionSizeLocked == false)
                              FFButtonWidget(
                                onPressed: () async {
                                  var confirmDialogResponse = await showDialog<
                                          bool>(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title: Text('Portion size update'),
                                            content: Text(
                                                'The portion size will be updated to ${((_model.portionSizeDropDownValue!) * 100).toString()}g. It can be changed again as of next week. '),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext, false),
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext, true),
                                                child: Text('Confirm'),
                                              ),
                                            ],
                                          );
                                        },
                                      ) ??
                                      false;
                                  if (confirmDialogResponse) {
                                    await WeeklyselectedplantTable().update(
                                      data: {
                                        'portionsize':
                                            _model.portionSizeDropDownValue,
                                        'portionsize_locked': true,
                                      },
                                      matchingRows: (rows) => rows
                                          .eqOrNull(
                                            'id_loc',
                                            widget!.locPlantId,
                                          )
                                          .eqOrNull(
                                            'week',
                                            FFAppState().calendarWeek,
                                          )
                                          .eqOrNull(
                                            'year',
                                            FFAppState().calendarYear,
                                          )
                                          .eqOrNull(
                                            'id_user',
                                            currentUserUid,
                                          ),
                                    );

                                    context.pushNamed(
                                      PlantselectionWidget.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.topToBottom,
                                          duration: Duration(milliseconds: 200),
                                        ),
                                      },
                                    );
                                  }

                                  safeSetState(() {});
                                },
                                text: 'Update',
                                options: FFButtonOptions(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.25,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.032,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).secondary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleSmallFamily,
                                        color: Colors.white,
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 14),
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleSmallIsCustom,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(8.0),
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
          Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            height: MediaQuery.sizeOf(context).height * 0.15,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(7.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Fiber (g/100g)',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).titleLargeFamily,
                              fontSize: FlutterFlowTheme.adjustScale(size: 13),
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .titleLargeIsCustom,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await launchURL(valueOrDefault<String>(
                              widget!.fiberValueReference,
                              'n/a',
                            ));
                          },
                          child: Text(
                            'Reference',
                            textAlign: TextAlign.end,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 9),
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.1,
                        height: MediaQuery.sizeOf(context).width * 0.1,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          shape: BoxShape.circle,
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.fiberLower?.toString(),
                            '0',
                          ),
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Color(0xFF35373E),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 14),
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.13,
                        height: MediaQuery.sizeOf(context).width * 0.13,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            () {
                              if (widget!.color == 'White') {
                                return FlutterFlowTheme.of(context).alternate;
                              } else if (widget!.color == 'Red') {
                                return Color(0xFFFBDDDD);
                              } else if (widget!.color == 'Orange') {
                                return Color(0xFFF9E6CB);
                              } else if (widget!.color == 'Yellow') {
                                return Color(0xFFF9F4C1);
                              } else if (widget!.color == 'Green') {
                                return Color(0xFFE1FDDE);
                              } else if (widget!.color == 'Purple') {
                                return Color(0xFFF2D7F9);
                              } else {
                                return Color(0xFFD6CFC5);
                              }
                            }(),
                            FlutterFlowTheme.of(context).alternate,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: valueOrDefault<Color>(
                              () {
                                if (widget!.color == 'White') {
                                  return FlutterFlowTheme.of(context)
                                      .secondaryText;
                                } else if (widget!.color == 'Red') {
                                  return FlutterFlowTheme.of(context).redBorder;
                                } else if (widget!.color == 'Orange') {
                                  return FlutterFlowTheme.of(context)
                                      .orangeBorder;
                                } else if (widget!.color == 'Yellow') {
                                  return FlutterFlowTheme.of(context)
                                      .yellowBorder;
                                } else if (widget!.color == 'Green') {
                                  return FlutterFlowTheme.of(context)
                                      .greenBorder;
                                } else if (widget!.color == 'Purple') {
                                  return FlutterFlowTheme.of(context)
                                      .purpleBorder;
                                } else {
                                  return FlutterFlowTheme.of(context)
                                      .brownBorder;
                                }
                              }(),
                              FlutterFlowTheme.of(context).alternate,
                            ),
                          ),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.fiberActual == -1.0
                                ? '<0.5'
                                : valueOrDefault<String>(
                                    widget!.fiberActual?.toString(),
                                    '0',
                                  ),
                            '0',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: valueOrDefault<Color>(
                                  () {
                                    if (widget!.color == 'White') {
                                      return Color(0xFF403D3D);
                                    } else if (widget!.color == 'Red') {
                                      return Color(0xFF630C1C);
                                    } else if (widget!.color == 'Orange') {
                                      return Color(0xFF60390B);
                                    } else if (widget!.color == 'Yellow') {
                                      return Color(0xFF5E500A);
                                    } else if (widget!.color == 'Green') {
                                      return Color(0xFF1B4F0A);
                                    } else if (widget!.color == 'Purple') {
                                      return Color(0xFF520C34);
                                    } else {
                                      return Color(0xFF492F09);
                                    }
                                  }(),
                                  FlutterFlowTheme.of(context).alternate,
                                ),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 17),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.14,
                        height: MediaQuery.sizeOf(context).width * 0.14,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          shape: BoxShape.circle,
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.fiberUpper?.toString(),
                            '0',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Color(0xFF35373E),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 20),
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ].divide(SizedBox(
                        width: valueOrDefault<double>(
                      () {
                        if (FFAppState().screenCategory == 'small') {
                          return 12.0;
                        } else if (FFAppState().screenCategory == 'medium') {
                          return 14.0;
                        } else {
                          return 16.0;
                        }
                      }(),
                      16.0,
                    ))),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget!.fiberLowerPlant,
                          'n/a',
                        ),
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: FlutterFlowTheme.adjustScale(size: 12),
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget!.fiberUpperPlant,
                          'n/a',
                        ),
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: FlutterFlowTheme.adjustScale(size: 12),
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.32,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                width: 1.0,
                              ),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: RatingBarIndicator(
                              itemBuilder: (context, index) => Icon(
                                Icons.star_rounded,
                                color: valueOrDefault<Color>(
                                  () {
                                    if (widget!.fiberRating == 1) {
                                      return Color(0xFFEE5A57);
                                    } else if (widget!.fiberRating == 2) {
                                      return Color(0xFFF07C53);
                                    } else if (widget!.fiberRating == 3) {
                                      return Color(0xFFEE9D65);
                                    } else if (widget!.fiberRating == 4) {
                                      return Color(0xFFAB8127);
                                    } else if (widget!.fiberRating == 5) {
                                      return Color(0xFF9CAE59);
                                    } else if (widget!.fiberRating == 6) {
                                      return Color(0xFF4EB04A);
                                    } else {
                                      return Color(0xFF1E782C);
                                    }
                                  }(),
                                  FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                              direction: Axis.horizontal,
                              rating: widget!.fiberRating!.toDouble(),
                              unratedColor: Color(0xFFC3C1C1),
                              itemCount: 7,
                              itemSize: valueOrDefault<double>(
                                () {
                                  if (FFAppState().screenCategory == 'small') {
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            height: MediaQuery.sizeOf(context).height * 0.15,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(7.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Protein (g/100g)',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).titleLargeFamily,
                              fontSize: FlutterFlowTheme.adjustScale(size: 13),
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .titleLargeIsCustom,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await launchURL(valueOrDefault<String>(
                              widget!.proteinValueReference,
                              'n/a',
                            ));
                          },
                          child: Text(
                            'Reference',
                            textAlign: TextAlign.end,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 9),
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.1,
                        height: MediaQuery.sizeOf(context).width * 0.1,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          shape: BoxShape.circle,
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.proteinLower?.toString(),
                            '0',
                          ),
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Color(0xFF35373E),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 14),
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.13,
                        height: MediaQuery.sizeOf(context).width * 0.13,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            () {
                              if (widget!.color == 'White') {
                                return FlutterFlowTheme.of(context).alternate;
                              } else if (widget!.color == 'Red') {
                                return Color(0xFFFBDDDD);
                              } else if (widget!.color == 'Orange') {
                                return Color(0xFFF9E6CB);
                              } else if (widget!.color == 'Yellow') {
                                return Color(0xFFF9F4C1);
                              } else if (widget!.color == 'Green') {
                                return Color(0xFFE1FDDE);
                              } else if (widget!.color == 'Purple') {
                                return Color(0xFFF2D7F9);
                              } else {
                                return Color(0xFFD6CFC5);
                              }
                            }(),
                            FlutterFlowTheme.of(context).alternate,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: valueOrDefault<Color>(
                              () {
                                if (widget!.color == 'White') {
                                  return FlutterFlowTheme.of(context)
                                      .secondaryText;
                                } else if (widget!.color == 'Red') {
                                  return FlutterFlowTheme.of(context).redBorder;
                                } else if (widget!.color == 'Orange') {
                                  return FlutterFlowTheme.of(context)
                                      .orangeBorder;
                                } else if (widget!.color == 'Yellow') {
                                  return FlutterFlowTheme.of(context)
                                      .yellowBorder;
                                } else if (widget!.color == 'Green') {
                                  return FlutterFlowTheme.of(context)
                                      .greenBorder;
                                } else if (widget!.color == 'Purple') {
                                  return FlutterFlowTheme.of(context)
                                      .purpleBorder;
                                } else {
                                  return FlutterFlowTheme.of(context)
                                      .brownBorder;
                                }
                              }(),
                              FlutterFlowTheme.of(context).alternate,
                            ),
                          ),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.proteinActual == -1.0
                                ? '<0.5'
                                : valueOrDefault<String>(
                                    widget!.proteinActual?.toString(),
                                    '0',
                                  ),
                            '0',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: valueOrDefault<Color>(
                                  () {
                                    if (widget!.color == 'White') {
                                      return Color(0xFF403D3D);
                                    } else if (widget!.color == 'Red') {
                                      return Color(0xFF630C1C);
                                    } else if (widget!.color == 'Orange') {
                                      return Color(0xFF60390B);
                                    } else if (widget!.color == 'Yellow') {
                                      return Color(0xFF5E500A);
                                    } else if (widget!.color == 'Green') {
                                      return Color(0xFF1B4F0A);
                                    } else if (widget!.color == 'Purple') {
                                      return Color(0xFF520C34);
                                    } else {
                                      return Color(0xFF492F09);
                                    }
                                  }(),
                                  FlutterFlowTheme.of(context).alternate,
                                ),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 17),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.14,
                        height: MediaQuery.sizeOf(context).width * 0.14,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          shape: BoxShape.circle,
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.proteinUpper?.toString(),
                            '0',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Color(0xFF35373E),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 20),
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ].divide(SizedBox(
                        width: valueOrDefault<double>(
                      () {
                        if (FFAppState().screenCategory == 'small') {
                          return 12.0;
                        } else if (FFAppState().screenCategory == 'medium') {
                          return 14.0;
                        } else {
                          return 16.0;
                        }
                      }(),
                      16.0,
                    ))),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget!.proteinLowerPlant,
                          'n/a',
                        ),
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: FlutterFlowTheme.adjustScale(size: 12),
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget!.proteinUpperPlant,
                          'n/a',
                        ),
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: FlutterFlowTheme.adjustScale(size: 12),
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.32,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                width: 1.0,
                              ),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: RatingBarIndicator(
                              itemBuilder: (context, index) => Icon(
                                Icons.star_rounded,
                                color: valueOrDefault<Color>(
                                  () {
                                    if (widget!.proteinRating == 1) {
                                      return Color(0xFFEE5A57);
                                    } else if (widget!.proteinRating == 2) {
                                      return Color(0xFFF07C53);
                                    } else if (widget!.proteinRating == 3) {
                                      return Color(0xFFEE9D65);
                                    } else if (widget!.proteinRating == 4) {
                                      return Color(0xFFAB8127);
                                    } else if (widget!.proteinRating == 5) {
                                      return Color(0xFF9CAE59);
                                    } else if (widget!.proteinRating == 6) {
                                      return Color(0xFF4EB04A);
                                    } else {
                                      return Color(0xFF1E782C);
                                    }
                                  }(),
                                  FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                              direction: Axis.horizontal,
                              rating: valueOrDefault<double>(
                                widget!.proteinRating?.toDouble(),
                                0.0,
                              ),
                              unratedColor: Color(0xFFC3C1C1),
                              itemCount: 7,
                              itemSize: valueOrDefault<double>(
                                () {
                                  if (FFAppState().screenCategory == 'small') {
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            height: MediaQuery.sizeOf(context).height * 0.13,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(7.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Fat (g/100g)',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).titleLargeFamily,
                              fontSize: FlutterFlowTheme.adjustScale(size: 13),
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .titleLargeIsCustom,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await launchURL(valueOrDefault<String>(
                              widget!.fatValueReference,
                              'n/a',
                            ));
                          },
                          child: Text(
                            'Reference',
                            textAlign: TextAlign.end,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 9),
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.1,
                        height: MediaQuery.sizeOf(context).width * 0.1,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          shape: BoxShape.circle,
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.fatLower?.toString(),
                            '0',
                          ),
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Color(0xFF35373E),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 14),
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.13,
                        height: MediaQuery.sizeOf(context).width * 0.13,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            () {
                              if (widget!.color == 'White') {
                                return FlutterFlowTheme.of(context).alternate;
                              } else if (widget!.color == 'Red') {
                                return Color(0xFFFBDDDD);
                              } else if (widget!.color == 'Orange') {
                                return Color(0xFFF9E6CB);
                              } else if (widget!.color == 'Yellow') {
                                return Color(0xFFF9F4C1);
                              } else if (widget!.color == 'Green') {
                                return Color(0xFFE1FDDE);
                              } else if (widget!.color == 'Purple') {
                                return Color(0xFFF2D7F9);
                              } else {
                                return Color(0xFFD6CFC5);
                              }
                            }(),
                            FlutterFlowTheme.of(context).alternate,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: valueOrDefault<Color>(
                              () {
                                if (widget!.color == 'White') {
                                  return FlutterFlowTheme.of(context)
                                      .secondaryText;
                                } else if (widget!.color == 'Red') {
                                  return FlutterFlowTheme.of(context).redBorder;
                                } else if (widget!.color == 'Orange') {
                                  return FlutterFlowTheme.of(context)
                                      .orangeBorder;
                                } else if (widget!.color == 'Yellow') {
                                  return FlutterFlowTheme.of(context)
                                      .yellowBorder;
                                } else if (widget!.color == 'Green') {
                                  return FlutterFlowTheme.of(context)
                                      .greenBorder;
                                } else if (widget!.color == 'Purple') {
                                  return FlutterFlowTheme.of(context)
                                      .purpleBorder;
                                } else {
                                  return FlutterFlowTheme.of(context)
                                      .brownBorder;
                                }
                              }(),
                              FlutterFlowTheme.of(context).alternate,
                            ),
                          ),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.fatActual == -1.0
                                ? '<0.5'
                                : valueOrDefault<String>(
                                    widget!.fatActual?.toString(),
                                    '0',
                                  ),
                            '0',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: valueOrDefault<Color>(
                                  () {
                                    if (widget!.color == 'White') {
                                      return Color(0xFF403D3D);
                                    } else if (widget!.color == 'Red') {
                                      return Color(0xFF630C1C);
                                    } else if (widget!.color == 'Orange') {
                                      return Color(0xFF60390B);
                                    } else if (widget!.color == 'Yellow') {
                                      return Color(0xFF5E500A);
                                    } else if (widget!.color == 'Green') {
                                      return Color(0xFF1B4F0A);
                                    } else if (widget!.color == 'Purple') {
                                      return Color(0xFF520C34);
                                    } else {
                                      return Color(0xFF492F09);
                                    }
                                  }(),
                                  FlutterFlowTheme.of(context).alternate,
                                ),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 17),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.14,
                        height: MediaQuery.sizeOf(context).width * 0.14,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          shape: BoxShape.circle,
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.fatUpper?.toString(),
                            '0',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Color(0xFF35373E),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 20),
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ].divide(SizedBox(
                        width: valueOrDefault<double>(
                      () {
                        if (FFAppState().screenCategory == 'small') {
                          return 12.0;
                        } else if (FFAppState().screenCategory == 'medium') {
                          return 14.0;
                        } else {
                          return 16.0;
                        }
                      }(),
                      16.0,
                    ))),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget!.fatLowerPlant,
                          'n/a',
                        ),
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: FlutterFlowTheme.adjustScale(size: 11),
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget!.fatUpperPlant,
                          'n/a',
                        ),
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: FlutterFlowTheme.adjustScale(size: 12),
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            height: MediaQuery.sizeOf(context).height * 0.13,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(7.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Carbohydrate (g/100g)',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).titleLargeFamily,
                              fontSize: FlutterFlowTheme.adjustScale(size: 13),
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .titleLargeIsCustom,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await launchURL(valueOrDefault<String>(
                              widget!.carbsValueReference,
                              'n/a',
                            ));
                          },
                          child: Text(
                            'Reference',
                            textAlign: TextAlign.end,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 9),
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.1,
                        height: MediaQuery.sizeOf(context).width * 0.1,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          shape: BoxShape.circle,
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.carbsLower?.toString(),
                            '0',
                          ),
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Color(0xFF35373E),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 14),
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.13,
                        height: MediaQuery.sizeOf(context).width * 0.13,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            () {
                              if (widget!.color == 'White') {
                                return FlutterFlowTheme.of(context).alternate;
                              } else if (widget!.color == 'Red') {
                                return Color(0xFFFBDDDD);
                              } else if (widget!.color == 'Orange') {
                                return Color(0xFFF9E6CB);
                              } else if (widget!.color == 'Yellow') {
                                return Color(0xFFF9F4C1);
                              } else if (widget!.color == 'Green') {
                                return Color(0xFFE1FDDE);
                              } else if (widget!.color == 'Purple') {
                                return Color(0xFFF2D7F9);
                              } else {
                                return Color(0xFFD6CFC5);
                              }
                            }(),
                            FlutterFlowTheme.of(context).alternate,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: valueOrDefault<Color>(
                              () {
                                if (widget!.color == 'White') {
                                  return FlutterFlowTheme.of(context)
                                      .secondaryText;
                                } else if (widget!.color == 'Red') {
                                  return FlutterFlowTheme.of(context).redBorder;
                                } else if (widget!.color == 'Orange') {
                                  return FlutterFlowTheme.of(context)
                                      .orangeBorder;
                                } else if (widget!.color == 'Yellow') {
                                  return FlutterFlowTheme.of(context)
                                      .yellowBorder;
                                } else if (widget!.color == 'Green') {
                                  return FlutterFlowTheme.of(context)
                                      .greenBorder;
                                } else if (widget!.color == 'Purple') {
                                  return FlutterFlowTheme.of(context)
                                      .purpleBorder;
                                } else {
                                  return FlutterFlowTheme.of(context)
                                      .brownBorder;
                                }
                              }(),
                              FlutterFlowTheme.of(context).alternate,
                            ),
                          ),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.carbsActual == -1.0
                                ? '<0.5'
                                : valueOrDefault<String>(
                                    widget!.carbsActual?.toString(),
                                    '0',
                                  ),
                            '0',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: valueOrDefault<Color>(
                                  () {
                                    if (widget!.color == 'White') {
                                      return Color(0xFF403D3D);
                                    } else if (widget!.color == 'Red') {
                                      return Color(0xFF630C1C);
                                    } else if (widget!.color == 'Orange') {
                                      return Color(0xFF60390B);
                                    } else if (widget!.color == 'Yellow') {
                                      return Color(0xFF5E500A);
                                    } else if (widget!.color == 'Green') {
                                      return Color(0xFF1B4F0A);
                                    } else if (widget!.color == 'Purple') {
                                      return Color(0xFF520C34);
                                    } else {
                                      return Color(0xFF492F09);
                                    }
                                  }(),
                                  FlutterFlowTheme.of(context).alternate,
                                ),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 17),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.14,
                        height: MediaQuery.sizeOf(context).width * 0.14,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          shape: BoxShape.circle,
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.carbsUpper?.toString(),
                            '0',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Color(0xFF35373E),
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 20),
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ].divide(SizedBox(
                        width: valueOrDefault<double>(
                      () {
                        if (FFAppState().screenCategory == 'small') {
                          return 12.0;
                        } else if (FFAppState().screenCategory == 'medium') {
                          return 14.0;
                        } else {
                          return 16.0;
                        }
                      }(),
                      16.0,
                    ))),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget!.carbsLowerPlant,
                          'n/a',
                        ),
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: FlutterFlowTheme.adjustScale(size: 11),
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      decoration: BoxDecoration(),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget!.carbsUpperPlant,
                          'n/a',
                        ),
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: FlutterFlowTheme.adjustScale(size: 12),
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Bounds & ratings based on your selection',
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: FlutterFlowTheme.adjustScale(size: 11),
                          letterSpacing: 0.0,
                          fontStyle: FontStyle.italic,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
