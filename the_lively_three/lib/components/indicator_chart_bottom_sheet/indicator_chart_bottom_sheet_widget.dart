import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'indicator_chart_bottom_sheet_model.dart';
export 'indicator_chart_bottom_sheet_model.dart';

class IndicatorChartBottomSheetWidget extends StatefulWidget {
  const IndicatorChartBottomSheetWidget({
    super.key,
    required this.indicatorName,
    required this.userId,
    required this.isCommunity,
    required this.hasSubscription,
    required this.isPercentageScale,
  });

  final String? indicatorName;
  final String? userId;
  final bool? isCommunity;
  final bool? hasSubscription;
  final bool? isPercentageScale;

  @override
  State<IndicatorChartBottomSheetWidget> createState() =>
      _IndicatorChartBottomSheetWidgetState();
}

class _IndicatorChartBottomSheetWidgetState
    extends State<IndicatorChartBottomSheetWidget> {
  late IndicatorChartBottomSheetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IndicatorChartBottomSheetModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {});

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.1,
                  height: MediaQuery.sizeOf(context).height * 0.007,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: MediaQuery.sizeOf(context).height * 0.45,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      height: MediaQuery.sizeOf(context).height * 0.45,
                      child: custom_widgets.ChartWidget(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: MediaQuery.sizeOf(context).height * 0.45,
                        chartHeightRatio: 0.7,
                        indicatorName: widget!.indicatorName!,
                        userId: widget!.userId!,
                        bottomSheetColor: Color(0xFFE9F9F9),
                        bottomSheetOpacity: 0.8,
                        isCommunity: widget!.isCommunity!,
                        isPercentageScale: widget!.isPercentageScale!,
                      ),
                    ),
                    if (widget!.hasSubscription == false)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 14.0,
                            sigmaY: 14.0,
                          ),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            height: MediaQuery.sizeOf(context).height * 0.45,
                            decoration: BoxDecoration(
                              color: Color(0x79FFFFFF),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.5,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            'Please subscribe to view long-term track records. ',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                          SettingsWidget.routeName,
                                          queryParameters: {
                                            'settingsTabObjective':
                                                serializeParam(
                                              5,
                                              ParamType.int,
                                            ),
                                          }.withoutNulls,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/Subscription.png',
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.8,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.2,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
      ],
    );
  }
}
