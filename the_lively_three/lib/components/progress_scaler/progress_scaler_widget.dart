import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';

class ScoreRulerWidget extends StatelessWidget {
  final double userScore;
  final double communityScore;
  final int milestone;
  final String milestoneLabel;
  final Color currentColor;
  final bool hasConsent;
  final bool hasPadding;

  // ✅ New optional height property
  final double? height;
  final double? containerPaddingBottom;
  final double? containerPaddingTop;
  final double? heightMilestone;
  final double? heightUser;
  final double? heightCommunity;

  // ✅ New optional Plant-based Score values
  final double? userPlantBasedScore;
  final double? communityPlantBasedScore;
  final bool showPlantBasedDetails;
  final bool showBoxShadow;
  final bool isDotted;
  final Color textBG;
  final Color userPlantBasedColor;
  final Color communityPlantBasedColor;
  final Color userColor;
  final Color communityColor;
  final Color graphBG;
  final Color borderColor;
  final double? userTextWidth;
  final double? communityTextWidth;
  final double? milestoneTextWidth;
  final double? userPlantBasedTextWidth;
  final double? communityPlantBasedTextWidth;

  const ScoreRulerWidget({
    super.key,
    required this.userScore,
    required this.communityScore,
    required this.milestone,
    required this.currentColor,
    required this.hasConsent,
    this.milestoneLabel = "2nd Day Milestone",
    this.height, // optional
    this.userTextWidth = 0, // optional
    this.communityTextWidth = 0, // optional
    this.milestoneTextWidth = 0, // optional
    this.userPlantBasedTextWidth = 0, // optional
    this.communityPlantBasedTextWidth = 0, // optional
    this.containerPaddingBottom, // optional
    this.containerPaddingTop, // optional
    this.userPlantBasedScore, // optional
    this.communityPlantBasedScore, // optional
    this.heightMilestone, // optional
    this.heightUser, // optional
    this.heightCommunity, // optional
    this.textBG = const Color.fromARGB(0, 249, 249, 249),
    this.userPlantBasedColor = const Color(0xffBEC41C), // optional
    this.communityPlantBasedColor = const Color(0xff2e8b57), // optional
    this.userColor = const Color(0xffBEC41C), // optional
    this.communityColor = const Color(0xff2e8b57), // optional
    this.graphBG = const Color(0xfff9f9f9), // optional
    this.borderColor = const Color(0xffdedede), // optional
    this.showPlantBasedDetails = false,
    this.hasPadding = false,
    this.showBoxShadow = true,
    this.isDotted = true,
  });

