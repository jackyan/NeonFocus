import 'package:flutter/material.dart';
import '../../../../core/constants/animation_constants.dart';
import 'glow_digit.dart';

/// Animated glow digit with transition effects
class AnimatedGlowDigit extends StatefulWidget {
  final int value;
  final Color glowColor;
  final double size;

  const AnimatedGlowDigit({
    Key? key,
    required this.value,
    required this.glowColor,
    this.size = 120,
  }) : super(key: key);

  @override
  State<AnimatedGlowDigit> createState() => _AnimatedGlowDigitState();
}

class _AnimatedGlowDigitState extends State<AnimatedGlowDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  int _previousValue = 0;
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _previousValue = widget.value;

    _controller = AnimationController(
      vsync: this,
      duration: AnimationConstants.digitTransition,
    );

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 60,
      ),
    ]).animate(_controller);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.8),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_controller);

    _slideAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(0, -0.5)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 0.5), end: Offset.zero),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(AnimatedGlowDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _currentValue = widget.value;
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
        final progress = _controller.value;
        final displayValue = progress < 0.4 ? _previousValue : _currentValue;

        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value.dy * widget.size * 0.3),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: GlowDigit(
                digit: displayValue.toString(),
                glowColor: widget.glowColor,
                size: widget.size,
              ),
            ),
          ),
        );
      },
    );
  }
}
