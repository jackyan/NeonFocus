import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../../core/themes/glow_theme.dart';

/// Animated seven segment digit with segment transition animation (Phase 2)
class AnimatedSevenSegmentDigit extends StatefulWidget {
  final int digit;
  final double size;
  final NeonTheme theme;

  const AnimatedSevenSegmentDigit({
    super.key,
    required this.digit,
    required this.size,
    required this.theme,
  });

  @override
  State<AnimatedSevenSegmentDigit> createState() =>
      _AnimatedSevenSegmentDigitState();
}

class _AnimatedSevenSegmentDigitState
    extends State<AnimatedSevenSegmentDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Map<String, Animation<double>> _segmentAnimations;
  int? _previousDigit;
  int _currentDigit = 0;

  // Segment activation map for digits 0-9
  static const Map<int, Set<String>> segmentMap = {
    0: {'a', 'b', 'c', 'd', 'e', 'f'},
    1: {'b', 'c'},
    2: {'a', 'b', 'd', 'e', 'g'},
    3: {'a', 'b', 'c', 'd', 'g'},
    4: {'b', 'c', 'f', 'g'},
    5: {'a', 'c', 'd', 'f', 'g'},
    6: {'a', 'c', 'd', 'e', 'f', 'g'},
    7: {'a', 'b', 'c'},
    8: {'a', 'b', 'c', 'd', 'e', 'f', 'g'},
    9: {'a', 'b', 'c', 'd', 'f', 'g'},
  };

  @override
  void initState() {
    super.initState();
    _currentDigit = widget.digit;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _segmentAnimations = {};
    const segments = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];

    for (String segment in segments) {
      _segmentAnimations[segment] = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          segments.indexOf(segment) * 0.05,
          (segments.indexOf(segment) * 0.05) + 0.4,
          curve: Curves.easeInOut,
        ),
      ));
    }
  }

  @override
  void didUpdateWidget(AnimatedSevenSegmentDigit oldWidget) {
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
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size * 0.72, widget.size),
          painter: AnimatedSevenSegmentPainter(
            currentDigit: _currentDigit,
            previousDigit: _previousDigit,
            segmentAnimations: _segmentAnimations,
            activeColor: widget.theme.primaryColor,
            inactiveColor: widget.theme.primaryColor.withOpacity(0.15),
            glowColor: widget.theme.glowColor,
            showGlow: widget.theme.glowIntensity != GlowIntensity.low,
            glowIntensity: widget.theme.glowIntensity,
          ),
        );
      },
    );
  }
}

class AnimatedSevenSegmentPainter extends CustomPainter {
  final int currentDigit;
  final int? previousDigit;
  final Map<String, Animation<double>> segmentAnimations;
  final Color activeColor;
  final Color inactiveColor;
  final Color glowColor;
  final bool showGlow;
  final GlowIntensity glowIntensity;

  AnimatedSevenSegmentPainter({
    required this.currentDigit,
    required this.previousDigit,
    required this.segmentAnimations,
    required this.activeColor,
    required this.inactiveColor,
    required this.glowColor,
    required this.showGlow,
    required this.glowIntensity,
  });

  // Segment activation map
  static const Map<int, Set<String>> segmentMap = {
    0: {'a', 'b', 'c', 'd', 'e', 'f'},
    1: {'b', 'c'},
    2: {'a', 'b', 'd', 'e', 'g'},
    3: {'a', 'b', 'c', 'd', 'g'},
    4: {'b', 'c', 'f', 'g'},
    5: {'a', 'c', 'd', 'f', 'g'},
    6: {'a', 'c', 'd', 'e', 'f', 'g'},
    7: {'a', 'b', 'c'},
    8: {'a', 'b', 'c', 'd', 'e', 'f', 'g'},
    9: {'a', 'b', 'c', 'd', 'f', 'g'},
  };

