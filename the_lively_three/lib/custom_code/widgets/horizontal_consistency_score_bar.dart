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

class HorizontalConsistencyScoreBar extends StatefulWidget {
  const HorizontalConsistencyScoreBar({
    super.key,
    this.width,
    this.height,
    required this.score, // [0..100] now, not [0..1]
    this.barHeight = 20.0,
    this.backgroundColor = Colors.grey,
    this.useMonochrome = false,
  });

  final double? width;
  final double? height;

  /// Changed comment: now [0..100], already a percentage
  final double score;

  final double barHeight;
  final Color backgroundColor;
  final bool useMonochrome;

  @override
  State<HorizontalConsistencyScoreBar> createState() =>
      _HorizontalConsistencyScoreBarState();
}

class _HorizontalConsistencyScoreBarState
    extends State<HorizontalConsistencyScoreBar>
    with SingleTickerProviderStateMixin {
  late double animatedScore;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // OLD: widget.score.clamp(0.0, 1.0)
    // NEW: clamp to [0..100], because it's already a percentage
    animatedScore = widget.score.clamp(0.0, 100.0);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: animatedScore).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant HorizontalConsistencyScoreBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.score != oldWidget.score) {
      // OLD: clamp(0.0, 1.0)
      // NEW: clamp(0.0, 100.0)
      animatedScore = widget.score.clamp(0.0, 100.0);

      _controller.reset();
      _animation = Tween<double>(
        begin: _animation.value,
        end: animatedScore,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double barWidth = (widget.width ?? 300.0).clamp(0.0, double.infinity);

    // OLD: progressWidth = barWidth * _animation.value (0..1)
    // NEW: interpret _animation.value as 0..100 => divide by 100
    final double progressWidth = barWidth * (_animation.value / 100.0);

    return Center(
      child: SizedBox(
        width: barWidth,
        height: widget.height ?? widget.barHeight * 2.5,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background bar with gradient overlay
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: barWidth,
                height: widget.barHeight,
                decoration: BoxDecoration(
                  gradient: widget.useMonochrome
                      ? const LinearGradient(
                          colors: [Color(0xFF8A8A8A), Color(0xFFD8D8D8)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : const LinearGradient(
                          colors: [Colors.red, Colors.yellow, Colors.green],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                  borderRadius: BorderRadius.circular(widget.barHeight / 2),
                ),
                foregroundDecoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(widget.barHeight / 2),
                ),
              ),
            ),
            // Filled progress bar
            Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.barHeight / 2),
                child: CustomPaint(
                  size: Size(progressWidth, widget.barHeight),
                  painter: _ProgressPainter(
                    // We now pass 0..100 to the painter
                    progress: _animation.value,
                    useMonochrome: widget.useMonochrome,
                  ),
                ),
              ),
            ),
            // Percentage text
            Center(
              child: Text(
                // OLD: '...(_animation.value * 100).toStringAsFixed(0)...'
                // If you used that. But from your snippet, you had:
                // '${(_animation.value).toStringAsFixed(0)}%'
                // That still works for 0..100.
                '${_animation.value.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: widget.barHeight * 0.6,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================
// Progress Painter
// =====================
class _ProgressPainter extends CustomPainter {
  final double progress; // Now 0..100
  final bool useMonochrome;

  _ProgressPainter({required this.progress, required this.useMonochrome});

  @override
  void paint(Canvas canvas, Size size) {
    // We'll convert 0..100 => fraction 0..1 for our color lerp
    final fraction = progress / 100.0;

    Color startColor = Colors.red;
    Color endColor = Colors.red;

    if (!useMonochrome) {
      // OLD: if (progress <= 0.5)
      // NEW: if (fraction <= 0.5)
      if (fraction <= 0.5) {
        // Lerp from red -> yellow
        endColor = Color.lerp(Colors.red, Colors.yellow, fraction / 0.5)!;
      } else {
        // Lerp from yellow -> green
        startColor = Colors.yellow;
        endColor = Color.lerp(
          Colors.yellow,
          Colors.green,
          (fraction - 0.5) / 0.5,
        )!;
      }
    } else {
      // Monochrome
      startColor = const Color(0xFF8A8A8A);
      endColor = const Color(0xFFD8D8D8);
    }

    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [startColor, endColor],
        stops: [0.0, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    paint.style = PaintingStyle.fill;

    // Draw the progress bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(size.height / 2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
