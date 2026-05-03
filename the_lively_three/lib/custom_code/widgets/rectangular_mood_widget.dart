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

import 'dart:ui' as ui;
import 'dart:math' show pow, sqrt, pi, min;

/// A rectangular “mood” panel that allows a pointer to move within [0..width] x [0..height].
/// The pointer color fades from [pointerCenterColor] at the center to [pointerRimColor] at the edges.
/// An aura expands/shrinks around the pointer when dragging starts/ends.
class RectangularMoodWidget extends StatefulWidget {
  final double width;
  final double height;
  final bool clampToRect;
  final Color innerRectColor;
  final double transitionStartRatio;
  final double transitionEasePower;
  final Color topLeftColor, topRightColor, bottomLeftColor, bottomRightColor;
  final Color pointerRimColorTopLeft,
      pointerRimColorTopRight,
      pointerRimColorBottomLeft,
      pointerRimColorBottomRight;
  final bool showAxes;
  final Color axesColor;
  final Color pointerCenterColor;
  final double pointerSize;
  final double auraIntensity;
  final double auraScale;
  final int auraExpandDuration;
  final int auraShrinkDuration;
  final bool showShadow;
  final Color shadowColor;
  final double shadowOffsetX, shadowOffsetY, shadowBlur;
  final bool showCoordinates;
  final double minValue, maxValue;
  final Function(int x, int y, DateTime time)? onMoodChange;
  final int throttleDuration;
  final bool callOnMove;
  final double iconScaleFactor;
  final String topLeftEmojiPath,
      topRightEmojiPath,
      bottomLeftEmojiPath,
      bottomRightEmojiPath;
  final String xAxisLabel;
  final String yAxisLabel;

  const RectangularMoodWidget({
    Key? key,
    required this.width,
    required this.height,
    this.clampToRect = true,
    this.innerRectColor = const Color(0xFFEEEEEE),
    this.transitionStartRatio = 0.75,
    this.transitionEasePower = 1.0,
    this.topLeftColor = const Color(0xFFFFCDD2),
    this.topRightColor = const Color(0xFFC8E6C9),
    this.bottomLeftColor = const Color(0xFFBBDEFB),
    this.bottomRightColor = const Color(0xFFFFF9C4),
    this.pointerRimColorTopLeft = const Color(0xFFFF0000),
    this.pointerRimColorTopRight = const Color(0xFF00FF00),
    this.pointerRimColorBottomLeft = const Color(0xFF0000FF),
    this.pointerRimColorBottomRight = const Color(0xFFFFFF00),
    this.showAxes = true,
    this.axesColor = const Color(0xFF616161),
    this.pointerCenterColor = const Color(0xFFF44336),
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
    this.onMoodChange,
    this.throttleDuration = 200,
    this.callOnMove = false,
    this.iconScaleFactor = 0.1,
    required this.topLeftEmojiPath,
    required this.topRightEmojiPath,
    required this.bottomLeftEmojiPath,
    required this.bottomRightEmojiPath,
    required this.xAxisLabel,
    required this.yAxisLabel,
  }) : super(key: key);

  @override
  State<RectangularMoodWidget> createState() => _RectangularMoodWidgetState();
}

