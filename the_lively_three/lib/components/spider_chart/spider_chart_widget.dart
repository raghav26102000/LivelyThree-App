/// A charting library for displaying spider/radar charts with two datasets
library spider_chart;

import 'dart:math' show pi, cos, sin, max;
import 'package:flutter/material.dart';
import 'dart:ui';

import 'dart:math';

import 'package:the_lively_three/components/personalized_plant_list/personalized_plant_list_widget.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';

class SpiderChart extends StatefulWidget {
  final List<double> data1;
  final List<double>? data2;
  final List<String> labels;

  final List<Color> color1;
  final List<Color> color2;
  final List<Color> backgroundColors;

  final double? maxValue;
  final int decimalPrecision;

  final Size size;
  final double fallbackHeight;
  final double fallbackWidth;
  final List<Color> labelBackgroundColor;
  final List<Color> labelBg;
  final Color labelTextColor;
  final double labelFontSize;

  /// The number of background layers (rings)
  final int layerCount;
  final int? tooltipMode;
  final ValueChanged<int>? onLabelTap;

  const SpiderChart({
    super.key,
    required this.data1,
    this.data2,
    required this.labels,
    this.color1 = const [
      Color(0xFFC40CD3),
      Color(0xFF2883DE),
    ],
    this.color2 = const [
      Color(0xFF00ECFF),
      Color(0xFF3968E6),
    ],
    this.maxValue = 200,
    this.decimalPrecision = 0,
    this.size = Size.infinite,
    this.fallbackHeight = double.infinity,
    this.fallbackWidth = double.infinity,
    this.labelBackgroundColor = const [
      Color(0xFFC40CD3),
      Color(0xFF2883DE),
    ],
    this.backgroundColors = const [
      Color(0xFFE3F2FD),
      Color(0xFFBBDEFB),
      Color(0xFF90CAF9),
      Color(0xFF64B5F6),
      Color(0xFF42A5F5),
    ],
    this.layerCount = 9,
    this.labelTextColor = const Color(0xff818181),
    this.labelFontSize = 12.0,
    this.tooltipMode,
    this.onLabelTap,
    this.labelBg = const [Colors.transparent, Colors.transparent],
  });
  // : assert(data1.length == labels.length,
  //           'Length of data1 and labels must match');

  @override
  State<SpiderChart> createState() => _SpiderChartState();
}

