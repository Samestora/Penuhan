// lib/widgets/tap_indicator.dart

import 'package:flutter/material.dart';

// A data class to hold information about each tap circle
class _TapCircle {
  final AnimationController controller;
  final Offset position;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;

  _TapCircle({required this.controller, required this.position})
    : scaleAnimation = Tween<double>(
        begin: 0.5,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)),
      fadeAnimation = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
}

class TapCircleIndicator extends StatefulWidget {
  final Widget child;

  const TapCircleIndicator({super.key, required this.child});

  @override
  State<TapCircleIndicator> createState() => _TapCircleIndicatorState();
}

class _TapCircleIndicatorState extends State<TapCircleIndicator>
    with TickerProviderStateMixin {
  final List<_TapCircle> _circles = [];

  void _onTapDown(TapDownDetails details) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    final circle = _TapCircle(
      controller: controller,
      position: details.localPosition,
    );

    // Clean up the controller and remove the circle after the animation completes
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _circles.remove(circle);
          });
        }
        controller.dispose();
      }
    });

    setState(() {
      _circles.add(circle);
    });

    controller.forward();
  }

  @override
  void dispose() {
    // Dispose any remaining controllers when the widget is removed
    for (final circle in _circles) {
      circle.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      child: Stack(
        // Set fit to expand to ensure the Stack fills the GestureDetector
        fit: StackFit.expand,
        children: [
          // Your main screen content goes here
          widget.child,

          // The animated tap circles are drawn here
          ..._circles.map((circle) {
            return Positioned(
              left: circle.position.dx - 24, // Center the circle on the tap
              top: circle.position.dy - 24,
              child: ScaleTransition(
                scale: circle.scaleAnimation,
                child: FadeTransition(
                  opacity: circle.fadeAnimation,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.0),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