  @override
  Widget build(BuildContext context) {
    int maxValue = max(
            milestone, max(userScore.toInt(), communityScore.toInt())) +
        (max(milestone, max(userScore.toInt(), communityScore.toInt())) * 0.1)
            .toInt();
    double containerHeight = height ?? 170;
    double paddingBottom = containerPaddingBottom ?? 74;
    double paddingTop = containerPaddingTop ?? 10;
    double communityHeight = heightCommunity ?? 30;
    double mileStoneHeight = heightMilestone ?? 70;
    double userHeight = heightUser ?? 30;
    double userWidth = userTextWidth != 0
        ? FlutterFlowTheme.adjustScale(size: userTextWidth!)
        : FlutterFlowTheme.adjustScale(size: 68);
    double communityWidth = communityTextWidth != 0
        ? FlutterFlowTheme.adjustScale(size: communityTextWidth!)
        : FlutterFlowTheme.adjustScale(size: 76);
    double milestoneWidth = milestoneTextWidth != 0
        ? FlutterFlowTheme.adjustScale(size: milestoneTextWidth!)
        : FlutterFlowTheme.adjustScale(size: 152);
    double userPlantBasedWidth = userPlantBasedTextWidth != 0
        ? FlutterFlowTheme.adjustScale(size: userPlantBasedTextWidth!)
        : FlutterFlowTheme.adjustScale(size: 124);
    double communityPlantBasedWidth = communityPlantBasedTextWidth != 0
        ? FlutterFlowTheme.adjustScale(size: communityPlantBasedTextWidth!)
        : FlutterFlowTheme.adjustScale(size: 140);

    return LayoutBuilder(
      builder: (context, constraints) {
        double rulerWidth = MediaQuery.sizeOf(context).width - 24;

        // Dynamic position calculations
        double userPosition =
            (userScore / maxValue).clamp(0.0, 1.0) * (rulerWidth - 24);
        double communityPosition =
            (communityScore / maxValue).clamp(0.0, 1.0) * (rulerWidth - 24);
        double milestonePosition =
            (milestone / maxValue).clamp(0.0, 1.0) * (rulerWidth - 40);

        // ✅ Plant-based positions (if provided)
        double userPlantBasedPosition = userPlantBasedScore != null
            ? (userPlantBasedScore! / maxValue).clamp(0.0, 1.0) *
                (rulerWidth - 24)
            : 0;
        double communityPlantBasedPosition = communityPlantBasedScore != null
            ? (communityPlantBasedScore! / maxValue).clamp(0.0, 1.0) *
                (rulerWidth - 24)
            : 0;

        double calculateScrollOffset({
          required double position,
          required double containerWidth,
          required double deviceWidth,
        }) {
          final halfContainer = containerWidth / 2;
          if (position < halfContainer) return position + 2;
          if (position + halfContainer > deviceWidth - 24)
            return containerWidth;
          return halfContainer;
        }

        double userPositionOffset = calculateScrollOffset(
          position: userPosition,
          containerWidth: hasPadding ? userWidth + 8 : userWidth,
          deviceWidth: MediaQuery.of(context).size.width,
        );
        double communityPositionOffset = calculateScrollOffset(
          position: communityPosition,
          containerWidth: hasPadding ? communityWidth + 8 : communityWidth,
          deviceWidth: MediaQuery.of(context).size.width,
        );
        double milestonePositionOffset = calculateScrollOffset(
          position: milestonePosition,
          containerWidth: milestoneWidth,
          deviceWidth: MediaQuery.of(context).size.width,
        );
        double userPlantBasedOffset = calculateScrollOffset(
          position: userPlantBasedPosition,
          containerWidth: userPlantBasedWidth,
          deviceWidth: MediaQuery.of(context).size.width,
        );
        double communityPlantBasedOffset = calculateScrollOffset(
          position: communityPlantBasedPosition,
          containerWidth: communityPlantBasedWidth,
          deviceWidth: MediaQuery.of(context).size.width,
        );

        return Container(
          padding: const EdgeInsets.all(12),
          width: rulerWidth,
          decoration: BoxDecoration(
            color: graphBG,
            border: Border.all(
                color: borderColor, style: BorderStyle.solid, width: 1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: showBoxShadow
                ? const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: containerHeight, // ✅ Dynamic height here
                padding:
                    EdgeInsets.only(bottom: paddingBottom, top: paddingTop),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Ruler with ticks
                    Align(
                      alignment: AlignmentDirectional(0, 0.0),
                      child: Column(
                        spacing: 6,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color(0xffececec),
                                          Color.fromARGB(0, 236, 236, 236)
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: [0.8, 1.0])),
                              ),
                              if (hasConsent)
                                Align(
                                  alignment: AlignmentDirectional(-1, 0.0),
                                  child: Container(
                                    height: 20,
                                    width: communityPosition,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(99)),
                                        color: communityColor),
                                  ),
                                ),

                              Align(
                                alignment: AlignmentDirectional(-1, 0.0),
                                child: Container(
                                  height: 20,
                                  width: communityPlantBasedPosition,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(99)),
                                      color: communityPlantBasedColor),
                                ),
                              ),
                              // ✅ Community Plant-Based Score Marker
                              if (showPlantBasedDetails)
                                Positioned(
                                  left: communityPlantBasedPosition,
                                  bottom: 0,
                                  child: isDotted
                                      ? DottedLine(
                                          width: 30,
                                          height: 1,
                                          color: communityPlantBasedColor,
                                          isVertical: true,
                                          spacing: 3,
                                          dotHeight: 2,
                                          dotWidth: 1,
                                        )
                                      : Container(
                                          width: 2,
                                          height: 30,
                                          color: communityPlantBasedColor,
                                        ),
                                ),
                              if (showPlantBasedDetails)
                                Positioned(
                                  left: communityPlantBasedPosition,
                                  bottom: 30,
                                  child: Transform.translate(
                                    offset:
                                        Offset(-communityPlantBasedOffset, 0),
                                    child: Container(
                                      padding: hasPadding
                                          ? const EdgeInsets.all(4)
                                          : EdgeInsets.zero,
                                      width: communityPlantBasedWidth,
                                      decoration: BoxDecoration(
                                        color: textBG,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text: "Comm Plant Protein:\n",
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 12),
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .blackText,
                                            ),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '$communityPlantBasedScore',
                                                  style: TextStyle(
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 16),
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
// ❌ Consent not given box
                              if (!hasConsent)
                                Positioned(
                                  left: 0,
                                  bottom: 20,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    width: 160,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xffb8b8b8),
                                          width: 1,
                                          style: BorderStyle.solid),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 8,
                                      children: [
                                        Icon(Icons.block,
                                            size: FlutterFlowTheme.adjustScale(
                                                size: 14)),
                                        Text(
                                          'Unlock Community Score',
                                          style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 8),
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              // Community Score
                              if (hasConsent)
                                Positioned(
                                  left: communityPosition,
                                  bottom: 0,
                                  child: isDotted
                                      ? DottedLine(
                                          width: communityHeight,
                                          height: 1,
                                          color: communityColor,
                                          isVertical: true,
                                          spacing: 3,
                                          dotHeight: 2,
                                          dotWidth: 1,
                                        )
                                      : Container(
                                          width: 2,
                                          height: communityHeight,
                                          color: communityColor),
                                ),
                              if (hasConsent)
                                Positioned(
                                  left: communityPosition,
                                  bottom: communityHeight,
                                  child: Transform.translate(
                                    offset: Offset(-communityPositionOffset, 0),
                                    child: Container(
                                      width: hasPadding
                                          ? communityWidth + 8
                                          : communityWidth,
                                      padding: hasPadding
                                          ? const EdgeInsets.all(4)
                                          : EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        color: textBG,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text: showPlantBasedDetails
                                                ? 'Comm Total Protein:\n'
                                                : "Community\n",
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 12),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .blackText,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${communityScore.toInt()} g',
                                                  style: TextStyle(
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 16),
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color(0xffececec),
                                          Color.fromARGB(0, 236, 236, 236)
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: [0.8, 1.0])),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-1, 0.0),
                                child: Container(
                                  height: 20,
                                  width: userPosition,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(99)),
                                      color: userColor),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-1, 0.0),
                                child: Container(
                                  height: 20,
                                  width: userPlantBasedPosition,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(99)),
                                      color: userPlantBasedColor),
                                ),
                              ),

                              // ✅ User Plant-Based Score Marker
                              if (showPlantBasedDetails)
                                Positioned(
                                  left: userPlantBasedPosition,
                                  bottom: -10,
                                  child: isDotted
                                      ? DottedLine(
                                          width: 30,
                                          height: 1,
                                          color: userPlantBasedColor,
                                          isVertical: true,
                                          spacing: 3,
                                          dotHeight: 2,
                                          dotWidth: 1,
                                        )
                                      : Container(
                                          width: 2,
                                          height: 30,
                                          color: userPlantBasedColor,
                                        ),
                                ),
                              if (showPlantBasedDetails)
                                Positioned(
                                  left: userPlantBasedPosition,
                                  bottom: -50,
                                  child: Transform.translate(
                                    offset: Offset(-userPlantBasedOffset, 0),
                                    child: Container(
                                      width: userPlantBasedWidth,
                                      padding: hasPadding
                                          ? const EdgeInsets.all(4)
                                          : EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        color: textBG,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text: "Your Plant Protein:\n",
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 12),
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .blackText,
                                            ),
                                            children: [
                                              TextSpan(
                                                  text: '$userPlantBasedScore',
                                                  style: TextStyle(
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 16),
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),

                              // User Score
                              Positioned(
                                left: userPosition,
                                bottom: -userHeight + 20,
                                child: isDotted
                                    ? DottedLine(
                                        width: userHeight,
                                        height: 1,
                                        color: userColor,
                                        isVertical: true,
                                        spacing: 3,
                                        dotHeight: 2,
                                        dotWidth: 1,
                                      )
                                    : Container(
                                        width: 2,
                                        height: userHeight,
                                        color: userColor,
                                      ),
                              ),
                              Positioned(
                                left: userPosition,
                                bottom: -userHeight - 15,
                                child: Transform.translate(
                                  offset: Offset(-userPositionOffset, 0),
                                  child: Container(
                                    padding: hasPadding
                                        ? const EdgeInsets.all(4)
                                        : EdgeInsets.zero,
                                    width:
                                        hasPadding ? userWidth + 8 : userWidth,
                                    decoration: BoxDecoration(
                                      color: textBG,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text: showPlantBasedDetails
                                              ? "Your Total Protein\n"
                                              : "Your Score\n",
                                          style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 12),
                                            color: FlutterFlowTheme.of(context)
                                                .blackText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                                text: '${userScore.toInt()} g',
                                                style: TextStyle(
                                                    fontSize: FlutterFlowTheme
                                                        .adjustScale(size: 16),
                                                    fontWeight:
                                                        FontWeight.w700))
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Milestone Marker
                    Positioned(
                      left: milestonePosition,
                      bottom: -mileStoneHeight,
                      child: Transform.translate(
                          offset: Offset(-milestonePositionOffset, 0),
                          child: Container(
                            width: milestoneWidth,
                            color: Colors.transparent,
                            child: RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                  text: '$milestoneLabel :',
                                  style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      color: FlutterFlowTheme.of(context)
                                          .blackText,
                                      fontWeight: FontWeight.w500,
                                      height: 1.33),
                                  children: [
                                    TextSpan(
                                        text: '$milestone',
                                        style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 16),
                                            color: FlutterFlowTheme.of(context)
                                                .blackText,
                                            height: 1,
                                            fontWeight: FontWeight.w700))
                                  ]),
                            ),
                          )),
                    ),
                    Positioned(
                      left: milestonePosition,
                      bottom: -mileStoneHeight + 20,
                      child: DottedLine(
                        width: mileStoneHeight,
                        height: 1,
                        color: Color(0xff979797),
                        isVertical: true,
                        spacing: 3,
                        dotHeight: 2,
                        dotWidth: 1,
                      ),
                    ),

                    // Positioned.fill(
                    //   child: CustomPaint(
                    //     painter: _RulerPainter(maxValue: maxValue),
                    //   ),
                    // ),
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

