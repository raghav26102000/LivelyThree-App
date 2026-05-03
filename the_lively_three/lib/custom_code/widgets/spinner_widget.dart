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

/// A rotating rainbow spinner custom widget for FlutterFlow.
/// Use the provided `width` and `height` to size the spinner.
class SpinnerWidget extends StatefulWidget {
  const SpinnerWidget({
    super.key,
    this.width,
    this.height,
  });

  /// Total width of the spinner.
  final double? width;

  /// Total height of the spinner.
  final double? height;

  @override
  State<SpinnerWidget> createState() => _SpinnerWidgetState();
}

class _SpinnerWidgetState extends State<SpinnerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 2-second full rotation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine spinner dimensions from incoming parameters or default to 50px
    final double w = widget.width ?? 50.0;
    final double h = widget.height ?? w;
    // Thicker stroke: 15% of the smaller dimension
    final double strokeWidth = math.min(w, h) * 0.15;

    return SizedBox(
      width: w,
      height: h,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        ),
        child: CustomPaint(
          painter: _RainbowPainter(strokeWidth: strokeWidth),
        ),
      ),
    );
  }
}

class _RainbowPainter extends CustomPainter {
  _RainbowPainter({required this.strokeWidth});

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = SweepGradient(
      colors: const [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
        Colors.red,
      ],
      startAngle: 0.0,
      endAngle: math.pi * 2,
      tileMode: TileMode.clamp,
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
