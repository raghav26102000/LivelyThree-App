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

class TendencyIndicator extends StatefulWidget {
  const TendencyIndicator({
    super.key,
    this.width,
    this.height,
    required this.progress,
  });

  final double? width;
  final double? height;
  final double progress;

  @override
  State<TendencyIndicator> createState() => _TendencyIndicatorState();
}

class _TendencyIndicatorState extends State<TendencyIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.width ?? 50.0,
        height: widget.height ?? 50.0,
        child: _ArrowIcon(
          progress: widget.progress,
          width: widget.width ?? 50.0,
          height: widget.height ?? 50.0,
        ),
      ),
    );
  }
}

class _ArrowIcon extends StatelessWidget {
  final double progress;
  final double width;
  final double height;

  const _ArrowIcon({
    Key? key,
    required this.progress,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the icon, color, and rotation based on progress
    IconData iconData =
        Icons.horizontal_rule; // Neutral (horizontal double-sided arrow)
    double rotation = 0; // Rotation angle in radians
    Color color = Colors.grey.shade600;

    if (progress < -50) {
      // Downward arrow (bright red)
      iconData = Icons.arrow_downward;
      color = Colors.red.shade700;
    } else if (progress >= -50 && progress <= -11) {
      // 45° downward arrow (dark yellow)
      iconData = Icons.arrow_downward;
      rotation = -math.pi / 4; // 45 degrees counterclockwise
      color = Colors.yellow.shade800;
    } else if (progress >= -10 && progress <= 10) {
      // Neutral horizontal arrow (grey)
      iconData = Icons.compare_arrows;
      rotation = 0;
      color = Colors.grey.shade600;
    } else if (progress > 10 && progress <= 50) {
      // 45° upward arrow (dark yellow)
      iconData = Icons.arrow_upward;
      rotation = math.pi / 4; // 45 degrees clockwise
      color = Colors.yellow.shade800;
    } else if (progress > 50) {
      // Upward arrow (bright green)
      iconData = Icons.arrow_upward;
      color = Colors.green.shade700;
    }

    return Transform.rotate(
      angle: rotation, // Rotate based on direction
      child: Icon(
        iconData,
        size: math.min(width, height * 0.8), // Size proportional to widget
        color: color,
      ),
    );
  }
}