class _RectangularMoodWidgetState extends State<RectangularMoodWidget>
    with SingleTickerProviderStateMixin {
  Offset _pointerOffset = Offset.zero;
  bool _isPressed = false;
  double _xVal = 0, _yVal = 0;
  late AnimationController _auraController;
  late Animation<double> _auraAnimation;
  ui.Image? _bgImage;
  bool _bgDirty = true;
  DateTime _lastThrottleCall = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _pointerOffset = Offset(widget.width / 2, widget.height / 2);
    _updateCoordinates(_pointerOffset);
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyMoodChange());
    _auraController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.auraExpandDuration),
      reverseDuration: Duration(milliseconds: widget.auraShrinkDuration),
    );
    _auraAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeInOut),
    )..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(RectangularMoodWidget old) {
    super.didUpdateWidget(old);
    if (old.width != widget.width ||
        old.height != widget.height ||
        old.innerRectColor != widget.innerRectColor ||
        old.transitionStartRatio != widget.transitionStartRatio ||
        old.transitionEasePower != widget.transitionEasePower ||
        old.topLeftColor != widget.topLeftColor ||
        old.topRightColor != widget.topRightColor ||
        old.bottomLeftColor != widget.bottomLeftColor ||
        old.bottomRightColor != widget.bottomRightColor ||
        old.pointerRimColorTopLeft != widget.pointerRimColorTopLeft ||
        old.pointerRimColorTopRight != widget.pointerRimColorTopRight ||
        old.pointerRimColorBottomLeft != widget.pointerRimColorBottomLeft ||
        old.pointerRimColorBottomRight != widget.pointerRimColorBottomRight) {
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
    final gap = 0.04 * min(widget.width, widget.height);
    final emojiSize = widget.width * widget.iconScaleFactor;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        onPanStart: (d) {
          setState(() => _isPressed = true);
          _auraController.forward();
          _handleDrag(d.localPosition, triggerCallback: widget.callOnMove);
        },
        onPanUpdate: (d) =>
            _handleDrag(d.localPosition, triggerCallback: widget.callOnMove),
        onPanEnd: (_) {
          setState(() => _isPressed = false);
          _auraController.reverse();
          _notifyMoodChange();
        },
        onTapDown: (d) {
          setState(() => _isPressed = true);
          _auraController.forward();
          _handleDrag(d.localPosition);
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _auraController.reverse();
          _notifyMoodChange();
        },
        child: Stack(clipBehavior: Clip.none, children: [
          CustomPaint(
            size: Size(widget.width, widget.height),
            painter: _RectangularMoodPainter(
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
              pointerRimColorTopLeft: widget.pointerRimColorTopLeft,
              pointerRimColorTopRight: widget.pointerRimColorTopRight,
              pointerRimColorBottomLeft: widget.pointerRimColorBottomLeft,
              pointerRimColorBottomRight: widget.pointerRimColorBottomRight,
              pointerSize: widget.pointerSize,
              auraProgress: _auraAnimation.value,
              auraIntensity: widget.auraIntensity,
              auraScale: widget.auraScale,
              isPressed: _isPressed,
              minValue: widget.minValue,
              maxValue: widget.maxValue,
              bgImage: _bgImage,
              bgDirty: _bgDirty,
              innerRectColor: widget.innerRectColor,
              transitionStartRatio: widget.transitionStartRatio,
              transitionEasePower: widget.transitionEasePower,
              topLeftColor: widget.topLeftColor,
              topRightColor: widget.topRightColor,
              bottomLeftColor: widget.bottomLeftColor,
              bottomRightColor: widget.bottomRightColor,
              xAxisLabel: widget.xAxisLabel,
              yAxisLabel: widget.yAxisLabel,
              onBgImageGenerated: (img) {
                setState(() {
                  _bgImage = img;
                  _bgDirty = false;
                });
              },
            ),
          ),

          // Top-left emoji
          Positioned(
            top: -emojiSize / 2,
            left: -emojiSize / 2,
            child: AnimatedOpacity(
              opacity: _calculateOpacity(_pointerOffset, Offset(0, 0)),
              duration: Duration(milliseconds: 300),
              child: Image.asset(
                widget.topLeftEmojiPath,
                width: emojiSize,
                height: emojiSize,
              ),
            ),
          ),

          // Top-right emoji
          Positioned(
            top: -emojiSize / 2,
            right: -emojiSize / 2,
            child: AnimatedOpacity(
              opacity:
                  _calculateOpacity(_pointerOffset, Offset(widget.width, 0)),
              duration: Duration(milliseconds: 300),
              child: Image.asset(
                widget.topRightEmojiPath,
                width: emojiSize,
                height: emojiSize,
              ),
            ),
          ),

          // Bottom-left emoji
          Positioned(
            bottom: -emojiSize / 2,
            left: -emojiSize / 2,
            child: AnimatedOpacity(
              opacity:
                  _calculateOpacity(_pointerOffset, Offset(0, widget.height)),
              duration: Duration(milliseconds: 300),
              child: Image.asset(
                widget.bottomLeftEmojiPath,
                width: emojiSize,
                height: emojiSize,
              ),
            ),
          ),

          // Bottom-right emoji
          Positioned(
            bottom: -emojiSize / 2,
            right: -emojiSize / 2,
            child: AnimatedOpacity(
              opacity: _calculateOpacity(
                  _pointerOffset, Offset(widget.width, widget.height)),
              duration: Duration(milliseconds: 300),
              child: Image.asset(
                widget.bottomRightEmojiPath,
                width: emojiSize,
                height: emojiSize,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  double _calculateOpacity(Offset p, Offset e) {
    const minO = 0.2, maxO = 1.0;
    final diag = sqrt(pow(widget.width, 2) + pow(widget.height, 2));
    final dist = (p - e).distance;
    return (maxO - (dist / diag) * (maxO - minO)).clamp(minO, maxO);
  }

  void _handleDrag(Offset pos, {bool triggerCallback = false}) {
    final newPos = widget.clampToRect
        ? Offset(
            pos.dx.clamp(0.0, widget.width),
            pos.dy.clamp(0.0, widget.height),
          )
        : pos;
    setState(() {
      _pointerOffset = newPos;
      _updateCoordinates(newPos);
    });
    if (triggerCallback) {
      final now = DateTime.now();
      if (now.difference(_lastThrottleCall).inMilliseconds >=
          widget.throttleDuration) {
        _notifyMoodChange();
        _lastThrottleCall = now;
      }
    }
  }

  void _updateCoordinates(Offset offset) {
    final dx = offset.dx - widget.width / 2;
    final dy = widget.height / 2 - offset.dy;
    final range = widget.maxValue - widget.minValue;
    final half = range / 2;
    final nx = dx / (widget.width / 2);
    final ny = dy / (widget.height / 2);
    _xVal = nx * half + (widget.minValue + half);
    _yVal = ny * half + (widget.minValue + half);
  }

  void _notifyMoodChange() {
    if (widget.onMoodChange != null) {
      widget.onMoodChange!(_xVal.toInt(), _yVal.toInt(), DateTime.now());
    }
  }
}

/// CustomPainter draws panel, pointer, aura, and axis labels.
class _RectangularMoodPainter extends CustomPainter {
  final bool clampToRect;
  final bool showShadow;
  final Color shadowColor;
  final double shadowOffsetX, shadowOffsetY, shadowBlur;
  final bool showAxes;
  final Color axesColor;
  final Offset pointerOffset;
  final Color pointerCenterColor,
      pointerRimColorTopLeft,
      pointerRimColorTopRight,
      pointerRimColorBottomLeft,
      pointerRimColorBottomRight;
  final double pointerSize;
  final double auraProgress, auraIntensity, auraScale;
  final bool isPressed;
  final double minValue, maxValue;
  final ui.Image? bgImage;
  final bool bgDirty;
  final Color innerRectColor;
  final double transitionStartRatio, transitionEasePower;
  final Color topLeftColor, topRightColor, bottomLeftColor, bottomRightColor;
  final String xAxisLabel, yAxisLabel;
  final void Function(ui.Image) onBgImageGenerated;

  _RectangularMoodPainter({
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
    required this.pointerRimColorTopLeft,
    required this.pointerRimColorTopRight,
    required this.pointerRimColorBottomLeft,
    required this.pointerRimColorBottomRight,
    required this.pointerSize,
    required this.auraProgress,
    required this.auraIntensity,
    required this.auraScale,
    required this.isPressed,
    required this.minValue,
    required this.maxValue,
    required this.bgImage,
    required this.bgDirty,
    required this.innerRectColor,
    required this.transitionStartRatio,
    required this.transitionEasePower,
    required this.topLeftColor,
    required this.topRightColor,
    required this.bottomLeftColor,
    required this.bottomRightColor,
    required this.xAxisLabel,
    required this.yAxisLabel,
    required this.onBgImageGenerated,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Background generation/drawing
    if (bgImage == null && bgDirty) {
      _generateQuadrantBgImage(w.toInt(), h.toInt()).then(onBgImageGenerated);
    }
    if (showShadow) {
      final paint = Paint()
        ..color = shadowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);
      canvas.drawRect(Rect.fromLTWH(shadowOffsetX, shadowOffsetY, w, h), paint);
    }
    if (bgImage != null) {
      canvas.drawImage(bgImage!, Offset.zero, Paint());
    } else {
      canvas.drawRect(
          Rect.fromLTWH(0, 0, w, h), Paint()..color = innerRectColor);
    }

    // Axes
    if (showAxes) {
      final paint = Paint()
        ..color = axesColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      _drawDashedLine(canvas, paint, Offset(0, h / 2), Offset(w, h / 2),
          dashLength: 8, spaceLength: 6);
      _drawDashedLine(canvas, paint, Offset(w / 2, 0), Offset(w / 2, h),
          dashLength: 8, spaceLength: 6);
    }

    // Compute pointer color fade
    final center = Offset(w / 2, h / 2);
    final dist = (pointerOffset - center).distance;
    final maxD = sqrt(pow(w / 2, 2) + pow(h / 2, 2));
    final ratio = (dist / maxD).clamp(0.0, 1.0);
    Color pColor;
    switch (_getQuadrant(pointerOffset, center)) {
      case Quadrant.topLeft:
        pColor = Color.lerp(pointerCenterColor, pointerRimColorTopLeft, ratio)!;
        break;
      case Quadrant.topRight:
        pColor =
            Color.lerp(pointerCenterColor, pointerRimColorTopRight, ratio)!;
        break;
      case Quadrant.bottomLeft:
        pColor =
            Color.lerp(pointerCenterColor, pointerRimColorBottomLeft, ratio)!;
        break;
      case Quadrant.bottomRight:
        pColor =
            Color.lerp(pointerCenterColor, pointerRimColorBottomRight, ratio)!;
        break;
    }

    // Aura
    if (auraProgress > 0) {
      final r = pointerSize + auraScale * pointerSize * auraProgress;
      if (r > pointerSize) {
        final paint = Paint()
          ..shader = ui.Gradient.radial(
            pointerOffset,
            r,
            [pColor.withOpacity(auraIntensity), pColor.withOpacity(0)],
          );
        canvas.drawCircle(pointerOffset, r, paint);
      }
    }

    // Draw pointer
    canvas.drawCircle(pointerOffset, pointerSize, Paint()..color = pColor);
    if (isPressed) {
      canvas.drawCircle(pointerOffset.translate(2, 2), pointerSize,
          Paint()..color = Colors.black.withOpacity(0.3));
    }

    // --- TWO AXIS LABELS in the negative quadrants ---

    final textStyle = TextStyle(color: axesColor, fontSize: min(w, h) * 0.04);
    final bgPaint = Paint()..color = Colors.white.withOpacity(0.7);
    final borderPaint = Paint()
      ..color = axesColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    const padH = 8.0, padV = 4.0, radius = 6.0;

    // 1) X‑axis label centered in left quadrant
    {
      final tpX = TextPainter(
        text: TextSpan(text: xAxisLabel, style: textStyle),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      final cx = w / 4, cy = h / 2;
      final bgRect = Rect.fromCenter(
          center: Offset(cx, cy),
          width: tpX.width + padH * 2,
          height: tpX.height + padV * 2);
      final rrect = RRect.fromRectAndRadius(bgRect, Radius.circular(radius));
      canvas.drawRRect(rrect, bgPaint);
      canvas.drawRRect(rrect, borderPaint);
      tpX.paint(canvas, Offset(cx - tpX.width / 2, cy - tpX.height / 2));
    }

    // 2) Y‑axis label centered in bottom quadrant
    {
      final tpY = TextPainter(
        text: TextSpan(text: yAxisLabel, style: textStyle),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      final cx = w / 2, cy = 3 * h / 4;
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(-pi / 2);
      final bgRect = Rect.fromCenter(
          center: Offset(0, 0),
          width: tpY.width + padH * 2,
          height: tpY.height + padV * 2);
      final rrect = RRect.fromRectAndRadius(bgRect, Radius.circular(radius));
      canvas.drawRRect(rrect, bgPaint);
      canvas.drawRRect(rrect, borderPaint);
      tpY.paint(canvas, Offset(-tpY.width / 2, -tpY.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _RectangularMoodPainter old) {
    return old.pointerOffset != pointerOffset ||
        old.auraProgress != auraProgress ||
        old.bgDirty != bgDirty ||
        old.innerRectColor != innerRectColor;
  }

  Quadrant _getQuadrant(Offset p, Offset c) {
    if (p.dx < c.dx && p.dy < c.dy) return Quadrant.topLeft;
    if (p.dx >= c.dx && p.dy < c.dy) return Quadrant.topRight;
    if (p.dx < c.dx && p.dy >= c.dy) return Quadrant.bottomLeft;
    return Quadrant.bottomRight;
  }

  Future<ui.Image> _generateQuadrantBgImage(int w, int h) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    final cx = w / 2, cy = h / 2;
    final start = transitionStartRatio.clamp(0.0, 1.0);
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        final dx = ((x + 0.5) - cx).abs() / cx;
        final dy = ((y + 0.5) - cy).abs() / cy;
        final r = max(dx, dy);
        final quad =
            _getQuadrant(Offset(x.toDouble(), y.toDouble()), Offset(cx, cy));
        final qColor = {
          Quadrant.topLeft: topLeftColor,
          Quadrant.topRight: topRightColor,
          Quadrant.bottomLeft: bottomLeftColor,
          Quadrant.bottomRight: bottomRightColor,
        }[quad]!;
        final color = (r < start)
            ? innerRectColor
            : Color.lerp(
                innerRectColor,
                qColor,
                pow((r - start) / (1 - start), transitionEasePower)
                    .toDouble())!;
        paint.color = color;
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }
    final picture = recorder.endRecording();
    final image = await picture.toImage(w, h);
    picture.dispose();
    return image;
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset s, Offset e,
      {required double dashLength, required double spaceLength}) {
    final dist = (e - s).distance;
    final dir = (e - s) / dist;
    double drawn = 0;
    while (drawn < dist) {
      final len = min(dashLength, dist - drawn);
      final p1 = s + dir * drawn;
      final p2 = s + dir * (drawn + len);
      canvas.drawLine(p1, p2, paint);
      drawn += len + spaceLength;
    }
  }
}

enum Quadrant { topLeft, topRight, bottomLeft, bottomRight }
