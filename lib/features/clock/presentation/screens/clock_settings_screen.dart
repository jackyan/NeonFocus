import 'package:flutter/material.dart';
import '../../../../core/themes/glow_theme.dart';

/// Clock settings bottom sheet (covers half screen) - with state management
class ClockSettingsScreen extends StatefulWidget {
  final NeonTheme currentTheme;
  final bool showDate;
  final bool showWeekday;
  final bool showBattery;
  final bool secondFlipSound;
  final Function(bool) onDateToggle;
  final Function(bool) onWeekdayToggle;
  final Function(bool) onBatteryToggle;
  final Function(bool) onSecondFlipSoundToggle;
  final Function(NeonTheme) onThemeChanged;

  const ClockSettingsScreen({
    Key? key,
    required this.currentTheme,
    required this.showDate,
    required this.showWeekday,
    required this.showBattery,
    required this.secondFlipSound,
    required this.onDateToggle,
    required this.onWeekdayToggle,
    required this.onBatteryToggle,
    required this.onSecondFlipSoundToggle,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<ClockSettingsScreen> createState() => _ClockSettingsScreenState();
}

class _ClockSettingsScreenState extends State<ClockSettingsScreen> {
  late bool _showDate;
  late bool _showWeekday;
  late bool _showBattery;
  late bool _secondFlipSound;
  late NeonTheme _selectedTheme;

  @override
  void initState() {
    super.initState();
    _showDate = widget.showDate;
    _showWeekday = widget.showWeekday;
    _showBattery = widget.showBattery;
    _secondFlipSound = widget.secondFlipSound;
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
          color: _selectedTheme.glowColor.withOpacity(0.3),
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
                      color: _selectedTheme.glowColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Clock Section
                  _buildSectionTitle('CLOCK', _selectedTheme),
                  const SizedBox(height: 15),
                  _buildToggleItem(
                    'Show Date',
                    _showDate,
                    (value) {
                      setState(() => _showDate = value);
                      widget.onDateToggle(value);
                    },
                    _selectedTheme,
                  ),
                  _buildToggleItem(
                    'Show Weekday',
                    _showWeekday,
                    (value) {
                      setState(() => _showWeekday = value);
                      widget.onWeekdayToggle(value);
                    },
                    _selectedTheme,
                  ),
                  _buildToggleItem(
                    'Show Battery',
                    _showBattery,
                    (value) {
                      setState(() => _showBattery = value);
                      widget.onBatteryToggle(value);
                    },
                    _selectedTheme,
                  ),

                  const SizedBox(height: 30),

                  // Sound Section
                  _buildSectionTitle('SOUND', _selectedTheme),
                  const SizedBox(height: 15),
                  _buildToggleItem(
                    'Second Flip Sound',
                    _secondFlipSound,
                    (value) {
                      setState(() => _secondFlipSound = value);
                      widget.onSecondFlipSoundToggle(value);
                    },
                    _selectedTheme,
                  ),

                  const SizedBox(height: 30),

                  // Theme Section
                  _buildSectionTitle('THEME', _selectedTheme),
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
          // Custom slim switch (elegant: 2/3 thickness)
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: value
                    ? Colors.green.withOpacity(0.8)
                    : Colors.grey.withOpacity(0.5),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 12,
                  height: 12,
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
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: NeonTheme.allThemes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final theme = NeonTheme.allThemes[index];
          final isSelected = theme.id == _selectedTheme.id;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedTheme = theme);
              widget.onThemeChanged(theme);
            },
            child: Container(
              width: 90,
              height: 50,
              decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
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
                // Miniature clock preview (landscape mode: 09:35:26)
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '09',
                      style: TextStyle(
                        fontSize: 14,
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
                    const SizedBox(width: 3),
                    Text(
                      '35',
                      style: TextStyle(
                        fontSize: 14,
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
                    const SizedBox(width: 3),
                    Text(
                      '26',
                      style: TextStyle(
                        fontSize: 14,
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
        },
      ),
    );
  }
}
