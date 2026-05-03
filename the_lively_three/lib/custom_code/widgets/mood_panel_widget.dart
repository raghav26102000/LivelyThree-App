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

/// A rectangular “mood” panel that allows a pointer to move within [0..width] x [0..height].
/// The pointer color fades from [pointerCenterColor] at the center to [pointerRimColor] at the edges.
/// An aura expands/shrinks around the pointer when dragging starts/ends.

import 'dart:ui' as ui;
import 'dart:math' show pow;

class MoodPanelWidget extends StatefulWidget {
  final double width;
  final double height;

  /// If true, clamp pointer within [0..width] x [0..height].
  final bool clampToRect;

  /// The color at the rectangle’s center (ratio=0).
  final Color innerRectColor;

  /// The color at the rectangle’s edges/corners (ratio=1).
  final Color outerRectColor;

  /// Where the color transition starts (0..1).
  /// e.g., 0.75 => color stays at innerRectColor up to 75% of the distance,
  /// then transitions to outerRectColor from 0.75..1.
  final double transitionStartRatio;

  /// A power/exponent that makes the transition more or less abrupt.
  /// e.g., 1.0 => linear, 2.0 => more gradual slope for transition, etc.
  /// Typically >= 1.0 for a gentler slope, or <1 for a steeper slope.
  final double transitionEasePower;

  final bool showAxes;
  final Color axesColor;

  final Color pointerCenterColor;
  final Color pointerRimColor;
  final double pointerSize;

  final double auraIntensity;
  final double auraScale;
  final int auraExpandDuration;
  final int auraShrinkDuration;

  final bool showShadow;
  final Color shadowColor;
  final double shadowOffsetX;
  final double shadowOffsetY;
  final double shadowBlur;

  final bool showCoordinates;

  final double minValue;
  final double maxValue;

  const MoodPanelWidget({
    Key? key,
    required this.width,
    required this.height,
    this.clampToRect = true,
    this.innerRectColor = const Color(0xFFEEEEEE),
    this.outerRectColor = const Color(0xFFBDBDBD),
    this.transitionStartRatio = 0.75,
    this.transitionEasePower = 1.0,
    this.showAxes = true,
    this.axesColor = const Color(0xFF616161),
    this.pointerCenterColor = const Color(0xFFF44336),
    this.pointerRimColor = const Color(0xFFFF0000),
    this.pointerSize = 10.0,
    this.auraIntensity = 0.7,
    this.auraScale = 4.0,
    this.auraExpandDuration = 1000,
    this.auraShrinkDuration = 1000,
    this.showShadow = true,
    this.shadowColor = const Color(0x33000000),
    this.shadowOffsetX = 4.0,
    this.shadowOffsetY = 4.0,
    this.shadowBlur = 10.0,
    this.showCoordinates = false,
    this.minValue = -10,
    this.maxValue = 10,
  }) : super(key: key);

  @override
  State<MoodPanelWidget> createState() => _MoodPanelWidgetState();
}

