import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/burnin_protection_service.dart';
import 'clock_settings_screen.dart';

/// Minimalist clock screen with vertical/horizontal layout
class ClockScreen extends StatefulWidget {
  final NeonTheme theme;
  final Function(NeonTheme) onThemeChanged;

  const ClockScreen({
    Key? key,
    this.theme = NeonTheme.cyberBlue,
    required this.onThemeChanged,
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

  // Settings
  bool _showDate = false;
  bool _showWeekday = false;
  bool _showBattery = false;

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

  void _showSettings() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClockSettingsScreen(
        currentTheme: widget.theme,
        showDate: _showDate,
        showWeekday: _showWeekday,
        showBattery: _showBattery,
        onDateToggle: (value) => setState(() => _showDate = value),
        onWeekdayToggle: (value) => setState(() => _showWeekday = value),
        onBatteryToggle: (value) => setState(() => _showBattery = value),
        onThemeChanged: widget.onThemeChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    // 2x font sizes
    final hourFontSize = isLandscape ? 120.0 : 160.0;
    final infoFontSize = 14.0; // System default size

    return GestureDetector(
      onTap: _showSettings,
      child: Container(
        color: widget.theme.backgroundColor,
        child: Transform.translate(
          offset: Offset(_offsetX, _offsetY),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Optional date
                if (_showDate) ...[
                  _buildDateDisplay(fontSize: infoFontSize),
                  const SizedBox(height: 20),
                ],

                // Optional weekday
                if (_showWeekday) ...[
                  _buildWeekdayDisplay(fontSize: infoFontSize),
                  const SizedBox(height: 20),
                ],

                // Time display
                isLandscape
                    ? _buildHorizontalTime(hourFontSize)
                    : _buildVerticalTime(hourFontSize),

                // Optional battery
                if (_showBattery) ...[
                  const SizedBox(height: 20),
                  _buildBatteryDisplay(fontSize: infoFontSize),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalTime(double fontSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeDigit(_currentTime.hour.toString().padLeft(2, '0'), fontSize),
        const SizedBox(height: 10),
        _buildTimeDigit(_currentTime.minute.toString().padLeft(2, '0'), fontSize),
        const SizedBox(height: 10),
        _buildTimeDigit(_currentTime.second.toString().padLeft(2, '0'), fontSize),
      ],
    );
  }

  Widget _buildHorizontalTime(double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeDigit(_currentTime.hour.toString().padLeft(2, '0'), fontSize),
        const SizedBox(width: 20),
        _buildTimeDigit(_currentTime.minute.toString().padLeft(2, '0'), fontSize),
        const SizedBox(width: 20),
        _buildTimeDigit(_currentTime.second.toString().padLeft(2, '0'), fontSize),
      ],
    );
  }

  Widget _buildTimeDigit(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'Orbitron',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: widget.theme.glowColor.withOpacity(0.9),
            blurRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildDateDisplay({double fontSize = 14.0}) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[_currentTime.month - 1];
    final day = _currentTime.day;
    final year = _currentTime.year;

    return Text(
      '$month $day, $year',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        color: widget.theme.textColor.withOpacity(0.7),
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildWeekdayDisplay({double fontSize = 14.0}) {
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final weekday = weekdays[_currentTime.weekday - 1];

    return Text(
      weekday,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        color: widget.theme.textColor.withOpacity(0.7),
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildBatteryDisplay({double fontSize = 14.0}) {
    // Placeholder for battery level
    // In real app, use battery_plus package
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.battery_full,
          size: fontSize + 4,
          color: widget.theme.textColor.withOpacity(0.7),
        ),
        const SizedBox(width: 4),
        Text(
          '100%',
          style: TextStyle(
            fontSize: fontSize,
            color: widget.theme.textColor.withOpacity(0.7),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
