import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/burnin_protection_service.dart';
import '../../../../core/services/charging_service.dart';
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
  final ChargingService _chargingService = ChargingService();
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  double _offsetX = 0.0;
  double _offsetY = 0.0;

  // Charging state
  bool _isCharging = false;
  int _batteryLevel = 100;

  // Settings
  bool _showDate = false;
  bool _showWeekday = false;
  bool _showBattery = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startBurninProtection();
    _initializeCharging();
  }

  Future<void> _initializeCharging() async {
    await _chargingService.initialize();

    // Set initial state
    setState(() {
      _isCharging = _chargingService.isCharging;
      _batteryLevel = _chargingService.batteryLevel;
    });

    // Add listeners
    _chargingService.addChargingListener(_onChargingChanged);
    _chargingService.addBatteryLevelListener(_onBatteryLevelChanged);
  }

  void _onChargingChanged(bool isCharging) {
    if (mounted) {
      setState(() {
        _isCharging = isCharging;
      });
    }
  }

  void _onBatteryLevelChanged(int level) {
    if (mounted) {
      setState(() {
        _batteryLevel = level;
      });
    }
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
    _chargingService.removeChargingListener(_onChargingChanged);
    _chargingService.removeBatteryLevelListener(_onBatteryLevelChanged);
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

    // Responsive font sizes based on screen dimensions
    // Landscape: 15% of screen width, Portrait: 38% of screen width
    final hourFontSize = isLandscape
        ? size.width * 0.15
        : size.width * 0.38;
    final infoFontSize = size.width * 0.0245; // ~2.45% of screen width (reduced by 30%)

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
                // Optional info row (date, weekday, battery) - all in one line
                if (_showDate || _showWeekday || _showBattery)
                  _buildInfoRow(fontSize: infoFontSize),

                if (_showDate || _showWeekday || _showBattery)
                  const SizedBox(height: 30),

                // Time display
                isLandscape
                    ? _buildHorizontalTime(hourFontSize)
                    : _buildVerticalTime(hourFontSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({double fontSize = 14.0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_showDate) _buildDateDisplay(fontSize: fontSize),
        if (_showDate && (_showWeekday || _showBattery))
          SizedBox(width: 12),
        if (_showWeekday) _buildWeekdayDisplay(fontSize: fontSize),
        if (_showWeekday && _showBattery)
          SizedBox(width: 12),
        if (_showBattery) _buildBatteryDisplay(fontSize: fontSize),
      ],
    );
  }

  Widget _buildVerticalTime(double fontSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeDigit(_currentTime.hour.toString().padLeft(2, '0'), fontSize),
        SizedBox(height: fontSize * 0.08),
        _buildTimeDigit(_currentTime.minute.toString().padLeft(2, '0'), fontSize),
        SizedBox(height: fontSize * 0.08),
        _buildTimeDigit(_currentTime.second.toString().padLeft(2, '0'), fontSize),
      ],
    );
  }

  Widget _buildHorizontalTime(double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeDigit(_currentTime.hour.toString().padLeft(2, '0'), fontSize),
        SizedBox(width: fontSize * 0.3),
        _buildTimeDigit(_currentTime.minute.toString().padLeft(2, '0'), fontSize),
        SizedBox(width: fontSize * 0.3),
        _buildTimeDigit(_currentTime.second.toString().padLeft(2, '0'), fontSize),
      ],
    );
  }

  Widget _buildTimeDigit(String text, double fontSize) {
    // Split the two-digit text into individual characters
    // Each character gets its own fixed-width container
    // Add consistent spacing between digits for better visual balance
    final chars = text.split('');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: fontSize * 0.72, // Fixed width per single digit
          child: Text(
            chars[0],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Orbitron',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.none,
              fontFeatures: const [FontFeature.tabularFigures()],
              shadows: [
                Shadow(
                  color: widget.theme.glowColor.withOpacity(0.9),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: fontSize * 0.08), // Increased spacing to prevent digit contact (especially "4")
        SizedBox(
          width: fontSize * 0.72, // Fixed width per single digit
          child: Text(
            chars[1],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Orbitron',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.none,
              fontFeatures: const [FontFeature.tabularFigures()],
              shadows: [
                Shadow(
                  color: widget.theme.glowColor.withOpacity(0.9),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ],
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
        decoration: TextDecoration.none, // No underline
      ),
    );
  }

  Widget _buildWeekdayDisplay({double fontSize = 14.0}) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekday = weekdays[_currentTime.weekday - 1];

    return Text(
      weekday,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        color: widget.theme.textColor.withOpacity(0.7),
        fontWeight: FontWeight.w300,
        decoration: TextDecoration.none, // No underline
      ),
    );
  }

  Widget _buildBatteryDisplay({double fontSize = 14.0}) {
    // Determine battery icon based on level
    IconData batteryIcon;
    if (_batteryLevel >= 90) {
      batteryIcon = Icons.battery_full;
    } else if (_batteryLevel >= 70) {
      batteryIcon = Icons.battery_6_bar;
    } else if (_batteryLevel >= 50) {
      batteryIcon = Icons.battery_5_bar;
    } else if (_batteryLevel >= 30) {
      batteryIcon = Icons.battery_3_bar;
    } else if (_batteryLevel >= 15) {
      batteryIcon = Icons.battery_2_bar;
    } else {
      batteryIcon = Icons.battery_1_bar;
    }

    // If charging, use charging icon
    if (_isCharging && _batteryLevel < 100) {
      batteryIcon = Icons.battery_charging_full;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle: 1.5708, // 90 degrees in radians (π/2)
          child: Icon(
            batteryIcon,
            size: fontSize + 6,
            color: _batteryLevel < 20
                ? Colors.red.withOpacity(0.8)
                : widget.theme.textColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$_batteryLevel%',
          style: TextStyle(
            fontSize: fontSize * 0.9,
            color: widget.theme.textColor.withOpacity(0.7),
            fontWeight: FontWeight.w300,
            decoration: TextDecoration.none,
          ),
        ),
        // Show charging info when charging
        if (_isCharging) ...[
          const SizedBox(width: 8),
          Text(
            '⚡ ${_chargingService.getFormattedTimeRemaining()}',
            style: TextStyle(
              fontSize: fontSize * 0.85,
              color: widget.theme.glowColor.withOpacity(0.9),
              fontWeight: FontWeight.w300,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ],
    );
  }
}
