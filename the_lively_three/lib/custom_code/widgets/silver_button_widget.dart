import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';

class SilverButton extends StatefulWidget {
  final double paddingHorizontal;
  final double paddingVertical;
  final double marginBottom;
  final double borderRadius;
  final bool hasIcon;
  final bool bgTransparent;
  final bool circularShape;
  final Widget iconWidget;
  final String buttonTitle;
  final String iconPlacement;
  final VoidCallback buttonFunction;
  const SilverButton({
    Key? key,
    this.paddingHorizontal = 12.0,
    this.paddingVertical = 8.0,
    this.borderRadius = 8.0,
    this.marginBottom = 0,
    this.hasIcon = false,
    this.bgTransparent = false,
    this.circularShape = false,
    this.iconWidget = const Icon(Icons.chevron_left),
    this.buttonTitle = '',
    this.iconPlacement = 'left',
    required this.buttonFunction,
  }) : super(key: key);

  @override
  State<SilverButton> createState() => _SilverButtonState();
}

class _SilverButtonState extends State<SilverButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.buttonFunction,
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: widget.paddingVertical,
                horizontal: widget.paddingHorizontal),
            margin: EdgeInsets.only(bottom: widget.marginBottom),
            decoration: widget.circularShape
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 1,
                        color: Color(0xffC7c7c7),
                        style: BorderStyle.solid),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 1.0,
                        color: Color.fromRGBO(199, 199, 199, 1),
                        offset: Offset(
                          0.0,
                          0.0,
                        ),
                      )
                    ],
                    gradient: const LinearGradient(
                      colors: [Color(0xffffffff), Color(0xffe0e0e0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ))
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                        width: widget.bgTransparent ? 0 : 1,
                        color: widget.bgTransparent
                            ? Colors.transparent
                            : Color(0xffC6c6c6),
                        style: BorderStyle.solid),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1.0,
                        color: widget.bgTransparent
                            ? Colors.transparent
                            : Color.fromRGBO(199, 199, 199, 1),
                        offset: Offset(
                          0.0,
                          0.0,
                        ),
                      )
                    ],
                    gradient: LinearGradient(
                      colors: widget.bgTransparent
                          ? [Colors.transparent, Colors.transparent]
                          : [Color(0xffffffff), Color(0xffe0e0e0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )),
            child: Row(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.hasIcon && widget.iconPlacement == 'left')
                  widget.iconWidget,
                if (widget.buttonTitle != '')
                  Text(
                    widget.buttonTitle,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.montserrat(
                          fontWeight: widget.bgTransparent
                              ? FontWeight.w400
                              : FontWeight.w700,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: const Color(0xff6b6b6b),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        fontSize: FlutterFlowTheme.adjustScale(size: 12),
                        lineHeight: 1.2),
                  ),
                if (widget.hasIcon && widget.iconPlacement == 'right')
                  widget.iconWidget,
              ],
            )));
  }
}