  @override
  void paint(Canvas canvas, Size size) {
    final currentActiveSegments = segmentMap[currentDigit] ?? {};
    final previousActiveSegments = segmentMap[previousDigit ?? currentDigit] ?? {};
    final segmentWidth = size.width * 0.12;
    final segmentLength = size.width * 0.65;

    // Create segment paths
    final segments = _createSegmentPaths(size, segmentWidth, segmentLength);

    // Draw all segments with animation
    segments.forEach((segmentId, path) {
      final wasActive = previousActiveSegments.contains(segmentId);
      final isActive = currentActiveSegments.contains(segmentId);
      final animationValue = segmentAnimations[segmentId]?.value ?? 1.0;

      // Calculate opacity based on transition
      double opacity;
      if (wasActive && isActive) {
        // Stay active
        opacity = 1.0;
      } else if (!wasActive && isActive) {
        // Fade in
        opacity = animationValue;
      } else if (wasActive && !isActive) {
        // Fade out
        opacity = 1.0 - animationValue;
      } else {
        // Stay inactive
        opacity = 0.15;
      }

      final segmentColor = isActive || wasActive
          ? activeColor.withOpacity(opacity)
          : inactiveColor;

      // Draw glow effect (only for active/transitioning segments)
      if ((isActive || wasActive) && showGlow && opacity > 0.3) {
        final glowRadius = glowIntensity.config.blurRadius;
        final glowOpacity = glowIntensity.config.opacity * opacity;

        // Multiple glow layers for stronger effect
        for (int i = 0; i < glowIntensity.config.layerCount; i++) {
          final glowPaint = Paint()
            ..color = glowColor.withOpacity(glowOpacity * (1 - i * 0.2))
            ..style = PaintingStyle.stroke
            ..strokeWidth = segmentWidth * 0.8
            ..maskFilter = ui.MaskFilter.blur(
              ui.BlurStyle.normal,
              glowRadius * (1 + i * 0.5),
            );
          canvas.drawPath(path, glowPaint);
        }
      }

      // Draw segment
      final paint = Paint()
        ..color = segmentColor
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);
    });
  }

  Map<String, Path> _createSegmentPaths(
      Size size, double width, double length) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final halfLength = length / 2;
    final padding = width * 1.2;
    final verticalSegmentLength = (size.height - padding * 2 - width) / 2;

    return {
      // a: top horizontal segment
      'a': _createHorizontalSegment(centerX, padding, width, length),
      // b: top right vertical segment
      'b': _createVerticalSegment(
          centerX + halfLength,
          padding + width / 2 + verticalSegmentLength / 2,
          width,
          verticalSegmentLength),
      // c: bottom right vertical segment
      'c': _createVerticalSegment(
          centerX + halfLength,
          size.height - padding - width / 2 - verticalSegmentLength / 2,
          width,
          verticalSegmentLength),
      // d: bottom horizontal segment
      'd': _createHorizontalSegment(
          centerX, size.height - padding, width, length),
      // e: bottom left vertical segment
      'e': _createVerticalSegment(
          centerX - halfLength,
          size.height - padding - width / 2 - verticalSegmentLength / 2,
          width,
          verticalSegmentLength),
      // f: top left vertical segment
      'f': _createVerticalSegment(
          centerX - halfLength,
          padding + width / 2 + verticalSegmentLength / 2,
          width,
          verticalSegmentLength),
      // g: middle horizontal segment
      'g': _createHorizontalSegment(centerX, centerY, width, length),
    };
  }

  Path _createHorizontalSegment(
      double centerX, double centerY, double width, double length) {
    final path = Path();
    final halfWidth = width / 2;
    final halfLength = length / 2;

    path.moveTo(centerX - halfLength + halfWidth, centerY - halfWidth);
    path.lineTo(centerX + halfLength - halfWidth, centerY - halfWidth);
    path.lineTo(centerX + halfLength, centerY);
    path.lineTo(centerX + halfLength - halfWidth, centerY + halfWidth);
    path.lineTo(centerX - halfLength + halfWidth, centerY + halfWidth);
    path.lineTo(centerX - halfLength, centerY);
    path.close();

    return path;
  }

  Path _createVerticalSegment(
      double centerX, double centerY, double width, double length) {
    final path = Path();
    final halfWidth = width / 2;
    final halfLength = length / 2;

    path.moveTo(centerX - halfWidth, centerY - halfLength + halfWidth);
    path.lineTo(centerX, centerY - halfLength);
    path.lineTo(centerX + halfWidth, centerY - halfLength + halfWidth);
    path.lineTo(centerX + halfWidth, centerY + halfLength - halfWidth);
    path.lineTo(centerX, centerY + halfLength);
    path.lineTo(centerX - halfWidth, centerY + halfLength - halfWidth);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
