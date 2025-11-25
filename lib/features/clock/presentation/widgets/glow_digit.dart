import 'package:flutter/material.dart';
import '../../../../core/themes/glow_theme.dart';

/// Glow digit widget - Multi-layer blur effect for neon glow
class GlowDigit extends StatelessWidget {
  final String digit;
  final Color glowColor;
  final GlowIntensity intensity;
  final double size;

  const GlowDigit({
    Key? key,
    required this.digit,
    required this.glowColor,
    this.intensity = GlowIntensity.medium,
    this.size = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = intensity.config;

    return SizedBox(
      width: size,
      height: size * 1.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow layer (largest blur)
          if (config.layerCount >= 3)
            _buildGlowLayer(
              blur: config.blurRadius,
              opacity: config.opacity * 0.3,
            ),

          // Middle glow layer
          if (config.layerCount >= 2)
            _buildGlowLayer(
              blur: config.blurRadius * 0.6,
              opacity: config.opacity * 0.5,
            ),

          // Inner glow layer
          _buildGlowLayer(
            blur: config.blurRadius * 0.3,
            opacity: config.opacity * 0.8,
          ),

          // Core digit (sharpest)
          _buildCoreDigit(),
        ],
      ),
    );
  }

  Widget _buildGlowLayer({
    required double blur,
    required double opacity,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(opacity),
            blurRadius: blur,
            spreadRadius: blur * 0.2,
          ),
        ],
      ),
      child: Text(
        digit,
        style: TextStyle(
          fontSize: size,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          color: glowColor,
        ),
      ),
    );
  }

  Widget _buildCoreDigit() {
    return Text(
      digit,
      style: TextStyle(
        fontSize: size,
        fontFamily: 'Orbitron',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: glowColor.withOpacity(0.9),
            blurRadius: 5,
          ),
        ],
      ),
    );
  }
}
