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

class HorizontalNutrientBar extends StatefulWidget {
  const HorizontalNutrientBar({
    super.key,
    this.width,
    this.height,
    this.userValue = 0.0,
    this.communityValue = 0.0,
    this.recommendedValue = 0.0,
  });

  final double? width;
  final double? height;
  final double userValue;
  final double communityValue;
  final double recommendedValue;

  @override
  State<HorizontalNutrientBar> createState() => _HorizontalNutrientBarState();
}

class _HorizontalNutrientBarState extends State<HorizontalNutrientBar> {
  @override
  Widget build(BuildContext context) {
    final double userValue = widget.userValue.isFinite ? widget.userValue : 0.0;
    final double communityValue =
        widget.communityValue.isFinite ? widget.communityValue : 0.0;
    final double recommendedValue =
        widget.recommendedValue.isFinite ? widget.recommendedValue : 0.0;

    final double outerWidth = widget.width ?? 300.0;
    final double outerHeight = widget.height ?? 90;

    final double innerWidth = outerWidth;
    final double innerHeightUpper = outerHeight;
    final double stackedContainerHeight = innerHeightUpper / 3;
    final double innerStart = outerWidth - innerWidth;
    final double maxPos = innerStart + innerWidth * 0.9;

    final double maxValue = [userValue, communityValue, recommendedValue]
        .reduce((a, b) => a > b ? a : b);

    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutExpo,
      tween: Tween<double>(begin: 0, end: userValue),
      builder: (context, animatedUserValue, child) {
        double userPos = innerStart +
            (animatedUserValue / (maxValue > 0 ? maxValue : 1)) *
                (maxPos - innerStart);
        double communityPos = innerStart +
            (communityValue / (maxValue > 0 ? maxValue : 1)) *
                (maxPos - innerStart);
        double recommendedPos = innerStart +
            (recommendedValue / (maxValue > 0 ? maxValue : 1)) *
                (maxPos - innerStart);

        return Container(
          width: outerWidth,
          height: outerHeight,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 3,
                spreadRadius: 0.5,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Gradient
              Positioned(
                left: innerStart,
                child: Container(
                  width: innerWidth,
                  height: innerHeightUpper,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF8C6), Color(0xFFE3FAF3)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),

              // **Animated Progress Bar**
              Positioned(
                left: innerStart,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOutExpo,
                  width: userPos - innerStart,
                  height: innerHeightUpper,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF1A8), Color(0xFFA6E3FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    border: Border.all(
                      width: 1.0,
                      color: const Color(0xFF4F81B9),
                    ),
                  ),
                ),
              ),

              // **Animated Vertical Markers**
              AnimatedPositioned(
                duration: const Duration(seconds: 1),
                left: communityPos - 2,
                child: _buildMarker(Colors.grey, innerHeightUpper),
              ),
              AnimatedPositioned(
                duration: const Duration(seconds: 1),
                left: recommendedPos - 2,
                child: _buildMarker(Colors.black54, innerHeightUpper),
              ),
              AnimatedPositioned(
                duration: const Duration(seconds: 1),
                left: userPos - 2,
                child: _buildMarker(Colors.lightBlueAccent, innerHeightUpper),
              ),

              // **Animated Labels**
              _buildFullWidthStackedContainer(
                  userPos,
                  innerStart,
                  outerWidth,
                  stackedContainerHeight,
                  Colors.lightBlueAccent,
                  animatedUserValue,
                  0,
                  true),
              _buildFullWidthStackedContainer(
                  communityPos,
                  innerStart,
                  outerWidth,
                  stackedContainerHeight,
                  Colors.grey,
                  communityValue,
                  stackedContainerHeight,
                  false),
              _buildFullWidthStackedContainer(
                  recommendedPos,
                  innerStart,
                  outerWidth,
                  stackedContainerHeight,
                  Colors.black54,
                  recommendedValue,
                  stackedContainerHeight * 2,
                  false),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMarker(Color color, double height) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildFullWidthStackedContainer(
      double position,
      double innerStart,
      double outerWidth,
      double height,
      Color color,
      double value,
      double verticalOffset,
      bool isUser) {
    final double textSize = height * 0.55;
    final double labelWidth = height * 2.7;
    final double spaceBeforeLine = 6.0;

    double adjustedPosition = position - labelWidth - spaceBeforeLine;
    if (adjustedPosition < innerStart) {
      adjustedPosition = innerStart;
    }

    return AnimatedPositioned(
      duration: const Duration(seconds: 1),
      left: adjustedPosition,
      top: verticalOffset,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: labelWidth,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: color,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isUser
                    ? Icons.person
                    : (color == Colors.grey ? Icons.people : Icons.flag),
                color: color,
                size: textSize * 1.2,
              ),
              const SizedBox(width: 2),
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
