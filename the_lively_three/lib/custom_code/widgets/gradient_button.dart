import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final String? iconPath;
  final bool showIcon;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? fontSize;
  final double borderRadius;

  final List<Color>? gradientColors;
  final List<double>? gradientStops;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;

  const GradientButton({
    super.key,
    required this.text,
    this.iconPath,
    this.showIcon = true,
    this.padding,
    this.margin,
    this.fontSize,
    this.borderRadius = 12,
    this.gradientColors,
    this.gradientStops,
    this.gradientBegin,
    this.gradientEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      margin: margin ??
          const EdgeInsets.only(bottom: 20, right: 12, left: 12, top: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          width: 1,
          color: const Color(0xffffffff),
          style: BorderStyle.solid,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 1),
            spreadRadius: 1,
            blurRadius: 0,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.32),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          colors: gradientColors ??
              const [
                Color(0xfff4c400),
                Color(0xfff77f00),
                Color(0xffe63949),
                Color(0xffc40cd3),
              ],
          stops: gradientStops ?? const [0.0, 0.27, 0.61, 1.0],
          begin: gradientBegin ?? Alignment.topLeft,
          end: gradientEnd ?? Alignment.bottomRight,
        ),
      ),
      child: Row(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && iconPath != null)
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              child: Image.asset(
                iconPath!,
                width: 20,
                height: 20,
              ),
            ),
          Text(
            text,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: fontSize != null
                  ? FlutterFlowTheme.adjustScale(size: fontSize!)
                  : FlutterFlowTheme.adjustScale(size: 12),
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
