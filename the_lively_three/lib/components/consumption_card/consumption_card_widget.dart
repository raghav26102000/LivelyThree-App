import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import '/l10n/app_localizations.dart';

class ConsumptionCard extends StatelessWidget {
  final String dateText;
  final String totalPortion;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final List<Widget> children;
  final bool hasFixedHeight;
  final bool showDateChangeIcon;
  final bool showTotalPortion;

  const ConsumptionCard({
    super.key,
    required this.dateText,
    required this.totalPortion,
    required this.children,
    this.hasFixedHeight = true,
    required this.showDateChangeIcon,
    this.onPrev,
    this.onNext,
    this.showTotalPortion = true,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 12.0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment:
                    Alignment.topCenter, //AlignmentDirectional(0.0, 1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(4.0, 15.0, 4.0, 0.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.98,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 0.0,
                      ),
                    ),
                    child: Padding(
                      padding: showTotalPortion
                          ? EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 10.0)
                          : EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 12.0),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8.0,
                                    color: Color(0x17000000),
                                    offset: Offset(
                                      0.0,
                                      3.0,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: showTotalPortion
                                    ? EdgeInsetsDirectional.fromSTEB(
                                        8.0, 20.0, 8.0, 4.0)
                                    : EdgeInsetsDirectional.fromSTEB(
                                        8.0, 12.0, 8.0, 12.0),
                                child: hasFixedHeight
                                    ? Container(
                                        height: 60,
                                        decoration: BoxDecoration(),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Wrap(
                                                spacing: 4,
                                                children: children,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        constraints:
                                            BoxConstraints(minHeight: 60),
                                        decoration: BoxDecoration(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Wrap(
                                              spacing: 4,
                                              children: children,
                                            )
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          if (showTotalPortion)
                            Align(
                                alignment:
                                    const AlignmentDirectional(0.0, -1.0),
                                child: IntrinsicWidth(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(99.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${locale.totalPortions}: ',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font:
                                                      GoogleFonts.montserrat(),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: FlutterFlowTheme
                                                      .adjustScale(size: 10.0),
                                                ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            totalPortion,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: FlutterFlowTheme
                                                      .adjustScale(size: 10.0),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(99.0),
                      ),
                      alignment: AlignmentDirectional(0.0, -1.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: showDateChangeIcon
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: showDateChangeIcon
                            ? [
                                if (showDateChangeIcon)
                                  InkWell(
                                      onTap: onPrev,
                                      child: Icon(
                                        Icons.chevron_left,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24.0,
                                      )),
                                Text(
                                  dateText,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 15.0),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                if (showDateChangeIcon)
                                  InkWell(
                                    onTap: onNext,
                                    child: Icon(
                                      Icons.chevron_right,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                  )
                              ]
                            : [
                                Text(
                                  dateText,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 15.0),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
