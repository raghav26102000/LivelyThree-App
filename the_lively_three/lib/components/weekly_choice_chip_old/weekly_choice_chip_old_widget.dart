import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'weekly_choice_chip_old_model.dart';
export 'weekly_choice_chip_old_model.dart';

class WeeklyChoiceChipOldWidget extends StatefulWidget {
  const WeeklyChoiceChipOldWidget({
    super.key,
    required this.plantname,
    required this.portionsum,
    required this.colorTextUntapped,
    required this.colorTextTapped,
    required this.colorContainerTapped,
    required this.colorContainerUntapped,
    required this.sizeTextUntapped,
    required this.sizeTextTapped,
    required this.shadowColorUntapped,
    required this.shadowColorTapped,
    required this.color,
    this.borderColorTapped,
    this.borderColorUntapped,
    required this.updateSelectedAction,
  });

  final String? plantname;
  final double? portionsum;
  final Color? colorTextUntapped;
  final Color? colorTextTapped;
  final Color? colorContainerTapped;
  final Color? colorContainerUntapped;
  final int? sizeTextUntapped;
  final int? sizeTextTapped;
  final Color? shadowColorUntapped;
  final Color? shadowColorTapped;
  final String? color;
  final Color? borderColorTapped;
  final Color? borderColorUntapped;
  final Future Function(bool selected)? updateSelectedAction;

  @override
  State<WeeklyChoiceChipOldWidget> createState() =>
      _WeeklyChoiceChipOldWidgetState();
}

class _WeeklyChoiceChipOldWidgetState extends State<WeeklyChoiceChipOldWidget>
    with TickerProviderStateMixin {
  late WeeklyChoiceChipOldModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WeeklyChoiceChipOldModel());

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
        if (animationsMap['containerOnActionTriggerAnimation'] != null) {
          await animationsMap['containerOnActionTriggerAnimation']!
              .controller
              .forward(from: 0.0);
        }
        await actions.updateWeeklySelectedPlant(
          currentUserUid,
          FFAppState().calendarWeek,
          FFAppState().calendarYear,
          widget!.plantname!,
          widget!.color!,
        );
        FFAppState().dummy = !(FFAppState().dummy ?? true);
        _model.updatePage(() {});
        if (animationsMap['containerOnActionTriggerAnimation'] != null) {
          await animationsMap['containerOnActionTriggerAnimation']!
              .controller
              .reverse();
        }
      },
      child: Container(
        height: 30.0,
        decoration: BoxDecoration(
          color: valueOrDefault<Color>(
            widget!.portionsum! > 0.0
                ? widget!.colorContainerTapped
                : widget!.colorContainerUntapped,
            FlutterFlowTheme.of(context).alternate,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: valueOrDefault<double>(
                widget!.portionsum! > 0.0 ? 4.0 : 1.0,
                0.0,
              ),
              color: widget!.portionsum! > 0.0
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
              widget!.portionsum! > 0.0
                  ? widget!.borderColorTapped
                  : widget!.borderColorUntapped,
              FlutterFlowTheme.of(context).alternate,
            ),
            width: widget!.portionsum! > 0.0 ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  widget!.plantname,
                  'n/a',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: widget!.portionsum! > 0.0
                          ? widget!.colorTextTapped
                          : widget!.colorTextUntapped,
                      fontSize: widget!.portionsum! > 0.0
                          ? widget!.sizeTextTapped?.toDouble()
                          : widget!.sizeTextUntapped?.toDouble(),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ),
            Text(
              '/',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: widget!.portionsum! > 0.0
                        ? widget!.colorTextTapped
                        : widget!.colorTextUntapped,
                    fontSize: widget!.portionsum! > 0.0
                        ? widget!.sizeTextTapped?.toDouble()
                        : widget!.sizeTextUntapped?.toDouble(),
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  widget!.portionsum?.toString(),
                  '0',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: widget!.portionsum! > 0.0
                          ? widget!.colorTextTapped
                          : widget!.colorTextUntapped,
                      fontSize: widget!.portionsum! > 0.0
                          ? widget!.sizeTextTapped?.toDouble()
                          : widget!.sizeTextUntapped?.toDouble(),
                      letterSpacing: 0.0,
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
