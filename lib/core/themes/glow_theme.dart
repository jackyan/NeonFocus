import 'package:flutter/material.dart';

/// Glow effect intensity configuration
class GlowConfig {
  final double blurRadius;
  final double opacity;
  final int layerCount;

  const GlowConfig({
    required this.blurRadius,
    required this.opacity,
    required this.layerCount,
  });
}

/// Glow intensity presets
enum GlowIntensity {
  low(GlowConfig(blurRadius: 15, opacity: 0.4, layerCount: 1)),
  medium(GlowConfig(blurRadius: 25, opacity: 0.6, layerCount: 2)),
  high(GlowConfig(blurRadius: 40, opacity: 0.8, layerCount: 3));

  final GlowConfig config;
  const GlowIntensity(this.config);
}

/// Theme definition for NeonFocus
class NeonTheme {
  final String id;
  final String name;
  final Color backgroundColor;
  final Color primaryColor;
  final Color glowColor;
  final Color accentColor;
  final Color textColor;
  final GlowIntensity glowIntensity;

  const NeonTheme({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.primaryColor,
    required this.glowColor,
    required this.accentColor,
    required this.textColor,
    this.glowIntensity = GlowIntensity.medium,
  });

  /// Cyber Blue Theme
  static const cyberBlue = NeonTheme(
    id: 'cyber_blue',
    name: 'Cyber Blue',
    backgroundColor: Color(0xFF0A0E27),
    primaryColor: Color(0xFF00D9FF),
    glowColor: Color(0xFF00D9FF),
    accentColor: Color(0xFFFF0080),
    textColor: Color(0xFFE0FFFF),
    glowIntensity: GlowIntensity.high,
  );

  /// Neon Purple Theme
  static const neonPurple = NeonTheme(
    id: 'neon_purple',
    name: 'Neon Purple',
    backgroundColor: Color(0xFF1A0033),
    primaryColor: Color(0xFFBB00FF),
    glowColor: Color(0xFFBB00FF),
    accentColor: Color(0xFFFF00AA),
    textColor: Color(0xFFFFE0FF),
    glowIntensity: GlowIntensity.medium,
  );

  /// Minimal Dark Theme
  static const minimalDark = NeonTheme(
    id: 'minimal_dark',
    name: 'Minimal Dark',
    backgroundColor: Color(0xFF000000),
    primaryColor: Color(0xFFFFFFFF),
    glowColor: Color(0xFFFFFFFF),
    accentColor: Color(0xFF888888),
    textColor: Color(0xFFCCCCCC),
    glowIntensity: GlowIntensity.low,
  );

  /// Electric Green Theme
  static const electricGreen = NeonTheme(
    id: 'electric_green',
    name: 'Electric Green',
    backgroundColor: Color(0xFF0A1F0A),
    primaryColor: Color(0xFF00FF41),
    glowColor: Color(0xFF00FF41),
    accentColor: Color(0xFF39FF14),
    textColor: Color(0xFFCCFFCC),
    glowIntensity: GlowIntensity.high,
  );

  /// Sunset Orange Theme
  static const sunsetOrange = NeonTheme(
    id: 'sunset_orange',
    name: 'Sunset Orange',
    backgroundColor: Color(0xFF1A0F00),
    primaryColor: Color(0xFFFF6B35),
    glowColor: Color(0xFFFF6B35),
    accentColor: Color(0xFFFFAA00),
    textColor: Color(0xFFFFE0CC),
    glowIntensity: GlowIntensity.medium,
  );

  /// Ice Blue Theme
  static const iceBlue = NeonTheme(
    id: 'ice_blue',
    name: 'Ice Blue',
    backgroundColor: Color(0xFF0D1821),
    primaryColor: Color(0xFF00F5FF),
    glowColor: Color(0xFF00F5FF),
    accentColor: Color(0xFF00C2FF),
    textColor: Color(0xFFE0FAFF),
    glowIntensity: GlowIntensity.high,
  );

  /// All available themes
  static const List<NeonTheme> allThemes = [
    cyberBlue,
    neonPurple,
    minimalDark,
    electricGreen,
    sunsetOrange,
    iceBlue,
  ];

  /// Get theme by ID
  static NeonTheme? getThemeById(String id) {
    try {
      return allThemes.firstWhere((theme) => theme.id == id);
    } catch (_) {
      return null;
    }
  }
}
