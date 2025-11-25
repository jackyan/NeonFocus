import 'package:flutter/material.dart';

/// Animation timing constants
class AnimationConstants {
  // Digit transition animation
  static const digitTransition = Duration(milliseconds: 800);
  static const digitCurve = Curves.easeInOutCubic;

  // Glow pulse animation
  static const glowPulse = Duration(milliseconds: 2000);
  static const glowCurve = Curves.easeInOut;

  // Theme transition animation
  static const themeTransition = Duration(milliseconds: 600);
  static const themeCurve = Curves.easeOutCubic;

  // Page transition animation
  static const pageTransition = Duration(milliseconds: 400);
  static const pageCurve = Curves.easeInOutQuart;

  // Button feedback animation
  static const buttonFeedback = Duration(milliseconds: 100);
  static const buttonCurve = Curves.easeOut;
}