class _SpiderChartState extends State<SpiderChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _hoveredLabelIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleLabelHover(int? index) {
    if (_hoveredLabelIndex != index) {
      setState(() {
        _hoveredLabelIndex = index;
      });

      if (index != null) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _handleLabelTap(BuildContext context, int index) async {
    widget.onLabelTap?.call(index);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PersonalizedPlantListWidget()), // Replace with your page
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final calculatedMax = widget.maxValue ??
        (<double>[...widget.data1, ...(widget.data2 ?? [])]).reduce(max);

    // Use LayoutBuilder to know actual size to compute label positions
    return SizedBox(
      width: widget.fallbackWidth,
      height: widget.fallbackHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final center = size.center(Offset.zero);
        final angle = (2 * pi) / widget.data1.length;
        final radius = size.height / 2; // painter uses center.dy as radius

        // compute label anchor points (same as painter would)
        final labelAnchorPoints = List.generate(widget.data1.length, (i) {
          final x = radius * cos(angle * i - pi / 2);
          final y = radius * sin(angle * i - pi / 2);
          return Offset(x, y) + center;
        });

        return MouseRegion(
          onExit: (_) => _handleLabelHover(null),
          child: Stack(
            clipBehavior: Clip.none, // allow labels/tooltips to overflow
            children: [
              // Bottom: CustomPaint drawing chart visuals (without labels)
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CustomPaint(
                    size: widget.size == Size.infinite ? size : widget.size,
                    painter: SpiderChartPainter(
                      data1: widget.data1,
                      data2: widget.data2,
                      labels: widget.labels,
                      color1: widget.color1,
                      color2: widget.color2,
                      maxValue: calculatedMax,
                      decimalPrecision: widget.decimalPrecision,
                      labelBackgroundColor: widget.labelBackgroundColor,
                      backgroundColors: widget.backgroundColors,
                      layerCount: widget.layerCount,
                      labelTextColor: widget.labelTextColor,
                      labelFontSize: widget.labelFontSize,
                      tooltipMode: widget.tooltipMode,
                      labelBg: widget.labelBg,
                      // painter doesn't handle label interactions now
                    ),
                  ),
                ),
              ),

              // Overlay labels + tooltips as widgets
              ...List.generate(widget.labels.length, (i) {
                final anchor = labelAnchorPoints[i];

                // Build TextPainter to measure text to get exact offsets & size
                final textPainter = TextPainter(
                  text: TextSpan(
                    text: widget.labels[i],
                    style: TextStyle(
                      color: widget.labelTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FlutterFlowTheme.adjustScale(
                          size: widget.labelFontSize),
                    ),
                  ),
                  textDirection: TextDirection.ltr,
                );
                textPainter.layout();

                // compute same offsets as painter's _computeLabelOffset
                final labelOffset =
                    _computeLabelOffsetForWidget(center, anchor, textPainter);

                const paddingX = 6.0;
                const paddingY = 4.0;
                final labelRect = Rect.fromLTWH(
                  labelOffset.dx - 6,
                  labelOffset.dy - 4,
                  textPainter.width + 12,
                  textPainter.height + 8,
                );

                return Positioned(
                  left: labelRect.left,
                  top: labelRect.top,
                  width: labelRect.width,
                  height: labelRect.height,
                  child: MouseRegion(
                    onEnter: (_) => _handleLabelHover(i),
                    onHover: (_) => _handleLabelHover(i),
                    onExit: (_) => _handleLabelHover(null),
                    child: GestureDetector(
                      behavior: HitTestBehavior.deferToChild,
                      onTap: () => _handleLabelTap(context, i),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // label background (gradient)
                          Container(
                            width: textPainter.width + 12,
                            height: textPainter.height + 8,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: const [Colors.transparent],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              widget.labels[i],
                              style: const TextStyle(
                                color: Colors.transparent,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  // Helper: compute same offset used in painter
  Offset _computeLabelOffsetForWidget(
      Offset center, Offset point, TextPainter textPainter) {
    if (point.dx < center.dx && point.dy > center.dy) {
      return point.translate(-(textPainter.width - 12), 8); // bottom left
    } else if (point.dx > center.dx && point.dy > center.dy) {
      return point.translate(-12, 8); //bottom right
    } else if (point.dx < center.dx && point.dy < center.dy) {
      return point.translate(-(textPainter.width - 4), 8); //middle left
    } else if (point.dx > center.dx && point.dy < center.dy) {
      return point.translate(-4, 8); //middle right
    } else {
      return point.translate(-(textPainter.width / 2), 0);
    }
  }

  Offset _calculateLabelPoint(
      Offset center, double radius, double angle, int index) {
    final x = radius * cos(angle * index - pi / 2);
    final y = radius * sin(angle * index - pi / 2);
    return Offset(x, y) + center;
  }

// Add this method to match the one used in SpiderChartPainter
  Offset _computeLabelOffset(
      Offset center, Offset point, TextPainter textPainter) {
    if (point.dx < center.dx && point.dy > center.dy) {
      return point.translate(-(textPainter.width - 8.0), 6);
    } else if (point.dx > center.dx && point.dy > center.dy) {
      return point.translate(-8.0, 6);
    } else if (point.dx < center.dx && point.dy < center.dy) {
      return point.translate(-(textPainter.width + 4), -4);
    } else if (point.dx > center.dx && point.dy < center.dy) {
      return point.translate(4, -4);
    } else {
      return point.translate(-(textPainter.width / 2), -15);
    }
  }
}

class SpiderChartPainter extends CustomPainter {
  final List<double> data1;
  final List<double>? data2;
  final List<String> labels;
  final List<Color> color1;
  final List<Color> color2;
  final double maxValue;
  final double labelFontSize;
  final int decimalPrecision;
  final List<Color> labelBackgroundColor;
  final Color labelTextColor;
  final List<Color> backgroundColors;
  final List<Color> labelBg;
  final int layerCount;
  final int? tooltipMode;
  final int? hoveredLabelIndex;
  final double animationValue;

  List<Offset> _calculatePentagonPoints(Offset center, double radius) {
    const sides = 5;
    final angle = (2 * pi) / sides;
    final points = <Offset>[];

    for (int i = 0; i < sides; i++) {
      final x = radius * cos(angle * i - pi / 2);
      final y = radius * sin(angle * i - pi / 2);
      points.add(Offset(x, y) + center);
    }
    return points;
  }

  SpiderChartPainter({
    required this.data1,
    this.data2,
    required this.labels,
    required this.color1,
    required this.color2,
    required this.maxValue,
    required this.decimalPrecision,
    required this.labelBackgroundColor,
    required this.labelTextColor,
    required this.labelFontSize,
    required this.backgroundColors,
    required this.layerCount,
    this.tooltipMode,
    this.hoveredLabelIndex,
    this.animationValue = 0.0,
    required this.labelBg,
  });

  final Paint spokes = Paint()..color = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    if (data1.isEmpty || labels.isEmpty) {
      return;
    }

    final center = size.center(Offset.zero);
    final angle = (2 * pi) / data1.length;
    final tooltipData = tooltipMode == 2 ? data1 : data2;
    final tooltipgradient = tooltipMode == 2 ? color1 : color2;

    // Draw multi-layer background
    _paintBackground(canvas, center, size, angle);

    // Draw spokes and outer polygon
    final outerPoints = List.generate(data1.length, (i) {
      final x = center.dy * cos(angle * i - pi / 2);
      final y = center.dy * sin(angle * i - pi / 2);
      return Offset(x, y) + center;
    });

    // Draw datasets
    _paintPentagonBadge(canvas, center);
    _paintGraphOutline(canvas, center, outerPoints);
    _paintMiddleCircle(canvas, center);
    _paintDataSet(canvas, center, data1, color1, angle, tooltipMode == 2);

    if (data2 != null) {
      _paintDataSet(canvas, center, data2!, color2, angle, tooltipMode == 1);
    }
    _paintLabels(canvas, center, outerPoints, labels, tooltipgradient, labelBg,
        tooltipData);
  }

  /// Draws layered polygon background
  void _paintBackground(Canvas canvas, Offset center, Size size, double angle) {
    final radiusStep = center.dy / layerCount;

    for (int i = layerCount; i > 0; i--) {
      final radius = radiusStep * i;
      final colorIndex = (layerCount - i) % backgroundColors.length;
      final paint = Paint()
        ..color = backgroundColors[colorIndex]
        ..style = PaintingStyle.fill;

      final points = List.generate(data1.length, (j) {
        final x = radius * cos(angle * j - pi / 2);
        final y = radius * sin(angle * j - pi / 2);
        return Offset(x, y) + center;
      });

      final path = _createRoundedPolygon(points, 12);
      canvas.drawPath(path, paint);
    }
  }

  bool _shouldShowTooltip(int index) {
    return hoveredLabelIndex == index || tooltipMode == 1 || tooltipMode == 2;
  }

  void _paintDataSet(Canvas canvas, Offset center, List<double> data,
      List<Color> color, double angle, bool darkColor) {
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final scaledRadius = (data[i] / maxValue) * center.dy;
      final x = scaledRadius * cos(angle * i - pi / 2);
      final y = scaledRadius * sin(angle * i - pi / 2);
      points.add(Offset(x, y) + center);
    }

    final path = Path()..addPolygon(points, true);

    // 🌈 Gradient fill background (radial)
    final rect = Rect.fromCircle(center: center, radius: center.dy);
    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: darkColor
            ? [
                color[0].withOpacity(0.75),
                color[0].withOpacity(0.75),
              ]
            : [
                color[0].withOpacity(0.35),
                color[0].withOpacity(0.35),
              ],
        radius: 1.0,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // ✨ Gradient border
    final strokePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color[0],
          color[1],
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, strokePaint);

    // 💧 Gradient dots
    for (var p in points) {
      final dotRect = Rect.fromCircle(center: p, radius: 7);
      final dotPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            color[0],
            color[1],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(dotRect);
      canvas.drawCircle(p, 3.0, dotPaint);
    }
  }

  void _paintGraphOutline(Canvas canvas, Offset center, List<Offset> points) {
    for (var p in points) {
      canvas.drawLine(center, p, spokes);
    }
    canvas.drawPoints(PointMode.polygon, [...points, points[0]], spokes);
    canvas.drawCircle(center, 3, spokes);
  }

  void _paintLabels(
      Canvas canvas,
      Offset center,
      List<Offset> points,
      List<String> labels,
      List<Color> gradientColors,
      List<Color> labelBg,
      List<double>? tooltipData) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final textStyle = TextStyle(
      color: labelTextColor,
      fontWeight: FontWeight.bold,
      fontSize: FlutterFlowTheme.adjustScale(size: labelFontSize),
    );

    for (var i = 0; i < points.length; i++) {
      textPainter.text = TextSpan(text: labels[i], style: textStyle);
      textPainter.layout();

      final labelOffset = _computeLabelOffset(center, points[i], textPainter);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          labelOffset.dx - 6,
          labelOffset.dy - 4,
          textPainter.width + 12,
          textPainter.height + 8,
        ),
        const Radius.circular(6),
      );

// Create background gradient paint
      final bgPaint = Paint()
        ..shader = LinearGradient(
          colors: labelBg,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect.outerRect);

// Draw background with gradient
      canvas.drawRRect(rect, bgPaint);

// Border (1px border)
      final borderPaint = Paint()
        ..color = labelBg[1] // border color
        ..style = PaintingStyle.stroke // Set paint style to stroke for border
        ..strokeWidth = 1; // Set border width

// Draw the border around the rect
      canvas.drawRRect(rect, borderPaint);

// Draw text on top
      textPainter.paint(canvas, labelOffset);

      // Animated tooltip
       if (_shouldShowTooltip(i) && tooltipData != null) {
      _drawAnimatedTooltip(
        canvas,
        rect.outerRect.topCenter,
        '${tooltipData![i].toInt()}',  // ✅ Convert double to int for display
        gradientColors,
        i == hoveredLabelIndex ? animationValue : 1.0,
      );
    }
    }
  }

  void _drawAnimatedTooltip(Canvas canvas, Offset baseCenter, String text,
      List<Color> gradientColors, double scale) {
    const tooltipWidth = 42.0;
    const tooltipHeight = 30.0;
    const notchHeight = 8.0;

    // Apply animation scale
    final animatedTooltipHeight = tooltipHeight * scale;
    final animatedNotchHeight = notchHeight * scale;

    final tooltipRect = Rect.fromCenter(
      center: Offset(baseCenter.dx,
          baseCenter.dy - animatedTooltipHeight / 2 - animatedNotchHeight),
      width: tooltipWidth,
      height: animatedTooltipHeight,
    );

    // Create a single path that includes the notch
    final tooltipPath = Path()
      // Start from bottom-left of notch
      ..moveTo(baseCenter.dx - 6, tooltipRect.bottom)
      // Draw up to start of rounded rectangle
      ..lineTo(tooltipRect.left + 6, tooltipRect.bottom)
      // Draw rounded rectangle (bottom-left rounded corner)
      ..arcToPoint(
        Offset(tooltipRect.left, tooltipRect.bottom - 6),
        radius: const Radius.circular(6),
      )
      // Left side
      ..lineTo(tooltipRect.left, tooltipRect.top + 6)
      // Top-left rounded corner
      ..arcToPoint(
        Offset(tooltipRect.left + 6, tooltipRect.top),
        radius: const Radius.circular(6),
      )
      // Top side
      ..lineTo(tooltipRect.right - 6, tooltipRect.top)
      // Top-right rounded corner
      ..arcToPoint(
        Offset(tooltipRect.right, tooltipRect.top + 6),
        radius: const Radius.circular(6),
      )
      // Right side
      ..lineTo(tooltipRect.right, tooltipRect.bottom - 6)
      // Bottom-right rounded corner
      ..arcToPoint(
        Offset(tooltipRect.right - 6, tooltipRect.bottom),
        radius: const Radius.circular(6),
      )
      // Draw down to notch
      ..lineTo(baseCenter.dx + 6, tooltipRect.bottom)
      // Complete the notch
      ..lineTo(baseCenter.dx, tooltipRect.bottom + animatedNotchHeight)
      ..close();

    // Rest of the drawing code remains the same...
    // 🌑 Draw drop shadow with animation
    canvas.drawShadow(
      tooltipPath,
      Colors.black.withOpacity(0.25 * scale),
      8.0 * scale,
      false,
    );

    // 🌈 Gradient background fill
    final gradient = LinearGradient(
      colors: [gradientColors[0], gradientColors[1]],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(tooltipRect);

    final tooltipPaint = Paint()..shader = gradient;
    canvas.drawPath(tooltipPath, tooltipPaint);

    // WHITE BORDER AROUND TOOLTIP
    // final borderPaint = Paint()
    //   ..color = Colors.white.withOpacity(scale)
    //   ..style: PaintingStyle.stroke
    //   ..strokeWidth = 1.5;

    // WHITE BORDER AROUND TOOLTIP
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(scale)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(tooltipPath, borderPaint);

    // 📝 Tooltip text with fade-in effect
  // 📝 Tooltip text with fade-in effect - display as integer
final textPainter = TextPainter(
  text: TextSpan(
      text: text,  // text is already formatted as integer in _paintLabels
      style: TextStyle(
        color: Colors.white.withOpacity(scale),
        fontSize: FlutterFlowTheme.adjustScale(size: 16),
        fontWeight: FontWeight.bold,
      ),
      children: [
        TextSpan(
            text: '%',
            style: TextStyle(fontSize: FlutterFlowTheme.adjustScale(size: 12)))
      ]),
  textAlign: TextAlign.center,
  textDirection: TextDirection.ltr,
);

    textPainter.layout(maxWidth: tooltipWidth - 8);
    textPainter.paint(
      canvas,
      Offset(
        tooltipRect.left + (tooltipWidth - textPainter.width) / 2,
        tooltipRect.top + (animatedTooltipHeight - textPainter.height) / 2,
      ),
    );
  }

  Offset _computeLabelOffset(
      Offset center, Offset point, TextPainter textPainter) {
    if (point.dx < center.dx && point.dy > center.dy) {
      return point.translate(-(textPainter.width - 8.0), 6);
    } else if (point.dx > center.dx && point.dy > center.dy) {
      return point.translate(-8.0, 6);
    } else if (point.dx < center.dx && point.dy < center.dy) {
      return point.translate(-(textPainter.width + 4), -4);
    } else if (point.dx > center.dx && point.dy < center.dy) {
      return point.translate(4, -4);
    } else {
      return point.translate(-(textPainter.width / 2), -20);
    }
  }

  Path _createRoundedPolygon(List<Offset> points, double radius) {
    final path = Path();
    if (points.isEmpty) return path;

    for (int i = 0; i < points.length; i++) {
      final current = points[i];
      final next = points[(i + 1) % points.length];
      final previous = points[(i - 1 + points.length) % points.length];

      final offsetIn = (current - previous).scale(
          radius / (current - previous).distance,
          radius / (current - previous).distance);
      final offsetOut = (next - current).scale(
          radius / (next - current).distance,
          radius / (next - current).distance);

      final entry = current - offsetIn;
      final exit = current + offsetOut;

      if (i == 0) {
        path.moveTo(entry.dx, entry.dy);
      } else {
        path.lineTo(entry.dx, entry.dy);
      }
      path.quadraticBezierTo(current.dx, current.dy, exit.dx, exit.dy);
    }

    path.close();
    return path;
  }

  void _paintPentagonBadge(Canvas canvas, Offset center) {
    final halfRadius = center.dy * 0.5;
    final pentagonPoints = _calculatePentagonPoints(center, halfRadius);

    final path = _createRoundedPolygonPath(pentagonPoints, 8);

    final pentagonPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.transparent, Colors.transparent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: halfRadius))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, pentagonPaint);

    final strokePaint = Paint()
      ..color = const Color(0xff98F4BD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, strokePaint);

    final topLeft = pentagonPoints[0];
    const labelWidth = 28.0;
    const labelHeight = 16.0;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        topLeft.dx - labelWidth / 2,
        topLeft.dy - labelHeight / 2 - 6,
        labelWidth,
        labelHeight,
      ),
      const Radius.circular(4),
    );

    final labelPaint = Paint()..color = Color(0xff98F4BD);

    canvas.drawCircle(
        topLeft.translate(-8, 15),
        13.0,
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0);

    canvas.save();
    canvas.translate(rect.center.dx - 12, rect.center.dy + 7);
    canvas.rotate(-pi / 5);
    canvas.translate(-rect.center.dx - 12, -rect.center.dy + 7);
    canvas.drawRRect(rect, labelPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '100',
        style: TextStyle(
          color: Colors.white,
          fontSize: FlutterFlowTheme.adjustScale(size: 10),
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final textOffset = Offset(
      rect.center.dx - textPainter.width / 2,
      rect.center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
    canvas.restore();
  }

  Path _createRoundedPolygonPath(List<Offset> points, double radius) {
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final prev = points[(i - 1 + points.length) % points.length];
      final current = points[i];
      final next = points[(i + 1) % points.length];

      final prevVec = (current - prev);
      final nextVec = (next - current);

      final prevNorm = prevVec / prevVec.distance;
      final nextNorm = nextVec / nextVec.distance;

      final offsetStart = current - prevNorm * radius;
      final offsetEnd = current + nextNorm * radius;

      if (i == 0) {
        path.moveTo(offsetStart.dx, offsetStart.dy);
      } else {
        path.lineTo(offsetStart.dx, offsetStart.dy);
      }
      path.quadraticBezierTo(
          current.dx, current.dy, offsetEnd.dx, offsetEnd.dy);
    }
    path.close();
    return path;
  }

  void _paintMiddleCircle(Canvas canvas, Offset center) {
    final topPoint = _calculatePentagonPoints(center, 0)[0];
    _drawLabelCircle(canvas, topPoint.translate(0, 0), "10%");
  }

  void _drawLabelCircle(Canvas canvas, Offset center, String text) {
    final double circleRadius = center.dy * 0.1 < 12 ? 12 : center.dy * 0.1;
    final Paint circlePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, circleRadius, circlePaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: FlutterFlowTheme.adjustScale(size: 10),
          fontWeight: FontWeight.w600,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: circleRadius * 2,
    );

    final Offset textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant SpiderChartPainter oldDelegate) {
    return oldDelegate.data1 != data1 ||
        oldDelegate.data2 != data2 ||
        oldDelegate.hoveredLabelIndex != hoveredLabelIndex ||
        oldDelegate.animationValue != animationValue;
  }
}