class _MoodPanelWidgetState extends State<MoodPanelWidget>
    with SingleTickerProviderStateMixin {
  Offset _pointerOffset = Offset.zero;
  bool _isPressed = false; // Renamed for clarity

  double _xVal = 0;
  double _yVal = 0;

  late AnimationController _auraController;
  late Animation<double> _auraAnimation;

  ui.Image? _bgImage;
  bool _bgDirty = true;

  @override
  void initState() {
    super.initState();
    _pointerOffset = Offset(widget.width / 2, widget.height / 2);
    _updateCoordinates(_pointerOffset);

    _auraController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.auraExpandDuration),
      reverseDuration: Duration(milliseconds: widget.auraShrinkDuration),
    );

    _auraAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _auraController,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      ),
    );

    _auraAnimation.addListener(() {
      // Optionally, uncomment the line below to see aura progress in the console
      // debugPrint('Aura Progress: ${_auraAnimation.value}');
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(MoodPanelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.width != widget.width ||
        oldWidget.height != widget.height ||
        oldWidget.innerRectColor != widget.innerRectColor ||
        oldWidget.outerRectColor != widget.outerRectColor ||
        oldWidget.transitionStartRatio != widget.transitionStartRatio ||
        oldWidget.transitionEasePower != widget.transitionEasePower) {
      _bgDirty = true;
      _bgImage?.dispose();
      _bgImage = null;
    }
  }

  @override
  void dispose() {
    _auraController.dispose();
    _bgImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() => _isPressed = true);
          _auraController.forward();
          _handleDrag(details.localPosition);
        },
        onPanUpdate: (details) => _handleDrag(details.localPosition),
        onPanEnd: (details) {
          setState(() => _isPressed = false);
          _auraController.reverse();
        },
        onTapDown: (details) {
          setState(() => _isPressed = true);
          _auraController.forward();
          _handleDrag(details.localPosition);
        },
        onTapUp: (details) {
          setState(() => _isPressed = false);
          _auraController.reverse();
        },
        child: Stack(
          children: [
            CustomPaint(
              size: Size(widget.width, widget.height),
              painter: _RectChebyshevPainter(
                width: widget.width,
                height: widget.height,
                clampToRect: widget.clampToRect,
                showShadow: widget.showShadow,
                shadowColor: widget.shadowColor,
                shadowOffsetX: widget.shadowOffsetX,
                shadowOffsetY: widget.shadowOffsetY,
                shadowBlur: widget.shadowBlur,
                showAxes: widget.showAxes,
                axesColor: widget.axesColor,
                pointerOffset: _pointerOffset,
                pointerCenterColor: widget.pointerCenterColor,
                pointerRimColor: widget.pointerRimColor,
                pointerSize: widget.pointerSize,
                auraProgress: _auraAnimation.value,
                auraIntensity: widget.auraIntensity,
                auraScale: widget.auraScale,
                isDragging: _isPressed,
                minValue: widget.minValue,
                maxValue: widget.maxValue,
                bgImage: _bgImage,
                bgDirty: _bgDirty,
                innerRectColor: widget.innerRectColor,
                outerRectColor: widget.outerRectColor,
                transitionStartRatio: widget.transitionStartRatio,
                transitionEasePower: widget.transitionEasePower,
                onBgImageGenerated: (img) {
                  setState(() {
                    _bgImage = img;
                    _bgDirty = false;
                  });
                },
              ),
            ),
            if (widget.showCoordinates)
              Center(
                child: Text(
                  'x=${_xVal.toStringAsFixed(1)} | y=${_yVal.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Ensure visibility
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleDrag(Offset localPos) {
    final newPos = widget.clampToRect ? _clampToRect(localPos) : localPos;
    setState(() {
      _pointerOffset = newPos;
      _updateCoordinates(newPos);
    });
  }

  Offset _clampToRect(Offset pos) {
    final double clampedX = pos.dx.clamp(0.0, widget.width).toDouble();
    final double clampedY = pos.dy.clamp(0.0, widget.height).toDouble();
    return Offset(clampedX, clampedY);
  }

  void _updateCoordinates(Offset offset) {
    final dx = offset.dx - (widget.width / 2);
    final dy = (widget.height / 2) - offset.dy;
    final range = widget.maxValue - widget.minValue;
    final halfRange = range / 2;

    final nx = dx / (widget.width / 2);
    final ny = dy / (widget.height / 2);

    _xVal = nx * halfRange + (widget.minValue + halfRange);
    _yVal = ny * halfRange + (widget.minValue + halfRange);
  }
}

class _RectChebyshevPainter extends CustomPainter {
  final double width;
  final double height;
  final bool clampToRect;

  final bool showShadow;
  final Color shadowColor;
  final double shadowOffsetX;
  final double shadowOffsetY;
  final double shadowBlur;

  final bool showAxes;
  final Color axesColor;

  final Offset pointerOffset;
  final Color pointerCenterColor;
  final Color pointerRimColor;
  final double pointerSize;

  final double auraProgress;
  final double auraIntensity;
  final double auraScale;
  final bool isDragging;

  final double minValue;
  final double maxValue;

  final ui.Image? bgImage;
  final bool bgDirty;

  final Color innerRectColor;
  final Color outerRectColor;

  /// The ratio (0..1) where the background starts transitioning from innerRectColor->outerRectColor
  final double transitionStartRatio;

  /// The exponent/power to apply to the transition (makes it smoother or steeper).
  final double transitionEasePower;

  /// Callback to provide the generated background image
  final void Function(ui.Image) onBgImageGenerated;

  _RectChebyshevPainter({
    required this.width,
    required this.height,
    required this.clampToRect,
    required this.showShadow,
    required this.shadowColor,
    required this.shadowOffsetX,
    required this.shadowOffsetY,
    required this.shadowBlur,
    required this.showAxes,
    required this.axesColor,
    required this.pointerOffset,
    required this.pointerCenterColor,
    required this.pointerRimColor,
    required this.pointerSize,
    required this.auraProgress,
    required this.auraIntensity,
    required this.auraScale,
    required this.isDragging,
    required this.minValue,
    required this.maxValue,
    required this.bgImage,
    required this.bgDirty,
    required this.innerRectColor,
    required this.outerRectColor,
    required this.transitionStartRatio,
    required this.transitionEasePower,
    required this.onBgImageGenerated,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Possibly regenerate the background if needed
    if (bgImage == null && bgDirty) {
      _generateChebyshevBgImage().then((img) {
        onBgImageGenerated(img);
      });
    }

    // 1. Shadow
    if (showShadow) {
      final shadowPaint = Paint()
        ..color = shadowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);
      final rectShadow = Rect.fromLTWH(
        shadowOffsetX,
        shadowOffsetY,
        width,
        height,
      );
      canvas.drawRect(rectShadow, shadowPaint);
    }

    // 2. Background
    if (bgImage != null) {
      canvas.drawImage(bgImage!, Offset.zero, Paint());
    } else {
      // Fallback color if BG not generated yet
      final fallbackPaint = Paint()..color = innerRectColor;
      canvas.drawRect(Rect.fromLTWH(0, 0, width, height), fallbackPaint);
    }

    // 3. Dashed Axes
    if (showAxes) {
      final axisPaint = Paint()
        ..color = axesColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      _drawDashedLine(
        canvas,
        axisPaint,
        Offset(0, height / 2),
        Offset(width, height / 2),
        dashLength: 8,
        spaceLength: 6,
      );
      _drawDashedLine(
        canvas,
        axisPaint,
        Offset(width / 2, 0),
        Offset(width / 2, height),
        dashLength: 8,
        spaceLength: 6,
      );
    }

    // 4. Chebyshev Ratio for Pointer Color
    final center = Offset(width / 2, height / 2);
    final dx = (pointerOffset.dx - center.dx).abs() / (width / 2);
    final dy = (pointerOffset.dy - center.dy).abs() / (height / 2);
    final ratio = dx > dy ? dx : dy;
    final pointerColor = Color.lerp(pointerCenterColor, pointerRimColor, ratio);

    // 5. Aura (Drawn Based on auraProgress)
    if (auraProgress > 0.0) {
      final auraRadius = pointerSize + (auraScale * pointerSize * auraProgress);
      if (auraRadius > pointerSize) {
        final auraBaseColor =
            Color.lerp(pointerCenterColor, pointerRimColor, ratio)
                ?.withOpacity(auraIntensity);

        final auraPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              auraBaseColor ?? pointerCenterColor.withOpacity(auraIntensity),
              (auraBaseColor ?? pointerRimColor).withOpacity(0.0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: pointerOffset,
              radius: auraRadius,
            ),
          );
        canvas.drawCircle(pointerOffset, auraRadius, auraPaint);
      }
    }

    // 6. Pointer
    final pointerPaint = Paint()..color = pointerColor ?? pointerCenterColor;
    canvas.drawCircle(pointerOffset, pointerSize, pointerPaint);

    // 7. Pointer Shadow
    if (isDragging) {
      final pointerShadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(
          pointerOffset.translate(2, 2), pointerSize, pointerShadowPaint);
    }
  }

  /// Generates a Chebyshev gradient background:
  /// - ratio = max(|dx|/cx, |dy|/cy)
  /// - If ratio < transitionStartRatio => color = innerRectColor
  /// - If ratio >= transitionStartRatio => we fade from ratio2=0..1 =>
  ///   color = lerp(innerRectColor, outerRectColor, (ratio - start)/(1 - start))^transitionEasePower
  Future<ui.Image> _generateChebyshevBgImage() async {
    final recorder = ui.PictureRecorder();
    final tempCanvas = Canvas(recorder);
    final paint = Paint();

    final cx = width / 2;
    final cy = height / 2;
    final start = transitionStartRatio.clamp(0.0, 1.0);

    for (int y = 0; y < height.toInt(); y++) {
      for (int x = 0; x < width.toInt(); x++) {
        final dx = ((x + 0.5) - cx).abs() / cx;
        final dy = ((y + 0.5) - cy).abs() / cy;
        final ratio = (dx > dy) ? dx : dy;

        Color color;
        if (ratio < start) {
          // Entirely innerRectColor
          color = innerRectColor;
        } else {
          // Fade portion from ratio in [start..1] => ratio2 in [0..1]
          double ratio2 = (ratio - start) / (1.0 - start);
          // Apply exponent for gradual or abrupt transition
          ratio2 = pow(ratio2, transitionEasePower).toDouble();
          color = Color.lerp(innerRectColor, outerRectColor, ratio2)!;
        }

        paint.color = color;
        tempCanvas.drawRect(
            Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    picture.dispose();
    return image;
  }

  @override
  bool shouldRepaint(_RectChebyshevPainter oldDelegate) {
    return oldDelegate.width != width ||
        oldDelegate.height != height ||
        oldDelegate.clampToRect != clampToRect ||
        oldDelegate.showShadow != showShadow ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.shadowOffsetX != shadowOffsetX ||
        oldDelegate.shadowOffsetY != shadowOffsetY ||
        oldDelegate.shadowBlur != shadowBlur ||
        oldDelegate.showAxes != showAxes ||
        oldDelegate.axesColor != axesColor ||
        oldDelegate.pointerOffset != pointerOffset ||
        oldDelegate.pointerCenterColor != pointerCenterColor ||
        oldDelegate.pointerRimColor != pointerRimColor ||
        oldDelegate.pointerSize != pointerSize ||
        oldDelegate.auraProgress != auraProgress ||
        oldDelegate.auraIntensity != auraIntensity ||
        oldDelegate.auraScale != auraScale ||
        oldDelegate.isDragging != isDragging ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.bgImage != bgImage ||
        oldDelegate.bgDirty != bgDirty ||
        oldDelegate.innerRectColor != innerRectColor ||
        oldDelegate.outerRectColor != outerRectColor ||
        oldDelegate.transitionStartRatio != transitionStartRatio ||
        oldDelegate.transitionEasePower != transitionEasePower;
  }

  void _drawDashedLine(
    Canvas canvas,
    Paint paint,
    Offset start,
    Offset end, {
    required double dashLength,
    required double spaceLength,
  }) {
    final dist = (end - start).distance;
    final dir = (end - start) / dist;
    double distanceSoFar = 0.0;
    while (distanceSoFar < dist) {
      final currentDashLen = (distanceSoFar + dashLength < dist)
          ? dashLength
          : (dist - distanceSoFar);
      final p1 = start + dir * distanceSoFar;
      final p2 = start + dir * (distanceSoFar + currentDashLen);
      canvas.drawLine(p1, p2, paint);
      distanceSoFar += currentDashLen + spaceLength;
    }
  }
}
