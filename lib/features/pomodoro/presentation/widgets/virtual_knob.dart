import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// Virtual knob widget for adjusting timer duration
class VirtualKnob extends StatefulWidget {
  final double initialValue;
  final double minValue;
  final double maxValue;
  final double step;
  final ValueChanged<double> onChanged;
  final Color knobColor;
  final double size;

  const VirtualKnob({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    this.minValue = 15,
    this.maxValue = 60,
    this.step = 5,
    this.knobColor = const Color(0xFF00D9FF),
    this.size = 120,
  }) : super(key: key);

  @override
  State<VirtualKnob> createState() => _VirtualKnobState();
}

class _VirtualKnobState extends State<VirtualKnob> {
  late double _currentValue;
  late double _angle;
  Offset? _startPosition;
  double _lastAngle = 0;

  static const double _minAngle = -math.pi * 0.75; // -135 degrees
  static const double _maxAngle = math.pi * 0.75; // 135 degrees
  static const double _totalAngle = _maxAngle - _minAngle;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _angle = _valueToAngle(_currentValue);
  }

  double _valueToAngle(double value) {
    final normalized =
        (value - widget.minValue) / (widget.maxValue - widget.minValue);
    return _minAngle + (normalized * _totalAngle);
  }

  double _angleToValue(double angle) {
    final normalized = (angle - _minAngle) / _totalAngle;
    final value =
        widget.minValue + (normalized * (widget.maxValue - widget.minValue));
    return value.clamp(widget.minValue, widget.maxValue);
  }

  double _snapToStep(double value) {
    return (value / widget.step).round() * widget.step;
  }

  void _onPanStart(DragStartDetails details) {
    _startPosition = details.localPosition;
    _lastAngle = _angle;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_startPosition == null) return;

    final center = Offset(widget.size / 2, widget.size / 2);
    final position = details.localPosition - center;
    final newAngle = math.atan2(position.dy, position.dx) + math.pi / 2;

    double deltaAngle = newAngle - _lastAngle;

    if (deltaAngle > math.pi) {
      deltaAngle -= 2 * math.pi;
    } else if (deltaAngle < -math.pi) {
      deltaAngle += 2 * math.pi;
    }

    _lastAngle = newAngle;

    setState(() {
      _angle = (_angle + deltaAngle).clamp(_minAngle, _maxAngle);
      final newValue = _snapToStep(_angleToValue(_angle));

      if (newValue != _currentValue) {
        _currentValue = newValue;
        widget.onChanged(_currentValue);
        HapticFeedback.selectionClick();
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _startPosition = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background ring
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _KnobBackgroundPainter(
                color: widget.knobColor.withOpacity(0.2),
              ),
            ),

            // Progress ring
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _KnobProgressPainter(
                progress: (_angle - _minAngle) / _totalAngle,
                color: widget.knobColor,
              ),
            ),

            // Knob indicator
            Transform.rotate(
              angle: _angle,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _KnobIndicatorPainter(color: widget.knobColor),
              ),
            ),

            // Center value display
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentValue.toInt().toString(),
                  style: TextStyle(
                    fontSize: widget.size * 0.35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Orbitron',
                  ),
                ),
                Text(
                  'MIN',
                  style: TextStyle(
                    fontSize: widget.size * 0.12,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Knob background painter
class _KnobBackgroundPainter extends CustomPainter {
  final Color color;

  _KnobBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);

    // Draw tick marks
    final tickPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = -math.pi * 0.75 + (i / 11) * math.pi * 1.5;
      final startRadius = radius - 5;
      final endRadius = radius + 5;

      final start = Offset(
        center.dx + startRadius * math.cos(angle - math.pi / 2),
        center.dy + startRadius * math.sin(angle - math.pi / 2),
      );

      final end = Offset(
        center.dx + endRadius * math.cos(angle - math.pi / 2),
        center.dy + endRadius * math.sin(angle - math.pi / 2),
      );

      canvas.drawLine(start, end, tickPaint);
    }
  }

  @override
  bool shouldRepaint(_KnobBackgroundPainter oldDelegate) => false;
}

/// Knob progress painter
class _KnobProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _KnobProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(0.3),
          color,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final sweepAngle = math.pi * 1.5 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 1.25,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_KnobProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Knob indicator painter
class _KnobIndicatorPainter extends CustomPainter {
  final Color color;

  _KnobIndicatorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final indicatorPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final indicatorPos = Offset(
      center.dx,
      center.dy - radius + 5,
    );

    canvas.drawCircle(indicatorPos, 6, indicatorPaint);

    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(indicatorPos, 10, glowPaint);
  }

  @override
  bool shouldRepaint(_KnobIndicatorPainter oldDelegate) => false;
}
