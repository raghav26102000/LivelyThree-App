// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;

class CircularProgressBar extends StatefulWidget {
  const CircularProgressBar({
    super.key,
    this.width,
    this.height,
    required this.progress,
    required this.barThickness,
    required this.lowColor,
    required this.mediumLowColor,
    required this.mediumHighColor,
    required this.highColor,
    required this.centerBackgroundColor,
    required this.numberFontSize,
  });

  final double? width;
  final double? height;
  final double progress;
  final double barThickness;
  final double numberFontSize;
  final Color lowColor;
  final Color mediumLowColor;
  final Color mediumHighColor;
  final Color highColor;
  final Color centerBackgroundColor;

  @override
  State<CircularProgressBar> createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 150.0,
      height: widget.height ?? 150.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Custom Paint for the circular progress bar
          CustomPaint(
            painter: _CircularProgressPainter(
              progress: widget.progress.clamp(0.0, 100.0),
              thickness: widget.barThickness,
              lowColor: widget.lowColor,
              mediumLowColor: widget.mediumLowColor,
              mediumHighColor: widget.mediumHighColor,
              highColor: widget.highColor,
            ),
            child: Container(),
          ),
          // Center background
          Container(
            width: (widget.width ?? 150.0) - widget.barThickness * 2,
            height: (widget.height ?? 150.0) - widget.barThickness * 2,
            decoration: BoxDecoration(
              color: widget.centerBackgroundColor,
              shape: BoxShape.circle,
            ),
          ),
          // Center percentage text
          Text(
            '${widget.progress.clamp(0.0, 100.0).toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize:
                  FlutterFlowTheme.adjustScale(size: widget.numberFontSize),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double thickness;
  final Color lowColor;
  final Color mediumLowColor;
  final Color mediumHighColor;
  final Color highColor;

  _CircularProgressPainter({
    required this.progress,
    required this.thickness,
    required this.lowColor,
    required this.mediumLowColor,
    required this.mediumHighColor,
    required this.highColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double startAngle = -math.pi / 2; // Start at the top (12 o'clock)
    final double sweepAngle = 2 * math.pi * (progress / 100);

    // Determine the progress color based on value
    final Color progressColor = _determineProgressColor(progress);

    // Paint for the unfilled (grey) circle
    final Paint basePaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - thickness / 2, basePaint);

    // Paint for the filled progress arc
    final Paint progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - thickness / 2),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  // Helper function to determine progress color
  Color _determineProgressColor(double progress) {
    if (progress <= 25) {
      return lowColor;
    } else if (progress > 25 && progress <= 50) {
      return mediumLowColor;
    } else if (progress > 50 && progress <= 75) {
      return mediumHighColor;
    } else {
      return highColor;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint when progress changes
  }
}
