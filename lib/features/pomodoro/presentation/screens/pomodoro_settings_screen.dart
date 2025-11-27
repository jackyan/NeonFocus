import 'package:flutter/material.dart';
import '../../../../core/themes/glow_theme.dart';

/// Pomodoro settings bottom sheet (covers half screen) - with state management
class PomodoroSettingsScreen extends StatefulWidget {
  final NeonTheme currentTheme;
  final bool autoStart;
  final bool vibration;
  final Function(bool) onAutoStartToggle;
  final Function(bool) onVibrationToggle;
  final Function(NeonTheme) onThemeChanged;

  const PomodoroSettingsScreen({
    Key? key,
    required this.currentTheme,
    required this.autoStart,
    required this.vibration,
    required this.onAutoStartToggle,
    required this.onVibrationToggle,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<PomodoroSettingsScreen> createState() => _PomodoroSettingsScreenState();
}

class _PomodoroSettingsScreenState extends State<PomodoroSettingsScreen> {
  late bool _autoStart;
  late bool _vibration;
  late NeonTheme _selectedTheme;

  @override
  void initState() {
    super.initState();
    _autoStart = widget.autoStart;
    _vibration = widget.vibration;
    _selectedTheme = widget.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.5, // Half screen
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E27),
        borderRadius: BorderRadius.circular(20), // All corners rounded
        border: Border.all(
          color: widget.currentTheme.glowColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'TIMER SETTINGS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.currentTheme.glowColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Pomodoro Section
                  _buildSectionTitle('POMODORO', widget.currentTheme),
                  const SizedBox(height: 15),
                  _buildToggleItem(
                    'Auto Start',
                    _autoStart,
                    (value) {
                      setState(() => _autoStart = value);
                      widget.onAutoStartToggle(value);
                    },
                    widget.currentTheme,
                  ),
                  _buildToggleItem(
                    'Vibration Alert',
                    _vibration,
                    (value) {
                      setState(() => _vibration = value);
                      widget.onVibrationToggle(value);
                    },
                    widget.currentTheme,
                  ),

                  const SizedBox(height: 30),

                  // Theme Section
                  _buildSectionTitle('THEME', widget.currentTheme),
                  const SizedBox(height: 15),
                  _buildThemeSelector(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, NeonTheme theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: theme.glowColor.withOpacity(0.7),
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildToggleItem(
    String label,
    bool value,
    Function(bool) onChanged,
    NeonTheme theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          // Custom slim switch (elegant: longer and thinner)
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: value
                    ? Colors.green.withOpacity(0.8)
                    : Colors.grey.withOpacity(0.5),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: NeonTheme.allThemes.map((theme) {
        final isSelected = theme.id == _selectedTheme.id;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedTheme = theme);
            widget.onThemeChanged(theme);
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.glowColor
                    : theme.glowColor.withOpacity(0.3),
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.glowColor.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              // Miniature timer preview (landscape mode)
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '25',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Orbitron',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: theme.glowColor.withOpacity(0.9),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '00',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Orbitron',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: theme.glowColor.withOpacity(0.9),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
