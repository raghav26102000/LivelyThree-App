import 'dart:ui';
import 'package:flutter/material.dart';

class FluidGradientBackground extends StatefulWidget {
  const FluidGradientBackground({Key? key}) : super(key: key);

  @override
  State<FluidGradientBackground> createState() =>
      _FluidGradientBackgroundState();
}

class _FluidGradientBackgroundState extends State<FluidGradientBackground>
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
          // Top scoop (smallest) - Green
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final scale =
                  1.05 + (_animation.value * 0.2); // 0-3% scale change
              return Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFF4CAF50),
                          Color(0xFF4CAF50).withOpacity(0.6),
                          Color(0xFF4CAF50).withOpacity(0.4),
                        ],
                        stops: [0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Middle scoop - Red/Orange
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final scale = -MediaQuery.sizeOf(context).width * 1.3 +
                  (_animation.value * 75); // 0-2% scale change
              return Positioned(
                left: 40,
                right: 40,
                bottom: scale,
                child: Transform.scale(
                  scale: 1.0,
                  child: Container(
                    height: MediaQuery.sizeOf(context).width - 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFf2c935),
                          Color(0xFFf2c935).withOpacity(0.6),
                          Color(0xFFf2c935).withOpacity(0.4),
                        ],
                        stops: [0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final scale = MediaQuery.sizeOf(context).width * 0.6 +
                  (_animation.value * 75); // 0-2% scale change
              return Positioned(
                left: 20,
                right: 20,
                bottom: scale,
                child: Transform.scale(
                  scale: 1.0,
                  child: Container(
                    height: MediaQuery.sizeOf(context).width - 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFF77F00),
                          Color(0xFFF77F00).withOpacity(0.6),
                          Color(0xFFF77F00).withOpacity(0.4),
                        ],
                        stops: [0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Middle-bottom scoop - Pink
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final scale = MediaQuery.sizeOf(context).width * 0.3 +
                  (_animation.value * 75); // 0-3.5% scale change
              return Positioned(
                left: 0,
                right: 0,
                bottom: scale,
                child: Transform.scale(
                  scale: 1.0,
                  child: Container(
                    height: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFE63949),
                          Color(0xFFE63949).withOpacity(0.6),
                          Color(0xFFE63949).withOpacity(0.4),
                        ],
                        stops: [0.4, 0.7, 1.0],
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
                left: -25,
                right: -25,
                bottom: scale,
                child: Transform.scale(
                  scale: 1.0,
                  child: Container(
                    height: MediaQuery.sizeOf(context).width + 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFC40CD3),
                          Color(0xFFC40CD3).withOpacity(0.6),
                          Color(0xFFC40CD3).withOpacity(0.4),
                        ],
                        stops: [0.6, 0.8, 1.0],
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
