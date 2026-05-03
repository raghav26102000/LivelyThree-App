import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'selected_choice_chip_model.dart';
export 'selected_choice_chip_model.dart';

class SelectedChoiceChipWidget extends StatefulWidget {
  const SelectedChoiceChipWidget({
    super.key,
    required this.plantname,
    required this.color,
    this.borderColorTapped,
    this.borderColorUntapped,
    required this.updateSelectionChoiceChip,
    required this.colorTextUntapped,
    required this.colorTextTapped,
    required this.colorContainerTapped,
    required this.colorContainerUntapped,
    required this.sizeTextUntapped,
    required this.sizeTextTapped,
    required this.shadowColorUntapped,
    required this.shadowColorTapped,
    required this.locId,
  });

  final String? plantname;
  final String? color;
  final Color? borderColorTapped;
  final Color? borderColorUntapped;
  final Future Function(bool selected)? updateSelectionChoiceChip;
  final Color? colorTextUntapped;
  final Color? colorTextTapped;
  final Color? colorContainerTapped;
  final Color? colorContainerUntapped;
  final int? sizeTextUntapped;
  final int? sizeTextTapped;
  final Color? shadowColorUntapped;
  final Color? shadowColorTapped;
  final int? locId;

  @override
  State<SelectedChoiceChipWidget> createState() =>
      _SelectedChoiceChipWidgetState();
}

class _SelectedChoiceChipWidgetState extends State<SelectedChoiceChipWidget>
    with TickerProviderStateMixin {
  late SelectedChoiceChipModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectedChoiceChipModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.selectedPlantOutput = await WeeklyselectedplantTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'id_user',
              currentUserUid,
            )
            .eqOrNull(
              'week',
              FFAppState().calendarWeek,
            )
            .eqOrNull(
              'id_loc',
              widget!.locId,
            )
            .eqOrNull(
              'color',
              widget!.color,
            )
            .eqOrNull(
              'year',
              FFAppState().calendarYear,
            ),
      );
      _model.selected = _model.selectedPlantOutput != null &&
              (_model.selectedPlantOutput)!.isNotEmpty
          ? true
          : false;
      _model.updatePage(() {});
    });

    animationsMap.addAll({
      'containerOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 80.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(1.2, 1.2),
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
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        _model.selectedPlantPortionOutput =
            await WeeklyselectedplantTable().queryRows(
          queryFn: (q) => q
              .eqOrNull(
                'id_user',
                currentUserUid,
              )
              .eqOrNull(
                'week',
                FFAppState().calendarWeek,
              )
              .eqOrNull(
                'id_loc',
                widget!.locId,
              )
              .eqOrNull(
                'color',
                widget!.color,
              )
              .gtOrNull(
                'portionsum',
                0.0,
              )
              .eqOrNull(
                'year',
                FFAppState().calendarYear,
              ),
        );
        if (_model.selectedPlantPortionOutput != null &&
            (_model.selectedPlantPortionOutput)!.isNotEmpty) {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Portions detected'),
                content: Text(
                    'You still have portions logged. Decrease to 0 and deselect again.                       '),
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
          _model.selected = !_model.selected;
          _model.updatePage(() {});
        }

        await widget.updateSelectionChoiceChip?.call(
          _model.selected,
        );

        safeSetState(() {});
      },
      child: Container(
        height: 30.0,
        decoration: BoxDecoration(
          color: valueOrDefault<Color>(
            _model.selected == true
                ? widget!.colorContainerTapped
                : widget!.colorContainerUntapped,
            FlutterFlowTheme.of(context).alternate,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: valueOrDefault<double>(
                _model.selected == true ? 4.0 : 1.0,
                0.0,
              ),
              color: _model.selected == true
                  ? widget!.shadowColorTapped!
                  : widget!.shadowColorUntapped!,
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: valueOrDefault<Color>(
              _model.selected == true
                  ? widget!.borderColorTapped
                  : widget!.borderColorUntapped,
              FlutterFlowTheme.of(context).primaryText,
            ),
            width: _model.selected == true ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
              child: Text(
                valueOrDefault<String>(
                  widget!.plantname,
                  'n/a',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: _model.selected == true
                          ? widget!.colorTextTapped
                          : widget!.colorTextUntapped,
                      fontSize: _model.selected == true
                          ? widget!.sizeTextTapped?.toDouble()
                          : widget!.sizeTextUntapped?.toDouble(),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ),
          ].divide(SizedBox(width: 2.0)).around(SizedBox(width: 2.0)),
        ),
      ),
    ).animateOnActionTrigger(
      animationsMap['containerOnActionTriggerAnimation']!,
    );
  }
}
