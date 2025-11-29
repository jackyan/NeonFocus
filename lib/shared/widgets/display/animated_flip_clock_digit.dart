import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/themes/glow_theme.dart';

/// Animated flip clock digit with 3D flip animation (Phase 2)
class AnimatedFlipClockDigit extends StatefulWidget {
  final String digit;
  final double size;
  final NeonTheme theme;

  const AnimatedFlipClockDigit({
    super.key,
    required this.digit,
    required this.size,
    required this.theme,
  });

  @override
  State<AnimatedFlipClockDigit> createState() =>
      _AnimatedFlipClockDigitState();
}

class _AnimatedFlipClockDigitState extends State<AnimatedFlipClockDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  String? _previousDigit;
  String _currentDigit = '';

  @override
  void initState() {
    super.initState();
    _currentDigit = widget.digit;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedFlipClockDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      setState(() {
        _previousDigit = oldWidget.digit;
        _currentDigit = widget.digit;
      });
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final isFirstHalf = _flipAnimation.value < 0.5;
        final displayDigit = isFirstHalf
            ? (_previousDigit ?? _currentDigit)
            : _currentDigit;
        final rotationAngle = isFirstHalf
            ? _flipAnimation.value * pi
            : (_flipAnimation.value - 1.0) * pi;

        return Transform(
          alignment: isFirstHalf ? Alignment.bottomCenter : Alignment.topCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateX(rotationAngle),
          child: _buildCard(displayDigit),
        );
      },
    );
  }

  Widget _buildCard(String digit) {
    return Container(
      width: widget.size * 0.85,  // Increased width to accommodate larger font
      height: widget.size * 1.1,  // Increased height for better spacing
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Full digit display (centered)
          Center(
            child: Text(
              digit,
              style: TextStyle(
                fontSize: widget.size * 1.0,  // Match standard font size
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1.0,
                fontFamily: 'Orbitron',
              ),
            ),
          ),

          // Middle divider line
          Positioned(
            top: widget.size * 0.5 - 1,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Left fixing hole
          Positioned(
            left: 6,
            top: widget.size * 0.5 - 3,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Right fixing hole
          Positioned(
            right: 6,
            top: widget.size * 0.5 - 3,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
