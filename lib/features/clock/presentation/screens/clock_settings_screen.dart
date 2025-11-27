import 'package:flutter/material.dart';
import '../../../../core/themes/glow_theme.dart';

/// Clock settings bottom sheet (covers half screen)
class ClockSettingsScreen extends StatelessWidget {
  final NeonTheme currentTheme;
  final bool showDate;
  final bool showWeekday;
  final bool showBattery;
  final Function(bool) onDateToggle;
  final Function(bool) onWeekdayToggle;
  final Function(bool) onBatteryToggle;
  final Function(NeonTheme) onThemeChanged;

  const ClockSettingsScreen({
    Key? key,
    required this.currentTheme,
    required this.showDate,
    required this.showWeekday,
    required this.showBattery,
    required this.onDateToggle,
    required this.onWeekdayToggle,
    required this.onBatteryToggle,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.5, // Half screen
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E27),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: currentTheme.glowColor.withOpacity(0.3),
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
                    'CLOCK SETTINGS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: currentTheme.glowColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Clock Section
                  _buildSectionTitle('CLOCK', currentTheme),
                  const SizedBox(height: 15),
                  _buildToggleItem(
                    'Show Date',
                    showDate,
                    onDateToggle,
                    currentTheme,
                  ),
                  _buildToggleItem(
                    'Show Weekday',
                    showWeekday,
                    onWeekdayToggle,
                    currentTheme,
                  ),
                  _buildToggleItem(
                    'Show Battery',
                    showBattery,
                    onBatteryToggle,
                    currentTheme,
                  ),

                  const SizedBox(height: 30),

                  // Theme Section
                  _buildSectionTitle('THEME', currentTheme),
                  const SizedBox(height: 15),
                  _buildThemeSelector(currentTheme),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.primaryColor,
            activeTrackColor: theme.primaryColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(NeonTheme currentTheme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: NeonTheme.allThemes.map((theme) {
        final isSelected = theme.id == currentTheme.id;
        return GestureDetector(
          onTap: () => onThemeChanged(theme),
          child: Container(
            width: 60,
            height: 60,
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
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: theme.glowColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.glowColor.withOpacity(0.7),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