// Painter for the ruler ticks
class _RulerPainter extends CustomPainter {
  int maxValue;
  _RulerPainter({required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;
    double step = size.width / maxValue;

    for (int i = 0; i <= maxValue; i++) {
      double x = i * step;
      canvas.drawLine(
          Offset(x, size.height - 10), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DottedLine extends StatelessWidget {
  final double width; // Total line width
  final double height; // Line thickness
  final Color color; // Color of dot/dash
  final double spacing; // Space between items
  final double dotWidth; // Dot width (new)
  final double dotHeight; // Dot height (new)
  final bool isDash; // Draw dash instead of dot (new)
  final bool isVertical; // Orientation

  const DottedLine({
    super.key,
    this.width = 200,
    this.height = 2,
    this.color = Colors.black,
    this.spacing = 4,
    this.dotWidth = 4, // Previously dotRadius * 2
    this.dotHeight = 4, // Previously dotRadius * 2
    this.isDash = false, // false -> dot mode (same behavior)
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: isVertical ? Size(height, width) : Size(width, height),
      painter: _DottedLinePainter(
        color: color,
        spacing: spacing,
        dotWidth: dotWidth,
        dotHeight: dotHeight,
        isDash: isDash,
        isVertical: isVertical,
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double dotWidth;
  final double dotHeight;
  final bool isDash;
  final bool isVertical;

  _DottedLinePainter({
    required this.color,
    required this.spacing,
    required this.dotWidth,
    required this.dotHeight,
    required this.isDash,
    required this.isVertical,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final maxLength = isVertical ? size.height : size.width;
    double current = 0;

    while (current < maxLength) {
      final dx = isVertical ? (size.width - dotWidth) / 2 : current;
      final dy = isVertical ? current : (size.height - dotHeight) / 2;

      if (isDash) {
        // Draw dash (rectangle)
        canvas.drawRect(Rect.fromLTWH(dx, dy, dotWidth, dotHeight), paint);
      } else {
        // Draw dot (ellipse/circle)
        canvas.drawOval(Rect.fromLTWH(dx, dy, dotWidth, dotHeight), paint);
      }

      current += dotWidth + spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
