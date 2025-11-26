import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/burnin_protection_service.dart';
import '../widgets/glow_clock.dart';

/// Main clock screen with burn-in protection
class ClockScreen extends StatefulWidget {
  final NeonTheme theme;

  const ClockScreen({
    Key? key,
    this.theme = NeonTheme.cyberBlue,
  }) : super(key: key);

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  final BurninProtectionService _burninProtection = BurninProtectionService();
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  double _offsetX = 0.0;
  double _offsetY = 0.0;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startBurninProtection();
  }

  void _startBurninProtection() {
    _burninProtection.addOffsetListener(_onBurninOffsetChanged);
    _burninProtection.start();
  }

  void _onBurninOffsetChanged(double x, double y) {
    if (mounted) {
      setState(() {
        _offsetX = x;
        _offsetY = y;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _burninProtection.removeOffsetListener(_onBurninOffsetChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.backgroundColor,
      body: SafeArea(
        child: Transform.translate(
          offset: Offset(_offsetX, _offsetY),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Date display
              _buildDateDisplay(),

              const SizedBox(height: 40),

              // Main clock
              GlowClock(
                time: _currentTime,
                glowColor: widget.theme.glowColor,
                show24Hour: true,
                showSeconds: true,
                digitSize: 80,
              ),

              const SizedBox(height: 40),

              // Theme indicator
              _buildThemeIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateDisplay() {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final weekday = weekdays[_currentTime.weekday - 1];
    final month = months[_currentTime.month - 1];
    final day = _currentTime.day;
    final year = _currentTime.year;

    return Text(
      '$weekday, $month $day, $year',
      style: TextStyle(
        fontSize: 18,
        color: widget.theme.textColor.withOpacity(0.8),
        fontWeight: FontWeight.w300,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildThemeIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: widget.theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.theme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        widget.theme.name.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          color: widget.theme.primaryColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
        ),
      ),
    );
  }
}
