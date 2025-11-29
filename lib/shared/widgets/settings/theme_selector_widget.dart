import 'package:flutter/material.dart';
import '../../../core/themes/glow_theme.dart';

/// Reusable theme selector widget for all settings screens
class ThemeSelectorWidget extends StatelessWidget {
  final NeonTheme currentTheme;
  final Function(NeonTheme) onThemeChanged;

  const ThemeSelectorWidget({
    Key? key,
    required this.currentTheme,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: NeonTheme.allThemes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final theme = NeonTheme.allThemes[index];
          final isSelected = theme.id == currentTheme.id;
          
          return GestureDetector(
            onTap: () => onThemeChanged(theme),
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
                    _buildTimeDigit('09', theme),
                    const SizedBox(width: 3),
                    _buildTimeDigit('35', theme),
                    const SizedBox(width: 3),
                    _buildTimeDigit('26', theme),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeDigit(String text, NeonTheme theme) {
    return Text(
      text,
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
    );
  }
}
