import 'package:flutter/material.dart';
import '../../../core/themes/glow_theme.dart';

/// Flip clock style digit display (simplified version - Phase 1)
class FlipClockDigit extends StatelessWidget {
  final String digit;
  final double size;
  final NeonTheme theme;

  const FlipClockDigit({
    super.key,
    required this.digit,
    required this.size,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 0.85,  // Increased width to accommodate larger font
      height: size * 1.1,  // Increased height for better spacing
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
                fontSize: size * 1.0,  // Match standard font size
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1.0,
                fontFamily: 'Orbitron',
              ),
            ),
          ),

          // Middle divider line
          Positioned(
            top: size * 0.5 - 1,
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
            top: size * 0.5 - 3,
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
            top: size * 0.5 - 3,
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
