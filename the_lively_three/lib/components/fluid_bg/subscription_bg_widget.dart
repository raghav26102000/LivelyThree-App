import 'dart:ui';
import 'package:flutter/material.dart';

class SubscriptionGradientBackground extends StatefulWidget {
  const SubscriptionGradientBackground({Key? key}) : super(key: key);

  @override
  State<SubscriptionGradientBackground> createState() =>
      _SubscriptionGradientBackgroundState();
}

class _SubscriptionGradientBackgroundState
    extends State<SubscriptionGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          // Middle scoop - Red/Orange
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final scale = -MediaQuery.sizeOf(context).width * 1.3 +
                  (_animation.value * 75); // 0-2% scale change
              return Positioned(
                left: -MediaQuery.sizeOf(context).width * 0.2,
                top: -26,
                child: Transform.scale(
                  scale: 1.0,
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.55,
                    width: MediaQuery.sizeOf(context).width * 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFe63949).withOpacity(0.2),
                          Color(0xFFe63949).withOpacity(0.2),
                          Color(0xFFe63949).withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Top scoop (smallest) - Green
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final scale =
                  1.05 + (_animation.value * 0.2); // 0-3% scale change
              return Positioned(
                left: MediaQuery.sizeOf(context).width * 0.35,
                right: -MediaQuery.sizeOf(context).width * 0.22,
                top: -MediaQuery.sizeOf(context).height * 0.2,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFc40cd3).withOpacity(0.11),
                          Color(0xFFc40cd3).withOpacity(0.11),
                          Color(0xFFc40cd3).withOpacity(0.11),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Bottom scoop (largest) - Purple/Magenta
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final scale = -MediaQuery.sizeOf(context).width * 0.3 +
                  (_animation.value * 50); // 0-1.5% scale change
              return Positioned(
                left: -MediaQuery.sizeOf(context).width * 0.4,
                bottom: -MediaQuery.sizeOf(context).height * 0.3,
                child: Transform.scale(
                  scale: 1.0,
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFf77f00).withOpacity(0.2),
                          Color(0xFFf77f00).withOpacity(0.2),
                          Color(0xFFf77f00).withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Blur effect overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
            child: Container(
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ],
      ),
    );
  }
}
