import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../../core/themes/glow_theme.dart';

/// Seven segment display style digit (simplified version - Phase 1)
class SevenSegmentDigit extends StatelessWidget {
  final int digit;
  final double size;
  final NeonTheme theme;

  const SevenSegmentDigit({
    super.key,
    required this.digit,
    required this.size,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * 0.72, size),  // Match standard digit width
      painter: SevenSegmentPainter(
        digit: digit,
        activeColor: theme.primaryColor,
        inactiveColor: theme.primaryColor.withOpacity(0.15),
        glowColor: theme.glowColor,
        showGlow: theme.glowIntensity != GlowIntensity.low,
        glowIntensity: theme.glowIntensity,
      ),
    );
  }
}

class SevenSegmentPainter extends CustomPainter {
  final int digit;
  final Color activeColor;
  final Color inactiveColor;
  final Color glowColor;
  final bool showGlow;
  final GlowIntensity glowIntensity;

  SevenSegmentPainter({
    required this.digit,
    required this.activeColor,
    required this.inactiveColor,
    required this.glowColor,
    required this.showGlow,
    required this.glowIntensity,
  });

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
  void paint(Canvas canvas, Size size) {
    final activeSegments = segmentMap[digit] ?? {};
    final segmentWidth = size.width * 0.12;  // Adjusted for wider canvas
    final segmentLength = size.width * 0.65;  // Adjusted for wider canvas

    // Create segment paths
    final segments = _createSegmentPaths(size, segmentWidth, segmentLength);

    // Draw all segments
    segments.forEach((segmentId, path) {
      final isActive = activeSegments.contains(segmentId);
      
      // Draw glow effect (only for active segments)
      if (isActive && showGlow) {
        final glowRadius = glowIntensity.config.blurRadius;
        final glowOpacity = glowIntensity.config.opacity;
        
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
        ..color = isActive ? activeColor : inactiveColor
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
