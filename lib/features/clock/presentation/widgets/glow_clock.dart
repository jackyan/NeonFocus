import 'package:flutter/material.dart';
import 'animated_glow_digit.dart';

/// Complete glow clock widget
class GlowClock extends StatelessWidget {
  final DateTime time;
  final Color glowColor;
  final bool show24Hour;
  final bool showSeconds;
  final double digitSize;

  const GlowClock({
    Key? key,
    required this.time,
    required this.glowColor,
    this.show24Hour = true,
    this.showSeconds = true,
    this.digitSize = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hour =
        show24Hour ? time.hour : (time.hour % 12 == 0 ? 12 : time.hour % 12);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hour
          _buildTimeUnit(hour),

          _buildSeparator(),

          // Minute
          _buildTimeUnit(time.minute),

          if (showSeconds) ...[
            _buildSeparator(),
            // Second
            _buildTimeUnit(time.second),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeUnit(int value) {
    final tens = value ~/ 10;
    final ones = value % 10;

    return Row(
      children: [
        AnimatedGlowDigit(
          value: tens,
          glowColor: glowColor,
          size: digitSize,
        ),
        SizedBox(width: digitSize * 0.1),
        AnimatedGlowDigit(
          value: ones,
          glowColor: glowColor,
          size: digitSize,
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: digitSize * 0.2),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: digitSize * 0.6,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: glowColor.withOpacity(0.9),
              blurRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
