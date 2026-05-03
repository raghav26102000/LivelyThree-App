import 'package:flutter/material.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';

class DoubleBarWidget extends StatelessWidget {
  final double totalValue;
  final double? upperValue;
  final Color lowerColor;
  final Color upperColor;
  final Color? textColor;
  final double maxBarHeight;
  final double barWidth;
  final bool showStar;
  final bool hasGradient;

  const DoubleBarWidget({
    super.key,
    required this.totalValue,
    this.upperValue,
    this.lowerColor = const Color(0xFF6FCF97), // default greenish
    this.upperColor = const Color(0xFF2F80ED), // default blueish
    this.textColor = const Color(0xFF000000), // default blueish
    this.maxBarHeight = 180,
    this.barWidth = 20,
    this.showStar = false,
    this.hasGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveUpper = upperValue ?? 0;
    final lowerPart = (totalValue - effectiveUpper).clamp(0, totalValue);
    final scale = 135 / maxBarHeight;

    final lowerHeight = lowerPart * scale;
    final upperHeight = effectiveUpper * scale;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top numeric labels
        Text(
          formatValue(totalValue),
          style: TextStyle(
              color: textColor ?? upperColor,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              height: 1.2),
        ),
        const SizedBox(height: 4),

        // Bar visualization
        Container(
          width: barWidth,
          height: 135,
          decoration: BoxDecoration(
            color: const Color(0xffececec),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Upper section (if any)
              if (upperValue != null)
                Container(
                  height: upperHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: upperColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(2),
                    ),
                  ),
                ),
              // Lower section
              Container(
                  height: lowerHeight.toDouble(),
                  width: double.infinity,
                  decoration: hasGradient
                      ? BoxDecoration(
                          gradient: LinearGradient(
                              colors: [lowerColor, upperColor],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(2),
                            top: upperValue == null
                                ? Radius.circular(2)
                                : Radius.zero,
                          ),
                        )
                      : BoxDecoration(
                          color: lowerColor,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(2),
                            top: upperValue == null
                                ? Radius.circular(2)
                                : Radius.zero,
                          ),
                        ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (showStar)
                        Icon(Icons.star,
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            size: 16),
                      if (showStar)
                        SizedBox(
                          height: 4,
                        )
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  String formatValue(double value) {
    return value % 1 == 0
        ? value.toInt().toString() // If whole number -> 1
        : value
            .toStringAsFixed(2)
            .replaceAll(RegExp(r'0+$'), '')
            .replaceAll(RegExp(r'\.$'), '');
    // If decimal -> up to 2 decimals, no trailing zeros
  }
}
