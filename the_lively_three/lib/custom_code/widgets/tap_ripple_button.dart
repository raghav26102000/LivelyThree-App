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

class TapRippleButton extends StatefulWidget {
  const TapRippleButton({
    Key? key,
    // Image info
    required this.imageUrl,
    // Callback to handle increment action
    required this.onIncrement,
    // Animation durations
    this.inDurationMs = 2000,
    this.outDurationMs = 2000,
    // Optional sizing
    this.width,
    this.height,
    // Fade factor: 0..1
    this.fadeFactor = 0.5,
    // Aura color parameter
    this.auraBaseColor = Colors.blueAccent,
  }) : super(key: key);

  /// Path to an asset in your FlutterFlow media library (e.g., "assets/images/my_image.png")
  final String imageUrl;

  /// Callback function to handle the increment action.
  /// It receives an integer value (fixed to 1 per tap).
  final ValueChanged<int> onIncrement;

  /// Duration for the aura to expand (milliseconds)
  final int inDurationMs;

  /// Duration for the aura to fade out (milliseconds)
  final int outDurationMs;

  /// Optional bounding size
  final double? width;
  final double? height;

  /// How much to fade the image at full aura presence (0..1).
  /// e.g., 0.5 => image at 50% opacity at full aura.
  final double fadeFactor;

  /// Base color for the aura, e.g., Colors.redAccent
  final Color auraBaseColor;

  @override
  State<TapRippleButton> createState() => _TapRippleButtonState();
}

class _TapRippleButtonState extends State<TapRippleButton>
    with TickerProviderStateMixin {
  // Animation controllers for the aura
  late AnimationController _rippleInController;
  late AnimationController _rippleOutController;

  // Controller for the “+1” ephemeral text
  late AnimationController _plusOneController;
  late Animation<double> _plusOneOpacity;
  late Animation<Offset> _plusOneOffset;

  @override
  void initState() {
    super.initState();

    // 1) Aura expand
    _rippleInController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.inDurationMs),
    );

    // 2) Aura fade
    _rippleOutController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.outDurationMs),
    );

    // 3) +1 ephemeral text
    _plusOneController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _plusOneOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _plusOneController,
        curve: Curves.easeOut,
      ),
    );
    _plusOneOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.2), // Moves up ~20%
    ).animate(
      CurvedAnimation(
        parent: _plusOneController,
        curve: Curves.easeOut,
      ),
    );

    // Start +1 invisible
    _plusOneController.value = 1.0;
  }

  @override
  void dispose() {
    _rippleInController.dispose();
    _rippleOutController.dispose();
    _plusOneController.dispose();
    super.dispose();
  }

  /// Handle tap gesture: trigger animations and call the increment callback
  void _onTapDown() {
    // Show +1 floating up & fading out
    _plusOneController.forward(from: 0.0);

    // Aura expand => fade
    _rippleInController.forward(from: 0.0).then((_) {
      _rippleOutController.forward(from: 0.0);
    });

    // Trigger the callback with an increment value of 1
    widget.onIncrement(1);
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width ?? 120.0;
    final h = widget.height ?? 120.0;

    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      child: SizedBox(
        width: w,
        height: h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1) The image that dims while aura is present
            _buildFadingImage(w, h),

            // 2) The aura circle
            _buildAuraCircle(w),

            // 3) “+1” ephemeral
            Positioned(
              top: 10,
              child: AnimatedBuilder(
                animation: _plusOneController,
                builder: (_, child) {
                  final offsetY = _plusOneOffset.value.dy * 60;
                  return Transform.translate(
                    offset: Offset(0, offsetY),
                    child: Opacity(
                      opacity: _plusOneOpacity.value,
                      child: child,
                    ),
                  );
                },
                child: const Text(
                  '+1',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Black text
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Fade the image from full opacity down to (1 - fadeFactor) at aura's peak
  Widget _buildFadingImage(double w, double h) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rippleInController, _rippleOutController]),
      builder: (context, child) {
        final expandValue = _rippleInController.value; // 0..1
        final fadeValue = 1.0 - _rippleOutController.value; // 1..0
        final auraPresence = expandValue * fadeValue;

        // fadeFactor=0.5 => image from 1.0 -> 0.5
        final imageOpacity = 1.0 - (widget.fadeFactor * auraPresence);

        return Opacity(
          opacity: imageOpacity,
          child: child,
        );
      },
      child: Image.asset(
        widget.imageUrl,
        width: w,
        height: h,
        fit: BoxFit.cover,
      ),
    );
  }

  /// Expand aura from 0..1, fade from 1..0,
  /// color = auraBaseColor with adjusted opacity
  Widget _buildAuraCircle(double w) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rippleInController, _rippleOutController]),
      builder: (_, __) {
        final scaleValue = _rippleInController.value;
        final alphaValue = 1.0 - _rippleOutController.value;

        if (scaleValue <= 0.0) {
          return const SizedBox.shrink();
        }

        final double maxDiameter = w * 1.5;
        final double diameter = maxDiameter * scaleValue;

        final auraColor = widget.auraBaseColor.withOpacity(0.3 * alphaValue);

        return Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: auraColor,
          ),
        );
      },
    );
  }
}
