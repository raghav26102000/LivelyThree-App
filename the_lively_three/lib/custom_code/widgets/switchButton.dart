import 'package:flutter/material.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';

class SwitchButton extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double height;
  final bool showFilterIcon;
  final Color switchOnColor;
  final Color switchOffColor;

  const SwitchButton({
    Key? key,
    required this.value,
    required this.onChanged,
    this.height = 40.0,
    this.showFilterIcon = false,
    this.switchOnColor = const Color(0xffa8e6cf),
    this.switchOffColor = const Color(0xfff28b82),
  }) : super(key: key);

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: widget.height * 1.8,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.height / 2),
          // 🔹 Fix: Show orange when opted-out but in grace period
          color: (widget.switchOnColor == const Color(0xffffa726) &&
                  widget.value == false)
              ? widget.switchOnColor
              : widget.value
                  ? widget.switchOnColor
                  : widget.switchOffColor,
          border: Border.all(
            color: Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: widget.value
                  ? (widget.height * 1.8) - widget.height - 2
                  : 2,
              top: 1,
              bottom: 1,
              child: Container(
                width: widget.height - 2,
                height: widget.height - 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular((widget.height - 2) / 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: widget.showFilterIcon
                    ? Icon(
                        widget.value ? Icons.filter_alt : Icons.filter_alt_off,
                        size: (widget.height - 2) * 0.6,
                        color: widget.value
                            ? FlutterFlowTheme.of(context).textGreen
                            : FlutterFlowTheme.of(context).textGrey,
                      )
                    : const SizedBox(width: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
